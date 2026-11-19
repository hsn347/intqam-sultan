# -*- coding: utf-8 -*-
"""
parse_game_march_data.py
استخراج كافة جداول حساب سعة المسيرة من سورس اللعبة الأصلي:
1. سعة مبنى ميدان العرض (BID 121) لكل مستوى ولكل نجمة.
2. سعة أبحاث القيادة (BuffType 43, 73, 77, 95).
3. سعة الأبطال بحسب الندرة والمستوى (hero_level_config + hero_view_info).
4. بافات سعة المسيرة (buff.lua).
"""

import re
import json
import sys
import os
sys.path.insert(0, os.path.abspath('.'))

def parse_drill_grounds():
    # build121.lua
    with open('game_file/src/app/localtb/config_server/build121.lua', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    
    # regex search for blv and capacity
    # Each entry has: blv = <lv> ... capacity = <cap>
    levels = {}
    blocks = text.split(';(nil).index =')
    for b in blocks[1:]:
        m_lv = re.search(r'\.blv\s*=\s*(?:nil,\s*)*(\d+)', b)
        m_cap = re.search(r'\.capacity\s*=\s*(?:nil,\s*)*(\d+)', b)
        if m_lv and m_cap:
            levels[int(m_lv.group(1))] = int(m_cap.group(1))

    # Also parse remaining entries if any
    for m in re.finditer(r'\.blv\s*=\s*(?:nil,\s*)*(\d+).*?\.capacity\s*=\s*(?:nil,\s*)*(\d+)', text, re.DOTALL):
        lv = int(m.group(1))
        cap = int(m.group(2))
        if lv not in levels:
            levels[lv] = cap

    # star levels from buildstar121.lua
    stars = {}
    with open('game_file/src/app/localtb/config_server/buildstar121.lua', encoding='utf-8', errors='ignore') as f:
        star_text = f.read()
    for m in re.finditer(r'\.starlv\s*=\s*(?:nil,\s*)*(\d+).*?\.capacity\s*=\s*(?:nil,\s*)*(\d+)', star_text, re.DOTALL):
        stars[int(m.group(1))] = int(m.group(2))

    return levels, stars


def parse_technologies():
    # technology.lua
    with open('game_file/src/app/localtb/config_server/technology.lua', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    techs = {}
    cur = {}
    for line in text.splitlines():
        m = re.search(r'technologyID\s*=\s*(\d+)', line)
        if m:
            cur['tid'] = int(m.group(1))
        m = re.search(r'technologyLevel\s*=\s*(?:nil,\s*)*(\d+)', line)
        if m:
            cur['lv'] = int(m.group(1))
        m = re.search(r'buffType\s*=\s*(\d+)', line)
        if m:
            cur['buffType'] = int(m.group(1))
        m = re.search(r'powerNum\s*=\s*(\d+)', line)
        if m:
            cur['powerNum'] = int(m.group(1))
        m = re.search(r'buffNumType\s*=\s*(\d+)', line)
        if m:
            cur['buffNumType'] = int(m.group(1))
        
        if 'index =' in line:
            if 'tid' in cur and 'buffType' in cur and cur['buffType'] in (43, 73, 77, 95):
                tid = cur['tid']
                t_base = tid // 100
                lv = tid % 100
                bt = cur['buffType']
                pw = cur.get('powerNum', 0)
                bnt = cur.get('buffNumType', 1)
                techs.setdefault(t_base, {})[lv] = {
                    'buff_type': bt,
                    'power': pw,
                    'buff_num_type': bnt
                }
            cur = {}
    return techs


def parse_hero_configs():
    # hero_view_info.lua
    heroes = {}
    with open('game_file/src/app/localtb/config_client/hero_view_info.lua', encoding='utf-8', errors='ignore') as f:
        cur_id = None
        for line in f:
            m_id = re.search(r'\.heroID\s*=\s*(\d+)', line)
            if m_id:
                cur_id = int(m_id.group(1))
                heroes[cur_id] = {}
            if cur_id is not None:
                m_rar = re.search(r'\.rarity\s*=\s*(?:nil,\s*)*(\d+)', line)
                if m_rar:
                    heroes[cur_id]['rarity'] = int(m_rar.group(1))
                m_name = re.search(r'\.name\s*=\s*["\']([^"\']+)["\']', line)
                if m_name:
                    heroes[cur_id]['name'] = m_name.group(1)

    # hero_level_config.lua -> rarity + level -> march_add
    # e.g. rarity: {level: march_add}
    rare_level_march = {}
    with open('game_file/src/app/localtb/config_server/hero_level_config.lua', encoding='utf-8', errors='ignore') as f:
        cur_rar = None
        cur_lv = None
        for line in f:
            m_rar = re.search(r'\.rarity\s*=\s*(\d+)', line)
            if m_rar:
                cur_rar = int(m_rar.group(1))
            m_lv = re.search(r'\.level\s*=\s*(\d+)', line)
            if m_lv:
                cur_lv = int(m_lv.group(1))
            m_add = re.search(r'\.march_add\s*=\s*(\d+)', line)
            if m_add and cur_rar is not None and cur_lv is not None:
                rare_level_march.setdefault(cur_rar, {})[cur_lv] = int(m_add.group(1))

    return heroes, rare_level_march


if __name__ == '__main__':
    levels, stars = parse_drill_grounds()
    print(f"Drill Grounds levels count: {len(levels)}, stars count: {len(stars)}")
    print(f"Lv.27 = {levels.get(27)}, Lv.30 = {levels.get(30)}, Lv.35 = {levels.get(35)}")
    
    techs = parse_technologies()
    print(f"March Techs count: {len(techs)}")
    for tid, lvs in sorted(techs.items()):
        max_l = max(lvs.keys())
        print(f"  Tech {tid}: max_lv={max_l}, data={lvs[max_l]}")

    heroes, rare_levels = parse_hero_configs()
    print(f"Heroes parsed: {len(heroes)}, Rarity levels parsed: {len(rare_levels)}")
    for r, lvs in sorted(rare_levels.items()):
        print(f"  Rarity {r}: {len(lvs)} levels, Lv.1={lvs.get(1)}, Lv.50={lvs.get(50)}, Lv.60={lvs.get(60)}")

    import asyncio
    from tools.test_base_task import BaseTaskHarness
    from bot_manager import CastleBot
    import core.database as db

    async def test_live():
        email = 'beetoo2@hotmail.com'
        c_data = db.get_castle_by_id(email)
        b = CastleBot(email=email, password=c_data.get('password'), log_callback=lambda m: None)
        b.is_running = True
        await b.connect()
        b.reload_config_from_db()
        task = BaseTaskHarness(b.conn, log_func=b.log, config=b.config)
        
        # 1. Drill grounds
        city_ctrl = task.get_ctrl('cityCtrl')
        b121_lv = 0
        b121_star = 0
        if isinstance(city_ctrl, dict):
            for item in city_ctrl.get('blist', []):
                binfo = item.get('binfo') if isinstance(item, dict) else None
                if isinstance(binfo, dict) and str(binfo.get('bid')) == '121':
                    b121_lv = int(binfo.get('lv', 0) or 0)
                    b121_star = int(binfo.get('starLv', 0) or 0)
                    break
        
        base_cap = levels.get(b121_lv, 0) + stars.get(b121_star, 0)
        default_cap = 1000
        
        # 2. Tech add
        tech_ctrl = task.get_ctrl('technologyCtrl') or {}
        tech_add = 0
        tech_group_add = 0.0
        tech_details = []
        for tid_str, tdata in tech_ctrl.items():
            tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) else int(tid_str)
            tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) else int(tdata)
            if tid in techs and tlv in techs[tid]:
                tinfo = techs[tid][tlv]
                bt = tinfo['buff_type']
                pw = tinfo['power']
                bnt = tinfo['buff_num_type']
                if bt == 43:
                    cardinal = 1 if bnt == 2 else 1000
                    val = pw / cardinal
                    tech_add += val
                    tech_details.append((tid, tlv, val))
                elif bt in (73, 77, 95):
                    cardinal = 1000
                    tech_group_add += (pw / cardinal)

        # 3. Buffs
        buff_list = task.get_ctrl('buffCtrl') or []
        buff_percent = 0.0
        buff_value = 0
        for b_item in buff_list:
            if isinstance(b_item, dict):
                pass # check if active march buff

        print(f"\n🏰 [Live Calculation on {email}]:")
        print(f"  • Drill Grounds Lv.{b121_lv} (Star Lv.{b121_star}): Base = {base_cap:,}")
        print(f"  • Default game constant                           : +{default_cap:,}")
        print(f"  • Technology additions (Leadership techs)         : +{int(tech_add):,} ({tech_details})")
        print(f"  • Total Base + Add (without heroes/buffs)         : {int(base_cap + default_cap + tech_add):,}")
        
        # 4. Heroes
        hero_sys = task.get_ctrl('heroSysCtrl') or {}
        hl = hero_sys.get('heroList', {})
        print(f"  • Owned Heroes Count: {len(hl)}")
        for hid, h in list(hl.items())[:5]:
            hlv = int(h.get('level', 1))
            hrar = heroes.get(int(hid), {}).get('rarity', 1)
            hname = heroes.get(int(hid), {}).get('name', f'Hero_{hid}')
            hmarch = rare_levels.get(hrar, {}).get(hlv, 0)
            print(f"     - Hero {hid} ({hname}): Lv.{hlv}, Rarity {hrar} -> March Capacity +{hmarch:,}")

        await b.stop()

    asyncio.run(test_live())

