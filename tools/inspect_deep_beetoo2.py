# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import asyncio
import json
import core.database as db
from bot_manager import CastleBot

async def main():
    target_email = 'beetoo2@hotmail.com'
    c_data = db.get_castle_by_id(target_email)
    pwd = c_data.get('password') if c_data else None
    bot = CastleBot(email=target_email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print('Failed to connect')
        return

    conn = bot.conn
    init_data = conn.init_data

    lord_info = init_data.get('lordInfoCtrl', {})
    print("=== Lord Info Details ===")
    for k in ['vip', 'militaryRankInfo', 'base', 'skill', 'achieveInfo']:
        print(f"lordInfo.{k}:", lord_info.get(k))

    print("\n=== Equipment Ctrl ===")
    equip = init_data.get('equipmentCtrl', {})
    for k, v in equip.items():
        print(f"equip.{k}:", type(v), len(v) if hasattr(v, '__len__') else v)

    print("\n=== Pet Ctrl ===")
    pet = init_data.get('petCtrl', {})
    print("petList:", pet.get('petList'))

    print("\n=== Buff Ctrl ===")
    buffs = init_data.get('buffCtrl', [])
    print("buffCtrl:", buffs)

    print("\n=== Army Ctrl ===")
    army = init_data.get('armyCtrl', {})
    for k in army:
        print(f"army.{k}:", type(army[k]), len(army[k]) if hasattr(army[k], '__len__') else army[k])

    print("\n=== City Ctrl blist drill grounds ===")
    city = init_data.get('cityCtrl', {})
    blist = city.get('blist', [])
    for b in blist:
        binfo = b.get('binfo', {})
        if binfo.get('bid') == 121:
            print("Drill grounds binfo:", binfo)

    if bot.conn:
        await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(main())
