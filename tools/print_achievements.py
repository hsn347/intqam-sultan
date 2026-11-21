import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

ach = diag.get("achievementctrl", {})
print(json.dumps(ach, ensure_ascii=False, indent=2))
