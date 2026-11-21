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
    city = bot.conn.init_data.get('cityCtrl', {})
    blist = city.get('blist', [])
    for item in blist:
        b = item.get('binfo', {})
        print(f"bid: {b.get('bid')}, lv: {b.get('lv')}, star: {b.get('starLv')}, iid: {b.get('iid')}")
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
