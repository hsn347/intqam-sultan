import sqlite3
import json

db_path = 'database/castles.db'
conn = sqlite3.connect(db_path)
c = conn.cursor()

c.execute("SELECT castle_id, user_id, config FROM castle_states")
rows = c.fetchall()
print(f"Total castles to check/migrate: {len(rows)}")

updated_count = 0
for cid, uid, cfg_json in rows:
    cfg = json.loads(cfg_json) if cfg_json else {}
    if "caravan" not in cfg or not isinstance(cfg.get("caravan"), dict):
        cfg["caravan"] = {"enabled": False}
        new_json = json.dumps(cfg, ensure_ascii=False)
        c.execute("UPDATE castle_states SET config = ? WHERE castle_id = ? AND user_id = ?", (new_json, cid, uid))
        updated_count += 1
        print(f"  [Updated] Castle {cid} with default caravan config")
    else:
        print(f"  [OK] Castle {cid} already has caravan config: {cfg['caravan']}")

conn.commit()
conn.close()
print(f"Migration completed successfully. Updated: {updated_count}/{len(rows)} castles.")
