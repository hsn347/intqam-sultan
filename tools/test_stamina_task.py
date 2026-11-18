# -*- coding: utf-8 -*-
"""
tools/test_stamina_task.py — اختبارات شاملة غير متصلة ومحاكاة لمهمة تعويض طاقة اللورد (StaminaTask)
══════════════════════════════════════════════════════════════════════════════════════════════
يختبر:
1. استهلاك كافة حزم وباقات الطاقة المجانية المتوفرة بالحقيبة بالكامل (100، 50، 10).
2. الفحص القبلي (0-Network Pre-flight): تخطي المهمة بصفر طلبات شبكية عند نفاذ الحزم وعدم تفعيل الشراء بالذهب.
3. التخطي عند عدم توفر حزم مجانية وكون الطاقة أعلى من سقف تفعيل الشراء بالذهب.
4. التخطي والتوقف الكامل عند عدم كفاية رصيد الذهب لكامل الكمية المطلوبة (منع الشراء الجزئي).
5. الشراء بالذهب من المتجر الرسمي (باقات 50 طاقة - 1034/2) وتحديث الذاكرة الحية (الذهب والطاقة).
6. اختبار الحساب الحي بنمط المحاكاة الآمنة.
"""

import asyncio
import json
import math
import os
import sys
import unittest
from typing import Any, Dict, List

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.stamina import StaminaTask
from tasks.base_task import TaskResult


class MockConnection:
    """محاكي اتصال البوابة وسيرفر اللعبة."""

    def __init__(self, init_data: Dict[str, Any]):
        self.is_connected = True
        self.init_data = init_data
        self.sent_queries: List[Dict[str, Any]] = []
        self.creds = type("Creds", (), {"email": "test_lord@sultan.com", "uid": "123456"})()

    async def query(self, cmd: str | int, sub_cmd: str | int, payload: Dict[str, Any]) -> Dict[str, Any]:
        self.sent_queries.append({"cmd": str(cmd), "sub_cmd": str(sub_cmd), "payload": payload})
        return {"err": "0", "msg": "ok", "data": {}}


class TestStaminaTask(unittest.IsolatedAsyncioTestCase):

    async def test_0_network_preflight_disabled(self):
        """اختبار التخطي بصفر طلبات شبكية عند تعطيل المهمة."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 30, "gold": 1000, "uid": "123456"}},
            "backpackCtrl": {"300401": {"count": 5}},
        }
        conn = MockConnection(init_data)
        cfg = {"enabled": False, "gold_buy_enabled": False, "gold_trigger_stamina": 50, "gold_buy_stamina_amount": 50}
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertFalse(can_run)
        self.assertIn("معطلة", reason)

        res = await task.safe_execute()
        self.assertTrue(res.skipped)
        self.assertEqual(len(conn.sent_queries), 0)

    async def test_consume_all_free_packs_in_bag(self):
        """اختبار استهلاك كافة حزم الطاقة المتوفرة في الحقيبة بالكامل (100s, 50s, 10s)."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 20, "gold": 100, "uid": "123456"}},
            "backpackCtrl": {
                "300401": {"count": 4},  # 4x 10 = 40 stamina
                "300402": {"count": 2},  # 2x 50 = 100 stamina
                "300403": {"count": 1},  # 1x 100 = 100 stamina
            },
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "gold_buy_enabled": False,
            "gold_trigger_stamina": 50,
            "gold_buy_stamina_amount": 50,
        }
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertTrue(can_run)

        res = await task.run()
        self.assertTrue(res.success)
        self.assertFalse(res.skipped)

        # استهلاك 3 فئات: 100 ثم 50 ثم 10
        self.assertEqual(len(conn.sent_queries), 3)
        self.assertEqual(conn.sent_queries[0]["payload"], {"itemID": 300403, "count": 1})
        self.assertEqual(conn.sent_queries[1]["payload"], {"itemID": 300402, "count": 2})
        self.assertEqual(conn.sent_queries[2]["payload"], {"itemID": 300401, "count": 4})

        # التحقق من تفريغ الحقيبة بالكامل
        backpack = init_data["backpackCtrl"]
        self.assertNotIn("300403", backpack)
        self.assertNotIn("300402", backpack)
        self.assertNotIn("300401", backpack)

        # الطاقة: 20 + 100 + 100 + 40 = 260
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 260)
        self.assertEqual(res.data["gained"], 240)
        self.assertEqual(res.data["gold_spent"], 0)
        self.assertEqual(res.data["bought_packs"], 0)

    async def test_0_network_skip_when_no_free_packs_and_gold_buy_disabled(self):
        """اختبار التخطي بصفر شبكة عند عدم توفر حزم مجانية وتعطيل الشراء بالذهب."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 20, "gold": 1000, "uid": "123456"}},
            "backpackCtrl": {},  # لا حزم
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "gold_buy_enabled": False,
            "gold_trigger_stamina": 50,
            "gold_buy_stamina_amount": 50,
        }
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertFalse(can_run)
        self.assertIn("لا توجد حزم طاقة مجانية", reason)

        res = await task.safe_execute()
        self.assertTrue(res.skipped)
        self.assertEqual(len(conn.sent_queries), 0)

    async def test_0_network_skip_when_stamina_above_gold_trigger(self):
        """اختبار التخطي بصفر شبكة عند نفاذ الحزم ولكن الطاقة أعلى من سقف تفعيل الذهب."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 80, "gold": 1000, "uid": "123456"}},
            "backpackCtrl": {},  # لا حزم
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "gold_buy_enabled": True,
            "gold_trigger_stamina": 50,  # 80 > 50 -> لا يشتري
            "gold_buy_stamina_amount": 50,
        }
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertFalse(can_run)
        self.assertIn("أعلى من سقف", reason)

        res = await task.safe_execute()
        self.assertTrue(res.skipped)
        self.assertEqual(len(conn.sent_queries), 0)

    async def test_skip_when_gold_insufficient_no_partial_buy(self):
        """اختبار التوقف والتخطي الكامل عند عدم كفاية الذهب للكمية المطلوبة (منع الشراء الجزئي)."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 30, "gold": 350, "uid": "123456"}},
            "backpackCtrl": {},
        }
        conn = MockConnection(init_data)
        # المطلوب: 100 طاقة = باقتين 50 = 400 ذهب. الرصيد: 350 ذهب (< 400)
        cfg = {
            "enabled": True,
            "gold_buy_enabled": True,
            "gold_trigger_stamina": 50,
            "gold_buy_stamina_amount": 100,
        }
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertFalse(can_run)
        self.assertIn("لا يكفي", reason)

        res = await task.safe_execute()
        self.assertTrue(res.skipped)
        self.assertEqual(len(conn.sent_queries), 0, "يجب عدم شراء أي باقة جزئياً عند عدم كفاية الذهب للكمية الكاملة!")

    async def test_gold_buy_success(self):
        """اختبار الشراء بالذهب بنجاح عند استيفاء كافة الشروط وتحديث الذاكرة الحية."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 25, "gold": 1000, "uid": "123456"}},
            "backpackCtrl": {},
        }
        conn = MockConnection(init_data)
        # المطلوب: 100 طاقة = باقتين 50 = 400 ذهب
        cfg = {
            "enabled": True,
            "gold_buy_enabled": True,
            "gold_trigger_stamina": 50,
            "gold_buy_stamina_amount": 100,
        }
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertTrue(can_run)

        res = await task.run()
        self.assertTrue(res.success)
        self.assertFalse(res.skipped)

        self.assertEqual(len(conn.sent_queries), 1)
        q = conn.sent_queries[0]
        self.assertEqual(q["cmd"], "1034")
        self.assertEqual(q["sub_cmd"], "2")
        self.assertEqual(q["payload"], {"shopItemID": 1000046, "num": 2, "use": True})

        # التحقق من خصم الذهب وزيادة الطاقة بالذاكرة الحية
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["gold"], 1000 - 400)  # 600
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 25 + 100)  # 125
        self.assertEqual(res.data["gold_spent"], 400)
        self.assertEqual(res.data["bought_packs"], 2)
        self.assertEqual(res.data["gained"], 100)

    async def test_live_castle_beetoo2_simulation(self):
        """اختبار القلعة الحية (beetoo2@hotmail.com) بنمط القراءة والمحاكاة الآمنة (0 مخاطر)."""
        import core.database as db
        from bot_manager import CastleBot

        c_data = db.get_castle_by_id("beetoo2@hotmail.com")
        if not c_data or not c_data.get("password"):
            self.skipTest("حساب beetoo2@hotmail.com غير متوفر في قاعدة البيانات")

        bot = CastleBot(email="beetoo2@hotmail.com", password=c_data["password"], log_callback=lambda m: None)
        bot.is_running = True
        conn = None
        try:
            ok = await bot.connect()
            if not ok or not bot.conn:
                self.skipTest("فشل الاتصال بالبوابة لحساب beetoo2")
            conn = bot.conn
        except Exception as e:
            self.skipTest(f"تعذر الاتصال بسيرفر اللعبة: {e}")

        if not conn or not conn.is_connected:
            self.skipTest("الاتصال بحساب beetoo2 غير متاح حالياً")

        try:
            # 1. قراءة الذاكرة الحية بصفر شبكة
            task = StaminaTask(conn, None, {"enabled": True, "gold_buy_enabled": False})
            stamina_val = task.stamina
            gold_val = task.gold
            self.assertGreater(stamina_val, 0)
            self.assertGreaterEqual(gold_val, 0)

            packs = task.get_available_stamina_packs()
            self.assertIsInstance(packs, dict)
            self.assertIn("total_packs", packs)
            self.assertIn("details", packs)

            # 2. محاكاة آمنة في الذاكرة المعزولة (0 مخاطر على الحساب)
            sim_init_data = json.loads(json.dumps(conn.init_data))
            mock_conn = MockConnection(sim_init_data)
            sim_task = StaminaTask(mock_conn, None, {
                "enabled": True,
                "gold_buy_enabled": False,
                "gold_trigger_stamina": 50,
                "gold_buy_stamina_amount": 50
            })
            sim_res = await sim_task.run()
            self.assertTrue(sim_res.success or sim_res.skipped)
        finally:
            if conn:
                await conn.close()


if __name__ == "__main__":
    unittest.main()
