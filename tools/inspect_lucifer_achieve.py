import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import asyncio
import json
from bot_manager import CastleBot
import core.database as db

async def inspect():
    c_data = db.get_castle_by_id("LUCIFER@g4.coom")
    pwd = c_data.get("password")
    bot = CastleBot(email="LUCIFER@g4.coom", password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        return
    
    conn = bot.conn
    ach = conn.init_data.get('achievementctrl')
    print("achievementctrl in init_data:", json.dumps(ach, indent=2))
    
    # Also sync achievements and check response
    from tasks.base_task import BaseTask
    class DummyTask(BaseTask):
        name = "dummy"
        async def run(self): pass
    
    task = DummyTask(conn=conn)
    vip_buff = task.get_vip_march_buff()
    print("vip_buff:", vip_buff)
    print("vip_level:", task.vip_level)
    print("is_vip_active:", task.is_vip_active)
    print("vip_end_time:", task.vip_end_time)

    # Check pet buff
    pet_ctrl = conn.init_data.get('petCtrl') or {}
    print("petCtrl:", json.dumps(pet_ctrl, indent=2))

    await conn.close()

if __name__ == '__main__':
    asyncio.run(inspect())
