import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db

async def print_responses():
    email = "beetoo1@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None

    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn: return

    conn = bot.conn
    try:
        r_kl = await conn.query("2054", "1", {})
        print("1. KL Response Data:", json.dumps(r_kl.get("data"), ensure_ascii=False))

        r_nt = await conn.query("2258", "1", {})
        print("2. NT Response Data:", json.dumps(r_nt.get("rspdata") or r_nt.get("data"), ensure_ascii=False))

        r_hb = await conn.query("2164", "1", {})
        print("3. HB Response Data:", json.dumps(r_hb.get("rspdata") or r_hb.get("data"), ensure_ascii=False))
    finally:
        await bot.stop()

if __name__ == "__main__":
    asyncio.run(print_responses())
