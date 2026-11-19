import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

for ctrl_name in ["lordSkillCtrl", "petCtrl", "wallsCtrl", "armyCtrl"]:
    print(f"\n==================== {ctrl_name} ====================")
    print(json.dumps(data.get(ctrl_name, {}), indent=2)[:3000])

print(f"\n==================== lordInfoCtrl keys ====================")
lord = data.get("lordInfoCtrl", {})
for k, v in lord.items():
    print(f"  {k}: {str(v)[:100]}")
