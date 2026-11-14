# -*- coding: utf-8 -*-
"""
tools/test_adversarial_lifecycle.py
══════════════════════════════════════════════════════════════════════════════════
Adversarial Lifecycle Stress Testing & Crash Immunity Verification
Author: Empirical Challenger (teamwork_challenger)
Target: tasks/command_hall.py

Strict Verification Matrix:
1. Zero Troops & March Blocker:
   - 0 troops or no march queues: execute instant tasks (3, 4, 6), skip march tasks (2, 5),
     claim rewards, and exit cleanly in < 5 seconds without exceptions.
2. Network Sync Failure Post-March:
   - Simulate network timeout or err != "0" during post-march force_network sync.
   - Graceful recovery, no freeze/stall, clean exit.
3. Malformed / Empty Server Data:
   - Empty commandHall, missing armyGroupTaskData, corrupted coordinates, non-integer IDs.
   - 100% crash immunity.
4. Strict Zero-Gold Spend Invariant:
   - Gold balance never decreases in any adversarial or normal scenario.
══════════════════════════════════════════════════════════════════════════════════
"""

import asyncio
import os
import sys
import time
import unittest
from typing import Any, Callable, Dict, List, Optional
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
    TASK_TYPE_REBEL_GROUP,
    TASK_TYPE_REBEL_PIONEER,
    TASK_TYPE_DIALOGUE,
    TASK_TYPE_RESCUE,
    TASK_TYPE_BATTLE,
    TASK_TYPE_SNIPE,
    TASK_STATUE_PREPARE,
    TASK_STATUE_BEGIN,
    TASK_STATUE_FINISH,
)


class AdversarialMockConnection:
    """Adversarial Mock Connection providing packet recording, latency injection, and fault injection."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data if init_data is not None else {}
        self.sent_queries: List[Dict[str, Any]] = []
        self.custom_responses: Dict[str, Any] = {}

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        record = {
            "cmd": str(cmd),
            "subcmd": str(subcmd),
            "data": data,
            "timestamp": time.time(),
        }
        self.sent_queries.append(record)
        key = f"{cmd}:{subcmd}"

        if key in self.custom_responses:
            resp = self.custom_responses[key]
            if callable(resp):
                return resp(data)
            return resp

        # Default standard responses
        if str(cmd) == CMD_COMMAND_HALL_MODULE:
            if str(subcmd) == REQ_COMMAND_HALL_INIT:
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 0,
                            "armyGroupID": 1,
                            "taskList": [],
                        }
                    }
                }
            elif str(subcmd) == REQ_COMMAND_HALL_FINISH_TASK:
                return {"code": 0, "status": "finished"}
            elif str(subcmd) == REQ_COMMAND_HALL_COMMIT_TASK:
                return {"code": 0, "status": "committed", "reward": [{"id": 1, "num": 10}]}
            elif str(subcmd) == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP:
                return {"code": 0, "status": "attacked"}
            elif str(subcmd) == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
                return {"code": 0, "newLv": 2}
        elif str(cmd) == CMD_KINGDOM_QUEUE_MODULE and str(subcmd) == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 99999}

        return {"code": 0}


class TestAdversarialZeroTroopsAndMarchBlocker(unittest.IsolatedAsyncioTestCase):
    """
    1. Zero Troops & March Blocker:
    - 0 troops or no march queues: execute instant tasks (3, 4, 6), skip march tasks (2, 5),
      claim rewards, and exit cleanly in < 5 seconds without raising exceptions.
    """

    async def test_01_zero_troops_executes_instant_skips_march_sub_5s(self):
        """
        Adversarial test: 0 troops in castle.
        Contains: Dialogue (3), Rescue (4), Snipe (6), Pioneer (2), Battle (5).
        MUST execute 3, 4, 6, claim rewards, skip 2 and 5, and exit in < 5.0s without exceptions.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 100000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {}},  # Exactly 0 troops
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},
                    {"index": 3, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 4, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 120, "y": 340},
                    {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 200, "y": 400},
                ]
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_troops_count, 0)
        self.assertGreater(task.available_marches, 0)

        # Fast human jitter mock (0.01s - 0.02s) to test real wall-clock timing under 5s
        orig_safe_query = task.safe_query
        async def fast_safe_query(cmd, subcmd, data=None, min_delay=0.3, max_delay=0.7):
            return await orig_safe_query(cmd, subcmd, data, min_delay=0.01, max_delay=0.02)

        task.safe_query = fast_safe_query

        wall_start = time.perf_counter()
        result = await task.run()
        wall_elapsed = time.perf_counter() - wall_start

        # 1. Clean exit without exceptions
        self.assertTrue(result.success)
        # 2. Execution time strictly < 5.0 seconds
        self.assertLess(wall_elapsed, 5.0, f"Task exceeded 5-second SLA: took {wall_elapsed:.2f}s")
        # 3. 3 instant tasks executed
        self.assertEqual(result.data["executed"], 3)
        # 4. 3 rewards claimed
        self.assertEqual(result.data["claimed"], 3)
        # 5. Zero marches dispatched
        self.assertEqual(result.data["marches"], 0)
        # 6. Zero CMD 1007 march queries dispatched
        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE]
        self.assertEqual(len(march_queries), 0, "March queries dispatched despite zero troops!")
        # 7. Exit reason confirms march blocker safety
        self.assertIn("تعذر إرسال فيلق", result.data["exit_reason"])

    async def test_02_zero_marches_available_skips_march_and_exits_sub_5s(self):
        """
        Adversarial test: 0 march queues available (all slots full), but plenty of troops.
        Instant tasks MUST execute, march tasks MUST be blocked, exits in < 5.0s.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 80000, "health": 100}},
            # 2 active queues occupied out of 2 default max (type=1 denotes active troop march)
            "queueCtrl": {"queues": [{"id": 101, "type": 1}, {"id": 102, "type": 1}]},
            "armyCtrl": {"totalArmy": {"501": 20000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 500, "y": 600},
                ]
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_marches, 0)
        self.assertGreater(task.available_troops_count, 0)

        wall_start = time.perf_counter()
        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()
        wall_elapsed = time.perf_counter() - wall_start

        self.assertTrue(result.success)
        self.assertLess(wall_elapsed, 5.0)
        self.assertEqual(result.data["executed"], 2)
        self.assertEqual(result.data["claimed"], 2)
        self.assertEqual(result.data["marches"], 0)
        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE]
        self.assertEqual(len(march_queries), 0)

    async def test_03_traps_only_in_garrison_zero_real_troops(self):
        """
        Adversarial test: Garrison only contains wall trap IDs (801..825).
        available_troops_count MUST evaluate to 0, blocking marches without sending ghost armies.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            # Traps only!
            "armyCtrl": {"totalArmy": {"801": 2000, "810": 1500, "825": 500}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 100, "y": 200},
                ]
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_troops_count, 0)

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 1)  # Snipe executed
        self.assertEqual(result.data["marches"], 0)   # Pioneer blocked
        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE]
        self.assertEqual(len(march_queries), 0)


class TestAdversarialPostMarchSyncFailures(unittest.IsolatedAsyncioTestCase):
    """
    2. Network Sync Failure Post-March:
    - Simulate network timeout or err != "0" during post-march force_network sync.
    - Verify the task catches the error gracefully, does not crash or stall, and exits cleanly.
    """

    async def test_04_post_march_sync_network_timeout_exception(self):
        """
        Adversarial test: March is successfully dispatched.
        During post-march force_network sync (CMD 2274 / SUBCMD 1), the network times out (TimeoutError).
        Verify task catches exception via safe_query, does not crash, does not loop infinitely, and exits.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 5000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 300, "y": 400},
                ]
            }
        })

        sync_attempt = 0
        def sync_hook(data):
            nonlocal sync_attempt
            sync_attempt += 1
            # Raise network timeout during post-march force_network sync
            raise asyncio.TimeoutError("Simulated network timeout during post-march sync")

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = sync_hook

        task = CommandHallTask(conn, config={"enabled": True})

        sleep_calls = []
        async def mock_sleep(sec):
            sleep_calls.append(sec)

        with patch("asyncio.sleep", side_effect=mock_sleep):
            result = await task.run()

        # Task MUST succeed and exit cleanly
        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(sync_attempt, 1)
        # Task should have exited cleanly instead of hanging
        self.assertIn(result.data["exit_reason"], [
            "تم إنجاز كافة المهام المتاحة بالكامل",
            "بيانات قاعة القيادة غير متوفرة",
            "تعذر إرسال فيلق على الخريطة (تم إتمام باقي المهام والخروج بأمان)"
        ])

    async def test_05_post_march_sync_server_error_payload(self):
        """
        Adversarial test: March is dispatched.
        During post-march sync, server returns an error payload: {"err": "1", "msg": "gateway failure", "code": 502}.
        Verify task unpacks it safely, does not raise KeyError/TypeError, and exits cleanly.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 5000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 2, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 500, "y": 600},
                ]
            }
        })

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = {
            "err": "1",
            "msg": "gateway timeout",
            "code": 502,
        }

        task = CommandHallTask(conn, config={"enabled": True})

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)

    async def test_06_post_march_claim_network_drop(self):
        """
        Adversarial test: March dispatched, post-march sync succeeds with statue == 3.
        When claiming reward (CMD 2274 / SUBCMD 8), network drops (returns None / ConnectionResetError).
        Verify task logs warning and exits cleanly without corrupted state.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 5000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 220, "y": 330},
                ]
            }
        })

        # Post-march sync returns finished battle
        def sync_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 0,
                        "commonTaskData": [
                            {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_FINISH, "consume": 5},
                        ]
                    }
                }
            }

        # Claim hook raises network error
        def claim_hook(data):
            raise ConnectionResetError("Remote host closed connection during claim")

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = sync_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = claim_hook

        task = CommandHallTask(conn, config={"enabled": True})

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["claimed"], 0)  # Claim dropped, but didn't crash


class TestAdversarialMalformedAndEmptyServerData(unittest.IsolatedAsyncioTestCase):
    """
    3. Malformed/Empty Server Data:
    - Test empty commandHall, missing armyGroupTaskData, corrupted coordinates, non-integer IDs.
    - Verify 100% crash immunity.
    """

    async def test_07_empty_and_none_command_hall_data(self):
        """
        Adversarial test: commandHall in live memory is empty dict {} or None,
        and initial server sync returns empty dict or None.
        Verify 100% crash immunity.
        """
        for empty_val in ({}, None):
            with self.subTest(empty_val=empty_val):
                conn = AdversarialMockConnection(init_data={
                    "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
                    "commandHall": empty_val,
                })
                conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = {}

                task = CommandHallTask(conn, config={"enabled": True})
                async def instant_sleep(sec):
                    return

                with patch("asyncio.sleep", side_effect=instant_sleep):
                    result = await task.run()

                self.assertTrue(result.success)
                self.assertEqual(result.data["claimed"], 0)
                self.assertEqual(result.data["executed"], 0)
                self.assertEqual(result.data["marches"], 0)

    async def test_08_corrupted_and_missing_army_group_task(self):
        """
        Adversarial test: armyGroupTaskData is corrupted with hostile types:
        None, list, string, invalid numbers, missing fields.
        Verify 100% crash immunity.
        """
        corrupted_payloads = [
            None,
            [],
            "hostile_string_not_dict",
            12345,
            {"index": "invalid", "statue": None, "rabelHp": "NaN", "hurtHp": "inf"},
            {"index": None, "type": None},
        ]

        for payload in corrupted_payloads:
            with self.subTest(payload=type(payload)):
                conn = AdversarialMockConnection(init_data={
                    "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
                    "commandHall": {
                        "commandLv": 1,
                        "commandExp": 0,
                        "armyGroupTaskData": payload,
                    }
                })

                task = CommandHallTask(conn, config={"enabled": True})
                async def instant_sleep(sec):
                    return

                with patch("asyncio.sleep", side_effect=instant_sleep):
                    result = await task.run()

                self.assertTrue(result.success)

    async def test_09_corrupted_coordinates_in_march_tasks(self):
        """
        Adversarial test: Tasks with corrupted map coordinates:
        x="corrupted", y=None, obj="not_dict", obj={"x": "nan", "y": "inf"}, missing coords.
        Verify _get_target_coordinates catches all errors and skips march cleanly.
        """
        corrupted_tasks = [
            {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "x": "bad_x", "y": "bad_y"},
            {"index": 2, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "x": None, "y": 200},
            {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "obj": "not_a_dict"},
            {"index": 4, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "obj": {"x": "nan", "y": None}},
            {"index": 5, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN},  # completely missing coords
        ]

        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 10000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": corrupted_tasks,
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 0)
        # Verify no march queries dispatched with bad coords
        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE]
        self.assertEqual(len(march_queries), 0)

    async def test_10_non_integer_and_hostile_ids_across_all_fields(self):
        """
        Adversarial test: Non-integer, hostile types across index, type, statue, rabelHp, hurtHp, consume.
        Verify _safe_int sanitizes every field and deduplication doesn't raise unhashable errors.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": 50000, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 10000}},
            "commandHall": {
                "commandLv": "1.0",
                "commandExp": "  150  ",
                "commonTaskData": [
                    {
                        "index": "NaN",
                        "type": "3",  # string dialogue
                        "statue": "2",  # string begin
                        "consume": "0.0",
                    },
                    {
                        "index": None,
                        "type": [1, 2],
                        "statue": {"nested": "bad"},
                    },
                    {
                        "index": object(),
                        "type": "not_int",
                        "statue": 2,
                    },
                ]
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)

    async def test_11_deeply_corrupted_game_ctrl_objects(self):
        """
        Adversarial test: cityCtrl, lordInfoCtrl, armyCtrl, queueCtrl are completely corrupted
        (strings, empty lists, None).
        Verify task properties and methods handle them gracefully.
        """
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": "corrupted_lord_string",
            "cityCtrl": {"blist": "invalid_blist"},
            "armyCtrl": None,
            "queueCtrl": [1, 2, 3],
            "commandHall": {"commandLv": 1},
        })

        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.current_stamina, 0)
        self.assertEqual(task.available_troops_count, 0)
        self.assertEqual(task._calculate_march_capacity(), 3000)
        # BaseTask defaults to max(2, config) when queueCtrl is corrupted
        self.assertEqual(task.available_marches, 2)

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)


class TestAdversarialStrictZeroGoldSpendInvariant(unittest.IsolatedAsyncioTestCase):
    """
    4. Strict Zero-Gold spend invariant:
    - Verify that gold balance never decreases in any scenario.
    - Zero gold spent, zero speedups consumed, costly tasks strictly skipped.
    """

    async def test_12_strict_zero_gold_invariant_across_adversarial_flow(self):
        """
        Adversarial test: Player has 500,000 gold.
        Tasks include costly traps: consumeGold=500, gold=1000, consumeItem='speedup_chest',
        consumeItems=['gold'], alongside legitimate free tasks (Dialogue, Rescue).
        Verify:
        1. Free tasks are executed and claimed.
        2. Costly tasks are strictly skipped.
        3. Gold balance before == Gold balance after (EXACT invariant).
        4. No network queries contain gold spend parameters.
        """
        initial_gold = 500000
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": initial_gold, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 10000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "commonTaskData": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},
                    # Costly traps
                    {"index": 3, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeGold": 500},
                    {"index": 4, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "gold": 1000},
                    {"index": 5, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consumeSpeedup": True},
                    {"index": 6, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consumeItem": "speedup_60m", "x": 100, "y": 200},
                    {"index": 7, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consumeItems": [{"id": 1}], "x": 150, "y": 250},
                ]
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.gold, initial_gold)

        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        # Free tasks executed and claimed
        self.assertEqual(result.data["executed"], 2)
        self.assertEqual(result.data["claimed"], 2)

        # STRICT INVARIANT: Gold balance did not decrease
        final_gold = task.gold
        self.assertEqual(final_gold, initial_gold, f"Gold leaked! Initial: {initial_gold}, Final: {final_gold}")

        # Verify no network packet attempted to spend gold or speedups
        for q in conn.sent_queries:
            q_data = q.get("data")
            if isinstance(q_data, dict):
                self.assertFalse(q_data.get("useGold", False))
                self.assertFalse(q_data.get("costGold", False))
                self.assertNotIn("gold", q_data)

    async def test_13_costly_rebel_group_attack_zero_gold_defense(self):
        """
        Adversarial test: Rebel Army Group (Type 1) injected with gold or speedup cost.
        _handle_rebel_group_attack MUST identify the cost trap and abort the attack.
        """
        initial_gold = 77777
        conn = AdversarialMockConnection(init_data={
            "lordInfoCtrl": {"base": {"gold": initial_gold, "health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": 5000}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_BEGIN,
                    "rabelHp": 100000,
                    "hurtHp": 0,
                    "consumeGold": 50,  # Hostile cost trap on Rebel Group!
                }
            }
        })

        task = CommandHallTask(conn, config={"enabled": True})
        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            result = await task.run()

        self.assertTrue(result.success)
        # Verify attack query was NEVER dispatched
        attack_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP
        ]
        self.assertEqual(len(attack_queries), 0, "Attacked costly rebel group despite 0-gold rule!")
        self.assertEqual(task.gold, initial_gold)


if __name__ == "__main__":
    unittest.main()
