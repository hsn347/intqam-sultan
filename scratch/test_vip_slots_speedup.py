"""
اختبار تحقق مستقل لدوال حساب طوابير البناء والتسريع المجاني لـ VIP في tasks/building.py
"""

import json
import time
import unittest
from tasks.building import BuildingTask


class MockConnection:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}


class TestVIPFix(unittest.TestCase):
    def setUp(self):
        # تحميل بيانات الذاكرة الحية الحقيقية لـ beetoo1 و beetoo3
        with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
            self.beetoo1_memory = json.load(f)

        with open("docs/beetoo3_live_memory.json", "r", encoding="utf-8") as f:
            self.beetoo3_memory = json.load(f)

    def test_beetoo1_expired_vip(self):
        """التحقق من بيانات beetoo1: VIP 10 منتهي (vipEndTime=0)"""
        conn = MockConnection(self.beetoo1_memory)
        task = BuildingTask(conn, config={"enabled": True})

        # 1. طوابير البناء يجب أن ترجع 1 بدقة
        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 1, f"Expected 1 slot for beetoo1 with expired VIP, got {slots}")

        # 2. ثواني التسريع المجاني يجب أن ترجع 300ث (5 دقائق الحد الأساسي)
        free_sec = task.calculate_free_speedup_seconds()
        self.assertEqual(free_sec, 300, f"Expected 300s free speedup for beetoo1 with expired VIP, got {free_sec}")

    def test_beetoo3_expired_vip(self):
        """التحقق من بيانات beetoo3: VIP 9 منتهي (vipEndTime=0)"""
        conn = MockConnection(self.beetoo3_memory)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 1, f"Expected 1 slot for beetoo3 with expired VIP, got {slots}")

        free_sec = task.calculate_free_speedup_seconds()
        self.assertEqual(free_sec, 300, f"Expected 300s free speedup for beetoo3 with expired VIP, got {free_sec}")

    def test_various_vip_end_formats(self):
        """التحقق من مرونة التعامل مع مختلف صيغ vipEndTime (int, str, None, float, invalid)"""
        cases = [
            (0, False),
            ("0", False),
            ("", False),
            (None, False),
            (time.time() - 3600, False),  # ماضي
            (str(int(time.time() - 3600)), False),  # ماضي كنص
            ("invalid_timestamp", False),
            (time.time() + 3600, True),  # نشط في المستقبل
            (str(int(time.time() + 3600)), True),  # نشط في المستقبل كنص
            ((time.time() + 3600) * 1000, True),  # نشط بالميلي ثانية
        ]

        for vip_end_val, expected_active in cases:
            mock_data = {
                "lordInfoCtrl": {
                    "vip": {
                        "level": 10,
                        "vipEndTime": vip_end_val,
                    }
                },
                "cityCtrl": {"queue": {}},
                "queueCtrl": {},
            }
            conn = MockConnection(mock_data)
            task = BuildingTask(conn, config={"enabled": True})

            is_active, lv = task._is_vip_active()
            self.assertEqual(is_active, expected_active, f"Failed for vipEndTime={vip_end_val}: expected active={expected_active}")

            slots = task.calculate_max_build_slots()
            expected_slots = 2 if expected_active else 1
            self.assertEqual(slots, expected_slots, f"Failed slots for vipEndTime={vip_end_val}: expected {expected_slots}, got {slots}")

            free_sec = task.calculate_free_speedup_seconds()
            expected_free = 5400 if expected_active else 300  # VIP 10 = 5400s (90 min)
            self.assertEqual(free_sec, expected_free, f"Failed free_sec for vipEndTime={vip_end_val}: expected {expected_free}, got {free_sec}")

    def test_vip_level_1_active(self):
        """التحقق من أن VIP 1 النشط يمنح تسريع 360ث ولكنه لا يمنح الطابور الثاني (VIP >= 2 مطلوب)"""
        mock_data = {
            "lordInfoCtrl": {
                "vip": {
                    "level": 1,
                    "vipEndTime": time.time() + 3600,
                }
            },
            "cityCtrl": {"queue": {}},
            "queueCtrl": {},
        }
        conn = MockConnection(mock_data)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 1, f"VIP 1 should only grant 1 slot, got {slots}")

        free_sec = task.calculate_free_speedup_seconds()
        self.assertEqual(free_sec, 360, f"VIP 1 should grant 360s, got {free_sec}")

    def test_rented_queue_with_expired_vip(self):
        """التحقق من أن استئجار الطابور 1201 يمنح الطابور الثاني حتى مع انتهاء VIP"""
        now = time.time()
        mock_data = {
            "lordInfoCtrl": {
                "vip": {
                    "level": 10,
                    "vipEndTime": 0,
                }
            },
            "cityCtrl": {
                "queue": {
                    "1201": {
                        "starttime": now,
                        "totaltime": 3600,
                    }
                }
            },
            "queueCtrl": {},
        }
        conn = MockConnection(mock_data)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 2, "Rented queue 1201 should grant 2 slots even with expired VIP")

    def test_actively_building_queue1201_with_expired_vip(self):
        """التحقق من أن الطابور 1201 النشط بالبناء في queueCtrl يمنح 2 طابور حتى مع انتهاء VIP"""
        now = time.time()
        mock_data = {
            "lordInfoCtrl": {
                "vip": {
                    "level": 10,
                    "vipEndTime": 0,
                }
            },
            "cityCtrl": {"queue": {}},
            "queueCtrl": {
                "1201": {
                    "starttime": now,
                    "totaltime": 3600,
                    "data": {"bid": "102", "lv": "35", "index": "1"},
                }
            },
        }
        conn = MockConnection(mock_data)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 2, "Actively building queue 1201 should grant 2 slots even with expired VIP")

    def test_expired_building_queue1201_returns_1(self):
        """التحقق من أن الطابور 1201 المنتهي بالبناء في queueCtrl يرجع 1 طابور"""
        mock_data = {
            "lordInfoCtrl": {
                "vip": {
                    "level": 10,
                    "vipEndTime": 0,
                }
            },
            "cityCtrl": {"queue": {}},
            "queueCtrl": {
                "1201": {
                    "starttime": 1000,
                    "totaltime": 100,  # انتهى في الماضي البعيد
                    "data": {"bid": "102"},
                }
            },
        }
        conn = MockConnection(mock_data)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 1, "Expired building queue 1201 should return 1 slot")

    def test_busy_queue_1200_with_expired_vip_gives_zero_free_slots(self):
        """التحقق من أن انشغال طابور 1200 مع انتهاء VIP يعطي 0 خانة بناء متاحة (1/1 متاح: 0)"""
        now = time.time()
        mock_data = {
            "lordInfoCtrl": {
                "vip": {
                    "level": 10,
                    "vipEndTime": 0,
                }
            },
            "cityCtrl": {"queue": {}},
            "queueCtrl": {
                "1200": {
                    "starttime": now,
                    "totaltime": 3600,
                    "data": {"bid": "102", "lv": "40", "index": "1"},
                }
            },
        }
        conn = MockConnection(mock_data)
        task = BuildingTask(conn, config={"enabled": True})

        slots = task.calculate_max_build_slots()
        self.assertEqual(slots, 1, "Should have max 1 slot")

        # فحص الطوابير النشطة
        import asyncio
        active = asyncio.run(task.refresh_active_queues())
        self.assertEqual(len(active), 1, "Should have 1 active queue")
        self.assertIn("1200", active)

        free_slots = max(0, slots - len(active))
        self.assertEqual(free_slots, 0, "Free slots must be 0 when queue 1200 is busy and VIP expired")


if __name__ == "__main__":
    unittest.main()
