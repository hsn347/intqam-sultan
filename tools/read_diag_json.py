import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

city = data.get("cityCtrl", {})
blist = city.get("blist", [])
for b in blist:
    binfo = b.get("binfo", b)
    if str(binfo.get("bid")) in ["101", "121", "113"]:
        print(binfo.get("bid"), "=>", binfo)

tech = data.get("technologyCtrl", {})
print("Tech keys count:", len(tech))
for k, v in list(tech.items())[:10]:
    print(" ", k, "=>", v)
