import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

city = data.get("cityCtrl", {})
blist = city.get("blist", [])
for b in blist:
    binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
    if str(binfo.get("bid")) == "121":
        print("Drill grounds:", binfo)
    if str(binfo.get("bid")) == "101":
        print("Castle:", binfo)
    if str(binfo.get("bid")) == "301":
        print("Glory Palace:", binfo)
