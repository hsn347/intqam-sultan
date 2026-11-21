# -*- coding: utf-8 -*-
import os, sys
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import asyncio
from bot_manager import CastleBot
import core.database as db

async def check():
    c_data = db.get_castle_by_id('LUCIFER@g4.coom')
    bot = CastleBot(email='LUCIFER@g4.coom', password=c_data['password'], log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    init = bot.conn.init_data
    
    print("=== CHECKING ALL BUFF SOURCES FOR LUCIFER ===")
    
    # 1. Equipment
    eq = init.get("equipmentCtrl", {})
    print("\n1. equipmentCtrl:", {k: len(v) if isinstance(v, (dict, list)) else v for k, v in eq.items()})
    
    # 2. Lord Info / Titles / Officials
    lord = init.get("lordInfoCtrl", {})
    print("\n2. lord titles / officials:")
    for k in ["legendTitle", "hegemonTitle", "emperorOfficial", "nebulaOfficialID", "nebulaOfficialID2", "atlantisOfficialType"]:
        print(f"  {k}: {lord.get(k)}")
        
    # 3. Alliance
    al = init.get("allianceCtrl", {})
    print("\n3. allianceCtrl keys:", list(al.keys()))
    
    # 4. Pets
    pet = init.get("petCtrl", {})
    print("\n4. petCtrl keys:", list(pet.keys()))
    if "feedInfo" in pet:
        print("  feedInfo:", pet["feedInfo"])
        
    # 5. City Ctrl (Mastery, Stars, etc.)
    city = init.get("cityCtrl", {})
    print("\n5. cityCtrl:")
    print("  mastery:", city.get("mastery"))
    
    # 6. Technology Ctrl (Conquest, Pyramid, Legend techs?)
    tech = init.get("technologyCtrl", {})
    print("\n6. technologyCtrl count:", len(tech))
    
    # 7. Any other modules
    for mod in ["stuffWorkshopCtrl", "treviFountainCtrl", "storesCtrl", "pyramidCtrl"]:
        if mod in init:
            print(f"\n{mod} keys:", list(init[mod].keys()) if isinstance(init[mod], dict) else type(init[mod]))
            
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
