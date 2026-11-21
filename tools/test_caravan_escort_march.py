"""
اختبار شامل ودقيق لدالة فحص فيلق حراسة قافلة الكنز:
is_caravan_escort_march_active & is_caravan_escort_active
"""

import os
import sys
import unittest
from unittest.mock import MagicMock

# إدراج جذر المشروع في sys.path لضمان استيراد الحزم
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from tasks.base_task import BaseTask


class DummyCastleTask(BaseTask):
    """صنف اختبار يرث من BaseTask لاختبار وظائف المسيرات."""

    def __init__(self, uid: str = "1001"):
        conn = MagicMock()
        conn.creds = MagicMock()
        conn.creds.uid = uid
        conn.init_data = {"lordInfoCtrl": {"base": {"uid": uid}}}
        conn.is_connected = True
        conn.local_queues = []
        conn.memory_engine = None
        super().__init__(conn=conn, config={"enabled": True})
        self.name = "dummy_test_task"

    async def run(self):
        return True


class TestCaravanEscortMarch(unittest.TestCase):

    def setUp(self):
        self.task = DummyCastleTask(uid="1001")

    def test_no_marches(self):
        """1. لا توجد أي مسيرات على الإطلاق."""
        self.task.conn.local_queues = []
        self.assertFalse(self.task.is_caravan_escort_march_active())
        self.assertFalse(self.task.is_caravan_escort_active)
        self.assertFalse(self.task.has_caravan_escort_march())

    def test_other_unrelated_marches(self):
        """2. توجد مسيرات لجمع موارد وأطلال فقط (ليست قوافل)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "moveLineType": 4},  # أطلال
            {"id": "q2", "uid": "1001", "status": 2, "moveLineType": 4, "to": {"mapType": 5}},  # جمع
        ]
        self.assertFalse(self.task.is_caravan_escort_march_active())
        self.assertFalse(self.task.is_caravan_escort_active)

    def test_other_player_caravan_march(self):
        """3. توجد مسيرة قافلة ولكنها تابعة للاعب آخر (UID مختلف)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "9999", "status": 1, "moveLineType": 22},  # قافلة لاعب آخر
        ]
        self.assertFalse(self.task.is_caravan_escort_march_active())

    def test_own_caravan_march_server_type(self):
        """4. فيلق حراسة القافلة الخاصة نشط بالمعيار السيرفري (moveLineType = 22)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "moveLineType": 22},
        ]
        self.assertTrue(self.task.is_caravan_escort_march_active())
        self.assertTrue(self.task.is_caravan_escort_active)

    def test_own_caravan_march_client_type(self):
        """5. فيلق حراسة القافلة الخاصة نشط بالمعيار العميل (moveLineType = 11)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "moveLineType": 11},
        ]
        self.assertTrue(self.task.is_caravan_escort_march_active())

    def test_own_caravan_march_map_type_16(self):
        """6. فيلق حراسة القافلة يحمل الهدف أو الانطلاق mapType = 16 (mapTypeEscort)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "to": {"mapType": 16, "id": "1-2-16-10"}},
        ]
        self.assertTrue(self.task.is_caravan_escort_march_active())

    def test_own_caravan_march_with_cart_data(self):
        """7. فيلق يحمل بيانات عربة البضائع (cartLv / cartId)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "data": {"cartLv": 4, "cartId": 2386}},
        ]
        self.assertTrue(self.task.is_caravan_escort_march_active())

    def test_exclude_ally_assist_march(self):
        """8. استبعاد مسيرة مساعدة حليف بالتحالف (moveLineType = 23 أو 13)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 1, "moveLineType": 23},  # assist server
            {"id": "q2", "uid": "1001", "status": 1, "moveLineType": 13},  # assist client
            {"id": "q3", "uid": "1001", "status": 1, "moveLineType": 23, "to": {"mapType": 16}},
        ]
        self.assertFalse(self.task.is_caravan_escort_march_active())
        self.assertFalse(self.task.is_caravan_escort_active)

    def test_inactive_caravan_status(self):
        """9. مسيرة قافلة غير نشطة (status = 5 أو 6 منتهية)."""
        self.task.conn.local_queues = [
            {"id": "q1", "uid": "1001", "status": 5, "moveLineType": 22},
        ]
        self.assertFalse(self.task.is_caravan_escort_march_active())

    def test_init_data_fallback(self):
        """10. قراءة المسيرات من init_data['local_queues'] عندما لا تكون على كائن conn مباشرة."""
        self.task.conn.local_queues = None
        self.task.conn.init_data = {
            "lordInfoCtrl": {"base": {"uid": "1001"}},
            "local_queues": [
                {"id": "q1", "uid": "1001", "status": 2, "moveLineType": 22}
            ]
        }
        self.assertTrue(self.task.is_caravan_escort_march_active())

    def test_with_live_memory_engine(self):
        """11. اختبار التوافق مع محرك الذاكرة الحية الحقيقي (LiveMemoryEngine)."""
        from core.live_memory import LiveMemoryEngine

        engine = LiveMemoryEngine(owner_uid="1001")
        self.task.conn.memory_engine = engine

        # لا توجد مسيرات في المحرك
        self.assertFalse(self.task.is_caravan_escort_march_active())

        # محاكاة إشعار وصول مسيرة حراسة القافلة الحية عبر البث الحقيقي (msgType=1 ADD)
        escort_march_msg = {
            "msgType": 1,
            "data": {
                "id": "1001-march-caravan-1",
                "uid": "1001",
                "status": 1,
                "moveLineType": 22,
                "to": {"mapType": 16, "id": "1-2-16-55"},
            }
        }
        engine.handle_notify(202, escort_march_msg)

        # التحقق من أن الدالة تلتقط المسيرة مباشرة من المحرك بـ 0 استهلاك شبكي
        self.assertTrue(self.task.is_caravan_escort_march_active())
        self.assertTrue(self.task.is_caravan_escort_active)

        # محاكاة وصول إشعار انتهاء/إزالة المسيرة (msgType=2 REMOVE)
        remove_march_msg = {
            "msgType": 2,
            "data": {
                "id": "1001-march-caravan-1",
            }
        }
        engine.handle_notify(202, remove_march_msg)

        # التحقق من العودة إلى False فور إزالة المسيرة
        self.assertFalse(self.task.is_caravan_escort_march_active())
        self.assertFalse(self.task.is_caravan_escort_active)


if __name__ == "__main__":
    unittest.main()
