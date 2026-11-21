# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from bot_manager import CastleBot
import core.database as db

async def inspect():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    bot = CastleBot(email=email, password=c_data.get("password"), log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok:
        print("Failed to connect")
        return
    await asyncio.sleep(2.5)
    
    hero_sys = bot.conn.init_data.get("heroSysCtrl", {})
    hlist = hero_sys.get("heroList", {})
    print("Total heroes:", len(hlist))
    for hid in ["1700", "1712", "1717", "1711", "1707"]:
        h = hlist.get(hid)
        if h:
            print(f"Hero {hid}: keys = {list(h.keys())}")
            print(f"  heroID={h.get('heroID')}, level={h.get('level')}, quality={h.get('quality')}, rarity={h.get('rarity')}, state={h.get('state')}")
            skills = h.get("skillList", {})
            print(f"  skillList keys = {list(skills.keys()) if isinstance(skills, dict) else skills}")
            if isinstance(skills, dict):
                for sk_id, sk_val in skills.items():
                    print(f"    skill {sk_id}: {sk_val}")
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(inspect())
