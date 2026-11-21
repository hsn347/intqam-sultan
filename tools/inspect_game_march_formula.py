# -*- coding: utf-8 -*-
"""
فحص دقيق للمعادلة الحرفية لحساب السعة القصوى للفيلق، وترتيب الأبطال، وفحص بيانات beetoo1 و beetoo2
"""
import json
import re
import math

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

def parse_build121():
    with open('game_file/src/app/localtb/config_server/build121.lua', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    chunks = text.split(';(nil).index = ')
    caps = {}
    for c in chunks[1:]:
        blv_m = re.search(r'blv\s*=\s*(?:nil,\s*)*(\d+)', c)
        cap_m = re.search(r'capacity\s*=\s*(?:nil,\s*)*(\d+)', c)
        if blv_m and cap_m:
            caps[int(blv_m.group(1))] = int(cap_m.group(1))
    return caps

if __name__ == '__main__':
    hero_info = parse_hero_view_info()
    rare_lvs = parse_hero_level_config()
    b121 = parse_build121()
    print("Build 121 Lv 27 capacity:", b121.get(27))
    print("Sample heroes rarity & lv 60 march_add:")
    for hid in [1700, 1701, 1702, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1710, 1711, 1712, 1713, 1714, 1717, 1718]:
        if hid in hero_info:
            r = hero_info[hid]['rarity']
            m60 = rare_lvs.get(r, {}).get(60, 0)
            print(f"  Hero {hid} ({hero_info[hid]['name']}): rarity={r}, march_add@lv60={m60}")
