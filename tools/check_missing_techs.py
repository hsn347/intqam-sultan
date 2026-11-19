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
    
    with open('tools/march_data_tables.json', 'r', encoding='utf-8') as f:
        tables = json.load(f)
    tech_tables = tables.get('techs', {})
    
    missing = []
    for tid_str, tdata in techs.items():
        tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else int(tid_str)
        if str(tid) not in tech_tables:
            missing.append(tid)
    print(f"Techs missing from tech_tables: {missing}")
    if b.conn:
        await b.conn.close()

asyncio.run(main())
