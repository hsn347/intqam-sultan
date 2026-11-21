import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
rows = c.execute("SELECT castle_id, email, castle_name, castle_info FROM castle_states").fetchall()
for cid, email, cname, cinfo_str in rows:
    cinfo = json.loads(cinfo_str) if cinfo_str else {}
    print(f"Castle: {cid} | {email} | {cname} | info: {cinfo.get('castle_level')}, lord_lv: {cinfo.get('lord_level')}")
