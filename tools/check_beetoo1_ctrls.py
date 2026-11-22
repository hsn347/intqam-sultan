import json

with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    b1 = json.load(f)

print("beetoo1 nebulaTowerCtrl:", b1.get("nebulaTowerCtrl"))
print("beetoo1 playerKingdomLevelCtrl:", b1.get("playerKingdomLevelCtrl"))
print("beetoo1 heroBiographyCtrl:", b1.get("heroBiographyCtrl"))
