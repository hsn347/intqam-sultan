# -*- coding: utf-8 -*-
"""
test_e2e_pipeline.py — Dedicated Adversarial End-to-End Pipeline Stress Test Suite
=================================================================================
Challenger 2: Pipeline E2E Adversarial Challenger
Targets:
  1. Full round-trip: Frontend Payload -> CastleConfigModel / clean_config (api_server)
     -> SQLite DB update -> bot_manager.reload_config_from_db() -> bot.execute_tasks() -> ForgeEquipmentTask
  2. Dual-Save simulation: performSave vs handleSave equivalence and non-destructive task preservation
  3. Adversarial input fuzzing: weird categories, non-bool enabled, injection attempts, normalization
  4. Live memory execution paths: 0-network pre-flight, busy check, piece collection, Lv.1 craft
  5. Production DB forensic audit: PRAGMA integrity_check, 4 castles verification, zero data loss
"""

import os
import sys
import json
import time
import shutil
import sqlite3
import asyncio
from typing import Any, Dict, List, Optional

# Ensure project root is on sys.path
PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", ".."))
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

import pydantic
from api_server import CastleConfigModel, ForgeEquipmentConfig, CastleUpdateRequest
import bot_manager
from tasks.forge_equipment import (
    ForgeEquipmentTask,
    CATEGORY_PREFIX_MAP,
    DAILY_QUEST_FORGE_ID,
    DAILY_QUEST_FORGE_TYPE,
)
from tasks.base_task import TaskResult

# Temporary isolated database path for stress testing
TEST_DB_PATH = os.path.join(os.path.dirname(__file__), "test_castles_e2e.db")
PROD_DB_PATH = os.path.join(PROJECT_ROOT, "database", "castles.db")

class MockConnection:
    """Mock GameConnection with live memory controllers for 0-network pre-flight and task execution."""
    def __init__(self, init_data: Optional[Dict[str, Any]] = None):
        self.init_data = init_data or {}
        self.queries_sent: List[Dict[str, Any]] = []
        self.is_connected = True

    async def query(self, cmd: str, sub_cmd: str, payload: Dict[str, Any], **kwargs) -> Dict[str, Any]:
        self.queries_sent.append({
            "cmd": str(cmd),
            "sub_cmd": str(sub_cmd),
            "payload": payload,
            "timestamp": time.time(),
        })
        # Simulate response
        if str(cmd) == "1047" and str(sub_cmd) == "2":
            return {"err": "0", "data": {"epid": payload.get("epid")}}
        elif str(cmd) == "1047" and str(sub_cmd) == "1":
            return {"err": "0", "data": {"eid": payload.get("eid"), "endTime": int(time.time()) + 360}}
        return {"err": "0"}

class TestRunner:
    def __init__(self):
        self.passed = 0
        self.failed = 0
        self.results: List[Dict[str, Any]] = []

    def record(self, test_name: str, passed: bool, details: str = ""):
        if passed:
            self.passed += 1
            print(f"  [PASS] {test_name} {details}")
        else:
            self.failed += 1
            print(f"  [FAIL] {test_name} - ERROR: {details}")
        self.results.append({"name": test_name, "passed": passed, "details": details})


runner = TestRunner()


# ═════════════════════════════════════════════════════════════════════════════
# Setup & Teardown Helpers
# ═════════════════════════════════════════════════════════════════════════════

def setup_test_db():
    """Copy production database to isolated test DB path and set CASTLES_DB_PATH."""
    if os.path.exists(TEST_DB_PATH):
        try:
            os.remove(TEST_DB_PATH)
        except Exception:
            pass
    shutil.copy2(PROD_DB_PATH, TEST_DB_PATH)
    os.environ["CASTLES_DB_PATH"] = TEST_DB_PATH
    import core.database as db
    db._db_initialized = False
    db.init_db(TEST_DB_PATH)


def teardown_test_db():
    """Reset CASTLES_DB_PATH and clean up temporary database."""
    os.environ.pop("CASTLES_DB_PATH", None)
    if os.path.exists(TEST_DB_PATH):
        try:
            os.remove(TEST_DB_PATH)
        except Exception:
            pass
    # Also clean test db WAL and SHM if created
    for ext in ("-wal", "-shm"):
        p = TEST_DB_PATH + ext
        if os.path.exists(p):
            try:
                os.remove(p)
            except Exception:
                pass


# ═════════════════════════════════════════════════════════════════════════════
# SUITE 1: Full E2E Pipeline Round-Trip
# ═════════════════════════════════════════════════════════════════════════════

def test_full_round_trip():
    print("\n" + "="*70)
    print("SUITE 1: Full E2E Pipeline Round-Trip Verification")
    print("="*70)

    import core.database as db

    castle_id = "sultan_beetoo1"
    castle = db.get_castle_by_id(castle_id)
    assert castle is not None, "Initial castle not found in test DB"

    # 1. Simulate Frontend performSave/handleSave payload
    frontend_payload = {
        "fountain": {"enabled": True, "wish_type": 1},
        "train": {"enabled": False},
        "shield": {"enabled": True, "min_hours": 8},
        "forge_equipment": {"enabled": True, "category": "helmet"}
    }

    # 2. Process via Pydantic model and API server update route logic
    try:
        req = CastleUpdateRequest(config=CastleConfigModel(**frontend_payload))
        runner.record("1.1 Pydantic Validation of Frontend Payload", True)
    except Exception as e:
        runner.record("1.1 Pydantic Validation of Frontend Payload", False, str(e))
        return

    # Simulate PUT /api/castles/{castle_id} logic
    clean_config = dict(castle.get("config") or {})
    clean_config.pop("pet_patrol", None)
    validated_updates = req.config.model_dump(exclude_none=True)
    clean_config.update(validated_updates)
    updates = {"config": clean_config}

    updated_castle = db.update_castle_db(castle_id, updates)
    runner.record(
        "1.2 SQLite DB Update via db.update_castle_db",
        updated_castle is not None and updated_castle.get("config", {}).get("forge_equipment") == {"enabled": True, "category": "helmet"},
        f"Stored: {updated_castle.get('config', {}).get('forge_equipment')}"
    )

    # 3. Direct SQLite verification
    conn = sqlite3.connect(TEST_DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT config FROM castle_states WHERE castle_id = ?", (castle_id,))
    row = cur.fetchone()
    conn.close()
    raw_cfg = json.loads(row[0])
    runner.record(
        "1.3 Direct SQLite Inspection of forge_equipment key",
        raw_cfg.get("forge_equipment") == {"enabled": True, "category": "helmet"},
        f"Raw SQLite Value: {raw_cfg.get('forge_equipment')}"
    )

    # 4. Verify bot_manager reload_config_from_db()
    email = castle.get("email")
    bot = bot_manager.CastleBot(email=email, password="dummy_password")
    # Verify initial config tasks
    assert "forge_equipment" in bot.config.get("tasks", {}), "forge_equipment missing in DEFAULT_BOT_CONFIG"
    bot.reload_config_from_db()
    fe_in_bot = bot.config.get("tasks", {}).get("forge_equipment")
    runner.record(
        "1.4 bot_manager.reload_config_from_db extraction into self.config['tasks']['forge_equipment']",
        fe_in_bot == {"enabled": True, "category": "helmet"},
        f"Bot tasks config: {fe_in_bot}"
    )

    # 5. Verify task instantiation in bot loop
    mock_conn = MockConnection()
    bot.conn = mock_conn
    bot.config["task_delay_min_seconds"] = 0
    bot.config["task_delay_max_seconds"] = 0
    logs = []
    bot.log = lambda msg: logs.append(msg)

    # Verify task class is in REGISTERED_TASKS
    assert ForgeEquipmentTask in bot_manager.REGISTERED_TASKS, "ForgeEquipmentTask missing in REGISTERED_TASKS"
    runner.record("1.5 ForgeEquipmentTask present in REGISTERED_TASKS", True)

    # Execute bot tasks (with everyday task completed mock so it finishes immediately)
    mock_conn.init_data = {
        "everydayTaskCtrl": {"eventInfo": {DAILY_QUEST_FORGE_ID: 1}}
    }
    asyncio.run(bot.execute_tasks())

    # Check that ForgeEquipmentTask was evaluated and logged
    fe_logs = [l for l in logs if "[forge_equipment]" in l]
    runner.record(
        "1.6 bot.execute_tasks creates and executes ForgeEquipmentTask",
        len(fe_logs) > 0 and any("تم إنجاز" in l or "تخطي" in l or "completed" in l for l in fe_logs),
        f"Logged entries: {fe_logs}"
    )


# ═════════════════════════════════════════════════════════════════════════════
# SUITE 2: Dual-Save Equivalence & Non-Destructive Preservation
# ═════════════════════════════════════════════════════════════════════════════

def test_dual_save_equivalence():
    print("\n" + "="*70)
    print("SUITE 2: Dual-Save Simulation (performSave vs handleSave) & Preservation")
    print("="*70)

    import core.database as db

    castle_id = "sultan_beetoo2"
    castle = db.get_castle_by_id(castle_id)
    orig_config = dict(castle.get("config") or {})
    orig_keys = set(orig_config.keys())

    # Simulate performSave() payload (auto-save upon toggle):
    # Sends draft object with all registered fields explicitly
    auto_save_payload = {
        "fountain": orig_config.get("fountain"),
        "train": orig_config.get("train"),
        "shield": orig_config.get("shield"),
        "research": orig_config.get("research"),
        "flower": orig_config.get("flower"),
        "wonder_merchant": orig_config.get("wonder_merchant"),
        "material_synthesis": orig_config.get("material_synthesis"),
        "cure_wounded": orig_config.get("cure_wounded"),
        "alliance": orig_config.get("alliance"),
        "pet": orig_config.get("pet"),
        "forge_equipment": {"enabled": True, "category": "ring"},
    }

    req_auto = CastleUpdateRequest(config=CastleConfigModel(**auto_save_payload))
    clean_auto = dict(castle.get("config") or {})
    clean_auto.pop("pet_patrol", None)
    clean_auto.update(req_auto.config.model_dump(exclude_none=True))
    db.update_castle_db(castle_id, {"config": clean_auto})

    saved_auto = db.get_castle_by_id(castle_id).get("config")
    runner.record(
        "2.1 Auto-Save (performSave) saves clean state",
        saved_auto.get("forge_equipment") == {"enabled": True, "category": "ring"},
        f"forge_equipment: {saved_auto.get('forge_equipment')}"
    )

    # Simulate handleSave() payload (manual save button):
    # Uses conditional spread ...(forgeEquipmentConfig !== undefined ? { forge_equipment: forgeEquipmentConfig } : {})
    manual_save_payload = {
        "forge_equipment": {"enabled": True, "category": "ring"}
    }
    req_manual = CastleUpdateRequest(config=CastleConfigModel(**manual_save_payload))
    clean_manual = dict(saved_auto)
    clean_manual.pop("pet_patrol", None)
    clean_manual.update(req_manual.config.model_dump(exclude_none=True))
    db.update_castle_db(castle_id, {"config": clean_manual})

    saved_manual = db.get_castle_by_id(castle_id).get("config")
    runner.record(
        "2.2 Manual-Save (handleSave) equivalence",
        saved_manual == saved_auto,
        f"Configs equal: {saved_manual == saved_auto}"
    )

    # Verify NO keys were stripped or lost
    current_keys = set(saved_manual.keys())
    missing_keys = orig_keys - current_keys
    runner.record(
        "2.3 Non-Destructive Preservation: No previous tasks stripped",
        len(missing_keys) == 0,
        f"Orig keys: {len(orig_keys)}, Current keys: {len(current_keys)}, Missing: {missing_keys}"
    )

    # Verify specific core tasks remain completely intact
    core_tasks = ["fountain", "train", "shield", "flower", "wonder_merchant", "material_synthesis"]
    all_intact = all(t in saved_manual for t in core_tasks)
    runner.record(
        "2.4 Core tasks intact in database",
        all_intact,
        f"Verified tasks: {core_tasks}"
    )

    # 2.5 Verify update of ONLY castle_name preserves forge_equipment
    db.update_castle_db(castle_id, {"castle_name": "قلعة تجريبية جديدة"})
    c_after_name = db.get_castle_by_id(castle_id)
    fe_preserved = c_after_name.get("config", {}).get("forge_equipment") == {"enabled": True, "category": "ring"}
    runner.record(
        "2.5 Updating unrelated castle metadata preserves forge_equipment",
        fe_preserved,
        f"forge_equipment: {c_after_name.get('config', {}).get('forge_equipment')}"
    )


# ═════════════════════════════════════════════════════════════════════════════
# SUITE 3: Adversarial Input Fuzzing & Normalization Across Chain
# ═════════════════════════════════════════════════════════════════════════════

def test_adversarial_inputs():
    print("\n" + "="*70)
    print("SUITE 3: Adversarial Input Fuzzing & Schema Resilience")
    print("="*70)

    import core.database as db

    castle_id = "sultan_beetoo3"
    castle = db.get_castle_by_id(castle_id)

    fuzz_cases = [
        # (input_dict, expected_enabled, expected_category, test_name)
        ({"category": "  HELMET  "}, False, "helmet", "Whitespace & Uppercase Normalization ('  HELMET  ')"),
        ({"category": "RING"}, False, "ring", "Uppercase Normalization ('RING')"),
        ({"category": "  trousers \n\t"}, False, "trousers", "Newline/Tab Whitespace ('  trousers \\n\\t')"),
        ({"category": 9999}, False, "weapon", "Integer Category Fallback (9999 -> 'weapon')"),
        ({"category": None}, False, "weapon", "None Category Fallback (None -> 'weapon')"),
        ({"category": ""}, False, "weapon", "Empty String Category Fallback ('' -> 'weapon')"),
        ({"category": "hacked_category_xyz"}, False, "weapon", "Unknown Category Fallback ('hacked_category_xyz')"),
        ({"category": "weapon'; DROP TABLE castle_states; --"}, False, "weapon", "SQL Injection in category neutralized"),
        ({"category": "weapon" * 500}, False, "weapon", "Buffer Overflow Attempt in category (3000 chars)"),
        ({"enabled": "true", "category": "shoes"}, True, "shoes", "String Boolean ('true' -> True)"),
        ({"enabled": "false", "category": "clothes"}, False, "clothes", "String Boolean ('false' -> False)"),
        ({"enabled": 1, "category": "weapon"}, True, "weapon", "Integer Boolean (1 -> True)"),
        ({"enabled": 0, "category": "weapon"}, False, "weapon", "Integer Boolean (0 -> False)"),
    ]

    for idx, (inp, exp_en, exp_cat, desc) in enumerate(fuzz_cases, 1):
        try:
            cfg_model = ForgeEquipmentConfig(**inp)
            assert cfg_model.enabled == exp_en, f"Expected enabled={exp_en}, got {cfg_model.enabled}"
            assert cfg_model.category == exp_cat, f"Expected category={exp_cat}, got {cfg_model.category}"

            # Pass through CastleUpdateRequest
            req = CastleUpdateRequest(config=CastleConfigModel(forge_equipment=cfg_model))
            clean = dict(castle.get("config") or {})
            clean.update(req.config.model_dump(exclude_none=True))
            db.update_castle_db(castle_id, {"config": clean})

            reloaded = db.get_castle_by_id(castle_id).get("config", {}).get("forge_equipment")
            assert reloaded == {"enabled": exp_en, "category": exp_cat}, f"Reloaded mismatch: {reloaded}"

            runner.record(f"3.{idx} Fuzz: {desc}", True, f"Result: {reloaded}")
        except Exception as e:
            runner.record(f"3.{idx} Fuzz: {desc}", False, str(e))

    # Test invalid non-coercible boolean (e.g. "not-a-boolean")
    try:
        ForgeEquipmentConfig(enabled="not-a-boolean")
        runner.record("3.14 Non-coercible boolean rejected by Pydantic", False, "Should have raised ValidationError")
    except pydantic.ValidationError:
        runner.record("3.14 Non-coercible boolean safely rejected by Pydantic", True)
    except Exception as e:
        runner.record("3.14 Non-coercible boolean rejected by Pydantic", False, str(e))

    # Test all 6 valid categories round-trip
    all_categories = ["weapon", "clothes", "helmet", "trousers", "shoes", "ring"]
    for cat in all_categories:
        cfg = ForgeEquipmentConfig(enabled=True, category=cat)
        assert cfg.category == cat
    runner.record("3.15 All 6 valid equipment categories accepted cleanly", True)


# ═════════════════════════════════════════════════════════════════════════════
# SUITE 4: Live Memory Execution Behaviors
# ═════════════════════════════════════════════════════════════════════════════

def test_live_memory_behaviors():
    print("\n" + "="*70)
    print("SUITE 4: Live Memory Pre-flight & Execution Edge Cases")
    print("="*70)

    import core.database as db

    # 4.1 When disabled in DB, bot_manager skips execution without invoking task logic
    # sultan_LUCIFER has enabled: False in database
    bot_disabled = bot_manager.CastleBot(email="LUCIFER@g4.com", password="dummy")
    bot_disabled.config["task_delay_min_seconds"] = 0
    bot_disabled.config["task_delay_max_seconds"] = 0
    logs_disabled = []
    bot_disabled.log = lambda m: logs_disabled.append(m)
    bot_disabled.conn = MockConnection()
    asyncio.run(bot_disabled.execute_tasks())
    fe_skip = [l for l in logs_disabled if "[forge_equipment] تم التخطي" in l]
    runner.record(
        "4.1 bot_manager skips execution when task is disabled in config",
        len(fe_skip) > 0,
        f"Log: {fe_skip[0] if fe_skip else 'None'}"
    )

    # 4.2 0-Network Pre-flight: Quest 4100009 already finished today
    conn_preflight = MockConnection({
        "everydayTaskCtrl": {"eventInfo": {"4100009": 1}},
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "101", "lv": 10}},
                {"binfo": {"bid": "115", "lv": 10}},
            ],
            "reslist": {"1006": 50000}
        },
    })
    task_pf = ForgeEquipmentTask(conn_preflight, lambda m: None, {"enabled": True, "category": "weapon"})
    res_pf = asyncio.run(task_pf.safe_execute())
    runner.record(
        "4.2 0-Network Pre-flight skips immediately when 4100009 count >= 1",
        res_pf.skipped and ("completed" in res_pf.message.lower() or "تم إنجاز" in res_pf.message) and len(conn_preflight.queries_sent) == 0,
        f"Skipped: {res_pf.skipped}, Queries: {len(conn_preflight.queries_sent)}, Msg: {res_pf.message}"
    )

    # 4.3 0-Network Pre-flight: Blacksmith busy forging (endTime > now)
    conn_busy = MockConnection({
        "equipmentCtrl": {
            "equipment_array": [
                {"epid": 8881, "eid": 6100101, "endTime": int(time.time()) + 120, "wear": 0}
            ]
        },
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "101", "lv": 10}},
                {"binfo": {"bid": "115", "lv": 10}},
            ],
            "reslist": {"1006": 50000}
        },
    })
    task_busy = ForgeEquipmentTask(conn_busy, lambda m: None, {"enabled": True, "category": "weapon"})
    res_busy = asyncio.run(task_busy.safe_execute())
    runner.record(
        "4.3 0-Network Pre-flight skips when blacksmith is busy (endTime > now)",
        res_busy.skipped and "busy forging" in res_busy.message and len(conn_busy.queries_sent) == 0,
        f"Skipped: {res_busy.skipped}, Queries: {len(conn_busy.queries_sent)}, Msg: {res_busy.message}"
    )

    # 4.4 Ready piece waiting (0 < endTime <= now) -> sends CMD 1047 / SubCMD 2 (Collect)
    conn_ready = MockConnection({
        "equipmentCtrl": {
            "equipment_array": [
                {"epid": 9992, "eid": 6100101, "endTime": int(time.time()) - 10, "wear": 0}
            ]
        },
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "101", "lv": 10}},
                {"binfo": {"bid": "115", "lv": 10}},
            ],
            "reslist": {"1006": 50000}
        },
    })
    task_ready = ForgeEquipmentTask(conn_ready, lambda m: None, {"enabled": True, "category": "weapon"})
    res_ready = asyncio.run(task_ready.safe_execute())
    runner.record(
        "4.4 Ready piece collected via CMD 1047 / SubCMD 2 with memory sync",
        res_ready.success and len(conn_ready.queries_sent) == 1 and conn_ready.queries_sent[0]["sub_cmd"] == "2",
        f"Success: {res_ready.success}, Query: {conn_ready.queries_sent}"
    )

    # 4.5 Empty forge -> Crafts Level 1 item with lowest tier materials
    conn_craft = MockConnection({
        "equipmentCtrl": {"equipment_array": []},
        "cityCtrl": {
            "blist": [
                {"binfo": {"bid": "101", "lv": 10}},
                {"binfo": {"bid": "115", "lv": 10}},
            ],
            "reslist": {"1006": 5000},
        },
        "backpackCtrl": {
            "200601": {"id": 200601, "num": 5, "qly": 1},
            "200301": {"id": 200301, "num": 5, "qly": 1},
        }
    })
    task_craft = ForgeEquipmentTask(conn_craft, lambda m: None, {"enabled": True, "category": "weapon"})
    res_craft = asyncio.run(task_craft.safe_execute())
    runner.record(
        "4.5 Empty forge crafts Level 1 piece via CMD 1047 / SubCMD 1",
        res_craft.success and not res_craft.skipped and len(conn_craft.queries_sent) == 1 and conn_craft.queries_sent[0]["sub_cmd"] == "1",
        f"Success: {res_craft.success}, Skipped: {res_craft.skipped}, Query: {conn_craft.queries_sent}"
    )

    # 4.6 Fallback for legacy castle config missing forge_equipment key
    bot_legacy = bot_manager.CastleBot(email="legacy@test.com", password="dummy")
    # Verify legacy castle gets DEFAULT_BOT_CONFIG for forge_equipment
    assert "forge_equipment" in bot_legacy.config.get("tasks", {})
    runner.record(
        "4.6 Legacy castle config safely defaults forge_equipment to disabled",
        bot_legacy.config["tasks"]["forge_equipment"] == {"enabled": False, "category": "weapon"},
        f"Default config: {bot_legacy.config['tasks']['forge_equipment']}"
    )


# ═════════════════════════════════════════════════════════════════════════════
# SUITE 5: Production Database Forensic Verification
# ═════════════════════════════════════════════════════════════════════════════

def test_production_db_forensics():
    print("\n" + "="*70)
    print("SUITE 5: Production Database Forensic Audit (database/castles.db)")
    print("="*70)

    # Open strictly read-only connection to production database
    prod_uri = f"file:{os.path.abspath(PROD_DB_PATH)}?mode=ro"
    conn = sqlite3.connect(prod_uri, uri=True)
    cur = conn.cursor()

    # 1. PRAGMA integrity_check
    cur.execute("PRAGMA integrity_check;")
    integrity = cur.fetchall()
    runner.record(
        "5.1 Production SQLite PRAGMA integrity_check == 'ok'",
        integrity == [("ok",)],
        f"Integrity check: {integrity}"
    )

    # 2. Check total castles
    cur.execute("SELECT castle_id, email, config, is_active FROM castle_states;")
    rows = cur.fetchall()
    conn.close()

    runner.record(
        "5.2 Production database contains exactly 4 castles",
        len(rows) == 4,
        f"Total castles found: {len(rows)}"
    )

    expected_castles = {"sultan_beetoo1", "sultan_beetoo2", "sultan_beetoo3", "sultan_LUCIFER"}
    found_castles = {r[0] for r in rows}
    runner.record(
        "5.3 Expected 4 castle IDs match exactly",
        found_castles == expected_castles,
        f"Found: {found_castles}"
    )

    # 3. Check forge_equipment presence and valid structure in each castle
    all_castles_valid = True
    for cid, email, cfg_str, is_act in rows:
        try:
            cfg = json.loads(cfg_str)
            fe = cfg.get("forge_equipment")
            if not fe or fe.get("category") != "weapon" or fe.get("enabled") is not False:
                all_castles_valid = False
                break
        except Exception:
            all_castles_valid = False
            break

    runner.record(
        "5.4 All 4 castles have forge_equipment: {'enabled': False, 'category': 'weapon'}",
        all_castles_valid,
        f"Verified 4/4 castles in production database"
    )


# ═════════════════════════════════════════════════════════════════════════════
# Main Execution
# ═════════════════════════════════════════════════════════════════════════════

def main():
    print("Starting Pipeline E2E Adversarial Integration Stress Harness...")
    setup_test_db()

    try:
        test_full_round_trip()
        test_dual_save_equivalence()
        test_adversarial_inputs()
        test_live_memory_behaviors()
    finally:
        teardown_test_db()

    # Production DB forensics runs outside test DB isolation
    test_production_db_forensics()

    print("\n" + "="*70)
    print("FINAL TEST HARNESS SUMMARY")
    print("="*70)
    print(f"Total Tests Executed: {runner.passed + runner.failed}")
    print(f"PASSED: {runner.passed}")
    print(f"FAILED: {runner.failed}")

    if runner.failed == 0:
        print("\n>>> FINAL VERDICT: APPROVE <<<")
        print("All pipeline layers verified 100% robust, non-destructive, and resilient.")
        return 0
    else:
        print("\n>>> FINAL VERDICT: REJECT <<<")
        print(f"Harness detected {runner.failed} failure(s).")
        return 1


if __name__ == "__main__":
    code = main()
    sys.exit(code)
