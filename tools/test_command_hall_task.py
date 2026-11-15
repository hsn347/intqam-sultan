# -*- coding: utf-8 -*-
"""
tools/test_command_hall_task.py
Comprehensive unit and empirical tests for CommandHallTask.
"""

import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.command_hall import (
    CommandHallTask,
    TASK_STATUE_BEGIN,
    TASK_STATUE_FIGHTING,
    TASK_STATUE_FINISH,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_SNIPE,
    TASK_TYPE_BATTLE,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    REQ_COMMAND_HALL_FINISH_TASK,
    REQ_COMMAND_HALL_COMMIT_TASK,
    REQ_COMMAND_HALL_UPGRADE_COMMAND_LV,
)
from tasks.base_task import TaskResult


class MockConn:
    def __init__(self, init_data=None):
        self.init_data = init_data or {}
        self.is_connected = True
        self.queries = []
        self.responses = {}

    def set_response(self, cmd, subcmd, resp):
        self.responses[(str(cmd), str(subcmd))] = resp

    async def query(self, cmd, subcmd, payload=None, **kwargs):
        self.queries.append((str(cmd), str(subcmd), payload or {}))
        return self.responses.get((str(cmd), str(subcmd)), {"err": 0, "rspdata": {}})

    async def safe_query(self, cmd, subcmd, payload=None, **kwargs):
        return await self.query(cmd, subcmd, payload, **kwargs)


async def test_0_network_preflight_when_daily_complete():
    print("\n--- Test 1: 0-Network Preflight when Daily Quest Already Complete ---")
    mock_conn = MockConn({
        "everydayTaskCtrl": {
            "eventInfo": {"33": 1}
        },
        "commandHall": {"commandLv": 5}
    })
    task = CommandHallTask(mock_conn, config={"enabled": True, "mode": "daily"})
    res = await task.run()
    assert res.success is True
    assert "0-Network" in res.message
    assert len(mock_conn.queries) == 0, f"Expected 0 queries, got {len(mock_conn.queries)}"
    print("✅ Test 1 PASSED: 0-Network pre-flight skipped when already at 1/1 daily limitTime.")


async def test_instant_tasks_daily_mode():
    print("\n--- Test 2: Instant Tasks Execution in Daily Mode ---")
    mock_conn = MockConn({
        "everydayTaskCtrl": {
            "eventInfo": {}
        },
        "lordInfoCtrl": {
            "base": {"health": 50}
        },
        "commandHall": {
            "commandLv": 3,
            "commandExp": 100,
            "commonTaskData": [
                {"index": 101, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FIGHTING, "consume": 5},
                {"index": 102, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_FIGHTING, "consume": 5},
                {"index": 103, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_FIGHTING, "consume": 5},
                {"index": 104, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FIGHTING, "consume": 5},
            ]
        }
    })
    mock_conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_FINISH_TASK, {"err": 0, "rspdata": {}})
    mock_conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_COMMIT_TASK, {"err": 0, "rspdata": {}})

    task = CommandHallTask(mock_conn, config={"enabled": True, "mode": "daily"})
    res = await task.run()

    assert res.success is True
    # In daily mode, it finishes exactly 3 tasks (101, 102, 103) and stops!
    finish_queries = [q for q in mock_conn.queries if q[0] == CMD_COMMAND_HALL_MODULE and q[1] == REQ_COMMAND_HALL_FINISH_TASK]
    assert len(finish_queries) == 3, f"Expected 3 instant task queries, got {len(finish_queries)}"
    assert finish_queries[0][2]["index"] == 101
    assert finish_queries[1][2]["index"] == 102
    assert finish_queries[2][2]["index"] == 103
    commit_queries = [q for q in mock_conn.queries if q[0] == CMD_COMMAND_HALL_MODULE and q[1] == REQ_COMMAND_HALL_COMMIT_TASK]
    assert len(commit_queries) == 3, f"Expected 3 commit queries, got {len(commit_queries)}"
    print("✅ Test 2 PASSED: Successfully completed exactly 3 tasks to reach daily goal and stopped.")


async def test_reward_claiming_and_upgrade():
    print("\n--- Test 3: Auto Claim Rewards and Auto Upgrade Hall ---")
    mock_conn = MockConn({
        "everydayTaskCtrl": {
            "eventInfo": {"33": 0}
        },
        "lordInfoCtrl": {
            "base": {"health": 50}
        },
        "commandHall": {
            "commandLv": 1,
            "commandExp": 250,  # Lv 1 needs 200 exp to upgrade to Lv 2
            "finishTaskData": [
                {"index": 201, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH}
            ],
            "commonTaskData": []
        }
    })
    mock_conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_COMMIT_TASK, {"err": 0, "rspdata": {}})
    mock_conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_UPGRADE_COMMAND_LV, {"err": 0, "rspdata": {"initData": {"commandLv": 2, "commandExp": 50}}})

    task = CommandHallTask(mock_conn, config={
        "enabled": True,
        "mode": "full",
        "auto_claim_rewards": True,
        "auto_upgrade_hall": True
    })
    res = await task.run()

    assert res.success is True
    commit_queries = [q for q in mock_conn.queries if q[0] == CMD_COMMAND_HALL_MODULE and q[1] == REQ_COMMAND_HALL_COMMIT_TASK]
    upgrade_queries = [q for q in mock_conn.queries if q[0] == CMD_COMMAND_HALL_MODULE and q[1] == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV]
    assert len(commit_queries) == 1, f"Expected 1 commit query, got {len(commit_queries)}"
    assert len(upgrade_queries) == 1, f"Expected 1 upgrade query, got {len(upgrade_queries)}"
    print("✅ Test 3 PASSED: Both reward claiming and hall upgrading executed successfully.")


async def test_safety_0_gold_and_low_stamina():
    print("\n--- Test 4: 0-Gold & Low Stamina Safety Protection ---")
    mock_conn = MockConn({
        "everydayTaskCtrl": {
            "eventInfo": {"33": 0}
        },
        "lordInfoCtrl": {
            "base": {"health": 8}  # Stamina is below MIN_SAFETY_STAMINA (10)
        },
        "commandHall": {
            "commandLv": 2,
            "commandExp": 50,
            "commonTaskData": [
                {"index": 301, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeGold": 50},  # Gold costly
                {"index": 302, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},          # Needs stamina but stamina is 8
            ]
        }
    })
    task = CommandHallTask(mock_conn, config={"enabled": True, "mode": "daily"})
    res = await task.run()

    assert res.success is True
    finish_queries = [q for q in mock_conn.queries if q[0] == CMD_COMMAND_HALL_MODULE and q[1] == REQ_COMMAND_HALL_FINISH_TASK]
    assert len(finish_queries) == 0, f"Expected 0 finish queries due to safety filters, got {len(finish_queries)}"
    print("✅ Test 4 PASSED: Costly gold task and low-stamina task were safely filtered out.")


async def main():
    await test_0_network_preflight_when_daily_complete()
    await test_instant_tasks_daily_mode()
    await test_reward_claiming_and_upgrade()
    await test_safety_0_gold_and_low_stamina()
    print("\n🎉 ALL TESTS PASSED SUCCESSFULLY! (4/4)\n")


if __name__ == "__main__":
    asyncio.run(main())
