import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

# check dress.list of all heroes
hlist = d1.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in hlist.items():
    d = h.get('dress', {})
    dlist = d.get('list', {}) if isinstance(d, dict) else {}
    if len(dlist) > 1 or any(k != f"{hid}01" for k in dlist):
        print(f"Hero {hid} has custom dress:", dlist)
print("Done checking hero dresses.")
