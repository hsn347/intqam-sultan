# -*- coding: utf-8 -*-
"""
tools/verify_material_workshop.py — فحص مستقل وشامل لمهمة معمل المواد وقاعدة البيانات والواجهة
"""

import json
import sqlite3
import os
import sys

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(BASE_DIR, "database", "castles.db")

def verify_database():
    print("=== 1. Direct DB Inspection (Rule 5) ===")
    if not os.path.exists(DB_PATH):
        print(f"FAIL: Database file not found at {DB_PATH}")
        return False

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"Total castles in DB: {len(rows)}")

    all_ok = True
    for cid, email, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception as e:
            print(f"FAIL: Castle {cid} ({email}) invalid JSON: {e}")
            all_ok = False
            continue

        mw = cfg.get("material_workshop")
        if not mw or not isinstance(mw, dict):
            print(f"FAIL: Castle {cid} ({email}) missing 'material_workshop' in root config")
            all_ok = False
            continue

        if "enabled" not in mw or "selected_materials" not in mw:
            print(f"FAIL: Castle {cid} ({email}) missing required keys in material_workshop: {mw}")
            all_ok = False
            continue

        if not isinstance(mw["selected_materials"], list) or len(mw["selected_materials"]) != 6:
            print(f"FAIL: Castle {cid} ({email}) invalid selected_materials list: {mw['selected_materials']}")
            all_ok = False
            continue

        # Check tasks.material_workshop if present
        tasks = cfg.get("tasks", {})
        if "material_workshop" not in tasks:
            print(f"FAIL: Castle {cid} ({email}) missing 'material_workshop' in tasks sub-dictionary")
            all_ok = False
            continue

    if all_ok and len(rows) > 0:
        print(f"SUCCESS: 100% of castles ({len(rows)}/{len(rows)}) have valid 'material_workshop' config in database/castles.db!")
        return True
    return False

if __name__ == "__main__":
    db_pass = verify_database()
    if not db_pass:
        sys.exit(1)
