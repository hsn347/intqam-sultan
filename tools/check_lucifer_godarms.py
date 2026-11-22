import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("godArmsCtrl in Lucifer:")
print(json.dumps(data.get("godArmsCtrl"), indent=2, ensure_ascii=False))
