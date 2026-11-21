import os
import sys
import json
import asyncio

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if ROOT_DIR not in sys.path:
    sys.path.insert(0, ROOT_DIR)

import core.database as db
from bot_manager import CastleBot

async def test_god_arms():
    email = "beetoo1@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect.")
        return

    try:
        # Request CMD_GOD_ARMS_MODULE (2122) / REQ_GOD_ARMS_INIT (1)
        print("🚨⚠️🚨 [Diagnostic] Sending CMD_GOD_ARMS_MODULE (2122) / REQ_GOD_ARMS_INIT (1)...")
        res = await bot.conn.query("2122", "1", {}, timeout=8.0)
        print("\n=== GOD ARMS RESPONSE ===")
        print(json.dumps(res, ensure_ascii=False, indent=2))
        
        # Save to file
        with open(os.path.join(ROOT_DIR, "tools", "god_arms_response.json"), "w", encoding="utf-8") as fp:
            json.dump(res, fp, ensure_ascii=False, indent=2)
            
    finally:
        await bot.stop()

if __name__ == "__main__":
    asyncio.run(test_god_arms())
