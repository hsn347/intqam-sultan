# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db
from tools.test_base_task import BaseTaskHarness

async def main():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok: return
    task = BaseTaskHarness(bot.conn, log_func=lambda m: None, config=bot.config)
    await task.sync_local_queues(timeout=3.0)
    await task.sync_achievements(timeout=3.0)
    
    conn = task.conn
    
    # Save the entire init_data to a json file to inspect completely!
    clean_init = {}
    for k, v in conn.init_data.items():
        try:
            json.dumps(v)
            clean_init[k] = v
        except Exception:
            clean_init[k] = str(v)

    with open("tools/beetoo2_full_init_data.json", "w", encoding="utf-8") as f:
        json.dump(clean_init, f, ensure_ascii=False, indent=2)

    print("Saved full init_data to tools/beetoo2_full_init_data.json")

    if bot.conn:
        await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
