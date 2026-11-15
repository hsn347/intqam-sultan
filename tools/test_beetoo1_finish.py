# -*- coding: utf-8 -*-
"""
tools/test_beetoo1_finish.py
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

async def test_finish():
    email = "beetoo1@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    try:
        # Check task 10 (rescue)
        print("Finishing task 10 (rescue)...")
        r1 = await conn.query("2274", "5", {"index": 10})
        print("Finish 10 err:", r1.get("err"))
        r2 = await conn.query("2274", "8", {"commitType": 4, "index": 10})
        print("Commit 10 err:", r2.get("err"), "reward:", r2.get("rspdata", {}).get("reward"))

        # Check task 11 (dialogue)
        print("Finishing task 11 (dialogue)...")
        r3 = await conn.query("2274", "5", {"index": 11})
        print("Finish 11 err:", r3.get("err"))
        r4 = await conn.query("2274", "8", {"commitType": 3, "index": 11})
        print("Commit 11 err:", r4.get("err"), "reward:", r4.get("rspdata", {}).get("reward"))

        # Query everydayTaskCtrl via 2027/1
        r_day = await conn.query("2027", "1", {})
        ev_info = r_day.get("data", {}).get("eventInfo", {})
        print("Everyday eventInfo task 33:", ev_info.get("33"))
        print("All eventInfo:", ev_info)

    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(test_finish())
