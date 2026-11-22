import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

print("=== Lucifer petCtrl ===")
print(json.dumps(lucifer.get("petCtrl"), indent=2, ensure_ascii=False))

with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    beetoo = json.load(f)

print("=== Beetoo1 petCtrl ===")
print(json.dumps(beetoo.get("petCtrl"), indent=2, ensure_ascii=False))







