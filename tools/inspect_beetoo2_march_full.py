# -*- coding: utf-8 -*-
"""
tools/inspect_beetoo2_march_full.py
Examine beetoo2's live memory in detail for all march capacity factors.
"""

import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db

async def inspect_beetoo2():
    email = "beetoo2@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect!")
        return

    conn = bot.conn
    try:
        init_data = conn.init_data
        print("=== INIT DATA KEYS ===")
        print(list(init_data.keys()))
        
        # 1. City / Drill Grounds
        city_ctrl = init_data.get("cityCtrl", {})
        blist = city_ctrl.get("blist", [])
        for item in blist:
            binfo = item.get("binfo") if isinstance(item, dict) else None
            if binfo and str(binfo.get("bid")) == "121":
                print("Drill grounds binfo:", binfo)
                
        # 2. Technology
        tech_ctrl = init_data.get("technologyCtrl", {})
        print(f"Total techs: {len(tech_ctrl)}")
        
        # 3. Buffs
        buff_ctrl = init_data.get("buffCtrl", [])
        print("buffCtrl:", buff_ctrl)
        
        # 4. HeroSysCtrl
        hero_sys = init_data.get("heroSysCtrl", {})
        hero_list = hero_sys.get("heroList", {})
        print(f"Total heroes: {len(hero_list)}")
        for hid, hdata in hero_list.items():
            print(f"Hero {hid}: level={hdata.get('level')}, state={hdata.get('state')}, quality={hdata.get('quality')}, isAwake={hdata.get('isAwake')}, skills={list(hdata.get('skillList', {}).keys())}, dresses={hdata.get('dress')}")
            if hdata.get("masterySkill"):
                print(f"  masterySkill: {hdata.get('masterySkill')}")
            if hdata.get("powerSkill"):
                print(f"  powerSkill: {hdata.get('powerSkill')}")
            if hdata.get("advancedSkill"):
                print(f"  advancedSkill: {hdata.get('advancedSkill')}")
                
        # 5. Hero lieutenant / combo / formation / defendList
        print("heroSysCtrl extra keys:", [k for k in hero_sys.keys() if k != "heroList"])
        for k in hero_sys.keys():
            if k != "heroList":
                print(f"  heroSys.{k} = {hero_sys[k]}")
                
        # 6. God arms / runes
        god_arms = init_data.get("godArmsCtrl", {})
        print("godArmsCtrl:", god_arms)
        
        # 7. Divine beast
        divine_beast = init_data.get("divineBeastCtrl", {})
        print("divineBeastCtrl:", divine_beast)
        
        # 8. ArmyCtrl / compiles
        army_ctrl = init_data.get("armyCtrl", {})
        print("armyCtrl keys:", list(army_ctrl.keys()))
        for k in army_ctrl:
            if "compile" in k.lower() or "team" in k.lower() or "march" in k.lower():
                print(f"  armyCtrl.{k} = {army_ctrl[k]}")
                
        # 9. Lord equipment / dress
        lord_info = init_data.get("lordInfoCtrl", {})
        print("lordInfoCtrl keys:", list(lord_info.keys()))
        equip_ctrl = init_data.get("equipmentCtrl", {})
        print("equipmentCtrl keys:", list(equip_ctrl.keys()) if isinstance(equip_ctrl, dict) else len(equip_ctrl))
        dress_ctrl = init_data.get("dressCtrl", {})
        print("dressCtrl:", dress_ctrl)
        
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(inspect_beetoo2())
