import sqlite3, json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
c.execute("SELECT castle_id, user_id, config FROM castle_states")
rows = c.fetchall()
print(f"Total rows: {len(rows)}")
for cid, uid, cfg_json in rows:
    cfg = json.loads(cfg_json) if cfg_json else {}
    print(f"Castle {cid}: caravan in cfg = {'caravan' in cfg}, val = {cfg.get('caravan')}")
conn.close()
