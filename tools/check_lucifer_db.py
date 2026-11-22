import sqlite3

con = sqlite3.connect("database/castles.db")
cur = con.cursor()
r = cur.execute("SELECT castle_id, email, castle_name, castle_info, updated_at FROM castle_states WHERE castle_id='sultan_LUCIFER'").fetchone()
print("Lucifer row:")
print("castle_id:", r[0])
print("email:", r[1])
print("name:", r[2])
print("updated_at:", r[4])
print("castle_info:", r[3])


