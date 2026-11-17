# -*- coding: utf-8 -*-
"""
tools/test_material_workshop_unit.py — اختبار تركيبي لمهمة معمل المواد والتكامل مع كافة الطبقات
"""

import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def test_imports():
    print("1. Testing imports from tasks...")
    from tasks import MaterialWorkshopTask
    assert MaterialWorkshopTask.name == "material_workshop"
    print("  -> MaterialWorkshopTask imported successfully.")

def test_bot_manager():
    print("2. Testing bot_manager registration...")
    from bot_manager import REGISTERED_TASKS, DEFAULT_BOT_CONFIG
    task_names = [getattr(t, "name", t.__name__) for t in REGISTERED_TASKS]
    assert "material_workshop" in task_names, f"material_workshop not in REGISTERED_TASKS: {task_names}"
    assert "material_workshop" in DEFAULT_BOT_CONFIG["tasks"]
    mw_cfg = DEFAULT_BOT_CONFIG["tasks"]["material_workshop"]
    assert mw_cfg["enabled"] is False
    assert len(mw_cfg["selected_materials"]) == 6
    print("  -> bot_manager registration verified.")

def test_api_server():
    print("3. Testing api_server CastleConfigModel...")
    from api_server import CastleConfigModel, MaterialWorkshopConfigModel
    cfg = CastleConfigModel(material_workshop={"enabled": True, "selected_materials": [200101, 200201]})
    dumped = cfg.model_dump(exclude_none=True)
    assert "material_workshop" in dumped
    assert dumped["material_workshop"]["enabled"] is True
    assert dumped["material_workshop"]["selected_materials"] == [200101, 200201]
    print("  -> api_server validation verified.")

def test_round_robin_logic():
    print("4. Testing task round-robin logic on mock workshop data...")
    from tasks.material_workshop import MaterialWorkshopTask

    class MockConn:
        is_connected = True
        def __init__(self):
            self.init_data = {
                "stuffWorkshopCtrl": {
                    "list": [
                        {"type": 0, "mid": 200101},  # pos 1 refining
                        {"type": 0, "mid": 200201},  # pos 2 queued
                        {"type": 0},                 # pos 3 vacant
                        {"type": 0},                 # pos 4 vacant
                        {"type": 0},                 # pos 5 vacant
                        {"type": 1, "gold": 500},    # pos 6 locked
                        {"type": 1, "gold": 1000},   # pos 7 locked
                    ],
                    "doneID": 200301,  # has finished material ready to collect
                }
            }

        def get_ctrl(self, name):
            return self.init_data.get(name, {})

    mock_conn = MockConn()
    logs = []
    task = MaterialWorkshopTask(mock_conn, log_func=lambda msg: logs.append(msg), config={"enabled": True})
    status = task.get_material_workshop_status()
    assert status["has_workshop"] is True
    assert status["total_unlocked_slots"] == 5
    assert status["currently_producing_count"] == 2
    assert status["vacant_slots_count"] == 3
    assert status["has_vacant_slot"] is True
    assert status["has_finished_material"] is True
    assert status["done_material_id"] == 200301

    print("  -> Status reading from memory: PASS")

    # Mock query responses
    queries_made = []
    async def mock_safe_query(cmd, sub, params=None):
        queries_made.append((cmd, sub, params))
        if sub == 3: # collect
            mock_conn.init_data["stuffWorkshopCtrl"]["doneID"] = 0
            return {"err": 0, "result": []}
        elif sub == 1: # refine
            pos = len([s for s in mock_conn.init_data["stuffWorkshopCtrl"]["list"] if s.get("mid") is not None]) + 1
            for s in mock_conn.init_data["stuffWorkshopCtrl"]["list"]:
                if s.get("type") == 0 and "mid" not in s:
                    s["mid"] = params["id"]
                    break
            return {"err": 0, "result": mock_conn.init_data["stuffWorkshopCtrl"]}
        return {"err": 0}

    task.safe_query = mock_safe_query

    async def run_test():
        res = await task.run()
        assert res.success is True
        print(f"  -> Task execution result: {res.message}")
        print(f"  -> Refined items: {res.data.get('refined')}")
        print(f"  -> Collected items: {res.data.get('collected')}")

    asyncio.run(run_test())
    print("  -> Task simulation: PASS")

if __name__ == "__main__":
    test_imports()
    test_bot_manager()
    test_api_server()
    test_round_robin_logic()
    print("\nALL BACKEND UNIT TESTS PASSED!")
