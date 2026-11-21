import json
import re

# Load hero_view_info to get hero rarities
rarities = {}
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Pattern for hero rarity: [(hid)] = { ... rarity = X ... }
for m in re.finditer(r'\[(\d+)\]\s*=\s*\{[^}]*rarity\s*=\s*(\d+)', text):
    rarities[int(m.group(1))] = int(m.group(2))

# Load hero_level_config
# [rarity] = { [level] = { ... march_add = X ... } }
level_config = {}
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    ltext = f.read()

for m in re.finditer(r'\[(\d+)\]\s*=\s*\{[^}]*march_add\s*=\s*(\d+)', ltext):
    pass # let's parse more cleanly

# Let's write a python parser for hero_level_config
def parse_hero_level_config():
    with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # We can match [rarity] = { [level] = { march_add = X, ... } }
    # Or simpler: split by rarity
    table = {}
    # Let's use regex to find all [rarity] blocks
    # Actually lua table format:
    # [1] = { [1] = { ... }, ... }
    lines = content.split('\n')
    cur_rarity = None
    cur_level = None
    for line in lines:
        rm = re.match(r'^\s*\[(\d+)\]\s*=\s*\{', line)
        if rm:
            num = int(rm.group(1))
            if cur_rarity is None or num <= 5:
                cur_rarity = num
                if cur_rarity not in table:
                    table[cur_rarity] = {}
            else:
                cur_level = num
        mm = re.search(r'march_add\s*=\s*(\d+)', line)
        if mm and cur_rarity and cur_level:
            table[cur_rarity][cur_level] = int(mm.group(1))
    return table

cfg = parse_hero_level_config()

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    b1_heroes = json.load(f)['heroSysCtrl']['heroList']

print("=== Beetoo1 Heroes March Capacity ===")
hero_caps = []
for hid_str, hinfo in b1_heroes.items():
    hid = int(hid_str)
    lvl = hinfo.get('level', 1)
    q = hinfo.get('quality', 1)
    st = hinfo.get('state', 1)
    rarity = rarities.get(hid, q)
    m_add = cfg.get(rarity, {}).get(lvl, 0)
    hero_caps.append((hid, lvl, rarity, q, st, m_add))

hero_caps.sort(key=lambda x: (x[5], x[1], x[2]), reverse=True)
for h in hero_caps:
    print(f"Hero {h[0]}: lvl={h[1]} rarity={h[2]} quality={h[3]} state={h[4]} -> march_add={h[5]}")
