# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db

async def run():
    email = "beetoo2@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        return

    conn = bot.conn
    try:
        init_data = conn.init_data
        hero_sys = init_data.get("heroSysCtrl", {})
        hero_list = hero_sys.get("heroList", {})
        for hid in ["1712", "1711", "1707", "1717", "1708", "1700"]:
            h = hero_list.get(hid)
            if h:
                print(f"=== HERO {hid} ===")
                print("quality:", h.get("quality"))
                print("level:", h.get("level"))
                print("skillList:", json.dumps(h.get("skillList"), indent=2))
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(run())
