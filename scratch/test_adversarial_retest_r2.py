# -*- coding: utf-8 -*-
"""
tools/test_adversarial_retest_r2.py
══════════════════════════════════════════════════════════════════════════════════
Adversarial Retest Round 2: Deep Stress-Testing of Command Hall Lifecycle Fixes
══════════════════════════════════════════════════════════════════════════════════
Tests 5 critical adversarial boundary scenarios:
1. Direct attack defeats boss -> verify delegation to _claim_finished_tasks and NO duplicate claim on subsequent claim pass.
2. Initial memory has statue == 0 with hurtHp >= rabelHp -> verify 0 queries, 0 claims.
3. tomorrowArmyGroupTaskData arrives -> verify memory purge from hall_data and conn.init_data.
4. Identical task index across different wave IDs (e.g. Wave 1 index 1, Wave 2 index 1) -> verify both claim cleanly.
5. Network failure during claim (res is None) -> verify no infinite loop, immediate safe exit.
"""

import asyncio
import os
import sys
import unittest
from typing import Any, Dict, List, Optional
from unittest.mock import patch

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.command_hall import (
    CommandHallTask,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_COMMIT_TASK,
    REQ_COMMAND_HALL_ATTACK_ARMY_GROUP,
    TASK_TYPE_REBEL_GROUP,
    TASK_STATUE_BEGIN,
    TASK_STATUE_FINISH,
)
from tools.test_empirical_lifecycle import (
    EmpiricalLifecycleMockConnection,
    create_standard_castle_state,
)


class TestAdversarialRetestR2(unittest.IsolatedAsyncioTestCase):

    async def test_scenario_a_direct_attack_defeats_boss_no_double_claim(self):
        """Verify boss defeated via attack is claimed exactly once even if claim is evaluated again."""
        claim_queries = []
        attack_queries = []

        def attack_hook(data):
            attack_queries.append(data)
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyGroupID": 1,
                        "armyGroupTaskData": {
                            "index": 1,
                            "type": TASK_TYPE_REBEL_GROUP,
                            "statue": TASK_STATUE_FINISH,
                            "rabelHp": 10000,
                            "hurtHp": 10000,
                        }
                    }
                }
            }

        def commit_hook(data):
            if data.get("commitType") == TASK_TYPE_REBEL_GROUP:
                claim_queries.append(data)
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "armyGroupID": 2,
                            "tomorrowArmyGroupTaskData": {"armyGroupID": 2},
                            "commonTaskData": []
                        }
                    }
                }
            return {"code": 0}

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_BEGIN,
                        "rabelHp": 10000,
                        "hurtHp": 0,
                    },
                    "commonTaskData": [],
                }
            )
        )
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_ATTACK_ARMY_GROUP}"] = attack_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook

        with patch("asyncio.sleep", return_value=None):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(len(attack_queries), 1, "Attack must be sent exactly once")
        self.assertEqual(len(claim_queries), 1, "Defeated boss must be claimed EXACTLY ONCE")
        self.assertEqual(result.data["claimed"], 1)

    async def test_scenario_b_stale_statue_zero_ignored(self):
        """Verify task with statue == 0 and hurtHp >= rabelHp is strictly ignored (0 claims)."""
        claim_queries = []

        def commit_hook(data):
            claim_queries.append(data)
            return {"code": 0}

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": 0,  # Already claimed / inactive
                        "rabelHp": 10000,
                        "hurtHp": 10000,
                    },
                    "commonTaskData": [],
                }
            )
        )
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook

        with patch("asyncio.sleep", return_value=None):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(len(claim_queries), 0, "No claims should be sent for statue == 0")
        self.assertEqual(result.data["claimed"], 0)

    async def test_scenario_c_tomorrow_task_purges_memory(self):
        """Verify tomorrowArmyGroupTaskData purges armyGroupTaskData from live memory."""
        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_FINISH,
                        "rabelHp": 5000,
                        "hurtHp": 5000,
                    },
                    "commonTaskData": [],
                }
            )
        )

        def commit_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyGroupID": 2,
                        "tomorrowArmyGroupTaskData": {"armyGroupID": 2},
                        "commonTaskData": []
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook

        with patch("asyncio.sleep", return_value=None):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["claimed"], 1)
        # Verify armyGroupTaskData is purged from conn.init_data
        cmd_hall = conn.init_data.get("commandHall", {})
        self.assertNotIn("armyGroupTaskData", cmd_hall, "armyGroupTaskData must be purged from memory")

    async def test_scenario_d_identical_index_across_distinct_waves(self):
        """Verify tasks with identical index in different waves (wave 1 idx 1, wave 2 idx 1) are both claimed."""
        claimed_keys = []

        def commit_hook(data):
            claimed_keys.append((data.get("commitType"), data.get("index")))
            if len(claimed_keys) == 1:
                # Wave 1 claimed, server supplies Wave 2 with identical task index (1)
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "armyGroupID": 2,
                            "armyGroupTaskData": {
                                "index": 1,  # Same index, but wave 2!
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_FINISH,
                                "rabelHp": 8000,
                                "hurtHp": 8000,
                            },
                            "commonTaskData": []
                        }
                    }
                }
            else:
                # Wave 2 claimed
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "armyGroupID": 3,
                            "tomorrowArmyGroupTaskData": {"armyGroupID": 3},
                            "commonTaskData": []
                        }
                    }
                }

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_FINISH,
                        "rabelHp": 5000,
                        "hurtHp": 5000,
                    },
                    "commonTaskData": [],
                }
            )
        )
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook

        with patch("asyncio.sleep", return_value=None):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(len(claimed_keys), 2, "Both Wave 1 and Wave 2 bosses must be claimed")
        self.assertEqual(result.data["claimed"], 2)

    async def test_scenario_e_network_failure_on_claim_exits_safely(self):
        """Verify network failure during claim does not loop infinitely."""
        call_count = 0

        def failing_commit(data):
            nonlocal call_count
            call_count += 1
            return None  # Simulate network drop / timeout

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_FINISH,
                        "rabelHp": 5000,
                        "hurtHp": 5000,
                    },
                    "commonTaskData": [],
                }
            )
        )
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = failing_commit

        with patch("asyncio.sleep", return_value=None):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertLessEqual(call_count, 2, "Must not retry in an infinite loop; at most 2 attempts within iteration")
        self.assertEqual(result.data["claimed"], 0)


if __name__ == "__main__":
    unittest.main()
