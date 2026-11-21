# -*- coding: utf-8 -*-
import sqlite3
import json
import sys

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

conn = sqlite3.connect("database/castles.db")
c = conn.cursor()
c.execute("SELECT email, config FROM castle_states WHERE email LIKE '%beetoo3%'")
row = c.fetchone()
cfg = json.loads(row[1]) if row else {}
print("beetoo3 skills config:", json.dumps(cfg.get("skills", {}), indent=2, ensure_ascii=False))
