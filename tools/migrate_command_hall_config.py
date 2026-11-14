# -*- coding: utf-8 -*-
"""
tools/migrate_command_hall_config.py
سكربت ترحيل وتحديث حقل config لكافة القلاع في database/castles.db بإعداد command_hall.
يضمن وجود "command_hall": {"enabled": False} في كل من root config و config["tasks"].
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

        needs_update = False

        # 1. Root level
        if "command_hall" not in cfg or not isinstance(cfg["command_hall"], dict):
            cfg["command_hall"] = {"enabled": False}
            needs_update = True

        # 2. Inside config["tasks"] (يجب أن يتطابق تماماً مع إعداد الجذر لتفادي أي تعارض)
        tasks_section = cfg.setdefault("tasks", {})
        if not isinstance(tasks_section, dict):
            cfg["tasks"] = {}
            tasks_section = cfg["tasks"]

        if tasks_section.get("command_hall") != cfg["command_hall"]:
            tasks_section["command_hall"] = dict(cfg["command_hall"])
            needs_update = True

        if needs_update:
            cur.execute(
                "UPDATE castle_states SET config = ? WHERE castle_id = ?",
                (json.dumps(cfg, ensure_ascii=False), cid)
            )
            updated += 1
            print(f"  ✓ Updated castle {email} ({cid}) with command_hall config.")

    conn.commit()

    # Direct programmatic verification check: 100% castles verified in SQLite
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    verified_rows = cur.fetchall()
    missing = []
    for cid, email, cfg_str in verified_rows:
        try:
            cfg = json.loads(cfg_str or "{}") if isinstance(cfg_str, str) else (cfg_str or {})
        except Exception:
            cfg = {}

        has_root = "command_hall" in cfg and isinstance(cfg["command_hall"], dict)
        tasks_sec = cfg.get("tasks", {})
        has_tasks = isinstance(tasks_sec, dict) and "command_hall" in tasks_sec and isinstance(tasks_sec["command_hall"], dict)

        if not (has_root and has_tasks):
            missing.append((cid, email))

    conn.close()

    if missing:
        print(f"❌ Migration verification failed! {len(missing)} castles missing command_hall: {missing}")
        return 1

    print(f"✅ Migration successful! {updated} castles updated. 100% ({len(verified_rows)}/{len(verified_rows)}) castles have command_hall configured in both config and config['tasks'].")
    return 0


if __name__ == "__main__":
    sys.exit(migrate())
