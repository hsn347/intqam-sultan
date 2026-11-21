import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

hlist = d1.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in sorted(hlist.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    print(f"Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}, isAwake={h.get('isAwake')}")
