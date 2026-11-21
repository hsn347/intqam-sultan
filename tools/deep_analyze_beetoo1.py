# -*- coding: utf-8 -*-
import json
import math

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    b1 = json.load(f)

# Drill ground
build_list = b1.get('cityCtrl', {}).get('buildList', {})
# find drill ground
drill = None
for k, b in build_list.items():
    if b.get('bid') == 121:
        drill = b
        break
print("Drill ground:", drill)

# Tech
tech_list = b1.get('technologyCtrl', {}).get('techList', {})
print("Tech 24016:", tech_list.get('24016'))
print("Tech 24032:", tech_list.get('24032'))
print("Tech 25030:", tech_list.get('25030'))

# Let's inspect all tech in techList
for tid, t in tech_list.items():
    if int(tid) in [24016, 24032, 25030, 24077, 24073, 24095]:
        print(f"Tech {tid}: lv={t.get('level')}")

# Lord buffs / buffCtrl
buffs = b1.get('buffCtrl', {})
print("buffCtrl keys:", buffs.keys() if isinstance(buffs, dict) else type(buffs))
if isinstance(buffs, dict):
    print("buffList:", buffs.get('buffList'))

# lord info / fcInfo
lord = b1.get('lordInfoCtrl', {})
print("lordInfo level:", lord.get('level'), "vip:", b1.get('vipCtrl', {}).get('vipLevel'))

# let's check all heroes in b1
hl = b1.get('heroSysCtrl', {}).get('heroList', {})
print("\nAll Heroes in b1:")
for hid, h in sorted(hl.items(), key=lambda x: int(x[0])):
    print(f"  Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}")
