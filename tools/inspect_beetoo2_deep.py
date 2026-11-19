# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db

async def inspect():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return
    await asyncio.sleep(2.0)
    data = bot.conn.init_data
    
    hero_sys = data.get("heroSysCtrl", {})
    hero_list = hero_sys.get("heroList", {})
    print("=== BEETOO2 HEROES WITH DRESS ===")
    for hid, h in hero_list.items():
        dress = h.get("dress")
        if dress:
            print(f"Hero {hid} dress: {dress}")
            
    print("\n=== BEETOO2 HEROES WITH AWAKENING / SPECIAL SKILLS ===")
    for hid, h in hero_list.items():
        if h.get("isAwake") or h.get("advancedSkill") or h.get("powerSkill") or h.get("masterySkill"):
            print(f"Hero {hid} (name: {h.get('name')}, lv: {h.get('level')}): isAwake={h.get('isAwake')}")
            if h.get("powerSkill"):
                print(f"   powerSkill: {h.get('powerSkill')}")
            if h.get("masterySkill"):
                print(f"   masterySkill: {h.get('masterySkill')}")
            if h.get("advancedSkill"):
                print(f"   advancedSkill: {h.get('advancedSkill')}")
                
    # Also check godArmsCtrl, divineBeastCtrl, petCtrl, allianceCtrl, lordInfoCtrl
    print("\n=== OTHER CONTROLLERS RELATED TO MARCH ===")
    for ctrl_name in ["godArmsCtrl", "divineBeastCtrl", "armRuneCtrl", "godArmsRuneCtrl", "warBeastCtrl", "wrathBeastCtrl", "nebulaActivityCtrl", "dragonCaveCtrl"]:
        if ctrl_name in data:
            print(f"{ctrl_name}: {json.dumps(data[ctrl_name], ensure_ascii=False)[:300]}")
        else:
            print(f"{ctrl_name}: NOT FOUND IN DATA")
            
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(inspect())
