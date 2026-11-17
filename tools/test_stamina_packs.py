# -*- coding: utf-8 -*-
"""
tools/test_stamina_packs.py
----------------------------
اختبارات شاملة ومستقلة لحزم وباقات طاقة اللورد (Stamina Packs) في BaseTask:
1. فحص الكتالوج وثوابت المعرفات الرسمية (300401, 300402, 300403).
2. فحص الحقيبة الفارغة (0-Network Direct Read).
3. فحص حقيبة بها كميات محددة واختبار كافة الفلاتر والأسماء المستعارة:
   - pack_type=10 -> 50
   - pack_type="50" -> 100
   - pack_type=100 -> 300
   - pack_type="total" -> 450
   - pack_type="صغيرة" -> 50
   - pack_type="large" -> 300
   - pack_type="unknown type" -> 0
4. فحص أنواع المخرجات (int / dict) بدقة.
5. فحص بديل bagCtrl عند غياب backpackCtrl.
"""

import sys
import os

WORKSPACE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from tasks.base_task import (
    BaseTask,
    STAMINA_PACKS_CATALOG,
    STAMINA_PACKS_KEY_MAP,
    STAMINA_PACKS_BY_ID,
)


class MockConnection:
    """محاكي اتصال الذاكرة الحية لقراءة الكنترولرات بدون شبكة."""

    def __init__(self, init_data=None):
        self.init_data = init_data or {}

    def get_ctrl(self, name: str):
        return self.init_data.get(name, {})


class ConcreteStaminaTask(BaseTask):
    """صنف اختباري يرث من BaseTask لاختبار وظائف الطاقة."""
    name = "stamina_test_task"

    async def run(self):
        pass


def run_catalog_verification():
    print("═" * 70)
    print(" [1] التحقق من الكتالوج وثوابت المعرفات الرسمية (Catalog & IDs)")
    print("═" * 70)

    # 1. فحص الفئات الأساسية
    assert "10" in STAMINA_PACKS_CATALOG, "Missing tier 10 in STAMINA_PACKS_CATALOG"
    assert "50" in STAMINA_PACKS_CATALOG, "Missing tier 50 in STAMINA_PACKS_CATALOG"
    assert "100" in STAMINA_PACKS_CATALOG, "Missing tier 100 in STAMINA_PACKS_CATALOG"

    # 2. فحص المعرفات الرسمية للسورس
    assert STAMINA_PACKS_CATALOG["10"]["item_id"] == 300401, "Tier 10 must have ID 300401"
    assert STAMINA_PACKS_CATALOG["50"]["item_id"] == 300402, "Tier 50 must have ID 300402"
    assert STAMINA_PACKS_CATALOG["100"]["item_id"] == 300403, "Tier 100 must have ID 300403"

    # 3. فحص قيم الطاقة
    assert STAMINA_PACKS_CATALOG["10"]["stamina_value"] == 10
    assert STAMINA_PACKS_CATALOG["50"]["stamina_value"] == 50
    assert STAMINA_PACKS_CATALOG["100"]["stamina_value"] == 100

    # 4. فحص الفهرس بالمعرف STAMINA_PACKS_BY_ID
    assert STAMINA_PACKS_BY_ID[300401]["stamina_value"] == 10
    assert STAMINA_PACKS_BY_ID[300402]["stamina_value"] == 50
    assert STAMINA_PACKS_BY_ID[300403]["stamina_value"] == 100

    print("   ✓ معرفات الكتالوج الرسمية متطابقة 100%: 300401 (10), 300402 (50), 300403 (100)")


def run_empty_bag_verification():
    print("\n" + "═" * 70)
    print(" [2] التحقق من الحقيبة الفارغة (Empty Backpack Mock Test)")
    print("═" * 70)

    conn = MockConnection({"backpackCtrl": {}})
    task = ConcreteStaminaTask(conn)

    # فحص النمط الشامل
    res = task.get_available_stamina_packs()
    assert isinstance(res, dict), f"Expected dict, got {type(res)}"
    assert res["total_stamina"] == 0, f"Expected 0 total_stamina, got {res['total_stamina']}"
    assert res["total_packs"] == 0, f"Expected 0 total_packs, got {res['total_packs']}"
    assert res["10"] == 0
    assert res["50"] == 0
    assert res["100"] == 0
    assert isinstance(res["details"], dict)
    assert res["details"]["10"]["count"] == 0
    assert res["details"]["50"]["count"] == 0
    assert res["details"]["100"]["count"] == 0

    # فحص الفلاتر عند خلو الحقيبة (يجب أن تُرجع 0 دائماً كرقم صحيح int)
    assert task.get_available_stamina_packs(10) == 0
    assert isinstance(task.get_available_stamina_packs(10), int)
    assert task.get_available_stamina_packs("50") == 0
    assert isinstance(task.get_available_stamina_packs("50"), int)
    assert task.get_available_stamina_packs(100) == 0
    assert isinstance(task.get_available_stamina_packs(100), int)
    assert task.get_available_stamina_packs("total") == 0
    assert isinstance(task.get_available_stamina_packs("total"), int)
    assert task.get_available_stamina_packs("unknown type") == 0
    assert isinstance(task.get_available_stamina_packs("unknown type"), int)

    print("   ✓ نتائج الحقيبة الفارغة سليمة بنسبة 100% (أصفار صحيحة int وقاموس تفصيلي فارغ)")


def run_populated_bag_verification():
    print("\n" + "═" * 70)
    print(" [3] التحقق من حقيبة مأهولة وفحص جميع الفلاتر المطلوبة")
    print("═" * 70)

    # الحقيبة المطلوبة في التكليف:
    # {300401: {"count": 5}, "300402": 2, 300403: {"count": "3"}}
    mock_backpack = {
        300401: {"count": 5},       # 5 حزم من فئة 10 = 50 نقطة طاقة
        "300402": 2,                 # 2 حزمة من فئة 50 = 100 نقطة طاقة (raw int)
        300403: {"count": "3"},      # 3 حزم من فئة 100 = 300 نقطة طاقة (str count)
    }

    conn = MockConnection({"backpackCtrl": mock_backpack})
    task = ConcreteStaminaTask(conn)

    # 1. فحص التقرير الشامل (pack_type=None)
    full_res = task.get_available_stamina_packs()
    assert isinstance(full_res, dict), f"Expected dict, got {type(full_res)}"
    assert full_res["total_stamina"] == 450, f"Expected 450 stamina, got {full_res['total_stamina']}"
    assert full_res["total_packs"] == 10, f"Expected 10 packs, got {full_res['total_packs']}"
    assert full_res["10"] == 50, f"Expected 50 pts for tier 10, got {full_res['10']}"
    assert full_res["50"] == 100, f"Expected 100 pts for tier 50, got {full_res['50']}"
    assert full_res["100"] == 300, f"Expected 300 pts for tier 100, got {full_res['100']}"

    d10 = full_res["details"]["10"]
    assert d10["item_id"] == 300401
    assert d10["count"] == 5
    assert d10["stamina_per_item"] == 10
    assert d10["total_stamina"] == 50

    d50 = full_res["details"]["50"]
    assert d50["item_id"] == 300402
    assert d50["count"] == 2
    assert d50["stamina_per_item"] == 50
    assert d50["total_stamina"] == 100

    d100 = full_res["details"]["100"]
    assert d100["item_id"] == 300403
    assert d100["count"] == 3
    assert d100["stamina_per_item"] == 100
    assert d100["total_stamina"] == 300

    print("   ✓ التقرير الشامل (pack_type=None) دقيق: total_stamina=450, total_packs=10")

    # 2. فحص الفلاتر المحددة في التكليف:
    # pack_type=10
    val_10 = task.get_available_stamina_packs(10)
    assert val_10 == 50, f"Expected 50, got {val_10}"
    assert isinstance(val_10, int)
    print("   ✓ فلتر (pack_type=10)             -> 50 نقطة (int)")

    # pack_type="50"
    val_50 = task.get_available_stamina_packs("50")
    assert val_50 == 100, f"Expected 100, got {val_50}"
    assert isinstance(val_50, int)
    print("   ✓ فلتر (pack_type='50')           -> 100 نقطة (int)")

    # pack_type=100
    val_100 = task.get_available_stamina_packs(100)
    assert val_100 == 300, f"Expected 300, got {val_100}"
    assert isinstance(val_100, int)
    print("   ✓ فلتر (pack_type=100)            -> 300 نقطة (int)")

    # pack_type="total"
    val_total = task.get_available_stamina_packs("total")
    assert val_total == 450, f"Expected 450, got {val_total}"
    assert isinstance(val_total, int)
    print("   ✓ فلتر (pack_type='total')         -> 450 نقطة (int)")

    # pack_type="صغيرة"
    val_small = task.get_available_stamina_packs("صغيرة")
    assert val_small == 50, f"Expected 50, got {val_small}"
    assert isinstance(val_small, int)
    print("   ✓ فلتر (pack_type='صغيرة')         -> 50 نقطة (int)")

    # pack_type="large"
    val_large = task.get_available_stamina_packs("large")
    assert val_large == 300, f"Expected 300, got {val_large}"
    assert isinstance(val_large, int)
    print("   ✓ فلتر (pack_type='large')         -> 300 نقطة (int)")

    # pack_type="unknown type"
    val_unknown = task.get_available_stamina_packs("unknown type")
    assert val_unknown == 0, f"Expected 0 for unknown type, got {val_unknown}"
    assert isinstance(val_unknown, int)
    print("   ✓ فلتر (pack_type='unknown type')  -> 0 نقطة (int)")


def run_bagctrl_fallback_verification():
    print("\n" + "═" * 70)
    print(" [4] التحقق من البديل bagCtrl عند غياب backpackCtrl")
    print("═" * 70)

    # استخدام bagCtrl بدلاً من backpackCtrl
    conn = MockConnection({"bagCtrl": {"300401": 10, "300402": 1}})
    task = ConcreteStaminaTask(conn)

    res = task.get_available_stamina_packs()
    assert res["total_stamina"] == 150  # (10 * 10) + (1 * 50) = 150
    assert res["total_packs"] == 11
    assert task.get_available_stamina_packs("total") == 150
    assert task.get_available_stamina_packs("10") == 100
    assert task.get_available_stamina_packs("50") == 50

    print("   ✓ آلية قراءة bagCtrl كبديل لـ backpackCtrl تعمل بنجاح 100%")


def main():
    print("🚀 بدء اختبارات التحقق الشاملة لوظائف حزم طاقة اللورد...")
    run_catalog_verification()
    run_empty_bag_verification()
    run_populated_bag_verification()
    run_bagctrl_fallback_verification()
    print("\n" + "═" * 70)
    print("🎉 جميع اختبارات Mock لحزم طاقة اللورد اجتازت بنجاح 100%!")
    print("═" * 70)


if __name__ == "__main__":
    main()
