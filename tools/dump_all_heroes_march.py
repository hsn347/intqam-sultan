# -*- coding: utf-8 -*-
import asyncio
import json
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from bot_manager import CastleBot
import core.database as db
from tasks.base_task import _load_march_data_tables

async def dump_all_hero_march():
    email = "beetoo2@hotmail.com"
    c_data = db.get_castle_by_id(email)
    pwd = c_data.get("password") if c_data else None
    bot = CastleBot(email=email, password=pwd, log_callback=lambda m: None)
    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        print("Failed to connect")
        return
    await asyncio.sleep(2.0)
    data = bot.conn.init_data
    
    tables = _load_march_data_tables()
    rare_levels = tables.get("rare_levels", {})
    hero_configs = tables.get("heroes", {})
    
    hero_sys = data.get("heroSysCtrl", {})
    hero_list = hero_sys.get("heroList", {})
    
    print(f"Total heroes: {len(hero_list)}")
    results = []
    for hid, h in hero_list.items():
        state = h.get("state")
        lv = h.get("level", 1)
        cfg = hero_configs.get(str(hid), {})
        rarity = h.get("rarity") or cfg.get("rarity", 1)
        name = cfg.get("name", f"Hero_{hid}")
        
        # Base march addition from rarity & level
        r_lvs = rare_levels.get(str(rarity), {})
        base_march = int(r_lvs.get(str(lv), 0))
        
        # Skills
        skill_list = h.get("skillList", {})
        skills_summary = []
        if isinstance(skill_list, dict):
            for skey, sinfo in skill_list.items():
                if sinfo.get("isActive"):
                    skills_summary.append(sinfo.get("skillType"))
                    
        results.append({
            "hid": int(hid),
            "name": name,
            "lv": lv,
            "rarity": rarity,
            "state": state,
            "base_march": base_march,
            "skills": skills_summary,
            "isAwake": h.get("isAwake", False)
        })
        
    results.sort(key=lambda x: (x["state"] == 1, x["base_march"], x["lv"], x["rarity"]), reverse=True)
    for r in results:
        print(f"Hero {r['hid']:<5} | {r['name']:<15} | Rarity:{r['rarity']} | Lv:{r['lv']:<2} | State:{r['state']} | BaseMarch:+{r['base_march']} | Awake:{r['isAwake']} | Skills:{r['skills']}")
        
    await bot.conn.close()

if __name__ == "__main__":
    asyncio.run(dump_all_hero_march())
