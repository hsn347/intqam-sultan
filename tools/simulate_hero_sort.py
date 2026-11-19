# -*- coding: utf-8 -*-
import json

with open('tools/beetoo2_diagnostics.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

heroes = d.get('heroes', [])

# Rarities:
# 1712: 3 (lvl 60 -> march_add 7000)
# 1711: 3 (lvl 60 -> march_add 7000)
# 1709: 3 (lvl 52 -> march_add ?)
# 1707: 2 (lvl 60 -> march_add 6000)
# 1708: 2 (lvl 60 -> march_add 6000)
# 1717: 2 (lvl 60 -> march_add 6000)
# 1700: 1 (lvl 60 -> march_add 5000)
# 1703: 1 (lvl 59 -> march_add ?)

# Let's get exact march_add from hero_level_config
import re
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

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
        rare_level_march.setdefault(r, {})[l] = m

# Rarities from hero_view_info
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text2 = f.read()

hero_rarity = {}
for h in heroes:
    hid = h['id']
    m = re.search(rf'\(nil\)\[{hid}\].*?rarity\s*=\s*(?:nil,\s*)?(\d+)', text2, re.DOTALL)
    if not m:
        m = re.search(rf'rarity\s*=\s*(?:nil,\s*)?(\d+).*?\(nil\)\[{hid}\]', text2, re.DOTALL)
    if m:
        hero_rarity[hid] = int(m.group(1))
    else:
        # search chunk
        idx = text2.find(str(hid))
        if idx != -1:
            chunk = text2[idx:idx+200]
            m_r = re.search(r'rarity\s*=\s*(?:nil,\s*)?(\d+)', chunk)
            if m_r:
                hero_rarity[hid] = int(m_r.group(1))

print("Hero rarities:", hero_rarity)

# Calculate sort keys for sortDispatchHerosID:
# states: {HERO_STATE_NORMAL: 1, HERO_STATE_GARRISON: 1}
# 1. V (state == 1 -> 1 else 0)
# 2. ownL (false)
# 3. MarchNum
# 4. level
# 5. Rarity
# 6. quality
# 7. -heroID

sorted_heroes = []
for h in heroes:
    hid = int(h['id'])
    lvl = int(h.get('level', 1))
    qual = int(h.get('quality', 1))
    state = int(h.get('state', 1))
    r = hero_rarity.get(hid, 1)
    march_num = rare_level_march.get(r, {}).get(lvl, 0)
    V = 1 if state == 1 else 0
    sort_tuple = (V, False, march_num, lvl, r, qual, -hid)
    sorted_heroes.append({
        'hid': hid,
        'lvl': lvl,
        'rarity': r,
        'quality': qual,
        'state': state,
        'march_num': march_num,
        'sort_tuple': sort_tuple
    })

sorted_heroes.sort(key=lambda x: x['sort_tuple'], reverse=True)

print("\n--- Sorted Heroes for Dispatch ---")
for i, h in enumerate(sorted_heroes):
    print(f"[{i+1}] Hero {h['hid']}: march={h['march_num']}, lvl={h['lvl']}, rarity={h['rarity']}, quality={h['quality']}")

top5 = sorted_heroes[:5]
top5_march = sum(x['march_num'] for x in top5)
print(f"\nTop 5 heroes march total: {top5_march}")
