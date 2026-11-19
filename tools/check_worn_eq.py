import json

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

eq_arr = data.get("equipmentCtrl", {}).get("equipment_array", [])
worn = [e for e in eq_arr if e.get("wear") == 1]
print(f"Total equipment: {len(eq_arr)}, Worn equipment: {len(worn)}")
for e in worn:
    print(json.dumps(e, indent=2))

set_list = data.get("equipmentCtrl", {}).get("setData", {}).get("setList", {})
print("\nSet list 1:", set_list.get("1"))
epids_set1 = list(set_list.get("1", {}).get("list", {}).values())
print("Set 1 epids:", epids_set1)
set1_items = [e for e in eq_arr if e.get("epid") in epids_set1]
print("\nSet 1 items in array:")
for e in set1_items:
    print(json.dumps(e, indent=2))
