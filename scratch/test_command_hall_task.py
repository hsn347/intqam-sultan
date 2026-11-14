# -*- coding: utf-8 -*-
"""
tools/test_command_hall_task.py
اختبار برمجي شامل ومستقل لفئة مهمة قاعة القيادة CommandHallTask والتحقق من كافة الشروط والمتطلبات.
"""

import asyncio
import json
import os
import sqlite3
import sys
import unittest
from typing import Any, Dict, List, Optional

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
    GATHERING_HERO_IDS,
)
import bot_manager
import api_server


class MockConnection:
    """Mock connection to test network packet exchanges, human delays, and memory sync."""
    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data or {}
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

        if str(cmd) == CMD_COMMAND_HALL_MODULE and str(subcmd) == REQ_COMMAND_HALL_INIT:
            return {
                "commandLv": 1,
                "commandExp": 250,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 550, "y": 620},
                    {"index": 4, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_FINISH, "consume": 0},
                ]
            }
        elif str(cmd) == CMD_COMMAND_HALL_MODULE and str(subcmd) == REQ_COMMAND_HALL_COMMIT_TASK:
            return {"code": 0, "status": "ok"}
        elif str(cmd) == CMD_COMMAND_HALL_MODULE and str(subcmd) == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
            return {"code": 0, "newLv": 2}
        elif str(cmd) == CMD_COMMAND_HALL_MODULE and str(subcmd) == REQ_COMMAND_HALL_FINISH_TASK:
            return {"code": 0, "status": "finished"}
        elif str(cmd) == CMD_COMMAND_HALL_MODULE and str(subcmd) == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP:
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyGroupTaskData": {
                            "index": 1,
                            "type": TASK_TYPE_REBEL_GROUP,
                            "statue": TASK_STATUE_FINISH,
                            "rabelHp": 100000,
                            "hurtHp": 100000,
                        }
                    }
                }
            }
        elif str(cmd) == CMD_KINGDOM_QUEUE_MODULE and str(subcmd) == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 12345}
        return {"code": 0}


class TestCommandHallTask(unittest.IsolatedAsyncioTestCase):

    async def test_01_toggle_and_can_run(self):
        """Test is_active toggle and can_run checks."""
        conn = MockConnection()
        task = CommandHallTask(conn, config={"enabled": False})
        self.assertFalse(task.is_active)
        can_run, reason = await task.can_run()
        self.assertFalse(can_run)

        task.config["enabled"] = True
        self.assertTrue(task.is_active)
        # Without init_data, can_run is False
        can_run, reason = await task.can_run()
        self.assertFalse(can_run)

        # With init_data, can_run is True
        conn.init_data = {"lordInfoCtrl": {}}
        task = CommandHallTask(conn, config={"enabled": True})
        can_run, reason = await task.can_run()
        self.assertTrue(can_run)

    async def test_02_preflight_memory_caching(self):
        """Test 0-network memory pre-flight check and fallback initialization."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
        })
        task = CommandHallTask(conn, config={"enabled": True})
        
        # When commandHall not in memory, queries REQ 1 and caches to conn.init_data
        self.assertNotIn("commandHall", conn.init_data)
        hall_data = await task._ensure_synced_data()
        self.assertIsNotNone(hall_data)
        self.assertIn("commandHall", conn.init_data)
        self.assertEqual(len(conn.sent_queries), 1)
        self.assertEqual(conn.sent_queries[0]["cmd"], CMD_COMMAND_HALL_MODULE)
        self.assertEqual(conn.sent_queries[0]["subcmd"], REQ_COMMAND_HALL_INIT)

        # Second call reads purely from memory (0-Network)
        hall_data2 = await task._ensure_synced_data()
        self.assertEqual(len(conn.sent_queries), 1)

    async def test_03_priorities_execution(self):
        """Test priorities: claim finished, level upgrade, zero-army instant tasks, march blocker exit."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},  # Available marches = 2
            "armyCtrl": {"totalArmy": {"501": "0"}},  # 0 troops! Triggers blocker exit
            "commandHall": {
                "commandLv": 1,
                "commandExp": 250,  # needExp is 200, so eligible for upgrade
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 2, "type": TASK_TYPE_RESCUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                    {"index": 3, "type": TASK_TYPE_BATTLE, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 550, "y": 620},
                    {"index": 4, "type": TASK_TYPE_SNIPE, "statue": TASK_STATUE_FINISH, "consume": 0},
                    {"index": 5, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consumeGold": 50},  # Must be skipped (0-Gold)
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Run task
        result = await task.run()
        self.assertTrue(result.success)
        self.assertIn("data", result.__dict__)
        data = result.data

        # Priority 1: Claim task 4 (was finished) + tasks 1 and 2 (after instant finish)
        self.assertGreaterEqual(data.get("claimed", 0), 3)

        # Priority 2: Level upgraded from Lv 1 to Lv 2
        self.assertEqual(data.get("upgraded_levels", 0), 1)

        # Priority 4: Instant tasks executed (tasks 1 and 2, but NOT task 5 with gold)
        self.assertEqual(data.get("executed", 0), 2)

        # Priority 5: March blocked due to 0 troops, clean exit after finishing zero-army tasks
        self.assertIn("تعذر إرسال فيلق", data.get("exit_reason", ""))
        self.assertEqual(data.get("marches", 0), 0)

        # Verify sent queries log
        subcmds = [q["subcmd"] for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE]
        self.assertIn(REQ_COMMAND_HALL_COMMIT_TASK, subcmds)
        self.assertIn(REQ_COMMAND_HALL_UPGRADE_COMMAND_LV, subcmds)
        self.assertIn(REQ_COMMAND_HALL_FINISH_TASK, subcmds)

    async def test_04_march_dispatch_when_troops_available(self):
        """Test march dispatch when marches, troops, and stamina are available."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},  # Available marches = 2
            "armyCtrl": {"totalArmy": {"501": "5000"}},  # Available troops
            "commandHall": {
                "commandLv": 2,
                "commandExp": 50,
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 600, "y": 700},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 1)
        self.assertFalse(blocked)

        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE]
        self.assertEqual(len(march_queries), 1)
        self.assertEqual(march_queries[0]["subcmd"], REQ_ADD_KINGDOM_QUEUE)
        self.assertEqual(march_queries[0]["data"]["moveLineType"], MOVE_LINE_TYPE_COMMAND_HALL_NPC)
        self.assertEqual(march_queries[0]["data"]["to"], {"x": 599, "y": 699})

    def test_05_bot_manager_and_api_server_integration(self):
        """Test registration in bot_manager and api_server CastleConfigModel."""
        # 1. Registered in bot_manager
        self.assertIn(CommandHallTask, bot_manager.REGISTERED_TASKS)
        idx_cmd = bot_manager.REGISTERED_TASKS.index(CommandHallTask)
        idx_daily = bot_manager.REGISTERED_TASKS.index(bot_manager.DailyQuestTask)
        self.assertEqual(idx_cmd, idx_daily - 1)

        # 2. In DEFAULT_BOT_CONFIG
        self.assertIn("command_hall", bot_manager.DEFAULT_BOT_CONFIG["tasks"])
        self.assertFalse(bot_manager.DEFAULT_BOT_CONFIG["tasks"]["command_hall"]["enabled"])

        # 3. In api_server CastleConfigModel
        model = api_server.CastleConfigModel(command_hall={"enabled": True})
        self.assertIsNotNone(model.command_hall)
        self.assertTrue(model.command_hall.enabled)

    def test_06_database_all_castles_configured(self):
        """Direct DB inspection asserting 100% presence in database/castles.db."""
        db_path = os.path.join(_ROOT, "database", "castles.db")
        self.assertTrue(os.path.exists(db_path))
        conn = sqlite3.connect(db_path)
        rows = conn.execute("SELECT castle_id, email, config FROM castle_states").fetchall()
        self.assertGreater(len(rows), 0)
        for cid, email, cfg_str in rows:
            cfg = json.loads(cfg_str)
            self.assertIn("command_hall", cfg, f"Missing root command_hall in {email}")
            self.assertIn("tasks", cfg, f"Missing tasks in {email}")
            self.assertIn("command_hall", cfg["tasks"], f"Missing tasks.command_hall in {email}")
            self.assertIsInstance(cfg["command_hall"]["enabled"], bool)
            self.assertEqual(cfg["command_hall"]["enabled"], cfg["tasks"]["command_hall"]["enabled"])
        conn.close()

    def test_07_hero_selection_combat_vs_gathering(self):
        """Test hero selection: strictly excludes gathering heroes (1711, 1717, 1724, 1733) and busy heroes."""
        conn = MockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1717": {"heroID": 1717, "quality": 5, "level": 60, "state": 1},  # Gathering -> EXCLUDE
                    "1711": {"heroID": 1711, "quality": 4, "level": 50, "state": 1},  # Support -> EXCLUDE
                    "1703": {"heroID": 1703, "quality": 3, "level": 40, "state": 1},  # Combat eligible
                    "1707": {"heroID": 1707, "quality": 4, "level": 60, "state": 1},  # Combat top
                    "1700": {"heroID": 1700, "quality": 5, "level": 70, "state": 4},  # In battle -> EXCLUDE
                    "1705": {"heroID": 1705, "quality": 5, "level": 70, "state": 1, "queue": {"id": 99}},  # In queue -> EXCLUDE
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Top 1 hero must be 1707 (highest quality/level among eligible)
        heroes = task._select_combat_heroes(max_heroes=1)
        self.assertEqual(len(heroes), 1)
        self.assertEqual(heroes[0]["heroID"], 1707)

        # Top 2 heroes must be [1707, 1703]
        heroes2 = task._select_combat_heroes(max_heroes=2)
        self.assertEqual(len(heroes2), 2)
        self.assertEqual(heroes2[0]["heroID"], 1707)
        self.assertEqual(heroes2[1]["heroID"], 1703)

        # Gathering heroes must never be selected
        selected_ids = {h["heroID"] for h in heroes2}
        self.assertTrue(selected_ids.isdisjoint(GATHERING_HERO_IDS))

    def test_08_march_capacity_and_troop_selection_excluding_traps(self):
        """Test march capacity calculation and troop selection strictly excluding wall traps (801..825)."""
        conn = MockConnection(init_data={
            "cityCtrl": {"blist": [{"bid": 121, "level": 10}]},  # Drill grounds lv 10
            "lordInfoCtrl": {"vip": {"level": 10}},
            "armyCtrl": {
                "totalArmy": {
                    "801": "5000",   # Wall Trap -> EXCLUDE
                    "812": "500",    # Wall Trap -> EXCLUDE
                    "401": "2000",   # Infantry T1
                    "606": "1500",   # Cavalry T6
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Capacity should be >= 3000 and include drill grounds + VIP
        capacity = task._calculate_march_capacity()
        self.assertGreaterEqual(capacity, 16000)

        # Available troops must strictly exclude traps: 2000 + 1500 = 3500
        self.assertEqual(task.available_troops_count, 3500)

        # Select troops capped at 2500
        selected = task._select_march_troops(max_capacity=2500)
        total_num = sum(t["num"] for t in selected)
        self.assertEqual(total_num, 2500)
        # Unit IDs must be from combat units only (606 first because higher ID, then 401)
        self.assertEqual(selected[0]["id"], 606)
        self.assertEqual(selected[0]["num"], 1500)
        self.assertEqual(selected[1]["id"], 401)
        self.assertEqual(selected[1]["num"], 1000)
        for t in selected:
            self.assertNotIn(t["id"], [801, 812])

    async def test_09_rebel_group_attack_and_reward_commit(self):
        """Test Type 1 Rebel Army Group attack (SubCMD 7) and reward claim (SubCMD 8)."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "armyCtrl": {"totalArmy": {"501": "3000"}},
            "heroSysCtrl": {"heroList": {"1707": {"heroID": 1707, "quality": 4, "level": 50, "state": 1}}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_BEGIN,
                    "rabelHp": 100000,
                    "hurtHp": 0,
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Attack rebel army group
        res = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(res)

        # Verify attack query sent
        attack_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP]
        self.assertEqual(len(attack_queries), 1)
        self.assertIn("armyInfo", attack_queries[0]["data"])
        self.assertIn("heroInfo", attack_queries[0]["data"])
        self.assertEqual(attack_queries[0]["data"]["heroInfo"][0]["heroID"], 1707)

        # Verify commit query sent because server mock returned defeated
        commit_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK]
        self.assertEqual(len(commit_queries), 1)
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_REBEL_GROUP)
        self.assertEqual(commit_queries[0]["data"]["index"], 1)

    async def test_10_march_nested_packet_structure(self):
        """Test that march tasks send the complete official nested structure."""
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "2000"}},
            "heroSysCtrl": {"heroList": {"1703": {"heroID": 1703, "quality": 3, "level": 30, "state": 1}}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {"index": 2, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 120, "y": 340},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 1)
        self.assertFalse(blocked)

        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE]
        self.assertEqual(len(march_queries), 1)
        payload = march_queries[0]["data"]

        # Check official nested structure
        self.assertEqual(payload["moveLineType"], MOVE_LINE_TYPE_COMMAND_HALL_NPC)
        self.assertEqual(payload["matrixType"], MOVE_LINE_MATRIX_TYPE_TROOP)
        self.assertEqual(payload["commandHallTaskType"], TASK_TYPE_REBEL_PIONEER)
        self.assertIn("data", payload)
        inner_data = payload["data"]
        self.assertEqual(inner_data["to"]["x"], 119)
        self.assertEqual(inner_data["to"]["y"], 339)
        self.assertEqual(inner_data["mapId"], 1)
        self.assertEqual(inner_data["data"]["commandHallTaskType"], TASK_TYPE_REBEL_PIONEER)
        self.assertEqual(len(inner_data["army"]), 1)
        self.assertEqual(inner_data["army"][0]["id"], 501)
        self.assertEqual(inner_data["army"][0]["num"], 2000)
        self.assertEqual(len(inner_data["heroInfo"]), 1)
        self.assertEqual(inner_data["heroInfo"][0]["heroID"], 1703)

    async def test_11_march_dynamic_tracking_force_sync_and_reward_claim(self):
        """
        Test dynamic march tracking, force network sync (force_network=True),
        and immediate reward claim via run() without stalling or 300s sleep.
        """
        init_task_list = [
            {"index": 10, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "consume": 5, "x": 400, "y": 500},
        ]
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 2,
                "commandExp": 50,
                "commonTaskData": init_task_list,
            }
        })

        sleep_calls: List[float] = []

        async def tracking_sleep(sec):
            sleep_calls.append(sec)

        # Hook: when REQ_COMMAND_HALL_INIT is queried after march, return finished task
        def init_hook(data):
            return {
                "rspdata": {
                    "initData": {
                        "commandLv": 2,
                        "commandExp": 100,
                        "commonTaskData": [
                            {"index": 10, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_FINISH, "consume": 0},
                        ]
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_INIT}"] = init_hook

        from unittest.mock import patch
        with patch("asyncio.sleep", side_effect=tracking_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        self.assertEqual(result.data["marches"], 1)
        self.assertEqual(result.data["claimed"], 1)
        self.assertIn("تم إنجاز كافة المهام المتاحة بالكامل", result.data["exit_reason"])

        # Verify dynamic wait was 6.0 to 8.5 seconds (NOT 300 seconds!)
        self.assertTrue(any(6.0 <= s <= 8.5 for s in sleep_calls), f"Expected 6.0-8.5s sleep, got {sleep_calls}")
        self.assertFalse(any(s >= 30.0 for s in sleep_calls), "Must not have any long 30+s sleep!")

        # Verify force network sync query was dispatched
        init_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_INIT]
        self.assertGreaterEqual(len(init_queries), 1)

        # Verify claim commit query was sent
        commit_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK]
        self.assertEqual(len(commit_queries), 1)
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_REBEL_PIONEER)
        self.assertEqual(commit_queries[0]["data"]["index"], 10)

    async def test_12_wave_progression_upon_rebel_group_defeat(self):
        """
        Test Type 1 Rebel Army Group defeat, wave progression (armyGroupID + 1),
        and seamless execution of subsequent wave in a single run.
        """
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "armyGroupID": 1,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_FINISH,  # Defeated!
                    "rabelHp": 1000,
                    "hurtHp": 1000,
                },
                "commonTaskData": []
            }
        })

        # When commitType == 1 is claimed, server returns wave 2 with fresh tasks
        def commit_hook(data):
            if data.get("commitType") == TASK_TYPE_REBEL_GROUP:
                return {
                    "code": 0,
                    "rspdata": {
                        "reward": [{"id": 101, "num": 5}],
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 50,
                            "armyGroupID": 2,  # Advanced to Wave 2!
                            "armyGroupTaskData": {
                                "index": 2,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 2000,
                                "hurtHp": 0,
                            },
                            "commonTaskData": [
                                {"index": 21, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN, "consume": 0},
                            ]
                        }
                    }
                }
            return {"code": 0}

        # Attack hook for wave 2: deals 500 damage (500 < 2000, so not defeated yet)
        def attack_hook(data):
            return {
                "code": 0,
                "rspdata": {
                    "initData": {
                        "armyGroupTaskData": {
                            "index": 2,
                            "type": TASK_TYPE_REBEL_GROUP,
                            "statue": TASK_STATUE_BEGIN,
                            "rabelHp": 2000,
                            "hurtHp": 500,
                        }
                    }
                }
            }

        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_COMMIT_TASK}"] = commit_hook
        conn.custom_responses[f"{CMD_COMMAND_HALL_MODULE}:{REQ_COMMAND_HALL_ATTACK_ARMY_GROUP}"] = attack_hook

        from unittest.mock import patch
        async def instant_sleep(sec):
            return

        with patch("asyncio.sleep", side_effect=instant_sleep):
            task = CommandHallTask(conn, config={"enabled": True})
            result = await task.run()

        self.assertTrue(result.success)
        # Should have claimed Wave 1 Rebel Group + Wave 2 Dialogue task!
        self.assertGreaterEqual(result.data["claimed"], 2)
        self.assertEqual(result.data["executed"], 1)  # Wave 2 Dialogue executed
        self.assertEqual(conn.init_data["commandHall"]["armyGroupID"], 2)

    async def test_13_coordinate_translation_and_gateway_error_rejection(self):
        """
        Verify:
        1. Translation of raw server coordinates (server_x, server_y) -> tile coordinates (server - 1).
        2. Boundary safety: max(0, server - 1).
        3. Strict gateway error handling: responses like err='8002' are rejected, dispatched is 0,
           and troops/stamina are NOT consumed in memory.
        4. Successful response with queueId and err=None correctly marks dispatched=1 and updates state.
        """
        # Test 1 & 3: Error 8002 rejection with coordinate translation
        conn = MockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "commandExp": 0,
                "taskList": [
                    {
                        "index": 100,
                        "type": TASK_TYPE_REBEL_PIONEER,
                        "statue": TASK_STATUE_BEGIN,
                        "consume": 5,
                        "obj": {"id": "1-100-397-423", "x": 397, "y": 423},
                    }
                ]
            }
        })

        # Gateway returns 8002 error
        conn.custom_responses[f"{CMD_KINGDOM_QUEUE_MODULE}:{REQ_ADD_KINGDOM_QUEUE}"] = {
            "cmd": "1007",
            "subcmd": "2",
            "err": "8002",
            "_ok": True,
        }

        task = CommandHallTask(conn, config={"enabled": True})
        initial_troops = task.available_troops_count
        initial_stamina = task.current_stamina

        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])

        # Must NOT consider error as dispatched
        self.assertEqual(dispatched, 0, "Error 8002 response must NOT count as dispatched!")
        self.assertFalse(blocked)

        # Coordinates must be translated to client tile coords (397 - 1 = 396, 423 - 1 = 422)
        march_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_KINGDOM_QUEUE_MODULE and q["subcmd"] == REQ_ADD_KINGDOM_QUEUE]
        self.assertEqual(len(march_queries), 1)
        self.assertEqual(march_queries[0]["data"]["to"], {"x": 396, "y": 422})
        self.assertEqual(march_queries[0]["data"]["data"]["to"]["x"], 396)
        self.assertEqual(march_queries[0]["data"]["data"]["to"]["y"], 422)

        # In-memory troops and stamina must NOT be deducted
        self.assertEqual(task.available_troops_count, initial_troops)
        self.assertEqual(task.current_stamina, initial_stamina)
        self.assertEqual(conn.init_data["commandHall"]["taskList"][0]["statue"], TASK_STATUE_BEGIN)

        # Test 4: Success when err is None / queueId present
        conn.sent_queries.clear()
        conn.custom_responses[f"{CMD_KINGDOM_QUEUE_MODULE}:{REQ_ADD_KINGDOM_QUEUE}"] = {
            "cmd": "1007",
            "subcmd": "2",
            "queueId": "11307263-3767",
            "err": None,
            "_ok": True,
        }

        dispatched_success, _ = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched_success, 1)
        self.assertEqual(conn.init_data["commandHall"]["taskList"][0]["statue"], TASK_STATUE_PREPARE)
        self.assertEqual(task.current_stamina, initial_stamina - 5)


if __name__ == "__main__":
    unittest.main()
