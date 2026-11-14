# -*- coding: utf-8 -*-
"""
tools/test_empirical_challenger_cmd_hall.py
Empirical Correctness Adversarial Challenger Suite for CommandHallTask.
Specifically stress-tests and verifies:
1. Hero selection logic:
   - Only gathering heroes in heroList ([1711, 1717, 1724, 1733]) -> returns []
   - Multiple combat heroes with varying qualities/levels -> selects highest (quality, level)
   - Heroes with state != 1 and state != 5 -> ignored
   - Heroes already in queue -> ignored
2. Troop selection and march capacity:
   - totalArmy contains ONLY wall traps (801..825) -> returns [] and available_troops_count == 0
   - totalArmy contains 50,000 troops and march capacity 12,000 -> returned sum <= 12,000
   - cityCtrl.blist has no Drill Grounds -> safe base capacity (>= 3,000)
3. Type 1 Rebel Army Group:
   - Attack via CMD 2274 / SubCMD 7 when statue == 2 and rabelHp > hurtHp
   - Commit via CMD 2274 / SubCMD 8 when hurtHp >= rabelHp and refreshes task list
"""

import asyncio
import os
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
    HERO_STATE_NORMAL,
    HERO_STATE_DEFEND,
)


class EmpiricalMockConnection:
    """Rigorous mock connection recording all sent queries and responses."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.is_connected = True
        self.init_data = init_data if init_data is not None else {}
        self.sent_queries: List[Dict[str, Any]] = []
        self.attack_response: Optional[Dict[str, Any]] = None
        self.commit_response: Optional[Dict[str, Any]] = None

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Dict[str, Any]:
        entry = {"cmd": str(cmd), "subcmd": str(subcmd), "data": data}
        self.sent_queries.append(entry)

        cmd_s = str(cmd)
        sub_s = str(subcmd)

        if cmd_s == CMD_COMMAND_HALL_MODULE:
            if sub_s == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP:
                if self.attack_response is not None:
                    return self.attack_response
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "armyGroupTaskData": {
                                "index": 1,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 100000,
                                "hurtHp": 50000,
                            }
                        }
                    }
                }
            elif sub_s == REQ_COMMAND_HALL_COMMIT_TASK:
                if self.commit_response is not None:
                    return self.commit_response
                return {
                    "code": 0,
                    "rspdata": {
                        "initData": {
                            "commandLv": 1,
                            "commandExp": 150,
                            "armyGroupTaskData": {
                                "index": 2,
                                "type": TASK_TYPE_REBEL_GROUP,
                                "statue": TASK_STATUE_BEGIN,
                                "rabelHp": 120000,
                                "hurtHp": 0,
                            },
                            "commonTaskData": [
                                {"index": 10, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN},
                            ]
                        }
                    }
                }
            elif sub_s == REQ_COMMAND_HALL_INIT:
                return {"code": 0, "rspdata": {"initData": {"commandLv": 1, "taskList": []}}}
            elif sub_s == REQ_COMMAND_HALL_FINISH_TASK:
                return {"code": 0, "status": "ok"}
            elif sub_s == REQ_COMMAND_HALL_UPGRADE_COMMAND_LV:
                return {"code": 0, "newLv": 2}

        elif cmd_s == CMD_KINGDOM_QUEUE_MODULE and sub_s == REQ_ADD_KINGDOM_QUEUE:
            return {"code": 0, "queueId": 54321}

        return {"code": 0}


class TestEmpiricalChallengerHeroSelection(unittest.TestCase):
    """
    Adversarial verification of hero selection logic:
    1. Gathering heroes exclusion (1711, 1717, 1724, 1733)
    2. Quality and level descending sort
    3. State filtering (only state 1 and 5 allowed)
    4. Active queue exclusion
    """

    def test_01_only_gathering_heroes_returns_empty_list(self):
        """When ONLY gathering heroes exist, _select_combat_heroes must return empty list []."""
        # Dictionary format with all 4 gathering heroes at maximum stats
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1711": {"heroID": 1711, "quality": 6, "level": 100, "state": 1},
                    "1717": {"heroID": 1717, "quality": 6, "level": 100, "state": 1},
                    "1724": {"heroID": 1724, "quality": 6, "level": 100, "state": 5},
                    "1733": {"heroID": 1733, "quality": 6, "level": 100, "state": 1},
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Test single hero pick
        selected_1 = task._select_combat_heroes(max_heroes=1)
        self.assertEqual(selected_1, [], "Must return empty list when only gathering heroes exist")

        # Test multi-hero pick
        selected_4 = task._select_combat_heroes(max_heroes=4)
        self.assertEqual(selected_4, [], "Must return empty list even with max_heroes=4")

        # Also test with list format instead of dict format
        conn_list = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": [
                    {"heroID": 1711, "quality": 5, "level": 60, "state": 1},
                    {"heroID": 1717, "quality": 5, "level": 60, "state": 1},
                    {"heroID": 1724, "quality": 5, "level": 60, "state": 1},
                    {"heroID": 1733, "quality": 5, "level": 60, "state": 1},
                ]
            }
        })
        task_list = CommandHallTask(conn_list, config={"enabled": True})
        self.assertEqual(task_list._select_combat_heroes(max_heroes=2), [])

    def test_02_gathering_heroes_excluded_in_mixed_roster(self):
        """Verify gathering heroes are never picked even if they outrank combat heroes."""
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1717": {"heroID": 1717, "quality": 6, "level": 100, "state": 1},  # Gathering (top quality/level)
                    "1711": {"heroID": 1711, "quality": 5, "level": 90, "state": 1},   # Gathering
                    "1703": {"heroID": 1703, "quality": 3, "level": 30, "state": 1},   # Combat (low quality/level)
                    "1704": {"heroID": 1704, "quality": 4, "level": 50, "state": 1},   # Combat (medium quality/level)
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # When max_heroes=1, 1704 must be selected (highest eligible combat hero), NEVER 1717 or 1711
        selected = task._select_combat_heroes(max_heroes=1)
        self.assertEqual(len(selected), 1)
        self.assertEqual(selected[0]["heroID"], 1704)
        self.assertNotIn(selected[0]["heroID"], GATHERING_HERO_IDS)

        # When max_heroes=3, only [1704, 1703] can be returned (gathering heroes ignored)
        selected_3 = task._select_combat_heroes(max_heroes=3)
        self.assertEqual(len(selected_3), 2)
        self.assertEqual([h["heroID"] for h in selected_3], [1704, 1703])
        for h in selected_3:
            self.assertNotIn(h["heroID"], GATHERING_HERO_IDS)

    def test_03_highest_quality_and_level_hero_selected(self):
        """Verify candidate sorting strictly prioritizes (quality DESC, level DESC)."""
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1701": {"heroID": 1701, "quality": 3, "level": 60, "state": 1},
                    "1702": {"heroID": 1702, "quality": 4, "level": 20, "state": 1},
                    "1703": {"heroID": 1703, "quality": 4, "level": 70, "state": 1},
                    "1705": {"heroID": 1705, "quality": 5, "level": 10, "state": 1},
                    "1706": {"heroID": 1706, "quality": 2, "level": 80, "state": 1},
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Expected rank order:
        # 1. 1705 (quality 5, level 10)
        # 2. 1703 (quality 4, level 70)
        # 3. 1702 (quality 4, level 20)
        # 4. 1701 (quality 3, level 60)
        # 5. 1706 (quality 2, level 80)
        selected_all = task._select_combat_heroes(max_heroes=5)
        expected_ids = [1705, 1703, 1702, 1701, 1706]
        self.assertEqual([h["heroID"] for h in selected_all], expected_ids)

        # Top 1 pick
        top_1 = task._select_combat_heroes(max_heroes=1)
        self.assertEqual(len(top_1), 1)
        self.assertEqual(top_1[0]["heroID"], 1705)

    def test_04_heroes_with_invalid_state_ignored(self):
        """Verify heroes with state != 1 and state != 5 are strictly ignored."""
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1701": {"heroID": 1701, "quality": 5, "level": 80, "state": 4},  # State 4: Marching -> IGNORE
                    "1702": {"heroID": 1702, "quality": 5, "level": 75, "state": 2},  # State 2: Wounded/Dead -> IGNORE
                    "1703": {"heroID": 1703, "quality": 5, "level": 70, "state": 3},  # State 3: Training -> IGNORE
                    "1704": {"heroID": 1704, "quality": 5, "level": 65, "state": 0},  # State 0: Invalid -> IGNORE
                    "1705": {"heroID": 1705, "quality": 4, "level": 50, "state": 5},  # State 5: Defending -> VALID
                    "1706": {"heroID": 1706, "quality": 3, "level": 40, "state": 1},  # State 1: Idle/Normal -> VALID
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        selected = task._select_combat_heroes(max_heroes=10)
        # Only 1705 (state 5) and 1706 (state 1) should be eligible
        self.assertEqual(len(selected), 2)
        self.assertEqual(selected[0]["heroID"], 1705)
        self.assertEqual(selected[1]["heroID"], 1706)

    def test_05_heroes_in_queue_ignored(self):
        """Verify heroes currently participating in a queue are strictly ignored."""
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1701": {"heroID": 1701, "quality": 5, "level": 80, "state": 1, "queue": {"id": 1001, "type": 1}},  # In queue dict -> IGNORE
                    "1702": {"heroID": 1702, "quality": 5, "level": 75, "state": 1, "queue": [1002]},                    # In queue list -> IGNORE
                    "1703": {"heroID": 1703, "quality": 4, "level": 50, "state": 1, "queue": None},                      # None queue -> VALID
                    "1704": {"heroID": 1704, "quality": 4, "level": 45, "state": 1, "queue": {}},                        # Empty dict -> VALID
                    "1705": {"heroID": 1705, "quality": 4, "level": 40, "state": 1, "queue": []},                        # Empty list -> VALID
                    "1706": {"heroID": 1706, "quality": 3, "level": 30, "state": 1},                                     # No queue key -> VALID
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        selected = task._select_combat_heroes(max_heroes=10)
        self.assertEqual(len(selected), 4)
        selected_ids = [h["heroID"] for h in selected]
        self.assertNotIn(1701, selected_ids)
        self.assertNotIn(1702, selected_ids)
        self.assertEqual(selected_ids, [1703, 1704, 1705, 1706])

    def test_06_missing_hero_id_key_in_dict_and_string_values(self):
        """Verify heroID extracted from dict key and numeric fields converted safely from strings."""
        conn = EmpiricalMockConnection(init_data={
            "heroSysCtrl": {
                "heroList": {
                    "1708": {"quality": "4", "level": "55", "state": "1"},  # heroID not in inner dict, strings
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        selected = task._select_combat_heroes(max_heroes=1)
        self.assertEqual(len(selected), 1)
        self.assertEqual(selected[0]["heroID"], 1708)


class TestEmpiricalChallengerTroopSelection(unittest.IsolatedAsyncioTestCase):
    """
    Adversarial verification of troop selection and march capacity:
    1. Trap exclusion (801..825)
    2. Capacity capping (50,000 troops vs 12,000 capacity)
    3. Safe base capacity when Drill Grounds is missing (>= 3,000)
    """

    def test_07_traps_only_returns_empty_and_zero_available(self):
        """When totalArmy contains ONLY wall traps (801..825), returns [] and available_troops_count == 0."""
        conn = EmpiricalMockConnection(init_data={
            "armyCtrl": {
                "totalArmy": {
                    "801": "2500",  # Rolling logs
                    "802": "1200",  # Caltrops
                    "810": "3000",  # Wall spikes
                    "820": "450",   # Pitch traps
                    "825": "100",   # Trebuchet trap
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # available_troops_count must strictly be 0
        self.assertEqual(task.available_troops_count, 0, "available_troops_count must ignore wall traps (>= 800)")

        # _select_march_troops must return empty list []
        troops = task._select_march_troops(max_capacity=5000)
        self.assertEqual(troops, [], "_select_march_troops must return empty list when only traps exist")

    def test_08_traps_excluded_in_mixed_army(self):
        """Verify traps are filtered out while real combat units (4xx..7xx) are properly selected."""
        conn = EmpiricalMockConnection(init_data={
            "armyCtrl": {
                "totalArmy": {
                    "801": "10000",  # Trap -> EXCLUDE
                    "825": "5000",   # Trap -> EXCLUDE
                    "401": "1000",   # Infantry T1
                    "504": "2000",   # Archer T4
                    "606": "3000",   # Cavalry T6
                    "708": "4000",   # Chariot T8
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Available combat troops: 1000 + 2000 + 3000 + 4000 = 10,000
        self.assertEqual(task.available_troops_count, 10000)

        # Select all 10,000 troops
        selected = task._select_march_troops(max_capacity=20000)
        total_selected = sum(t["num"] for t in selected)
        self.assertEqual(total_selected, 10000)

        # Ensure no trap IDs are present
        selected_ids = {t["id"] for t in selected}
        self.assertTrue(all(uid < 800 for uid in selected_ids), "No trap IDs allowed in march payload")
        self.assertEqual(selected_ids, {401, 504, 606, 708})

    def test_09_capacity_capping_50k_troops_to_12k_limit(self):
        """When totalArmy contains 50,000 troops and capacity is 12,000, returned troops do NOT exceed 12,000."""
        conn = EmpiricalMockConnection(init_data={
            "cityCtrl": {
                "blist": [
                    {"bid": 121, "level": 7},  # Drill Grounds lv 7 -> 3000 + 6*1500 = 12,000
                ]
            },
            "lordInfoCtrl": {"vip": {"level": 0}},
            "armyCtrl": {
                "totalArmy": {
                    "708": "20000",  # Chariot T8 (20,000)
                    "607": "15000",  # Cavalry T7 (15,000)
                    "506": "15000",  # Archer T6 (15,000)
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Total army available is 50,000
        self.assertEqual(task.available_troops_count, 50000)

        # Calculated capacity should be 12,000
        calc_cap = task._calculate_march_capacity()
        self.assertEqual(calc_cap, 12000)

        # Selection with dynamic capacity
        selected_dyn = task._select_march_troops()
        total_dyn = sum(t["num"] for t in selected_dyn)
        self.assertEqual(total_dyn, 12000, "Troop count must equal march capacity 12,000")
        self.assertLessEqual(total_dyn, 12000, "Troop count must NOT exceed 12,000")

        # Highest tier unit 708 should be prioritized
        self.assertEqual(selected_dyn[0]["id"], 708)
        self.assertEqual(selected_dyn[0]["num"], 12000)

        # Selection with explicit max_capacity=12000
        selected_exp = task._select_march_troops(max_capacity=12000)
        total_exp = sum(t["num"] for t in selected_exp)
        self.assertEqual(total_exp, 12000)
        self.assertLessEqual(total_exp, 12000)

    def test_10_missing_drill_grounds_safe_base_capacity(self):
        """When cityCtrl.blist has NO Drill Grounds, capacity safely defaults to >= 3,000."""
        # Case A: Empty blist
        conn_a = EmpiricalMockConnection(init_data={
            "cityCtrl": {"blist": []},
            "lordInfoCtrl": {"vip": {"level": 0}},
        })
        task_a = CommandHallTask(conn_a, config={"enabled": True})
        self.assertGreaterEqual(task_a._calculate_march_capacity(), 3000)

        # Case B: blist with other buildings (barracks 101, archery 102, stable 103), but no Drill Grounds (121 / 4220)
        conn_b = EmpiricalMockConnection(init_data={
            "cityCtrl": {
                "blist": [
                    {"bid": 101, "level": 15},
                    {"bid": 102, "level": 15},
                    {"bid": 103, "level": 15},
                    {"bid": 104, "level": 15},
                ]
            },
            "lordInfoCtrl": {"vip": {"level": 0}},
        })
        task_b = CommandHallTask(conn_b, config={"enabled": True})
        self.assertEqual(task_b._calculate_march_capacity(), 3000)

        # Case C: cityCtrl missing entirely
        conn_c = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"vip": {"level": 0}},
        })
        task_c = CommandHallTask(conn_c, config={"enabled": True})
        self.assertGreaterEqual(task_c._calculate_march_capacity(), 3000)

    async def test_11_march_blocked_when_only_traps_exist(self):
        """Verify march handler detects lack of real troops when only traps exist and blocks cleanly."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},  # Available marches = 2
            "armyCtrl": {"totalArmy": {"801": "5000", "802": "2000"}},  # Only traps!
            "commandHall": {
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN, "x": 100, "y": 200},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 0, "No march should be dispatched when only traps exist")
        self.assertTrue(blocked, "blocked_on_march must be True when real troops == 0")


class TestEmpiricalChallengerRebelGroupType1(unittest.IsolatedAsyncioTestCase):
    """
    Adversarial verification of Type 1 Rebel Army Group attack & commit:
    1. Attack via CMD 2274 / SubCMD 7 when statue == 2 and rabelHp > hurtHp
    2. Commit via CMD 2274 / SubCMD 8 when hurtHp >= rabelHp
    3. Commit via CMD 2274 / SubCMD 8 when statue == 3
    4. Attack followed by automatic reward commit on group defeat
    5. In-memory task list refreshing
    """

    async def test_12_attack_when_statue_2_and_rabel_hp_greater_than_hurt_hp(self):
        """Verify attack occurs via CMD 2274 / SubCMD 7 when statue == 2 and rabelHp > hurtHp."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 80}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "heroSysCtrl": {"heroList": {"1707": {"heroID": 1707, "quality": 4, "level": 50, "state": 1}}},
            "commandHall": {
                "commandLv": 1,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_BEGIN,  # statue == 2
                    "rabelHp": 100000,
                    "hurtHp": 40000,              # rabelHp > hurtHp
                }
            }
        })
        # Server response simulates attack dealing damage but not yet defeating
        conn.attack_response = {
            "code": 0,
            "rspdata": {
                "initData": {
                    "armyGroupTaskData": {
                        "index": 1,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_BEGIN,
                        "rabelHp": 100000,
                        "hurtHp": 70000,
                    }
                }
            }
        }
        task = CommandHallTask(conn, config={"enabled": True})

        result = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(result)

        # Verify exact attack query sent
        attack_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP
        ]
        self.assertEqual(len(attack_queries), 1, "Exactly one attack query should be sent")
        payload = attack_queries[0]["data"]
        self.assertIn("armyInfo", payload)
        self.assertIn("heroInfo", payload)
        self.assertEqual(payload["heroInfo"][0]["heroID"], 1707)
        self.assertGreater(sum(t["num"] for t in payload["armyInfo"]), 0)

        # Verify NO commit query sent because hurtHp (70,000) < rabelHp (100,000)
        commit_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK
        ]
        self.assertEqual(len(commit_queries), 0, "No commit query should be sent before defeat")

        # Verify stamina remains untouched (cost is 0 stamina)
        self.assertEqual(task.current_stamina, 80, "Type 1 attack must cost 0 stamina")

    async def test_13_commit_directly_when_hurt_hp_gte_rabel_hp(self):
        """Verify commit occurs via CMD 2274 / SubCMD 8 directly when hurtHp >= rabelHp without attacking."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 80}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_BEGIN,  # statue == 2
                    "rabelHp": 100000,
                    "hurtHp": 100000,             # hurtHp >= rabelHp (already defeated!)
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        result = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(result)

        # Verify NO attack query sent
        attack_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP
        ]
        self.assertEqual(len(attack_queries), 0, "Should NOT attack when hurtHp >= rabelHp")

        # Verify commit query sent with commitType = 1
        commit_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK
        ]
        self.assertEqual(len(commit_queries), 1, "Must commit reward via SubCMD 8")
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_REBEL_GROUP)
        self.assertEqual(commit_queries[0]["data"]["index"], 1)

    async def test_14_commit_directly_when_statue_3_finish(self):
        """Verify commit occurs via CMD 2274 / SubCMD 8 when statue == 3 (TASK_STATUE_FINISH)."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 80}},
            "commandHall": {
                "commandLv": 1,
                "armyGroupTaskData": {
                    "index": 3,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_FINISH,  # statue == 3
                    "rabelHp": 100000,
                    "hurtHp": 0,
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        result = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(result)

        commit_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK
        ]
        self.assertEqual(len(commit_queries), 1)
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_REBEL_GROUP)
        self.assertEqual(commit_queries[0]["data"]["index"], 3)

    async def test_15_attack_defeats_group_and_chains_immediate_commit(self):
        """Verify that when attack reduces HP to 0, it immediately executes commit via SubCMD 8 and updates task list."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 80}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "heroSysCtrl": {"heroList": {"1707": {"heroID": 1707, "quality": 4, "level": 50, "state": 1}}},
            "commandHall": {
                "commandLv": 1,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": TASK_TYPE_REBEL_GROUP,
                    "statue": TASK_STATUE_BEGIN,
                    "rabelHp": 100000,
                    "hurtHp": 20000,
                }
            }
        })
        # Server response indicates the attack dealt final damage, defeating the group
        conn.attack_response = {
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
        # Commit response refreshes task list with wave 2 and common tasks
        conn.commit_response = {
            "code": 0,
            "rspdata": {
                "initData": {
                    "commandLv": 1,
                    "armyGroupTaskData": {
                        "index": 2,
                        "type": TASK_TYPE_REBEL_GROUP,
                        "statue": TASK_STATUE_BEGIN,
                        "rabelHp": 120000,
                        "hurtHp": 0,
                    },
                    "commonTaskData": [
                        {"index": 20, "type": TASK_TYPE_DIALOGUE, "statue": TASK_STATUE_BEGIN},
                    ]
                }
            }
        }
        task = CommandHallTask(conn, config={"enabled": True})

        result = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(result)

        # Verify BOTH queries executed in sequence: SubCMD 7 (attack) followed by SubCMD 8 (commit)
        cmd_hall_queries = [q for q in conn.sent_queries if q["cmd"] == CMD_COMMAND_HALL_MODULE]
        subcmds = [q["subcmd"] for q in cmd_hall_queries]
        self.assertEqual(subcmds, [REQ_COMMAND_HALL_ATTACK_ARMY_GROUP, REQ_COMMAND_HALL_COMMIT_TASK])

        # Verify memory refreshed with new wave 2 and commonTaskData
        updated_hall = conn.init_data["commandHall"]
        self.assertEqual(updated_hall["armyGroupTaskData"]["index"], 2)
        self.assertEqual(updated_hall["armyGroupTaskData"]["rabelHp"], 120000)
        self.assertEqual(len(updated_hall["commonTaskData"]), 1)
        self.assertEqual(updated_hall["commonTaskData"][0]["index"], 20)

    async def test_16_rebel_group_located_in_taskList_fallback(self):
        """Verify Type 1 Rebel Group is discovered and handled even if placed in taskList instead of armyGroupTaskData."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 80}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "taskList": [
                    {"index": 5, "type": TASK_TYPE_REBEL_GROUP, "statue": TASK_STATUE_FINISH, "rabelHp": 50000, "hurtHp": 50000},
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})

        result = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(result)

        commit_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK
        ]
        self.assertEqual(len(commit_queries), 1)
        self.assertEqual(commit_queries[0]["data"]["commitType"], TASK_TYPE_REBEL_GROUP)
        self.assertEqual(commit_queries[0]["data"]["index"], 5)


class TestEmpiricalChallengerStringResilienceAndEdgeCases(unittest.IsolatedAsyncioTestCase):
    """
    Adversarial verification of string typing resilience, resource deduction,
    gold/speedup traps, and malformed task handling.
    """

    async def test_17_string_typing_resilience_in_rebel_group_hp(self):
        """Verify Rebel Group attack handles string numbers ('100000', '40000', '2') gracefully."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": "100"}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "heroSysCtrl": {"heroList": {"1707": {"heroID": "1707", "quality": "4", "level": "50", "state": "1"}}},
            "commandHall": {
                "commandLv": "1",
                "armyGroupTaskData": {
                    "index": "1",
                    "type": "1",
                    "statue": "2",
                    "rabelHp": "100000",
                    "hurtHp": "40000",
                }
            }
        })
        conn.attack_response = {
            "code": 0,
            "rspdata": {
                "initData": {
                    "armyGroupTaskData": {
                        "index": "1",
                        "type": "1",
                        "statue": "2",
                        "rabelHp": "100000",
                        "hurtHp": "80000",
                    }
                }
            }
        }
        task = CommandHallTask(conn, config={"enabled": True})
        res = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(res)
        attack_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_ATTACK_ARMY_GROUP
        ]
        self.assertEqual(len(attack_queries), 1)

    async def test_18_rebel_hp_field_name_variants(self):
        """Verify tolerance for field name variants ('rebelHp' / 'damageHp')."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "commandLv": 1,
                "armyGroupTaskData": {
                    "index": 1,
                    "type": 1,
                    "statue": 2,
                    "rebelHp": 80000,
                    "damageHp": 80000,  # Already defeated via alternate field names!
                }
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        res = await task._handle_rebel_group_attack(conn.init_data["commandHall"])
        self.assertTrue(res)

        commit_queries = [
            q for q in conn.sent_queries
            if q["cmd"] == CMD_COMMAND_HALL_MODULE and q["subcmd"] == REQ_COMMAND_HALL_COMMIT_TASK
        ]
        self.assertEqual(len(commit_queries), 1, "Should commit directly when alternate damageHp >= rebelHp")

    def test_19_in_memory_resource_deduction(self):
        """Verify _deduct_march_resources_in_memory accurately updates memory structures."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 50}},
            "armyCtrl": {"totalArmy": {"501": "5000", "606": "2000"}},
            "queueCtrl": {"queues": [], "1221": {"count": 1}},
        })
        task = CommandHallTask(conn, config={"enabled": True})

        # Deduct 1500 units of 501 and 500 units of 606 with 5 stamina cost
        troops_to_deduct = [{"id": 501, "num": 1500}, {"id": 606, "num": 500}]
        task._deduct_march_resources_in_memory(troops_to_deduct, stamina_cost=5)

        # Check stamina: 50 - 5 = 45
        self.assertEqual(conn.init_data["lordInfoCtrl"]["base"]["health"], 45)

        # Check troops: 501 -> 3500, 606 -> 1500
        self.assertEqual(conn.init_data["armyCtrl"]["totalArmy"]["501"], 3500)
        self.assertEqual(conn.init_data["armyCtrl"]["totalArmy"]["606"], 1500)

        # Check queue added
        self.assertEqual(len(conn.init_data["queueCtrl"]["queues"]), 1)
        self.assertEqual(conn.init_data["queueCtrl"]["1221"]["count"], 2)

    def test_20_in_memory_stamina_deduction_bounds(self):
        """Verify _deduct_stamina_in_memory handles deductions and zero lower bounds."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 8}},
        })
        task = CommandHallTask(conn, config={"enabled": True})

        task._deduct_stamina_in_memory(5)
        self.assertEqual(conn.init_data["lordInfoCtrl"]["base"]["health"], 3)

        # Deduct more than remaining stamina -> clamped at 0
        task._deduct_stamina_in_memory(10)
        self.assertEqual(conn.init_data["lordInfoCtrl"]["base"]["health"], 0)

    def test_21_costly_task_filters_speedup_gold_items(self):
        """Stress-test _is_costly_task against adversarial variations of gold/speedup/item payloads."""
        # Costly cases
        self.assertTrue(CommandHallTask._is_costly_task({"consumeGold": 1}))
        self.assertTrue(CommandHallTask._is_costly_task({"consumeGold": "50"}))
        self.assertTrue(CommandHallTask._is_costly_task({"gold": 10}))
        self.assertTrue(CommandHallTask._is_costly_task({"consumeSpeedup": True}))
        self.assertTrue(CommandHallTask._is_costly_task({"speedup": 1}))
        self.assertTrue(CommandHallTask._is_costly_task({"item": "item_speedup_1h"}))
        self.assertTrue(CommandHallTask._is_costly_task({"item": "gold_chest"}))
        self.assertTrue(CommandHallTask._is_costly_task({"consumeItems": ["item1"]}))
        self.assertTrue(CommandHallTask._is_costly_task({"consumeItem": {"id": 101}}))
        self.assertTrue(CommandHallTask._is_costly_task({"consumeItem": 1}))

        # Free / Safe cases
        self.assertFalse(CommandHallTask._is_costly_task({"consume": 5}))
        self.assertFalse(CommandHallTask._is_costly_task({"consumeGold": 0, "gold": 0}))
        self.assertFalse(CommandHallTask._is_costly_task({"consumeSpeedup": False, "speedup": 0}))
        self.assertFalse(CommandHallTask._is_costly_task({"item": "", "items": []}))
        self.assertFalse(CommandHallTask._is_costly_task({}))
        self.assertFalse(CommandHallTask._is_costly_task(None))

    async def test_22_march_tasks_graceful_handling_missing_coordinates(self):
        """Verify march handler gracefully skips tasks with missing coordinates without throwing."""
        conn = EmpiricalMockConnection(init_data={
            "lordInfoCtrl": {"base": {"health": 100}},
            "queueCtrl": {"queues": []},
            "armyCtrl": {"totalArmy": {"501": "5000"}},
            "commandHall": {
                "taskList": [
                    {"index": 1, "type": TASK_TYPE_REBEL_PIONEER, "statue": TASK_STATUE_BEGIN},  # Missing x, y
                ]
            }
        })
        task = CommandHallTask(conn, config={"enabled": True})
        dispatched, blocked = await task._handle_march_tasks(conn.init_data["commandHall"])
        self.assertEqual(dispatched, 0)
        self.assertFalse(blocked)


if __name__ == "__main__":
    unittest.main()

