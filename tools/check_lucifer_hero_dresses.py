import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

hlist = data.get("heroSysCtrl", {}).get("heroList", {})
for hid, h in hlist.items():
    dress = h.get("dress")
    if dress:
        print(f"Hero {hid} dress:", dress)
