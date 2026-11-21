# -*- coding: utf-8 -*-
import os, sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import asyncio
import json
from bot_manager import CastleBot
import core.database as db

async def inspect():
    target_email = "LUCIFER@g4.coom"
    c_data = db.get_castle_by_id(target_email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return
    
    init = bot.conn.init_data
    print("=== TOP LEVEL INIT KEYS ===")
    print(list(init.keys()))
    
    # Save a sanitized json dump of all keys
    dump_data = {}
    for k, v in init.items():
        if isinstance(v, dict):
            dump_data[k] = {"keys": list(v.keys())}
        elif isinstance(v, list):
            dump_data[k] = {"count": len(v)}
        else:
            dump_data[k] = str(type(v))
            
    print("\n=== SUMMARY OF MODULES ===")
    print(json.dumps(dump_data, indent=2))
    
    # Inspect playerInfo / lordInfo
    for k in ["playerInfo", "lordInfo", "userData", "cityCtrl", "technologyCtrl", "buffCtrl", "heroCtrl", "dressCtrl", "equipmentCtrl", "petCtrl", "militaryRankCtrl", "allianceCtrl"]:
        if k in init:
            print(f"\n--- {k} ---")
            val = init[k]
            if isinstance(val, dict):
                # print some interesting fields
                simple_fields = {sk: sv for sk, sv in val.items() if not isinstance(sv, (dict, list)) or len(str(sv)) < 100}
                print(f"simple fields: {simple_fields}")
            elif isinstance(val, list):
                print(f"list of {len(val)} items")
                if len(val) > 0:
                    print(f"first item: {val[0]}")
                    
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(inspect())
