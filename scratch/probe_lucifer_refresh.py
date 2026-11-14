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
from tasks.command_hall import CommandHallTask


async def probe():
    bot = CastleBot(email="LUCIFER@g4.com", log_callback=lambda m: None)
    c_data = db.get_castle_by_id("LUCIFER@g4.com")
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    res = await conn.query("2274", "1", {})
    init_data = res.get("rspdata", {}).get("initData", {}) or res.get("data", {})
    tasks = task._extract_task_list(init_data)
    for t in tasks:
        if t.get("type") in (2, 5):
            idx = t.get("index")
            obj = t.get("obj", {})
            print(f"Combat Task {idx}: obj={obj}")
            res9 = await conn.query("2274", "9", {"x": obj.get("x"), "y": obj.get("y")})
            print(f"Subcmd 9 for {idx}: {res9}")

    await conn.close()


if __name__ == "__main__":
    asyncio.run(probe())
