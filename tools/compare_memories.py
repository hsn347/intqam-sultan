import json

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

hlist = d.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in sorted(hlist.items(), key=lambda x: (x[1].get('level', 0), x[1].get('quality', 0)), reverse=True):
    if h.get('level', 0) > 1:
        print(f"Hero {hid}: level={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}, isAwake={h.get('isAwake')}")
