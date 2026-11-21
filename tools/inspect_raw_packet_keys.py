# -*- coding: utf-8 -*-
import asyncio
import sys
import os
import json
sys.path.insert(0, os.path.abspath("."))
from bot_manager import CastleBot
import core.database as db
from core.live_memory import LiveMemoryEngine

captured_data = {}
orig_extract = LiveMemoryEngine.extract_controllers

def my_extract(self, packet):
    data = packet.get("data", {})
    if isinstance(data, dict):
        for k in ["dressCtrl", "militaryRankCtrl", "parliamentCtrl", "warGemCtrl", "miraculousWeaponCtrl", "magicLampCtrl", "divineBeastCtrl"]:
            if k in data:
                captured_data[k] = data[k]
        retdata = data.get("retdata", {})
        if isinstance(retdata, dict):
            for k in ["dressCtrl", "militaryRankCtrl", "parliamentCtrl", "warGemCtrl", "miraculousWeaponCtrl", "magicLampCtrl", "divineBeastCtrl"]:
                if k in retdata:
                    captured_data[k] = retdata[k]
    return orig_extract(self, packet)

LiveMemoryEngine.extract_controllers = my_extract

async def check():
    c_data = db.get_castle_by_id('LUCIFER@g4.coom')
    bot = CastleBot(email='LUCIFER@g4.coom', password=c_data['password'], log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    
    print("=== INSPECTING STRIPPED CONTROLLERS ON LUCIFER ===")
    for k, val in captured_data.items():
        print(f"\n--- {k} ---")
        if isinstance(val, dict):
            print(f"dict keys: {list(val.keys())}")
            # print dump of small dict or items
            print(json.dumps(val, ensure_ascii=False, indent=2)[:500])
        elif isinstance(val, list):
            print(f"list len: {len(val)}")
            print(json.dumps(val[:3], ensure_ascii=False, indent=2))
        else:
            print(val)
            
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
