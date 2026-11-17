# -*- coding: utf-8 -*-
"""
tools/test_stamina_task.py — اختبارات شاملة غير متصلة ومحاكاة لمهمة تعويض طاقة اللورد (StaminaTask)
══════════════════════════════════════════════════════════════════════════════════════════════
يختبر:
1. الفحص القبلي (0-Network Pre-flight): تخطي المهمة إذا كانت الطاقة كافية دون أي طلبات شبكية.
2. النمط التلقائي الذكي (Auto Mode): توزيع الاستهلاك على حزم 100 و 50 و 10 مع تقليل الهدر.
3. النمط اليدوي (Manual Mode): استهلاك الفئة والعدد المحددين.
4. الشراء بالذهب (Gold Shop Purchase): حزمة 50 طاقة (1034/2) والسقف اليومي للذهب.
5. تحديث الذاكرة اللحظية (backpackCtrl / lordInfoCtrl).
"""

import asyncio
import json
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

    def setUp(self):
        # تصفير متتبع الذهب لكل اختبار
        StaminaTask._daily_gold_tracker.clear()

    async def test_0_network_preflight_sufficient_stamina(self):
        """اختبار 0-Network: إذا كانت طاقة القلعة >= الحد الأدنى يتم التخطي بصفر طلبات شبكية."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 120, "gold": 500, "uid": "123456"}},
            "backpackCtrl": {
                "300401": {"count": 10},
                "300402": {"count": 5},
            },
        }
        conn = MockConnection(init_data)
        cfg = {"enabled": True, "min_stamina": 100, "mode": "auto"}
        task = StaminaTask(conn, None, cfg)

        can_run, reason = await task.can_run()
        self.assertFalse(can_run)
        self.assertIn("طاقة القلعة كافية", reason)

        res = await task.safe_execute()
        self.assertTrue(res.skipped)
        self.assertIn("طاقة القلعة كافية", res.message)
        self.assertEqual(len(conn.sent_queries), 0, "يجب عدم إرسال أي طلبات شبكية إطلاقاً!")

    async def test_auto_mode_consumption(self):
        """اختبار النمط التلقائي: عجز 65 نقطة مع وجود حزم متنوعة."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 35, "gold": 500, "uid": "123456"}},
            "backpackCtrl": {
                "300401": {"count": 10},  # 10 Stamina packs
                "300402": {"count": 2},   # 50 Stamina packs
                "300403": {"count": 0},   # 100 Stamina packs
            },
        }
        conn = MockConnection(init_data)
        cfg = {"enabled": True, "min_stamina": 100, "mode": "auto", "allow_buy": False}
        task = StaminaTask(conn, None, cfg)

        # العجز: 100 - 35 = 65
        # الخطة التلقائية: 1x50 (يتبقى 15) -> 2x10 (يغطي الـ 15 مع زيادة 5)
        res = await task.run()
        self.assertTrue(res.success)
        self.assertFalse(res.skipped)

        # التحقق من الطلبات المرسلة: استهلاك 1 من 50 (300402) و 2 من 10 (300401)
        self.assertEqual(len(conn.sent_queries), 2)
        q1 = conn.sent_queries[0]
        q2 = conn.sent_queries[1]
        self.assertEqual(q1["cmd"], "1004")
        self.assertEqual(q1["sub_cmd"], "2")
        self.assertEqual(q1["payload"], {"itemID": 300402, "count": 1})

        self.assertEqual(q2["cmd"], "1004")
        self.assertEqual(q2["sub_cmd"], "2")
        self.assertEqual(q2["payload"], {"itemID": 300401, "count": 2})

        # التحقق من تحديث الذاكرة الحية (backpackCtrl / lordInfoCtrl)
        self.assertEqual(init_data["backpackCtrl"]["300402"]["count"], 1)  # 2 - 1 = 1
        self.assertEqual(init_data["backpackCtrl"]["300401"]["count"], 8)  # 10 - 2 = 8
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 35 + 50 + 20)  # 105

    async def test_manual_mode_consumption(self):
        """اختبار النمط اليدوي: طلب استهلاك 2 من فئة 50 طاقة."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 40, "gold": 500, "uid": "123456"}},
            "backpackCtrl": {
                "300402": {"count": 5},
            },
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "min_stamina": 120,
            "mode": "manual",
            "pack_tier": "50",
            "pack_count": 2,
            "allow_buy": False,
        }
        task = StaminaTask(conn, None, cfg)

        res = await task.run()
        self.assertTrue(res.success)
        self.assertEqual(len(conn.sent_queries), 1)
        self.assertEqual(conn.sent_queries[0]["payload"], {"itemID": 300402, "count": 2})
        self.assertEqual(init_data["backpackCtrl"]["300402"]["count"], 3)
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 40 + 100)  # 140

    async def test_gold_shop_buy_within_daily_limit(self):
        """اختبار الشراء بالذهب عند نفاذ الحزم وضمن السقف اليومي."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 20, "gold": 800, "uid": "123456"}},
            "backpackCtrl": {},  # لا توجد حزم إطلاقاً
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "min_stamina": 100,
            "mode": "auto",
            "allow_buy": True,
            "max_gold_daily": 600,
        }
        task = StaminaTask(conn, None, cfg)

        # العجز: 100 - 20 = 80
        # لا حزم بالحقيبة -> شراء باقتين 50 بالذهب (200 + 200 = 400 ذهب <= 600)
        res = await task.run()
        self.assertTrue(res.success)
        self.assertEqual(len(conn.sent_queries), 2)
        for q in conn.sent_queries:
            self.assertEqual(q["cmd"], "1034")
            self.assertEqual(q["sub_cmd"], "2")
            self.assertEqual(q["payload"], {"shopItemID": 1000046, "num": 1, "use": True})

        # فحص خصم الذهب وزيادة الطاقة بالذاكرة
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["gold"], 800 - 400)  # 400
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 20 + 100)  # 120
        self.assertEqual(res.data["gold_spent"], 400)
        self.assertEqual(res.data["bought_packs"], 2)

    async def test_gold_shop_daily_limit_enforced(self):
        """اختبار الالتزام الصارم بالسقف اليومي للذهب وعدم تجاوزه."""
        init_data = {
            "lordInfoCtrl": {"base": {"health": 10, "gold": 5000, "uid": "123456"}},
            "backpackCtrl": {},
        }
        conn = MockConnection(init_data)
        cfg = {
            "enabled": True,
            "min_stamina": 200,
            "mode": "auto",
            "allow_buy": True,
            "max_gold_daily": 200,  # سقف يكفي لشراء باقة واحدة فقط (200 ذهب)
        }
        task = StaminaTask(conn, None, cfg)

        res = await task.run()
        self.assertTrue(res.success)
        # تم شراء 1 فقط لأن الباقة الثانية ستصل إلى 400 > 200
        self.assertEqual(len(conn.sent_queries), 1)
        self.assertEqual(res.data["gold_spent"], 200)
        self.assertEqual(res.data["bought_packs"], 1)
        self.assertEqual(init_data["lordInfoCtrl"]["base"]["health"], 10 + 50)

    async def test_live_castle_beetoo2_read_only(self):
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
            # 1. اختبار الفحص المسبق لطاقة القلعة الحالية (0-network)
            cfg = {"enabled": True, "min_stamina": 100, "mode": "auto", "allow_buy": False}
            task = StaminaTask(conn, None, cfg)
            current_stamina = task.stamina
            self.assertGreater(current_stamina, 0)

            # إذا كانت الطاقة الحالية >= 100 يتم التخطي بصفر طلبات شبكية
            if current_stamina >= 100:
                can_run, reason = await task.can_run()
                self.assertFalse(can_run)
                res = await task.safe_execute()
                self.assertTrue(res.skipped)
                self.assertIn("طاقة القلعة كافية", res.message)

            # 2. فحص قراءة الحزم من الذاكرة الحية (0-network)
            packs = task.get_available_stamina_packs()
            self.assertIsInstance(packs, dict)
            self.assertIn("total_stamina", packs)
            self.assertIn("details", packs)
            self.assertGreater(packs["total_stamina"], 0)

            # 3. اختبار المحاكاة الآمنة لاستهلاك الحزم (Read-Only Mock Interceptor لحماية الحساب من أي استهلاك حقيقي)
            sim_init_data = json.loads(json.dumps(conn.init_data))
            mock_conn = MockConnection(sim_init_data)
            sim_task = StaminaTask(mock_conn, None, {
                "enabled": True,
                "min_stamina": current_stamina + 75,
                "mode": "auto",
                "allow_buy": False
            })
            sim_res = await sim_task.run()
            self.assertTrue(sim_res.success)
            self.assertGreater(len(mock_conn.sent_queries), 0)
        finally:
            if conn:
                await conn.close()


if __name__ == "__main__":
    unittest.main()
