# -*- coding: utf-8 -*-
import asyncio
import sys
import os
import json

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKSPACE_DIR = os.path.dirname(CURRENT_DIR)
sys.path.insert(0, WORKSPACE_DIR)

from bot_manager import CastleBot
import core.database as db

async def run():
    c_data = db.get_castle_by_id('beetoo2@hotmail.com')
    bot = CastleBot(email='beetoo2@hotmail.com', password=c_data.get('password'), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok: return
    data = bot.conn.init_data
    
    hero_sys = data.get('heroSysCtrl', {})
    hl = hero_sys.get('heroList', {})
    print("=== BEETOO2 FULL HERO DATA ===")
    for hid, h in hl.items():
        print(f"Hero {hid}: state={h.get('state')}, lv={h.get('level')}, quality={h.get('quality')}, rarity={h.get('rarity')}, isAwake={h.get('isAwake')}, dress={h.get('dress')}, star={h.get('star')}")
        
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(run())
