# -*- coding: utf-8 -*-
import re

with open(r'E:\intqam-sultan\game_file\src\app\localtb\config_client\local_en.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

matches = re.findall(r'([a-zA-Z0-9_]+)\s*=\s*"([^"]*bonus[^"]*)"', text, re.IGNORECASE)
found = []
for k, v in matches:
    low = v.lower()
    if any(w in low for w in ['march', 'troop', 'dispatch', 'capacity', 'size']):
        found.append((k, v))

print(f"Found {len(found)} keys:")
for k, v in found[:25]:
    print(f"  {k}: {v}")
