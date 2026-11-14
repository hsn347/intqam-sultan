import sqlite3
import json

db_path = "database/castles.db"
conn = sqlite3.connect(db_path)
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

# 1. Tables list
cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
tables = [r[0] for r in cursor.fetchall()]
print(f"Tables in DB: {tables}")

# 2. Columns in castle_states
cursor.execute("PRAGMA table_info(castle_states)")
cols = [dict(r) for r in cursor.fetchall()]
print(f"\nColumns in castle_states:")
for col in cols:
    print(f"  - {col['name']} ({col['type']})")

# 3. Castle rows
cursor.execute("SELECT castle_id, email, castle_name, is_active, config FROM castle_states")
castles = cursor.fetchall()
print(f"\nTotal castles count: {len(castles)}")
for idx, c in enumerate(castles, 1):
    cfg_raw = c["config"]
    try:
        cfg = json.loads(cfg_raw) if cfg_raw else {}
    except Exception as e:
        cfg = f"ERROR: {e}"
    print(f"\n--- Castle #{idx} ---")
    print(f"ID: {c['castle_id']}")
    print(f"Email: {c['email']}")
    print(f"Name: {c['castle_name']}")
    print(f"Active: {c['is_active']}")
    if isinstance(cfg, dict):
        print(f"Config Keys ({len(cfg)}): {list(cfg.keys())}")
        print(f"Config JSON: {json.dumps(cfg, indent=2, ensure_ascii=False)}")
    else:
        print(f"Config: {cfg}")

conn.close()
