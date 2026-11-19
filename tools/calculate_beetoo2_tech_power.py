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

async def calc_tech():
    email = "beetoo2@hotmail.com"
    bot = CastleBot(email=email, log_callback=lambda m: None)
    c_data = db.get_castle_by_id(email)
    if c_data and c_data.get("password"):
        bot.password = c_data["password"]

    bot.is_running = True
    ok = await bot.connect()
    if not ok or not bot.conn:
        return

    conn = bot.conn
    try:
        init_data = conn.init_data
        tech_ctrl = init_data.get("technologyCtrl", {})
        print(f"Tech entries in beetoo2: {len(tech_ctrl)}")
        
        # Load march_data_tables.json
        tables_path = os.path.join(_ROOT, "tools", "march_data_tables.json")
        with open(tables_path, "r", encoding="utf-8") as f:
            tables = json.load(f)
            
        tech_tables = tables.get("techs", {})
        
        # Let's inspect all tech entries in beetoo2
        tech_add = 0
        tech_group_add = 0
        all_tech_effects = {}
        for tid_key, tdata in tech_ctrl.items():
            tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else (int(tid_key) if str(tid_key).isdigit() else 0)
            tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) and len(tdata) > 1 else (int(tdata) if isinstance(tdata, (int, str)) and str(tdata).isdigit() else 0)
            
            str_tid = str(tid)
            str_tlv = str(tlv)
            t_info = tech_tables.get(str_tid, {})
            lv_data = t_info.get(str_tlv)
            if lv_data:
                pw, bt, bnt = lv_data[0], lv_data[1], lv_data[2]
                all_tech_effects[tid] = {"level": tlv, "buffType": bt, "power": pw, "buffNumType": bnt}
                if bt == 43: # SINGLE_TROOP_STRENGTH
                    cardinal = 1 if bnt == 2 else 1000
                    val = int(pw / cardinal)
                    tech_add += val
                    print(f"Tech {tid} Lv.{tlv}: +{val} capacity (pw={pw}, bnt={bnt})")
                elif bt in (73, 77, 95):
                    tech_group_add += (pw / 1000.0)
                    print(f"Tech {tid} Lv.{tlv}: group add {pw}/1000 (bt={bt})")
            else:
                pass
                
        print(f"Total SINGLE_TROOP_STRENGTH tech_add = {tech_add}")
        print(f"Total techGroupAdd = {tech_group_add}")
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(calc_tech())
