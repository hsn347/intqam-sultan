# -*- coding: utf-8 -*-
"""
tools/migrate_skills_config.py — ترحيل قاعدة البيانات لإضافة إعدادات مهارات الأمير (skills)
"""

import json
import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

def migrate():
    print(f"Connecting to database: {DB_PATH}")
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"Total castles found: {len(rows)}")

    updated_count = 0
    default_skills = {"enabled": False, "target_skills": []}

    for castle_id, email, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception:
            cfg = {}

        needs_update = False

        if "skills" not in cfg:
            cfg["skills"] = default_skills
            needs_update = True

        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "skills" not in cfg["tasks"]:
                cfg["tasks"]["skills"] = default_skills
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
