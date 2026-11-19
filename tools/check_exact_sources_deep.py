# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR) if os.path.basename(CURRENT_DIR) == "tools" else CURRENT_DIR
if WORKSPACE_DIR not in sys.path:
    sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db
from tools.test_base_task import BaseTaskHarness

async def main():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return

    task = BaseTaskHarness(bot.conn, log_func=lambda m: None, config=bot.config)
    await task.sync_local_queues(timeout=3.0)
    await task.sync_achievements(timeout=3.0)
    
    conn = task.conn
    
    # 1. Inspect ALL achievements in achievementctrl
    ach = conn.init_data.get('achievementctrl', {})
    ach_list = ach.get('list', {})
    print(f"=== CHECKING {len(ach_list)} ACHIEVEMENTS ===")
    
    # Load achievement config to see medalBuff for each done tier
    # In config: localtb/config_server/achievement_medal.lua or achievement.lua
    # Let's search for medal config
    ach_medals = {}
    ach_file = "game_file/src/app/localtb/config_server/achievement_medal.lua"
    if os.path.exists(ach_file):
        with open(ach_file, "r", encoding="utf-8") as f:
            txt = f.read()
            # parse medalBuff
            # medalID = { ... medalBuff = {prop, val} ... }
            pass

    for ach_type, ach_data in ach_list.items():
        max_done = ach_data.get('maxDoneID', 0)
        has_buff = ach_data.get('hasBuff', 0)
        cur = ach_data.get('cur', 0)
        medal_id = ach_data.get('medalID', 0)
        if has_buff or max_done > 0:
            print(f"Type {ach_type}: medalID={medal_id}, maxDoneID={max_done}, hasBuff={has_buff}, cur={cur}")

    # 2. Check VIP
    lic = conn.init_data.get('lordInfoCtrl', {})
    vip = lic.get('vip', {})
    print(f"\n=== VIP ===")
    print(f"VIP level: {vip.get('level')}, endTime: {vip.get('vipEndTime')}")

    # 3. Check Alliance Science
    al = conn.init_data.get('allianceCtrl', {})
    sci = al.get('sciencelist', {}).get('scilist', {})
    print(f"\n=== ALLIANCE SCIENCES ===")
    for cat, scis in sci.items():
        for s in scis:
            if s.get('lv', 0) > 0:
                print(f"  Category {cat}: id={s.get('id')}, lv={s.get('lv')}")

    # 4. Check Pet
    pet = conn.init_data.get('petCtrl', {})
    print(f"\n=== PET DATA ===")
    print(f"curPet: {pet.get('curPet')}, petData keys: {list(pet.get('petData', {}).keys())}")
    for pid, pdata in pet.get('petData', {}).items():
        print(f"  Pet {pid}: lv={pdata.get('level')}, star={pdata.get('star')}, skill={pdata.get('skills')}")

    # 5. Check Military Rank
    mil = lic.get('militaryRankInfo', {})
    print(f"\n=== MILITARY RANK ===")
    print(f"level: {mil.get('level')}, rank: {mil.get('curRank')}, points: {mil.get('points')}")

    # 6. Check Hero Stunts / Power Skills
    hsys = conn.init_data.get('heroSysCtrl', {})
    hlist = hsys.get('heroList', {})
    print(f"\n=== HERO POWER SKILLS ===")
    for hid in ['1712', '1711', '1717', '1707', '1708']:
        h = hlist.get(hid, {})
        print(f"Hero {hid}: lv={h.get('level')}, powerSkills={h.get('powerSkill')}, skills={h.get('skills')}")

    # 7. Check if there are dress / skin buffs on heroes
    for hid in ['1712', '1711', '1717', '1707', '1708']:
        h = hlist.get(hid, {})
        print(f"Hero {hid} dress: {h.get('dress')}")

    if bot.conn:
        bot.conn.close()

if __name__ == "__main__":
    asyncio.run(main())
