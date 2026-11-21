import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
c.execute("SELECT email, castle_info FROM castle_states WHERE email LIKE '%beetoo2%'")
row = c.fetchone()
if row:
    print(f"Email: {row[0]}")
    print("castle_info:", json.dumps(json.loads(row[1]), indent=2, ensure_ascii=False))
conn.close()
