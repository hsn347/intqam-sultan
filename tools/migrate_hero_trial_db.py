# -*- coding: utf-8 -*-
"""
tools/migrate_hero_trial_db.py — ترحيل قاعدة البيانات لإضافة مفتاح hero_trial لكافة القلاع
══════════════════════════════════════════════════════════════════════════════════════
يقرأ كل سجل في جدول castle_states داخل database/castles.db ويضيف مفتاح hero_trial: {"enabled": False}
إذا لم يكن موجوداً، مع الحفاظ الكامل على كافة الإعدادات الحالية دون أي مساس بها.
"""

import json
import os
import sqlite3
import sys

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")


def migrate():
    print(f"Connecting to database: {DB_PATH}")
    if not os.path.exists(DB_PATH):
        print(f"ERROR: Database file {DB_PATH} not found!")
        sys.exit(1)

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cursor.fetchall()
    print(f"Found {len(rows)} castles in database.")

    updated_count = 0
    for castle_id, email, config_str in rows:
        try:
            cfg = json.loads(config_str) if config_str else {}
        except Exception as e:
            print(f"Warning: Corrupted config for castle {castle_id}: {e}")
            cfg = {}

        if "hero_trial" not in cfg:
            cfg["hero_trial"] = {"enabled": False}
            new_config_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (new_config_str, castle_id)
            )
            updated_count += 1

    conn.commit()
    conn.close()
    print(f"Successfully migrated {updated_count} castles with hero_trial default config.")


if __name__ == "__main__":
    migrate()

