import json

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

print("buffCtrl in beetoo1:")
print(json.dumps(diag.get("buffCtrl"), indent=2))
