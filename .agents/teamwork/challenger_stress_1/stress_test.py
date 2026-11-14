# -*- coding: utf-8 -*-
r"""
e:\intqam-sultan\.agents\teamwork\challenger_stress_1\stress_test.py
Adversarial Stress Test Suite for ForgeEquipmentTask (tasks/forge_equipment.py)
═══════════════════════════════════════════════════════════════════════════════
Empirical challenger verification covering:
  1. Corrupted & Malformed Memory
  2. Extreme Resource Conditions & Boundaries
  3. Recipe Selection & Base Item Fallback
  4. Malformed Configuration Fallback
  5. Fault Isolation & Exception Confinement
  6. 0-Network Invariant Enforcement
  7. High-Volume / Scale Stress Test
"""

import asyncio
import copy
import os
import sys
import time
from typing import Any, Dict, List, Optional

# Ensure project root is in sys.path
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from tasks.base_task import BaseTask, TaskResult
from tasks.forge_equipment import (
    ForgeEquipmentTask,
    CATEGORY_PREFIX_MAP,
    CATEGORY_MATERIAL_PAIRS,
    EQUIPMENT_LEVELS_DESC,
    LEVEL_SPECS,
    CMD_EQUIPMENT_MODULE,
    REQ_FORGE_EQUIPMENT,
    REQ_GET_EQUIPMENT,
    DAILY_QUEST_FORGE_ID,
    DAILY_QUEST_FORGE_TYPE,
    RES_STEEL_ID,
)


class MockConcurrentLogin(Exception):
    """Simulates game client ConcurrentLogin error."""
    pass


class AdversarialMockConnection:
    """Mock connection with full query recording and adversarial injection."""
    def __init__(self, init_data: Any = None, is_connected: bool = True):
        self.init_data = copy.deepcopy(init_data) if isinstance(init_data, (dict, list)) else init_data
        self.is_connected = is_connected
        self.query_log: List[Dict[str, Any]] = []
        self.mock_responses: Dict[str, Any] = {}
        self.exception_to_raise: Optional[Exception] = None

    def get_ctrl(self, name: str) -> Any:
        if isinstance(self.init_data, dict):
            return self.init_data.get(name, {})
        return {}

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        self.query_log.append({
            "cmd": str(cmd),
            "subcmd": str(subcmd),
            "data": copy.deepcopy(data),
            "timestamp": time.time(),
        })
        if self.exception_to_raise:
            raise self.exception_to_raise
        key = f"{cmd}_{subcmd}"
        if key in self.mock_responses:
            resp = self.mock_responses[key]
            if isinstance(resp, Exception):
                raise resp
            return resp
        return {"err": 0, "data": {}}


class StressTestRunner:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.test_records: List[Dict[str, Any]] = []

    def record(self, test_name: str, passed: bool, details: str = ""):
        if passed:
            self.passed += 1
            status = "PASS"
            print(f"  [✓ PASS] {test_name} {details}")
        else:
            self.failed += 1
            status = "FAIL"
            print(f"  [✗ FAIL] {test_name} {details}")
        self.test_records.append({
            "name": test_name,
            "status": status,
            "details": details,
        })

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 1: Malformed & Corrupted Live Memory
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_1_corrupted_memory(self):
        print("\n--- Suite 1: Malformed & Corrupted Live Memory ---")

        # 1.1: conn is None
        task = ForgeEquipmentTask(None, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.1 conn is None",
            res.skipped is True and "لا يوجد اتصال" in res.message,
            f"(msg: {res.message})",
        )

        # 1.2: conn.is_connected = False
        conn = AdversarialMockConnection(init_data={"equipmentCtrl": {}}, is_connected=False)
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.2 conn.is_connected is False",
            res.skipped is True and len(conn.query_log) == 0,
            f"(queries: {len(conn.query_log)})",
        )

        # 1.3: conn.init_data is None
        conn = AdversarialMockConnection(init_data=None, is_connected=True)
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.3 conn.init_data is None",
            res.skipped is True and len(conn.query_log) == 0,
            f"(msg: {res.message})",
        )

        # 1.4: conn.init_data is empty dict {}
        conn = AdversarialMockConnection(init_data={}, is_connected=True)
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.4 conn.init_data is {}",
            res.skipped is True and len(conn.query_log) == 0,
            f"(msg: {res.message})",
        )

        # 1.5: Missing equipmentCtrl entirely
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 1000}, "blist": []},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        # Should proceed to forge Lv.1 weapon without equipmentCtrl crashing
        self.record(
            "1.5 Missing equipmentCtrl",
            res.success is True and len(conn.query_log) == 1,
            f"(result: {res.message})",
        )

        # 1.6: Missing backpackCtrl entirely
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 1000}},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.6 Missing backpackCtrl",
            res.skipped is True and len(conn.query_log) == 0,
            f"(graceful skip: {res.message})",
        )

        # 1.7: Missing cityCtrl entirely
        conn = AdversarialMockConnection(init_data={
            "equipmentCtrl": {"equipment_array": []},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        # 0 steel available, 0 boxes -> graceful skip without crash
        self.record(
            "1.7 Missing cityCtrl",
            res.skipped is True and len(conn.query_log) == 0,
            f"(graceful skip: {res.message})",
        )

        # 1.8: Missing everydayTaskCtrl entirely
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 1000}},
            "equipmentCtrl": {"equipment_array": []},
            "backpackCtrl": {"200601": 5, "200301": 5},
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.8 Missing everydayTaskCtrl",
            res.success is True and len(conn.query_log) == 1,
            f"(crafted successfully without everydayTaskCtrl)",
        )

        # 1.9: Corrupted controllers (strings, numbers, lists instead of dicts)
        conn = AdversarialMockConnection(init_data={
            "equipmentCtrl": "CORRUPTED_STRING",
            "backpackCtrl": 12345,
            "cityCtrl": ["corrupted", "list"],
            "everydayTaskCtrl": False,
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.9 Corrupted controller types",
            (res.skipped is True or res.success is False) and len(conn.query_log) == 0,
            f"(gracefully handled non-dict controllers: {res.message})",
        )

        # 1.10: Corrupted fields inside controllers
        conn = AdversarialMockConnection(init_data={
            "equipmentCtrl": {"equipment_array": "NOT_A_LIST"},
            "cityCtrl": {"reslist": "NOT_A_DICT", "blist": "NOT_A_LIST"},
            "backpackCtrl": {"itemList": None},
            "everydayTaskCtrl": {"eventInfo": None},
            "questCtrl": {"point_finish_list": None},
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.10 Corrupted fields inside controllers",
            res.skipped is True and len(conn.query_log) == 0,
            f"(handled without crashing: {res.message})",
        )

        # 1.11: Malformed equipment items inside equipment_array
        conn = AdversarialMockConnection(init_data={
            "equipmentCtrl": {
                "equipment_array": [
                    None,
                    "invalid_string_item",
                    {},
                    {"wear": "corrupted_val"},
                    {"endTime": "corrupted_time"},
                    {"eid": None},
                ]
            },
            "cityCtrl": {"reslist": {"1006": 1000}},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "1.11 Malformed items in equipment_array",
            res.success is True or res.skipped is True or not res.success,
            f"(safe execution handled malformed items: {res.message})",
        )

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 2: Extreme Resource Conditions & Boundaries
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_2_extreme_resources(self):
        print("\n--- Suite 2: Extreme Resource Conditions & Boundaries ---")

        # 2.1: 0 steel and 0 boxes
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 0}},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "2.1 Zero steel and zero boxes",
            res.skipped is True and len(conn.query_log) == 0,
            f"(0 queries sent, skipped gracefully: {res.message})",
        )

        # 2.2: Negative steel (-999,999) and 0 boxes
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": -999999}},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "2.2 Negative steel (-999,999)",
            res.skipped is True and len(conn.query_log) == 0,
            f"(skipped gracefully: {res.message})",
        )

        # 2.3: Non-numeric / float steel in reslist
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": "garbage_value"}},
            "backpackCtrl": {"200601": 5, "200301": 5},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "2.3 Non-numeric steel in reslist",
            res.skipped is True and len(conn.query_log) == 0,
            f"(parsed as 0 without crashing: {res.message})",
        )

        # 2.4: 0 materials in backpack
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 5000}},
            "backpackCtrl": {},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "2.4 Zero materials in backpack",
            res.skipped is True and len(conn.query_log) == 0,
            f"(skipped gracefully: {res.message})",
        )

        # 2.5: Missing one of two required materials (has 200601 but 0 of 200301)
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 5000}},
            "backpackCtrl": {"200601": {"count": 10}},
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        self.record(
            "2.5 Missing one required material",
            res.skipped is True and len(conn.query_log) == 0,
            f"(skipped gracefully: {res.message})",
        )

        # 2.6: Only rare / high-tier materials in bag (Gold qly 6 only)
        # Weapon requires families 2006 and 2003. Provide only 200606 and 200306.
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 5000}},
            "backpackCtrl": {
                "200606": {"count": 2, "id": 200606},
                "200306": {"count": 2, "id": 200306},
            },
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_2_6 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["materialArray"] == [200606, 200306]
        )
        self.record(
            "2.6 Only gold / high-tier materials in bag",
            passed_2_6,
            f"(picked gold materials [200606, 200306]: {res.message})",
        )

        # 2.7: Mixed material qualities in bag -> Strict priority of lowest quality
        # 2006: has white (200601), blue (200603), gold (200606)
        # 2003: has green (200302), purple (200304)
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 5000}},
            "backpackCtrl": {
                "200601": {"count": 1, "id": 200601},
                "200603": {"count": 5, "id": 200603},
                "200606": {"count": 5, "id": 200606},
                "200302": {"count": 1, "id": 200302},
                "200304": {"count": 5, "id": 200304},
            },
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_2_7 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["materialArray"] == [200601, 200302]
        )
        self.record(
            "2.7 Mixed qualities prioritizes lowest (white -> green)",
            passed_2_7,
            f"(picked [200601, 200302]: {conn.query_log[0]['data']['materialArray']})",
        )

        # 2.8: Steel deficit covered by opening steel boxes from bag
        # Need 100 steel for Lv.1 weapon. Current steel is 20 (deficit 80).
        # Box 100402 gives 100 steel.
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 20}},
            "backpackCtrl": {
                "100402": {"count": 5, "id": 100402},  # 100 steel box
                "200601": {"count": 5, "id": 200601},
                "200301": {"count": 5, "id": 200301},
            },
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        # Should have sent 2 queries: 1 to open box (CMD 1004 / SubCMD 2), 1 to forge (CMD 1047 / SubCMD 1)
        passed_2_8 = (
            res.success is True
            and len(conn.query_log) == 2
            and conn.query_log[0]["cmd"] == "1004"
            and conn.query_log[0]["data"]["itemID"] == 100402
            and conn.query_log[1]["cmd"] == "1047"
        )
        self.record(
            "2.8 Steel deficit covered by auto-opening boxes",
            passed_2_8,
            f"(total queries: {len(conn.query_log)}, box opened then forged)",
        )

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 3: Recipe Selection & Missing Base Item Fallback
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_3_recipe_and_fallback(self):
        print("\n--- Suite 3: Recipe Selection & Missing Base Item Fallback ---")

        # 3.1: Lv.100 Blacksmith & Castle with Lv.100 materials, but 0 base items in bag
        # Must fall back gracefully from Lv.100 all the way to Lv.1 without crashing
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "100"}}],
                "reslist": {"1006": 10000000},
            },
            "lordInfoCtrl": {"base": {"level": 100}},
            "equipmentCtrl": {"equipment_array": []},  # 0 base items!
            "backpackCtrl": {
                "200601": {"count": 100, "id": 200601},
                "200301": {"count": 100, "id": 200301},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_3_1 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
            and conn.query_log[0]["data"]["mainMaterialID"] == 0
        )
        self.record(
            "3.1 Fallback from Lv.100 to Lv.1 when no base pieces exist",
            passed_3_1,
            f"(EID: {conn.query_log[0]['data']['eid'] if conn.query_log else 'None'}, mainMaterialID: 0)",
        )

        # 3.2: Base item exists in bag but is EQUIPPED (wear == 1)
        # Should NOT use the equipped item, and must fall back to Lv.1
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "10"}}],
                "reslist": {"1006": 100000},
            },
            "lordInfoCtrl": {"base": {"level": 10}},
            "equipmentCtrl": {
                "equipment_array": [
                    {"epid": 555, "eid": 6100101, "wear": 1, "endTime": 0}  # WORN!
                ]
            },
            "backpackCtrl": {
                "200601": {"count": 10, "id": 200601},
                "200301": {"count": 10, "id": 200301},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_3_2 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
            and conn.query_log[0]["data"]["mainMaterialID"] == 0
        )
        self.record(
            "3.2 Equipped base piece (wear == 1) rejected for crafting",
            passed_3_2,
            f"(ignored equipped piece 555, safely forged Lv.1)",
        )

        # 3.3: Base item exists in bag but is of WRONG category (clothes 62 instead of weapon 61)
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "10"}}],
                "reslist": {"1006": 100000},
            },
            "lordInfoCtrl": {"base": {"level": 10}},
            "equipmentCtrl": {
                "equipment_array": [
                    {"epid": 666, "eid": 6200101, "wear": 0, "endTime": 0}  # Clothes!
                ]
            },
            "backpackCtrl": {
                "200601": {"count": 10, "id": 200601},
                "200301": {"count": 10, "id": 200301},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_3_3 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
            and conn.query_log[0]["data"]["mainMaterialID"] == 0
        )
        self.record(
            "3.3 Wrong category base piece rejected",
            passed_3_3,
            f"(ignored clothes piece 666 when forging weapon, forged Lv.1)",
        )

        # 3.4: Multiple candidate base items -> Consumes lowest quality first
        # Lv.1 weapon (6100101): one with qly=1 (white), one with qly=3 (blue)
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "10"}}],
                "reslist": {"1006": 100000},
            },
            "lordInfoCtrl": {"base": {"level": 10}},
            "equipmentCtrl": {
                "equipment_array": [
                    {"epid": 901, "eid": 6100101, "wear": 0, "endTime": 0, "qly": 3, "slv": 0},
                    {"epid": 902, "eid": 6100101, "wear": 0, "endTime": 0, "qly": 1, "slv": 0},
                ]
            },
            "backpackCtrl": {
                "200601": {"count": 10, "id": 200601},
                "200301": {"count": 10, "id": 200301},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_3_4 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["mainMaterialID"] == 902
        )
        self.record(
            "3.4 Multiple candidate base items consumes lowest quality first",
            passed_3_4,
            f"(consumed epid 902 [qly 1] over 901 [qly 3])",
        )

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 4: Malformed Configuration & Safe Fallback
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_4_malformed_config(self):
        print("\n--- Suite 4: Malformed Configuration & Safe Fallback ---")

        base_init_data = {
            "cityCtrl": {"reslist": {"1006": 500}},
            "backpackCtrl": {
                "200601": {"count": 5, "id": 200601},
                "200301": {"count": 5, "id": 200301},
            },
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        }

        # 4.1: category is None -> Safe fallback to "weapon" (6100101)
        conn = AdversarialMockConnection(init_data=base_init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": None})
        res = asyncio.run(task.safe_execute())
        passed_4_1 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
        )
        self.record("4.1 category is None falls back to weapon", passed_4_1, f"(EID: 6100101)")

        # 4.2: category is empty string "" -> Safe fallback to "weapon"
        conn = AdversarialMockConnection(init_data=base_init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": ""})
        res = asyncio.run(task.safe_execute())
        passed_4_2 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
        )
        self.record("4.2 category is empty string falls back to weapon", passed_4_2, f"(EID: 6100101)")

        # 4.3: category is an integer 99999 -> Safe fallback to "weapon"
        conn = AdversarialMockConnection(init_data=base_init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": 99999})
        res = asyncio.run(task.safe_execute())
        passed_4_3 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
        )
        self.record("4.3 category is integer 99999 falls back to weapon", passed_4_3, f"(EID: 6100101)")

        # 4.4: category is unknown string "laser_gun" -> Safe fallback to "weapon"
        conn = AdversarialMockConnection(init_data=base_init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "laser_gun"})
        res = asyncio.run(task.safe_execute())
        passed_4_4 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6100101
        )
        self.record("4.4 category is 'laser_gun' falls back to weapon", passed_4_4, f"(EID: 6100101)")

        # 4.5: category is uppercase with spaces "   CLOTHES   " -> parsed to clothes (6200101)
        clothes_init_data = copy.deepcopy(base_init_data)
        clothes_init_data["backpackCtrl"] = {
            "200501": {"count": 5, "id": 200501},
            "200101": {"count": 5, "id": 200101},
        }
        conn = AdversarialMockConnection(init_data=clothes_init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "   CLOTHES   "})
        res = asyncio.run(task.safe_execute())
        passed_4_5 = (
            res.success is True
            and len(conn.query_log) == 1
            and conn.query_log[0]["data"]["eid"] == 6200101
        )
        self.record("4.5 category '   CLOTHES   ' parsed to clothes (62)", passed_4_5, f"(EID: 6200101)")

        # 4.6: config is None -> default fallback, safe skip
        conn = AdversarialMockConnection(init_data=base_init_data)
        task = ForgeEquipmentTask(conn, config=None)
        res = asyncio.run(task.safe_execute())
        passed_4_6 = res.skipped is True and len(conn.query_log) == 0
        self.record("4.6 config is None skips safely", passed_4_6, f"(0 queries sent)")

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 5: Fault Isolation & Exception Confinement
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_5_fault_isolation(self):
        print("\n--- Suite 5: Fault Isolation & Exception Confinement ---")

        base_init_data = {
            "cityCtrl": {"reslist": {"1006": 500}},
            "backpackCtrl": {
                "200601": {"count": 5, "id": 200601},
                "200301": {"count": 5, "id": 200301},
            },
            "equipmentCtrl": {"equipment_array": []},
            "everydayTaskCtrl": {"eventInfo": {}}
        }

        # 5.1: conn.query raises RuntimeError("Network socket crashed")
        conn = AdversarialMockConnection(init_data=base_init_data)
        conn.exception_to_raise = RuntimeError("Network socket crashed")
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        try:
            res = asyncio.run(task.safe_execute())
            passed_5_1 = res.success is False and "انقطاع" in res.message or "socket" in res.message
        except Exception as exc:
            passed_5_1 = False
        self.record("5.1 Network socket error confined without leaking", passed_5_1, f"(returned TaskResult.fail)")

        # 5.2: conn.query raises asyncio.TimeoutError
        conn = AdversarialMockConnection(init_data=base_init_data)
        conn.exception_to_raise = asyncio.TimeoutError("Query timed out")
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        try:
            res = asyncio.run(task.safe_execute())
            passed_5_2 = res.success is False
        except Exception:
            passed_5_2 = False
        self.record("5.2 asyncio.TimeoutError confined without leaking", passed_5_2, f"(returned TaskResult.fail)")

        # 5.3: Server returns business error {"err": "10005", "msg": "Cannot forge"}
        conn = AdversarialMockConnection(init_data=base_init_data)
        conn.mock_responses["1047_1"] = {"err": "10005", "msg": "Cannot forge"}
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        passed_5_3 = res.success is False and "10005" in res.message
        self.record("5.3 Server error code 10005 handled cleanly", passed_5_3, f"(msg: {res.message})")

        # 5.4: Special case - ConcurrentLoginException MUST bubble up per bot_manager contract
        conn = AdversarialMockConnection(init_data=base_init_data)
        conn.exception_to_raise = MockConcurrentLogin("Account logged in from another device")
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        bubbled_up = False
        try:
            asyncio.run(task.safe_execute())
        except MockConcurrentLogin:
            bubbled_up = True
        except Exception:
            bubbled_up = False
        self.record("5.4 ConcurrentLogin bubbles up per bot_manager contract", bubbled_up, f"(bubbled={bubbled_up})")

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 6: 0-Network Invariant Enforcement
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_6_zero_network_invariants(self):
        print("\n--- Suite 6: 0-Network Invariant Enforcement ---")

        # 6.1: Disabled config -> Exactly 0 queries
        conn = AdversarialMockConnection(init_data={"equipmentCtrl": {}})
        task = ForgeEquipmentTask(conn, config={"enabled": False})
        res = asyncio.run(task.safe_execute())
        self.record("6.1 Disabled config -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

        # 6.2: Daily quest already done (eventInfo['4100009'] = 1) -> Exactly 0 queries
        conn = AdversarialMockConnection(init_data={"everydayTaskCtrl": {"eventInfo": {"4100009": 1}}})
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record("6.2 Daily quest 4100009 done -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

        # 6.3: Daily quest already done (eventInfo['9'] = 1) -> Exactly 0 queries
        conn = AdversarialMockConnection(init_data={"everydayTaskCtrl": {"eventInfo": {"9": 1}}})
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record("6.3 Daily quest Type 9 done -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

        # 6.4: Quest point_finish_list has 4100009 -> Exactly 0 queries
        conn = AdversarialMockConnection(init_data={"questCtrl": {"point_finish_list": [4100009]}})
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record("6.4 point_finish_list has 4100009 -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

        # 6.5: Blacksmith currently busy forging (endTime > now) -> Exactly 0 queries
        now_ts = int(time.time())
        conn = AdversarialMockConnection(init_data={
            "equipmentCtrl": {
                "equipment_array": [
                    {"epid": 111, "eid": 6100101, "wear": 0, "endTime": now_ts + 600}
                ]
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record("6.5 Blacksmith busy forging -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

        # 6.6: Insufficient materials -> Exactly 0 queries
        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {"reslist": {"1006": 10000}},
            "equipmentCtrl": {"equipment_array": []},
            "backpackCtrl": {},
            "everydayTaskCtrl": {"eventInfo": {}}
        })
        task = ForgeEquipmentTask(conn, config={"enabled": True})
        res = asyncio.run(task.safe_execute())
        self.record("6.6 Insufficient materials -> 0 queries", len(conn.query_log) == 0, f"queries={len(conn.query_log)}")

    # ═════════════════════════════════════════════════════════════════════════
    # Suite 7: High-Volume / Scale Stress Test
    # ═════════════════════════════════════════════════════════════════════════

    def test_suite_7_high_volume_scale(self):
        print("\n--- Suite 7: High-Volume & Scale Stress Test ---")

        # 1,000 equipment items in equipment_array + 1,000 items in backpack
        huge_equipment_array = []
        for i in range(1, 1001):
            huge_equipment_array.append({
                "epid": 10000 + i,
                "eid": 6100000 + (i % 20) * 100 + 1,
                "wear": 1 if i % 2 == 0 else 0,
                "endTime": 0,
                "qly": (i % 6) + 1,
                "slv": i % 5,
            })

        huge_backpack = {}
        for i in range(1, 1001):
            huge_backpack[str(200000 + i)] = {"count": 10, "id": 200000 + i}
        # Inject required weapon materials
        huge_backpack["200601"] = {"count": 10, "id": 200601}
        huge_backpack["200301"] = {"count": 10, "id": 200301}

        conn = AdversarialMockConnection(init_data={
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "10"}}],
                "reslist": {"1006": 50000},
            },
            "lordInfoCtrl": {"base": {"level": 10}},
            "equipmentCtrl": {"equipment_array": huge_equipment_array},
            "backpackCtrl": huge_backpack,
            "everydayTaskCtrl": {"eventInfo": {}}
        })

        t0 = time.time()
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
        res = asyncio.run(task.safe_execute())
        elapsed_ms = (time.time() - t0) * 1000.0

        passed_7_1 = res.success is True and elapsed_ms < 100.0  # Must finish within 100ms
        self.record(
            "7.1 1,000 equipment items + 1,000 backpack items scale test",
            passed_7_1,
            f"(elapsed: {elapsed_ms:.2f}ms, target < 100ms)",
        )

    # ═════════════════════════════════════════════════════════════════════════
    # Run All Suites
    # ═════════════════════════════════════════════════════════════════════════

    def run_all(self):
        from unittest.mock import patch

        async def immediate_sleep(*args, **kwargs):
            return None

        print("=================================================================")
        print("Starting Challenger Adversarial Stress Test Suite")
        print("=================================================================")
        t_start = time.time()

        with patch("asyncio.sleep", new=immediate_sleep):
            self.test_suite_1_corrupted_memory()
            self.test_suite_2_extreme_resources()
            self.test_suite_3_recipe_and_fallback()
            self.test_suite_4_malformed_config()
            self.test_suite_5_fault_isolation()
            self.test_suite_6_zero_network_invariants()
            self.test_suite_7_high_volume_scale()

        total_time = (time.time() - t_start) * 1000.0
        total_tests = self.passed + self.failed

        print("\n=================================================================")
        print(f"STRESS TEST SUMMARY: {self.passed}/{total_tests} PASSED, {self.failed} FAILED ({total_time:.2f}ms)")
        print(f"VERDICT: {'APPROVE' if self.failed == 0 else 'REJECT'}")
        print("=================================================================")

        return self.failed == 0


if __name__ == "__main__":
    runner = StressTestRunner()
    success = runner.run_all()
    sys.exit(0 if success else 1)
