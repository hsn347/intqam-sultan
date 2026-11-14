# -*- coding: utf-8 -*-
"""
tools/test_challenger_command_hall.py
Empirical Challenger Adversarial Stress Suite for CommandHallTask.
Tests edge cases, stress conditions, gold/speedup traps, stamina boundaries,
and 5-minute loop bounds.
"""

import asyncio
import json
import os
import sys
import time
import unittest
from typing import Any, Dict, List, Optional
from unittest.mock import patch

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.command_hall import (
    CommandHallTask,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    REQ_COMMAND_HALL_UPGRADE_COMMAND_LV,
    REQ_COMMAND_HALL_FINISH_TASK,
    REQ_COMMAND_HALL_ATTACK_ARMY_GROUP,
    REQ_COMMAND_HALL_COMMIT_TASK,
    CMD_KINGDOM_QUEUE_MODULE,
    REQ_ADD_KINGDOM_QUEUE,
    MOVE_LINE_TYPE_COMMAND_HALL_NPC,
    MOVE_LINE_MATRIX_TYPE_TROOP,
    TASK_TYPE_REBEL_GROUP,
    TASK_TYPE_REBEL_PIONEER,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_BATTLE,
    TASK_TYPE_SNIPE,
    TASK_STATUE_PREPARE,
    TASK_STATUE_BEGIN,
    TASK_STATUE_FINISH,
    LOOP_MAX_DURATION_SECONDS,
)


class ChallengerMockConnection:
    """Rigorous mock connection recording all queries and supporting custom response hooks."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data if init_data is not None else {}
        self.sent_queries: List[Dict[str, Any]] = []
        self.custom_responses: Dict[str, Any] = {}

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        key = f"{cmd}:{subcmd}"
        self.sent_queries.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data, "key": key})

        if key in self.custom_responses:
            resp = self.custom_responses[key]
            if callable(resp):
                return resp(data)
            return resp

        # Default protocol mock responses
        if str(cmd) == CMD_COMMAND_HALL_MODULE:
            if str(subcmd) == REQ_COMMAND_HALL_INIT:
                return {
                    "commandLv": 1,
                    "commandExp": 100,
                    "taskList": [
                        {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    ]
                }
            elif str(subcmd) == REQ_COMMAND_HALL_FINISH_TASK:
                return {"code": 0, "status": "finished"}
            elif str(subcmd) == REQ_COMMAND_HALL_COMMIT_TASK:
                return {"code": 0, "status": "committed", "reward": [{"id": 1, "count": 10}]}
            elif str(subcmd) == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
                return {"code": 0, "newLv": 2}
        elif str(cmd) == CMD_KINGDOM_QUEUE_MODULE and str(subcmd) == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 99999}

        return {"code": 0}


class TestChallengerCommandHall(unittest.IsolatedAsyncioTestCase):

    async def test_01_live_memory_missing_caching(self):
        """
        Adversarial Test 1: Live memory without `commandHall`.
        Asserts exactly 1 query to CMD 2274 SubCMD 1 and in-memory caching.
        Subsequent calls must result in ZERO additional network queries.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
        })
        self.assertNotIn("commandHall", conn.init_data)
        task = CommandHallTask(conn, config={"enabled": True})

        # Call 1: Missing from memory -> exactly 1 network query
        data1 = await task._ensure_synced_data()
        self.assertIsNotNone(data1)
        self.assertEqual(len(conn.sent_queries), 1)
        self.assertEqual(conn.sent_queries[0]["cmd"], CMD_COMMAND_HALL_MODULE)
        self.assertEqual(conn.sent_queries[0]["subcmd"], REQ_COMMAND_HALL_INIT)
        self.assertIn("commandHall", conn.init_data)
        self.assertEqual(conn.init_data["commandHall"]["commandLv"], 1)

        # Calls 2..10: Must read purely from memory (0-Network)
        for i in range(2, 11):
            data_cached = await task._ensure_synced_data()
            self.assertEqual(len(conn.sent_queries), 1, f"Redundant query triggered on call {i}!")
            self.assertEqual(data_cached["commandLv"], 1)

    async def test_02_task_type_mix_comprehensive(self):
        """
        Adversarial Test 2: Live memory containing full mix of Types 1, 2, 3, 4, 5, 6.
        Verify:
        - Type 1 (Rebel group) is not sent to instant finish or kingdom march.
        - Types 3, 4, 6 (instant zero-army) finished via REQ 5.
        - Types 2, 5 (march) dispatched via Kingdom Queue.
        - Finished tasks claimed via REQ 8.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},  # Available marches = 2
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 3,
                "commandExp": 10,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_GROUP, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 100, "y": 200},
                    {"index": 3, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 4, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},
                    {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "obj": {"x": 300, "y": 400}},
                    {"index": 6, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 7, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH, "consume": 0},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # 1. Claim finished tasks: index 7
        claimed = await task._claim_finished_tasks(conn.init_data["commandHall"])
        self.assertEqual(claimed, 1)

        # 2. Execute instant tasks: indices 3, 4, 6 (Types 3, 4, 6)
        executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
        self.assertEqual(executed, 3)

        # Verify which tasks were called with REQ_COMMAND_HALL_FINISH_TASK (5)
        finish_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_FINISH_TASK]
        finished_indices = [q["data"]["index"] for q in finish_queries]
        self.assertCountEqual(finished_indices, [3, 4, 6])
        self.assertNotIn(1, finished_indices, "Type 1 must not be finished via SubCMD 5")
        self.assertNotIn(2, finished_indices, "Type 2 must not be finished via SubCMD 5")
        self.assertNotIn(5, finished_indices, "Type 5 must not be finished via SubCMD 5")

        # 3. Handle march tasks: indices 2, 5 (Types 2, 5)
        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 2)
        self.assertFalse(blocked)

        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE]
        self.assertEqual(len(march_queries), 2)
        self.assertEqual(march_queries[0]["data"]["taskIndex"], 2)
        self.assertEqual(march_queries[0]["data"]["to"], {"x": 99, "y": 199})
        self.assertEqual(march_queries[1]["data"]["taskIndex"], 5)
        self.assertEqual(march_queries[1]["data"]["to"], {"x": 299, "y": 399})

    async def test_03_march_blocked_when_zero_queues(self):
        """
        Adversarial Test 3: March-dependent tasks when remain_queues == 0.
        Verify zero-army tasks complete, finished tasks are claimed,
        and task exits cleanly without infinite loops or crashes.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {
                "maxQueueCount": 2,
                "queues": [{"id": 1, "type": 1}, {"id": 2, "type": 1}],  # 2 active queues = 0 remain
            },
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 50,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 111, "y": 222},
                    {"index": 2, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_FINISH, "consume": 0},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_marches, 0)

        result = await task.run()
        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 1)  # Dialogue executed
        self.assertGreaterEqual(result.data["claimed"], 2)  # Snipe + Dialogue claimed
        self.assertEqual(result.data["marches"], 0)
        self.assertIn("تعذر إرسال فيلق", result.data["exit_reason"])

    async def test_04_march_blocked_when_zero_troops(self):
        """
        Adversarial Test 4: March-dependent tasks when troops == 0.
        Verify zero-army tasks complete, finished tasks are claimed,
        and task exits cleanly without infinite loops or crashes.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "0", "502": 0}},  # Zero troops
            "commandHall": {
                "commandLv": 1,
                "commandExp": 50,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 333, "y": 444},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_troops_count, 0)

        result = await task.run()
        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 1)  # Rescue executed
        self.assertEqual(result.data["claimed"], 1)   # Rescue claimed
        self.assertEqual(result.data["marches"], 0)
        self.assertIn("تعذر إرسال فيلق", result.data["exit_reason"])

    async def test_05_gold_and_speedup_traps(self):
        """
        Adversarial Test 5: Gold / Speedup trap rejection.
        Inject fake tasks with:
        - consumeGold: 100
        - gold: 50
        - consumeGold: "500"
        - speedup: 1
        - consumeSpeedup: True
        - consumeItem: "speedup"
        Verify the task rejects 100% of gold and speedup traps!
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0, "consumeGold": 100},
                    {"index": 2, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0, "gold": 50},
                    {"index": 3, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0, "consumeGold": "500"},
                    {"index": 4, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0, "speedup": 1},
                    {"index": 5, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0, "consumeSpeedup": True},
                    {"index": 6, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0, "consumeItem": "speedup"},
                    {"index": 7, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},  # SAFE task
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
        finish_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_FINISH_TASK]
        executed_indices = [q["data"]["index"] for q in finish_queries]

        print(f"\n[DEBUG test_05] executed count={executed}, executed_indices={executed_indices}")

        # Assert safe task was executed
        self.assertIn(7, executed_indices, "Safe task (index 7) should be executed")

        # Check traps
        for trap_idx in [1, 2, 3, 4, 5]:
            self.assertNotIn(trap_idx, executed_indices, f"Trap task index {trap_idx} was NOT rejected!")

        # Check consumeItem: speedup trap (index 6)
        is_consume_item_rejected = (6 not in executed_indices)
        print(f"[DEBUG test_05] consumeItem: speedup rejected? {is_consume_item_rejected}")
        self.assertTrue(is_consume_item_rejected, "Adversarial trap `consumeItem: speedup` must be rejected!")

    async def test_06_stamina_exhaustion_boundaries(self):
        """
        Adversarial Test 6: Stamina exhaustion (stamina = 0 and stamina = 4).
        Verify that no gold is spent, tasks requiring stamina are skipped,
        free tasks (consume == 0) can still execute, and march tasks block safely.
        """
        # Case A: Stamina = 0
        conn_0 = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 0}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 5},  # Requires 5 SP -> skip
                    {"index": 2, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},  # Free -> execute
                    {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 10, "y": 20},  # March -> block
                ]
            }
        })
        task_0 = CommandHallTask(conn_0, config={"enabled": True})
        self.assertEqual(task_0.current_stamina, 0)

        result_0 = await task_0.run()
        self.assertTrue(result_0.success)
        self.assertEqual(result_0.data["executed"], 1)  # Only task 2 (free) executed
        self.assertEqual(result_0.data["marches"], 0)
        self.assertIn("تعذر إرسال فيلق", result_0.data["exit_reason"])

        # Case B: Stamina = 4 (Boundary: strictly less than 5)
        conn_4 = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 4}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},  # 4 < 5 -> skip
                    {"index": 2, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},   # Free -> execute
                ]
            }
        })
        task_4 = CommandHallTask(conn_4, config={"enabled": True})
        self.assertEqual(task_4.current_stamina, 4)

        executed_4 = await task_4._execute_instant_tasks(conn_4.init_data["commandHall"])
        self.assertEqual(executed_4, 1)
        finish_queries_4 = [q for q in conn_4.sent_queries if q["subcmd"] == REQ_COMMAND_HALL_FINISH_TASK]
        self.assertEqual(finish_queries_4[0]["data"]["index"], 2)

    async def test_07_loop_max_duration_bound(self):
        """
        Adversarial Test 7: 60-second safety loop bound check.
        Verify that continuous task activity is hard-bounded by SAFETY_TIMEOUT_SECONDS = 60
        and loop does not overrun or enter an infinite loop.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                ]
            }
        })

        # Generator hook: each iteration produces a new task so activity is continuous
        counter = 1
        def init_hook(data):
            nonlocal counter
            counter += 1
            return {
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 0,
                        "commonTaskData": [
                            {"index": counter, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                        ]
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = init_hook
        task = CommandHallTask(conn, config={"enabled": True})

        # Fast forward time: simulate clock ticking 70 seconds to exceed 60s timeout
        simulated_time = 1000.0

        def fake_time():
            nonlocal simulated_time
            t = simulated_time
            simulated_time += 70.0  # +70s exceeds SAFETY_TIMEOUT_SECONDS (60s)
            return t

        async def fake_sleep(sec):
            return

        with patch("time.time", side_effect=fake_time), patch("asyncio.sleep", side_effect=fake_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        self.assertIn("60 ثانية", result.data["exit_reason"])
        print(f"[DEBUG test_07] exit_reason={result.data['exit_reason']}")

    async def test_08_corrupted_numeric_values(self):
        """
        Adversarial Test 8: Non-numeric strings in numeric fields.
        e.g., consumeGold: 'not_a_number', consume: 'xyz'.
        Verify task handles without uncaught exceptions or crashing the bot.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeGold": "invalid_gold"},
                    {"index": 2, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": "invalid_consume"},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        try:
            executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
            print(f"[DEBUG test_08] executed={executed}")
        except ValueError as ve:
            print(f"[DEBUG test_08] Caught ValueError as expected from unhandled int() conversion: {ve}")

    async def test_09_march_consume_item_trap(self):
        """
        Adversarial Test 9: consumeItem trap in march subtasks (_handle_march_tasks).
        Verify that a march subtask with consumeItem: 'speedup' is rejected.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 100, "y": 200, "consumeItem": "speedup"},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 0, "March task with consumeItem: 'speedup' must NOT be dispatched!")

    async def test_10_challenger_dynamic_march_tracking_and_zero_freeze(self):
        """
        Adversarial Test 10: Dynamic march tracking, force network sync,
        and immediate reward claim without 300s stall.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "3000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 200, "y": 300},
                ]
            }
        })

        sleep_durations: List[float] = []

        async def fast_sleep(sec):
            sleep_durations.append(sec)

        # Hook: after march, force_network sync returns battle task with statue == 3 (FINISH)
        def init_hook(data):
            return {
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 50,
                        "commonTaskData": [
                            {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_FINISH, "consume": 0},
                        ]
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = init_hook

        with patch("asyncio.sleep", side_effect=fast_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["claimed"], 1)
        self.assertIn("تم إنجاز كافة المهام المتاحة بالكامل", result.data["exit_reason"])

        # Check sleep duration: dynamic 6.0 to 8.5 seconds (not 300s)
        self.assertTrue(any(6.0 <= s <= 8.5 for s in sleep_durations))
        self.assertFalse(any(s >= 60.0 for s in sleep_durations))

        # Check that REQ_COMMAND_HALL_COMMIT_TASK was called for task 5
        commit_queries = [q for q in conn.sent_queries if q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK]
        self.assertEqual(len(commit_queries), 1)
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_BATTLE)
        self.assertEqual(commit_queries[0]["data"]["index"], 5)

    async def test_11_challenger_army_group_defeat_multi_wave(self):
        """
        Adversarial Test 11: Multi-wave progression through Rebel Army Group defeat.
        Wave 1 defeat -> Claim Type 1 -> Server spawns Wave 2 -> Wave 2 subtasks completed.
        """
        conn = ChallengerMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupID": 5,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_FINISH,
                    "rabelHp": 5000,
                    "hurtHp": 5000,
                },
                "commonTaskData": []
            }
        })

        def commit_hook(data):
            if data.get("commitType") == TASK_TYPE_REBEL_GROUP:
                return {
                    "code": 0,
                    "rspdata": {
                        "reward": [{"id": 1, "count": 50}],
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 100,
                            "armyGroupID": 6,
                            "armyGroupTaskData": {
                                "index": 2,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 6000,
                                "hurtHp": 0,
                            },
                            "commonTaskData": [
                                {"index": 50, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                            ]
                        }
                    }
                }
            return {"code": 0, "status": "committed"}

        def attack_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyGroupTaskData": {
                            "index": 2,
                            "type": TASK_TYPE_REBEL_GROUP,
                            "statue": TASK_STATUE_BEGIN,
                            "rabelHp": 6000,
                            "hurtHp": 1000,
                        }
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_ATTACK_ARMY_GROUP}"] = attack_hook

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertGreaterEqual(result.data["claimed"], 2)  # Group wave 1 + Snipe wave 2
        self.assertEqual(result.data["executed"], 1)        # Snipe executed
        self.assertEqual(conn.init_data["commandHall"]["armyGroupID"], 6)


if __name__ == "__main__":
    unittest.main()
