# -*- coding: utf-8 -*-
"""
tools/test_army_list_source_match.py
═════════════════════════════════════════════════════════════════════════
اختبار تدقيقي شامل ومطابقة حرفية 100% لدوال الجيش والجنود الشاغرين:
- armyltCtrl.isArmyID(armyid)
- serviceFunctions.isTrapID(armyid)
- armyCtrl:getArmyList(warType)
- armyCtrl:getTrapList()
- armyCtrl:getTrapTotalCount()
- armyCtrl:getInnerCityNormalArmy(warType)
═════════════════════════════════════════════════════════════════════════
"""

import sys
import os
import unittest

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.base_task import BaseTask, BUILDID_FORTRESS, FORTRESS_TRAP_IDS


class DummyConn:
    def __init__(self, init_data: dict = None):
        self.init_data = init_data or {}
        self.is_connected = True


class DummyTask(BaseTask):
    """فئة وهمية ترث من BaseTask لاختبار الدوال الحسابية دون الحاجة لشبكة."""

    def __init__(self, init_data: dict = None):
        conn = DummyConn(init_data=init_data)
        super().__init__(conn=conn, log_func=lambda m: None, config={})

    async def run(self):
        return True


class TestArmySourceMatch(unittest.TestCase):
    """اختبارات المطابقة الحرفية لسورس كود اللعبة."""

    def test_fortress_trap_ids(self):
        """التحقق من قائمة معرفات فخاخ حصن الحرب (15 معرفاً برتب مختلفة من armyinfo.lua)."""
        expected_traps = {801, 802, 803, 804, 805, 811, 812, 813, 814, 815, 821, 822, 823, 824, 825}
        self.assertEqual(FORTRESS_TRAP_IDS, expected_traps)
        self.assertEqual(BUILDID_FORTRESS, 120)

    def test_is_trap_id(self):
        """مطابقة دالة serviceFunctions.isTrapID."""
        # فخاخ حصن الحرب
        for tid in FORTRESS_TRAP_IDS:
            self.assertTrue(BaseTask.is_trap_id(tid), f"فشل التحقق من الفخ {tid}")
            self.assertTrue(BaseTask.is_trap_id(str(tid)), f"فشل التحقق من الفخ كنص {tid}")

        # حدود النطاق 801..899
        self.assertTrue(BaseTask.is_trap_id(801))
        self.assertTrue(BaseTask.is_trap_id(899))
        self.assertFalse(BaseTask.is_trap_id(800))
        self.assertFalse(BaseTask.is_trap_id(900))

        # جنود عاديين (مشاة، فرسان، رماة، عربات، نخبة)
        normal_units = [401, 402, 410, 501, 510, 601, 610, 701, 710, 901, 910, 10004511]
        for uid in normal_units:
            self.assertFalse(BaseTask.is_trap_id(uid), f"الوحدة {uid} ليست فخاً ويجب أن تعيد False")

    def test_is_army_id(self):
        """مطابقة دالة armyltCtrl.isArmyID (barrackID ~= BUILDID.FORTRESS)."""
        # الجنود المقاتلون يجب أن يعيدوا True
        normal_units = [401, 402, 410, 501, 510, 601, 610, 701, 710, 901, 910]
        for uid in normal_units:
            self.assertTrue(BaseTask.is_army_id(uid), f"الوحدة {uid} جندي مقاتل ويجب أن تعيد True")
            self.assertTrue(BaseTask.is_army_id(str(uid)), f"الوحدة {uid} كنص يجب أن تعيد True")

        # فخاخ وعناصر حصن الحرب يجب استبعادها تماماً (False)
        for tid in FORTRESS_TRAP_IDS:
            self.assertFalse(BaseTask.is_army_id(tid), f"الفخ {tid} يجب استبعاده من is_army_id")

        # معالجة القيم الصفرية والخاطئة
        self.assertFalse(BaseTask.is_army_id(0))
        self.assertFalse(BaseTask.is_army_id(-5))
        self.assertFalse(BaseTask.is_army_id("invalid"))

    def test_get_army_list_clean_filter(self):
        """مطابقة دالة armyCtrl:getArmyList واستبعاد فخاخ حصن الحرب وخصم معارك الدفاع."""
        mock_init = {
            "armyCtrl": {
                "totalArmy": {
                    "401": 5000,    # مشاة رتبة 1
                    "501": 3000,    # فرسان رتبة 1
                    "601": 4000,    # رماة رتبة 1
                    "801": 1500,    # فخ حصن الحرب (يجب استبعاده)
                    "811": 800,     # فخ حصن الحرب (يجب استبعاده)
                    "701": 0,       # وحدة بصفر جنود (يجب استبعادها)
                },
                "fightingArmy": {
                    "401": 1000,    # 1000 مشاة منخرطين في دفاع القلعة
                }
            }
        }
        task = DummyTask(init_data=mock_init)

        # 1. استخراج الجنود بخصم معارك الدفاع
        army_list = task.get_army_list(deduct_fighting=True)
        self.assertNotIn(801, army_list)
        self.assertNotIn(811, army_list)
        self.assertNotIn(701, army_list)
        self.assertEqual(army_list[401], 4000)  # 5000 - 1000
        self.assertEqual(army_list[501], 3000)
        self.assertEqual(army_list[601], 4000)

        # 2. إجمالي الجنود الشاغرين داخل القلعة (armyCtrl:getInnerCityNormalArmy)
        self.assertEqual(task.get_inner_city_normal_army(), 11000)
        self.assertEqual(task.available_troops_count, 11000)

        # 3. جلب فخاخ حصن الحرب (armyCtrl:getTrapList)
        traps = task.get_trap_list()
        self.assertEqual(traps, {801: 1500, 811: 800})
        self.assertEqual(task.get_trap_total_count(), 2300)

    def test_get_available_troops_backward_compatibility(self):
        """التأكد من التوافقية الرجعية الكاملة لدالة get_available_troops وخصائصها."""
        mock_init = {
            "armyCtrl": {
                "totalArmy": {
                    "601": 100,
                    "401": 300,
                    "801": 50,
                }
            }
        }
        task = DummyTask(init_data=mock_init)

        # exclude_fortress=True
        avail_dict = task.get_available_troops(exclude_fortress=True, as_list=False, reverse=False)
        self.assertEqual(avail_dict, {401: 300, 601: 100})
        self.assertNotIn(801, avail_dict)

        # as_list=True
        avail_list = task.get_available_troops(exclude_fortress=True, as_list=True, reverse=False)
        self.assertEqual(avail_list, [{"id": 401, "num": 300}, {"id": 601, "num": 100}])

        # reverse=True
        avail_rev = task.get_available_troops(exclude_fortress=True, as_list=False, reverse=True)
        self.assertEqual(list(avail_rev.keys()), [601, 401])

        # exclude_fortress=False
        all_units = task.get_available_troops(exclude_fortress=False, as_list=False)
        self.assertEqual(all_units, {401: 300, 601: 100, 801: 50})


if __name__ == "__main__":
    unittest.main()
