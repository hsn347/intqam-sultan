import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

lord = lucifer.get("lordInfoCtrl", {})
print("lordInfoCtrl keys:", list(lord.keys()))
for k, v in lord.items():
    if k not in ["skill"]:
        print(f" {k}: {v}")
