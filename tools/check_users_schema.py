import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("PRAGMA table_info(users)")
for r in c.fetchall():
    print(r)
