# -*- coding: utf-8 -*-
import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    b1 = json.load(f)

# Let's inspect everything in lordInfoCtrl, fcInfo, etc.
print("=== BEETOO1 ALL DATA KEYS ===")
for k in sorted(b1.keys()):
    v = b1[k]
    if isinstance(v, dict):
        print(f"[{k}] (dict, {len(v)} keys): {list(v.keys())[:10]}")
    elif isinstance(v, list):
        print(f"[{k}] (list, {len(v)} items)")
    else:
        print(f"[{k}]: {v}")
