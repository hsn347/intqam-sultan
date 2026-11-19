# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, '.')
import asyncio
import json
import core.database as db
from bot_manager import CastleBot

async def check():
    c_data = db.get_castle_by_id('beetoo2@hotmail.com')
    bot = CastleBot(email='beetoo2@hotmail.com', password=c_data.get('password'), log_callback=lambda m: None)
    bot.is_running = True
    await bot.connect()
    equip = bot.conn.init_data.get('equipmentCtrl', {})
    arr = equip.get('equipment_array', [])
    print(f"Total equipment in array: {len(arr)}")
    for i, eq in enumerate(arr):
        print(f"[{i}] {eq}")
    if bot.conn:
        await bot.conn.close()

asyncio.run(check())
