import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("PRAGMA table_info(castle_states)")
for r in c.fetchall():
    print(r)
print("--- Sample data ---")
c.execute("SELECT castle_id, kingdom, lord_name FROM castle_states")
for r in c.fetchall():
    print(r)
