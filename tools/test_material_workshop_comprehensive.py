# -*- coding: utf-8 -*-
"""
tools/test_material_workshop_comprehensive.py — فحص واختبار شامل لحالات الحافة والأمان والمنطق التكراري
"""

import asyncio
import copy
import json
import os
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, BASE_DIR)

from tasks.material_workshop import MaterialWorkshopTask, DEFAULT_MATERIAL_IDS
from tasks.base_task import TaskResult

class MockConnection:
    def __init__(self, init_data=None, connected=True):
        self.is_connected = connected
        self.init_data = init_data or {}
        self.queries_log = []

    def get_ctrl(self, name):
        return self.init_data.get(name, {})

    async def query(self, cmd, sub, params=None):
        self.queries_log.append((cmd, sub, params))
        if cmd == "2021" and sub == "4": # collect (GET)
            self.init_data.setdefault("stuffWorkshopCtrl", {})["doneID"] = 0
            return {"err": 0, "result": []}
        elif cmd == "2021" and sub == "2": # refine (REFINERY)
            lst = self.init_data.setdefault("stuffWorkshopCtrl", {}).setdefault("list", [])
            for slot in lst:
                if slot.get("type") == 0 and "mid" not in slot:
                    slot["mid"] = params.get("id")
                    break
            return {"err": 0, "result": self.init_data["stuffWorkshopCtrl"]}
        return {"err": 0}

async def run_comprehensive_tests():
    print("=" * 70)
    print("🧪 بدء الاختبارات التركيبية المستقلة لمهمة معمل المواد (Edge Cases & Safety)...")
    print("=" * 70)

    # 1. اختبار الحساب المعطل (disabled config)
    print("\n[Case 1] اختبار المهمة عندما تكون معطلة...")
    conn = MockConnection()
    task = MaterialWorkshopTask(conn, config={"enabled": False})
    assert task.is_active is False
    can_run, reason = await task.can_run()
    assert can_run is False
    assert "معطلة" in reason
    print("  ✅ [Case 1] PASS")

    # 2. اختبار عدم وجود اتصال
    print("\n[Case 2] اختبار انقطاع الاتصال...")
    conn_disc = MockConnection(connected=False)
    task_disc = MaterialWorkshopTask(conn_disc, config={"enabled": True})
    can_run, reason = await task_disc.can_run()
    assert can_run is False
    assert "اتصال" in reason
    print("  ✅ [Case 2] PASS")

    # 3. اختبار عدم وجود بيانات معمل المواد بالذاكرة الحية
    print("\n[Case 3] اختبار غياب stuffWorkshopCtrl من الذاكرة الحية...")
    conn_no_ctrl = MockConnection(init_data={}, connected=True)
    task_no_ctrl = MaterialWorkshopTask(conn_no_ctrl, config={"enabled": True})
    can_run, reason = await task_no_ctrl.can_run()
    assert can_run is False
    print("  ✅ [Case 3] PASS")

    # 4. اختبار التراجع التلقائي عند تلف قائمة المواد المختارة في الإعدادات
    print("\n[Case 4] اختبار قائمة مواد مختارة تالفة أو فارغة وتطبيق الافتراضي...")
    task_bad_cfg = MaterialWorkshopTask(conn, config={"enabled": True, "selected_materials": "invalid_string"})
    assert task_bad_cfg.selected_materials == DEFAULT_MATERIAL_IDS
    task_empty_cfg = MaterialWorkshopTask(conn, config={"enabled": True, "selected_materials": []})
    assert task_empty_cfg.selected_materials == DEFAULT_MATERIAL_IDS
    print("  ✅ [Case 4] PASS")

    # 5. اختبار تخصيص مواد معينة فقط (Subset Selection)
    print("\n[Case 5] اختبار تخصيص مادتين فقط وتوزيع الـ Round-Robin عليهما حصراً...")
    custom_mats = [200101, 200401] # عشب + ياقوت فقط
    mock_data_partial = {
        "stuffWorkshopCtrl": {
            "doneID": 0,
            "list": [
                {"type": 0, "mid": 200101}, # خانة 1: عشب
                {"type": 0},                # خانة 2: شاغرة
                {"type": 0},                # خانة 3: شاغرة
                {"type": 0},                # خانة 4: شاغرة
                {"type": 1, "gold": 500},   # خانة 5: مقفلة
            ]
        }
    }
    conn_partial = MockConnection(init_data=copy.deepcopy(mock_data_partial))
    task_partial = MaterialWorkshopTask(conn_partial, config={"enabled": True, "selected_materials": custom_mats})
    res = await task_partial.run()
    assert res.success is True
    # بما أن هناك 3 خانات شاغرة، و 1 عشب قيد الإنتاج:
    # سيتم اختيار: ياقوت (لأن عدده 0) -> ثم عشب (لأن كلاهما 1) -> ثم ياقوت (لأن عدده 1 مقابل 2 عشب)
    # جميع المواد المضافة يجب أن تكون حصراً من custom_mats!
    refine_queries = [p["id"] for cmd, sub, p in conn_partial.queries_log if cmd == "2021" and sub == "2"]
    assert len(refine_queries) == 3
    for mid in refine_queries:
        assert mid in custom_mats
    assert refine_queries.count(200401) == 2 # ياقوت تم اختياره مرتين
    assert refine_queries.count(200101) == 1 # عشب تم اختياره مرة واحدة
    print(f"  -> تسلسل التكرير: {refine_queries} (توزيع متوازن عادل)")
    print("  ✅ [Case 5] PASS")

    # 6. اختبار استلام المادة الجاهزة وتفريغ الخانة فوراً
    print("\n[Case 6] اختبار استلام المادة الجاهزة (doneID) وتكرير مكانها...")
    mock_data_done = {
        "stuffWorkshopCtrl": {
            "doneID": 200601, # قرن جاهز للاستلام
            "list": [
                {"type": 0, "mid": 200101},
                {"type": 0, "mid": 200201},
                {"type": 0, "mid": 200301},
                {"type": 0}, # خانة شاغرة
                {"type": 1, "gold": 500},
            ]
        }
    }
    conn_done = MockConnection(init_data=copy.deepcopy(mock_data_done))
    task_done = MaterialWorkshopTask(conn_done, config={"enabled": True})
    res_done = await task_done.run()
    assert res_done.success is True
    assert "قرن المستوى 1" in res_done.data.get("collected", [])
    collect_queries = [q for q in conn_done.queries_log if q[0] == "2021" and q[1] == "4"]
    assert len(collect_queries) == 1
    print("  ✅ [Case 6] PASS")

    # 7. اختبار عدم تنفيذ أي شيء عند امتلاء المعمل وعدم وجود منتهي
    print("\n[Case 7] اختبار معمل ممتلئ تماماً ولا يوجد شيء جاهز...")
    mock_data_full = {
        "stuffWorkshopCtrl": {
            "doneID": 0,
            "list": [
                {"type": 0, "mid": 200101},
                {"type": 0, "mid": 200201},
                {"type": 0, "mid": 200301},
                {"type": 1, "gold": 500},
            ]
        }
    }
    conn_full = MockConnection(init_data=mock_data_full)
    task_full = MaterialWorkshopTask(conn_full, config={"enabled": True})
    can_run, reason = await task_full.can_run()
    assert can_run is False
    assert "المعمل ممتلئ" in reason
    print("  ✅ [Case 7] PASS")

    print("\n" + "=" * 70)
    print("🎉 جميع اختبارات الأمان وحالات الحافة (7/7) اجتازت بنجاح تام 100%!")
    print("=" * 70)

if __name__ == "__main__":
    asyncio.run(run_comprehensive_tests())
