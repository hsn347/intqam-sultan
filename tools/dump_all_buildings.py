import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

blist = lucifer.get("cityCtrl", {}).get("blist", [])
print(f"Total buildings in Lucifer: {len(blist)}")
for b in blist:
    binfo = b.get("binfo", {})
    bid = binfo.get("bid")
    lv = binfo.get("lv")
    star = binfo.get("starLv")
    index = binfo.get("index")
    print(f"  bid={bid}, lv={lv}, starLv={star}, index={index}")
