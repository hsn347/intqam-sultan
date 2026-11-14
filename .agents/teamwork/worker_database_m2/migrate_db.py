# -*- coding: utf-8 -*-
"""
Database Migration Script for Forge Equipment
Updates all castle rows in database/castles.db adding:
forge_equipment: {"enabled": False, "category": "weapon"}
Zero-loss guaranteed with automatic pre-backup and verification.
"""

import sys
import os
import shutil
import sqlite3
import json
from datetime import datetime, timezone

# Ensure stdout can handle UTF-8 if possible
if sys.stdout.encoding and sys.stdout.encoding.lower() != "utf-8":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
    except Exception:
        pass

DB_PATH = os.path.join(r"e:\intqam-sultan", "database", "castles.db")

def run_migration():
    if not os.path.exists(DB_PATH):
        raise FileNotFoundError(f"Database file not found at: {DB_PATH}")

    # 1. Create timestamped backup file
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{DB_PATH}.bak_{timestamp}"
    shutil.copy2(DB_PATH, backup_path)
    print(f"[OK] Created backup at: {backup_path}")

    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    try:
        # Snapshot existing data for zero-loss verification
        cursor.execute("SELECT castle_id, config FROM castle_states")
        original_rows = cursor.fetchall()
        print(f"[*] Found {len(original_rows)} castles to migrate.")

        snapshots = {}
        for r in original_rows:
            cid = r["castle_id"]
            cfg_raw = r["config"]
            cfg = json.loads(cfg_raw) if cfg_raw else {}
            snapshots[cid] = cfg

        now_iso = datetime.now(timezone.utc).isoformat()
        updated_count = 0

        # Update each castle
        for cid, original_cfg in snapshots.items():
            new_cfg = dict(original_cfg)
            if "forge_equipment" not in new_cfg or not isinstance(new_cfg["forge_equipment"], dict):
                new_cfg["forge_equipment"] = {"enabled": False, "category": "weapon"}
            else:
                new_cfg["forge_equipment"].setdefault("enabled", False)
                new_cfg["forge_equipment"].setdefault("category", "weapon")

            new_cfg_str = json.dumps(new_cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ?, updated_at = ? WHERE castle_id = ?",
                (new_cfg_str, now_iso, cid)
            )
            updated_count += 1

        conn.commit()
        print(f"[OK] Successfully committed updates for {updated_count} castles.")

        # 2. Strict Verification
        cursor.execute("SELECT castle_id, config FROM castle_states")
        verified_rows = cursor.fetchall()
        assert len(verified_rows) == len(original_rows), "Castle count mismatch after migration!"

        for vr in verified_rows:
            cid = vr["castle_id"]
            v_cfg = json.loads(vr["config"])
            orig_cfg = snapshots[cid]

            # Verify forge_equipment presence and values
            assert "forge_equipment" in v_cfg, f"Castle {cid} missing forge_equipment!"
            assert v_cfg["forge_equipment"]["enabled"] is False, f"Castle {cid} enabled != False"
            assert v_cfg["forge_equipment"]["category"] == "weapon", f"Castle {cid} category != 'weapon'"

            # Verify ZERO LOSS: all original keys and values are identical
            for orig_key, orig_val in orig_cfg.items():
                if orig_key == "forge_equipment":
                    continue
                assert orig_key in v_cfg, f"Castle {cid} lost key: {orig_key}"
                assert v_cfg[orig_key] == orig_val, f"Castle {cid} key {orig_key} value was modified!"

            # Verify no unexpected keys were added
            expected_keys = set(orig_cfg.keys()) | {"forge_equipment"}
            assert set(v_cfg.keys()) == expected_keys, f"Castle {cid} has unexpected keys: {set(v_cfg.keys()) - expected_keys}"

        print(f"[SUCCESS] Post-migration verification PASSED: 100% of castles migrated, 0 data loss.")
        return backup_path

    except Exception as e:
        conn.rollback()
        print(f"[FAIL] Migration failed: {e}")
        print(f"[!] Restoring database from backup: {backup_path}")
        shutil.copy2(backup_path, DB_PATH)
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    b_path = run_migration()
    print(f"Migration completed successfully. Backup retained at: {b_path}")
