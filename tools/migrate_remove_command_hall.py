# -*- coding: utf-8 -*-
"""
tools/migrate_remove_command_hall.py
سكربت ترحيل قاعدة البيانات لحذف إعدادات مهمة قاعة القيادة (command_hall) نهائياً من كافة القلاع.
"""

import json
import sqlite3
import os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), "database", "castles.db")

def migrate():
    if not os.path.exists(DB_PATH):
        print(f"[!] Database file not found at: {DB_PATH}")
        return

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT castle_id, castle_name, config FROM castle_states")
    rows = cursor.fetchall()

    print(f"[*] Found {len(rows)} castles in database.")
    updated_count = 0

    for castle_id, castle_name, config_raw in rows:
        try:
            cfg = json.loads(config_raw) if config_raw else {}
        except Exception as e:
            print(f"[!] Error decoding JSON for castle {castle_id}: {e}")
            continue

        changed = False
        if "command_hall" in cfg:
            del cfg["command_hall"]
            changed = True

        if "tasks" in cfg and isinstance(cfg["tasks"], dict) and "command_hall" in cfg["tasks"]:
            del cfg["tasks"]["command_hall"]
            changed = True

        if changed:
            new_config_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (new_config_str, castle_id)
            )
            updated_count += 1
            print(f"  [+] Purged command_hall from castle: {castle_name} ({castle_id})")

    conn.commit()
    conn.close()
    print(f"[*] Migration completed. Updated {updated_count}/{len(rows)} castles.")

if __name__ == "__main__":
    migrate()
