# -*- coding: utf-8 -*-
import json

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d = json.load(f)

eq = d.get("equipmentCtrl", {})
print("equipmentCtrl keys:", list(eq.keys()))
for k, v in eq.items():
    if isinstance(v, dict):
        print(f"  {k}: {list(v.keys())[:10]}")
    elif isinstance(v, list):
        print(f"  {k}: len={len(v)}")
    else:
        print(f"  {k}: {v}")

# print active set
print("active set:", eq.get("activeSet"))
print("equipData:", eq.get("equipData"))
