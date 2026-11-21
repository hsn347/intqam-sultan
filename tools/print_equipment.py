import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

eq = diag.get("equipmentCtrl", {})
print(json.dumps(eq, ensure_ascii=False, indent=2))
