import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    data = json.load(f)

army = data.get("armyCtrl", {})
print("defCompileInfo:", army.get("defCompileInfo"))
print("activeDefCompile:", army.get("activeDefCompile"))
