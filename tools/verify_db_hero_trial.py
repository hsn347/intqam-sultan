# -*- coding: utf-8 -*-
import json
import sqlite3

conn = sqlite3.connect('database/castles.db')
cursor = conn.cursor()
cursor.execute('SELECT castle_id, email, config FROM castle_states')
rows = cursor.fetchall()
for cid, email, cfg_str in rows:
    cfg = json.loads(cfg_str)
    assert 'hero_trial' in cfg, f'hero_trial missing in {cid}'
    print(f"✓ Verified {cid} ({email}): hero_trial={cfg['hero_trial']}")
conn.close()
print("All castles verified 100% in database/castles.db!")

