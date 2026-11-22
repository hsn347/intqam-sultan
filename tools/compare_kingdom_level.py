import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("Lucifer playerKingdomLevelCtrl:")
print(json.dumps(data.get("playerKingdomLevelCtrl"), indent=2))

print("\nbeetoo1 playerKingdomLevelCtrl:")
with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    b1 = json.load(f)
print(json.dumps(b1.get("playerKingdomLevelCtrl"), indent=2))
