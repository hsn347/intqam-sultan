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


async def check_wave():
    bot = CastleBot(email="beetoo3@hotmail.com", log_callback=lambda m: None)
    c_data = db.get_castle_by_id("beetoo3@hotmail.com")
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    task = CommandHallTask(conn, config={"enabled": True})
    res = await conn.query("2274", "1", {})
    init_data = res.get("rspdata", {}).get("initData", {}) or res.get("data", {})
    print(f"armyGroupID: {init_data.get('armyGroupID')}")
    tasks = task._extract_task_list(init_data)
    print(f"Tasks in wave: {len(tasks)}")
    for t in tasks:
        print(f"  • Task index={t.get('index')}, type={t.get('type')}, statue={t.get('statue')}, obj={t.get('obj')}")

    await conn.close()

if __name__ == "__main__":
    asyncio.run(check_wave())
