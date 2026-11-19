# -*- coding: utf-8 -*-
import sys, os, json, asyncio
sys.path.insert(0, '.')
from bot_manager import CastleBot
import core.database as db

async def main():
    c = db.get_castle_by_id('beetoo2@hotmail.com')
    b = CastleBot('beetoo2@hotmail.com', c.get('password'), config={}, log_callback=lambda m: None)
    b.is_running = True
    await b.connect()
    init = b.conn.init_data
    techs = init.get('technologyCtrl', {})
    print(f"Total researched techs: {len(techs)}")
    
    # Load tech tables
    with open('tools/march_data_tables.json', 'r', encoding='utf-8') as f:
        tables = json.load(f)
    tech_tables = tables.get('techs', {})
    
    # Check each tech in tech_tables
    for tid_str, tdata in techs.items():
        tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else int(tid_str)
        tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) and len(tdata) > 1 else int(tdata)
        
        t_info = tech_tables.get(str(tid), {})
        lv_data = t_info.get(str(tlv))
        if lv_data:
            pw, bt, bnt = lv_data[0], lv_data[1], lv_data[2]
            # Check if bt is related to march capacity or strength
            # bt 43 is SINGLE_TROOP_STRENGTH
            # bt 73, 77, 95 are group additions
            # What else could bt be?
            if bt in (43, 73, 77, 95) or "troop" in str(bt).lower() or bt in (19, 96):
                print(f"  Tech {tid} Lv.{tlv}: pw={pw}, buffType={bt}, bnt={bnt}")
        else:
            # Not in tech_tables
            pass
            
    if b.conn:
        await b.conn.close()

asyncio.run(main())
