import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

hb = data.get("heroBiographyCtrl", {})
print("Lucifer heroBiographyCtrl:")
print(json.dumps(hb, indent=2, ensure_ascii=False))
