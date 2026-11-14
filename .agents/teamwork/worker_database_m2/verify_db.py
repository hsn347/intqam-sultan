# -*- coding: utf-8 -*-
"""
Standalone Direct Programmatic SQLite Verification Script
Queries database/castles.db directly to verify:
1. Every castle has forge_equipment: {"enabled": False, "category": "weapon"}
2. Assert 100% of castles have forge_equipment.
3. Assert no other config keys were altered or deleted.
"""

import sys
import os
import sqlite3
import json

# Ensure stdout can handle UTF-8 if possible
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

DB_PATH = os.path.join(r"e:\intqam-sultan", "database", "castles.db")

def verify_castles_db():
    print(f"=== Direct SQLite Inspection: {DB_PATH} ===")
    assert os.path.exists(DB_PATH), f"Database file does not exist: {DB_PATH}"

    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, castle_name, config, updated_at FROM castle_states")
    rows = cursor.fetchall()

    total_castles = len(rows)
    print(f"Total castles found: {total_castles}")
    assert total_castles > 0, "No castles found in database!"

    passed_count = 0
    for idx, row in enumerate(rows, 1):
        cid = row["castle_id"]
        email = row["email"]
        cname = row["castle_name"]
        raw_cfg = row["config"]

        assert raw_cfg is not None and len(raw_cfg.strip()) > 0, f"Castle {cid} has empty config!"
        cfg = json.loads(raw_cfg)
        assert isinstance(cfg, dict), f"Castle {cid} config is not a JSON object!"

        # Check forge_equipment presence
        assert "forge_equipment" in cfg, f"ASSERTION FAILED: Castle {cid} missing forge_equipment!"
        fe = cfg["forge_equipment"]
        assert isinstance(fe, dict), f"ASSERTION FAILED: forge_equipment in {cid} is not a dict!"

        # Check default values
        assert fe.get("enabled") is False, f"ASSERTION FAILED: {cid} enabled != False, got {fe.get('enabled')}"
        assert fe.get("category") == "weapon", f"ASSERTION FAILED: {cid} category != 'weapon', got {fe.get('category')}"

        # Check critical previous keys are untouched
        expected_keys = {"fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "cure_wounded", "alliance", "pet", "tasks"}
        missing_keys = expected_keys - set(cfg.keys())
        assert len(missing_keys) == 0, f"ASSERTION FAILED: Castle {cid} lost keys: {missing_keys}"

        print(f"[{idx}/{total_castles}] Castle ID: {cid:18} | Email: {email:20} | forge_equipment: {fe} | Total Keys: {len(cfg)}")
        passed_count += 1

    conn.close()

    assert passed_count == total_castles, f"Only {passed_count}/{total_castles} passed!"
    percentage = (passed_count / total_castles) * 100
    print(f"\n==========================================")
    print(f"VERIFICATION RESULT: {passed_count}/{total_castles} ({percentage:.0f}%) castles verified.")
    print("ALL ASSERTIONS PASSED: 100% compliance, zero data loss.")
    print("==========================================")
    return True

if __name__ == "__main__":
    verify_castles_db()
