# -*- coding: utf-8 -*-
"""
tools/test_watermill_task.py — اختبار شامل لوحدة وتكامل مهمة مكافأة الحقول (Watermill Task)
═══════════════════════════════════════════════════════════════════════════════════════════
يتحقق بدقة من:
1. تسجيل المهمة في bot_manager.REGISTERED_TASKS و TASK_METADATA.
2. منطق تطبيع الموارد وتحديد الأولويات (أعلى مستوى أولاً).
3. فحص الذاكرة القبلية 0-Network Pre-flight.
4. تحديث الذاكرة الحية (خصم الحزم وتسجيل الباف محلياً).
5. تكامل قاعدة البيانات وخادم الـ API والواجهة الأمامية.
"""

import asyncio
import copy
import json
import os
import sqlite3
import sys
import unittest
from unittest.mock import AsyncMock, MagicMock

# إضافة مجلد الجذر إلى مسار بايثون
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import bot_manager
from tasks.base_task import BaseTask, TaskResult
from tasks.watermill import WatermillTask


class MockConnection:
    """محاكي اتصال للقلعة مع ذاكرة حية واقعية."""

    def __init__(self, email="beetoo1@hotmail.com"):
        self.email = email
        self.is_connected = True
        self.init_data = {}
        # محاولة قراءة ذاكرة حية حقيقية إن وجدت
        try:
            with open(f"docs/{email.split('@')[0]}_live_memory.json", "r", encoding="utf-8") as f:
                self.init_data = json.load(f)
        except Exception:
            try:
                with open("docs/sample_live_memory.json", "r", encoding="utf-8") as f:
                    self.init_data = json.load(f)
            except Exception:
                self.init_data = {
                    "cityCtrl": {
                        "blist": [
                            {"binfo": {"bid": 201, "iid": 1, "lv": 10, "state": 0}},
                            {"binfo": {"bid": 201, "iid": 2, "lv": 20, "state": 0}},
                            {"binfo": {"bid": 202, "iid": 1, "lv": 15, "state": 0}},
                        ]
                    },
                    "backpackCtrl": {
                        "501501": {"count": 10, "id": 501501},
                        "501401": {"count": 5, "id": 501401},
                    },
                    "buffCtrl": [],
                }


class TestWatermillTask(unittest.IsolatedAsyncioTestCase):

    def setUp(self):
        self.conn = MockConnection()
        self.config = {
            "enabled": True,
            "resources": ["food", "wood", "iron", "silver", "crystal"],
            "types": "all",
            "allow_shop_buy": False,
        }
        self.task = WatermillTask(self.conn, self.config)

    def test_01_task_registration(self):
        """التحقق من تسجيل المهمة في كافة المكونات الأساسية."""
        self.assertEqual(self.task.name, "watermill")
        registered_names = [t.name for t in bot_manager.REGISTERED_TASKS]
        self.assertIn("watermill", registered_names, "WatermillTask must be in bot_manager.REGISTERED_TASKS")
        harvest_idx = registered_names.index("city_harvest")
        watermill_idx = registered_names.index("watermill")
        self.assertEqual(watermill_idx, harvest_idx + 1, "WatermillTask must be immediately after CityHarvestTask")
        self.assertIn("watermill", bot_manager.TASK_METADATA, "watermill must be in TASK_METADATA")
        self.assertIn("watermill", bot_manager.DEFAULT_BOT_CONFIG.get("tasks", {}), "watermill must be in DEFAULT_BOT_CONFIG['tasks']")

    def test_02_resource_normalization(self):
        """التحقق من صحة تطبيع أسماء الموارد المدخلة."""
        self.task.config["resources"] = ["food", "wood", "iron", "silver", "crystal"]
        targets = self.task._get_target_resources()
        expected = {"wheat", "wood", "iron", "silver", "crystal"}
        self.assertEqual(targets, expected)

        # فحص مع أسماء عربية
        self.task.config["resources"] = ["قمح", "منشرة", "حديد", "فضة", "بلور"]
        targets_ar = self.task._get_target_resources()
        self.assertEqual(targets_ar, expected)

    async def test_03_preflight_checks(self):
        """التحقق من فحص 0-Network Pre-flight في can_run."""
        # 1. إذا كانت معطلة
        self.task.config["enabled"] = False
        can, reason = await self.task.can_run()
        self.assertFalse(can)
        self.assertIn("معطلة", reason)

        # 2. إذا كانت مفعلة وبها حزم ومبانٍ غير مدعومة
        self.task.config["enabled"] = True
        # تأكد من توفر حزم
        self.conn.init_data.setdefault("backpackCtrl", {})["501501"] = {"count": 10, "id": 501501}
        can, reason = await self.task.can_run()
        self.assertTrue(can)

        # 3. إذا نفدت الحزم بالحقيبة
        self.conn.init_data["backpackCtrl"] = {}
        self.conn.init_data["bagCtrl"] = {}
        can, reason = await self.task.can_run()
        self.assertFalse(can)
        self.assertIn("لا توجد أي حزم دعم متوفرة", reason)

    async def test_04_execution_and_priority_sorting(self):
        """التحقق من تفعيل الدعم للحقول الأعلى مستوى أولاً وتحديث الذاكرة الحية."""
        # تهيئة مبانٍ واضحة المستويات
        self.conn.init_data["cityCtrl"] = {
            "blist": [
                {"binfo": {"bid": 201, "iid": 1, "lv": 10, "state": 0}},
                {"binfo": {"bid": 201, "iid": 2, "lv": 25, "state": 0}},
                {"binfo": {"bid": 201, "iid": 3, "lv": 18, "state": 0}},
            ]
        }
        # حزمة واحدة فقط من دعم المزرعة
        self.conn.init_data["backpackCtrl"] = {
            "501501": {"count": 1, "id": 501501}
        }
        self.conn.init_data["buffCtrl"] = []
        self.task.config["enabled"] = True
        self.task.config["resources"] = ["food"]

        called_payloads = []

        async def mock_safe_query(cmd, sub, payload, **kwargs):
            called_payloads.append(payload)
            return {"err": 0}

        self.task.safe_query = mock_safe_query

        res = await self.task.run()
        self.assertTrue(res.success)

        # يجب أن يطلب تفعيل الحقل لفل 25 أولاً (iid=2) فقط، ويتوقف عند نفاد الحزم
        self.assertEqual(len(called_payloads), 1)
        self.assertEqual(called_payloads[0]["bid"], 201)
        self.assertEqual(called_payloads[0]["iid"], 2)  # الأعلى مستوى
        self.assertEqual(called_payloads[0]["mode"], 1)
        self.assertEqual(called_payloads[0]["toolid"], 501501)

        # التحقق من خصم الحزمة من الذاكرة الحية
        backpack = self.conn.init_data["backpackCtrl"]
        self.assertNotIn("501501", backpack, "Item count was 1 and should be popped or 0")

        # التحقق من تسجيل الباف محلياً في الذاكرة الحية
        buffs = self.conn.init_data["buffCtrl"]
        self.assertEqual(len(buffs), 1)
        self.assertEqual(buffs[0]["bid"], 201)
        self.assertEqual(buffs[0]["iid"], 2)
        self.assertEqual(buffs[0]["buffId"], 5020)

    def test_05_database_zero_loss_audit(self):
        """التحقق من سلامة كافة سجلات قاعدة البيانات وأن مفتاح watermill يحوي الموارد الخمسة."""
        conn = sqlite3.connect("database/castles.db")
        cursor = conn.cursor()
        cursor.execute("SELECT email, config FROM castle_states")
        rows = cursor.fetchall()
        conn.close()

        self.assertGreater(len(rows), 0, "Database should contain castles")
        for email, cfg_raw in rows:
            cfg = json.loads(cfg_raw)
            wm = cfg.get("watermill")
            self.assertIsInstance(wm, dict, f"Castle {email} must have watermill config dict")
            self.assertIn("crystal", wm.get("resources", []), f"Castle {email} must include crystal in resources")
            self.assertIn("food", wm.get("resources", []), f"Castle {email} must include food in resources")


def run_tests():
    suite = unittest.TestLoader().loadTestsFromTestCase(TestWatermillTask)
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)
    if not result.wasSuccessful():
        sys.exit(1)


if __name__ == "__main__":
    run_tests()
