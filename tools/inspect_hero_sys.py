# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
import asyncio
from bot_manager import CastleBot
import core.database as db

async def check():
    email = 'beetoo2@hotmail.com'
    c_data = db.get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get('password'), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok: return
    init_data = bot.conn.init_data
    heros = init_data.get('heroSysCtrl', {}).get('heroList', {})
    print(f"Total heroes: {len(heros)}")
    for hid, h in heros.items():
        print(f"Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}, isAwake={h.get('isAwake')}, isDefend={h.get('isDefend')}")
        for k in ['skillList', 'masterySkill', 'powerSkill', 'advancedSkill', 'lieutenant', 'dress', 'stunt']:
            if h.get(k):
                print(f"   {k}: {h.get(k)}")
    print('defendList:', init_data.get('heroSysCtrl', {}).get('defendList'))
    print('buffCtrl:', init_data.get('buffCtrl'))
    await bot.conn.close()

if __name__ == '__main__':
    asyncio.run(check())
