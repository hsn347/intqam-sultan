# -*- coding: utf-8 -*-
"""
tools/test_finish_task_live.py
Test finishing an instant task on beetoo3.
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
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    conn = bot.conn
    try:
        # Check beetoo1 boss
        r1 = await conn.query("2274", "1", {})
        ag = r1.get("rspdata", {}).get("initData", {}).get("armyGroupTaskData", {})
        print("Current Army Group on beetoo1:", json.dumps(ag, ensure_ascii=False))

        # Attack army group
        print("Attacking Army Group...")
        r_atk = await conn.query("2274", "7", {})
        print("Attack result:", json.dumps(r_atk, ensure_ascii=False, indent=2))

        # Commit army group
        ag_idx = ag.get("index", 3)
        print(f"Committing Army Group index {ag_idx}...")
        r_commit = await conn.query("2274", "8", {"commitType": 1, "index": ag_idx})
        print("Commit result:", json.dumps(r_commit, ensure_ascii=False, indent=2))

        # Check new state
        r_after = await conn.query("2274", "1", {})
        new_init = r_after.get("rspdata", {}).get("initData", {})
        print("\n=== NEW STATE ON BEETOO1 ===")
        print(f"ArmyGroupID: {new_init.get('armyGroupID')}")
        print(f"Common tasks count: {len(new_init.get('commonTaskData', []))}")
        print(f"ArmyPioneerTask: {json.dumps(new_init.get('armyPioneerTaskData', {}), ensure_ascii=False)}")
    finally:
        await conn.close()
        await conn.close()


if __name__ == "__main__":
    asyncio.run(test_finish())
