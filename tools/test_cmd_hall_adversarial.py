# -*- coding: utf-8 -*-
"""
tools/test_cmd_hall_adversarial.py
══════════════════════════════════════════════════════════════════════════════════
Empirical Challenger 2: Adversarial & Concurrency Test Suite
Author: Challenger 2 (teamwork_challenger)
Target: tasks/command_hall.py

Rigorous empirical challenge matrix covering:
1. Adversarial Cost Traps (6 Subtask Types x 5 Cost Traps = 30 combinations + falsy checks)
2. Resource Exhaustion & Blocker Scenarios (marches=0, garrison=0, traps-only, stamina<5)
3. Memory Corruption & Robust Type Casting (_safe_int on corrupted/hostile fields)
4. Concurrency, safe_query failures, and loop bounds
══════════════════════════════════════════════════════════════════════════════════
"""

import asyncio
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


class EmpiricalMockConnection:
    """Rigorous mock connection tracking all queries, payloads, and call sequences."""

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

        # Default protocol responses
        if str(cmd) == CMD_COMMAND_HALL_MODULE:
            if str(subcmd) == REQ_COMMAND_HALL_INIT:
                return {
                    "commandLv": 1,
                    "commandExp": 50,
                    "taskList": [],
                }
            elif str(subcmd) == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP:
                return {"code": 0, "status": "attacked", "rabelHp": 1000, "hurtHp": 1000}
            elif str(subcmd) == REQ_COMMAND_HALL_FINISH_TASK:
                return {"code": 0, "status": "finished"}
            elif str(subcmd) == REQ_COMMAND_HALL_COMMIT_TASK:
                return {"code": 0, "status": "committed", "reward": [{"id": 1, "count": 100}]}
            elif str(subcmd) == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
                return {"code": 0, "status": "upgraded"}
        elif str(cmd) == CMD_KINGDOM_QUEUE_MODULE and str(subcmd) == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 88888}

        return {"code": 0}


class TestAdversarialCostTraps(unittest.IsolatedAsyncioTestCase):
    """
    Challenge Dimension 1: Adversarial Cost Traps.
    Inject corrupted or malicious payloads with gold, speedups, and item traps.
    Verify 100% rejection across all 6 subtask types.
    """

    SUBTASK_TYPES = [
        (TASK_TYPE_REBEL_GROUP, "Rebel Group (Type 1)"),
        (TASK_TYPE_REBEL_PIONEER, "Rebel Pioneer (Type 2)"),
        (TASK_TYPE_DIALOGUE, "Dialogue (Type 3)"),
        (TASK_TYPE_RESCUE, "Rescue (Type 4)"),
        (TASK_TYPE_BATTLE, "Battle Squad (Type 5)"),
        (TASK_TYPE_SNIPE, "Silent Sniper (Type 6)"),
    ]

    TRAP_PAYLOADS = [
        ("gold: 1", {"gold": 1}),
        ("consumeGold: '100'", {"consumeGold": "100"}),
        ("consumeSpeedup: True", {"consumeSpeedup": True}),
        ("consumeItem: 'speedup'", {"consumeItem": "speedup"}),
        ("items: ['gold_pack']", {"items": ["gold_pack"]}),
        ("consumeItems: {'speedup_1h': 1}", {"consumeItems": {"speedup_1h": 1}}),
        ("item: 'gold'", {"item": "gold"}),
        ("speedup: 5", {"speedup": 5}),
    ]

    def test_01_is_costly_task_trap_matrix(self):
        """Verify _is_costly_task accurately detects every trap pattern."""
        for trap_label, trap_dict in self.TRAP_PAYLOADS:
            with self.subTest(trap=trap_label):
                task = {"index": 1, "type": 3, "statue": 2, **trap_dict}
                is_costly = CommandHallTask._is_costly_task(task)
                self.assertTrue(
                    is_costly,
                    f"Cost trap '{trap_label}' was NOT flagged by _is_costly_task!"
                )

    def test_02_is_costly_task_safe_falsy_values(self):
        """Verify _is_costly_task does NOT falsely flag legitimate free tasks."""
        safe_samples = [
            {"index": 1, "consumeGold": 0, "gold": 0},
            {"index": 2, "consumeSpeedup": False, "speedup": 0},
            {"index": 3, "consumeItem": "", "items": []},
            {"index": 4, "consumeItem": "0", "items": {}},
            {"index": 5, "consumeItem": "false", "consumeItems": None},
            {"index": 6, "consume": 0},
            {"index": 7, "consume": 5},
        ]
        for task in safe_samples:
            with self.subTest(task=task):
                self.assertFalse(
                    CommandHallTask._is_costly_task(task),
                    f"Safe task was falsely flagged as costly: {task}"
                )

    async def test_03_rejection_across_all_six_subtask_types(self):
        """
        Adversarial Injection Matrix:
        For every subtask type (1..6) and every trap payload:
        Run execution logic and assert ZERO network execution queries are emitted.
        """
        for t_type, t_name in self.SUBTASK_TYPES:
            for trap_label, trap_dict in self.TRAP_PAYLOADS:
                with self.subTest(subtask=t_name, trap=trap_label):
                    conn = EmpiricalMockConnection(init_data={
                        "lordInfoCtrl": {"base": {"health": 100}},
                        "queueCtrl": {"queues": []},
                        "armyCtrl": {"totalArmy": {"401": "1000", "501": "1000"}},
                        "commandHall": {
                            "commandLv": 1,
                            "commandExp": 0,
                            "taskList": [
                                {
                                    "index": 42,
                                    "type": t_type,
                                    "statue": TASK_STATUE_BEGIN,
                                    "consume": 0,
                                    "rabelHp": 1000,
                                    "hurtHp": 0,
                                    "x": 150,
                                    "y": 250,
                                    **trap_dict,
                                }
                            ]
                        }
                    })
                    task = CommandHallTask(conn, config={"enabled": True})

                    if t_type == TASK_TYPE_REBEL_GROUP:
                        res = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
                        self.assertFalse(res, f"Type 1 with {trap_label} should return False")
                        attack_queries = [
                            q for q in conn.sent_queries
                            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP
                        ]
                        self.assertEqual(len(attack_queries), 0, f"Type 1 attacked despite trap: {trap_label}")

                    elif t_type in (TASK_TYPE_DIALOGUE, TASK_TYPE_RESCUE, TASK_TYPE_SNIPE):
                        executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
                        self.assertEqual(executed, 0, f"{t_name} executed despite trap: {trap_label}")
                        finish_queries = [
                            q for q in conn.sent_queries
                            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_FINISH_TASK
                        ]
                        self.assertEqual(len(finish_queries), 0, f"{t_name} sent finish query despite trap: {trap_label}")

                    elif t_type in (TASK_TYPE_REBEL_PIONEER, TASK_TYPE_BATTLE):
                        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
                        self.assertEqual(dispatched, 0, f"{t_name} dispatched despite trap: {trap_label}")
                        march_queries = [
                            q for q in conn.sent_queries
                            if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE
                        ]
                        self.assertEqual(len(march_queries), 0, f"{t_name} sent march query despite trap: {trap_label}")


class TestResourceExhaustionAndBlockers(unittest.IsolatedAsyncioTestCase):
    """
    Challenge Dimension 2: Resource Exhaustion & Blocker Scenarios.
    - When marches == 0 or garrison troops == 0:
      * Does it complete all remaining zero-army instant tasks (Types 3, 4, 6)?
      * Does it claim all available finished rewards?
      * Does it exit cleanly without infinite retries or blocking the bot?
    - When lord stamina < 5:
      * Does it skip stamina-consuming tasks without attempting to buy stamina with gold?
    """

    async def test_01_marches_zero_completes_instant_and_claims_all(self):
        """
        When marches == 0:
        Task list contains:
        - Task 1: Type 3 (Dialogue, ready, consume=0) -> should EXECUTE
        - Task 2: Type 4 (Rescue, ready, consume=0) -> should EXECUTE
        - Task 3: Type 6 (Snipe, ready, consume=0) -> should EXECUTE
        - Task 4: Type 3 (Dialogue, finished) -> should CLAIM
        - Task 5: Type 2 (Pioneer, ready) -> should BLOCK
        - Task 6: Type 5 (Battle, ready) -> should BLOCK
        Asserts:
        - Instant tasks (1, 2, 3) executed
        - All finished tasks (4, plus newly finished 1, 2, 3) claimed
        - Marches = 0
        - Clean exit in 1 loop cycle with graceful exit message
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {
                "maxQueueCount": 2,
                "queues": [{"id": 1, "type": 1}, {"id": 2, "type": 1}],  # 2 active queues = 0 remain
            },
            "armyCtrl": {"totalArmy": {"401": "5000", "501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 4, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH, "consume": 0},
                    {"index": 5, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 100, "y": 200},
                    {"index": 6, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 300, "y": 400},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_marches, 0)

        result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 3, "All 3 zero-army instant tasks must execute")
        self.assertEqual(result.data["claimed"], 4, "Task 4 + newly completed tasks 1, 2, 3 must be claimed")
        self.assertEqual(result.data["marches"], 0, "Zero marches must be dispatched")
        self.assertIn("تعذر إرسال فيلق", result.data["exit_reason"])

        # Verify no march packets sent
        march_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE
        ]
        self.assertEqual(len(march_queries), 0)

    async def test_02_garrison_troops_zero_completes_instant_and_claims_all(self):
        """
        When garrison troops == 0 (totalArmy empty or all counts 0):
        Asserts instant tasks complete, claims occur, march blocks, clean exit.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {}},  # Zero troops
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_FINISH, "consume": 0},
                    {"index": 4, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 10, "y": 20},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_troops_count, 0)

        result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 2)
        self.assertEqual(result.data["claimed"], 3)  # Task 3 + tasks 1, 2
        self.assertEqual(result.data["marches"], 0)
        self.assertIn("تعذر إرسال فيلق", result.data["exit_reason"])

    async def test_03_wall_traps_only_prevents_false_march_dispatch(self):
        """
        Adversarial: armyCtrl only contains wall traps (801..825).
        available_troops_count must be 0, and march handler must NOT dispatch traps.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {
                "totalArmy": {
                    "801": "5000",  # Rolling logs
                    "805": "3000",  # Caltrops
                    "820": "1000",  # Trebuchet trap
                }
            },
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 10, "y": 20},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.available_troops_count, 0, "Wall traps must not count as available troops")

        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 0)
        self.assertTrue(blocked)

    async def test_04_stamina_exhaustion_no_gold_purchase_attempted(self):
        """
        When lord stamina < 5:
        - Lord stamina = 3.
        - Task requiring 5 stamina must be SKIPPED.
        - Free task (consume = 0) must be EXECUTED.
        - March task (requiring 5 SP) must be BLOCKED.
        - ZERO queries attempting to buy stamina or spend gold.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 3}},  # Strictly < 5
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},  # Free
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 5},    # Cost 5 SP
                    {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 50, "y": 60}, # March
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        self.assertEqual(task.current_stamina, 3)

        result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["executed"], 1, "Only free task 1 should execute")
        self.assertEqual(result.data["claimed"], 1, "Only task 1 claimed")
        self.assertEqual(result.data["marches"], 0, "March blocked due to stamina < 5")

        # Verify absolutely no gold or item purchase commands were sent
        for q in conn.sent_queries:
            cmd = q["cmd"]
            # CMD 1003 is item store / bag; CMD 1001 is player / recharge; check gold fields
            self.assertNotEqual(cmd, "1003", "Stamina buy from store attempted!")
            payload = q["data"]
            if isinstance(payload, dict):
                self.assertNotIn("gold", payload)
                self.assertNotIn("consumeGold", payload)


class TestMemoryCorruptionAndRobustTypeCasting(unittest.IsolatedAsyncioTestCase):
    """
    Challenge Dimension 3: Memory Corruption & Robust Type Casting.
    Inject non-integer strings ('invalid_hp', 'NaN', 'inf', None, negative values)
    for rabelHp, hurtHp, index, statue, commandLv, consume.
    Verify _safe_int() prevents unhandled exceptions and maintains safe execution.
    """

    def test_01_safe_int_extreme_inputs(self):
        """Test _safe_int under hostile, extreme, and malformed inputs."""
        cases = [
            ("None", None, 0, 0),
            ("None with default 42", None, 42, 42),
            ("True boolean", True, 0, 0),
            ("False boolean", False, 0, 0),
            ("Empty string", "", 0, 0),
            ("Whitespace string", "   ", 0, 0),
            ("NaN string", "NaN", 0, 0),
            ("nan lower", "nan", 0, 0),
            ("inf string", "inf", 0, 0),
            ("-inf string", "-inf", 0, 0),
            ("Float string '123.45'", "123.45", 0, 123),
            ("Negative float string '-42.9'", "-42.9", 0, -42),
            ("Int string with spaces ' 99 '", " 99 ", 0, 99),
            ("Non-numeric 'invalid_hp'", "invalid_hp", 0, 0),
            ("List value []", [], 0, 0),
            ("Dict value {}", {}, 0, 0),
            ("Object instance", object(), 0, 0),
        ]
        for label, val, default, expected in cases:
            with self.subTest(label=label):
                res = CommandHallTask._safe_int(val, default=default)
                self.assertEqual(res, expected, f"Failed for {label}: got {res}, expected {expected}")

    async def test_02_corrupted_type1_rebel_group_hp_and_statue(self):
        """
        Inject corrupted strings and negatives into Type 1 (Rebel Group):
        rabelHp: 'invalid_hp', hurtHp: 'NaN', statue: 'corrupted', index: 'None'
        Verify no exceptions raised, degrades safely.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "1000"}},
            "commandHall": {
                "commandLv": "invalid_lv",
                "commandExp": "corrupted_exp",
                "armyGroupTaskData": {
                    "index": "invalid_index",
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": "invalid_statue",
                    "rabelHp": "invalid_hp",
                    "hurtHp": "NaN",
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Should safely parse, normalize, and not crash
        res = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertIsInstance(res, bool)

    async def test_03_corrupted_instant_task_consume_and_index(self):
        """
        Inject corrupted fields into Types 3, 4, 6:
        index: 'NaN', consume: 'invalid_consume', statue: 2.
        Verify _execute_instant_tasks executes without throwing exceptions.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "1000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": "10", "type": str(TASK_TYPE_DIALOGUE), "statue": "2", "consume": "invalid_consume"},
                    {"index": "-5", "type": TASK_TYPE_RESCUE, "statue": 2, "consume": -10},
                    {"index": "invalid", "type": TASK_TYPE_SNIPE, "statue": 2, "consume": "NaN"},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
        # All three have safe parse: index "10" -> 10, index "-5" -> -5, index "invalid" -> 0
        # None should crash
        self.assertEqual(executed, 3)

    async def test_04_corrupted_coordinates_in_march_tasks(self):
        """
        Inject non-numeric coordinates:
        x: 'invalid_x', y: None, obj: 'bad_obj'.
        Verify _handle_march_tasks skips invalid targets without crashing.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "x": "invalid", "y": "invalid"},
                    {"index": 2, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "obj": "not_a_dict"},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 0)
        self.assertFalse(blocked)


class TestConcurrencyAndLifecycle(unittest.IsolatedAsyncioTestCase):
    """
    Challenge Dimension 4: Concurrency, error isolation, and lifecycle limits.
    """

    async def test_01_safe_query_failure_does_not_crash_loop(self):
        """
        Simulate safe_query returning None (network timeout or packet loss).
        Loop must handle gracefully without crashing.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                ]
            }
        })
        # Simulate network drop on finish query
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_FINISH_TASK}"] = None

        task = CommandHallTask(conn, config={"enabled": True})
        executed = await task._execute_instant_tasks(conn.init_data["commandHall"])
        self.assertEqual(executed, 0, "Failed query should yield 0 executed tasks")

    async def test_02_cancellation_preserves_clean_shutdown(self):
        """
        Verify asyncio.CancelledError is propagated cleanly for bot_manager supervision.
        """
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"401": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        async def cancel_after_brief():
            await asyncio.sleep(0.01)
            t.cancel()

        t = asyncio.create_task(task.run())
        asyncio.create_task(cancel_after_brief())

        with self.assertRaises(asyncio.CancelledError):
            await t


if __name__ == "__main__":
    unittest.main()
