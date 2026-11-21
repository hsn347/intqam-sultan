import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import asyncio
import json
from bot_manager import CastleBot
import core.database as db

async def inspect_lucifer_dress():
    c_data = db.get_castle_by_id("LUCIFER@g4.coom")
    if not c_data:
        print("LUCIFER account not found in database!")
        return

    pwd = c_data.get("password")
    print(f"Connecting to account: LUCIFER@g4.coom...")
    bot = CastleBot(email="LUCIFER@g4.coom", password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    conn = bot.conn
    # Check init_data
    print("\n--- CONTROLLERS IN INIT_DATA ---")
    controllers = list(conn.init_data.keys())
    print(f"Total controllers in init_data: {len(controllers)}")
    
    # Check dressCtrl
    dress_ctrl = conn.init_data.get('dressCtrl')
    print("dressCtrl in init_data:", json.dumps(dress_ctrl, indent=2))

    await conn.close()

if __name__ == '__main__':
    asyncio.run(inspect_lucifer_dress())
