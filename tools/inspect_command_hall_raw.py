# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db
from tasks.command_hall import CommandHallTask

async def inspect():
    email = "beetoo3@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return
    task = CommandHallTask(bot.conn)
    tasks_res = await task.get_command_hall_tasks(force_sync=True)
    ch_data = bot.conn.init_data.get("commandHall", {})
    print("=== COMMAND HALL KEYS ===")
    print(list(ch_data.keys()))
    print("\n=== ARMY GROUP TASK DATA ===")
    print(json.dumps(ch_data.get("armyGroupTaskData"), indent=2, ensure_ascii=False))
    print("\n=== ARMY PIONEER TASK DATA ===")
    print(json.dumps(ch_data.get("armyPioneerTaskData"), indent=2, ensure_ascii=False))
    print("\n=== TOMORROW ARMY GROUP TASK DATA ===")
    print(json.dumps(ch_data.get("tomorrowArmyGroupTaskData"), indent=2, ensure_ascii=False))
    print("\n=== COMMON TASK DATA (Count: {}) ===".format(len(ch_data.get("commonTaskData", []))))
    for t in ch_data.get("commonTaskData", []):
        print("  Index: {}, Type: {}, TaskID: {}, Statue: {}".format(t.get("index"), t.get("type"), t.get("taskID"), t.get("statue")))
    print("\n=== NEXT REFRESH TIME ===")
    print(ch_data.get("nextRefreshTime"))
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(inspect())
