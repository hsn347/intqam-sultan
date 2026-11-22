import json
import os

with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    b_data = json.load(f)

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    l_data = json.load(f)

all_keys = set(b_data.keys()).union(set(l_data.keys()))

print("Controllers present in both:")
for k in sorted(all_keys):
    in_b = k in b_data
    in_l = k in l_data
    if in_b != in_l:
        print(f"  Controller {k}: in beetoo={in_b}, in lucifer={in_l}")
