# -*- coding: utf-8 -*-
"""
tools/migrate_command_hall_config.py
سكربت ترحيل قاعدة البيانات لإضافة إعدادات مهمة قاعة القيادة (command_hall) بالقيم الافتراضية لكافة القلاع.
"""

import json
import sqlite3
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(_ROOT, "database", "castles.db")

DEFAULT_COMMAND_HALL_CONFIG = {
    "enabled": False,
    "mode": "daily",
    "allow_marches": True,
    "allow_snipe": True,
    "allow_rescue": True,
    "allow_dialogue": True,
    "allow_army_group": True,
    "auto_claim_rewards": True,
    "auto_upgrade_hall": True,
    "min_safety_stamina": 10,
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
        if "command_hall" not in cfg or not isinstance(cfg["command_hall"], dict):
            cfg["command_hall"] = dict(DEFAULT_COMMAND_HALL_CONFIG)
            changed = True
        else:
            # ضمان اكتمال المفاتيح وتفعيل المسير الافتراضي
            for k, v in DEFAULT_COMMAND_HALL_CONFIG.items():
                if k not in cfg["command_hall"]:
                    cfg["command_hall"][k] = v
                    changed = True
            if cfg["command_hall"].get("allow_marches") is False:
                cfg["command_hall"]["allow_marches"] = True
                changed = True
            if "allow_snipe" not in cfg["command_hall"]:
                cfg["command_hall"]["allow_snipe"] = True
                changed = True
            if "allow_rescue" not in cfg["command_hall"]:
                cfg["command_hall"]["allow_rescue"] = True
                changed = True
            if "allow_dialogue" not in cfg["command_hall"]:
                cfg["command_hall"]["allow_dialogue"] = True
                changed = True
            if "allow_army_group" not in cfg["command_hall"]:
                cfg["command_hall"]["allow_army_group"] = True
                changed = True

        # إضافة الإعداد في كائن tasks الفرعي إن وجد
        if "tasks" in cfg and isinstance(cfg["tasks"], dict):
            if "command_hall" not in cfg["tasks"] or not isinstance(cfg["tasks"]["command_hall"], dict):
                cfg["tasks"]["command_hall"] = dict(DEFAULT_COMMAND_HALL_CONFIG)
                changed = True
            else:
                for k, v in DEFAULT_COMMAND_HALL_CONFIG.items():
                    if k not in cfg["tasks"]["command_hall"]:
                        cfg["tasks"]["command_hall"][k] = v
                        changed = True
                if cfg["tasks"]["command_hall"].get("allow_marches") is False:
                    cfg["tasks"]["command_hall"]["allow_marches"] = True
                    changed = True
                if "allow_snipe" not in cfg["tasks"]["command_hall"]:
                    cfg["tasks"]["command_hall"]["allow_snipe"] = True
                    changed = True
                if "allow_rescue" not in cfg["tasks"]["command_hall"]:
                    cfg["tasks"]["command_hall"]["allow_rescue"] = True
                    changed = True
                if "allow_dialogue" not in cfg["tasks"]["command_hall"]:
                    cfg["tasks"]["command_hall"]["allow_dialogue"] = True
                    changed = True
                if "allow_army_group" not in cfg["tasks"]["command_hall"]:
                    cfg["tasks"]["command_hall"]["allow_army_group"] = True
                    changed = True

        if changed:
            new_config_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (new_config_str, castle_id)
            )
            updated_count += 1
            print(f"  [+] Updated castle: {castle_name} ({castle_id}) with command_hall config.")

    conn.commit()
    conn.close()
    print(f"[*] Migration completed. Updated {updated_count}/{len(rows)} castles.")

if __name__ == "__main__":
    migrate()
