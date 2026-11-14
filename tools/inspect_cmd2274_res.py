# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot

async def inspect_cmd2274():
    email = sys.argv[1] if len(sys.argv) > 1 else "beetoo1@hotmail.com"
    bot = CastleBot(email=email)
    bot.is_running = True
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return

    conn = bot.conn
    print("Keys in init_data with 'hall' or 'cmd' or '2274':")
    for k in conn.init_data.keys():
        if any(w in k.lower() for w in ["hall", "cmd", "command", "task", "quest"]):
            print(f"  • {k}")

    print("\nSending safe_query(2274, 1, {})...")
    res = await conn.query("2274", "1", {})
    print("Exact Response:")
    print(json.dumps(res, indent=2, ensure_ascii=False))

    await conn.close()

if __name__ == "__main__":
    asyncio.run(inspect_cmd2274())
