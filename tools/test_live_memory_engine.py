# -*- coding: utf-8 -*-
r"""
tools/test_live_memory_engine.py — Comprehensive Test Suite for LiveMemoryEngine and BaseTask Marches
══════════════════════════════════════════════════════════════════════════════════════════════════════
Author: Verifier Agent (Verification & Test Engineering)
Workspace: e:\intqam-sultan

Covers:
  1. LiveMemoryEngine Unit Tests:
     - Whitelist enforcement (non-whitelisted stripped, whitelisted 58 preserved).
     - Smart deep merge & Keyed list merging (blist, heroes, buffs, queues) without wipes/duplication.
     - Queue synchronizer: NOTIFY_LOCAL_QUEUE_SYNC (cmd 202; msgType 1 ADD, 2 REMOVE, 3 UPDATE, 4 ADD_ALL, 5 REMOVE_ALL).
     - Separation of own vs other players' marches (get_own_local_queues, get_other_local_queues, breakdown, init_data mirrors).
     - Army synchronizer: NOTIFY_ARMY (cmd 15) updating totalArmy, woundedArmy, trainArmy, freeArmy.
     - Memory readiness gate: is_memory_ready() validation with missing vs complete startup controllers.
     - Concurrency test: 4 writer threads pushing 1000 packets simultaneously under RLock without deadlocks or corruption.
  2. BaseTask Marches Integration Tests:
     - _read_live_local_queues and _read_live_other_queues across all fallback tiers.
     - get_active_marches_count with owner UID filtering and active status validation.
     - get_other_marches_count for foreign player march monitoring.
     - get_max_marches_capacity calculation (Base 1 + Techs 24011/24017/24033 + VIP 4..9/10..18, capped at 6).
     - get_available_marches_count and available_marches property.
     - get_active_gather_resource_types detecting resource types 1..5.
     - is_ruins_march_active detecting moveLineType 4 or mapType 7.
"""

from __future__ import annotations

import copy
import os
import sys
import threading
import time
import unittest
from typing import Any, Dict, List, Optional, Set

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from core.live_memory import (
    LiveMemoryEngine,
    ALLOWED_CONTROLLERS,
    CRITICAL_STARTUP_CONTROLLERS,
    smart_deep_merge,
    is_own_march_queue,
    resolve_queue_owner_uid,
)
from tasks.base_task import BaseTask, TaskResult


class MockConnection:
    """Mock connection emulating GateClient with LiveMemoryEngine integration."""

    def __init__(self, init_data: Optional[Dict[str, Any]] = None, owner_uid: str = "10001"):
        self.owner_uid = owner_uid
        self.init_data = init_data if init_data is not None else {}
        self.memory_engine = LiveMemoryEngine(init_data=self.init_data, owner_uid=self.owner_uid)
        self.local_queues: List[Any] = self.memory_engine.get_own_local_queues()
        self.other_local_queues: List[Any] = self.memory_engine.get_other_local_queues()
        self.queries_log: List[Dict[str, Any]] = []

    async def safe_query(self, cmd: int, subcmd: int, data: Optional[Dict[str, Any]] = None, timeout: float = 10.0) -> Dict[str, Any]:
        self.queries_log.append({"cmd": cmd, "subcmd": subcmd, "data": data or {}})
        return {"retcode": 0, "cmd": cmd, "subcmd": subcmd, "data": {}}

    def sync_queues_to_conn(self) -> None:
        """Helper to sync conn properties from memory engine."""
        self.local_queues = self.memory_engine.get_own_local_queues()
        self.other_local_queues = self.memory_engine.get_other_local_queues()


class DummyConcreteTask(BaseTask):
    """Concrete subclass of BaseTask to test BaseTask methods directly."""

    def __init__(self, conn: Any, config: Optional[Dict[str, Any]] = None, uid: str = "10001"):
        super().__init__(conn, config=config)
        self.name = "dummy_test_task"
        self._custom_uid = uid

    @property
    def uid(self) -> str:
        if hasattr(self, "_custom_uid") and self._custom_uid:
            return self._custom_uid
        return super().uid

    async def run(self) -> TaskResult:
        return TaskResult.ok("dummy executed")


# ══════════════════════════════════════════════════════════════════════════════
# Section 1: LiveMemoryEngine Unit Tests
# ══════════════════════════════════════════════════════════════════════════════

class TestLiveMemoryEngineUnit(unittest.TestCase):
    """Unit tests verifying all requirements of LiveMemoryEngine."""

    def setUp(self):
        self.owner_uid = "10001"
        self.engine = LiveMemoryEngine(owner_uid=self.owner_uid)

    def test_01_whitelist_enforcement(self):
        """Verify non-whitelisted controllers are dropped and whitelisted 58 preserved."""
        # 1. Verify key controllers in ALLOWED_CONTROLLERS
        expected_controllers = [
            "cityCtrl", "lordInfoCtrl", "queueCtrl", "armyCtrl", "heroCtrl", "heroSysCtrl",
            "backpackCtrl", "allianceCtrl", "technologyCtrl", "vipCtrl", "meritoriousTaskCtrl",
            "timeRewardCtrl", "lordSkillCtrl", "boeAttributeCtrl", "buffCtrl", "newBuffCtrl",
            "petCtrl", "kingdomMapCtrl", "buyStaminaCtrl", "wallsCtrl", "taskCtrl", "questCtrl",
            "everydayTaskCtrl", "commandHall", "commandHallCtrl", "armyGroupTaskData",
            "tomorrowArmyGroupTaskData", "storesCtrl", "treviFountainCtrl", "salesRoomAgCtrl",
            "pyramidCtrl", "heroVoyageAgCtrl", "heroEnlistCtrl", "heroTacticalHallAgCtrl",
            "heroTacticalHallCtrl", "heroEquipAgCtrl", "runeForgeAgCtrl", "allianceTreasureCtrl",
            "cumulateRewardData", "fieldShopCtrl", "PveBattleCtrl", "badgeExchangeCtrl",
            "savingsBankAgCtrl", "troyTreasureAgCtrl", "exchangeStoreAgCtrl", "generalAtyMgr",
            "activityShowCtrl", "godBeastCtrl", "equipmentCtrl", "playerCtrl", "itemShop",
            "shopItemBuyTimesMgr", "loginRewardCtrl", "lord", "army", "queue", "bagCtrl",
            "itemCtrl", "loginDataInitCtrl", "item_sign", "local_queues", "other_local_queues",
            "everydayTask"
        ]
        for ctrl in expected_controllers:
            self.assertIn(ctrl, ALLOWED_CONTROLLERS, f"Expected controller '{ctrl}' not in ALLOWED_CONTROLLERS")

        # 2. Test packet filtering
        incoming_packet = {
            "cmd": 1000,
            "data": {
                # Whitelisted controllers
                "cityCtrl": {"blist": [{"index": 1, "bid": 101, "lv": 10}]},
                "lordInfoCtrl": {"base": {"uid": "10001", "name": "Sultan1"}},
                "technologyCtrl": {"24011": 1},
                "commandHall": {"lv": 2},
                # Junk non-whitelisted controllers that MUST be stripped
                "chatCtrl": {"messages": ["hello", "world"]},
                "redPointCtrl": {"unread": 99},
                "adDataCtrl": {"ads": [1, 2, 3]},
                "worldRankSpam": {"rank": 1},
                "randomTelemetry": {"foo": "bar"},
            }
        }

        filtered = self.engine.extract_controllers(incoming_packet)
        self.assertIn("cityCtrl", filtered)
        self.assertIn("lordInfoCtrl", filtered)
        self.assertIn("technologyCtrl", filtered)
        self.assertIn("commandHall", filtered)

        self.assertNotIn("chatCtrl", filtered)
        self.assertNotIn("redPointCtrl", filtered)
        self.assertNotIn("adDataCtrl", filtered)
        self.assertNotIn("worldRankSpam", filtered)
        self.assertNotIn("randomTelemetry", filtered)

        # Ingest and check init_data
        self.engine.ingest_packet(incoming_packet)
        self.assertIn("cityCtrl", self.engine.init_data)
        self.assertNotIn("chatCtrl", self.engine.init_data)
        self.assertNotIn("redPointCtrl", self.engine.init_data)

    def test_02_smart_deep_merge_and_keyed_lists(self):
        """Verify Smart deep merge & Keyed list merging preserving object identities and avoiding duplicates."""
        # 1. City blist merge by index
        initial_packet = {
            "cmd": 1001,
            "data": {
                "cityCtrl": {
                    "blist": [
                        {"index": 1, "bid": 101, "lv": 5, "state": "0"},
                        {"index": 2, "bid": 102, "lv": 3, "state": "0"},
                    ],
                    "reslist": {"1002": 50000, "1003": 40000},
                }
            }
        }
        self.engine.ingest_packet(initial_packet)
        self.assertEqual(len(self.engine.init_data["cityCtrl"]["blist"]), 2)

        # Update building 1 (lv 5 -> 6), leave building 2 intact, add building 3
        update_packet = {
            "cmd": 1001,
            "data": {
                "cityCtrl": {
                    "blist": [
                        {"index": 1, "lv": 6},
                        {"index": 3, "bid": 103, "lv": 1, "state": "0"},
                    ],
                    "reslist": {"1002": 55000},
                }
            }
        }
        self.engine.ingest_packet(update_packet)
        blist = self.engine.init_data["cityCtrl"]["blist"]
        self.assertEqual(len(blist), 3, "Expected 3 buildings after update (no duplicate index 1)")

        b1 = next(b for b in blist if b["index"] == 1)
        self.assertEqual(b1["lv"], 6)
        self.assertEqual(b1["bid"], 101, "Original fields (bid) must be preserved in keyed merge")

        b2 = next(b for b in blist if b["index"] == 2)
        self.assertEqual(b2["lv"], 3)

        b3 = next(b for b in blist if b["index"] == 3)
        self.assertEqual(b3["bid"], 103)

        # Check reslist deep merge
        reslist = self.engine.init_data["cityCtrl"]["reslist"]
        self.assertEqual(reslist["1002"], 55000)
        self.assertEqual(reslist["1003"], 40000, "Non-updated keys in reslist must be preserved")

        # 2. Heroes list keyed merge by id / heroId / cId
        hero_initial = {
            "cmd": 1004,
            "data": {
                "heroCtrl": {
                    "heroes": [
                        {"id": 101, "lv": 20, "star": 2, "name": "Saladin"},
                        {"id": 102, "lv": 15, "star": 1, "name": "Baybars"},
                    ]
                }
            }
        }
        self.engine.ingest_packet(hero_initial)
        heroes = self.engine.init_data["heroCtrl"]["heroes"]
        self.assertEqual(len(heroes), 2)

        hero_update = {
            "cmd": 1004,
            "data": {
                "heroCtrl": {
                    "heroes": [
                        {"id": 101, "lv": 25},  # Update Saladin level
                        {"id": 103, "lv": 1, "star": 1, "name": "Harun"},  # New hero
                    ]
                }
            }
        }
        self.engine.ingest_packet(hero_update)
        heroes = self.engine.init_data["heroCtrl"]["heroes"]
        self.assertEqual(len(heroes), 3, "Expected 3 heroes (Saladin updated, Harun added, Baybars intact)")
        h101 = next(h for h in heroes if h["id"] == 101)
        self.assertEqual(h101["lv"], 25)
        self.assertEqual(h101["name"], "Saladin")
        self.assertEqual(h101["star"], 2)

    def test_03_queue_synchronizer_notify_local_queue_sync(self):
        """Verify Queue synchronizer: NOTIFY_LOCAL_QUEUE_SYNC (msgType 1 ADD, 2 REMOVE, 3 UPDATE, 4 ADD_ALL, 5 REMOVE_ALL)."""
        # 1. msgType 1 (ADD): Add a march queue
        add_packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 1,
                "data": {"id": "10001-1", "uid": "10001", "status": 1, "target": {"x": 500, "y": 600}},
            }
        }
        self.engine.ingest_packet(add_packet)
        self.assertIn("10001-1", self.engine.local_queues_map)
        self.assertEqual(self.engine.local_queues_map["10001-1"]["status"], 1)
        self.assertEqual(len(self.engine.get_own_local_queues()), 1)
        self.assertEqual(len(self.engine.init_data["local_queues"]), 1)

        # 2. msgType 3 (UPDATE): Update march queue status
        update_packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 3,
                "data": {"id": "10001-1", "status": 2, "endTime": 1700000000},
            }
        }
        self.engine.ingest_packet(update_packet)
        q = self.engine.local_queues_map["10001-1"]
        self.assertEqual(q["status"], 2)
        self.assertEqual(q["endTime"], 1700000000)
        self.assertEqual(q["uid"], "10001", "Original queue fields must be preserved on update")

        # 3. Add second queue
        add_packet2 = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 1,
                "data": {"id": "10001-2", "uid": "10001", "status": 1},
            }
        }
        self.engine.ingest_packet(add_packet2)
        self.assertEqual(len(self.engine.local_queues_map), 2)

        # 4. msgType 2 (REMOVE): Remove queue 1
        remove_packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 2,
                "data": {"id": "10001-1"},
            }
        }
        self.engine.ingest_packet(remove_packet)
        self.assertNotIn("10001-1", self.engine.local_queues_map)
        self.assertIn("10001-2", self.engine.local_queues_map)
        self.assertEqual(len(self.engine.get_own_local_queues()), 1)

        # 5. msgType 4 (ADD_ALL): Full replacement
        add_all_packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 4,
                "data": [
                    {"id": "10001-10", "uid": "10001", "status": 1},
                    {"id": "10001-11", "uid": "10001", "status": 3},
                    {"id": "10001-12", "uid": "10001", "status": 4},
                ]
            }
        }
        self.engine.ingest_packet(add_all_packet)
        self.assertEqual(len(self.engine.local_queues_map), 3)
        self.assertIn("10001-10", self.engine.local_queues_map)
        self.assertNotIn("10001-2", self.engine.local_queues_map, "ADD_ALL must replace previous queues")

        # 6. msgType 5 (REMOVE_ALL): Clear all
        remove_all_packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {"msgType": 5}
        }
        self.engine.ingest_packet(remove_all_packet)
        self.assertEqual(len(self.engine.local_queues_map), 0)
        self.assertEqual(len(self.engine.get_own_local_queues()), 0)
        self.assertEqual(len(self.engine.init_data["local_queues"]), 0)

    def test_04_separation_of_own_vs_other_marches(self):
        """Verify that get_own_local_queues() only returns own UID marches, and other marches go to other_local_queues."""
        self.engine.owner_uid = "10001"

        # Ingest a mixture of own castle marches and foreign player marches
        packet = {
            "cmd": 1009,
            "notifyID": 202,
            "notifyData": {
                "msgType": 4,
                "data": [
                    # Own marches (matching owner_uid "10001")
                    {"id": "10001-1", "uid": "10001", "status": 1, "armyCount": 50000},
                    {"id": "10001-2", "uid": "10001", "status": 2, "armyCount": 30000},
                    # Foreign player marches (different owner UIDs)
                    {"id": "20002-1", "uid": "20002", "status": 1, "armyCount": 100000},
                    {"id": "30003-1", "from": {"uid": "30003"}, "status": 2, "armyCount": 80000},
                    {"id": "40004-1", "playerID": "40004", "status": 1, "armyCount": 60000},
                ]
            }
        }
        self.engine.ingest_packet(packet)

        # 1. Total queues in map
        self.assertEqual(len(self.engine.local_queues_map), 5)

        # 2. Own queues
        own_queues = self.engine.get_own_local_queues()
        self.assertEqual(len(own_queues), 2, "get_own_local_queues() must strictly return own castle marches")
        own_ids = {q["id"] for q in own_queues}
        self.assertEqual(own_ids, {"10001-1", "10001-2"})

        # 3. Other players' queues
        other_queues = self.engine.get_other_local_queues()
        self.assertEqual(len(other_queues), 3, "get_other_local_queues() must capture all foreign player marches")
        other_ids = {q["id"] for q in other_queues}
        self.assertEqual(other_ids, {"20002-1", "30003-1", "40004-1"})

        # 4. init_data mirroring (CRITICAL requirement)
        self.assertEqual(len(self.engine.init_data.get("local_queues", [])), 2)
        self.assertEqual(len(self.engine.init_data.get("other_local_queues", [])), 3)

        # 5. Breakdown tuple
        own_b, other_b = self.engine.get_local_queues_breakdown()
        self.assertEqual(len(own_b), 2)
        self.assertEqual(len(other_b), 3)

    def test_05_army_synchronizer_notify_army(self):
        """Verify NOTIFY_ARMY properly updating totalArmy, woundedArmy, trainArmy, freeArmy under armyCtrl cleanly."""
        # Initial state
        self.engine.init_data["armyCtrl"] = {
            "totalArmy": {"1": 10000, "2": 5000},
            "woundedArmy": {"1": 0},
            "trainArmy": {},
            "freeArmy": {"1": 10000, "2": 5000},
        }

        # NOTIFY_ARMY packet with nested armyInfo
        army_packet = {
            "cmd": 1009,
            "notifyID": 15,
            "notifyData": {
                "armyInfo": {
                    "totalArmy": {"1": 10000, "2": 5000, "3": 2000},
                    "woundedArmy": {"1": 500},
                    "trainArmy": {"3": 500},
                    "freeArmy": {"1": 9500, "2": 5000, "3": 1500},
                }
            }
        }
        self.engine.ingest_packet(army_packet)

        army_ctrl = self.engine.init_data["armyCtrl"]
        self.assertEqual(army_ctrl["totalArmy"]["3"], 2000)
        self.assertEqual(army_ctrl["woundedArmy"]["1"], 500)
        self.assertEqual(army_ctrl["trainArmy"]["3"], 500)
        self.assertEqual(army_ctrl["freeArmy"]["1"], 9500)

        # Direct army update packet without nested armyInfo
        direct_packet = {
            "cmd": 1009,
            "notifyID": "NOTIFY_ARMY",
            "notifyData": {
                "totalArmy": {"1": 12000, "2": 5000, "3": 2000},
                "woundedArmy": {"1": 0},
            }
        }
        self.engine.ingest_packet(direct_packet)
        self.assertEqual(self.engine.init_data["armyCtrl"]["totalArmy"]["1"], 12000)
        self.assertEqual(self.engine.init_data["armyCtrl"]["woundedArmy"]["1"], 0)

    def test_06_memory_readiness_gate(self):
        """Verify is_memory_ready() behavior with missing vs complete startup controllers."""
        # 1. Fresh empty engine: NOT ready
        ready, missing = self.engine.is_memory_ready()
        self.assertFalse(ready)
        self.assertTrue(len(missing) > 0)
        self.assertIn("cityCtrl", missing)
        self.assertIn("lordInfoCtrl", missing)
        self.assertIn("queueCtrl", missing)
        self.assertIn("armyCtrl", missing)
        self.assertIn("heroCtrl", missing)
        self.assertIn("backpackCtrl", missing)

        # 2. Add partial invalid cityCtrl (missing blist)
        self.engine.init_data["cityCtrl"] = {"blist": []}
        ready, missing = self.engine.is_memory_ready()
        self.assertFalse(ready)
        self.assertIn("cityCtrl.blist", missing)

        # 3. Populate all 6 critical controllers with valid data
        self.engine.init_data = {
            "cityCtrl": {
                "blist": [{"index": 1, "bid": 101, "lv": 10}],
                "reslist": {"1002": 100000},
            },
            "lordInfoCtrl": {
                "base": {"uid": "10001", "name": "KingSultan"},
            },
            "queueCtrl": {
                "queues": [{"qtype": 1, "id": "1"}],
            },
            "armyCtrl": {
                "totalArmy": {"1": 10000},
            },
            "heroCtrl": {
                "heroes": [{"id": 101, "lv": 10}],
            },
            "backpackCtrl": {
                "items": [{"id": 1001, "count": 5}],
            },
        }

        ready, missing = self.engine.is_memory_ready()
        self.assertTrue(ready, f"Memory should be ready, but missing: {missing}")
        self.assertEqual(len(missing), 0)

    def test_07_concurrency_stress_test(self):
        """Verify 4 writer threads pushing 1000 packets simultaneously under RLock without race conditions or deadlocks."""
        errors: List[Exception] = []
        packets_per_thread = 250
        num_threads = 4

        def worker(thread_id: int):
            try:
                for i in range(packets_per_thread):
                    qid = f"q-{thread_id}-{i}"
                    # Alternating packets: queue sync, army sync, controller deep merge
                    op = i % 4
                    if op == 0:  # ADD queue
                        pkt = {
                            "cmd": 1009,
                            "notifyID": 202,
                            "notifyData": {
                                "msgType": 1,
                                "data": {"id": qid, "uid": self.owner_uid, "status": 1, "val": i},
                            }
                        }
                    elif op == 1:  # UPDATE queue
                        pkt = {
                            "cmd": 1009,
                            "notifyID": 202,
                            "notifyData": {
                                "msgType": 3,
                                "data": {"id": qid, "status": 2, "updated_val": i * 10},
                            }
                        }
                    elif op == 2:  # Army update
                        pkt = {
                            "cmd": 1009,
                            "notifyID": 15,
                            "notifyData": {
                                "totalArmy": {str(thread_id): i * 100},
                            }
                        }
                    else:  # Controller deep merge
                        pkt = {
                            "cmd": 1001,
                            "data": {
                                "cityCtrl": {
                                    "reslist": {str(1000 + thread_id): i * 50},
                                }
                            }
                        }
                    self.engine.ingest_packet(pkt)
                    # Snapshot access under load
                    if i % 50 == 0:
                        _ = self.engine.get_own_local_queues()
                        _ = self.engine.get_other_local_queues()
                        _ = self.engine.get_snapshot("cityCtrl")
            except Exception as e:
                errors.append(e)

        threads = [threading.Thread(target=worker, args=(t,)) for t in range(num_threads)]
        for t in threads:
            t.start()
        for t in threads:
            t.join(timeout=15.0)

        self.assertEqual(len(errors), 0, f"Concurrency test produced errors: {errors}")
        self.assertTrue(len(self.engine.local_queues_map) > 0, "Queues map should contain processed entries")


# ══════════════════════════════════════════════════════════════════════════════
# Section 2: BaseTask Marches Integration Tests
# ══════════════════════════════════════════════════════════════════════════════

class TestBaseTaskMarchIntegration(unittest.TestCase):
    """Integration tests verifying march helper methods on BaseTask."""

    def setUp(self):
        self.uid = "10001"
        self.conn = MockConnection(owner_uid=self.uid)
        self.task = DummyConcreteTask(self.conn, config={"enabled": True}, uid=self.uid)

    def test_01_read_live_local_queues_and_other_queues(self):
        """Verify _read_live_local_queues and _read_live_other_queues across all fallback tiers."""
        # Tier 1: Reading from conn.local_queues and conn.other_local_queues
        self.conn.local_queues = [{"id": "10001-1", "uid": "10001"}]
        self.conn.other_local_queues = [{"id": "99999-1", "uid": "99999"}]

        own = self.task._read_live_local_queues(self.conn)
        other = self.task._read_live_other_queues(self.conn)
        self.assertEqual(len(own), 1)
        self.assertEqual(own[0]["id"], "10001-1")
        self.assertEqual(len(other), 1)
        self.assertEqual(other[0]["id"], "99999-1")

        # Tier 2: Reading from conn.memory_engine when conn.local_queues is None
        self.conn.local_queues = None  # type: ignore
        self.conn.other_local_queues = None  # type: ignore
        self.conn.memory_engine.local_queues_map = {
            "10001-2": {"id": "10001-2", "uid": "10001"},
            "88888-1": {"id": "88888-1", "uid": "88888"},
        }
        own = self.task._read_live_local_queues(self.conn)
        other = self.task._read_live_other_queues(self.conn)
        self.assertEqual(len(own), 1)
        self.assertEqual(own[0]["id"], "10001-2")
        self.assertEqual(len(other), 1)
        self.assertEqual(other[0]["id"], "88888-1")

        # Tier 3: Reading from conn.init_data fallback
        self.conn.memory_engine = None  # type: ignore
        self.conn.init_data["local_queues"] = [{"id": "10001-3", "uid": "10001"}]
        self.conn.init_data["other_local_queues"] = [{"id": "77777-1", "uid": "77777"}]
        own = self.task._read_live_local_queues(self.conn)
        other = self.task._read_live_other_queues(self.conn)
        self.assertEqual(len(own), 1)
        self.assertEqual(own[0]["id"], "10001-3")
        self.assertEqual(len(other), 1)
        self.assertEqual(other[0]["id"], "77777-1")

    def test_02_get_active_marches_count_and_status_filtering(self):
        """Verify get_active_marches_count filters by owner UID and active statuses (0, 1, 2, 3, 4, 7)."""
        # Active statuses: 0=rally, 1=moving, 2=gather/settle, 3=return, 4=waiting, 7=launched rally
        # Inactive/completed: 5=finished, 6=canceled, 9=idle
        self.conn.local_queues = [
            {"id": "10001-1", "uid": "10001", "status": 0},  # Active (rally)
            {"id": "10001-2", "uid": "10001", "status": 1},  # Active (moving)
            {"id": "10001-3", "uid": "10001", "status": 2},  # Active (gather)
            {"id": "10001-4", "uid": "10001", "status": 3},  # Active (return)
            {"id": "10001-5", "uid": "10001", "status": 4},  # Active (waiting)
            {"id": "10001-6", "uid": "10001", "status": 7},  # Active (launched rally)
            {"id": "10001-7", "uid": "10001", "status": 5},  # Inactive (finished)
            {"id": "10001-8", "uid": "10001", "status": 9},  # Inactive
            {"id": "99999-1", "uid": "99999", "status": 1},  # Foreign player march!
        ]

        active_count = self.task.get_active_marches_count()
        self.assertEqual(active_count, 6, "Expected exactly 6 active own castle marches")

    def test_03_get_other_marches_count(self):
        """Verify get_other_marches_count correctly counts other players' marches."""
        self.conn.other_local_queues = [
            {"id": "20002-1", "uid": "20002", "status": 1},
            {"id": "30003-1", "uid": "30003", "status": 2},
            {"id": "40004-1", "uid": "40004", "status": 1},
        ]
        other_count = self.task.get_other_marches_count()
        self.assertEqual(other_count, 3)

    def test_04_get_max_marches_capacity(self):
        """Verify get_max_marches_capacity with Base 1 + Techs 24011/24017/24033 + VIP 4..9/10..18, capped at 6."""
        # 1. Base case: no tech, no VIP -> capacity = 1
        self.conn.init_data = {}
        self.assertEqual(self.task.get_max_marches_capacity(), 1)

        # 2. Add Military Leadership Tech 1 (#24011) -> +1 (capacity = 2)
        self.conn.init_data = {
            "technologyCtrl": {"24011": 1}
        }
        self.assertEqual(self.task.get_max_marches_capacity(), 2)

        # 3. Add Military Leadership Tech 2 (#24017) -> +1 (capacity = 3)
        self.conn.init_data["technologyCtrl"]["24017"] = 1
        self.assertEqual(self.task.get_max_marches_capacity(), 3)

        # 4. Add Military Leadership Tech 3 (#24033) -> +1 (capacity = 4)
        self.conn.init_data["technologyCtrl"]["24033"] = 1
        self.assertEqual(self.task.get_max_marches_capacity(), 4)

        # 5. Add VIP 5 (VIP 4..9 gives +1 march) -> capacity = 5
        self.conn.init_data["vipCtrl"] = {"level": 5}
        self.assertEqual(self.task.get_max_marches_capacity(), 5)

        # 6. Upgrade to VIP 12 (VIP 10..18 gives +2 marches) -> capacity = 4 (base+techs) + 2 = 6
        self.conn.init_data["vipCtrl"] = {"level": 12}
        self.assertEqual(self.task.get_max_marches_capacity(), 6)

        # 7. Check max_marches config cap override
        self.task.config["max_marches"] = 3
        self.assertEqual(self.task.get_max_marches_capacity(), 3)
        self.task.config.pop("max_marches")

        # 8. Test VIP in lordInfoCtrl.vip fallback
        self.conn.init_data.pop("vipCtrl")
        self.conn.init_data["lordInfoCtrl"] = {
            "vip": {"level": 8, "vipEndTime": time.time() + 3600}
        }
        self.assertEqual(self.task.get_max_marches_capacity(), 5)

    def test_05_get_available_marches_count_and_property(self):
        """Verify get_available_marches_count and available_marches property."""
        # Capacity = 3 (base 1 + techs 24011 and 24017)
        self.conn.init_data = {
            "technologyCtrl": {"24011": 1, "24017": 1}
        }
        # 1 active march
        self.conn.local_queues = [
            {"id": "10001-1", "uid": "10001", "status": 1}
        ]

        avail = self.task.get_available_marches_count()
        self.assertEqual(avail, 2)
        # Verify property delegation
        self.assertEqual(int(self.task.available_marches), 2)

        # 3 active marches -> available = 0
        self.conn.local_queues.extend([
            {"id": "10001-2", "uid": "10001", "status": 2},
            {"id": "10001-3", "uid": "10001", "status": 3},
        ])
        self.assertEqual(self.task.get_available_marches_count(), 0)
        self.assertEqual(int(self.task.available_marches), 0)

        # Excess active marches (e.g. 4 active, capacity 3) -> available clamped at 0
        self.conn.local_queues.append(
            {"id": "10001-4", "uid": "10001", "status": 1}
        )
        self.assertEqual(self.task.get_available_marches_count(), 0)

    def test_06_get_active_gather_resource_types(self):
        """Verify get_active_gather_resource_types accurately detects gather types 1..5."""
        # Active gather marches targeting resource tiles (mapType 5 with subMapType or data.resourceType)
        self.conn.local_queues = [
            {"id": "10001-1", "uid": "10001", "status": 2, "to": {"mapType": 5, "subMapType": 1}},  # Gold/Wheat
            {"id": "10001-2", "uid": "10001", "status": 2, "to": {"mapType": 5, "subMapType": 3}},  # Wood/Iron
            {"id": "10001-3", "uid": "10001", "status": 1, "to": {"mapType": 1}},                   # Monster attack (not gather)
        ]

        gather_types = self.task.get_active_gather_resource_types()
        self.assertIsInstance(gather_types, (set, Set))
        self.assertEqual(set(gather_types), {1, 3})

    def test_07_is_ruins_march_active(self):
        """Verify is_ruins_march_active accurately detects ruins march (moveLineType 4 or mapType 7)."""
        # Case 1: No ruins march
        self.conn.local_queues = [
            {"id": "10001-1", "uid": "10001", "status": 1, "moveLineType": 1}
        ]
        self.assertFalse(self.task.is_ruins_march_active())

        # Case 2: Ruins march via moveLineType == 4
        self.conn.local_queues.append(
            {"id": "10001-2", "uid": "10001", "status": 1, "moveLineType": 4}
        )
        self.assertTrue(self.task.is_ruins_march_active())

        # Case 3: Ruins march via to.mapType == 7
        self.conn.local_queues = [
            {"id": "10001-3", "uid": "10001", "status": 1, "to": {"mapType": 7, "x": 100, "y": 200}}
        ]
        self.assertTrue(self.task.is_ruins_march_active())


if __name__ == "__main__":
    unittest.main(verbosity=2)
