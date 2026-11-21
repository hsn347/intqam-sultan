# -*- coding: utf-8 -*-
import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    b1 = json.load(f)
with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    b2 = json.load(f)

print("=== COMPARING B1 vs B2 ===")

# 1. Lord Level
l1 = b1.get('lordInfoCtrl', {}).get('base', {})
l2 = b2.get('lordInfoCtrl', {}).get('base', {})
print("Lord base b1:", l1)
print("Lord base b2:", l2)

# 2. Alliance Science
sci1 = b1.get('allianceCtrl', {}).get('sciencelist', {})
sci2 = b2.get('allianceCtrl', {}).get('sciencelist', {})
print("\nAlliance Science diff:")
all_sci = set(list(sci1.keys()) + list(sci2.keys()))
for s in sorted(all_sci):
    v1 = sci1.get(s)
    v2 = sci2.get(s)
    if v1 != v2:
        print(f"  Sci {s}: b1={v1}, b2={v2}")

# 3. Technology diff
t1 = b1.get('technologyCtrl', {})
t2 = b2.get('technologyCtrl', {})
print("\nTechnology diff:")
all_t = set(list(t1.keys()) + list(t2.keys()))
for t in sorted(all_t):
    v1 = t1.get(t)
    v2 = t2.get(t)
    if v1 != v2:
        print(f"  Tech {t}: b1={v1}, b2={v2}")

# 4. Buildings diff (for non-resource buildings)
def get_builds(d):
    res = {}
    for b in d.get('cityCtrl', {}).get('blist', []):
        info = b.get('binfo', {})
        bid = str(info.get('bid', ''))
        lv = int(info.get('lv', 0))
        star = int(info.get('starLv', 0))
        res[bid] = max(res.get(bid, (0, 0)), (lv, star))
    return res

blds1 = get_builds(b1)
blds2 = get_builds(b2)
print("\nBuilding levels diff:")
for bid in sorted(set(list(blds1.keys()) + list(blds2.keys()))):
    if blds1.get(bid) != blds2.get(bid):
        print(f"  Bid {bid}: b1={blds1.get(bid)}, b2={blds2.get(bid)}")
