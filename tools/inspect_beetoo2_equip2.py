# -*- coding: utf-8 -*-
import json

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d = json.load(f)

eq = d.get("equipmentCtrl", {})
print("setData:", eq.get("setData"))
print("\nequipment_array:")
for item in eq.get("equipment_array", []):
    print(" ", item)
