# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import asyncio
from bot_manager import CastleBot
import core.database as db

async def check():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return
    conn = bot.conn
    init_data = conn.init_data
    
    print('=== BEAST / DIVINE ===')
    for k in init_data.keys():
        if 'beast' in k.lower() or 'divine' in k.lower():
            print(k, type(init_data[k]), init_data[k])
            
    print('=== GOD ARMS / RUNE ===')
    for k in init_data.keys():
        if 'rune' in k.lower() or 'god' in k.lower():
            print(k, type(init_data[k]), init_data[k])
            
    print('=== HEROES ON BEETOO2 ===')
    heros = init_data.get('heroCtrl', {}).get('heros', {})
    for hid, h in heros.items():
        print(f"Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}, isAwake={h.get('isAwake')}")
        if h.get('skillList'):
            print(f"   skills: {h.get('skillList')}")
        if h.get('masterySkill'):
            print(f"   masterySkill: {h.get('masterySkill')}")
        if h.get('powerSkill'):
            print(f"   powerSkill: {h.get('powerSkill')}")
        if h.get('advancedSkill'):
            print(f"   advancedSkill: {h.get('advancedSkill')}")
            
    print('=== LIEUTENANTS ===')
    for k in init_data.keys():
        if 'lieutenant' in k.lower() or 'assist' in k.lower():
            print(k, type(init_data[k]), init_data[k])
            
    print('=== HEROCTRL KEYS ===')
    print(list(init_data.get('heroCtrl', {}).keys()))
    
    await conn.close()

if __name__ == '__main__':
    asyncio.run(check())
