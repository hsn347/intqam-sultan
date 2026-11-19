import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

blist = data.get("cityCtrl", {}).get("blist", [])
print(f"Total buildings in blist: {len(blist)}")
for b in blist:
    binfo = b.get("binfo", {})
    bid = binfo.get("bid")
    lv = binfo.get("lv")
    star = binfo.get("starLv", 0)
    print(f"  bid={bid}, lv={lv}, starLv={star}")
