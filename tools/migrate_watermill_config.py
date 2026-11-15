# -*- coding: utf-8 -*-
"""
tools/migrate_watermill_config.py
سكربت ترحيل قاعدة البيانات لإضافة إعدادات مهمة مكافأة الطاحونة (watermill) بالقيم الافتراضية لكافة القلاع.
"""

import json
import sqlite3
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(_ROOT, "database", "castles.db")

DEFAULT_WATERMILL_CONFIG = {
    "enabled": False,
    "resources": ["food", "wood", "iron", "silver"],
    "types": "all",
}

def migrate():
    if not os.path.exists(DB_PATH):
        print(f"[!] Database file not found at: {DB_PATH}")
        sys.exit(1)

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
            print(f"[!] JSON parse error for castle {castle_id}: {e}")
            continue

        changed = False

        # إضافة الإعداد في الجذر
        if "watermill" not in cfg or not isinstance(cfg["watermill"], dict):
            cfg["watermill"] = dict(DEFAULT_WATERMILL_CONFIG)
            changed = True
        else:
            for k, v in DEFAULT_WATERMILL_CONFIG.items():
                if k not in cfg["watermill"]:
                    cfg["watermill"][k] = v
                    changed = True

        # إضافة الإعداد في كائن tasks الفرعي إن وجد
        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "watermill" not in cfg["tasks"] or not isinstance(cfg["tasks"]["watermill"], dict):
                cfg["tasks"]["watermill"] = dict(DEFAULT_WATERMILL_CONFIG)
                changed = True
            else:
                for k, v in DEFAULT_WATERMILL_CONFIG.items():
                    if k not in cfg["tasks"]["watermill"]:
                        cfg["tasks"]["watermill"][k] = v
                        changed = True

        if changed:
            new_config_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (new_config_str, castle_id)
            )
            updated_count += 1

    conn.commit()
    conn.close()
    print(f"[+] Successfully migrated {updated_count}/{len(rows)} castles in {DB_PATH}.")

if __name__ == '__main__':
    migrate()
