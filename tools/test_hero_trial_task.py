# -*- coding: utf-8 -*-
"""
tools/test_hero_trial_task.py — اختبار شامل لوحدة مهمة كفاءة الجندي (HeroTrialTask)
═════════════════════════════════════════════════════════════════════════════════
يختبر كافة سيناريوهات الأمان، فحص الذاكرة المسبق (0-Network Pre-flight)،
استراتيجية الإكتساح السريع، استراتيجية الهجوم بالحد الأدنى من الجنود،
ومزامنة الذاكرة الحية (In-Memory State Sync).
"""

import asyncio
import copy
import os
import sys
from typing import Any, Dict, Optional

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from tasks.hero_trial import (
    HeroTrialTask,
    CMD_HT_MODULE,
    REQ_HT_OPEN_TRIAL,
    REQ_HT_GENERAL_TRIAL,
    REQ_HT_INIT_DATA,
    REQ_HT_SWEEP,
    DAILY_QUEST_HERO_TRIAL_TYPE,
)


class MockConnection:
    """محاكي اتصال لاختبار استعلامات كفاءة الجندي دون ملامسة السيرفر الحقيقي"""
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = copy.deepcopy(init_data)
        self.is_connected = True
        self.queries_log = []

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        self.queries_log.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data})

        # رد مزامنة البيانات الأولية (REQ 10)
        if str(cmd) == CMD_HT_MODULE and str(subcmd) == REQ_HT_INIT_DATA:
            return {
                "err": "0",
                "data": {
                    "htPointData": {"htPoint": 3, "inRCD": True, "bTime": 1700000000},
                    "mapInfo": {"lastSID": 40105, "lastCOMPSID": 40104},
                    "battleData": {"trialStatus": False, "trialMID": 401, "trialSID": 40101, "soldiers": {"401": 50}},
                }
            }

        # رد الإكتساح السريع (REQ 11)
        if str(cmd) == CMD_HT_MODULE and str(subcmd) == REQ_HT_SWEEP:
            return {
                "err": "0",
                "data": {"mapID": data.get("mapID", 401), "reward": [{"id": 1008, "count": 100}]}
            }

        # رد فتح التحدي (REQ 1)
        if str(cmd) == CMD_HT_MODULE and str(subcmd) == REQ_HT_OPEN_TRIAL:
            return {
                "err": "0",
                "data": {"mapID": data.get("mapID", 401), "soldiers": {"401": 200, "501": 150}}
            }

        # رد هجوم المرحلة (REQ 3)
        if str(cmd) == CMD_HT_MODULE and str(subcmd) == REQ_HT_GENERAL_TRIAL:
            return {
                "err": "0",
                "data": {"stageID": data.get("stageID", 40101), "battleRet": True}
            }

        return {"err": "0", "data": {}}


async def test_scenario_1_already_completed():
    print("\n--- [Scenario 1] 0-Network Pre-flight when already completed ---")
    conn = MockConnection({
        "everydayTaskCtrl": {"eventInfo": {DAILY_QUEST_HERO_TRIAL_TYPE: 1}},
        "htData": {"htPointData": {"htPoint": 5}}
    })
    task = HeroTrialTask(conn, print, {"enabled": True})
    res = await task.run()
    assert res.skipped is True, "Task should be skipped"
    assert len(conn.queries_log) == 0, "No network queries should be sent!"
    print("✓ Scenario 1 passed: 0 network queries sent.")


async def test_scenario_2_no_points():
    print("\n--- [Scenario 2] Safe skip when htPoint == 0 and not in trial ---")
    conn = MockConnection({
        "everydayTaskCtrl": {"eventInfo": {}},
        "htData": {
            "htPointData": {"htPoint": 0},
            "battleData": {"trialStatus": False},
            "mapInfo": {"lastSID": 40101}
        }
    })
    task = HeroTrialTask(conn, print, {"enabled": True})
    res = await task.run()
    assert res.skipped is True, "Task should be skipped when points=0"
    assert len(conn.queries_log) == 0, "No network queries should be sent when points=0"
    print("✓ Scenario 2 passed: Safe skip when no points.")


async def test_scenario_3_sweep_execution():
    print("\n--- [Scenario 3] Fast Sweep when privilege & passed map exist ---")
    conn = MockConnection({
        "everydayTaskCtrl": {"eventInfo": {}},
        "exaltedPrivilegeCtrl": {"privileges": {"56": 1}},
        "htData": {
            "htPointData": {"htPoint": 2},
            "battleData": {"trialStatus": False},
            "mapInfo": {"lastSID": 40105, "lastCOMPSID": 40110}  # Map 401 fully completed
        }
    })
    task = HeroTrialTask(conn, print, {"enabled": True})
    res = await task.run()
    assert res.success is True, "Task should succeed"
    assert len(conn.queries_log) == 1, "Only 1 sweep query expected"
    assert conn.queries_log[0]["subcmd"] == REQ_HT_SWEEP, "Subcmd should be REQ_HT_SWEEP"
    # Verify in-memory state sync
    assert conn.init_data["everydayTaskCtrl"]["eventInfo"][DAILY_QUEST_HERO_TRIAL_TYPE] == 1, "Quest should be marked 1"
    assert conn.init_data["htData"]["htPointData"]["htPoint"] == 1, "Point should be decremented"
    print("✓ Scenario 3 passed: Fast sweep executed and state synced.")


async def test_scenario_4_regular_open_and_attack():
    print("\n--- [Scenario 4] Regular Open Trial + Attack 1 Stage with Minimal Troops ---")
    conn = MockConnection({
        "everydayTaskCtrl": {"eventInfo": {}},
        "armyCtrl": {"armys": {"401": 1000, "501": 500}},
        "htData": {
            "htPointData": {"htPoint": 3},
            "battleData": {"trialStatus": False},
            "mapInfo": {"lastSID": 40101, "lastCOMPSID": 0}
        }
    })
    task = HeroTrialTask(conn, print, {"enabled": True})
    res = await task.run()
    assert res.success is True, "Task should succeed"
    assert len(conn.queries_log) == 2, "Expected 2 queries (open + attack)"
    assert conn.queries_log[0]["subcmd"] == REQ_HT_OPEN_TRIAL, "First should be open trial"
    assert conn.queries_log[1]["subcmd"] == REQ_HT_GENERAL_TRIAL, "Second should be attack stage"
    
    # Check that minimal troop was dispatched (only 1 soldier)
    soldiers_dispatched = conn.queries_log[1]["data"]["soldiers"]
    assert isinstance(soldiers_dispatched, list) and len(soldiers_dispatched) == 1 and soldiers_dispatched[0]["num"] == 1, f"Expected 1 minimal soldier dispatched, got {soldiers_dispatched}"
    
    # Check in-memory sync
    assert conn.init_data["everydayTaskCtrl"]["eventInfo"][DAILY_QUEST_HERO_TRIAL_TYPE] == 1, "Quest 25 completed in memory"
    assert conn.init_data["htData"]["htPointData"]["htPoint"] == 2, "Points decremented by 1"
    print("✓ Scenario 4 passed: Opened trial and attacked stage with minimal soldier (1 troop).")

    # Run again immediately -> Must be 0-Network Pre-flight skip!
    conn.queries_log.clear()
    res2 = await task.run()
    assert res2.skipped is True
    assert len(conn.queries_log) == 0, "Subsequent run must send 0 network requests!"
    print("✓ Subsequent run verified: 0 network requests sent.")


async def main():
    print("==================================================")
    print("Starting HeroTrialTask Comprehensive Test Suite...")
    print("==================================================")
    await test_scenario_1_already_completed()
    await test_scenario_2_no_points()
    await test_scenario_3_sweep_execution()
    await test_scenario_4_regular_open_and_attack()
    print("\n==================================================")
    print("ALL 4 TEST SCENARIOS PASSED WITH 100% SUCCESS!")
    print("==================================================")


if __name__ == "__main__":
    asyncio.run(main())
