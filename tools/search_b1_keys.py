# -*- coding: utf-8 -*-
import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    b1 = json.load(f)

# Let's search for any key or value containing march, capacity, soldier, army, etc.
def search_dict(d, path=""):
    if isinstance(d, dict):
        for k, v in d.items():
            new_path = f"{path}.{k}" if path else k
            if any(term in str(k).lower() for term in ["march", "capacity", "soldier", "drill", "troop", "fc"]):
                if not isinstance(v, (dict, list)):
                    print(f"{new_path} = {v}")
            search_dict(v, new_path)
    elif isinstance(d, list):
        for i, v in enumerate(d):
            search_dict(v, f"{path}[{i}]")

print("=== SEARCHING BEETOO1 FOR MARCH/CAPACITY KEYS ===")
search_dict(b1)
