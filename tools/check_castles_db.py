import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("SELECT email, kingdom, lord_name FROM castles")
for row in c.fetchall():
    print(row)
