# -*- coding: utf-8 -*-
"""
tools/inspect_live_command_hall_state.py
Inspects live command hall state across all castles in castles.db.
"""

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


async def inspect_castle_cmd_hall(email: str):
    print(f"\n{'='*70}\n🏰 Inspecting Command Hall for: {email}\n{'='*70}")
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print(f"❌ Failed to connect to {email}")
        return

    conn = bot.conn
    task = CommandHallTask(conn, config={"enabled": True})

    res = await conn.query("2274", "1", {})
    init_data = res.get("rspdata", {}).get("initData", {}) or res.get("data", {})

    print(f"armyGroupID: {init_data.get('armyGroupID')}")
    print(f"hallLevel: {init_data.get('hallLevel')}")
    print(f"score: {init_data.get('score')}")
    print(f"rebelArmyGroup: {init_data.get('rebelArmyGroup')}")
    
    tasks = task._extract_task_list(init_data)
    print(f"Total subtasks extracted: {len(tasks)}")
    for t in tasks:
        idx = t.get("index")
        tp = t.get("type")
        st = t.get("statue")
        obj = t.get("obj")
        print(f"  • Task index={idx}, type={tp}, statue={st}, obj={obj}")

    await conn.close()


async def main():
    for email in ["beetoo3@hotmail.com", "beetoo2@hotmail.com", "beetoo1@hotmail.com", "LUCIFER@g4.com"]:
        try:
            await inspect_castle_cmd_hall(email)
        except Exception as e:
            print(f"Error on {email}: {e}")


if __name__ == "__main__":
    asyncio.run(main())
