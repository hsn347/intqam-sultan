import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

city = diag.get("cityCtrl", {})
blist = city.get("blist", [])
for b in blist:
    binfo = b.get("binfo", b)
    if str(binfo.get("bid")) == "121":
        print("Drill grounds found:", binfo)
