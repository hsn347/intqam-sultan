# -*- coding: utf-8 -*-
"""
tools/test_empirical_lifecycle.py
══════════════════════════════════════════════════════════════════════════════════
Empirical Challenger: Command Hall Lifecycle, Fast March & Freeze Elimination
Target: tasks/command_hall.py
══════════════════════════════════════════════════════════════════════════════════
Verifies:
1. Fast March Arrival & Forced Sync:
   - Type 2 (Pioneer) and Type 5 (Battle) world map marches.
   - Verifies dynamic wait between 6.0 and 8.5 seconds (matching Lua COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5s).
   - Verifies forced sync query (CMD 2274 / SUBCMD 1) immediately following march arrival.
   - Verifies server response updating statue to 3 triggers immediate reward claim (CMD 2274 / SUBCMD 8).
2. Freeze Elimination:
   - High-precision assertion that total execution time of run() across all scenarios
     (empty, march, wave renewal, blocked) never exceeds 20-30 seconds.
   - 300-second freeze is 100% eliminated.
3. Multi-Wave Progression:
   - Defeating Rebel Army Group (Type 1) unpacks Wave N+1 into live memory.
   - Subsequent wave tasks are seamlessly executed and claimed within the same session.
   - 3-wave progression chain verification.
4. Adversarial Stress & Failure Mode Mining:
   - CRITICAL VULNERABILITY: Double-claiming and infinite-loop claiming of Rebel Army Group (Type 1).
   - Network dropouts during force sync.
   - Delayed battle resolution on server.
   - Claim failure handling.
   - Gathering hero exclusion.
══════════════════════════════════════════════════════════════════════════════════
"""

import asyncio
import os
import sys
import time
import unittest
from typing import Any, Callable, Dict, List, Optional, Tuple
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
    SAFETY_TIMEOUT_SECONDS,
    LOOP_MAX_DURATION_SECONDS,
    COMMANDHALL_REBEL_ARMY_MARCH_TIME,
    COMMANDHALL_COMMON_TASK_MARCH_TIME,
    MARCH_DYNAMIC_WAIT_MIN,
    MARCH_DYNAMIC_WAIT_MAX,
    GATHERING_HERO_IDS,
)


class EmpiricalLifecycleMockConnection:
    """Mock connection recording all network packets, timestamps, and hookable responses."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data if init_data is not None else {}
        self.sent_queries: List[Dict[str, Any]] = []
        self.custom_responses: Dict[str, Any] = {}
        self.query_log: List[Tuple[float, str, str, Dict[str, Any]]] = []

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        key = f"{cmd}:{subcmd}"
        timestamp = time.time()
        self.sent_queries.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": data, "key": key})
        self.query_log.append((timestamp, str(cmd), str(subcmd), data))

        if key in self.custom_responses:
            handler = self.custom_responses[key]
            if callable(handler):
                return handler(data)
            return handler

        # Standard default responses
        if str(cmd) == CMD_COMMAND_HALL_MODULE:
            if str(subcmd) == REQ_COMMAND_HALL_INIT:
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 100,
                            "taskList": [],
                        }
                    }
                }
            elif str(subcmd) == REQ_COMMAND_HALL_COMMIT_TASK:
                return {"code": 0, "status": "ok", "reward": [{"id": 1001, "num": 10}]}
            elif str(subcmd) == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
                return {"code": 0, "newLv": 2}
            elif str(subcmd) == REQ_COMMAND_HALL_FINISH_TASK:
                return {"code": 0, "status": "finished"}
            elif str(subcmd) == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP:
                return {"code": 0, "status": "attacked"}
        elif str(cmd) == CMD_KINGDOM_QUEUE_MODULE and str(subcmd) == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 88888}

        return {"code": 0}


def create_standard_castle_state(
    hall_override: Optional[Dict[str, Any]] = None,
    health: int = 100,
    free_marches: int = 2,
    troops: int = 5000,
) -> Dict[str, Any]:
    """Helper to initialize realistic castle memory."""
    queues = []
    if free_marches < 2:
        for i in range(2 - free_marches):
            queues.append({"type": 1, "id": f"q_{i}"})

    return {
        "lordInfoCtrl": {
            "base": {"health": health, "shieldTime": 0},
            "vip": {"level": 5},
        },
        "queueCtrl": {"queues": queues},
        "armyCtrl": {"totalArmy": {"401": str(troops)}},  # Footmen (valid combat unit)
        "heroCtrl": {
            "heros": [
                {"heroID": 1701, "state": 1, "quality": 4, "level": 30},  # Combat Hero
                {"heroID": 1711, "state": 1, "quality": 3, "level": 25},  # Gathering Hero (must exclude)
            ]
        },
        "cityCtrl": {
            "blist": [{"bid": 121, "level": 10}],  # Drill Ground
        },
        "commandHall": hall_override or {
            "commandLv": 1,
            "commandExp": 50,
            "armyGroupID": 1,
            "commonTaskData": [],
        },
    }


async def async_noop_sleep(sec: float = 0):
    """Clean async no-op sleep that avoids Python 3.12 unawaited coroutine warnings."""
    pass


class TestEmpiricalLifecycle(unittest.IsolatedAsyncioTestCase):
    """Rigorous empirical lifecycle tests for CommandHallTask."""

    # ═════════════════════════════════════════════════════════════════════════
    # 1. Fast March Arrival & Forced Sync (Type 2 Pioneer & Type 5 Battle)
    # ═════════════════════════════════════════════════════════════════════════

    async def test_01_fast_march_arrival_and_force_sync_pioneer_type_2(self):
        """
        [Requirement 1] Fast March Arrival & Forced Sync for Type 2 (Pioneer):
        1. Dispatches march via CMD 1007 / SubCMD 2.
        2. Asserts dynamic sleep is strictly between 6.0 and 8.5 seconds
           (matching COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5s + battle buffer).
        3. Asserts forced sync (CMD 2274 / SubCMD 1) is immediately sent after sleep.
        4. Asserts updating statue to 3 triggers immediate claim (CMD 2274 / SubCMD 8).
        """
        init_state = create_standard_castle_state(
            hall_override={
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupID": 1,
                "armyPioneerTaskData": {
                    "index": 10,
                    "type": TASK_TYPE_REBEL_PIONEER,
                    "statue": TASK_STATUE_BEGIN,
                    "consume": 5,
                    "x": 350,
                    "y": 450,
                },
                "commonTaskData": [],
            }
        )
        conn = EmpiricalLifecycleMockConnection(init_data=init_state)

        # Force sync response returns Pioneer task with statue = 3 (TASK_STATUE_FINISH)
        def sync_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 150,
                        "armyGroupID": 1,
                        "armyPioneerTaskData": {
                            "index": 10,
                            "type": TASK_TYPE_REBEL_PIONEER,
                            "statue": TASK_STATUE_FINISH,
                            "x": 350,
                            "y": 450,
                        },
                        "commonTaskData": [],
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = sync_hook

        sleep_durations: List[float] = []

        async def tracking_sleep(sec: float):
            sleep_durations.append(sec)

        with patch("asyncio.sleep", side_effect=tracking_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["claimed"], 1)
        self.assertIn("تم إنجاز كافة المهام المتاحة بالكامل", result.data["exit_reason"])

        # Check march sleep duration: MUST be between 6.0 and 8.5 seconds
        march_sleeps = [s for s in sleep_durations if 5.9 <= s <= 8.6]
        self.assertEqual(len(march_sleeps), 1, f"Expected exactly one march sleep in [6.0, 8.5], got: {sleep_durations}")
        self.assertTrue(all(s < 30.0 for s in sleep_durations), "No long sleeps allowed!")

        # Verify query order: March -> Sync -> Claim
        queries = conn.sent_queries
        march_indices = [i for i, q in enumerate(queries) if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE]
        sync_indices = [i for i, q in enumerate(queries) if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_INIT]
        claim_indices = [i for i, q in enumerate(queries) if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK]

        self.assertEqual(len(march_indices), 1, "Must dispatch 1 march")
        self.assertGreaterEqual(len(sync_indices), 1, "Must send force sync query")
        self.assertEqual(len(claim_indices), 1, "Must claim 1 completed task")

        # Strict sequence: march was dispatched BEFORE sync, sync happened BEFORE claim
        self.assertLess(march_indices[0], sync_indices[0])
        self.assertLess(sync_indices[0], claim_indices[0])

        # Verify claim payload
        claim_payload = queries[claim_indices[0]]["data"]
        self.assertEqual(claim_payload.get("commitType"), TASK_TYPE_REBEL_PIONEER)
        self.assertEqual(claim_payload.get("index"), 10)

    async def test_02_fast_march_arrival_and_force_sync_battle_type_5(self):
        """
        [Requirement 1] Fast March Arrival & Forced Sync for Type 5 (Battle):
        1. Dispatches march via CMD 1007 / SubCMD 2 with taskType=5.
        2. Waits 6.0 to 8.5 seconds.
        3. Forces network sync (CMD 2274 / SubCMD 1).
        4. Receives statue=3 and immediately commits claim via CMD 2274 / SubCMD 8.
        """
        init_state = create_standard_castle_state(
            hall_override={
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupID": 1,
                "commonTaskData": [
                    {
                        "index": 55,
                        "type": TASK_TYPE_BATTLE,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "x": 620,
                        "y": 740,
                    }
                ],
            }
        )
        conn = EmpiricalLifecycleMockConnection(init_data=init_state)

        def sync_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 120,
                        "armyGroupID": 1,
                        "commonTaskData": [
                            {
                                "index": 55,
                                "type": TASK_TYPE_BATTLE,
                                "statue": TASK_STATUE_FINISH,
                                "x": 620,
                                "y": 740,
                            }
                        ],
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = sync_hook

        sleep_durations: List[float] = []

        async def tracking_sleep(sec: float):
            sleep_durations.append(sec)

        with patch("asyncio.sleep", side_effect=tracking_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["claimed"], 1)

        # Verify dynamic wait was 6.0 to 8.5 seconds
        march_sleeps = [s for s in sleep_durations if 6.0 <= s <= 8.5]
        self.assertEqual(len(march_sleeps), 1)

        # Verify claim
        claim_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK]
        self.assertEqual(len(claim_queries), 1)
        self.assertEqual(claim_queries[0]["data"]["commitType"], TASK_TYPE_BATTLE)
        self.assertEqual(claim_queries[0]["data"]["index"], 55)

    # ═════════════════════════════════════════════════════════════════════════
    # 2. Freeze Elimination: Benchmark Total Execution Across All Scenarios
    # ═════════════════════════════════════════════════════════════════════════

    async def test_03_freeze_elimination_benchmark_across_all_scenarios(self):
        """
        [Requirement 2] Freeze Elimination:
        Asserts with high precision that the total execution time of run() across
        various scenarios never exceeds 20-30 seconds, and the 300-second freeze
        is 100% eliminated.

        Scenarios benchmarked:
        A. No tasks (empty) -> terminates in < 1 second.
        B. Already finished tasks -> claims and terminates in < 2 seconds.
        C. March task with arrival & sync -> simulated elapsed time < 10 seconds.
        D. Wave progression (Wave 1 defeated -> Wave 2 live with fresh group) -> simulated elapsed time < 15 seconds.
        E. Blocked on resources (0 marches / 0 troops) -> terminates in < 1 second.
        """
        scenarios: List[Tuple[str, Dict[str, Any], Dict[str, Any]]] = [
            (
                "Scenario A (Empty Tasks)",
                create_standard_castle_state(hall_override={"taskList": [], "commonTaskData": []}),
                {},
            ),
            (
                "Scenario B (Finished Tasks Ready for Claim)",
                create_standard_castle_state(hall_override={
                    "taskList": [
                        {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH, "consume": 0},
                        {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_FINISH, "consume": 0},
                    ]
                }),
                {},
            ),
            (
                "Scenario C (March Task with Dynamic 6-8.5s Arrival)",
                create_standard_castle_state(hall_override={
                    "armyPioneerTaskData": {
                        "index": 10,
                        "type": TASK_TYPE_REBEL_PIONEER,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "x": 300,
                        "y": 400,
                    }
                }),
                {
                    f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}": {
                        "code": 0,
                        "rspdata": {
                            "initData": {
                                "armyPioneerTaskData": {
                                    "index": 10,
                                    "type": TASK_TYPE_REBEL_PIONEER,
                                    "statue": TASK_STATUE_FINISH,
                                    "x": 300,
                                    "y": 400,
                                }
                            }
                        }
                    }
                },
            ),
            (
                "Scenario D (Multi-Wave Progression Wave 1 -> Wave 2 with fresh group)",
                create_standard_castle_state(hall_override={
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_FINISH,
                        "rabelHp": 5000,
                        "hurtHp": 5000,
                    }
                }),
                {
                    f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}": lambda d: {
                        "code": 0,
                        "rspdata": {
                            "initData": {
                                "armyGroupID": 2,
                                "armyGroupTaskData": {
                                    "index": 2,
                                    "type": TASK_TYPE_REBEL_GROUP,
                                    "statue": TASK_STATUE_BEGIN,
                                    "rabelHp": 10000,
                                    "hurtHp": 0,
                                },
                                "commonTaskData": [
                                    {"index": 20, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0}
                                ]
                            }
                        }
                    } if d.get("commitType") == 1 else {"code": 0}
                },
            ),
            (
                "Scenario E (Blocked on Troops: 0 Available Troops)",
                create_standard_castle_state(
                    hall_override={
                        "armyPioneerTaskData": {
                            "index": 10,
                            "type": TASK_TYPE_REBEL_PIONEER,
                            "statue": TASK_STATUE_BEGIN,
                            "consume": 5,
                            "x": 300,
                            "y": 400,
                        }
                    },
                    troops=0,  # 0 troops!
                ),
                {},
            ),
        ]

        print("\n" + "=" * 78)
        print("EMPIRICAL BENCHMARK: FREEZE ELIMINATION & LIFECYCLE EXECUTION")
        print("=" * 78)

        for name, initial_state, custom_resp in scenarios:
            conn = EmpiricalLifecycleMockConnection(init_data=initial_state)
            conn.custom_responses.update(custom_resp)

            simulated_sleep_time = 0.0
            sleep_calls: List[float] = []

            async def mock_sleep(sec: float):
                nonlocal simulated_sleep_time
                simulated_sleep_time += sec
                sleep_calls.append(sec)

            wall_start = time.perf_counter()
            with patch("asyncio.sleep", side_effect=mock_sleep):
                task = CommandHallTask(conn, config={"enabled": True})
                result = await task.run()
            wall_elapsed = time.perf_counter() - wall_start

            print(
                f"  [{name}]\n"
                f"    Success: {result.success} | Exit Reason: {result.data.get('exit_reason')}\n"
                f"    Claimed: {result.data.get('claimed')} | Marches: {result.data.get('marches')}\n"
                f"    Simulated Sleep: {simulated_sleep_time:.2f}s | Wall-clock: {wall_elapsed:.4f}s\n"
                f"    Max Single Sleep: {max(sleep_calls) if sleep_calls else 0.0:.2f}s"
            )

            # Strict assertion 1: Wall clock test execution must be under 1.5 seconds per scenario
            self.assertLess(wall_elapsed, 1.5, f"{name}: Wall-clock execution exceeded 1.5s!")

            # Strict assertion 2: Total simulated execution time MUST NEVER exceed 20.0 seconds
            self.assertLess(
                simulated_sleep_time,
                20.0,
                f"{name}: Total simulated time ({simulated_sleep_time}s) exceeded 20s limit! Freeze risk detected!"
            )

            # Strict assertion 3: Zero sleeps >= 30.0s anywhere (old 300s freeze is 100% eliminated)
            for s in sleep_calls:
                self.assertLess(s, 30.0, f"{name}: Long sleep detected: {s}s! 300-second freeze was NOT eliminated!")

        print("=" * 78 + "\n")

    # ═════════════════════════════════════════════════════════════════════════
    # 3. Multi-Wave Progression (Wave 1 -> Wave 2 and 3-Wave Chain)
    # ═════════════════════════════════════════════════════════════════════════

    async def test_04_multi_wave_progression_seamless_single_session(self):
        """
        [Requirement 3] Multi-Wave Progression:
        1. Wave 1: Rebel Army Group (Type 1) at full HP (10,000).
        2. Task attacks Rebel Army Group via CMD 2274 / SubCMD 7.
           Server returns hurtHp = 10,000 (defeat).
        3. Task immediately recognizes defeat and sends CMD 2274 / SubCMD 8 with commitType = 1.
        4. Server returns Wave 2 (armyGroupID = 2) with a Dialogue task (Type 3) and Pioneer (Type 2).
        5. Task executes Dialogue task, claims it, dispatches Pioneer march, waits 6-8.5s,
           forces network sync, and claims Pioneer reward.
        6. Asserts all accomplished in a SINGLE run() call without restarting the bot.
        """
        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "commandExp": 0,
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

        wave_1_attacked = False

        def attack_hook(data):
            nonlocal wave_1_attacked
            if not wave_1_attacked:
                wave_1_attacked = True
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
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
            else:
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "armyGroupTaskData": {
                                "index": 2,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 25000,
                                "hurtHp": 5000,
                            }
                        }
                    }
                }

        # 2. Commit hook: claiming Wave 1 returns Wave 2
        def commit_hook(data):
            ctype = data.get("commitType")
            cidx = data.get("index")

            if ctype == TASK_TYPE_REBEL_GROUP and cidx == 1:
                return {
                    "code": 0,
                    "rspdata": {
                        "reward": [{"id": 101, "num": 50}],
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 200,
                            "armyGroupID": 2,
                            "armyGroupTaskData": {
                                "index": 2,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 25000,
                                "hurtHp": 5000,  # 5000 < 25000: not defeated yet
                            },
                            "commonTaskData": [
                                {
                                    "index": 21,
                                    "type": TASK_TYPE_DIALOGUE,
                                    "statue": TASK_STATUE_BEGIN,
                                    "consume": 0,
                                },
                                {
                                    "index": 22,
                                    "type": TASK_TYPE_REBEL_PIONEER,
                                    "statue": TASK_STATUE_BEGIN,
                                    "consume": 5,
                                    "x": 420,
                                    "y": 530,
                                },
                            ],
                        }
                    }
                }
            return {"code": 0, "status": "ok"}

        # 3. Init/Sync hook: post-march forced sync confirms Wave 2 Pioneer completion
        def sync_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "commandLv": 1,
                        "commandExp": 350,
                        "armyGroupID": 2,
                        "armyGroupTaskData": {
                            "index": 2,
                            "type": TASK_TYPE_REBEL_GROUP,
                            "statue": TASK_STATUE_BEGIN,
                            "rabelHp": 25000,
                            "hurtHp": 5000,
                        },
                        "commonTaskData": [
                            # Dialogue already claimed
                            {
                                "index": 22,
                                "type": TASK_TYPE_REBEL_PIONEER,
                                "statue": TASK_STATUE_FINISH,
                                "consume": 5,
                                "x": 420,
                                "y": 530,
                            },
                        ],
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_ATTACK_ARMY_GROUP}"] = attack_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = sync_hook

        sleep_calls = []

        async def fast_sleep(sec: float):
            sleep_calls.append(sec)

        with patch("asyncio.sleep", side_effect=fast_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        # Verify claimed: Wave 1 Rebel Group + Wave 2 Dialogue + Wave 2 Pioneer = at least 3
        self.assertGreaterEqual(result.data["claimed"], 3)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["executed"], 1)

        # Verify live memory transitioned to Wave 2
        cmd_hall_mem = conn.init_data.get("commandHall", {})
        self.assertEqual(cmd_hall_mem.get("armyGroupID"), 2)

        # Verify dynamic wait occurred for the Pioneer march
        self.assertTrue(any(6.0 <= s <= 8.5 for s in sleep_calls))

    async def test_05_three_wave_chain_progression(self):
        """
        [Requirement 3] Stress-test seamless progression across 3 successive waves:
        Wave 1 -> Wave 2 -> Wave 3 -> Clean finish when daily waves are completed.
        All within a single run() without restart or stall.
        """
        current_wave = 1

        def commit_hook(data):
            nonlocal current_wave
            ctype = data.get("commitType")
            if ctype == TASK_TYPE_REBEL_GROUP:
                if current_wave == 1:
                    current_wave = 2
                    return {
                        "code": 0,
                        "rspdata": {
                            "initData": {
                                "armyGroupID": 2,
                                "armyGroupTaskData": {
                                    "index": 2,
                                    "type": TASK_TYPE_REBEL_GROUP,
                                    "statue": TASK_STATUE_FINISH,
                                    "rabelHp": 5000,
                                    "hurtHp": 5000,
                                },
                                "commonTaskData": [
                                    {"index": 201, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0}
                                ]
                            }
                        }
                    }
                elif current_wave == 2:
                    current_wave = 3
                    return {
                        "code": 0,
                        "rspdata": {
                            "initData": {
                                "armyGroupID": 3,
                                "armyGroupTaskData": {
                                    "index": 3,
                                    "type": TASK_TYPE_REBEL_GROUP,
                                    "statue": TASK_STATUE_FINISH,
                                    "rabelHp": 10000,
                                    "hurtHp": 10000,
                                },
                                "commonTaskData": [
                                    {"index": 301, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_BEGIN, "consume": 0}
                                ]
                            }
                        }
                    }
                elif current_wave == 3:
                    current_wave = 4
                    # Daily quota exhausted, no more waves today:
                    # Crucially returns empty armyGroupTaskData to signal no monster
                    return {
                        "code": 0,
                        "rspdata": {
                            "initData": {
                                "armyGroupID": 3,
                                "armyGroupTaskData": {},
                                "tomorrowArmyGroupTaskData": {"armyGroupID": 4},
                                "commonTaskData": []
                            }
                        }
                    }
            return {"code": 0}

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "commandExp": 0,
                    "armyGroupID": 1,
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_FINISH,
                        "rabelHp": 3000,
                        "hurtHp": 3000,
                    },
                    "commonTaskData": [],
                }
            )
        )
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook

        with patch("asyncio.sleep", side_effect=async_noop_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertGreaterEqual(result.data["claimed"], 3)

    # ═════════════════════════════════════════════════════════════════════════
    # 4. Adversarial Stress & Failure Mode Mining
    # ═════════════════════════════════════════════════════════════════════════

    async def test_06_delayed_battle_resolution_server_lag(self):
        """
        Adversarial Test 4.1: Server Lag during forced sync.
        Post-march forced sync returns statue = 2 (battle still computing on server).
        Verify the bot does not get stuck in a 300-second freeze, does not crash,
        and cleanly terminates when no further progress can be made.
        """
        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "commandExp": 0,
                    "armyPioneerTaskData": {
                        "index": 99,
                        "type": TASK_TYPE_REBEL_PIONEER,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "x": 200,
                        "y": 200,
                    }
                }
            )
        )

        def lagged_sync_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyPioneerTaskData": {
                            "index": 99,
                            "type": TASK_TYPE_REBEL_PIONEER,
                            "statue": TASK_STATUE_BEGIN,  # Still not 3!
                            "x": 200,
                            "y": 200,
                        }
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = lagged_sync_hook

        sleep_calls = []

        async def fast_sleep(sec: float):
            sleep_calls.append(sec)

        with patch("asyncio.sleep", side_effect=fast_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertLess(sum(sleep_calls), 25.0)
        self.assertTrue(all(s < 30.0 for s in sleep_calls))

    async def test_07_post_march_sync_network_failure_resilience(self):
        """
        Adversarial Test 4.2: Network drop during forced sync (CMD 2274 / SubCMD 1 returns None).
        Verify task handles connection dropout gracefully and exits without uncaught exceptions.
        """
        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "armyPioneerTaskData": {
                        "index": 12,
                        "type": TASK_TYPE_REBEL_PIONEER,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "x": 300,
                        "y": 300,
                    }
                }
            )
        )

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = None

        with patch("asyncio.sleep", side_effect=async_noop_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)

    async def test_08_claim_reward_failure_graceful_handling(self):
        """
        Adversarial Test 4.3: Reward claim query (CMD 2274 / SubCMD 8) returns None.
        Verify task does not loop indefinitely retrying the same failed claim.
        """
        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "taskList": [
                        {"index": 77, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_FINISH, "consume": 0}
                    ]
                }
            )
        )

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = None

        with patch("asyncio.sleep", side_effect=async_noop_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["claimed"], 0)
        self.assertIn("تم إنجاز كافة المهام المتاحة بالكامل", result.data["exit_reason"])

    async def test_09_gathering_heroes_strictly_excluded_from_marches(self):
        """
        Adversarial Test 4.4: Gathering heroes (1711, 1717, 1724, 1733) must NEVER be sent on marches.
        Only combat heroes are permitted.
        """
        conn = EmpiricalLifecycleMockConnection(
            init_data={
                "lordInfoCtrl": {"base": {"health": 100}},
                "queueCtrl": {"queues": []},
                "armyCtrl": {"totalArmy": {"401": "5000"}},
                "heroCtrl": {
                    "heros": [
                        {"heroID": 1711, "state": 1, "quality": 5, "level": 50},  # Gathering (high lv)
                        {"heroID": 1717, "state": 1, "quality": 5, "level": 50},  # Gathering
                        {"heroID": 1724, "state": 1, "quality": 5, "level": 50},  # Gathering
                        {"heroID": 1733, "state": 1, "quality": 5, "level": 50},  # Gathering
                        {"heroID": 1705, "state": 1, "quality": 2, "level": 10},  # Weak combat hero
                    ]
                },
                "cityCtrl": {"blist": []},
                "commandHall": {
                    "armyPioneerTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_PIONEER,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "x": 100,
                        "y": 100,
                    }
                }
            }
        )

        with patch("asyncio.sleep", side_effect=async_noop_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            await task.run()

        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE]
        self.assertEqual(len(march_queries), 1)

        hero_info = march_queries[0]["data"].get("heroInfo", [])
        if hero_info:
            dispatched_hero_ids = {h["heroID"] for h in hero_info}
            intersection = dispatched_hero_ids.intersection(GATHERING_HERO_IDS)
            self.assertEqual(
                len(intersection),
                0,
                f"Gathering heroes leaked into combat march! Found: {intersection}"
            )
            self.assertIn(1705, dispatched_hero_ids)

    async def test_10_safety_timeout_constant_guarantee(self):
        """
        Adversarial Test 4.5: Safety timeout guarantee.
        Asserts SAFETY_TIMEOUT_SECONDS is exactly 60 seconds (NOT 300s),
        and LOOP_MAX_DURATION_SECONDS matches it for full backward compatibility.
        """
        self.assertEqual(SAFETY_TIMEOUT_SECONDS, 60)
        self.assertEqual(LOOP_MAX_DURATION_SECONDS, 60)
        self.assertEqual(COMMANDHALL_REBEL_ARMY_MARCH_TIME, 5)
        self.assertEqual(COMMANDHALL_COMMON_TASK_MARCH_TIME, 2)
        self.assertEqual(MARCH_DYNAMIC_WAIT_MIN, 6.0)
        self.assertEqual(MARCH_DYNAMIC_WAIT_MAX, 8.5)

    # ═════════════════════════════════════════════════════════════════════════
    # 5. EMPIRICAL VULNERABILITY CHALLENGE: Duplicate Claims & Infinite Loop
    # ═════════════════════════════════════════════════════════════════════════

    async def test_11_adversarial_vulnerability_duplicate_claim_and_infinite_loop(self):
        """
        [CHALLENGER VULNERABILITY AUDIT]
        Tests whether the bot is vulnerable to double-claiming and infinite loop
        when a Rebel Army Group (Type 1) is defeated and the server response:
        1. Advances wave without supplying a new armyGroupTaskData, OR
        2. Supplies tomorrowArmyGroupTaskData indicating all daily waves are cleared.

        EXPECTED BEHAVIOR (PASS):
        The bot claims the defeated Rebel Group EXACTLY ONCE, recognizes it as claimed,
        and cleanly terminates without sending duplicate claims or entering an infinite loop.

        VULNERABILITY BEHAVIOR (FAIL):
        - Double-claim within the same iteration (both _claim_finished_tasks and _handle_rebel_group_attack fire).
        - Endless loop claiming the same index repeatedly due to _claimed_tasks being wiped
          and status == 0 being ignored when hurtHp >= rabelHp.
        """
        group_claim_queries: List[Dict[str, Any]] = []

        def tracked_commit_hook(data):
            if data.get("commitType") == TASK_TYPE_REBEL_GROUP:
                group_claim_queries.append(data)
                # If we detect more than 3 duplicate claims, abort early to protect test run
                if len(group_claim_queries) > 3:
                    return {
                        "code": 0,
                        "rspdata": {
                            "reward": [{"id": 1, "num": 10}],
                            "initData": {
                                "armyGroupID": 2,
                                "tomorrowArmyGroupTaskData": {"armyGroupID": 3},
                                "commonTaskData": []
                            }
                        }
                    }
                return {
                    "code": 0,
                    "rspdata": {
                        "reward": [{"id": 1, "num": 10}],
                        "initData": {
                            "armyGroupID": 2,
                            "tomorrowArmyGroupTaskData": {"armyGroupID": 3},
                            "commonTaskData": []
                        }
                    }
                }
            return {"code": 0}

        conn = EmpiricalLifecycleMockConnection(
            init_data=create_standard_castle_state(
                hall_override={
                    "commandLv": 1,
                    "commandExp": 0,
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
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = tracked_commit_hook

        iteration_count = 0

        async def counting_sleep(sec: float):
            nonlocal iteration_count
            iteration_count += 1
            if iteration_count > 15:
                # Loop threshold exceeded: break loop to prevent infinite hang
                raise RuntimeError(
                    f"Infinite loop detected! Task claimed {len(group_claim_queries)} times "
                    f"across {iteration_count} iterations without terminating!"
                )

        try:
            with patch("asyncio.sleep", side_effect=counting_sleep):
                task = CommandHallTask(conn, config={"enabled": True})
                result = await task.run()
        except RuntimeError as e:
            self.fail(f"CRITICAL VULNERABILITY CONFIRMED: {e}")

        # The core assertion: The defeated Rebel Army Group MUST be claimed EXACTLY ONCE!
        self.assertEqual(
            len(group_claim_queries),
            1,
            f"CRITICAL VULNERABILITY: Rebel Army Group (index 1) was claimed {len(group_claim_queries)} times! "
            f"Duplicate/infinite claiming detected! High account BAN risk! Queries: {group_claim_queries}"
        )


if __name__ == "__main__":
    unittest.main()
