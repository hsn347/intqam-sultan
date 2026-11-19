import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

heroes = data.get("heroSysCtrl", {}).get("heroList", {})
for hid, hdata in heroes.items():
    print(f"Hero {hid}: quality={hdata.get('quality')}, level={hdata.get('level')}")
