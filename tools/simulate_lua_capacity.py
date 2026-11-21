import json
import re

# Parse hero_view_info.lua
with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    t_view = f.read()

# Parse hero_level_config.lua
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    t_level = f.read()

# heroID -> rarity
# In hero_view_info:
# heroID = (\d+).*?rarity = nil, (\d+)
matches = re.findall(r'heroID\s*=\s*(\d+).*?rarity\s*=\s*(?:nil,\s*)?(\d+)', t_view, re.DOTALL)
herosInfo_rarity = {int(hid): int(r) for hid, r in matches}

# heroRare2LevelInfo[rarity][level] -> march_add
entries = []
pattern = re.compile(r'ID\s*=\s*(\d+).*?rarity\s*=\s*(\d+).*?level\s*=\s*(\d+).*?march_add\s*=\s*(\d+)', re.DOTALL)
for m in pattern.finditer(t_level):
    entries.append({
        'rarity': int(m.group(2)),
        'level': int(m.group(3)),
        'march_add': int(m.group(4))
    })

heroRare2LevelInfo = {}
for e in entries:
    r = e['rarity']
    lv = e['level']
    if r not in heroRare2LevelInfo:
        heroRare2LevelInfo[r] = {}
    heroRare2LevelInfo[r][lv] = e['march_add']

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

for name, d in [('beetoo2', d2), ('beetoo1', d1)]:
    print(f"\n=== {name} LUA heroltCtrl:getHerosMarchCapacity ===")
    hlist = d.get('heroSysCtrl', {}).get('heroList', {})
    for hid_str, h in sorted(hlist.items(), key=lambda x: int(x[0])):
        hid = int(hid_str)
        lv = int(h.get('level', 1))
        pType = herosInfo_rarity.get(hid, 1)
        march_add_by_pType = heroRare2LevelInfo.get(pType, {}).get(lv, 0)
        # also by quality
        q = int(h.get('quality', 1))
        march_add_by_quality = heroRare2LevelInfo.get(q, {}).get(lv, 0)
        if lv > 1:
            print(f"  Hero {hid}: lv={lv}, quality={q}, pType(config_rarity)={pType} -> by_pType={march_add_by_pType}, by_quality={march_add_by_quality}")
