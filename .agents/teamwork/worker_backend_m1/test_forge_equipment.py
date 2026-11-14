# -*- coding: utf-8 -*-
"""
Unit tests for ForgeEquipmentTask and bot_manager registration
"""

import asyncio
import copy
import json
import os
import sys
import time

# Ensure project root is in sys.path
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

from typing import Any, Dict, List, Optional

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
)
import bot_manager


class MockConnection:
    """Mock game client connection for testing."""
    def __init__(self, init_data: Dict[str, Any]):
        self.init_data = copy.deepcopy(init_data)
        self.is_connected = True
        self.query_log: List[Dict[str, Any]] = []
        self.mock_responses: Dict[str, Any] = {}

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        return self.init_data.get(name, {})

    async def query(self, cmd: str, subcmd: str, data: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        self.query_log.append({"cmd": str(cmd), "subcmd": str(subcmd), "data": copy.deepcopy(data)})
        key = f"{cmd}_{subcmd}"
        if key in self.mock_responses:
            return self.mock_responses[key]
        return {"err": 0, "data": {}}


def test_registration():
    print("[TEST] Registration in bot_manager...")
    assert ForgeEquipmentTask in bot_manager.REGISTERED_TASKS, "ForgeEquipmentTask missing from REGISTERED_TASKS"
    assert "forge_equipment" in bot_manager.DEFAULT_BOT_CONFIG["tasks"], "forge_equipment missing from DEFAULT_BOT_CONFIG"
    default_cfg = bot_manager.DEFAULT_BOT_CONFIG["tasks"]["forge_equipment"]
    assert default_cfg.get("enabled") is False
    assert default_cfg.get("category") == "weapon"

    # Test reload_config_from_db
    class DummyBot:
        def __init__(self):
            self.email = "test@example.com"
            self.config = copy.deepcopy(bot_manager.DEFAULT_BOT_CONFIG)
        reload_config_from_db = bot_manager.CastleBot.reload_config_from_db

    bot = DummyBot()
    # Mock database
    import sys
    class MockDB:
        @staticmethod
        def get_castle_by_id(email):
            return {
                "email": email,
                "config": json.dumps({
                    "forge_equipment": {"enabled": True, "category": "helmet"}
                })
            }
    sys.modules["core.database"] = MockDB
    bot.reload_config_from_db()
    assert bot.config["tasks"]["forge_equipment"]["enabled"] is True
    assert bot.config["tasks"]["forge_equipment"]["category"] == "helmet"
    print("  ✓ Registration & reload_config_from_db PASSED!")


def test_task_metadata():
    print("[TEST] Task metadata and inheritance...")
    assert issubclass(ForgeEquipmentTask, BaseTask)
    assert ForgeEquipmentTask.name == "forge_equipment"
    print("  ✓ Task metadata PASSED!")


def test_disabled_config():
    print("[TEST] Task disabled in config...")
    conn = MockConnection(init_data={})
    task = ForgeEquipmentTask(conn, config={"enabled": False})
    res = asyncio.run(task.safe_execute())
    assert res.skipped is True
    assert "معطلة" in res.message or "disabled" in res.message.lower()
    assert len(conn.query_log) == 0, "0-Network violated: sent query while disabled"
    print("  ✓ Disabled check PASSED!")


def test_preflight_daily_quest_completed_id():
    print("[TEST] 0-Network Pre-flight when everydayTaskCtrl.eventInfo['4100009'] >= 1...")
    init_data = {
        "everydayTaskCtrl": {
            "eventInfo": {"4100009": 1}
        }
    }
    conn = MockConnection(init_data)
    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
    res = asyncio.run(task.safe_execute())
    assert res.skipped is True
    assert "4100009 already completed" in res.message
    assert len(conn.query_log) == 0, "0-Network violated: sent query when daily quest already done"
    print("  ✓ 4100009 eventInfo skip PASSED!")


def test_preflight_daily_quest_completed_type():
    print("[TEST] 0-Network Pre-flight when everydayTaskCtrl.eventInfo['9'] >= 1...")
    init_data = {
        "everydayTaskCtrl": {
            "eventInfo": {"9": 1}
        }
    }
    conn = MockConnection(init_data)
    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "clothes"})
    res = asyncio.run(task.safe_execute())
    assert res.skipped is True
    assert "4100009 already completed" in res.message
    assert len(conn.query_log) == 0, "0-Network violated"
    print("  ✓ Type '9' eventInfo skip PASSED!")


def test_preflight_quest_finish_list():
    print("[TEST] 0-Network Pre-flight when questCtrl.point_finish_list has 4100009...")
    init_data = {
        "questCtrl": {
            "point_finish_list": [4100001, 4100009]
        }
    }
    conn = MockConnection(init_data)
    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "helmet"})
    res = asyncio.run(task.safe_execute())
    assert res.skipped is True
    assert "4100009 already completed" in res.message
    assert len(conn.query_log) == 0, "0-Network violated"
    print("  ✓ questCtrl.point_finish_list skip PASSED!")


def test_collect_ready_piece():
    print("[TEST] Collect ready piece when endTime <= now...")
    now_ts = int(time.time())
    init_data = {
        "equipmentCtrl": {
            "equipment_array": [
                {"epid": 777, "eid": 6100101, "wear": 0, "endTime": now_ts - 50}
            ]
        },
        "everydayTaskCtrl": {
            "eventInfo": {}
        }
    }
    conn = MockConnection(init_data)
    conn.mock_responses["1047_2"] = {"err": 0, "data": {}}

    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
    res = asyncio.run(task.safe_execute())

    assert res.success is True
    assert res.skipped is False
    assert len(conn.query_log) == 1
    query = conn.query_log[0]
    assert query["cmd"] == "1047"
    assert query["subcmd"] == "2"
    assert query["data"] == {"epid": 777}

    # Verify live memory sync
    arr = conn.init_data["equipmentCtrl"]["equipment_array"]
    assert arr[0]["endTime"] == 0, "Live memory endTime not reset to 0"
    ev = conn.init_data["everydayTaskCtrl"]["eventInfo"]
    assert ev.get("4100009") == 1, "Daily quest ID 4100009 not set in live memory"
    assert ev.get("9") == 1, "Daily quest Type 9 not set in live memory"
    print("  ✓ Collect ready piece PASSED!")


def test_busy_forge_skip():
    print("[TEST] Busy forge 0-Network skip when endTime > now...")
    now_ts = int(time.time())
    init_data = {
        "equipmentCtrl": {
            "equipment_array": [
                {"epid": 888, "eid": 6200501, "wear": 0, "endTime": now_ts + 500}
            ]
        },
        "everydayTaskCtrl": {
            "eventInfo": {}
        }
    }
    conn = MockConnection(init_data)
    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "clothes"})
    res = asyncio.run(task.safe_execute())

    assert res.skipped is True
    assert "busy forging" in res.message
    assert len(conn.query_log) == 0, "0-Network violated: sent query while blacksmith is busy"
    print("  ✓ Busy forge 0-Network skip PASSED!")


def test_highest_tier_downgrade_to_level_1():
    print("[TEST] Highest tier downgrade to Level 1 when bag has no base pieces...")
    # Blacksmith is Lv.15, Castle is Lv.15
    # Has ample Lv.1 materials (200601, 200301) and steel (500)
    # But NO base equipment pieces in bag for Lv.5 or Lv.10 or Lv.15!
    init_data = {
        "cityCtrl": {
            "blist": [{"binfo": {"bid": "115", "lv": "15"}}],
            "reslist": {"1006": 500}
        },
        "lordInfoCtrl": {"base": {"level": 15}},
        "equipmentCtrl": {
            "equipment_array": []  # No base items!
        },
        "backpackCtrl": {
            "200601": {"count": 10, "id": 200601},  # white
            "200301": {"count": 10, "id": 200301},  # white
        },
        "everydayTaskCtrl": {
            "eventInfo": {}
        }
    }
    conn = MockConnection(init_data)
    conn.mock_responses["1047_1"] = {
        "err": 0,
        "data": {
            "equipment": {"epid": 9999, "eid": 6100101, "wear": 0, "qly": 1},
            "bTime": int(time.time()),
            "costTime": 360
        }
    }

    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
    res = asyncio.run(task.safe_execute())

    assert res.success is True
    assert res.skipped is False
    assert len(conn.query_log) == 1

    q = conn.query_log[0]
    assert q["cmd"] == "1047"
    assert q["subcmd"] == "1"
    assert q["data"]["eid"] == 6100101, "Did not downgrade to Level 1 weapon (6100101)"
    assert q["data"]["mainMaterialID"] == 0, "Level 1 weapon should have mainMaterialID == 0"
    assert q["data"]["materialArray"] == [200601, 200301]

    # Verify live memory state sync
    bp = conn.init_data["backpackCtrl"]
    assert bp["200601"]["count"] == 9, "Material 200601 not decremented"
    assert bp["200301"]["count"] == 9, "Material 200301 not decremented"
    reslist = conn.init_data["cityCtrl"]["reslist"]
    assert reslist["1006"] == 400, "Steel not decremented by 100"
    eq_arr = conn.init_data["equipmentCtrl"]["equipment_array"]
    assert len(eq_arr) == 1
    assert eq_arr[0]["eid"] == 6100101
    assert eq_arr[0]["endTime"] > int(time.time())
    ev = conn.init_data["everydayTaskCtrl"]["eventInfo"]
    assert ev.get("4100009") == 1
    print("  ✓ Downgrade to Level 1 with state sync PASSED!")


def test_highest_tier_crafts_level_5_when_base_piece_exists():
    print("[TEST] Crafts Level 5 piece when base Lv.1 piece exists in bag...")
    # Blacksmith is Lv.10, Castle is Lv.10
    # Bag has unequipped Lv.1 weapon (6100101, epid 101, wear=0, endTime=0)
    # Materials for Lv.5 weapon (200601, 200301) and steel (2000)
    init_data = {
        "cityCtrl": {
            "blist": [{"binfo": {"bid": "115", "lv": "10"}}],
            "reslist": {"1006": 2000}
        },
        "lordInfoCtrl": {"base": {"level": 10}},
        "equipmentCtrl": {
            "equipment_array": [
                {"epid": 101, "eid": 6100101, "wear": 0, "endTime": 0, "qly": 1}
            ]
        },
        "backpackCtrl": {
            "200601": {"count": 5, "id": 200601},
            "200301": {"count": 5, "id": 200301},
        },
        "everydayTaskCtrl": {
            "eventInfo": {}
        }
    }
    conn = MockConnection(init_data)
    conn.mock_responses["1047_1"] = {
        "err": 0,
        "data": {
            "equipment": {"epid": 202, "eid": 6100501, "wear": 0, "qly": 1},
            "bTime": int(time.time()),
            "costTime": 360
        }
    }

    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "weapon"})
    res = asyncio.run(task.safe_execute())

    assert res.success is True
    assert res.skipped is False
    q = conn.query_log[0]
    assert q["data"]["eid"] == 6100501, "Should select Level 5 weapon"
    assert q["data"]["mainMaterialID"] == 101, "Should consume base item 101"

    # Base item 101 should be removed from equipment_array, new item 202 added
    eq_arr = conn.init_data["equipmentCtrl"]["equipment_array"]
    epids = [x["epid"] for x in eq_arr]
    assert 101 not in epids, "Base item 101 was not removed from equipment_array"
    assert 202 in epids, "New item 202 not added to equipment_array"
    print("  ✓ Level 5 craft with base item consumption PASSED!")


def test_lowest_quality_material_selection():
    print("[TEST] Material selection prioritizes lowest quality (white -> green -> blue)...")
    # Category 63 (helmet): Pair (2002, 2001)
    # In bag:
    # 2002 has 200203 (blue) count 5, and 200201 (white) count 2
    # 2001 has 200102 (green) count 5 (no white)
    init_data = {
        "cityCtrl": {
            "blist": [{"binfo": {"bid": "115", "lv": "1"}}],
            "reslist": {"1006": 1000}
        },
        "equipmentCtrl": {"equipment_array": []},
        "backpackCtrl": {
            "200203": {"count": 5, "id": 200203},  # blue
            "200201": {"count": 2, "id": 200201},  # white
            "200102": {"count": 5, "id": 200102},  # green
        },
        "everydayTaskCtrl": {"eventInfo": {}}
    }
    conn = MockConnection(init_data)
    task = ForgeEquipmentTask(conn, config={"enabled": True, "category": "helmet"})
    res = asyncio.run(task.safe_execute())

    assert res.success is True
    q = conn.query_log[0]
    # For 2002, white (200201) should be chosen over blue (200203)
    # For 2001, green (200102) should be chosen since white is unavailable
    assert 200201 in q["data"]["materialArray"], "Did not pick white 200201"
    assert 200203 not in q["data"]["materialArray"], "Picked blue 200203 when white was available"
    assert 200102 in q["data"]["materialArray"], "Did not pick green 200102"
    print("  ✓ Lowest quality material selection PASSED!")


def test_all_six_categories():
    print("[TEST] Support for all 6 categories...")
    for cat_name, prefix in CATEGORY_PREFIX_MAP.items():
        pair_a, pair_b = CATEGORY_MATERIAL_PAIRS[prefix]
        init_data = {
            "cityCtrl": {
                "blist": [{"binfo": {"bid": "115", "lv": "1"}}],
                "reslist": {"1006": 500}
            },
            "equipmentCtrl": {"equipment_array": []},
            "backpackCtrl": {
                f"{pair_a}01": {"count": 5, "id": int(f"{pair_a}01")},
                f"{pair_b}01": {"count": 5, "id": int(f"{pair_b}01")},
            },
            "everydayTaskCtrl": {"eventInfo": {}}
        }
        conn = MockConnection(init_data)
        task = ForgeEquipmentTask(conn, config={"enabled": True, "category": cat_name})
        res = asyncio.run(task.safe_execute())
        assert res.success is True, f"Failed for category {cat_name}"
        q = conn.query_log[0]
        expected_eid = prefix * 100000 + 101
        assert q["data"]["eid"] == expected_eid, f"Wrong EID for {cat_name}: {q['data']['eid']}"
    print("  ✓ All 6 categories supported PASSED!")


def run_all():
    print("==================================================")
    print("Running ForgeEquipmentTask & Bot Manager Unit Tests")
    print("==================================================")
    test_registration()
    test_task_metadata()
    test_disabled_config()
    test_preflight_daily_quest_completed_id()
    test_preflight_daily_quest_completed_type()
    test_preflight_quest_finish_list()
    test_collect_ready_piece()
    test_busy_forge_skip()
    test_highest_tier_downgrade_to_level_1()
    test_highest_tier_crafts_level_5_when_base_piece_exists()
    test_lowest_quality_material_selection()
    test_all_six_categories()
    print("==================================================")
    print("ALL 12 TESTS PASSED PERFECTLY WITH ZERO FAILURES!")
    print("==================================================")


if __name__ == "__main__":
    run_all()
