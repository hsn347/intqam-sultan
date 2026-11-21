import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
c.execute('SELECT email, config FROM castle_states WHERE email="beetoo1@hotmail.com"')
row = c.fetchone()
if row:
    print("Email:", row[0])
    cfg = json.loads(row[1]) if row[1] else {}
    print("Config keys:", list(cfg.keys()))
    # print any march related config
    for k, v in cfg.items():
        if 'march' in k.lower() or 'troop' in k.lower() or 'army' in k.lower() or 'capacity' in k.lower():
            print(k, ':', v)
