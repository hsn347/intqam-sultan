# -*- coding: utf-8 -*-
"""
tools/verify_stamina_db.py — فحص مباشر وتدقيق 100% لوجود مفتاح stamina وقيمه في قاعدة البيانات
════════════════════════════════════════════════════════════════════════════════════════════════
ينفذ بروتوكول حماية قاعدة البيانات ومنع ضياع الإعدادات (Rule 5 Zero-Loss Protocol).
"""

import json
import os
import sqlite3
import sys

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

REQUIRED_STAMINA_FIELDS = {
    "enabled": bool,
    "min_stamina": int,
    "mode": str,
    "pack_tier": str,
    "pack_count": int,
    "allow_buy": bool,
    "max_gold_daily": int,
}

def verify():
    if not os.path.exists(DB_PATH):
        print(f"[FAIL] Database file not found at {DB_PATH}")
        return False

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Discover tables with config column
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
    tables = [row[0] for row in cursor.fetchall()]
    print(f"Discovered tables in database: {tables}")

    target_table = "castle_states" if "castle_states" in tables else "castles"
    print(f"Reading from table: {target_table}")

    cursor.execute(f"SELECT castle_id, email, config FROM {target_table}")
    rows = cursor.fetchall()

    if not rows:
        print("[WARNING] No castle records found in database!")
        conn.close()
        return False

    all_ok = True
    print(f"\n{'='*70}")
    print(f"DIRECT DATABASE INSPECTION: STAMINA CONFIG CHECK ({len(rows)} castles)")
    print(f"{'='*70}")

    for idx, (castle_id, email, cfg_raw) in enumerate(rows, 1):
        try:
            cfg = json.loads(cfg_raw) if cfg_raw else {}
        except Exception as e:
            print(f"[{idx}] ❌ Castle {email} ({castle_id}): Invalid JSON: {e}")
            all_ok = False
            continue

        has_root = "stamina" in cfg
        has_tasks = "stamina" in cfg.get("tasks", {})

        stamina_cfg = cfg.get("stamina") or cfg.get("tasks", {}).get("stamina")

        if not stamina_cfg or not isinstance(stamina_cfg, dict):
            print(f"[{idx}] ❌ Castle {email} ({castle_id}): Missing stamina dict (root={has_root}, tasks={has_tasks})")
            all_ok = False
            continue

        missing_fields = []
        type_mismatches = []
        for field, expected_type in REQUIRED_STAMINA_FIELDS.items():
            if field not in stamina_cfg:
                missing_fields.append(field)
            elif not isinstance(stamina_cfg[field], expected_type):
                # Allow int for float or bool if type matches expected loosely, but check rigorously
                if expected_type is int and isinstance(stamina_cfg[field], (int, float)):
                    pass
                else:
                    type_mismatches.append(f"{field} (expected {expected_type.__name__}, got {type(stamina_cfg[field]).__name__})")

        if missing_fields or type_mismatches:
            print(f"[{idx}] ❌ Castle {email} ({castle_id}): Schema issues!")
            if missing_fields:
                print(f"       Missing fields: {missing_fields}")
            if type_mismatches:
                print(f"       Type mismatches: {type_mismatches}")
            all_ok = False
        else:
            print(f"[{idx}] ✅ Castle {email} ({castle_id}): PASS (root={has_root}, tasks={has_tasks})")
            print(f"       Config: {stamina_cfg}")

    conn.close()
    print(f"{'='*70}")
    if all_ok:
        print(f"🎉 100% OF CASTLES VERIFIED: 'stamina' config intact and valid across all records!")
    else:
        print(f"❌ DATABASE VERIFICATION FAILED: Some records missing or invalid 'stamina' config!")
    print(f"{'='*70}\n")
    return all_ok


if __name__ == "__main__":
    success = verify()
    sys.exit(0 if success else 1)
