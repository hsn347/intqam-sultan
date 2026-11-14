# -*- coding: utf-8 -*-
"""Pre-migration inspection script"""
import os
import sqlite3
import json

DB_PATH = os.path.join(r"e:\intqam-sultan", "database", "castles.db")

conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

cursor.execute("SELECT castle_id, email, castle_name, config FROM castle_states")
rows = cursor.fetchall()
print(f"Total castles in DB: {len(rows)}")

for r in rows:
    cfg = json.loads(r["config"]) if r["config"] else {}
    print(f"\nCastle: ID={r['castle_id']}, Email={r['email']}, Name={r['castle_name']}")
    print(f"Config keys ({len(cfg)}): {list(cfg.keys())}")
    print(f"Has forge_equipment: {'forge_equipment' in cfg}")

conn.close()
