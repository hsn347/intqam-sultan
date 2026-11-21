import sqlite3
import json

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
tables = c.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
print("Tables:", tables)

for t in tables:
    t_name = t[0]
    print(f"\n--- Table: {t_name} ---")
    cols = [d[1] for d in c.execute(f"PRAGMA table_info({t_name})").fetchall()]
    print("Columns:", cols)
    rows = c.execute(f"SELECT * FROM {t_name} LIMIT 5").fetchall()
    for r in rows:
        print(r)
