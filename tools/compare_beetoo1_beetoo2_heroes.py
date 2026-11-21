# -*- coding: utf-8 -*-
import json
import re

def parse_hero_view_info():
    with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    chunks = text.split(';(nil).heroID = ')
    hero_info = {}
    for c in chunks[1:]:
        lines = c.splitlines()
        hid = int(lines[0].strip().split(',')[0])
        rarity_m = re.search(r'rarity\s*=\s*(?:nil,\s*)*(\d+)', c)
        name_m = re.search(r'name\s*=\s*"([^"]+)"', c)
        rarity = int(rarity_m.group(1)) if rarity_m else 1
        name = name_m.group(1) if name_m else str(hid)
        hero_info[hid] = {'rarity': rarity, 'name': name}
    return hero_info

def parse_hero_level_config():
    with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    current = {}
    levels = {}
    for l in lines:
        l = l.strip()
        if 'ID =' in l:
            if 'rarity' in current and 'level' in current:
                r = current['rarity']
                lv = current['level']
                levels.setdefault(r, {})[lv] = current.get('march_add', 0)
            current = {}
        elif 'rarity =' in l:
            current['rarity'] = int(l.split('=')[-1].strip().split(',')[0])
        elif 'level =' in l:
            current['level'] = int(l.split('=')[-1].strip().split(',')[0])
        elif 'march_add =' in l:
            current['march_add'] = int(l.split('=')[-1].strip().split(',')[0])
    if 'rarity' in current and 'level' in current:
        levels.setdefault(current['rarity'], {})[current['level']] = current.get('march_add', 0)
    return levels

hero_meta = parse_hero_view_info()
rare_lvs = parse_hero_level_config()

def get_hero_march_add(hid, lv):
    r = hero_meta.get(int(hid), {}).get('rarity', 1)
    return rare_lvs.get(r, {}).get(int(lv), 0)

for tag, path in [('beetoo1', 'tools/beetoo1_full_init_data.json'), ('beetoo2', 'tools/beetoo2_full_init_data.json')]:
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        d = json.load(f)
    hl = d.get('heroSysCtrl', {}).get('heroList', {})
    defendList = d.get('heroSysCtrl', {}).get('defendList', {})
    print(f"\n=================== {tag} (defendList: {list(defendList.values())}) ===================")
    hero_records = []
    for hid_str, hdata in hl.items():
        hid = int(hid_str)
        lv = hdata.get('level', 1)
        st = hdata.get('state', 1)
        q = hdata.get('quality', 1)
        awake = hdata.get('isAwake', False)
        rarity = hero_meta.get(hid, {}).get('rarity', 1)
        name = hero_meta.get(hid, {}).get('name', str(hid))
        march_base = get_hero_march_add(hid, lv)
        
        # Check skillList buffs:
        skills = hdata.get('skillList', {})
        # We will check if any skill gives MARCH_VALUE_LIMIT_BOOST
        hero_records.append({
            'hid': hid,
            'name': name,
            'lv': lv,
            'state': st,
            'quality': q,
            'rarity': rarity,
            'march_base': march_base,
            'skills': list(skills.keys()),
            'powerSkill': list(hdata.get('powerSkill', {}).keys()),
            'masterySkill': list(hdata.get('masterySkill', {}).keys()),
        })
    # Sort according to sortDispatchHerosID:
    # 1. V (state == 1 => 1, else 0)
    # 2. ownL (false for now)
    # 3. MarchNum (march_base)
    # 4. level
    # 5. Rarity
    # 6. quality
    # 7. hid (lower first)
    hero_records.sort(key=lambda x: (
        1 if x['state'] == 1 else 0,
        x['march_base'],
        x['lv'],
        x['rarity'],
        x['quality'],
        -x['hid']
    ), reverse=True)
    
    print("Top 10 sorted heroes:")
    top5_march = 0
    for idx, hr in enumerate(hero_records[:10]):
        if idx < 5:
            top5_march += hr['march_base']
        print(f"  #{idx+1}: Hero {hr['hid']} ({hr['name']}): lv={hr['lv']}, rarity={hr['rarity']}, quality={hr['quality']}, state={hr['state']} -> march_add={hr['march_base']}")
    print(f"Total Top 5 March Add = {top5_march}")
