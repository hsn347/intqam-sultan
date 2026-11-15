# -*- coding: utf-8 -*-
"""
tools/test_boss_live.py
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

async def test_boss(email="beetoo1@hotmail.com"):
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    assert ok and bot.conn
    conn = bot.conn

    try:
        # Check current state
        res1 = await conn.query("2274", "1", {})
        ag = res1.get("rspdata", {}).get("initData", {}).get("armyGroupTaskData", {})
        print("Initial armyGroupTaskData:", ag)
        
        # Test calling REQ 7
        print("Calling REQ 7 (attackArmyGroup)...")
        r7 = await conn.query("2274", "7", {
            "armyInfo": [],
            "heroInfo": [],
            "armsInfo": [],
            "divineBeastInfo": []
        })
        print("REQ 7 response err:", r7.get("err"))
        print("REQ 7 response:", json.dumps(r7, ensure_ascii=False))

        # Test calling REQ 8
        print("Calling REQ 8 (commitTask)...")
        r8 = await conn.query("2274", "8", {
            "commitType": 1,
            "index": ag.get("index", 3)
        })
        print("REQ 8 response err:", r8.get("err"))
        print("REQ 8 response:", json.dumps(r8, ensure_ascii=False))

        # Check state after
        res2 = await conn.query("2274", "1", {})
        init2 = res2.get("rspdata", {}).get("initData", {})
        print("ArmyGroupID after:", init2.get("armyGroupID"))
        print("armyGroupTaskData after:", init2.get("armyGroupTaskData"))
        print("commonTaskData after:", init2.get("commonTaskData"))

    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(test_boss())
