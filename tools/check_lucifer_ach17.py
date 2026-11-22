import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

ach = data.get("achievementctrl", {})
print("Lucifer achievement 17:")
print(ach.get("list", {}).get("17"))
