"""
Examine all 45 buff sources for beetoo2
"""
import asyncio, json, os, sys
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot

async def inspect():
    bot = CastleBot(email='beetoo2@hotmail.com', password=None, log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    d = bot.conn.init_data

    print("=== INSPECTING ALL BUFF SOURCES IN BEETOO2 ===")

    # 1. Active buffs in buffCtrl
    buff_ctrl = d.get('buffCtrl', [])
    print(f"buffCtrl (active items): {buff_ctrl}")

    # 2. Lord Info (VIP, talents, titles, military rank, etc.)
    lord = d.get('lordInfoCtrl', {})
    print(f"lordInfoCtrl keys: {list(lord.keys()) if isinstance(lord, dict) else type(lord)}")
    if isinstance(lord, dict):
        for k in ['vip', 'skill', 'official', 'title', 'hegemon', 'legendLord', 'militaryRank', 'jewel', 'wonder']:
            if k in lord:
                print(f"lord['{k}'] = {lord[k]}")

    # 3. Alliance
    ali = d.get('allianceCtrl', {})
    print(f"allianceCtrl keys: {list(ali.keys()) if isinstance(ali, dict) else type(ali)}")
    if isinstance(ali, dict):
        for k in ['official', 'rank', 'science', 'buff']:
            if k in ali:
                print(f"alliance['{k}'] = {ali[k]}")

    # 4. Hero Appoint & Hero System
    hero = d.get('heroSysCtrl', {})
    print(f"heroSysCtrl keys: {list(hero.keys()) if isinstance(hero, dict) else type(hero)}")
    if isinstance(hero, dict):
        # Check all heroes
        hero_list = hero.get('heroList', {})
        print(f"heroList count: {len(hero_list)}")
        for hid, hdata in hero_list.items():
            print(f"Hero {hid}: state={hdata.get('state')}, level={hdata.get('level')}, star={hdata.get('star')}, powerSkill={list(hdata.get('powerSkill', {}).keys())}, appoint={hdata.get('appoint')}")

    # 5. Pet
    pet = d.get('petCtrl', {})
    if isinstance(pet, dict):
        p_info = pet.get('petInfo', {})
        print(f"Pets owned: {list(p_info.keys()) if isinstance(p_info, dict) else type(p_info)}")
        if isinstance(p_info, dict):
            for pid, pdata in p_info.items():
                print(f"Pet {pid}: lv={pdata.get('lv')}, rank={pdata.get('rank')}, skill={pdata.get('skill')}")

    # 6. City mastery & stars
    city = d.get('cityCtrl', {})
    if isinstance(city, dict):
        print(f"mastery: {city.get('mastery')}")

    await bot.stop()

asyncio.run(inspect())
