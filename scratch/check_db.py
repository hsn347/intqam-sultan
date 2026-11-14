import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
cursor = conn.cursor()
cursor.execute("SELECT castle_id, castle_name, config FROM castle_states LIMIT 1;")
row = cursor.fetchone()
if row:
    cid, name, cfg_str = row
    cfg = json.loads(cfg_str) if cfg_str else {}
    print(f"Castle {cid} ({name}) config keys:", list(cfg.keys()))
    print("daily_train:", cfg.get("daily_train"))
    print("daily_quest:", cfg.get("daily_quest"))
conn.close()
