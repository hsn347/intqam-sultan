import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', 'r', encoding='utf-8') as f:
    d2 = json.load(f)

print("=== 1. CITY BUILDINGS ===")
def get_drill(d):
    for b in d.get('cityCtrl', {}).get('buildList', []):
        if b.get('bid') == 121:
            return b
    # or in blist / dict
    bl = d.get('cityCtrl', {}).get('blist', [])
    for b in bl:
        binfo = b.get('binfo', b)
        if str(binfo.get('bid')) == '121':
            return binfo
    return None

print("beetoo1 drill:", get_drill(d1))
print("beetoo2 drill:", get_drill(d2))

print("\n=== 2. TECHNOLOGIES ===")
t1 = d1.get('technologyCtrl', {})
t2 = d2.get('technologyCtrl', {})
print("beetoo1 tech count:", len(t1), "beetoo2 tech count:", len(t2))

# Check leadership tech (24016, 24032, 25030, etc.)
for tid in [24016, 24032, 25030, 24048, 110027]:
    v1 = t1.get(str(tid)) or [x for x in t1.values() if isinstance(x, list) and x and x[0] == tid]
    v2 = t2.get(str(tid)) or [x for x in t2.values() if isinstance(x, list) and x and x[0] == tid]
    print(f"Tech {tid}: beetoo1={v1}, beetoo2={v2}")

print("\n=== 3. LORD INFO & VIP ===")
lord1 = d1.get('lordInfoCtrl', {})
lord2 = d2.get('lordInfoCtrl', {})
for k in ['vip', 'level', 'medal', 'achieve', 'buff']:
    print(f"lord1 {k}:", {sk: sv for sk, sv in lord1.items() if k in sk.lower()})
    print(f"lord2 {k}:", {sk: sv for sk, sv in lord2.items() if k in sk.lower()})

print("\n=== 4. HEROES DETAILED ===")
h1 = d1.get('heroSysCtrl', {}).get('heroList', {})
h2 = d2.get('heroSysCtrl', {}).get('heroList', {})
print("beetoo1 heroes:")
for hid, h in sorted(h1.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    if h.get('level', 0) >= 40:
        print(f"  Hero {hid}: lv={h.get('level')}, q={h.get('quality')}, state={h.get('state')}, awake={h.get('isAwake')}")

print("beetoo2 heroes:")
for hid, h in sorted(h2.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    if h.get('level', 0) >= 40:
        print(f"  Hero {hid}: lv={h.get('level')}, q={h.get('quality')}, state={h.get('state')}, awake={h.get('isAwake')}")
