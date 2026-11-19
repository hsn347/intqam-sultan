# -*- coding: utf-8 -*-
"""
tools/test_market_capacity.py
اختبار وتدقيق محرك حساب سعة نقل مساعدة الموارد والضرائب بالسوق في BaseTask
مطابقة 100% لسورس كود اللعبة الرسمي.
"""

import os
import sys
import math
import json
from typing import Dict, Any

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.base_task import (
    BaseTask,
    MARKET_BUILDING_ID,
    MARKET_BASE_CAPACITY,
    MARKET_BASE_TAX_RATE,
    MARKET_RESOURCE_WEIGHTS,
    MARKET_RESOURCE_ALIASES,
    ALLIANCE_SCIENCE_TRADING_WEIGHT_ID,
    ALLIANCE_SCIENCE_TRADING_WEIGHT_BONUS,
)


class MockConn:
    """محاكي اتصال للعبة لتزويد الذاكرة الحية (init_data)."""
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = init_data

    def get_ctrl(self, name: str) -> Any:
        return self.init_data.get(name, {})


class MockTask(BaseTask):
    """صنف وهمي يرث من BaseTask لاختبار الدوال بدقة دون الحاجة لاتصال شبكي."""
    name = "mock_test_task"

    def __init__(self, init_data: Dict[str, Any], castle_level: int = 30):
        self.conn = MockConn(init_data)
        self._mock_castle_level = castle_level
        self.config = {}

    @property
    def castle_level(self) -> int:
        return self._mock_castle_level

    async def run(self):
        return True, "ok"


def run_unit_tests():
    print("=" * 70)
    print("🚀 بدء الاختبارات البرمجية التفصيلية لدالة get_market_transport_capacity")
    print("=" * 70)

    # 1. اختبار السوق غير مبني (مستوى 0)
    mock_empty = MockTask(init_data={}, castle_level=1)
    cap_empty = mock_empty.get_market_transport_capacity()
    assert cap_empty == 0, f"Expected 0, got {cap_empty}"
    print("✅ Test 1 Passed: السوق غير مبني يعطي سعة 0.")

    # 2. اختبار سوق مستوى 1 (السعة 20,000، الضريبة 45%) بدون تحالف
    init_data_lv1 = {
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": 112, "lv": 1}}
            ]
        }
    }
    mock_lv1 = MockTask(init_data=init_data_lv1, castle_level=5)
    cap_lv1 = mock_lv1.get_market_transport_capacity()
    assert cap_lv1 == 20000, f"Expected 20000, got {cap_lv1}"

    # فحص سعة الموارد الفردية
    # طعام (وزن 1) -> 20000
    food_cap = mock_lv1.get_market_transport_capacity(resource_type="food")
    assert food_cap == 20000, f"Expected 20000, got {food_cap}"

    # خشب (وزن 1) -> 20000
    wood_cap = mock_lv1.get_market_transport_capacity(resource_type="wood")
    assert wood_cap == 20000, f"Expected 20000, got {wood_cap}"

    # حديد (وزن 6، فتح مستوى 10) والقلعة مستوى 5 -> يجب أن يكون مقفلاً (0)
    iron_cap_locked = mock_lv1.get_market_transport_capacity(resource_type="iron")
    assert iron_cap_locked == 0, f"Expected 0 for locked iron at lv 5, got {iron_cap_locked}"
    print("✅ Test 2 Passed: سوق مستوى 1 يحسب 20,000 وقفل الحديد بنجاح للقلعة دون مستوى 10.")

    # 3. اختبار سوق مستوى 10 (200,000، الضريبة 36%) مع علم تحالف مستوى 5 (+5%)
    init_data_lv10 = {
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": 112, "lv": 10}}
            ]
        },
        "allianceCtrl": {
            "aid": 12345,
            "sciencelist": {
                "scilist": {
                    "3": [
                        {"id": 33002, "lv": 5}
                    ]
                }
            }
        }
    }
    # القلعة مستوى 12 (الحديد مفتوح، الفضة مقفلة)
    mock_lv10 = MockTask(init_data=init_data_lv10, castle_level=12)
    # base = 200,000, add = floor(200,000 * 0.05) = 10,000 -> total = 210,000
    cap_lv10 = mock_lv10.get_market_transport_capacity()
    assert cap_lv10 == 210000, f"Expected 210000, got {cap_lv10}"

    # الحديد (وزن 6) -> 210,000 // 6 = 35,000
    iron_cap = mock_lv10.get_market_transport_capacity(resource_type="iron")
    assert iron_cap == 35000, f"Expected 35000, got {iron_cap}"

    # الفضة (فتح مستوى 15) والقلعة 12 -> مقفل (0)
    silver_cap = mock_lv10.get_market_transport_capacity(resource_type="silver")
    assert silver_cap == 0, f"Expected 0 for locked silver, got {silver_cap}"
    print("✅ Test 3 Passed: سوق مستوى 10 + علم تحالف 5% يعطي 210,000 وحديد 35,000 بدقة.")

    # 4. اختبار قلعة مستلمة (target_castle_level)
    # القلعة المرسلة مستوى 30 ولكن القلعة المستلمة مستوى 8 (الحديد مقفل لديها)
    init_data_lv30 = {
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": 112, "lv": 30}}
            ]
        },
        "allianceCtrl": {
            "aid": 9999,
            "sciencelist": {
                "scilist": {
                    "3": [
                        {"id": 33002, "lv": 10}  # +10%
                    ]
                }
            }
        }
    }
    mock_lv30 = MockTask(init_data=init_data_lv30, castle_level=30)
    # base = 690,000, add = floor(690,000 * 0.10) = 69,000 -> total = 759,000
    total_cap_30 = mock_lv30.get_market_transport_capacity()
    assert total_cap_30 == 759000, f"Expected 759000, got {total_cap_30}"

    # إرسال حديد لحليف قلعته مستوى 8
    target_iron_locked = mock_lv30.get_market_transport_capacity(resource_type="iron", target_castle_level=8)
    assert target_iron_locked == 0, f"Expected 0 for target lv 8, got {target_iron_locked}"

    # إرسال حديد لحليف قلعته مستوى 10 -> مسموح
    target_iron_ok = mock_lv30.get_market_transport_capacity(resource_type="iron", target_castle_level=10)
    assert target_iron_ok == (759000 // 6), f"Expected {759000 // 6}, got {target_iron_ok}"

    # إرسال فضة لحليف قلعته 12 -> مقفلة لديه
    target_silver_locked = mock_lv30.get_market_transport_capacity(resource_type="silver", target_castle_level=12)
    assert target_silver_locked == 0, f"Expected 0 for target lv 12 silver, got {target_silver_locked}"

    # إرسال فضة لحليف قلعته 15 -> مسموح
    target_silver_ok = mock_lv30.get_market_transport_capacity(resource_type="silver", target_castle_level=15)
    assert target_silver_ok == (759000 // 24), f"Expected {759000 // 24}, got {target_silver_ok}"
    print("✅ Test 4 Passed: فحص مستوى القلعة المستلمة (target_castle_level) يعمل بكفاءة تامة.")

    # 5. اختبار التفصيل الكامل (breakdown=True)
    full_breakdown = mock_lv30.get_market_transport_capacity(resource_type="iron", target_castle_level=12, breakdown=True)
    assert full_breakdown["total_weight_capacity"] == 759000
    assert full_breakdown["market_building"]["level"] == 30
    assert full_breakdown["market_building"]["base_capacity"] == 690000
    assert full_breakdown["alliance_science"]["bonus_weight"] == 69000
    assert full_breakdown["alliance_science"]["bonus_percent"] == 10.0
    assert full_breakdown["tax"]["tax_rate"] == 0.10
    assert full_breakdown["tax"]["tax_percent"] == 10.0
    assert full_breakdown["resources"]["food"]["max_capacity_units"] == 759000
    # صافي الواصل من الطعام بعد ضريبة 10%: 759000 * 0.9 = 683100
    assert full_breakdown["resources"]["food"]["net_delivered_units"] == 683100
    # الحديد للهدف مستوى 12 مسموح: 759000 // 6 = 126500، وصافي الواصل = floor(126500 * 0.9) = 113850
    assert full_breakdown["resources"]["iron"]["max_capacity_units"] == 126500
    assert full_breakdown["resources"]["iron"]["net_delivered_units"] == 113850
    # الفضة للهدف مستوى 12 مقفلة:
    assert full_breakdown["resources"]["mithril"]["is_locked"] is True
    assert full_breakdown["resources"]["mithril"]["max_capacity_units"] == 0
    print("✅ Test 5 Passed: قاموس الـ breakdown شامل ومطابق للضرائب والصافي بنسبة 100%.")

    # 6. اختبار تطبيع الأسماء والمعرفات (Aliases)
    for alias in ["food", "wheat", "طعام", "قمح", 1002, "1002", 1, "1"]:
        c = mock_lv30.get_market_transport_capacity(resource_type=alias)
        assert c == 759000, f"Alias {alias} failed"

    for alias in ["iron", "حديد", 1004, "1004", 3, "3"]:
        c = mock_lv30.get_market_transport_capacity(resource_type=alias)
        assert c == 126500, f"Alias {alias} failed"

    for alias in ["mithril", "silver", "فضة", "ميثريل", 1005, "1005", 4, "4"]:
        c = mock_lv30.get_market_transport_capacity(resource_type=alias)
        assert c == (759000 // 24), f"Alias {alias} failed"

    for alias in ["crystal", "بلور", "كريستال", 1006, "1006", 5, "5"]:
        c = mock_lv30.get_market_transport_capacity(resource_type=alias)
        assert c == (759000 // 96), f"Alias {alias} failed"

    # اختبار قيمة غير معروفة
    try:
        mock_lv30.get_market_transport_capacity(resource_type="invalid_res")
        assert False, "Should raise ValueError"
    except ValueError:
        pass

    print("✅ Test 6 Passed: تطبيع أسماء ومعرفات الموارد يعمل بسلاسة لجميع التسميات.")

    print("\n🎉 جميع الاختبارات البرمجية لوحدة حساب سعة نقل السوق اجتازت بنجاح تام 100%!")


if __name__ == "__main__":
    run_unit_tests()
