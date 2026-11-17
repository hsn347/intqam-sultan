# -*- coding: utf-8 -*-
"""
tools/test_command_hall_unit.py
Unit tests verifying CommandHallTask logic for Sniper (Type 6) and Battle (Type 5 & 2) tasks.
"""

import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.command_hall import (
    CommandHallTask,
    TASK_TYPE_SNIPE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_BATTLE,
    TASK_TYPE_REBEL_PIONEER,
    TASK_TYPE_REBEL_GROUP,
    TASK_STATUE_READY,
)


class MockTaskBot:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        if "cityCtrl" not in self.init_data:
            self.init_data["cityCtrl"] = {"level": 30}
        self.is_connected = True
        self.queries = []
        self.responses = {}

    def set_response(self, cmd, subcmd, resp):
        self.responses[(int(cmd), int(subcmd))] = resp

    async def query(self, cmd, subcmd, payload=None, **kwargs):
        self.queries.append((int(cmd), int(subcmd), payload or {}))
        return self.responses.get((int(cmd), int(subcmd)), {"err": 0, "rspdata": {}})

    async def safe_query(self, cmd, subcmd, payload=None, **kwargs):
        return await self.query(cmd, subcmd, payload, **kwargs)


async def test_sniper_execution_flow():
    print("--- Test: CommandHallTask Sniper Execution Flow ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {
                    "taskID": 6001,
                    "index": 101,
                    "type": TASK_TYPE_SNIPE,
                    "statue": TASK_STATUE_READY,
                    "quality": 5,
                },
                {
                    "taskID": 6002,
                    "index": 102,
                    "type": TASK_TYPE_SNIPE,
                    "statue": TASK_STATUE_READY,
                    "quality": 4,
                }
            ]
        }
    })
    # Set mock responses for SubCMD 5 (finish) and SubCMD 8 (commit)
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 101, "count": 5}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 102, "count": 10}]}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_snipe": True, "allow_marches": False})
    
    # can_run check
    can_exec, reason = await task.can_run()
    assert can_exec is True, f"Expected can_run to be True, got {can_exec}: {reason}"

    # run check with mock
    res = await task.run()
    assert res.success is True, f"Expected task to succeed, got: {res}"
    assert res.data["completed_snipe"] == 2
    assert res.data["completed_battle"] == 0
    assert res.data["completed_tasks"] == 2
    print(f"✅ PASSED: {res.message}")


async def test_low_stamina_still_runs_sniper():
    print("\n--- Test: Low Stamina Still Executes Sniper Tasks ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 5}}, # Only 5 stamina! Less than safety stamina
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {
                    "taskID": 6001,
                    "index": 201,
                    "type": TASK_TYPE_SNIPE,
                    "statue": TASK_STATUE_READY,
                    "quality": 6,
                },
                {
                    "taskID": 5001,
                    "index": 202,
                    "type": TASK_TYPE_BATTLE,
                    "statue": TASK_STATUE_READY,
                    "quality": 4,
                }
            ]
        }
    })
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 101, "count": 2}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 102, "count": 4}]}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_snipe": True, "allow_marches": True, "min_stamina": 10})
    
    can_exec, reason = await task.can_run()
    assert can_exec is True, "can_run must be True even if stamina is 5 because sniper costs 0 stamina"

    res = await task.run()
    assert res.success is True
    assert res.data["completed_snipe"] == 1
    assert res.data["completed_battle"] == 0 # Battles skipped safely due to stamina < 20
    print(f"✅ PASSED: {res.message}")


async def test_rescue_execution_flow():
    print("\n--- Test: CommandHallTask Rescue (Type 4) Execution Flow ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {
                    "taskID": 4001,
                    "index": 301,
                    "type": TASK_TYPE_RESCUE,
                    "statue": TASK_STATUE_READY,
                    "quality": 3,
                },
                {
                    "taskID": 4002,
                    "index": 302,
                    "type": TASK_TYPE_RESCUE,
                    "statue": TASK_STATUE_READY,
                    "quality": 4,
                }
            ]
        }
    })
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 500606, "count": 2}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 110114, "count": 5}]}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_rescue": True, "allow_marches": False})
    res = await task.run()

    assert res.success is True, f"Expected task to succeed, got: {res}"
    assert res.data["completed_rescue"] == 2
    assert res.data["completed_tasks"] == 2
    assert res.data["stamina_spent"] == 10  # 5 * 2
    print(f"✅ PASSED: {res.message}")


async def test_dialogue_execution_flow():
    print("\n--- Test: CommandHallTask Dialogue (Type 3) Execution Flow ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {
                    "taskID": 3022,
                    "index": 401,
                    "type": TASK_TYPE_DIALOGUE,
                    "statue": TASK_STATUE_READY,
                    "quality": 2,
                },
                {
                    "taskID": 3024,
                    "index": 402,
                    "type": TASK_TYPE_DIALOGUE,
                    "statue": TASK_STATUE_READY,
                    "quality": 4,
                }
            ]
        }
    })
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 500601, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 110114, "count": 15}]}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_dialogue": True, "allow_marches": False})
    res = await task.run()

    assert res.success is True, f"Expected task to succeed, got: {res}"
    assert res.data["completed_dialogue"] == 2
    assert res.data["completed_tasks"] == 2
    assert res.data["stamina_spent"] == 10  # 5 * 2
    print(f"✅ PASSED: {res.message}")


async def test_army_group_boss_execution_flow():
    print("\n--- Test: CommandHallTask Rebel Legion Boss (Type 1) Renewal Flow ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 10,
            "commandExp": 1600,
            "armyGroupID": 14,
            "commonTaskData": [],
            "armyGroupTaskData": {
                "taskID": 1014,
                "index": 501,
                "type": TASK_TYPE_REBEL_GROUP,
                "statue": 2,
                "rabelHp": 1000,
                "hurtHp": 1000,
                "armyPioneerTaskCount": 0,
            }
        }
    })
    # SubCMD 7 (Attack Boss) and SubCMD 8 (Commit Boss)
    mock_conn.set_response(2274, 7, {"err": 0, "rspdata": {"statue": 3, "commandExp": 1800}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {
        "reward": [{"id": 300403, "count": 2}],
        "initData": {
            "armyGroupID": 15,
            "commonTaskData": [{"taskID": 6005, "index": 601, "type": TASK_TYPE_SNIPE, "statue": 1}]
        }
    }})

    task = CommandHallTask(mock_conn, config={"enabled": True, "allow_army_group": True, "allow_marches": False})
    res = await task.run()

    assert res.success is True, f"Expected task to succeed, got: {res}"
    assert res.data["completed_army_group"] == 1
    assert res.data["completed_tasks"] == 1
    # Verify in-memory state renewed
    assert mock_conn.init_data["commandHall"]["armyGroupID"] == 15
    assert len(mock_conn.init_data["commandHall"]["commonTaskData"]) == 1
    print(f"✅ PASSED: {res.message}")


async def test_auto_upgrade_command_hall_level():
    print("\n--- Test: CommandHallTask Auto Upgrade Hall Level Flow ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "commandHall": {
            "commandLv": 4,
            "commandExp": 600,  # need_exp is 500 for Lv.4 -> eligible!
            "commonTaskData": [
                {
                    "taskID": 6001,
                    "index": 701,
                    "type": TASK_TYPE_SNIPE,
                    "statue": TASK_STATUE_READY,
                    "quality": 5,
                }
            ]
        }
    })
    # SubCMD 2 (Upgrade Level), SubCMD 5 (Finish Snipe), SubCMD 8 (Commit Snipe)
    mock_conn.set_response(2274, 2, {
        "err": 0,
        "rspdata": {
            "reward": [{"id": 900009, "count": 10}],
            "initData": {
                "commandLv": 5,
                "commandExp": 100,
            }
        }
    })
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 6001, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 110114, "count": 5}]}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "auto_upgrade_hall": True, "allow_snipe": True, "allow_marches": False})
    res = await task.run()

    assert res.success is True, f"Expected task to succeed, got: {res}"
    assert res.data["completed_hall_upgrades"] == 1
    assert res.data["completed_snipe"] == 1
    assert mock_conn.init_data["commandHall"]["commandLv"] == 5
    assert mock_conn.init_data["commandHall"]["commandExp"] == 100
    print(f"✅ PASSED: {res.message}")


async def test_prestige_daily_skip_logic():
    print("\n--- Test: Prestige / Daily Activity Skip Logic ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "everydayTaskCtrl": {
            "eventInfo": {
                "33": 1,
            }
        },
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 801, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5}
            ]
        }
    })

    # 1. نمط daily مع إنجاز المهمة 33 مسبقاً -> يجب أن يتخطى فوراً (0-Network Skip)
    task_daily = CommandHallTask(mock_conn, config={"enabled": True, "mode": "daily"})
    can_exec, reason = await task_daily.can_run()
    assert can_exec is False, f"Expected can_run to be False in daily mode when task 33 is done, got {can_exec}"
    assert "منجزة بالفعل في النشاط اليومي" in reason, f"Unexpected reason: {reason}"
    res_daily = await task_daily.run()
    assert res_daily.skipped is True
    assert "منجزة بالفعل في النشاط اليومي" in res_daily.message
    print(f"✅ PASSED: daily mode safely skipped: {res_daily.message}")

    # 2. نمط full مع نفس البيانات -> يجب أن يسمح بالتنفيذ ولا يتخطى
    task_full = CommandHallTask(mock_conn, config={"enabled": True, "mode": "full", "allow_snipe": True, "allow_marches": False})
    can_exec_full, reason_full = await task_full.can_run()
    assert can_exec_full is True, f"Expected can_run to be True in full mode, got {can_exec_full}: {reason_full}"
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 6001, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 110114, "count": 5}]}})
    res_full = await task_full.run()
    assert res_full.success is True
    assert res_full.data["completed_snipe"] == 1
    print(f"✅ PASSED: full mode executed successfully without skipping: {res_full.message}")


async def test_daily_mode_full_cycle_then_skip():
    print("\n--- Test: Daily Mode Runs Full Cycle on First Run, Then Skips on Subsequent Runs ---")
    mock_conn = MockTaskBot({
        "lordInfoCtrl": {"base": {"health": 80}},
        "everydayTaskCtrl": {
            "eventInfo": {}
        },
        "commandHall": {
            "commandLv": 4,
            "commandExp": 150,
            "commonTaskData": [
                {"taskID": 6001, "index": 901, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 5},
                {"taskID": 6002, "index": 902, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_READY, "quality": 4},
                {"taskID": 4001, "index": 903, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_READY, "quality": 4},
                {"taskID": 4002, "index": 904, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_READY, "quality": 3},
            ]
        }
    })
    mock_conn.set_response(2274, 5, {"err": 0, "rspdata": {"reward": [{"id": 101, "count": 1}]}})
    mock_conn.set_response(2274, 8, {"err": 0, "rspdata": {"reward": [{"id": 102, "count": 2}]}})

    task = CommandHallTask(
        mock_conn,
        config={
            "enabled": True,
            "mode": "daily",
            "allow_snipe": True,
            "allow_rescue": True,
            "allow_marches": False,
        }
    )

    # 1. الدورة الأولى: المهمة 33 غير منجزة -> تنفيذ دورة كاملة لكافة المهام الأربعة المتاحة (بدون سقف الـ 3)
    can_exec, reason = await task.can_run()
    assert can_exec is True, f"Expected can_run to be True on first run, got {can_exec}: {reason}"

    res = await task.run()
    assert res.success is True, f"Expected run to succeed, got: {res}"
    assert res.data["completed_snipe"] == 2, f"Expected 2 snipers, got {res.data['completed_snipe']}"
    assert res.data["completed_rescue"] == 2, f"Expected 2 rescues, got {res.data['completed_rescue']}"
    assert res.data["completed_tasks"] == 4, f"Expected 4 tasks total, got {res.data['completed_tasks']}"
    print(f"✅ PASSED (First Run - Full Cycle): {res.message}")

    # التحقق من أن سجل الذاكرة الحية تم تحديثه بإنجاز المهمة 33
    event_info = mock_conn.init_data.get("everydayTaskCtrl", {}).get("eventInfo", {})
    assert int(event_info.get("33", 0)) >= 1, f"Expected eventInfo['33'] to be >= 1, got {event_info}"

    # 2. الدورة الثانية: المهمة 33 مسجلة كمنجزة -> تجاوز فوري في can_run و run (0-Network Skip)
    can_exec_2, reason_2 = await task.can_run()
    assert can_exec_2 is False, f"Expected can_run to be False on second run, got {can_exec_2}: {reason_2}"
    assert "منجزة بالفعل في النشاط اليومي" in reason_2
    res_skip = await task.run()
    assert res_skip.skipped is True
    print(f"✅ PASSED (Second Run - Safely Skipped): {res_skip.message}")


async def test_weak_castle_preflight_skip():
    print("--- Test: Weak Castle Preflight Skip (< Lv.5) ---")
    # قلعة بمستوى 4 (ضعيفة وغير مؤهلة لقاعة القيادة)
    mock_conn = MockTaskBot({"cityCtrl": {"level": 4}})
    task = CommandHallTask(mock_conn, config={"enabled": True})
    
    can_exec, reason = await task.can_run()
    assert can_exec is False, f"Expected can_run to be False for weak castle, got {can_exec}"
    assert "أقل من المستوى المطلوب Lv.5" in reason
    print(f"✅ PASSED (Weak Castle Safely Skipped 0-Network): {reason}")


async def main():
    await test_sniper_execution_flow()
    await test_low_stamina_still_runs_sniper()
    await test_rescue_execution_flow()
    await test_dialogue_execution_flow()
    await test_army_group_boss_execution_flow()
    await test_auto_upgrade_command_hall_level()
    await test_prestige_daily_skip_logic()
    await test_daily_mode_full_cycle_then_skip()
    await test_weak_castle_preflight_skip()
    print("\n🎉 ALL UNIT TESTS PASSED SUCCESSFULLY!")

if __name__ == "__main__":
    asyncio.run(main())
