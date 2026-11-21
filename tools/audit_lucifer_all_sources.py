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
LiveMemoryEngine.extract_controllers = lambda self, p: (raw_packets.append(p), {})[1]

async def check():
    c_data = db.get_castle_by_id('LUCIFER@g4.coom')
    bot = CastleBot(email='LUCIFER@g4.coom', password=c_data['password'], log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    p1000 = next(p for p in raw_packets if str(p.get('cmd')) in ('1000', 'onemt_1000') or p.get('_session') == 0)
    data = p1000.get('data', {}).get('retdata', {})
    
    print("=== CHECKING ALL BUFF SOURCES ON LUCIFER ===")
    
    # 1. Equipment & Resonance
    eq = data.get("equipmentCtrl", {})
    eq_arr = eq.get("equipment_array", [])
    print(f"1. Equipment count: {len(eq_arr)}")
    for item in eq_arr:
        if item.get("wear") == 1:
            print(f"  Wearing eq: eid={item.get('eid')}, epid={item.get('epid')}, qly={item.get('qly')}, extra={item.get('extra')}")
            
    # 2. Pets
    pet = data.get("petCtrl", {})
    pet_list = pet.get("petList", {})
    print(f"\n2. Pet count: {len(pet_list)}")
    for pid, pdata in pet_list.items():
        print(f"  Pet {pid}: lv={pdata.get('lv')}, rank={pdata.get('rank')}, talents={pdata.get('talents')}")
        
    # 3. Alliance Prosperity
    al = data.get("allianceCtrl", {})
    sci = al.get("sciencelist", {})
    print(f"\n3. Alliance prosperity: {sci.get('prosperity')}")
    
    # 4. Building Mastery & Star
    city = data.get("cityCtrl", {})
    mastery = city.get("mastery", {})
    print(f"\n4. City mastery: {mastery}")
    
    # 5. Military Rank
    mil = data.get("militaryRankCtrl", {})
    print(f"\n5. Military rank: curRank={mil.get('curRank')}, level={mil.get('level')}, effects={mil.get('effects')}")
    
    # 6. Parliament
    parl = data.get("parliamentCtrl", {})
    print(f"\n6. Parliament: {parl}")
    
    # 7. War Gem
    gem = data.get("warGemCtrl", {})
    print(f"\n7. War gem: {gem}")
    
    # 8. Titles / Officials in lordInfoCtrl
    lord = data.get("lordInfoCtrl", {})
    print(f"\n8. Lord titles: legendTitle={lord.get('legendTitle')}, hegemonTitle={lord.get('hegemonTitle')}, emperorOfficial={lord.get('emperorOfficial')}")
    
    # 9. Dresses
    dress = data.get("dressCtrl", {})
    print(f"\n9. Dresses: {dress.get('list')}")
    
    # 10. Magic Lamp
    lamp = data.get("magicLampCtrl", {})
    print(f"\n10. Magic lamp: isUnLock={lamp.get('isUnLock')}")
    
    # 11. Divine Beast
    beast = data.get("divineBeastCtrl", {})
    print(f"\n11. Divine beast: {beast.get('beast')}")
    
    # 12. Garden
    garden = data.get("gardenFarmlandCtrl", {})
    print(f"\n12. Garden: {garden}")

    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
