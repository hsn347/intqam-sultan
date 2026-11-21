import sqlite3
import json
import sys
import os

sys.path.insert(0, os.path.abspath('.'))

# 1. Direct DB Inspection
conn = sqlite3.connect('database/castles.db')
c = conn.cursor()
c.execute("SELECT castle_id, user_id, config FROM castle_states")
rows = c.fetchall()

print("=== 1. Direct DB Inspection ===")
print(f"Total castles in DB: {len(rows)}")
for cid, uid, cfg_json in rows:
    cfg = json.loads(cfg_json) if cfg_json else {}
    if "caravan" not in cfg:
        print(f"ERROR: Castle {cid} missing 'caravan' key!")
        sys.exit(1)
    print(f"  [PASS] Castle {cid}: caravan = {cfg['caravan']}")
conn.close()

# 2. Test api_server CastleConfigModel validation
print("\n=== 2. API Server Pydantic Whitelist Test ===")
from api_server import CastleConfigModel
model = CastleConfigModel(caravan={"enabled": True})
dump = model.model_dump(exclude_none=True)
if "caravan" not in dump or dump["caravan"]["enabled"] is not True:
    print(f"ERROR: CastleConfigModel failed to preserve caravan: {dump}")
    sys.exit(1)
print(f"  [PASS] Pydantic model successfully validated and serialized caravan: {dump['caravan']}")

# 3. Test bot_manager DEFAULT_BOT_CONFIG
print("\n=== 3. Bot Manager Defaults Test ===")
from bot_manager import DEFAULT_BOT_CONFIG
if "caravan" not in DEFAULT_BOT_CONFIG.get("tasks", {}):
    print("ERROR: caravan not in DEFAULT_BOT_CONFIG['tasks']!")
    sys.exit(1)
print(f"  [PASS] DEFAULT_BOT_CONFIG['tasks']['caravan']: {DEFAULT_BOT_CONFIG['tasks']['caravan']}")

print("\nALL FORENSIC CHECKS PASSED 100%!")
