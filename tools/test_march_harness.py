# -*- coding: utf-8 -*-
import asyncio
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db
from tasks.base_task import BaseTask

class TestHarness(BaseTask):
    def __init__(self, conn):
        super().__init__(conn, log_func=print)
    async def run(self):
        pass

async def main():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return
    await asyncio.sleep(2.0)
    task = TestHarness(bot.conn)
    
    print("\n--- TEST BASE TASK GET_MAX_MARCH_CAPACITY ---")
    bare = task.get_max_march_capacity(heroes="none", breakdown=True)
    print("Bare breakdown:")
    for k, v in bare.items():
        print(f"  {k}: {v}")
        
    print("\nAuto heroes breakdown:")
    auto = task.get_max_march_capacity(heroes=None, breakdown=True)
    for k, v in auto.items():
        print(f"  {k}: {v}")
        
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
