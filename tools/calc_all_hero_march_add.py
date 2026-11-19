# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

rare_levels = {}
cur_rare = None
cur_lv = None

for l in lines:
    if 'rarity =' in l:
        cur_rare = int(l.split('=')[1].strip())
    if 'level =' in l and 'march_add' not in l:
        cur_lv = int(l.split('=')[1].strip())
    if 'march_add =' in l and cur_rare and cur_lv:
        madd = int(l.split('=')[1].strip())
        if cur_rare not in rare_levels: rare_levels[cur_rare] = {}
        rare_levels[cur_rare][cur_lv] = madd
        cur_lv = None

# Beetoo2 heroes:
heroes = {
    1700: (1, 60), # Rarity 1, Lv 60
    1701: (1, 1),
    1702: (1, 1),
    1703: (1, 59), # Rarity 1, Lv 59
    1704: (2, 1),
    1705: (2, 1),
    1706: (2, 1),
    1707: (2, 60), # Rarity 2, Lv 60
    1708: (2, 60), # Rarity 2, Lv 60
    1709: (2, 52), # Rarity 2, Lv 52
    1710: (3, 1),
    1711: (3, 60), # Rarity 3, Lv 60
    1712: (3, 60), # Rarity 3, Lv 60
    1713: (4, 1),
    1714: (3, 1),
    1717: (2, 60), # Rarity 2, Lv 60
    1718: (2, 1),
}

for hid, (r, lv) in sorted(heroes.items()):
    m = rare_levels.get(r, {}).get(lv, 0)
    print(f"Hero {hid}: Rarity {r}, Lv {lv} => march_add = {m}")
