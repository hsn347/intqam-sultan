import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

eq_arr = data.get("equipmentCtrl", {}).get("equipment_array", [])
worn = [e for e in eq_arr if e.get("wear") == 1]
for w in worn:
    print(w)
