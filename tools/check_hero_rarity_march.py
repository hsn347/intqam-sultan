# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Parse hero_level_config
# Entries look like:
# ;(nil).rarity = 1
# ;(nil).level = 60
# ;(nil).march_add = 7000
entries = re.split(r';\(nil\)\.ID\s*=\s*\d+', text)
rare_level_march = {}
for e in entries[1:]:
    m_r = re.search(r'rarity\s*=\s*(\d+)', e)
    m_l = re.search(r'level\s*=\s*(\d+)', e)
    m_m = re.search(r'march_add\s*=\s*(\d+)', e)
    if m_r and m_l and m_m:
        r = int(m_r.group(1))
        l = int(m_l.group(1))
        m = int(m_m.group(1))
        if r not in rare_level_march:
            rare_level_march[r] = {}
        rare_level_march[r][l] = m

print("Rarities in hero_level_config:", rare_level_march.keys())
for r in sorted(rare_level_march.keys()):
    print(f"Rarity {r}: lvl 1={rare_level_march[r].get(1)}, lvl 60={rare_level_march[r].get(60)}")

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text2 = f.read()

chunks = re.split(r';\(nil\)\.heroID\s*=\s*', text2)
hero_rarity = {}
for c in chunks:
    m_id = re.match(r'(\d+)', c)
    if m_id:
        hid = int(m_id.group(1))
        m_r = re.search(r'rarity\s*=\s*(\d+)', c)
        if m_r:
            hero_rarity[hid] = int(m_r.group(1))

print(f"Parsed {len(hero_rarity)} heroes from hero_view_info.lua")
for hid in [1700, 1707, 1708, 1709, 1711, 1712, 1717]:
    r = hero_rarity.get(hid)
    march60 = rare_level_march.get(r, {}).get(60) if r else None
    print(f"Hero {hid}: rarity={r}, march_add at lvl 60={march60}")
