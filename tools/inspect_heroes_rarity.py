# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

import re
heroes = [1700, 1701, 1702, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1710, 1711, 1712, 1713, 1714, 1717, 1718]

for hid in heroes:
    idx = text.find(f'heroID = {hid}')
    if idx != -1:
        chunk = text[idx:idx+400]
        rarity_m = re.search(r'rarity\s*=\s*(?:nil,\s*)?(\d+)', chunk)
        rarity = rarity_m.group(1) if rarity_m else "unknown"
        print(f"Hero {hid}: rarity={rarity}")
    else:
        print(f"Hero {hid}: NOT FOUND")
