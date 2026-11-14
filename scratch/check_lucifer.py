# -*- coding: utf-8 -*-
import asyncio
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

import core.database as db
from bot_manager import CastleBot
from tasks.command_hall import CommandHallTask


async def check_lucifer():
    bot = CastleBot(email="LUCIFER@g4.com", log_callback=lambda m: None)
    c_data = db.get_castle_by_id("LUCIFER@g4.com")
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    print(f"LUCIFER Troops: {task.available_troops_count}")
    print(f"LUCIFER Marches: {task.available_marches}")
    print(f"LUCIFER Stamina: {task.current_stamina}")

    base = conn.init_data.get("lordInfoCtrl", {}).get("base", {})
    print(f"LUCIFER Gold: {base.get('gold')}")

    await conn.close()


if __name__ == "__main__":
    asyncio.run(check_lucifer())
