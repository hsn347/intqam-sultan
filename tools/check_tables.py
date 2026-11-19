import sqlite3

conn = sqlite3.connect(r"e:\intqam-sultan\database\castles.db")
c = conn.cursor()
c.execute("SELECT name FROM sqlite_master WHERE type='table'")
print(c.fetchall())
