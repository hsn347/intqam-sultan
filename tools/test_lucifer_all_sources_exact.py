# -*- coding: utf-8 -*-
import asyncio
import sys
import os
import json
sys.path.insert(0, os.path.abspath("."))
from bot_manager import CastleBot
import core.database as db
from core.live_memory import LiveMemoryEngine

raw_packets = []
orig_extract = LiveMemoryEngine.extract_controllers

def my_extract(self, packet):
    raw_packets.append(packet)
    return orig_extract(self, packet)

LiveMemoryEngine.extract_controllers = my_extract

async def check():
    c_data = db.get_castle_by_id('LUCIFER@g4.coom')
    bot = CastleBot(email='LUCIFER@g4.coom', password=c_data['password'], log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    
    # Save the entire raw packet data from CMD 1000 subcmd 1
    p1000 = None
    for p in raw_packets:
        if str(p.get("cmd")) in ("1000", "onemt_1000") or p.get("_session") == 0:
            p1000 = p
            break
            
    if p1000:
        data = p1000.get("data", {})
        retdata = data.get("retdata", {}) if isinstance(data, dict) else {}
        all_controllers = {}
        if isinstance(data, dict):
            all_controllers.update(data)
        if isinstance(retdata, dict):
            all_controllers.update(retdata)
            
        print(f"Captured {len(all_controllers)} total controllers in CMD 1000!")
        
        # Search for any value 96 or 19 or march keywords across ALL controllers!
        print("\n--- Scanning for march keywords in raw controllers ---")
        march_findings = []
        for cname, cval in all_controllers.items():
            s = json.dumps(cval, ensure_ascii=False)
            for kw in ["march", "army", "troop", "capacity", "expArmy"]:
                if kw in s.lower():
                    # check what keys
                    march_findings.append((cname, kw, len(s)))
                    break
        print("Controllers with march/troop/army keywords:")
        for cf in march_findings:
            print(f"  {cf[0]} ({cf[1]}, len={cf[2]})")
            
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
