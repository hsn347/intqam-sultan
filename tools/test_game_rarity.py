# -*- coding: utf-8 -*-
import json
import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

level_cfg = {}
chunks = text.split(';(nil).ID = ')
for c in chunks[1:]:
    r_m = re.search(r'rarity\s*=\s*(\d+)', c)
    l_m = re.search(r'level\s*=\s*(\d+)', c)
    m_m = re.search(r'march_add\s*=\s*(\d+)', c)
    if r_m and l_m and m_m:
        level_cfg[(int(r_m.group(1)), int(l_m.group(1)))] = int(m_m.group(1))

rarities = {
    1700: 1, 1701: 1, 1702: 1, 1703: 1, 1704: 2, 1705: 2, 1706: 2, 1707: 2,
    1708: 2, 1709: 2, 1710: 3, 1711: 3, 1712: 3, 1713: 4, 1714: 3, 1717: 2, 1718: 2
}

print("=== MARCH ADD FOR RARITIES 1..5 AT LEVEL 60 ===")
for r in range(1, 6):
    print(f"Rarity {r} at Lv.60: {level_cfg.get((r, 60))}")

print("\n=== BEETOO2 HEROES (Quality vs Rarity) ===")
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    b2 = json.load(f)
for hid, h in sorted(b2.get('heroSysCtrl', {}).get('heroList', {}).items(), key=lambda x: int(x[0])):
    hid = int(hid)
    lv = h.get('level', 1)
    if lv > 1:
        q = h.get('quality', 1)
        r = rarities.get(hid, 1)
        m_q = level_cfg.get((q, lv), 0)
        m_r = level_cfg.get((r, lv), 0)
        print(f"Hero {hid}: lv={lv}, Quality={q} (march={m_q}), Rarity={r} (march={m_r})")
