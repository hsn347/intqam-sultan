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

أنماط التشغيل المدعومة:
  - نمط حي حقيقي (Live Mode - الافتراضي): يتصل مباشرة بالبوابة الرسمية للحساب عبر CastleBot (مطابق لتشغيل البوت العام من الواجهة).
  - نمط محلي آمن (Offline Mode): يعتمد على ملفات تفريغ الذاكرة الحية في مجلد docs/ (0-Network) عند تمرير --offline صراحة.

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

from tasks.base_task import BaseTask, TaskResult, RESOURCE_CATALOG, RESOURCE_KEY_MAP


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
# 2. محاكي الاتصال المحلي (Offline Mock Connection)
# ════════════════════════════════════════════════════════════════════

class OfflineMockConnection:
    """
    محاكي اتصال يعتمد على ملف الذاكرة الحية المحلي للاختبار السريع (0-Network).
    يدعم محاكاة استهلاك الصناديق وتحديث الموارد بالذاكرة محلياً.
    """
    def __init__(self, init_data: Dict[str, Any], email: str = "offline@bot.com"):
        self.init_data = init_data
        self.email = email
        self.is_connected = True

        # استخراج بيانات اللورد والقلعة
        lord = self.init_data.get("lordInfoCtrl", {})
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        uid = str(base.get("uid") or "31596828")
        kid = int(base.get("lastKid") or 614)
        server_name = f"OfflineKingdom_{kid}"

        self.creds = type("MockCreds", (), {
            "uid": uid,
            "kingdom_id": kid,
            "server_name": server_name,
            "user_id": uid,
        })()

        # استخراج طوابير الفيالق إن وجدت
        self.local_queues = self.init_data.get("local_queues", [])
        self.other_local_queues = self.init_data.get("other_local_queues", [])

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        val = self.init_data.get(name, {})
        return val if isinstance(val, dict) else {}

    async def query(self, cmd: str, subcmd: str, data: Optional[Dict[str, Any]] = None, timeout: float = 5.0) -> Dict[str, Any]:
        """محاكاة استعلام الشبكة المحلي مع معالجة منطق فتح الصناديق محلياً."""
        payload = data or {}
        # محاكاة استخدام الصناديق في الحقيبة (CMD 1004 / SubCMD 2)
        if cmd == "1004" and subcmd == "2":
            item_id = str(payload.get("itemID", ""))
            count = int(payload.get("count", 1))
            backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
            entry = backpack.get(item_id) or backpack.get(int(item_id) if item_id.isdigit() else 0)
            if entry and isinstance(entry, dict):
                cur_count = int(entry.get("count", 0))
                entry["count"] = max(0, cur_count - count)
            return {"err": 0, "data": {"status": "ok", "mock_consumed": True}}

        # محاكاة مزامنة الفيالق (CMD 1007 / SubCMD 1000)
        if cmd == "1007" and subcmd == "1000":
            return {"err": 0, "data": {"status": "synced"}}

        return {"err": 0, "data": {}}

    async def close(self):
        self.is_connected = False


# ════════════════════════════════════════════════════════════════════
# 3. مساعدات قراءة الحسابات وملفات الذاكرة
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


def find_memory_dump_file(target_account: Optional[str] = None) -> Optional[str]:
    """العثور على أنسب ملف تفريغ ذاكرة حية محلي."""
    candidates = []
    if target_account:
        name_prefix = target_account.split("@")[0].lower()
        candidates.extend([
            os.path.join(DOCS_DIR, f"{name_prefix}_live_memory.json"),
            os.path.join(WORKSPACE_DIR, "scratch", f"init_{name_prefix.upper()}.json"),
        ])

    candidates.extend([
        os.path.join(DOCS_DIR, "lucifer_live_memory.json"),
        os.path.join(DOCS_DIR, "beetoo1_live_memory.json"),
        os.path.join(DOCS_DIR, "beetoo3_live_memory.json"),
        os.path.join(DOCS_DIR, "sample_live_memory.json"),
        os.path.join(WORKSPACE_DIR, "scratch", "init_LUCIFER.json"),
    ])

    for p in candidates:
        if os.path.exists(p):
            return p
    return None


# ════════════════════════════════════════════════════════════════════
# 4. دوال فحص واختبار BaseTask المحددة
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
    t_elapsed_ms = (time.perf_counter() - t0) * 1000

    # إحصائيات الأفخاخ المستبعدة لحصن الحرب (800..899)
    fortress_count = sum(v for k, v in all_units.items() if 800 <= k <= 899)

    # تصنيف القوات المتاحة حسب الصنف الرسمي للعبة
    type_names = {
        4: "🛡️ مشاة (Infantry)",
        5: "🐎 خيالة (Cavalry)",
        6: "🏹 رماة (Archers)",
        7: "🚜 عربات (Chariots)",
        9: "⭐ نخبة (Elite)",
    }
    categorized: Dict[str, int] = {}
    for uid, cnt in troops_dict.items():
        cat_key = type_names.get(uid // 100, f"وحدات ({uid // 100})")
        categorized[cat_key] = categorized.get(cat_key, 0) + cnt

    print("\n" + "═" * 70)
    print(" ⚔️ [Available Troops] القوات والجنود الشاغرين في القلعة (0-Network)")
    print("═" * 70)
    print(f"   • إجمالي الجنود المتاحين والشاغرين : {total_count:,} جندي (Property: {prop_count:,})")
    print(f"   • وحدات حصن الحرب المستبعدة (الأفخاخ) : {fortress_count:,} فخ (ID: 800..899)")
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
        "troops_list": troops_list,
        "categorized": categorized,
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
# 6. القائمة التفاعلية في التيرمنال (Interactive Menu)
# ════════════════════════════════════════════════════════════════════

async def run_interactive_menu(current_email: str, is_live: bool, memory_file: Optional[str] = None):
    """تشغيل القائمة التفاعلية في التيرمنال لاختيار الدالة المطلوب فحصها."""
    task = None
    bot = None
    conn = None

    async def _setup_harness(live_mode: bool, email: str, mem_path: Optional[str]) -> Tuple[BaseTask, Any, Any]:
        if live_mode:
            print(f"\n🌐 جاري الاتصال الحي بالبوابة لحساب: {email} (محاكاة تشغيل البوت العام)...")
            from bot_manager import CastleBot
            import core.database as db
            c_data = db.get_castle_by_id(email)
            pwd = c_data.get("password") if c_data else None
            b = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
            b.is_running = True  # إلزامي لتمكين اتصال البوابة
            ok = await b.connect()
            if not ok or not b.conn:
                print(f"❌ فشل الاتصال بالبوابة للحساب: {email}! سيتم التحويل للنمط المحلي.")
                return await _setup_harness(False, email, mem_path)
            b.reload_config_from_db()
            print(f"✓ متصل بالبوابة بنجاح! UID={getattr(b.creds, 'uid', 'N/A')} | المملكة={getattr(b.creds, 'kingdom_id', 'N/A')}")
            t = BaseTaskHarness(b.conn, log_func=b.log, config=b.config)
            print("🔄 جاري مزامنة طوابير الفيالق مع السيرفر...")
            await t.sync_local_queues(timeout=3.0)
            await asyncio.sleep(0.5)
            return t, b, b.conn
        else:
            path = mem_path or find_memory_dump_file(email)
            print(f"\n⚡ جاري تجهيز النمط المحلي (Offline) من الملف: {path}...")
            if not path or not os.path.exists(path):
                raise FileNotFoundError(f"لم يتم العثور على ملف ذاكرة حية محلي ({path})!")
            with open(path, "r", encoding="utf-8") as f:
                dump = json.load(f)
            c = OfflineMockConnection(dump, email=email)
            t = BaseTaskHarness(c, log_func=lambda m: print(f"   [Offline Log] {m}"))
            print(f"✓ تم تجهيز الذاكرة الحية المحلية بنجاح ({len(dump)} متحكم).")
            return t, None, c

    try:
        task, bot, conn = await _setup_harness(is_live, current_email, memory_file)

        while True:
            mode_badge = "🔴 حي (Live)" if is_live else "🟢 محلي (Offline)"
            print("\n" + "═" * 70)
            print(f" 🧪 أداة فحص واختبار BaseTask — النمط: [{mode_badge}] | الحساب: {current_email}")
            print("═" * 70)
            print(" [1] فحص شامل لكافة الخصائص والدوال (All-in-One Benchmark)")
            print(" [2] خصائص الذاكرة الحية (uid, kingdom_id, stamina, gold, resources...)")
            print(" [3] محرك الفيالق والمسيرات (get_max_marches_capacity, active, available...)")
            print(" [4] فحص موارد الجمع النشطة (get_active_gather_resource_types)")
            print(" [5] فحص مسيرات الأطلال (is_ruins_march_active / has_active_ruins_march)")
            print(" [t] فحص القوات الشاغرة بالقلعة واستبعاد حصن الحرب (get_available_troops)")
            print(" [6] مزامنة طوابير الفيالق مع السيرفر (sync_local_queues)")
            print(" [7] تجربة توفير الموارد وفتح الصناديق (ensure_resources)")
            print(" [8] فحص دورة حياة التنفيذ والحماية (can_run / safe_execute)")
            print(" [9] فحص الاستعلام الآمن والفاصل البشري (safe_query)")
            print(" [0] تبديل نمط التشغيل (Live ⮂ Offline)")
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

            elif choice == "0":
                is_live = not is_live
                print(f"🔄 جاري التحويل إلى النمط {'الحي (Live)' if is_live else 'المحلي (Offline)'}...")
                if bot and bot.conn:
                    await bot.conn.close()
                task, bot, conn = await _setup_harness(is_live, current_email, memory_file)

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
                    task, bot, conn = await _setup_harness(is_live, current_email, memory_file)

            else:
                print("⚠️ خيار غير معروف، يرجى الاختيار من القائمة.")

    finally:
        if bot and bot.conn:
            try:
                await bot.conn.close()
            except Exception:
                pass


# ════════════════════════════════════════════════════════════════════
# 7. نقطة الدخول الرئيسية للسكريبت (CLI Entrypoint)
# ════════════════════════════════════════════════════════════════════

async def main_async():
    parser = argparse.ArgumentParser(
        description="أداة فحص واختبار دوال وفئات BaseTask الشاملة (Revenge of Sultans)",
        formatter_class=argparse.RawTextHelpFormatter,
    )

    # خيارات البيئة والاتصال
    parser.add_argument("--live", action="store_true", help="تشغيل في النمط الحي (Live) بالاتصال المباشر بالبوابة (الافتراضي)")
    parser.add_argument("--offline", action="store_true", help="تشغيل في النمط المحلي الآمن (Offline) بدون شبكة عبر تفريغ الذاكرة")
    parser.add_argument("--email", type=str, default=None, help="بريد حساب القلعة المراد اختباره")
    parser.add_argument("--memory-file", type=str, default=None, help="مسار مخصص لملف الذاكرة الحية JSON")

    # خيارات الاختبارات
    parser.add_argument("command", nargs="?", default=None, help="اسم الاختبار السريع (all, properties, marches, gather, ruins, sync, ensure_resources, lifecycle)")
    parser.add_argument("--fn", type=str, default=None, help="اسم الدالة أو الخاصية المراد فحصها تحديداً")
    parser.add_argument("--all", action="store_true", help="تشغيل الفحص الشامل الميداني (All-in-One Benchmark)")
    parser.add_argument("-i", "--interactive", action="store_true", help="فتح القائمة التفاعلية في التيرمنال")

    # معاملات دالة ensure_resources
    parser.add_argument("--resource", type=str, default="wheat", help="نوع المورد المطلوب توفيره (قمح, خشب, حديد, فضة, بلور)")
    parser.add_argument("--amount", type=int, default=100_000, help="الكمية المطلوبة لتوفير الموارد")
    parser.add_argument("--multiplier", type=int, default=2, help="مضاعف الاحتياط لتوفير الموارد (افتراضياً 2x)")
    parser.add_argument("--force-open", action="store_true", help="فتح الصناديق إجبارياً حتى لو كان الرصيد كافياً")

    args = parser.parse_args()

    # تحديد نمط التشغيل: الافتراضي هو النمط الحي المباشر (Live) محاكاة لتشغيل البوت من الواجهة
    is_live = not args.offline
    target_email = args.email or get_default_account_email()

    # إذا تم تمرير دالة محددة بـ --fn، يُطلب حصراً طباعة ناتجها المباشر فقط بدون أي سجلات أو نصوص إضافية
    if args.fn:
        fn_name = args.fn.strip()
        logging.disable(logging.CRITICAL)
        bot_fn = None
        res_fn = None
        f_silent = io.StringIO()
        with contextlib.redirect_stdout(f_silent), contextlib.redirect_stderr(f_silent):
            if is_live:
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
                    await asyncio.sleep(0.5)
            else:
                mem_file = args.memory_file or find_memory_dump_file(target_email)
                if not mem_file or not os.path.exists(mem_file):
                    return
                with open(mem_file, "r", encoding="utf-8") as f:
                    dump = json.load(f)
                conn = OfflineMockConnection(dump, email=target_email)
                task = BaseTaskHarness(conn, log_func=lambda m: None)

            if hasattr(task, fn_name):
                attr = getattr(task, fn_name)
                if callable(attr):
                    is_async = asyncio.iscoroutinefunction(attr)
                    res_fn = await attr() if is_async else attr()
                else:
                    res_fn = attr

            if bot_fn and bot_fn.conn:
                await bot_fn.conn.close()

        # طباعة قيمة الدالة فقط بدون أي زيادة
        print(res_fn)
        return

    # تحديد اسم العملية المطلوبة
    cmd = (args.command or "").strip().lower()

    # إذا تم طلب الوضع التفاعلي أو لم يتم تمرير أي أمر أو دالة
    if args.interactive or (not args.all and not cmd):
        await run_interactive_menu(target_email, is_live, args.memory_file)
        return

    # تجهيز كائن المهمة للاختبار المباشر من سطر الأوامر
    bot = None
    conn = None

    if is_live:
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
    else:
        mem_file = args.memory_file or find_memory_dump_file(target_email)
        if not mem_file or not os.path.exists(mem_file):
            print(f"❌ تعذر العثور على ملف ذاكرة حية محلي ({mem_file})!")
            return
        print(f"⚡ [Offline Mode] قراءة الذاكرة الحية من: {mem_file}...")
        with open(mem_file, "r", encoding="utf-8") as f:
            dump = json.load(f)
        conn = OfflineMockConnection(dump, email=target_email)
        task = BaseTaskHarness(conn, log_func=lambda m: print(f"   [Task Log] {m}"))

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
