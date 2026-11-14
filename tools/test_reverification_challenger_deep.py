# -*- coding: utf-8 -*-
"""
tools/test_reverification_challenger_deep.py
══════════════════════════════════════════════════════════════════════════════
Empirical Re-verification Challenger Deep Test Harness
Independent, exhaustive verification of:
1. `_is_costly_task` rejection of speedup, gold, item traps & edge cases.
2. `_ensure_synced_data` unpacking of `res['rspdata']['initData']` into `conn.init_data['commandHall']`.
3. `_extract_task_list` aggregation from all 4 partitions + legacy + dict/list variations.
4. Zero repeated network queries inside the loop when data is cached.
══════════════════════════════════════════════════════════════════════════════
"""

import asyncio
import os
import sys
import unittest
from unittest.mock import patch
from typing import Any, Dict, List, Optional

# Add project root to sys.path
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from tasks.command_hall import (
    CommandHallTask,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    TASK_STATUE_BEGIN,
    TASK_STATUE_FINISH,
    TASK_STATUE_PREPARE,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_SNIPE,
    TASK_TYPE_REBEL_PIONEER,
    TASK_TYPE_BATTLE,
)


class MockConnection:
    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data if init_data is not None else {}
        self.query_log: List[Dict[str, Any]] = []
        self.query_responses: Dict[tuple, Any] = {}

    def set_response(self, cmd: str, subcmd: str, response: Any):
        self.query_responses[(str(cmd), str(subcmd))] = response

    async def query(self, cmd: str, subcmd: str, data: Any = None) -> Any:
        self.query_log.append({
            "cmd": str(cmd),
            "subcmd": str(subcmd),
            "data": data,
        })
        key = (str(cmd), str(subcmd))
        if key in self.query_responses:
            resp = self.query_responses[key]
            if callable(resp):
                return resp(data)
            return resp
        return {"_ok": True, "err": "0", "data": {}}


class TestEmpiricalDeepVerification(unittest.TestCase):

    def test_01_is_costly_task_exhaustive_matrix(self):
        """1. Verify `_is_costly_task` properly rejects all costly tasks and adversarial traps."""
        # Traps that MUST BE REJECTED (is_costly == True)
        costly_traps = [
            {"consumeGold": 100},
            {"consumeGold": "100"},
            {"consumeGold": 1},
            {"gold": 50},
            {"gold": "50"},
            {"consumeSpeedup": True},
            {"consumeSpeedup": 1},
            {"speedup": True},
            {"speedup": 1},
            {"consumeItem": "speedup"},
            {"consumeItem": "SPEEDUP"},
            {"consumeItem": "1h_speedup"},
            {"consumeItem": "gold_pack"},
            {"consumeItem": 1},
            {"consumeItem": 10},
            {"consumeItem": ["item_speedup"]},
            {"consumeItem": {"id": 1, "num": 1}},
            {"consumeItems": "speedup"},
            {"consumeItems": ["item1"]},
            {"consumeItems": {"item1": 1}},
            {"consumeItems": 5},
            {"item": "speedup"},
            {"item": 1},
            {"item": [101]},
            {"item": {"id": 1}},
            {"items": "speedup"},
            {"items": 1},
            {"items": [101]},
            {"items": {"id": 1}},
        ]

        for trap in costly_traps:
            is_costly = CommandHallTask._is_costly_task(trap)
            self.assertTrue(
                is_costly,
                f"Trap failed to be marked costly: {trap}"
            )

        # Free / Safe tasks that MUST NOT BE REJECTED (is_costly == False)
        safe_tasks = [
            {},
            {"consumeGold": 0},
            {"consumeGold": "0"},
            {"gold": 0},
            {"gold": "0"},
            {"consumeSpeedup": False},
            {"speedup": False},
            {"consumeItem": None},
            {"consumeItem": ""},
            {"consumeItem": "0"},
            {"consumeItem": "false"},
            {"consumeItem": "none"},
            {"consumeItem": "null"},
            {"consumeItem": 0},
            {"consumeItem": []},
            {"consumeItem": {}},
            {"consumeItems": None},
            {"consumeItems": ""},
            {"consumeItems": 0},
            {"consumeItems": []},
            {"consumeItems": {}},
            {"item": None},
            {"item": ""},
            {"item": 0},
            {"item": []},
            {"item": {}},
            {"items": None},
            {"items": ""},
            {"items": 0},
            {"items": []},
            {"items": {}},
            {"consume": 5},  # Stamina consumption is allowed (tested via stamina logic)
            {"consume": 0},
        ]

        for safe in safe_tasks:
            is_costly = CommandHallTask._is_costly_task(safe)
            self.assertFalse(
                is_costly,
                f"Safe task incorrectly marked costly: {safe}"
            )

        # Malformed / boundary non-dict tasks
        self.assertFalse(CommandHallTask._is_costly_task(None))
        self.assertFalse(CommandHallTask._is_costly_task("not a dict"))
        self.assertFalse(CommandHallTask._is_costly_task(12345))

    def test_02_safe_int_corrupted_inputs(self):
        """2. Verify `_safe_int` avoids exceptions on corrupted string, float, null, bool types."""
        self.assertEqual(CommandHallTask._safe_int("invalid_gold"), 0)
        self.assertEqual(CommandHallTask._safe_int("invalid_gold", default=10), 10)
        self.assertEqual(CommandHallTask._safe_int(""), 0)
        self.assertEqual(CommandHallTask._safe_int("   "), 0)
        self.assertEqual(CommandHallTask._safe_int(None), 0)
        self.assertEqual(CommandHallTask._safe_int(True), 0)  # bool should not be converted to 1
        self.assertEqual(CommandHallTask._safe_int(False), 0)
        self.assertEqual(CommandHallTask._safe_int("5"), 5)
        self.assertEqual(CommandHallTask._safe_int(" 12 "), 12)
        self.assertEqual(CommandHallTask._safe_int("5.0"), 5)
        self.assertEqual(CommandHallTask._safe_int("5.9"), 5)
        self.assertEqual(CommandHallTask._safe_int(5.9), 5)
        self.assertEqual(CommandHallTask._safe_int([1, 2]), 0)
        self.assertEqual(CommandHallTask._safe_int({"a": 1}), 0)

    def test_03_unpack_live_server_packet_into_init_data(self):
        """3. Verify `res.get('rspdata', {}).get('initData')` is properly unpacked and cached into `conn.init_data['commandHall']`."""
        conn = MockConnection()
        live_gateway_response = {
            "cmd": "2274",
            "subcmd": "1",
            "pid": 11299184,
            "_ok": True,
            "err": "0",
            "source": "c",
            "data": {},
            "rspdata": {
                "initData": {
                    "commandLv": 7,
                    "commandExp": 450,
                    "powerLv": 3,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": 1,
                        "taskID": 1001,
                        "statue": 2,
                    },
                    "armyPioneerTaskData": {
                        "index": 2,
                        "type": 2,
                        "taskID": 2001,
                        "statue": 2,
                        "obj": {"x": 924, "y": 1168},
                    },
                    "commonTaskData": [
                        {"index": 3, "type": 3, "statue": 2},
                        {"index": 4, "type": 4, "statue": 2},
                    ],
                    "finishTaskData": [
                        {"index": 5, "type": 6, "statue": 3},
                    ],
                }
            }
        }
        conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_INIT, live_gateway_response)

        task = CommandHallTask(conn, config={"enabled": True})
        synced_data = asyncio.run(task._ensure_synced_data())

        # Assert returned data is the unpacked initData
        self.assertIsNotNone(synced_data)
        self.assertEqual(synced_data.get("commandLv"), 7)
        self.assertEqual(synced_data.get("commandExp"), 450)
        self.assertEqual(synced_data.get("powerLv"), 3)

        # Assert conn.init_data['commandHall'] was updated
        self.assertIn("commandHall", conn.init_data)
        cached = conn.init_data["commandHall"]
        self.assertEqual(cached.get("commandLv"), 7)
        self.assertIn("armyGroupTaskData", cached)
        self.assertIn("armyPioneerTaskData", cached)
        self.assertIn("commonTaskData", cached)
        self.assertIn("finishTaskData", cached)

    def test_04_extract_task_list_aggregates_all_partitions(self):
        """4. Verify `_extract_task_list` properly aggregates subtasks from armyGroupTaskData, armyPioneerTaskData, commonTaskData, finishTaskData, and legacy fallbacks."""
        # Case A: commonTaskData as list, finishTaskData as list
        data_a = {
            "armyGroupTaskData": {"index": 1, "type": 1, "statue": 2},
            "armyPioneerTaskData": {"index": 2, "type": 2, "statue": 2},
            "commonTaskData": [
                {"index": 3, "type": 3, "statue": 2},
                {"index": 4, "type": 4, "statue": 2},
            ],
            "finishTaskData": [
                {"index": 5, "type": 6, "statue": 0},  # statue 0 should normalize to 3 (TASK_STATUE_FINISH)
            ],
        }
        tasks_a = CommandHallTask._extract_task_list(data_a)
        self.assertEqual(len(tasks_a), 5)
        indices_a = [t["index"] for t in tasks_a]
        self.assertEqual(indices_a, [1, 2, 3, 4, 5])
        # Check normalization of finish task statue
        t5 = next(t for t in tasks_a if t["index"] == 5)
        self.assertEqual(t5["statue"], TASK_STATUE_FINISH)

        # Case B: commonTaskData as dict, finishTaskData as dict (Lua table format)
        data_b = {
            "armyGroupTaskData": {"index": "10", "type": "1", "statue": "2"},
            "armyPioneerTaskData": {"index": "20", "type": "2", "statue": "2"},
            "commonTaskData": {
                "task_1": {"index": "30", "type": "3", "statue": "2"},
                "task_2": {"index": "40", "type": "4", "statue": "2"},
            },
            "finishTaskData": {
                "fin_1": {"index": "50", "type": "6", "statue": "3"},
            },
        }
        tasks_b = CommandHallTask._extract_task_list(data_b)
        self.assertEqual(len(tasks_b), 5)
        indices_b = [t["index"] for t in tasks_b]
        self.assertEqual(set(indices_b), {10, 20, 30, 40, 50})
        # Assert indices and types normalized to int
        for t in tasks_b:
            self.assertIsInstance(t["index"], int)
            self.assertIsInstance(t["type"], int)
            self.assertIsInstance(t["statue"], int)

        # Case C: legacy taskList / tasks format
        data_c = {
            "taskList": [
                {"index": 100, "type": 3, "statue": 2},
                {"index": 200, "type": 4, "statue": 2},
            ]
        }
        tasks_c = CommandHallTask._extract_task_list(data_c)
        self.assertEqual(len(tasks_c), 2)
        self.assertEqual([t["index"] for t in tasks_c], [100, 200])

        # Case D: Deduplication when duplicate entries exist across partitions
        data_d = {
            "armyGroupTaskData": {"index": 1, "type": 1, "statue": 2},
            "taskList": [
                {"index": 1, "type": 1, "statue": 2},
                {"index": 2, "type": 3, "statue": 2},
            ]
        }
        tasks_d = CommandHallTask._extract_task_list(data_d)
        self.assertEqual(len(tasks_d), 2)
        self.assertEqual([t["index"] for t in tasks_d], [1, 2])

    def test_05_zero_repeated_network_queries_inside_loop(self):
        """5. Verify that no repeated live network queries fire inside the loop when data is already cached."""
        # Scenario 1: Initial state has NO cache. Exactly 1 query should be sent.
        conn1 = MockConnection()
        payload = {
            "cmd": "2274",
            "subcmd": "1",
            "data": {},
            "rspdata": {
                "initData": {
                    "commandLv": 1,
                    "commandExp": 0,
                    "armyGroupTaskData": {},
                    "armyPioneerTaskData": {},
                    "commonTaskData": {},
                    "finishTaskData": {},
                }
            }
        }
        conn1.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_INIT, payload)

        task1 = CommandHallTask(conn1, config={"enabled": True})
        # Simulate multiple sequential calls to _ensure_synced_data
        for _ in range(10):
            d = asyncio.run(task1._ensure_synced_data())
            self.assertIsNotNone(d)

        # Count how many CMD 2274 SubCMD 1 were sent
        init_queries_1 = [
            q for q in conn1.query_log
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_INIT
        ]
        self.assertEqual(
            len(init_queries_1), 1,
            f"Expected exactly 1 init query, got {len(init_queries_1)}"
        )

        # Scenario 2: Memory is PRE-SEEDED with commandHall data (0-Network Pre-flight).
        # ZERO network queries should be sent!
        conn2 = MockConnection(init_data={
            "commandHall": {
                "commandLv": 2,
                "commandExp": 50,
                "armyGroupTaskData": {},
                "armyPioneerTaskData": {},
                "commonTaskData": {},
                "finishTaskData": {},
            }
        })
        task2 = CommandHallTask(conn2, config={"enabled": True})
        for _ in range(10):
            d = asyncio.run(task2._ensure_synced_data())
            self.assertIsNotNone(d)

        init_queries_2 = [
            q for q in conn2.query_log
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_INIT
        ]
        self.assertEqual(
            len(init_queries_2), 0,
            f"Expected exactly 0 queries for pre-seeded memory, got {len(init_queries_2)}"
        )

    def test_06_full_loop_run_adversarial_rejection_and_zero_repeated_queries(self):
        """6. Full loop run: verify that costly/speedup tasks are never dispatched, and SubCMD 1 is never repeatedly called during loop iterations."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "armyCtrl": {"totalArmy": {"1": 1000}},
            "queueCtrl": {"kingdomQueue": []},  # 2 march slots free
        })

        # Server responds to init with diverse tasks:
        # Task 1: dialogue with consumeItem: "speedup" (TRAP)
        # Task 2: march with consumeItem: "speedup" (TRAP)
        # Task 3: dialogue with consumeGold: 50 (TRAP)
        # Task 4: safe dialogue task (FREE)
        # Task 5: finished task (CLAIMABLE)
        init_payload = {
            "cmd": "2274",
            "subcmd": "1",
            "data": {},
            "rspdata": {
                "initData": {
                    "commandLv": 1,
                    "commandExp": 0,
                    "commonTaskData": [
                        {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeItem": "speedup"},
                        {"index": 3, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeGold": 50},
                        {"index": 4, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN},
                    ],
                    "armyPioneerTaskData": {
                        "index": 2, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN,
                        "consumeItem": "speedup", "obj": {"x": 100, "y": 200}
                    },
                    "finishTaskData": [
                        {"index": 5, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH},
                    ],
                }
            }
        }
        conn.set_response(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_INIT, init_payload)

        task = CommandHallTask(conn, config={"enabled": True})

        # Fast forward time: simulate clock ticking 35 seconds per iteration so it exits after completing tasks
        simulated_time = 1000.0

        def fake_time():
            nonlocal simulated_time
            t = simulated_time
            simulated_time += 35.0
            return t

        async def fake_sleep(sec):
            return

        with patch("time.time", side_effect=fake_time), patch("asyncio.sleep", side_effect=fake_sleep):
            result = asyncio.run(task.run())

        self.assertTrue(result.success)

        # 1. Verify CMD 2274 SubCMD 1 was called EXACTLY ONCE at start, never repeated in the loop
        subcmd_1_calls = [
            q for q in conn.query_log
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_INIT
        ]
        self.assertEqual(len(subcmd_1_calls), 1, "SubCMD 1 must NOT be called repeatedly inside the loop!")

        # 2. Verify Task 1 (consumeItem: speedup) and Task 3 (consumeGold: 50) were NEVER executed via SubCMD 5
        subcmd_5_calls = [
            q for q in conn.query_log
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == "5"
        ]
        subcmd_5_indices = [q["data"]["index"] for q in subcmd_5_calls]
        self.assertNotIn(1, subcmd_5_indices, "Adversarial trap task 1 (consumeItem: speedup) was dispatched!")
        self.assertNotIn(3, subcmd_5_indices, "Adversarial trap task 3 (consumeGold: 50) was dispatched!")
        self.assertIn(4, subcmd_5_indices, "Safe task 4 should have been executed!")

        # 3. Verify Task 2 (march with consumeItem: speedup) was NEVER dispatched to world map (CMD 1007)
        cmd_1007_calls = [
            q for q in conn.query_log
            if q["cmd"] == "1007"
        ]
        self.assertEqual(len(cmd_1007_calls), 0, "Adversarial march trap (consumeItem: speedup) was dispatched!")

        # 4. Verify finished task 5 was claimed via SubCMD 8
        subcmd_8_calls = [
            q for q in conn.query_log
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == "8"
        ]
        subcmd_8_indices = [q["data"]["index"] for q in subcmd_8_calls]
        self.assertIn(5, subcmd_8_indices, "Finished task 5 should have been claimed!")


if __name__ == "__main__":
    unittest.main()

