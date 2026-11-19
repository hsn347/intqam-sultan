import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

blist = data.get("cityCtrl", {}).get("blist", [])
for b in blist:
    binfo = b.get("binfo", {})
    if str(binfo.get("bid")) == "121":
        print("BID 121 full item:", json.dumps(b, indent=2))
