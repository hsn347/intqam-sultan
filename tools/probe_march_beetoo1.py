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


async def probe_beetoo1():
    email = "beetoo1@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    # Check city position
    city = conn.init_data.get("cityCtrl", {})
    print("City x, y:", city.get("x"), city.get("y"))

    # Check Command Hall
    task = CommandHallTask(conn, config={"enabled": True})
    res = await conn.query("2274", "1", {})
    init_data = res.get("rspdata", {}).get("initData", {}) or res.get("data", {})
    task_list = task._extract_task_list(init_data)
    print("Tasks:", json.dumps(task_list, ensure_ascii=False, indent=2))

    t4 = [t for t in task_list if t.get("index") == 4]
    if t4:
        obj = t4[0].get("obj", {})
        print("Task 4 obj:", obj)
        # Test Subcmd 10 (REQ_COMMAND_HALL_REFRESH_POS2)
        print("Testing Subcmd 10 with obj...")
        res10 = await conn.query("2274", "10", {"x": obj.get("x"), "y": obj.get("y")})
        print("Subcmd 10 response:", res10)

        # Also test Subcmd 9 (REQ_COMMAND_HALL_REFRESH_POS)
        print("Testing Subcmd 9 with obj...")
        res9 = await conn.query("2274", "9", {"x": obj.get("x"), "y": obj.get("y")})
        print("Subcmd 9 response:", res9)

    await conn.close()


if __name__ == "__main__":
    asyncio.run(probe_beetoo1())
