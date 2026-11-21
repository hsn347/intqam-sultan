import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

for name in ["lordSkillCtrl", "militaryRankCtrl", "allianceCtrl", "equipmentCtrl", "petCtrl"]:
    print(f"\n=================== {name} ===================")
    print(json.dumps(diag.get(name), ensure_ascii=False, indent=2))
