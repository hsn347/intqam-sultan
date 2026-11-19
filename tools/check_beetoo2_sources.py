import json
import os
import re

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("=== beetoo2 Controllers ===")
for k in sorted(data.keys()):
    if any(term in k.lower() for term in ["equip", "dress", "godarm", "weapon", "talent", "lord", "buff", "skill", "rune"]):
        print(f"  {k}: {type(data[k])}")

# Let's inspect data['equipmentCtrl'] or similar
for k in data.keys():
    if "equip" in k.lower():
        print(f"\n--- {k} ---")
        print(json.dumps(data[k], indent=2)[:500])

for k in data.keys():
    if "dress" in k.lower():
        print(f"\n--- {k} ---")
        print(json.dumps(data[k], indent=2)[:500])

for k in data.keys():
    if "talent" in k.lower() or "lordskill" in k.lower():
        print(f"\n--- {k} ---")
        print(json.dumps(data[k], indent=2)[:500])

for k in data.keys():
    if "god" in k.lower() or "weapon" in k.lower() or "arm" in k.lower():
        print(f"\n--- {k} ---")
        print(json.dumps(data[k], indent=2)[:500])
