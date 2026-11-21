import json

with open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8", errors="ignore") as f:
    data = json.load(f)

print("=== 1. cityCtrl ===")
city = data.get("cityCtrl", {})
blist = city.get("blist", [])
for b in blist:
    binfo = b.get("binfo", b)
    if str(binfo.get("bid")) == "121":
        print("Drill grounds found in blist:", binfo)

print("\n=== 2. technologyCtrl ===")
tech = data.get("technologyCtrl", {})
print("type of technologyCtrl:", type(tech))
if isinstance(tech, dict):
    print("Sample items in technologyCtrl:", list(tech.items())[:5])
elif isinstance(tech, list):
    print("Sample items in technologyCtrl:", tech[:5])

print("\n=== 3. buffCtrl ===")
buff = data.get("buffCtrl", {})
print("type of buffCtrl:", type(buff))
if isinstance(buff, dict):
    print("buffCtrl keys:", list(buff.keys()))
    for k, v in list(buff.items())[:5]:
        print(f"  {k}: {v}")
elif isinstance(buff, list):
    print("buffCtrl list sample:", buff[:5])

print("\n=== 4. lordInfoCtrl ===")
lord = data.get("lordInfoCtrl", {})
if isinstance(lord, dict):
    print("lordInfoCtrl sample keys:", list(lord.keys())[:15])
    print("vip in lord:", lord.get("vip"), "vipLv:", lord.get("vipLv"), "vipPoint:", lord.get("vipPoint"))

print("\n=== 5. equipmentCtrl ===")
equip = data.get("equipmentCtrl", {})
if isinstance(equip, dict):
    print("equipmentCtrl keys:", list(equip.keys()))
    for k, v in equip.items():
        if isinstance(v, list):
            print(f"  {k} (list len={len(v)}):", v[:3])
        elif isinstance(v, dict):
            print(f"  {k} (dict len={len(v)}):", list(v.keys())[:5])
