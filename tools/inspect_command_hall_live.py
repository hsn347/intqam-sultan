# -*- coding: utf-8 -*-
"""
tools/inspect_command_hall_live.py
Directly inspects the live Command Hall data from the game server.
"""

import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db


async def inspect_live(email="beetoo1@hotmail.com"):
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print(f"Failed to connect to {email}!")
        return

    conn = bot.conn
    try:
        # 1. Check everydayTaskCtrl in live memory
        everyday = conn.init_data.get("everydayTaskCtrl", {})
        event_info = everyday.get("eventInfo", {}) if isinstance(everyday, dict) else {}
        print("=== EVERYDAY TASK EVENT INFO ===")
        print(f"Task 33 progress: {event_info.get('33', 'Not found')}")
        print(f"All everyday eventInfo: {json.dumps(event_info, ensure_ascii=False)}")

        # 2. Check CMD 2274 / SUBCMD 1
        resp = await conn.query("2274", "1", {})
        print("\n=== CMD 2274 / 1 RESPONSE ===")
        print(json.dumps(resp, ensure_ascii=False, indent=2))

    finally:
        await conn.close()


if __name__ == "__main__":
    email = sys.argv[1] if len(sys.argv) > 1 else "beetoo1@hotmail.com"
    asyncio.run(inspect_live(email))
