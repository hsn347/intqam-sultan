import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("SELECT castle_id, email, castle_name FROM castle_states")
for r in c.fetchall():
    print(r)
