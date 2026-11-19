import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("SELECT id, email, kingdom FROM users")
for r in c.fetchall():
    print(r)
