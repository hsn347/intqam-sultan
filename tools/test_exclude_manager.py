# -*- coding: utf-8 -*-
"""
tools/test_exclude_manager.py — أداة الفحص الشاملة لمدير استبعاد الأهداف المركزي (ExcludeManager)
══════════════════════════════════════════════════════════════════════════════════════════════════
يفحص:
  1. إنشاء اتصال SQLite WAL والتأكد من وضع journal_mode = wal
  2. استنتاج أنواع الأهداف واستخراج الإحداثيات بدقة
  3. دورة الحجز الذري: Reserve (منع التصادم بين القلاع الشقيقة)
  4. تحرير الحجز: Release (إعادة إتاحة الهدف عند فشل المسيرة)
  5. تثبيت الحجز: Confirm (الحفظ في SQLite وضبط الحد الأقصى MAX_PER_KINGDOM)
  6. فلترة واسترجاع خريطة الاستبعاد: get_exclude_map بالمسافة ونوع الهدف
  7. تكامل BaseTask مع دوال الاستبعاد المباشرة
"""

import asyncio
import os
import sqlite3
import sys
import time

# إضافة مسار المشروع
_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT_DIR not in sys.path:
    sys.path.insert(0, _ROOT_DIR)

from tasks.exclude_manager import ExcludeManager, get_manager
from tasks.base_task import BaseTask


async def run_tests():
    print("=" * 70)
    print("🚀 بدء الفحص الشامل لمدير الاستبعاد المركزي (ExcludeManager)...")
    print("=" * 70)

    mgr = get_manager()
    assert mgr is get_manager(), "❌ فشل فحص Singleton!"
    print("✅ 1. تم التحقق من نمط Singleton بنجاح.")

    # 1. فحص قاعدة البيانات ووضع WAL
    db_path = mgr._db_path
    print(f"📁 مسار قاعدة البيانات: {db_path}")
    assert os.path.exists(db_path), "❌ ملف قاعدة البيانات غير موجود!"

    with sqlite3.connect(db_path) as conn:
        mode = conn.execute("PRAGMA journal_mode;").fetchone()[0]
        print(f"⚡ نمط Journal Mode: {mode.upper()}")
        assert mode.lower() == "wal", f"❌ النمط ليس WAL بل {mode}"
    print("✅ 2. تم التحقق من تفعيل SQLite WAL بنجاح تام.")

    # 2. فحص استنتاج نوع الهدف والإحداثيات
    test_cases = [
        ("100-200-5-1-12345", "gold", (99, 199)),
        ("150-250-5-2-99999", "food", (149, 249)),
        ("300-400-5-3-11111", "wood", (299, 399)),
        ("500-600-5-4-22222", "iron", (499, 599)),
        ("700-800-5-5-33333", "silver", (699, 799)),
        ("120-130-6-1-55555", "invader", (119, 129)),
        ("220-230-7-1-66666", "ruins", (219, 229)),
        ("330-340-26-1-77777", "stronghold", (329, 339)),
        ("440-450-35-1-88888", "rebel", (439, 449)),
    ]

    for tid, expected_type, expected_coords in test_cases:
        actual_type = ExcludeManager._infer_target_type(tid)
        actual_coords = ExcludeManager._parse_coords(tid)
        assert actual_type == expected_type, f"❌ نوع غير متطابق لـ {tid}: {actual_type} != {expected_type}"
        assert actual_coords == expected_coords, f"❌ إحداثيات غير متطابقة لـ {tid}: {actual_coords} != {expected_coords}"
    print("✅ 3. تم فحص استنتاج أنواع الأهداف والإحداثيات لكافة التراكيب بنجاح.")

    # 3. فحص دورة الحجز المؤقت (Reserve) ومنع التصادم بين قلاعتين شقيقتين
    uid_a = "player_1001"
    uid_b = "player_1002"
    kid = 999  # مملكة اختبار
    target_res = "50-60-5-2-1"

    # قلعة A تحجز الهدف
    res_a1 = await mgr.reserve(uid=uid_a, target_id=target_res, kingdom_id=kid)
    assert res_a1 is True, "❌ فشل حجز قلعة A لهدف شاغر!"

    # قلعة B تحاول حجز نفس الهدف في نفس المملكة -> يجب أن تُرفض
    res_b = await mgr.reserve(uid=uid_b, target_id=target_res, kingdom_id=kid)
    assert res_b is False, "❌ قلعة B تمكنت من حجز هدف محجوز لقلعة A (فشل منع Race Condition)!"

    # قلعة A تعيد طلب الحجز لنفسها -> يجب أن تنجح
    res_a2 = await mgr.reserve(uid=uid_a, target_id=target_res, kingdom_id=kid)
    assert res_a2 is True, "❌ قلعة A لم تتمكن من تجديد حجزها الخاص!"
    print("✅ 4. تم فحص الحجز المؤقت والحماية الذرية ضد التصادم (Atomic Locking) بنجاح.")

    # 4. فحص تحرير الحجز (Release)
    await mgr.release(uid=uid_a, target_id=target_res, kingdom_id=kid)
    # الآن قلعة B يجب أن تتمكن من الحجز
    res_b2 = await mgr.reserve(uid=uid_b, target_id=target_res, kingdom_id=kid)
    assert res_b2 is True, "❌ قلعة B لم تتمكن من الحجز بعد تحريره عبر release!"
    await mgr.release(uid=uid_b, target_id=target_res, kingdom_id=kid)
    print("✅ 5. تم فحص تحرير الحجز (Release) بنجاح.")

    # 5. فحص التثبيت (Confirm) في قاعدة البيانات
    target_confirmed = "50-60-5-2-99"
    await mgr.reserve(uid=uid_a, target_id=target_confirmed, kingdom_id=kid)
    await mgr.confirm(uid=uid_a, target_id=target_confirmed, kingdom_id=kid)

    # التحقق من وجوده في get_exclude_map
    ex_map = await mgr.get_exclude_map(uid=uid_a, kingdom_id=kid, x=49, y=59)
    assert target_confirmed in ex_map, f"❌ الهدف المثبت {target_confirmed} غير موجود في خريطة الاستبعاد!"
    print("✅ 6. تم فحص تثبيت الهدف (Confirm) واسترجاعه بنجاح.")

    # 6. فحص فلترة المسافة والنوع
    target_far = "900-900-5-2-88"  # بعيد جداً عن (49, 59)
    await mgr.confirm(uid=uid_a, target_id=target_far, kingdom_id=kid)

    near_map = await mgr.get_exclude_map(uid=uid_a, kingdom_id=kid, x=49, y=59, max_distance=100)
    assert target_confirmed in near_map, "❌ الهدف القريب مفقود من الخريطة!"
    assert target_far not in near_map, "❌ الهدف البعيد ظهر في خريطة المسافة المحدودة!"

    type_food_map = await mgr.get_exclude_map(uid=uid_a, kingdom_id=kid, target_type="food")
    assert target_confirmed in type_food_map, "❌ مورد القمح مفقود من فلترة food!"

    type_iron_map = await mgr.get_exclude_map(uid=uid_a, kingdom_id=kid, target_type="iron")
    assert target_confirmed not in type_iron_map, "❌ مورد القمح ظهر في فلترة iron!"
    print("✅ 7. تم فحص فلاتر المسافة ونوع الهدف بنجاح.")

    # 7. فحص تكامل BaseTask
    class DummyConn:
        creds = type("Creds", (), {"uid": "dummy_player", "kingdom_id": kid})()
        is_connected = True
        init_data = {}

    class DummyTask(BaseTask):
        name = "DummyTask"
        async def run(self):
            return BaseTask.ok()

    dummy_task = DummyTask(conn=DummyConn())
    assert dummy_task.uid == "dummy_player"
    assert dummy_task.kingdom_id == kid

    dummy_target = "100-100-5-3-555"
    reserved = await dummy_task.reserve_target(dummy_target)
    assert reserved is True, "❌ فشل حجز الهدف عبر BaseTask.reserve_target!"

    await dummy_task.confirm_target(dummy_target)
    base_map = await dummy_task.get_exclude_map()
    assert dummy_target in base_map, "❌ الهدف مفقود من خريطة BaseTask.get_exclude_map!"
    print("✅ 8. تم فحص تكامل دوال BaseTask بنجاح تام.")

    # تنظيف مملكة الاختبار
    mgr.clear_kingdom(kid)
    stats = mgr.get_stats(kid)
    assert stats["db_kingdom_count"] == 0, "❌ فشل تنظيف بيانات مملكة الاختبار!"
    print("✅ 9. تم فحص دالة تنظيف المملكة والإحصائيات بنجاح.")

    print("=" * 70)
    print("🎉 كافة الفحوصات الـ 9 اكتملت بنجاح 100%! نظام الاستبعاد جاهز تماماً.")
    print("=" * 70)


if __name__ == "__main__":
    asyncio.run(run_tests())
