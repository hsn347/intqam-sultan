import json
import re

# Read hero_view_info.lua for all hero rarities
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern: heroID = (\d+).*?rarity = nil, (\d+)
matches = re.findall(r'heroID\s*=\s*(\d+).*?rarity\s*=\s*(?:nil,\s*)?(\d+)', text, re.DOTALL)
herosInfo_rarity = {int(hid): int(r) for hid, r in matches}
print(f"Total hero view info parsed: {len(herosInfo_rarity)}")

# Read hero_level_config.lua
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    hl_text = f.read()

hl_matches = re.findall(r'rarity\s*=\s*(\d+).*?level\s*=\s*(\d+).*?march_add\s*=\s*(\d+)', hl_text, re.DOTALL)
heroRare2LevelInfo = {}
for r, l, m in hl_matches:
    heroRare2LevelInfo[(int(r), int(l))] = int(m)

# Beetoo2 top heroes:
# 1712, 1717, 1700, 1711, 1707
print("\n--- BEETOO2 HEROES ---")
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)
h2 = d2.get('heroSysCtrl', {}).get('heroList', {})

# Case 1: using hInfo.quality (or rarity if quality==0)
print("Case 1: using hInfo.quality:")
tot_q = 0
for hid in [1712, 1717, 1700, 1711, 1707]:
    info = h2.get(str(hid), {})
    q = info.get('quality')
    lv = info.get('level')
    m = heroRare2LevelInfo.get((q, lv), 0)
    print(f"  Hero {hid}: quality={q}, lv={lv} -> march_add={m}")
    tot_q += m
print("  Total using quality:", tot_q)
tot2_case1 = (100500 + tot_q) * 1.01
print("  Total with 1.01 buff:", tot2_case1)

# Case 2: using herosInfo[hid].rarity
print("\nCase 2: using herosInfo[hid].rarity:")
tot_r = 0
for hid in [1712, 1717, 1700, 1711, 1707]:
    info = h2.get(str(hid), {})
    r = herosInfo_rarity.get(hid, 1)
    lv = info.get('level')
    m = heroRare2LevelInfo.get((r, lv), 0)
    print(f"  Hero {hid}: rarity={r}, lv={lv} -> march_add={m}")
    tot_r += m
print("  Total using rarity:", tot_r)
tot2_case2 = (100500 + tot_r) * 1.01
print("  Total with 1.01 buff:", tot2_case2)
