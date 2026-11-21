# -*- coding: utf-8 -*-
"""
tools/test_march_manager.py
فحص واختبار معماري شامل لمدير المسيرات والفيالق (MarchManagerTask):
1. التحقق من خصائص وإعدادات كلاس MarchManagerTask ووراثته من BaseTask.
2. التحقق من آلية تسجيل المهام الفرعية (Sub-tasks Registry).
3. اختبار الفحص القبلي والتحليل الزمني لطوابير المسيرات (0-Network ETA).
4. التحقق من تسجيل المهمة في bot_manager، وapi_server، وقاعدة البيانات castles.db.
"""

import asyncio
import json
import os
import sys
import time

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.base_task import BaseTask, TaskResult
from tasks.march_manager import (
    MarchManagerTask,
    DEFAULT_MAX_DURATION_MINUTES,
    DEFAULT_MAX_DURATION_SECONDS,
)
import bot_manager
from api_server import CastleConfigModel, MarchManagerConfigModel
import core.database as db


class DummyMockConnection:
    """محاكي اتصال لاختبار دوال الذاكرة الحية 0-Network بدون ملامسة السيرفر."""
    def __init__(self):
        self.is_connected = True
        self.uid = "123456"
        self.init_data = {
            "technologyCtrl": {
                "24011": 1,  # فيلق البعثة I (+1)
                "24017": 1,  # فيلق البعثة II (+1)
            },
            "lordInfoCtrl": {
                "base": {"health": 120},
            },
            "local_queues": [
                {
                    "id": "q_101",
                    "uid": "123456",
                    "status": 1,
                    "type": 1,
                    "finishTime": time.time() + 450.0,
                    "to": {"x": 350, "y": 720},
                },
                {
                    "id": "q_102",
                    "uid": "123456",
                    "status": 2,
                    "type": 2,
                    "finishTime": time.time() + 820.0,
                    "to": {"x": 360, "y": 710},
                },
            ]
        }
        self.local_queues = self.init_data["local_queues"]


class SampleSubTaskA(BaseTask):
    name = "sample_sub_a"
    alias = "sample_sub_a"

    async def run(self) -> TaskResult:
        self.log("🚀 [SampleSubTaskA] تم تنفيذ المهمة الفرعية بنجاح.")
        return TaskResult.ok("تم إرسال المسيرة الأولى")


class SampleSubTaskB(BaseTask):
    name = "sample_sub_b"
    alias = "sample_sub_b"

    async def run(self) -> TaskResult:
        self.log("🎯 [SampleSubTaskB] تم تنفيذ المهمة الفرعية بنجاح.")
        return TaskResult.ok("تم إرسال المسيرة الثانية")


async def run_tests():
    print("=" * 70)
    print("🧪 بدء الاختبارات المعمارية لمدير المسيرات (MarchManagerTask)...")
    print("=" * 70)

    # 1. اختبار البنية والوراثة
    assert issubclass(MarchManagerTask, BaseTask), "MarchManagerTask يجب أن يرث من BaseTask"
    assert MarchManagerTask.name == "march_manager", "اسم المهمة يجب أن يكون march_manager"
    print("✅ 1. البنية والوراثة من BaseTask مطابقة للمعايير.")

    # 2. اختبار الاتصال والذاكرة الحية 0-Network
    mock_conn = DummyMockConnection()
    logs = []
    task = MarchManagerTask(mock_conn, log_func=lambda m: logs.append(m), config={"enabled": True, "max_duration_minutes": 20})

    assert task.is_active is True
    assert task.max_duration_minutes == 20
    assert task.max_duration_seconds == 1200.0

    # فحص سعة الفيالق: أساس 1 + بحث 1 + VIP 1 = 3 فيالق
    max_cap = task.get_max_marches_capacity()
    active_count = task.get_active_marches_count()
    avail_count = task.get_available_marches_count()

    print(f"  - السعة القصوى للفيالق: {max_cap}")
    print(f"  - الفيالق النشطة بالخارج: {active_count}")
    print(f"  - الفيالق الشاغرة المتاحة: {avail_count}")
    assert max_cap >= 3, f"السعة المتوقعة 3 على الأقل ولكن وجدت {max_cap}"
    assert active_count == 2, f"النشطة المتوقعة 2 ولكن وجدت {active_count}"
    assert avail_count == max_cap - 2

    # فحص الـ ETA
    eta_summary = task.get_active_marches_eta()
    print(f"  - تحليل أزمنة العودة (ETA): أقرب عودة بعد {eta_summary['earliest_return_seconds']}ث | أبعد عودة بعد {eta_summary['latest_return_seconds']}ث")
    assert eta_summary["active_count"] == 2
    assert eta_summary["earliest_return_seconds"] > 0
    print("✅ 2. فحص الذاكرة الحية والسعة وتحليل الطوابير (0-Network) ناجح 100%.")

    # 3. اختبار آلية تسجيل المهام الفرعية (Sub-tasks Registry)
    MarchManagerTask.clear_subtasks()
    assert len(MarchManagerTask.get_registered_subtasks()) == 0

    MarchManagerTask.register_subtask(SampleSubTaskA)
    MarchManagerTask.register_subtask(SampleSubTaskB)
    assert len(MarchManagerTask.get_registered_subtasks()) == 2
    print("✅ 3. تسجيل المهام الفرعية وإدارتها (Subtasks Registry) يعمل بنجاح.")

    # 4. اختبار تشغيل المهام الفرعية تلو الأخرى وحساب المدة والخروج الفوري
    res = await task.run()
    assert res.success is True
    print(f"  - نتيجة التشغيل: {res.message}")
    print("✅ 4. تشغيل المهام الفرعية تلو الأخرى والخروج الفوري عند الإنجاز تم بنجاح.")

    # اختبار الخروج الفوري عند عدم وجود مهام فرعية مسجلة
    MarchManagerTask.clear_subtasks()
    t_start = time.perf_counter()
    res_empty = await task.run()
    t_end = time.perf_counter()
    assert res_empty.success is True
    assert (t_end - t_start) < 0.5, "الخروج يجب أن يكون فورياً عند عدم وجود مهام"
    print(f"✅ 5. الخروج الفوري عند عدم وجود مهام فرعية استغرق: {(t_end - t_start)*1000:.2f} مللي ثانية.")

    # 5. اختبار التكامل مع bot_manager
    assert MarchManagerTask in bot_manager.REGISTERED_TASKS, "MarchManagerTask غير مسجل في REGISTERED_TASKS"
    assert "march_manager" in bot_manager.TASK_METADATA, "march_manager غير موجود في TASK_METADATA"
    assert "march_manager" in bot_manager.DEFAULT_BOT_CONFIG["tasks"], "march_manager غير موجود في DEFAULT_BOT_CONFIG"
    print("✅ 6. التكامل مع bot_manager (التسجيل والإعدادات والميتاداتا) محقق بالكامل.")

    # 6. اختبار التكامل مع api_server Pydantic model
    cfg_test = CastleConfigModel.model_validate({
        "march_manager": {
            "enabled": True,
            "max_duration_minutes": 20,
            "combat": {"enabled": True},
            "gather": {"enabled": True},
        }
    })
    assert cfg_test.march_manager is not None
    assert cfg_test.march_manager.enabled is True
    assert cfg_test.march_manager.max_duration_minutes == 20
    print("✅ 7. التكامل مع api_server وتحقق Pydantic ناجح 100%.")

    # 7. اختبار التحقق المباشر من قاعدة البيانات
    c_data = db.get_castle_by_id("beetoo1@hotmail.com")
    assert c_data is not None
    cfg_dict = c_data.get("config") if isinstance(c_data.get("config"), dict) else json.loads(c_data.get("config") or "{}")
    assert "march_manager" in cfg_dict, "march_manager غير موجود في config الخاص بـ beetoo1 في قاعدة البيانات"
    print(f"✅ 8. التحقق من قاعدة البيانات: القلعة تحتوي على march_manager -> {cfg_dict['march_manager']}")

    print("\n🎉 كافة الاختبارات المعمارية اجتيزت بنجاح وتوافق 100% مع معايير المشروع!")


if __name__ == "__main__":
    asyncio.run(run_tests())
