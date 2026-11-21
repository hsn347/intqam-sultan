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
    eq = bot.conn.init_data.get('equipmentCtrl', {})
    earray = eq.get('equipment_array', [])
    print(f'Total equipments: {len(earray)}')
    for e in earray:
        is_wear = e.get('wear') == 1 or e.get('wear') == '1'
        print(f"eid: {e.get('eid')}, epid: {e.get('epid')}, wear: {e.get('wear')}, is_wear: {is_wear}, qly: {e.get('qly')}, slv: {e.get('slv')}")
        if is_wear:
            print(f"  -> WORN: {e}")
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
