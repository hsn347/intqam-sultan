# -*- coding: utf-8 -*-
"""
اختبارات شاملة لوظائف معمل المواد (Material Workshop / stuffWorkshopCtrl) في BaseTask.
يشمل التحقق من:
  1. جلب المواد التي تعامل في المعمل ومواقعها وحالتها (قيد التكرير الفعلي مقابل في الانتظار).
  2. حساب السعة الكلية للمعمل المفتوحة للقلعة بدقة.
  3. التحقق من وجود خانات شاغرة وعددها ومواقعها.
  4. فحص المادة المكتملة الجاهزة للاستلام (doneID).
  5. فحص طابور التكرير النشط (queueType 1238) والوقت المتبقي.
  6. فحص معالجة الحالات الحدية (معمل ممتلئ، معمل فارغ، بيانات غير موجودة).
"""

import copy
import json
import os
import sys
import time
from typing import Any, Dict

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from tasks.base_task import (
    BaseTask,
    MATERIAL_WORKSHOP_CATALOG,
    QUEUE_TYPE_STUFF_WORKSHOP,
)


class MockTaskConnection:
    """محاكي اتصال للذاكرة الحية لأغراض الفحص."""

    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = init_data
        self.is_connected = True

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        return {"err": 0, "result": {}}


class ConcreteTestTask(BaseTask):
    name = "test_material_workshop"

    async def run(self):
        return None


def run_all_tests():
    print("=" * 70)
    print("🧪 بدء الاختبارات الشاملة لدوال معمل المواد (Material Workshop)...")
    print("=" * 70)

    # ─────────────────────────────────────────────────────────────
    # اختبار 1: التحقق من دقة قاموس المواد ومستوياتها (Catalog & Resolver)
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 1] اختبار استخراج معلومات المواد وأسمائها ومستوياتها...")
    info_herb_1 = BaseTask.resolve_material_info(200101)
    assert info_herb_1["name"] == "عشب المستوى 1", f"Unexpected name: {info_herb_1['name']}"
    assert info_herb_1["quality"] == 1, f"Unexpected quality: {info_herb_1['quality']}"
    assert info_herb_1["base_name"] == "عشب", f"Unexpected base: {info_herb_1['base_name']}"

    info_ruby_2 = BaseTask.resolve_material_info(200402)
    assert info_ruby_2["name"] == "ياقوت المستوى 2", f"Unexpected name: {info_ruby_2['name']}"
    assert info_ruby_2["quality"] == 2, f"Unexpected quality: {info_ruby_2['quality']}"

    info_horn_3 = BaseTask.resolve_material_info(200603)
    assert info_horn_3["name"] == "قرن المستوى 3", f"Unexpected name: {info_horn_3['name']}"
    assert info_horn_3["quality"] == 3, f"Unexpected quality: {info_horn_3['quality']}"

    # فحص معرف أساسي بسيط (10..15)
    info_bronze_base = BaseTask.resolve_material_info(12)
    assert info_bronze_base["name"] == "برونز", f"Unexpected base: {info_bronze_base['name']}"
    print("  ✅ [Suite 1] اجتاز فحص استخراج تفاصيل المواد ومستوياتها بنجاح!")

    # ─────────────────────────────────────────────────────────────
    # اختبار 2: معمل فارغ بالكامل (كافة الخانات المفتوحة شاغرة)
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 2] اختبار معمل فارغ بالكامل (4 خانات مفتوحة، 3 مغلقة)...")
    mock_data_empty = {
        "stuffWorkshopCtrl": {
            "count": 20,
            "discount": 1,
            "doneID": 0,
            "list": [
                {"type": 0},
                {"type": 0},
                {"type": 0},
                {"type": 0},
                {"gold": 500, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
            ],
        }
    }
    task_empty = ConcreteTestTask(MockTaskConnection(mock_data_empty))
    status_empty = task_empty.get_material_workshop_status()

    assert status_empty["has_workshop"] is True
    assert status_empty["total_slots"] == 7
    assert status_empty["total_unlocked_slots"] == 4
    assert status_empty["locked_slots_count"] == 3
    assert status_empty["currently_producing_count"] == 0
    assert status_empty["vacant_slots_count"] == 4
    assert status_empty["has_vacant_slot"] is True
    assert status_empty["vacant_positions"] == [1, 2, 3, 4]
    assert len(status_empty["materials_in_process"]) == 0
    assert status_empty["has_finished_material"] is False
    print("  ✅ [Suite 2] اجتاز فحص المعمل الفارغ بنجاح!")

    # ─────────────────────────────────────────────────────────────
    # اختبار 3: معمل به مواد قيد المعالجة وطابور نشط
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 3] اختبار معمل به مواد قيد المعالجة (تكرير فعلي + قائمة انتظار)...")
    now_ts = int(time.time())
    mock_data_active = {
        "stuffWorkshopCtrl": {
            "count": 18,
            "discount": 0.9,
            "doneID": 0,
            "list": [
                {"type": 0, "mid": 200101},  # الخانة 1: عشب مستوى 1 (قيد التكرير)
                {"type": 0, "mid": 200302},  # الخانة 2: برونز مستوى 2 (في الانتظار)
                {"type": 0},                 # الخانة 3: شاغرة
                {"type": 0},                 # الخانة 4: شاغرة
                {"gold": 500, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
            ],
        },
        "queueCtrl": {
            "q1": {
                "type": 1238,
                "begintime": now_ts - 1000,
                "totaltime": 14400,
                "finishTime": now_ts + 13400,
            }
        },
    }
    task_active = ConcreteTestTask(MockTaskConnection(mock_data_active))
    status_active = task_active.get_material_workshop_status()

    assert status_active["total_unlocked_slots"] == 4
    assert status_active["currently_producing_count"] == 2
    assert status_active["vacant_slots_count"] == 2
    assert status_active["has_vacant_slot"] is True
    assert status_active["vacant_positions"] == [3, 4]

    mats = status_active["materials_in_process"]
    assert len(mats) == 2

    # فحص المادة الأولى (في الخانة 1)
    mat1 = mats[0]
    assert mat1["position"] == 1
    assert mat1["material_id"] == 200101
    assert mat1["name"] == "عشب المستوى 1"
    assert mat1["status"] == "refining"
    assert mat1["remaining_seconds"] is not None and mat1["remaining_seconds"] > 0
    assert mat1["finish_time"] == now_ts + 13400

    # فحص المادة الثانية (في الخانة 2)
    mat2 = mats[1]
    assert mat2["position"] == 2
    assert mat2["material_id"] == 200302
    assert mat2["name"] == "برونز المستوى 2"
    assert mat2["status"] == "queued"
    assert mat2["remaining_seconds"] is None
    print("  ✅ [Suite 3] اجتاز فحص المواد قيد المعالجة وطابور التكرير النشط بنجاح!")

    # ─────────────────────────────────────────────────────────────
    # اختبار 4: معمل ممتلئ بالكامل (جميع الخانات المفتوحة مشغولة)
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 4] اختبار معمل ممتلئ بالكامل (جميع الخانات المفتوحة مشغولة)...")
    mock_data_full = {
        "stuffWorkshopCtrl": {
            "count": 15,
            "discount": 1,
            "doneID": 0,
            "list": [
                {"type": 0, "mid": 200101},
                {"type": 0, "mid": 200201},
                {"type": 0, "mid": 200301},
                {"type": 0, "mid": 200401},
                {"gold": 500, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
            ],
        }
    }
    task_full = ConcreteTestTask(MockTaskConnection(mock_data_full))
    status_full = task_full.get_material_workshop_status()

    assert status_full["total_unlocked_slots"] == 4
    assert status_full["currently_producing_count"] == 4
    assert status_full["vacant_slots_count"] == 0
    assert status_full["has_vacant_slot"] is False
    assert status_full["vacant_positions"] == []
    print("  ✅ [Suite 4] اجتاز فحص المعمل الممتلئ وحظر الشغور بنجاح!")

    # ─────────────────────────────────────────────────────────────
    # اختبار 5: مادة مكتملة جاهزة للاستلام (doneID > 0)
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 5] اختبار مادة مكتملة جاهزة للاستلام (doneID > 0)...")
    mock_data_done = {
        "stuffWorkshopCtrl": {
            "count": 20,
            "discount": 1,
            "doneID": 200502,  # فرو مستوى 2
            "list": [
                {"type": 0},
                {"type": 0},
                {"type": 0},
                {"type": 0},
                {"gold": 500, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
                {"gold": 500, "vip": 12, "type": 1},
            ],
        }
    }
    task_done = ConcreteTestTask(MockTaskConnection(mock_data_done))
    status_done = task_done.get_material_workshop_status()

    assert status_done["has_finished_material"] is True
    assert status_done["done_material_id"] == 200502
    assert status_done["finished_material"] is not None
    assert status_done["finished_material"]["name"] == "فرو المستوى 2"
    assert status_done["finished_material"]["ready_to_collect"] is True
    print("  ✅ [Suite 5] اجتاز فحص كشف المادة المكتملة بنجاح!")

    # ─────────────────────────────────────────────────────────────
    # اختبار 6: معالجة الحالات الحدية (بيانات غير موجودة)
    # ─────────────────────────────────────────────────────────────
    print("\n[Suite 6] اختبار الحالات الحدية (غياب stuffWorkshopCtrl)...")
    task_none = ConcreteTestTask(MockTaskConnection({}))
    status_none = task_none.get_material_workshop_status()

    assert status_none["has_workshop"] is False
    assert status_none["total_unlocked_slots"] == 0
    assert status_none["has_vacant_slot"] is False
    print("  ✅ [Suite 6] اجتاز فحص الحالات الحدية بنجاح!")

    print("\n" + "=" * 70)
    print("🎉 كافة الاختبارات (6/6) اجتازت بنجاح تام 100% وبدون أدنى خطأ!")
    print("=" * 70)


if __name__ == "__main__":
    run_all_tests()
