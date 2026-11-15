# -*- coding: utf-8 -*-
"""
tools/test_march_live.py
Test combat march for command hall task on beetoo1.
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


async def test_march():
    email = "beetoo1@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    conn = bot.conn
    try:
        # 1. Get task 8 (pioneer)
        r1 = await conn.query("2274", "1", {})
        init_data = r1.get("rspdata", {}).get("initData", {})
        pioneer = init_data.get("armyPioneerTaskData", {})
        print("Pioneer task:", json.dumps(pioneer, ensure_ascii=False))

        # Check army
        army_ctrl = conn.init_data.get("armyCtrl", {})
        total_army = army_ctrl.get("totalArmy", {})
        soldier_id = None
        for k, v in total_army.items():
            if int(k) < 800 and int(v) > 0:
                soldier_id = int(k)
                break
        print(f"Using soldier id: {soldier_id}")

        # Send march 1007 / 2
        # Structure from worldMapFunction:
        # 1. Refresh pos 2 (CMD 2274 / 10)
        print("Refreshing Pos2 (CMD 2274 / 10)...")
        r_pos = await conn.query("2274", "10", pioneer.get("obj", {}))
        print("Refresh Pos2 response:", json.dumps(r_pos, ensure_ascii=False, indent=2))
    finally:
        await conn.close()


if __name__ == "__main__":
    asyncio.run(test_march())
