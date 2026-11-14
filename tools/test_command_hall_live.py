# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

import asyncio
import json
import core.database as db
from bot_manager import CastleBot

async def test_cmd_hall():
    # Find an active account from database
    castles = db.get_all_castles()
    email = None
    for c in castles:
        if c.get("password") and c.get("enabled"):
            email = c.get("email")
            break
    if not email and castles:
        email = castles[0].get("email")

    print(f"Testing with castle: {email}")
    bot = CastleBot(email=email, log_callback=lambda m: print("[BOT]", m))
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return

    conn = bot.conn
    print("Connected successfully!")
    cmd_keys = [k for k in conn.init_data.keys() if 'command' in k.lower() or 'hall' in k.lower()]
    print("Matching keys in init_data:", cmd_keys)

    # Let's test safe_query for CMD 2274 SubCMD 1 (REQ_COMMAND_HALL_INIT)
    print("Testing safe_query CMD 2274 SUBCMD 1...")
    res = await conn.safe_query("2274", "1", {}, timeout=10)
    print("CMD 2274 SUBCMD 1 response:")
    print(json.dumps(res, indent=2, ensure_ascii=False))

    await conn.close()

if __name__ == "__main__":
    asyncio.run(test_cmd_hall())
