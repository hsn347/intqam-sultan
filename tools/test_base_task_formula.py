import json

d = json.load(open('docs/beetoo1_live_memory.json', encoding='utf-8'))
print("docs/beetoo1_live_memory keys:", d.keys() if isinstance(d, dict) else type(d))
if isinstance(d, dict) and 'heroSysCtrl' in d:
    hlist = d['heroSysCtrl'].get('heroList', {})
    for hid, h in hlist.items():
        print(f"Hero {hid}: lv={h.get('level')}, quality={h.get('quality')}, state={h.get('state')}")
