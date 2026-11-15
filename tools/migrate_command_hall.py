# -*- coding: utf-8 -*-
"""
Database Migration: Standardize command_hall config in database/castles.db
"""

import json
import sqlite3

DEFAULT_COMMAND_HALL_CONFIG = {
    "enabled": False,
    "mode": "daily",
    "allow_marches": True,
    "auto_claim_rewards": True,
    "auto_upgrade_hall": True,
    "min_safety_stamina": 10,
}

def migrate():
    conn = sqlite3.connect("database/castles.db")
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()

    updated_count = 0
    for cid, em, cfg_str in rows:
        cfg = json.loads(cfg_str or "{}")
        ch_cfg = cfg.get("command_hall")
        if not isinstance(ch_cfg, dict):
            ch_cfg = dict(DEFAULT_COMMAND_HALL_CONFIG)
            cfg["command_hall"] = ch_cfg
            updated_count += 1
        else:
            changed = False
            for k, v in DEFAULT_COMMAND_HALL_CONFIG.items():
                if k not in ch_cfg:
                    ch_cfg[k] = v
                    changed = True
            if changed:
                cfg["command_hall"] = ch_cfg
                updated_count += 1

        cur.execute("UPDATE castle_states SET config = ? WHERE castle_id = ?", (json.dumps(cfg, ensure_ascii=False), cid))

    conn.commit()
    conn.close()
    print(f"Migration complete: updated {updated_count}/{len(rows)} castles.")

if __name__ == "__main__":
    migrate()
