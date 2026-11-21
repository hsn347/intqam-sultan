# -*- coding: utf-8 -*-
import asyncio
import sys
import os
import json

sys.path.insert(0, os.path.abspath("."))
from bot_manager import CastleBot
import core.database as db

async def main():
    c_data = db.get_castle_by_id("LUCIFER@g4.coom")
    b = CastleBot(email="LUCIFER@g4.coom", password=c_data.get("password"), log_callback=lambda m: None)
    b.is_running = True
    await b.connect()
    init = b.conn.init_data
    
    print("=== LUCIFER FULL AUDIT ===")
    lord = init.get("lordInfoCtrl") or {}
    print("Lord Level:", lord.get("base", {}).get("level"))
    print("Lord VIP:", lord.get("base", {}).get("vip"))
    print("Lord VIP EndTime:", lord.get("base", {}).get("vipEndTime"))
    print("Lord Name:", lord.get("base", {}).get("name"))
    print("Lord Castle Lv:", lord.get("base", {}).get("castleLevel"))
    
    # Check Drill Grounds
    city = init.get("cityCtrl") or {}
    blist = city.get("blist", [])
    drill = [b["binfo"] for b in blist if b.get("binfo", {}).get("bid") == 121]
    print("\nDrill Grounds (121):", drill)
    
    # Check Wall (102), Castle (101), Miracle (301)
    important_bids = [101, 102, 107, 108, 114, 121, 301]
    for binfo in [b["binfo"] for b in blist if b.get("binfo", {}).get("bid") in important_bids]:
        print(f"Building {binfo.get('bid')}: level={binfo.get('level')}, star={binfo.get('starLevel', binfo.get('slv', 0))}")
        
    # Check BuffCtrl
    print("\nBuffCtrl in init_data:", init.get("buffCtrl"))
    
    # Check Backpack for active/used buffs or march items
    bp = init.get("backpackCtrl") or {}
    print(f"\nBackpack item count: {len(bp)}")
    
    # Check QueueCtrl
    queue = init.get("queueCtrl") or {}
    print("\nQueueCtrl:", queue)
    
    # Check Marches (armyCtrl)
    army = init.get("armyCtrl") or {}
    print("\nArmyCtrl marches count / keys:", list(army.keys()))
    if "marches" in army:
        print("Marches:", army["marches"])
        
    # Check Alliance Sciences
    al = init.get("allianceCtrl") or {}
    sci = al.get("sciencelist", {})
    print("\nAlliance Sciences count:", len(sci))
    print("Alliance sci:", sci)

    if b.conn:
        await b.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
