import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

hlist = data.get("heroSysCtrl", {}).get("heroList", {})
check_heroes = [1703, 1709, 1704, 1700, 1705, 1701, 1706]
for hid in check_heroes:
    h = hlist.get(str(hid))
    if h:
        print(f"Hero {hid}: level={h.get('level')}")
    else:
        print(f"Hero {hid}: NOT OWNED")
