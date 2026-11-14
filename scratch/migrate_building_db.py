import sqlite3
import json
import os

db_path = r'e:\intqam-sultan\database\castles.db'
if not os.path.exists(db_path):
    print("DB not found at:", db_path)
    exit(1)

conn = sqlite3.connect(db_path)
cur = conn.cursor()

cur.execute("SELECT email, config FROM castle_states")
rows = cur.fetchall()

default_building = {
    "enabled": False,
    "upgrade_castle": True,
    "speedup_castle": False,
    "auto_open_chests": True,
    "upgrade_support_buildings": True,
    "target_buildings": {
        "farm": True,
        "sawmill": True,
        "iron_mine": True,
        "quartz_mine": True,
        "hospital": True,
        "military_tent": True
    }
}

migrated = 0
for email, cfg_raw in rows:
    try:
        cfg = json.loads(cfg_raw) if isinstance(cfg_raw, str) else (cfg_raw or {})
    except Exception:
        cfg = {}
    
    if "building" not in cfg or not isinstance(cfg["building"], dict):
        cfg["building"] = default_building
        migrated += 1
    else:
        # merge missing keys
        for k, v in default_building.items():
            if k not in cfg["building"]:
                cfg["building"][k] = v
                migrated += 1
                
    cur.execute("UPDATE castle_states SET config = ? WHERE email = ?", (json.dumps(cfg, ensure_ascii=False), email))

conn.commit()
print(f"Migrated {migrated} castle records.")

# Verification
cur.execute("SELECT email, config FROM castle_states")
all_rows = cur.fetchall()
verified_count = 0
for email, cfg_raw in all_rows:
    cfg = json.loads(cfg_raw) if isinstance(cfg_raw, str) else cfg_raw
    bld = cfg.get("building")
    assert bld is not None and isinstance(bld, dict), f"Failed for {email}"
    assert "enabled" in bld, f"Failed enabled for {email}"
    verified_count += 1

print(f"VERIFIED 100%: All {verified_count}/{len(all_rows)} castles have valid 'building' in config!")
conn.close()

