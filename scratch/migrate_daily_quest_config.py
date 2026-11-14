# -*- coding: utf-8 -*-
"""
tools/migrate_daily_quest_config.py
سكربت ترحيل وتحديث حقل config لكافة القلاع في database/castles.db بإعداد daily_quest.
"""

import json
import os
import sqlite3
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(_ROOT, "database", "castles.db")

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


def migrate() -> int:
    if not os.path.exists(DB_PATH):
        print(f"❌ Database not found at {DB_PATH}")
        return 1

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()

    print(f"📊 Found {len(rows)} castles in database.")
    updated = 0

    for cid, email, cfg_str in rows:
        try:
            cfg = json.loads(cfg_str or "{}") if isinstance(cfg_str, str) else (cfg_str or {})
        except Exception:
            cfg = {}

        if "daily_quest" not in cfg:
            cfg["daily_quest"] = {"enabled": True}
            cur.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), cid)
            )
            updated += 1
            print(f"  ✓ Updated castle {email} ({cid}) with daily_quest config.")

    conn.commit()

    # Direct verification check: 100% castles verified
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    verified_rows = cur.fetchall()
    missing = []
    for cid, email, cfg_str in verified_rows:
        try:
            cfg = json.loads(cfg_str or "{}") if isinstance(cfg_str, str) else (cfg_str or {})
        except Exception:
            cfg = {}
        if "daily_quest" not in cfg or not isinstance(cfg["daily_quest"], dict):
            missing.append((cid, email))

    conn.close()

    if missing:
        print(f"❌ Migration verification failed! {len(missing)} castles missing daily_quest: {missing}")
        return 1

    print(f"✅ Migration successful! {updated} castles updated. 100% ({len(verified_rows)}/{len(verified_rows)}) castles have daily_quest configured.")
    return 0


if __name__ == "__main__":
    sys.exit(migrate())
