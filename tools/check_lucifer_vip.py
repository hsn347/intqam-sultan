import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

lord = data.get("lordInfoCtrl", {})
print("Lucifer VIP in lordInfoCtrl:")
print(json.dumps(lord.get("vip"), indent=2))
