import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("Lucifer warGemCtrl:")
print(json.dumps(data.get("warGemCtrl"), indent=2))

print("\nbeetoo1 warGemCtrl:")
with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    b1 = json.load(f)
print(json.dumps(b1.get("warGemCtrl"), indent=2))
