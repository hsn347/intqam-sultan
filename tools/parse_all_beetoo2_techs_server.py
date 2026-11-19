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

    print(f"Reading technology.lua for {len(techs)} technologies...")
    with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    # Search for all tid in techs
    march_related = []
    for tid_str, tdata in techs.items():
        tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) and len(tdata) > 0 else int(tid_str)
        tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) and len(tdata) > 1 else int(tdata)

        # Look for [tid] in text
        # In technology.lua: [tid] = { ... [tlv] = { power, buffType, buffNumType } }
        m = re.search(rf'\[{tid}\]\s*=\s*\{{([^}}]+(?:\{{[^}}]*\}}[^}}]*)*)\}}', text)
        if m:
            block = m.group(1)
            # Find [tlv] = { ... }
            m_lv = re.search(rf'\[{tlv}\]\s*=\s*\{{([^}}]+)\}}', block)
            if m_lv:
                parts = [p.strip() for p in m_lv.group(1).split(',')]
                # power, buffType, buffNumType
                try:
                    pw = int(parts[0])
                    bt = int(parts[1]) if len(parts) > 1 else 0
                    bnt = int(parts[2]) if len(parts) > 2 else 0
                    if bt in (43, 73, 77, 95) or bt in (19, 96):
                        march_related.append((tid, tlv, pw, bt, bnt))
                except Exception:
                    pass
            else:
                pass
        else:
            pass

    print(f"\nMarch-related technologies found in technology.lua:")
    for tid, tlv, pw, bt, bnt in march_related:
        print(f"  Tech {tid} Lv.{tlv}: power={pw}, buffType={bt}, buffNumType={bnt}")

asyncio.run(main())
