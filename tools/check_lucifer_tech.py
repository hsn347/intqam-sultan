import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tctrl = data.get("technologyCtrl", {})
print("Technologies in Lucifer:")
for k, v in tctrl.items():
    print(k, v)
