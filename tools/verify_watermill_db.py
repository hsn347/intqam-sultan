# -*- coding: utf-8 -*-
import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
cursor = conn.cursor()
cursor.execute("SELECT castle_id, castle_name, config FROM castle_states")
rows = cursor.fetchall()

print(f"Total castles in DB: {len(rows)}")
for cid, cname, cfg_str in rows:
    cfg = json.loads(cfg_str)
    wm = cfg.get("watermill")
    tasks_wm = cfg.get("tasks", {}).get("watermill")
    print(f"Castle {cid} ({cname}):")
    print(f"  root watermill: {wm}")
    print(f"  tasks.watermill: {tasks_wm}")
    assert wm is not None, f"watermill missing in root of castle {cid}"
    assert wm.get("enabled") is False
    assert "food" in wm.get("resources", [])

conn.close()
print("100% DIRECT DB INSPECTION VERIFIED SUCCESSFULLY!")
