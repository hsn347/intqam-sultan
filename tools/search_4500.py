# -*- coding: utf-8 -*-
import json
import re

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

# Search recursively for 4500
found = []
def search(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            search(v, f"{path}.{k}" if path else k)
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            search(item, f"{path}[{i}]")
    else:
        if obj == 4500 or obj == "4500":
            found.append((path, obj))

search(data)
print("Found 4500 in init_data:")
for p, v in found:
    print(f"  {p} = {v}")
