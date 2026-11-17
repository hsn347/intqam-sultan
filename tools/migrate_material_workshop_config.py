# -*- coding: utf-8 -*-
"""
tools/migrate_material_workshop_config.py — ترحيل قاعدة البيانات لإضافة إعدادات معمل المواد (material_workshop)
"""

import json
import sqlite3
import os
import sys

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

DEFAULT_MATERIAL_WORKSHOP_CONFIG = {
    "enabled": False,
    "selected_materials": [200101, 200201, 200301, 200401, 200501, 200601],
}

def migrate():
    print(f"Connecting to database: {DB_PATH}")
    if not os.path.exists(DB_PATH):
        print(f"Error: Database file not found at {DB_PATH}")
        sys.exit(1)

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"Total castles found: {len(rows)}")

    updated_count = 0

    for castle_id, email, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception:
            cfg = {}

        needs_update = False

        if "material_workshop" not in cfg:
            cfg["material_workshop"] = dict(DEFAULT_MATERIAL_WORKSHOP_CONFIG)
            needs_update = True

        tasks_dict = cfg.setdefault("tasks", {})
        if not isinstance(tasks_dict, dict):
            tasks_dict = {}
            cfg["tasks"] = tasks_dict
            needs_update = True

        if "material_workshop" not in tasks_dict:
            tasks_dict["material_workshop"] = dict(DEFAULT_MATERIAL_WORKSHOP_CONFIG)
            needs_update = True

        if needs_update:
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), castle_id),
            )
            updated_count += 1
            print(f"  -> Migrated castle: {email} ({castle_id})")

    conn.commit()
    conn.close()
    print(f"Migration completed. Castles updated: {updated_count}/{len(rows)}")

if __name__ == "__main__":
    migrate()
