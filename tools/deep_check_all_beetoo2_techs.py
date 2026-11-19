# -*- coding: utf-8 -*-
import sys, os, json, re, asyncio
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
    if b.conn:
        await b.conn.close()

    print(f"Checking {len(techs)} technologies of Beetoo2...")
    with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    # Find each tech
    found = 0
    march_buffs = []
    all_buffs = {}
    for tid_str, tdata in techs.items():
        tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else int(tid_str)
        tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) and len(tdata) > 1 else int(tdata)
        
        full_id = f"{tid}{tlv:02d}"
        
        # Look for full_id in text
        # pattern: .technologyID = {full_id}
        pattern = rf'technologyID\s*=\s*{full_id}\b'
        m = re.search(pattern, text)
        if m:
            found += 1
            pos = m.start()
            # extract surrounding block
            block = text[pos:pos+1500]
            # extract buffType, powerNum, buffNumType
            m_bt = re.search(r'\.buffType\s*=\s*(\d+)', block)
            m_pw = re.search(r'\.powerNum\s*=\s*(\d+)', block)
            m_bnt = re.search(r'\.buffNumType\s*=\s*(\d+)', block)
            if m_bt and m_pw:
                bt = int(m_bt.group(1))
                pw = int(m_pw.group(1))
                bnt = int(m_bnt.group(1)) if m_bnt else 1
                all_buffs[tid] = (tlv, bt, pw, bnt)
                if bt in (43, 73, 77, 95, 19, 96):
                    march_buffs.append((tid, tlv, bt, pw, bnt))
        else:
            print(f"Tech {full_id} NOT found!")

    print(f"\nFound {found}/{len(techs)} technologies in technology.lua")
    print(f"\nMarch-related buffs ({len(march_buffs)}):")
    total_43 = 0
    for tid, tlv, bt, pw, bnt in march_buffs:
        cardinal = 1 if bnt == 2 else 1000
        val = int(pw / cardinal) if bnt == 2 else pw
        if bt == 43:
            total_43 += pw
        print(f"  Tech {tid} Lv.{tlv}: buffType={bt}, powerNum={pw}, bnt={bnt} -> val={val}")
    print(f"Total buffType 43: {total_43}")

    # Also list all other unique buffTypes
    unique_bts = set(v[1] for v in all_buffs.values())
    print(f"\nAll unique buffTypes in Beetoo2 techs: {sorted(unique_bts)}")

asyncio.run(main())
