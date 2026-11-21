import sqlite3

conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
tables = c.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
print("Tables:", tables)
for t in tables:
    tname = t[0]
    schema = c.execute(f"PRAGMA table_info({tname})").fetchall()
    print(f"Schema for {tname}: {[col[1] for col in schema]}")
