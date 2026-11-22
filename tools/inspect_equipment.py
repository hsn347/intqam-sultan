import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

eq = data.get("equipmentCtrl", {})
print("equipmentCtrl keys:", list(eq.keys()))
for k, v in eq.items():
    print(f"\n--- {k} ---")
    s = json.dumps(v, indent=2)
    print(s[:500] if len(s) > 500 else s)
