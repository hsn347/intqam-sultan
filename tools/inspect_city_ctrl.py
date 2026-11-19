import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

city = data.get("cityCtrl", {})
print("cityCtrl keys:", list(city.keys()))
for k, v in city.items():
    if k != "blist":
        print(f"\n--- {k} ---")
        print(json.dumps(v, indent=2)[:500])
