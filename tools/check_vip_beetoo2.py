import json
import os

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

for k, v in data.items():
    if "vip" in k.lower():
        print(f"Key {k}:", v)
