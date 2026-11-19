# -*- coding: utf-8 -*-
"""
test_base_task.py — أداة فحص واختبار دوال وخصائص BaseTask الشاملة (ميدانياً ومحلياً)
══════════════════════════════════════════════════════════════════════════════════════
تتيح هذه الأداة للمطور اختبار كافة مكونات الكلاس الأساسي (BaseTask):
  1. خصائص الذاكرة الحية السريعة (0-Network Direct Read):
     - المعرف الفريد UID، رقم المملكة، طاقة اللورد، الذهب، الموارد، مستوى القلعة، درع السلام.
  2. محرك الفيالق والمسيرات (March & Queue Engine):
     - حساب السعة القصوى للفيالق (get_max_marches_capacity) بدقة (الأبحاث + VIP + السقف).
     - عدد الفيالق النشطة (get_active_marches_count) والشاغرة (get_available_marches_count).
     - فحص أنواع الموارد التي تجمعها الفيالق حالياً (get_active_gather_resource_types).
     - فحص مسيرات استكشاف الأطلال (is_ruins_march_active / has_active_ruins_march).
     - مزامنة طوابير الفيالق مع السيرفر (sync_local_queues).
  3. التوفير الذكي للموارد وفتح الصناديق (ensure_resources):
     - فحص مستوى فك القفل بحسب مستوى القلعة.
     - استهلاك الصناديق العادية ثم الآمنة تنازلياً وتحديث الذاكرة.
  4. دورة حياة التنفيذ والحماية (can_run / safe_execute / safe_query).

نمط التشغيل:
  - نمط حي مباشر ورسمي 100% (Live Mode): يتصل مباشرة بالبوابة الرسمية للحساب عبر CastleBot لمزامنة وقراءة الذاكرة الحية الحقيقية (مطابق لتشغيل البوت العام من الواجهة).

أمثلة الاستخدام من سطر الأوامر:
  1. تشغيل القائمة التفاعلية في التيرمنال:
     python tools/test_base_task.py

  2. فحص شامل لكافة الخصائص والدوال (All-in-One Benchmark):
     python tools/test_base_task.py --all
     python tools/test_base_task.py --email beetoo2@hotmail.com --all

  3. اختبار دالة أو خاصية محددة:
     python tools/test_base_task.py --email beetoo2@hotmail.com --fn get_active_gather_resource_types
     python tools/test_base_task.py --fn marches
     python tools/test_base_task.py --fn gather
     python tools/test_base_task.py --fn ruins
     python tools/test_base_task.py --fn sync

  4. اختبار دالة توفير الموارد (ensure_resources):
     python tools/test_base_task.py --fn ensure_resources --resource قمح --amount 500000 --multiplier 2
     python tools/test_base_task.py --fn ensure_resources --resource بلور --amount 100000 --live

  5. أوامر مختصرة مباشرة:
     python tools/test_base_task.py all
     python tools/test_base_task.py properties
     python tools/test_base_task.py marches
     python tools/test_base_task.py ensure_resources
"""

from __future__ import annotations

import argparse
import asyncio
import contextlib
import io
import inspect
import json
import logging
import os
import sqlite3
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

# ضبط إخراج التيرمنال لـ UTF-8 على ويندوز
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

# تحديد مسارات المشروع بدقة
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
DOCS_DIR = os.path.join(WORKSPACE_DIR, "docs")
DB_PATH = os.path.join(WORKSPACE_DIR, "database", "castles.db")

if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from tasks.base_task import (
    BaseTask,
    TaskResult,
    RESOURCE_CATALOG,
    RESOURCE_KEY_MAP,
    STAMINA_PACKS_CATALOG,
    STAMINA_PACKS_KEY_MAP,
)


# ════════════════════════════════════════════════════════════════════
# 1. كلاس تسخير الاختبار الحقيقي لـ BaseTask (Harness Subclass)
# ════════════════════════════════════════════════════════════════════

class BaseTaskHarness(BaseTask):
    """كلاس مشتق خفيف لاختبار وظائف BaseTask التجريدية وتوفير بيئة فحص مرنة."""
    name = "base_task_harness"

    async def run(self) -> TaskResult:
        """تنفيذ تجريبي لقياس أداء دورة حياة BaseTask."""
        return TaskResult.ok(
            msg="تم تنفيذ دورة حياة BaseTaskHarness بنجاح تام.",
            data={
                "uid": self.uid,
                "castle_level": self.castle_level,
                "stamina": self.stamina,
                "gold": self.gold,
            },
        )


# ════════════════════════════════════════════════════════════════════
# 2. مساعدات قراءة حسابات القلاع
# ════════════════════════════════════════════════════════════════════

def get_registered_accounts() -> List[Dict[str, Any]]:
    """استرجاع كافة حسابات القلاع المسجلة في قاعدة البيانات."""
    accounts = []
    if not os.path.exists(DB_PATH):
        return accounts
    try:
        conn = sqlite3.connect(DB_PATH)
        cur = conn.cursor()
        cur.execute("SELECT email, password, is_active, castle_name FROM castle_states")
        for row in cur.fetchall():
            accounts.append({
                "email": row[0],
                "password": row[1],
                "is_active": bool(row[2]),
                "castle_name": row[3] or "",
            })
        conn.close()
    except Exception as e:
        print(f"⚠️ خطأ أثناء قراءة قاعدة البيانات: {e}")
    return accounts


def get_default_account_email() -> str:
    """استرجاع البريد الافتراضي للحساب النشط."""
    accs = get_registered_accounts()
    for acc in accs:
        if acc["is_active"]:
            return acc["email"]
    return accs[0]["email"] if accs else "LUCIFER@g4.com"


# ════════════════════════════════════════════════════════════════════
# 3. دوال فحص واختبار BaseTask المحددة
# ════════════════════════════════════════════════════════════════════

def test_fast_memory_properties(task: BaseTask) -> Dict[str, Any]:
    """اختبار استخراج خصائص الذاكرة الحية السريعة (0-Network Direct Read)."""
    t0 = time.perf_counter()
    uid = task.uid
    kid = task.kingdom_id
    stamina = task.stamina
    health = task.health
    gold = task.gold
    c_lv = task.castle_level
    l_lv = task.lord_level
    shield = task.shield_remaining_seconds
    res = task.resources
    ctrl_count = len(task.init_data) if isinstance(task.init_data, dict) else 0
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    food = int(float(res.get("1002", 0)))
    wood = int(float(res.get("1003", 0)))
    iron = int(float(res.get("1004", 0)))
    silver = int(float(res.get("1005", 0)))
    crystal = int(float(res.get("1027", 0)))

    print("\n" + "═" * 70)
    print(" 📊 [BaseTask Properties] خصائص ومتحكمات الذاكرة الحية (0-Network)")
    print("═" * 70)
    print(f"   • معرف اللاعب (UID)       : {uid}")
    print(f"   • رقم المملكة (Kingdom ID): {kid}")
    print(f"   • مستوى القلعة (Castle Lv): Lv.{c_lv}")
    print(f"   • مستوى اللورد (Lord Lv)  : Lv.{l_lv}")
    print(f"   • طاقة اللورد (Stamina)   : {stamina:,} (Health Alias: {health:,})")
    print(f"   • رصيد الذهب (Gold)       : {gold:,}")
    print(f"   • درع الحماية المتبقي     : {shield:,} ثانية ({round(shield / 3600, 1)} ساعة)")
    print(f"   • الموارد المتاحة بالمخزن :")
    print(f"       - 🌾 القمح (Food)     : {food:,}")
    print(f"       - 🪵 الخشب (Wood)     : {wood:,}")
    print(f"       - ⛏️ الحديد (Iron)     : {iron:,}")
    print(f"       - 🪙 الفضة (Silver)   : {silver:,}")
    print(f"       - 💎 البلور (Crystal) : {crystal:,}")
    print(f"   • إجمالي متحكمات الذاكرة : {ctrl_count} متحكم")
    print(f"   ⚡ زمن القراءة الفوري     : {t_elapsed_ms:.3f} ms (استهلاك شبكي: 0-Network)")
    print("═" * 70)

    return {
        "success": bool(uid and kid),
        "uid": uid,
        "kingdom_id": kid,
        "castle_level": c_lv,
        "lord_level": l_lv,
        "stamina": stamina,
        "gold": gold,
        "shield_remaining": shield,
        "resources": {"food": food, "wood": wood, "iron": iron, "silver": silver, "crystal": crystal},
        "time_ms": t_elapsed_ms,
    }


def test_marches_and_queues(task: BaseTask) -> Dict[str, Any]:
    """اختبار حسابات سعة الفيالق والمسيرات النشطة والشاغرة بدقة."""
    t0 = time.perf_counter()
    max_cap = int(task.get_max_marches_capacity())
    active_count = int(task.get_active_marches_count())
    avail_count = int(task.get_available_marches_count())
    prop_avail = int(task.available_marches)
    other_count = int(task.get_other_marches_count())
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    # استخراج تفاصيل الأبحاث والـ VIP لشرح السعة القصوى
    tech_ctrl = task.get_ctrl("technologyCtrl")
    tech_exp_count = 0
    if isinstance(tech_ctrl, dict):
        for tid in ("24011", "24017", "24033"):
            if tid in tech_ctrl or int(tid) in tech_ctrl:
                tech_exp_count += 1

    vip_ctrl = task.get_ctrl("vipCtrl")
    vip_lv = 0
    if isinstance(vip_ctrl, dict):
        vip_lv = int(vip_ctrl.get("vipLv", vip_ctrl.get("level", 0)) or 0)
    if vip_lv == 0:
        lord = task.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict) and isinstance(lord.get("vip"), dict):
            vip_lv = int(lord["vip"].get("level", lord["vip"].get("vipLv", 0)) or 0)

    vip_bonus = 2 if vip_lv >= 10 else (1 if vip_lv >= 4 else 0)

    print("\n" + "═" * 70)
    print(" ⚔️ [March Engine] محرك الفيالق والمسيرات (March & Queue Engine)")
    print("═" * 70)
    print(f"   • سعة الفيالق القصوى (Max Capacity) : {max_cap} مسيرة")
    print(f"       - الأساسي الافتراضي للعبة       : +1")
    print(f"       - مكافأة معهد الأبحاث (#240xx)  : +{min(3, tech_exp_count)}")
    print(f"       - مكافأة ميزة VIP (مستوى Lv.{vip_lv}) : +{vip_bonus}")
    print(f"   • الفيالق النشطة بالخارج (Active)    : {active_count}")
    print(f"   • الفيالق الشاغرة للإرسال (Available): {avail_count}")
    print(f"   • خاصية available_marches (Property) : {prop_avail}")
    print(f"   • مسيرات اللاعبين الآخرين (Other)   : {other_count}")
    print(f"   ⚡ زمن معالجة الفيالق                : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": (max_cap >= 1 and avail_count >= 0),
        "max_capacity": max_cap,
        "active_marches": active_count,
        "available_marches": avail_count,
        "property_available": prop_avail,
        "other_marches": other_count,
        "time_ms": t_elapsed_ms,
    }


def test_gather_resource_types(task: BaseTask) -> Dict[str, Any]:
    """اختبار فحص أنواع الموارد التي تجمعها فيالق القلعة حالياً."""
    t0 = time.perf_counter()
    types_set = task.get_active_gather_resource_types()
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    type_names = {
        1: "ذهب (Gold)",
        2: "قمح (Food)",
        3: "خشب (Wood)",
        4: "حديد (Iron)",
        5: "فضة (Silver)",
    }
    gathered = [type_names.get(t, f"نوع {t}") for t in sorted(types_set)]

    print("\n" + "═" * 70)
    print(" 🌾 [Gather Types] فحص أنواع الموارد قيد الجمع (Active Gather Types)")
    print("═" * 70)
    print(f"   • الموارد التي تجمعها الفيالق حالياً : {set(types_set)}")
    if gathered:
        for g in gathered:
            print(f"       - {g}")
    else:
        print("       (لا توجد أي مسيرة تجمع موارد في الوقت الحالي)")
    print(f"   ⚡ زمن الفحص : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": True,
        "active_gather_types": list(types_set),
        "gathered_names": gathered,
        "time_ms": t_elapsed_ms,
    }


def test_ruins_march(task: BaseTask) -> Dict[str, Any]:
    """اختبار التحقق من وجود فيلق يستكشف الأطلال."""
    t0 = time.perf_counter()
    is_active = task.is_ruins_march_active()
    has_active = task.has_active_ruins_march()
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print("\n" + "═" * 70)
    print(" 🏛️ [Ruins March] فحص مسيرات الأطلال (Ruins March Status)")
    print("═" * 70)
    print(f"   • هل يوجد فيلق أطلال نشط؟ : {'نعم ✅' if is_active else 'لا (لا يوجد) ❌'}")
    print(f"   • فحص الاسم البديل (has_active_ruins_march): {has_active}")
    print(f"   ⚡ زمن الفحص : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": (is_active == has_active),
        "is_ruins_march_active": is_active,
        "time_ms": t_elapsed_ms,
    }


def test_available_troops(task: BaseTask) -> Dict[str, Any]:
    """اختبار استخراج وفحص القوات والجنود الشاغرين في القلعة مع استبعاد حصن الحرب (0-Network)."""
    t0 = time.perf_counter()
    troops_dict = task.get_available_troops(exclude_fortress=True, as_list=False, reverse=False)
    troops_list = task.get_available_troops(exclude_fortress=True, as_list=True, reverse=False)
    troops_rev = task.get_available_troops(exclude_fortress=True, as_list=False, reverse=True)
    all_units = task.get_available_troops(exclude_fortress=False, as_list=False)
    total_count = task.get_available_troops_count(exclude_fortress=True)
    prop_count = task.available_troops_count
    prop_troops = task.available_troops
    troops_list_helper = task.get_available_troops_list(exclude_fortress=True)

    # دوال سورس كود اللعبة المطابقة حرفياً (armyCtrl.lua / armyltCtrl.lua / serviceFunctions.lua)
    army_list = task.get_army_list()
    trap_list = task.get_trap_list()
    trap_total = task.get_trap_total_count()
    inner_city_count = task.get_inner_city_normal_army()

    # التحقق من دقة armyltCtrl.is_army_id و serviceFunctions.is_trap_id
    assert task.is_trap_id(801) is True, "فحص 801 يجب أن يكون فخاً (Trap ID)"
    assert task.is_trap_id(401) is False, "فحص 401 يجب ألا يكون فخاً"
    assert task.is_army_id(401) is True, "فحص 401 يجب أن يكون جندياً مقاتلاً"
    assert task.is_army_id(801) is False, "فحص 801 يجب ألا يكون جندياً مقاتلاً"

    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    # إحصائيات الأفخاخ المستبعدة لحصن الحرب (800..899 / BUILDID 120)
    fortress_count = trap_total

    # تصنيف القوات المتاحة حسب الصنف الرسمي للعبة
    type_names = {
        4: "🛡️ مشاة (Infantry)",
        5: "🐎 خيالة (Cavalry)",
        6: "🏹 رماة (Archers)",
        7: "🚜 عربات (Chariots)",
        9: "⭐ نخبة (Elite)",
    }
    categorized: Dict[str, int] = {}
    for uid, cnt in army_list.items():
        cat_key = type_names.get(uid // 100, f"وحدات ({uid // 100})")
        categorized[cat_key] = categorized.get(cat_key, 0) + cnt

    print("\n" + "═" * 70)
    print(" ⚔️ [Available Troops & ArmyList] القوات والجنود الشاغرين في القلعة (0-Network)")
    print("═" * 70)
    print(f"   • إجمالي الجنود المتاحين والشاغرين : {total_count:,} جندي (InnerCityNormalArmy: {inner_city_count:,})")
    print(f"   • وحدات حصن الحرب المستبعدة (الأفخاخ) : {fortress_count:,} فخ (Trap Total: {trap_total:,})")
    print(f"   • تفصيل القوات حسب الصنف:")
    if categorized:
        for cat_name, cat_cnt in categorized.items():
            print(f"       - {cat_name:<24}: {cat_cnt:,}")
    else:
        print("       (لا يوجد أي جنود متاحين في القلعة حالياً - القلعة خالية من الجنود)")
    print(f"   • عينة من الوحدات المتاحة (تصاعدي - الأضعف رتبة أولاً):")
    if troops_list:
        for item in troops_list[:5]:
            print(f"       - معرف: {item['id']} | العدد: {item['num']:,}")
        if len(troops_list) > 5:
            print(f"       ... و {len(troops_list) - 5} فئات أخرى")
    else:
        print("       (قائمة فارغة [] - صفر استهلاك للقوات الملفقة)")
    print(f"   ⚡ زمن القراءة والمعالجة الفوري     : {t_elapsed_ms:.3f} ms (0-Network)")
    print("═" * 70)

    return {
        "success": True,
        "total_available_troops": total_count,
        "fortress_traps_excluded": fortress_count,
        "troops_dict": troops_dict,
        "army_list": army_list,
        "trap_list": trap_list,
        "inner_city_count": inner_city_count,
        "troops_list": troops_list,
        "categorized": categorized,
        "time_ms": t_elapsed_ms,
    }


def test_stamina_packs(task: BaseTask, pack_type: Optional[str] = None) -> Dict[str, Any]:
    """اختبار استخراج حزم وباقات طاقة اللورد من الحقيبة (0-Network Direct Read)."""
    t0 = time.perf_counter()
    res = task.get_available_stamina_packs(pack_type)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print("\n" + "═" * 70)
    print(" ⚡ [BaseTask Stamina Packs] حزم وباقات طاقة اللورد بالحقيبة (0-Network)")
    print("═" * 70)
    if pack_type is not None:
        print(f"   • الفئة المفحوصة          : {pack_type}")
        print(f"   • إجمالي نقاط الطاقة المتاحة : {res:,}")
    else:
        tot_pts = res.get("total_stamina", 0) if isinstance(res, dict) else 0
        tot_packs = res.get("total_packs", 0) if isinstance(res, dict) else 0
        p10 = res.get("10", 0) if isinstance(res, dict) else 0
        p50 = res.get("50", 0) if isinstance(res, dict) else 0
        p100 = res.get("100", 0) if isinstance(res, dict) else 0
        details = res.get("details", {}) if isinstance(res, dict) else {}
        cnt10 = details.get("10", {}).get("count", 0)
        cnt50 = details.get("50", {}).get("count", 0)
        cnt100 = details.get("100", {}).get("count", 0)
        print(f"   • إجمالي نقاط الطاقة الكلي : {tot_pts:,} نقطة طاقة")
        print(f"   • إجمالي عدد الحزم        : {tot_packs:,} حزمة")
        print(f"   • تفاصيل الحزم:")
        print(f"       - 🟢 حزم 10 طاقة (300401) : {cnt10:,} حزمة ({p10:,} نقطة طاقة)")
        print(f"       - 🔵 حزم 50 طاقة (300402) : {cnt50:,} حزمة ({p50:,} نقطة طاقة)")
        print(f"       - 🟣 حزم 100 طاقة (300403): {cnt100:,} حزمة ({p100:,} نقطة طاقة)")
    print(f"   ⚡ زمن القراءة الفوري       : {t_elapsed_ms:.3f} ms (استهلاك شبكي: 0-Network)")
    print("═" * 70)

    return {
        "success": True,
        "result": res,
        "time_ms": t_elapsed_ms,
    }


async def test_sync_queues(task: BaseTask) -> Dict[str, Any]:
    """اختبار إرسال استعلام مزامنة طوابير الفيالق 1007/1000."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" 🔄 [Sync Queues] مزامنة طوابير الفيالق مع السيرفر (CMD 1007/1000)")
    print("═" * 70)
    print("   📡 إرسال استعلام المزامنة...")
    ok = await task.sync_local_queues(timeout=3.0)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000
    print(f"   • نتيجة المزامنة : {'نجحت بنجاح ✅' if ok else 'فشلت أو لم يرد إشعار ❌'}")
    print(f"   ⚡ زمن الاستجابة : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": ok,
        "time_ms": t_elapsed_ms,
    }


async def test_resource_provisioning(
    task: BaseTask,
    resource: str = "food",
    amount: int = 100_000,
    multiplier: int = 2,
    force_open: bool = False,
) -> Dict[str, Any]:
    """اختبار دالة التوفير الذكي للموارد (ensure_resources)."""
    print("\n" + "═" * 70)
    print(" 📦 [Resource Provisioning] تجربة دالة توفير الموارد (ensure_resources)")
    print("═" * 70)
    print(f"   • المورد المطلوب     : {resource}")
    print(f"   • الكمية المطلوبة   : {amount:,}")
    print(f"   • مضاعف الاحتياط    : {multiplier}x أضعاف (المستهدف: {amount * multiplier:,})")
    print(f"   • فتح إجباري مباشر  : {force_open}")

    # رصيد المورد الحالي قبل الفتح
    norm_key = RESOURCE_KEY_MAP.get(resource) or RESOURCE_KEY_MAP.get(resource.lower()) or "food"
    meta = RESOURCE_CATALOG.get(norm_key, {})
    res_id = meta.get("res_id", "1002")
    res_list = task.resources
    initial_bal = int(float(res_list.get(res_id, 0)))
    print(f"   • الرصيد الأولي بالمخزن: {initial_bal:,}")

    # فحص الحقيبة للصناديق المتاحة قبل التجربة
    backpack = task.get_ctrl("backpackCtrl") or task.get_ctrl("bagCtrl")
    normal_boxes = meta.get("normal_boxes", [])
    safe_boxes = meta.get("safe_boxes", [])

    avail_normal_total = sum(
        int((backpack.get(str(b_id)) or backpack.get(b_id, {})).get("count", 0)) * b_val
        for b_id, b_val in normal_boxes if isinstance(backpack.get(str(b_id)) or backpack.get(b_id), dict)
    )
    avail_safe_total = sum(
        int((backpack.get(str(b_id)) or backpack.get(b_id, {})).get("count", 0)) * b_val
        for b_id, b_val in safe_boxes if isinstance(backpack.get(str(b_id)) or backpack.get(b_id), dict)
    )
    print(f"   • إجمالي الصناديق العادية المتاحة بالحقيبة: {avail_normal_total:,}")
    print(f"   • إجمالي الصناديق الآمنة المتاحة بالحقيبة : {avail_safe_total:,}")

    t0 = time.perf_counter()
    result = await task.ensure_resources({resource: amount}, multiplier=multiplier, force_open=force_open)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    new_res_list = task.resources
    final_bal = int(float(new_res_list.get(res_id, 0)))

    print(f"   • نتيجة التنفيذ       : {'ناجحة ✅' if result.get('success') else 'لم تكتمل بالكامل ⚠️'}")
    print(f"   • الرصيد النهائي بالمخزن: {final_bal:,} (الزيادة: +{final_bal - initial_bal:,})")
    print(f"   ⚡ زمن التنفيذ         : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": result.get("success", False),
        "result": result,
        "initial_balance": initial_bal,
        "final_balance": final_bal,
        "gained": final_bal - initial_bal,
        "time_ms": t_elapsed_ms,
    }


async def test_lifecycle_and_safety(task: BaseTask) -> Dict[str, Any]:
    """اختبار الفحص القبلي can_run والتنفيذ الآمن safe_execute."""
    t0 = time.perf_counter()
    can_exec, reason = await task.can_run()
    exec_result = await task.safe_execute()
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print("\n" + "═" * 70)
    print(" 🛡️ [Lifecycle & Safety] فحص دورة الحياة والأمان (can_run / safe_execute)")
    print("═" * 70)
    print(f"   • نتيجة can_run()      : {'جاهز للتشغيل ✅' if can_exec else f'غير متاح ❌ ({reason})'}")
    print(f"   • نتيجة safe_execute() : {exec_result}")
    print(f"       - النجاح (Success) : {exec_result.success}")
    print(f"       - التخطي (Skipped) : {exec_result.skipped}")
    print(f"       - الرسالة (Message): {exec_result.message}")
    print(f"       - البيانات (Data)  : {exec_result.data}")
    print(f"   ⚡ زمن التنفيذ          : {t_elapsed_ms:.3f} ms")
    print("═" * 70)

    return {
        "success": exec_result.success,
        "can_run": can_exec,
        "reason": reason,
        "task_result": exec_result.to_dict(),
        "time_ms": t_elapsed_ms,
    }


async def test_safe_query_and_jitter(task: BaseTask) -> Dict[str, Any]:
    """اختبار الاستعلام الآمن وحساب الفاصل البشري العشوائي (Human Jitter)."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" ⏱️ [Safe Query & Jitter] الاستعلام الآمن والفاصل البشري العشوائي")
    print("═" * 70)
    print("   📡 إرسال استعلام تجريبي آمن بفاصل عشوائي (0.2s - 0.4s)...")
    res = await task.safe_query("1007", "1000", {}, min_delay=0.2, max_delay=0.4)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print(f"   • استجابة الاستعلام    : {res is not None} ({res})")
    print(f"   • زمن التنفيذ الإجمالي: {t_elapsed_ms:.2f} ms (يحتوي على الفاصل الزمني العشوائي لحماية الحساب)")
    print("═" * 70)

    return {
        "success": res is not None,
        "response": res,
        "time_ms": t_elapsed_ms,
    }


async def test_command_hall_inspection(task: BaseTask, force_sync: bool = False) -> Dict[str, Any]:
    """اختبار دالة استكشاف وجلب مهام قاعة القيادة (get_command_hall_tasks)."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" 🏰 [Command Hall Inspection] فحص وجلب مهام قاعة القيادة الشامل")
    print("═" * 70)

    res = await task.get_command_hall_tasks(force_sync=force_sync)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    if not res.get("success", False):
        print(f"   ❌ تعذر جلب بيانات قاعة القيادة: {res.get('message')}")
        print("═" * 70)
        return {"success": False, "time_ms": t_elapsed_ms, "result": res}

    summary = res.get("summary", {})
    counts = res.get("counts", {})
    instant_tasks = res.get("instant_tasks", [])
    march_tasks = res.get("march_tasks", [])
    army_group = res.get("army_group_task")
    claimable = res.get("claimable_tasks", [])

    print(f"   👑 مستوى قاعة القيادة : Lv.{summary.get('command_lv')} (الخبرة: {summary.get('command_exp')}/{summary.get('need_exp')})")
    print(f"   ⚡ مستوى القوة        : Lv.{summary.get('power_lv')}")
    print(f"   🎯 فيلق الغزاة الحالي : #{summary.get('army_group_id')}")
    print(f"   ✨ الترقية متاحة       : {'نعم ✅' if summary.get('can_upgrade') else 'لا ⏳'}")
    print(f"   📅 النشاط اليومي (33) : {'مكتمل ✅' if summary.get('daily_quest_completed') else 'غير مكتمل ⏳'}")
    print(f"   ⏳ التحديث القادم      : خلال {summary.get('next_refresh_remaining_seconds')} ثانية")
    print("   ─" * 35)
    print(f"   📊 إحصائيات المهام    : إجمالي={counts.get('total')} | للتنفيذ={counts.get('executable')} | فورية={counts.get('instant')} | مسير={counts.get('march')} | للاستلام={counts.get('claimable')}")
    print("   ─" * 35)

    if army_group:
        print(f"   🚩 [فيلق الغزاة (بوس)] : ID={army_group['task_id']} | جودة={army_group['quality_name_ar']} | حالة={army_group['statue_name_ar']}")

    if instant_tasks:
        print(f"   ⚡ [مهام فورية آمنة ({len(instant_tasks)})]:")
        for t in instant_tasks:
            print(f"      • [{t['type_name_ar']}] ID={t['task_id']} | جودة={t['quality_name_ar']} | طاقة={t['stamina_cost']}")

    if march_tasks:
        print(f"   ⚔️ [مهام مسير ومعارك ({len(march_tasks)})]:")
        for t in march_tasks:
            pos_str = f"({t['pos']['x']}, {t['pos']['y']})" if t.get('pos') else "غير محدد"
            print(f"      • [{t['type_name_ar']}] ID={t['task_id']} | جودة={t['quality_name_ar']} | موقع={pos_str} | طاقة={t['stamina_cost']}")

    if claimable:
        print(f"   🎁 [مهام جاهزة للاستلام ({len(claimable)})]:")
        for t in claimable:
            print(f"      • [{t['type_name_ar']}] ID={t['task_id']} | جودة={t['quality_name_ar']}")

    print(f"   ⏱️ زمن التنفيذ الإجمالي: {t_elapsed_ms:.2f} ms")
    print("═" * 70)

    return {"success": True, "time_ms": t_elapsed_ms, "result": res}


async def test_command_hall_battle(task: BaseTask) -> Dict[str, Any]:
    """اختبار دوال تجهيز الجيش وتنفيذ معركة فريق الغزاة في قاعة القيادة."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" ⚔️ [Command Hall Battle] اختبار تجهيز الجيش وتنفيذ معركة فريق الغزاة")
    print("═" * 70)

    # 1. اختبار دوال تجهيز الجيش والبطل
    troops = task.prepare_combat_troops(task_id=5025)
    heroes = task.prepare_combat_hero(task_id=5025)
    total_troops = sum(t.get("num", 0) for t in troops)
    print(f"   🛡️ القوات المجهزة   : {len(troops)} فئات (إجمالي الجنود: {total_troops:,})")
    for tr in troops:
        print(f"      • رتبة ID={tr['id']} : {tr['num']:,} جندي")
    print(f"   👑 الأبطال المجهزون : {len(heroes)} أبطال")
    for idx, h in enumerate(heroes):
        print(f"      • خانة {idx+1}: بطل ID={h.get('heroID')}" + (f" (نائب: {h.get('slaveHeroID')})" if h.get("slaveHeroID") else ""))

    # 2. جلب مهام المعارك المتاحة حالياً
    cmd_res = await task.get_command_hall_tasks(force_sync=False)
    march_tasks = cmd_res.get("march_tasks", [])
    battle_tasks = [t for t in march_tasks if t.get("type") in (5, 2)]

    if not battle_tasks:
        print("   ⚠️ لا توجد مهام فريق الغزاة (نوع 5) متاحة للتنفيذ حالياً في القلعة.")
        print("═" * 70)
        return {"success": True, "executed": False, "troops": troops, "heroes": heroes}

    target_task = battle_tasks[0]
    print(f"   🎯 المهمة المستهدفة : #{target_task.get('index')} (ID: {target_task.get('task_id')}) عند {target_task.get('pos')}")

    # 3. تنفيذ المعركة بالكامل (إرسال المسير + الانتظار + استلام الجائزة)
    exec_res = await task.execute_command_hall_battle_task(target_task)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print(f"   🚀 نتيجة التنفيذ   : {'ناجح ✅' if exec_res.get('success') else 'فشل ❌'}")
    print(f"   📢 رسالة العملية   : {exec_res.get('message', exec_res.get('reason'))}")
    print(f"   📬 رد إرسال المسير : {exec_res.get('march_response')}")
    print(f"   🎁 رد استلام الجائزة: {exec_res.get('claim_response')}")
    if exec_res.get("rewards"):
        print(f"   ⭐ الجوائز المستلمة: {exec_res.get('rewards')}")
    print(f"   ⏱️ زمن التنفيذ     : {t_elapsed_ms:.2f} ms")
    print("═" * 70)

    return {"success": exec_res.get("success", False), "result": exec_res, "time_ms": t_elapsed_ms}


async def test_command_hall_snipe(task: BaseTask) -> Dict[str, Any]:
    """اختبار دالة تنفيذ مهمة القناص الصامت (نوع 6) في قاعة القيادة."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" 🎯 [Command Hall Snipe] اختبار تنفيذ مهمة القناص الصامت (نوع 6)")
    print("═" * 70)

    # 1. جلب مهام قاعة القيادة وفحص القناص الصامت
    cmd_res = await task.get_command_hall_tasks(force_sync=False)
    all_t = cmd_res.get("all_tasks", [])
    snipe_tasks = [t for t in all_t if t.get("type") == 6 and t.get("statue") in (1, 2)]

    if not snipe_tasks:
        print("   ⚠️ لا توجد مهام قناص صامت (نوع 6) جاهزة للتنفيذ حالياً في القلعة.")
        print(f"      (إجمالي المهام المرصودة: {len(all_t)} | القابلة للتنفيذ: {len(cmd_res.get('executable_tasks', []))})")
        print("═" * 70)
        return {"success": True, "executed": False, "found": 0}

    target_task = snipe_tasks[0]
    print(f"   🎯 المهمة المستهدفة : #{target_task.get('index')} (ID: {target_task.get('task_id')}) جودة: {target_task.get('quality_name_ar')}")

    # 2. تنفيذ مهمة القناص الصامت
    exec_res = await task.execute_command_hall_snipe_task(target_task, wait_seconds=1.5)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print(f"   🚀 نتيجة التنفيذ   : {'ناجح ✅' if exec_res.get('success') else 'فشل ❌'}")
    print(f"   📢 رسالة العملية   : {exec_res.get('message', exec_res.get('reason'))}")
    if exec_res.get("rewards"):
        print(f"   ⭐ الجوائز المستلمة: {exec_res.get('rewards')}")
    print(f"   ⏱️ زمن التنفيذ     : {t_elapsed_ms:.2f} ms")
    print("═" * 70)

    return {"success": exec_res.get("success", False), "result": exec_res, "time_ms": t_elapsed_ms}


async def test_command_hall_rescue(task: BaseTask) -> Dict[str, Any]:
    """اختبار دالة تنفيذ مهمة إنقاذ القرويين (نوع 4) في قاعة القيادة."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" 🤝 [Command Hall Rescue] اختبار تنفيذ مهمة إنقاذ القرويين (نوع 4)")
    print("═" * 70)

    # 1. جلب مهام قاعة القيادة وفحص مهام إنقاذ القرويين
    cmd_res = await task.get_command_hall_tasks(force_sync=False)
    all_t = cmd_res.get("all_tasks", [])
    rescue_tasks = [t for t in all_t if t.get("type") == 4 and t.get("statue") in (1, 2, 3)]

    if not rescue_tasks:
        print("   ⚠️ لا توجد مهام إنقاذ قرويين (نوع 4) جاهزة للتنفيذ حالياً في القلعة.")
        print(f"      (إجمالي المهام المرصودة: {len(all_t)} | القابلة للتنفيذ: {len(cmd_res.get('executable_tasks', []))})")
        print("═" * 70)
        return {"success": True, "executed": False, "found": 0}

    target_task = rescue_tasks[0]
    print(f"   🎯 المهمة المستهدفة : #{target_task.get('index')} (ID: {target_task.get('task_id')}) جودة: {target_task.get('quality_name_ar')} | الحالة: {target_task.get('statue_name_ar')}")

    # 2. تنفيذ مهمة إنقاذ القرويين
    exec_res = await task.execute_command_hall_rescue_task(target_task, wait_seconds=2.0)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print(f"   🚀 نتيجة التنفيذ   : {'ناجح ✅' if exec_res.get('success') else 'فشل ❌'}")
    print(f"   📢 رسالة العملية   : {exec_res.get('message', exec_res.get('reason'))}")
    if exec_res.get("rewards"):
        print(f"   ⭐ الجوائز المستلمة: {exec_res.get('rewards')}")
    print(f"   ⏱️ زمن التنفيذ     : {t_elapsed_ms:.2f} ms")
    print("═" * 70)

    return {"success": exec_res.get("success", False), "result": exec_res, "time_ms": t_elapsed_ms}


async def test_command_hall_dialogue(task: BaseTask) -> Dict[str, Any]:
    """اختبار دالة تنفيذ مهمة المعلومات العسكرية (نوع 3) في قاعة القيادة."""
    t0 = time.perf_counter()
    print("\n" + "═" * 70)
    print(" 📜 [Command Hall Dialogue] اختبار تنفيذ مهمة المعلومات العسكرية (نوع 3)")
    print("═" * 70)

    # 1. جلب مهام قاعة القيادة وفحص مهام المعلومات العسكرية
    cmd_res = await task.get_command_hall_tasks(force_sync=False)
    all_t = cmd_res.get("all_tasks", [])
    dialogue_tasks = [t for t in all_t if t.get("type") == 3 and t.get("statue") in (1, 2, 3)]

    if not dialogue_tasks:
        print("   ⚠️ لا توجد مهام معلومات عسكرية (نوع 3) جاهزة للتنفيذ حالياً في القلعة.")
        print(f"      (إجمالي المهام المرصودة: {len(all_t)} | القابلة للتنفيذ: {len(cmd_res.get('executable_tasks', []))})")
        print("═" * 70)
        return {"success": True, "executed": False, "found": 0}

    target_task = dialogue_tasks[0]
    print(f"   🎯 المهمة المستهدفة : #{target_task.get('index')} (ID: {target_task.get('task_id')}) جودة: {target_task.get('quality_name_ar')} | الحالة: {target_task.get('statue_name_ar')}")

    # 2. تنفيذ مهمة المعلومات العسكرية
    exec_res = await task.execute_command_hall_dialogue_task(target_task, wait_seconds=1.5)
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print(f"   🚀 نتيجة التنفيذ   : {'ناجح ✅' if exec_res.get('success') else 'فشل ❌'}")
    print(f"   📢 رسالة العملية   : {exec_res.get('message', exec_res.get('reason'))}")
    if exec_res.get("rewards"):
        print(f"   ⭐ الجوائز المستلمة: {exec_res.get('rewards')}")
    print(f"   ⏱️ زمن التنفيذ     : {t_elapsed_ms:.2f} ms")
    print("═" * 70)

    return {"success": exec_res.get("success", False), "result": exec_res, "time_ms": t_elapsed_ms}


def test_single_march_capacity(task: BaseTask) -> Dict[str, Any]:
    """اختبار دالة حساب سعة المسيرة القصوى للفيلق الواحد get_max_march_capacity بدقة وميدانياً."""
    t0 = time.perf_counter()

    # 1. حساب السعة المجردة للقلعة بدون أبطال (Bare Castle Capacity)
    bare_cap_int = task.get_max_march_capacity(heroes="none", breakdown=False)
    bare_breakdown = task.get_max_march_capacity(heroes="none", breakdown=True)

    # 2. حساب السعة القصوى الممكنة مع أفضل أبطال القلعة تلقائياً (Max Possible March Capacity)
    max_cap_int = task.get_max_march_capacity(heroes=None, breakdown=False)
    max_breakdown = task.get_max_march_capacity(heroes=None, breakdown=True)

    # 3. استخراج الأبطال المتوفرين بالقلعة لتجربة تمريرهم يدوياً
    hero_sys = task.get_ctrl("heroSysCtrl") or {}
    hl = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
    sample_heroes = list(hl.keys())[:2]

    hero_cap_int = None
    hero_breakdown = None
    if sample_heroes:
        hero_cap_int = task.get_max_march_capacity(heroes=sample_heroes, breakdown=False)
        hero_breakdown = task.get_max_march_capacity(heroes=sample_heroes, breakdown=True)

    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print("\n" + "═" * 70)
    print(" 🛡️ [March Capacity Engine] سعة المسيرة القصوى للفيلق الواحد (Single March)")
    print("═" * 70)
    print(f"   • السعة القصوى الممكنة للفيلق (مع أفضل الأبطال) : {max_cap_int:,} جندي")
    print(f"   • سعة القلعة الأساسية المجردة (بدون أبطال)      : {bare_cap_int:,} جندي")
    dg = bare_breakdown.get("drill_grounds", {})
    print(f"       - مبنى ميدان العرض (BID 121)               : Lv.{dg.get('level')} (نجوم: {dg.get('star_level')}) -> {dg.get('total_building_capacity', 0):,} جندي")
    print(f"       - السعة الافتراضية للعبة                   : +{bare_breakdown.get('game_default', 1000):,} جندي")
    tech_info = bare_breakdown.get("technology", {})
    print(f"       - أبحاث معهد القيادة (#240xx)             : +{tech_info.get('tech_add', 0):,} جندي (مضاعف: +{round(tech_info.get('tech_group_multiplier', 0)*100, 1)}%)")
    buff_info = bare_breakdown.get("buffs", {})
    print(f"       - بافات المسيرة النشطة                     : نسبة +{round(buff_info.get('percent_add', 0)*100, 1)}% (+{buff_info.get('percent_bonus_troops', 0):,} جندي) | ثابت: +{buff_info.get('flat_add', 0):,}")

    max_h_info = max_breakdown.get("heroes", {})
    unlocked_slots = max_breakdown.get("unlocked_hero_slots", 5)
    print(f"\n   👑 مساهمة أفضل {unlocked_slots} أبطال متاحين بالقلعة (Auto-Selected): +{max_h_info.get('total_hero_add', 0):,} جندي")
    for h in max_h_info.get("details", []):
        print(f"       - بطل #{h.get('hero_id')} ({h.get('name')}): Lv.{h.get('level')} (ندرة {h.get('rarity')}) -> سعة أساسية: +{h.get('level_march_add'):,} | مهارات: +{h.get('skill_march_add'):,} (إجمالي: +{h.get('total_hero_add'):,})")

    if sample_heroes and hero_breakdown:
        h_info = hero_breakdown.get("heroes", {})
        print(f"\n   • سعة الفيلق عند تمرير أبطال محددين {sample_heroes}: {hero_cap_int:,} جندي (زيادة الأبطال: +{h_info.get('total_hero_add', 0):,})")

    print(f"\n   ⚡ زمن الحساب بالذاكرة الحية                    : {t_elapsed_ms:.3f} ms (0-Network)")
    print("═" * 70)

    return {
        "success": bool(max_cap_int > 0),
        "max_capacity": max_cap_int,
        "bare_capacity": bare_cap_int,
        "with_sample_heroes": hero_cap_int,
        "breakdown": max_breakdown,
        "time_ms": t_elapsed_ms,
    }


def test_available_heroes_cli(
    task: BaseTask,
    hero_type: str = "all",
    include_defend: bool = False,
    detailed: bool = True,
    limit: Optional[int] = None,
) -> Dict[str, Any]:
    """فحص واختبار دالة get_available_heroes الجديدة بمطابقتها لسورس كود اللعبة."""
    t0 = time.perf_counter()
    all_heroes = task.get_available_heroes(hero_type="all", include_defend=include_defend, detailed=detailed)
    combat_heroes = task.get_available_heroes(hero_type="combat", include_defend=include_defend, detailed=detailed)
    infantry_heroes = task.get_available_heroes(hero_type="infantry", include_defend=include_defend, detailed=detailed)
    cavalry_heroes = task.get_available_heroes(hero_type="cavalry", include_defend=include_defend, detailed=detailed)
    archer_heroes = task.get_available_heroes(hero_type="archer", include_defend=include_defend, detailed=detailed)
    chariot_heroes = task.get_available_heroes(hero_type="chariots", include_defend=include_defend, detailed=detailed)
    support_heroes = task.get_available_heroes(hero_type="support", include_defend=include_defend, detailed=detailed)

    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    print("\n" + "═" * 70)
    print(" 👑 [Available Heroes Engine] جلب الأبطال المتاحين والشاغرين في القلعة")
    print(f"   • إجمالي الأبطال المتاحين (all)                 : {len(all_heroes)} بطل")
    print(f"   • أبطال القتال والعسكر (combat)               : {len(combat_heroes)} بطل")
    print(f"       - مشاة (Infantry)                          : {len(infantry_heroes)} بطل")
    print(f"       - فرسان (Cavalry)                          : {len(cavalry_heroes)} بطل")
    print(f"       - رماة (Archer)                            : {len(archer_heroes)} بطل")
    print(f"       - عربات (Chariots)                         : {len(chariot_heroes)} بطل")
    print(f"   • أبطال التنمية والدعم (Support/Ancillary)     : {len(support_heroes)} بطل")

    specific_heroes = task.get_available_heroes(hero_type=hero_type, include_defend=include_defend, detailed=detailed, limit=limit)
    if hero_type and hero_type != "all":
        print(f"\n   🎯 الأبطال المتاحون للفئة المطلوبة [{hero_type}] (العدد: {len(specific_heroes)}):")
        for idx, h in enumerate(specific_heroes, start=1):
            if isinstance(h, dict):
                print(f"       {idx}. بطل #{h.get('heroID')} ({h.get('name_ar')}) - نوع: {h.get('type_name_ar')} | Lv.{h.get('level')} | ندرة {h.get('rarity')} | سعة مسيرة: +{h.get('march_num'):,} | نائب: {h.get('own_l')}")
            else:
                print(f"       {idx}. بطل #{h}")
    elif combat_heroes:
        print("\n   ⚔️ أفضل أبطال القتال مرتبين تنازلياً (سورس اللعبة: sortDispatchHerosID):")
        for idx, h in enumerate(combat_heroes[:5], start=1):
            if isinstance(h, dict):
                print(f"       {idx}. بطل #{h.get('heroID')} ({h.get('name_ar')}) - نوع: {h.get('type_name_ar')} | Lv.{h.get('level')} | ندرة {h.get('rarity')} | سعة مسيرة: +{h.get('march_num'):,} | نائب: {h.get('own_l')}")
            else:
                print(f"       {idx}. بطل #{h}")

    print(f"\n   ⚡ زمن الفحص بالذاكرة الحية                    : {t_elapsed_ms:.3f} ms (0-Network)")
    print("═" * 70)

    return {
        "success": True,
        "total_available": len(all_heroes),
        "combat_count": len(combat_heroes),
        "infantry_count": len(infantry_heroes),
        "cavalry_count": len(cavalry_heroes),
        "archer_count": len(archer_heroes),
        "chariot_count": len(chariot_heroes),
        "support_count": len(support_heroes),
        "time_ms": t_elapsed_ms,
    }


# ════════════════════════════════════════════════════════════════════
# 5. الفحص الشامل لجميع المكونات (All-in-One Benchmark)
# ════════════════════════════════════════════════════════════════════

async def run_all_benchmarks(task: BaseTask) -> Dict[str, Any]:
    """تشغيل فحص شامل لكافة خصائص ودوال BaseTask دفعة واحدة وإخراج تقرير تقييمي."""
    print("\n" + "╔" + "═" * 76 + "╗")
    print("║   🚀 بدء الفحص الشامل الميداني لدوال وفئات BaseTask (All-in-One Benchmark)   ║")
    print("╚" + "═" * 76 + "╝")

    t_all_start = time.perf_counter()
    results = {}

    results["properties"] = test_fast_memory_properties(task)
    results["marches"] = test_marches_and_queues(task)
    results["gather_types"] = test_gather_resource_types(task)
    results["ruins_march"] = test_ruins_march(task)
    results["available_troops"] = test_available_troops(task)
    results["single_march_capacity"] = test_single_march_capacity(task)
    results["available_heroes"] = test_available_heroes_cli(task)
    results["stamina_packs"] = test_stamina_packs(task)
    results["lifecycle"] = await test_lifecycle_and_safety(task)
    results["safe_query"] = await test_safe_query_and_jitter(task)

    # تجربة توفير الموارد مع كمية صغيرة لا تضر
    results["ensure_resources"] = await test_resource_provisioning(
        task, resource="wheat", amount=1_000, multiplier=1, force_open=False
    )

    t_all_elapsed = (time.perf_counter() - t_all_start) * 1000

    print("\n" + "╔" + "═" * 76 + "╗")
    print("║                        📋 التقرير النهائي للفحص الشامل                        ║")
    print("╠" + "═" * 76 + "╣")
    print(f"║ {'الاختبار / الدالة':<35} | {'الحالة':<12} | {'زمن التنفيذ (ms)':<20} ║")
    print("╠" + "─" * 76 + "╣")

    all_passed = True
    for key, data in results.items():
        ok = data.get("success", False)
        if not ok:
            all_passed = False
        status_str = "ناجح ✅" if ok else "تنبيه ⚠️"
        t_str = f"{data.get('time_ms', 0):.2f} ms"
        print(f"║ {key:<35} | {status_str:<12} | {t_str:<20} ║")

    print("╠" + "═" * 76 + "╣")
    total_status = "🎉 كافة الاختبارات تمت بنجاح تام!" if all_passed else "⚠️ تمت معظم الاختبارات مع بعض التنبيهات."
    print(f"║ النتيجة العامة: {total_status:<56} ║")
    print(f"║ إجمالي زمن المعالجة: {t_all_elapsed:.2f} ms{'':<50} ║")
    print("╚" + "═" * 76 + "╝\n")

    return {
        "all_passed": all_passed,
        "total_time_ms": t_all_elapsed,
        "details": results,
    }


# ════════════════════════════════════════════════════════════════════
# 5. القائمة التفاعلية في التيرمنال (Interactive Menu)
# ════════════════════════════════════════════════════════════════════

async def run_interactive_menu(current_email: str):
    """تشغيل القائمة التفاعلية في التيرمنال لاختيار الدالة المطلوب فحصها (نمط حي دائم)."""
    task = None
    bot = None
    conn = None

    async def _setup_harness(email: str) -> Tuple[Optional[BaseTask], Any, Any]:
        print(f"\n🌐 جاري الاتصال الحي بالبوابة لحساب: {email} (محاكاة تشغيل البوت العام)...")
        from bot_manager import CastleBot
        import core.database as db
        c_data = db.get_castle_by_id(email)
        pwd = c_data.get("password") if c_data else None
        b = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
        b.is_running = True  # إلزامي لتمكين اتصال البوابة
        ok = await b.connect()
        if not ok or not b.conn:
            print(f"❌ فشل الاتصال بالبوابة للحساب: {email}!")
            return None, None, None
        b.reload_config_from_db()
        print(f"✓ متصل بالبوابة بنجاح! UID={getattr(b.creds, 'uid', 'N/A')} | المملكة={getattr(b.creds, 'kingdom_id', 'N/A')}")
        t = BaseTaskHarness(b.conn, log_func=b.log, config=b.config)
        print("🔄 جاري مزامنة طوابير الفيالق مع السيرفر...")
        await t.sync_local_queues(timeout=3.0)
        await asyncio.sleep(0.5)
        return t, b, b.conn

    try:
        task, bot, conn = await _setup_harness(current_email)
        if not task:
            return

        while True:
            print("\n" + "═" * 70)
            print(f" 🧪 أداة فحص واختبار BaseTask — النمط: [🔴 حي مباشر (Live)] | الحساب: {current_email}")
            print("═" * 70)
            print(" [1] فحص شامل لكافة الخصائص والدوال (All-in-One Benchmark)")
            print(" [2] خصائص الذاكرة الحية (uid, kingdom_id, stamina, gold, resources...)")
            print(" [3] محرك الفيالق والمسيرات (get_max_marches_capacity, active, available...)")
            print(" [4] فحص موارد الجمع النشطة (get_active_gather_resource_types)")
            print(" [5] فحص مسيرات الأطلال (is_ruins_march_active / has_active_ruins_march)")
            print(" [t] فحص القوات الشاغرة بالقلعة واستبعاد حصن الحرب (get_available_troops)")
            print(" [p] فحص حزم وباقات طاقة اللورد بالحقيبة (get_available_stamina_packs)")
            print(" [6] مزامنة طوابير الفيالق مع السيرفر (sync_local_queues)")
            print(" [7] تجربة توفير الموارد وفتح الصناديق (ensure_resources)")
            print(" [8] فحص دورة حياة التنفيذ والحماية (can_run / safe_execute)")
            print(" [9] فحص الاستعلام الآمن والفاصل البشري (safe_query)")
            print(" [c] تغيير الحساب المستهدف")
            print(" [q] خروج")
            print("─" * 70)

            choice = input("👉 اختر رقم الدالة المطلوبة: ").strip().lower()

            if choice in ("q", "exit", "quit"):
                print("👋 تم إنهاء أداة الفحص.")
                break

            elif choice == "1":
                await run_all_benchmarks(task)

            elif choice == "2":
                test_fast_memory_properties(task)

            elif choice == "3":
                test_marches_and_queues(task)

            elif choice == "4":
                test_gather_resource_types(task)

            elif choice == "5":
                test_ruins_march(task)

            elif choice in ("t", "troops", "soldiers", "army"):
                test_available_troops(task)

            elif choice in ("p", "packs", "stamina_packs", "stamina"):
                p_in = input("   أدخل فئة الحزمة (10, 50, 100, total أو اتركه فارغاً للتقرير الشامل): ").strip()
                test_stamina_packs(task, pack_type=p_in if p_in else None)

            elif choice == "6":
                await test_sync_queues(task)

            elif choice == "7":
                res_input = input("   أدخل نوع المورد (food/wood/iron/silver/crystal أو قمح/خشب/حديد/فضة/بلور) [افتراضي: قمح]: ").strip() or "wheat"
                amt_str = input("   أدخل الكمية المطلوبة [افتراضي: 100000]: ").strip() or "100000"
                mult_str = input("   أدخل المضاعف الاحتياطي [افتراضي: 2]: ").strip() or "2"
                force_str = input("   هل تريد فتح إجباري مباشر حتى لو كان الرصيد كافياً؟ (y/N): ").strip().lower()
                force_open = (force_str == "y")
                try:
                    amt = int(amt_str)
                    mult = int(mult_str)
                except ValueError:
                    amt = 100_000
                    mult = 2
                await test_resource_provisioning(task, resource=res_input, amount=amt, multiplier=mult, force_open=force_open)

            elif choice == "8":
                await test_lifecycle_and_safety(task)

            elif choice == "9":
                await test_safe_query_and_jitter(task)

            elif choice == "c":
                accs = get_registered_accounts()
                print("\nالحسابات المتاحة:")
                for i, acc in enumerate(accs, 1):
                    act_badge = "نشط" if acc["is_active"] else "معطل"
                    print(f"   [{i}] {acc['email']} ({acc['castle_name']}) - [{act_badge}]")
                c_idx = input("👉 اختر رقم الحساب: ").strip()
                if c_idx.isdigit() and 1 <= int(c_idx) <= len(accs):
                    current_email = accs[int(c_idx) - 1]["email"]
                    if bot and bot.conn:
                        await bot.conn.close()
                    task, bot, conn = await _setup_harness(current_email)

            else:
                print("⚠️ خيار غير معروف، يرجى الاختيار من القائمة.")

    finally:
        if bot and bot.conn:
            try:
                await bot.conn.close()
            except Exception:
                pass


# ════════════════════════════════════════════════════════════════════
# 6. نقطة الدخول الرئيسية للسكريبت (CLI Entrypoint)
# ════════════════════════════════════════════════════════════════════

async def main_async():
    parser = argparse.ArgumentParser(
        description="أداة فحص واختبار دوال وفئات BaseTask الشاملة (Revenge of Sultans)",
        formatter_class=argparse.RawTextHelpFormatter,
    )

    # خيارات البيئة والاتصال
    parser.add_argument("--live", action="store_true", default=True, help="تشغيل في النمط الحي (Live) بالاتصال المباشر بالبوابة (الافتراضي دائماً)")
    parser.add_argument("--email", type=str, default=None, help="بريد حساب القلعة المراد اختباره")

    # خيارات الاختبارات
    parser.add_argument("command", nargs="?", default=None, help="اسم الاختبار السريع (all, properties, marches, gather, ruins, sync, ensure_resources, lifecycle)")
    parser.add_argument("--fn", type=str, default=None, help="اسم الدالة أو الخاصية المراد فحصها تحديداً")
    parser.add_argument("--skill", "--skill-id", dest="skill", type=str, default=None, help="معرف أو اسم المهارة المراد فحصها (مثل 12008 أو 'حصاد وافر')")
    parser.add_argument("--pack", "--pack-type", dest="pack", type=str, default=None, help="نوع أو فئة حزمة الطاقة المراد فحصها (10, 50, 100, total, all...)")
    parser.add_argument("--heroes", "--hero", dest="heroes", type=str, default=None, help="قائمة معرفات الأبطال مفصولة بفواصل لحساب سعة المسيرة (مثل 1712,1706)")
    parser.add_argument("--breakdown", "-b", "--detail", action="store_true", help="طلب تفصيل شامل لمصادر سعة المسيرة (ميدان العرض، أبحاث، بافات، أبطال)")
    parser.add_argument("--all", action="store_true", help="تشغيل الفحص الشامل الميداني (All-in-One Benchmark)")
    parser.add_argument("-i", "--interactive", action="store_true", help="فتح القائمة التفاعلية في التيرمنال")

    # معاملات دالة ensure_resources
    parser.add_argument("--resource", type=str, default="wheat", help="نوع المورد المطلوب توفيره (قمح, خشب, حديد, فضة, بلور)")
    parser.add_argument("--amount", type=int, default=100_000, help="الكمية المطلوبة لتوفير الموارد")
    parser.add_argument("--multiplier", type=int, default=2, help="مضاعف الاحتياط لتوفير الموارد (افتراضياً 2x)")
    parser.add_argument("--force-open", action="store_true", help="فتح الصناديق إجبارياً حتى لو كان الرصيد كافياً")

    # معاملات فحص الأبطال (get_available_heroes)
    parser.add_argument("--type", "--hero-type", "-t", dest="hero_type", type=str, default="all", help="نوع الأبطال المراد جلبه (combat, infantry, cavalry, archer, chariots, support, all)")
    parser.add_argument("--include-defend", dest="include_defend", action="store_true", help="تضمين حماة السور مع الأبطال المتاحين")
    parser.add_argument("--limit", "-l", dest="limit", type=int, default=None, help="الحد الأقصى لعدد الأبطال المطلوب إرجاعه")

    args = parser.parse_args()

    # تحديد الحساب المستهدف (دائماً في النمط الحي المباشر)
    target_email = args.email or get_default_account_email()

    # إذا تم تمرير دالة محددة بـ --fn، يُطلب حصراً طباعة ناتجها المباشر فقط بدون أي سجلات أو نصوص إضافية
    if args.fn:
        fn_name = args.fn.strip()
        logging.disable(logging.CRITICAL)
        bot_fn = None
        res_fn = None
        f_silent = io.StringIO()
        with contextlib.redirect_stdout(f_silent), contextlib.redirect_stderr(f_silent):
            from bot_manager import CastleBot
            import core.database as db
            c_data = db.get_castle_by_id(target_email)
            pwd = c_data.get("password") if c_data else None
            bot_fn = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
            bot_fn.is_running = True
            ok = await bot_fn.connect()
            if not ok or not bot_fn.conn:
                return
            bot_fn.reload_config_from_db()
            task = BaseTaskHarness(bot_fn.conn, log_func=lambda m: None, config=bot_fn.config)
            if any(k in fn_name.lower() for k in ("march", "queue", "gather", "ruin")):
                await task.sync_local_queues(timeout=3.0)
                if "capacity" in fn_name.lower() and hasattr(task, "sync_achievements"):
                    await task.sync_achievements(timeout=3.0)
                await asyncio.sleep(0.5)

            if fn_name.lower() in ("march_capacity", "single_march", "test_single_march_capacity"):
                res_fn = test_single_march_capacity(task)
            elif hasattr(task, fn_name):
                attr = getattr(task, fn_name)
                if callable(attr):
                    is_async = asyncio.iscoroutinefunction(attr)
                    try:
                        sig = inspect.signature(attr)
                        params = [p for p in sig.parameters.values() if p.default == inspect.Parameter.empty and p.kind in (inspect.Parameter.POSITIONAL_ONLY, inspect.Parameter.POSITIONAL_OR_KEYWORD)]
                    except Exception:
                        params = []

                    # إذا كانت الدالة هي get_lord_skill_status أو تتطلب معامل المهارة
                    if fn_name.lower() in ("march_capacity", "single_march", "test_single_march_capacity"):
                        res_fn = test_single_march_capacity(task)
                    elif fn_name.lower() == "get_max_march_capacity":
                        breakdown_flag = any(a in ("--breakdown", "-b", "--detail") for a in sys.argv)
                        heroes_arg: Any = None
                        for idx_a, a in enumerate(sys.argv):
                            if a in ("--heroes", "--hero") and idx_a + 1 < len(sys.argv):
                                val_raw = sys.argv[idx_a + 1].strip()
                                if val_raw.lower() in ("none", "bare", "0", "false"):
                                    heroes_arg = "none"
                                elif val_raw.isdigit() and int(val_raw) <= 5:
                                    heroes_arg = int(val_raw)
                                else:
                                    heroes_arg = [h.strip() for h in val_raw.split(",") if h.strip()]
                        need_avail = any(a in ("--available", "--need-available") for a in sys.argv)
                        res_fn = task.get_max_march_capacity(heroes=heroes_arg, breakdown=breakdown_flag, need_available=need_avail)
                    elif "skill" in fn_name.lower():
                        res_fn = await attr(args.skill) if is_async else attr(args.skill)
                    elif any(k in fn_name.lower() for k in ("boost", "speedup")):
                        res_arg = args.resource if any(a.startswith("--resource") for a in sys.argv) else None
                        res_fn = await attr(res_arg) if is_async else attr(res_arg)
                    elif any(k in fn_name.lower() for k in ("stamina_pack", "stamina_packs")):
                        pack_arg = args.pack if any(a.startswith(("--pack", "--pack-type")) for a in sys.argv) else None
                        res_fn = await attr(pack_arg) if is_async else attr(pack_arg)
                    elif any(k in fn_name.lower() for k in ("available_hero", "get_available_heroes")):
                        res_fn = task.get_available_heroes(
                            hero_type=args.hero_type or "all",
                            include_defend=args.include_defend,
                            detailed=args.breakdown,
                            limit=args.limit,
                        )
                    elif len(params) > 0:
                        res_fn = await attr(args.skill) if is_async else attr(args.skill)
                    else:
                        res_fn = await attr() if is_async else attr()
                else:
                    res_fn = attr

            if bot_fn and bot_fn.conn:
                await bot_fn.conn.close()

        # طباعة قيمة الدالة بتنسيق JSON نظيف إذا كانت قاموساً أو مصفوفة
        if isinstance(res_fn, (dict, list)):
            print(json.dumps(res_fn, ensure_ascii=False, indent=2))
        else:
            print(res_fn)
        return

    # تحديد اسم العملية المطلوبة
    cmd = (args.command or "").strip().lower()

    # إذا تم طلب الوضع التفاعلي أو لم يتم تمرير أي أمر أو دالة
    if args.interactive or (not args.all and not cmd):
        await run_interactive_menu(target_email)
        return

    # تجهيز كائن المهمة للاختبار المباشر من سطر الأوامر (نمط حي دائم)
    bot = None
    conn = None

    print(f"🌐 [Live Mode] جاري الاتصال بحساب القلعة: {target_email} (محاكاة تشغيل البوت العام)...")
    from bot_manager import CastleBot
    import core.database as db
    c_data = db.get_castle_by_id(target_email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True  # إلزامي لتمكين اتصال البوابة
    ok = await bot.connect()
    if not ok or not bot.conn:
        print(f"❌ فشل الاتصال بالبوابة لحساب: {target_email}")
        return
    bot.reload_config_from_db()
    conn = bot.conn
    print(f"✓ متصل بالبوابة بنجاح! UID={getattr(bot.creds, 'uid', 'N/A')} | المملكة={getattr(bot.creds, 'kingdom_id', 'N/A')}")
    cfg = bot.config
    task = BaseTaskHarness(conn, log_func=bot.log, config=cfg)
    print("🔄 جاري مزامنة طوابير الفيالق مع السيرفر...")
    await task.sync_local_queues(timeout=3.0)
    await asyncio.sleep(0.5)

    try:
        if args.all or cmd in ("all", "benchmark", "full"):
            await run_all_benchmarks(task)

        elif cmd in ("properties", "props", "info", "memory"):
            test_fast_memory_properties(task)

        elif cmd in ("marches", "queues", "march", "capacity"):
            test_marches_and_queues(task)

        elif cmd in ("gather", "gather_types", "resources_gather"):
            test_gather_resource_types(task)

        elif cmd in ("ruins", "ruins_march", "ruin"):
            test_ruins_march(task)

        elif cmd in ("troops", "soldiers", "army", "available_troops", "get_available_troops"):
            test_available_troops(task)

        elif cmd in ("sync", "sync_queues", "sync_local_queues"):
            await test_sync_queues(task)

        elif cmd in ("ensure_resources", "resources", "boxes", "open_boxes"):
            await test_resource_provisioning(
                task,
                resource=args.resource,
                amount=args.amount,
                multiplier=args.multiplier,
                force_open=args.force_open,
            )

        elif cmd in ("lifecycle", "can_run", "safe_execute"):
            await test_lifecycle_and_safety(task)

        elif cmd in ("safe_query", "query", "jitter"):
            await test_safe_query_and_jitter(task)

        elif cmd in ("command_hall", "cmd_hall", "get_command_hall_tasks", "commandhall"):
            await test_command_hall_inspection(task, force_sync=getattr(args, "live", False))

        elif cmd in ("command_hall_battle", "battle", "test_battle", "battle_task"):
            await test_command_hall_battle(task)

        elif cmd in ("command_hall_snipe", "snipe", "sniper", "test_snipe", "snipe_task"):
            await test_command_hall_snipe(task)

        elif cmd in ("command_hall_rescue", "rescue", "rescue_task", "test_rescue"):
            await test_command_hall_rescue(task)

        elif cmd in ("command_hall_dialogue", "dialogue", "dialogue_task", "test_dialogue"):
            await test_command_hall_dialogue(task)

        elif cmd in ("stamina_packs", "stamina_pack", "get_available_stamina_packs", "packs", "stamina_boxes"):
            test_stamina_packs(task, pack_type=args.pack)

        elif cmd in ("single_march", "march_capacity", "get_max_march_capacity", "max_march", "march_size", "march_limit"):
            test_single_march_capacity(task)

        elif cmd in ("heroes", "available_heroes", "get_available_heroes"):
            test_available_heroes_cli(
                task,
                hero_type=args.hero_type or "all",
                include_defend=args.include_defend,
                detailed=True,
                limit=args.limit,
            )

        elif hasattr(task, cmd):
            # فحص مرن لأي دالة أو خاصية أخرى في BaseTask
            attr = getattr(task, cmd)
            print(f"\n🔍 فحص العنصر `{cmd}` في BaseTask:")
            if callable(attr):
                is_async = asyncio.iscoroutinefunction(attr)
                res = await attr() if is_async else attr()
                print(f"   • ناتج الاستدعاء: {res}")
            else:
                print(f"   • القيمة المباشرة: {attr}")

            # تفاصيل إضافية مساعدة للمطور إذا كان الفحص يخص الفيالق والمسيرات
            if "march" in cmd or "queue" in cmd:
                act = int(task.get_active_marches_count())
                max_c = int(task.get_max_marches_capacity())
                avail = int(task.get_available_marches_count())
                print(f"\n📊 تفاصيل حالة الفيالق اللحظية للقلعة:")
                print(f"   • الفيالق النشطة بالخارج : {act}")
                print(f"   • الفيالق الشاغرة للإرسال: {avail}")
                print(f"   • السعة القصوى المسموحة : {max_c}")
                if act == 0:
                    print("   💡 ملاحظة: لا توجد أي جيوش أو فيالق خارج القلعة حالياً (جميع الجيوش مرابطة داخل القلعة وجاهزة).")
                else:
                    queues = task._read_live_local_queues(task.conn)
                    for i, q in enumerate(queues, 1):
                        to_name = q.get('to', {}).get('name', 'غير محدد') if isinstance(q.get('to'), dict) else 'غير محدد'
                        print(f"   • فيلق #{i}: الهدف={to_name} | الحالة={q.get('status')} | معرف={q.get('id')}")

        else:
            print(f"❌ أمر غير معروف: `{cmd}`")
            print("   الأوامر المتاحة: all, properties, marches, gather, ruins, sync, ensure_resources, lifecycle, safe_query")

    finally:
        if bot and bot.conn:
            await bot.conn.close()


def main():
    asyncio.run(main_async())


if __name__ == "__main__":
    main()
