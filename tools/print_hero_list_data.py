import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

heroes = data.get("heroSysCtrl", {}).get("heroList", {})
for hid, hdata in heroes.items():
    print(f"Hero {hid}: level={hdata.get('level')}, state={hdata.get('state')}, keys={list(hdata.keys())}")
