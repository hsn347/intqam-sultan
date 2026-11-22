import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

c = lucifer.get("cityCtrl", {})
print("cityCtrl keys:", list(c.keys()))
for k, v in c.items():
    if k != "blist":
        print(f" {k}: {v}")

blist = c.get("blist", {})
print(f"blist count: {len(blist)}")
# find any drill ground or special building
stars = [b.get("binfo") for b in blist if int(b.get("binfo", {}).get("starLv", 0)) > 0]
print("Buildings with starLv > 0:", len(stars))

for bdata in blist:
    binfo = bdata.get("binfo", {})
    if str(binfo.get("bid")) in ["121", "101", "301"]:
        print(f" building {binfo.get('bid')}: {binfo}")



