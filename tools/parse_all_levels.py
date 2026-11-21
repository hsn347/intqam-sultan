# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Pattern matching each block:
# rarity = (\d+) ... level = (\d+) ... march_add = (\d+)
pattern = re.compile(r'rarity\s*=\s*(\d+).*?level\s*=\s*(\d+).*?march_add\s*=\s*(\d+)', re.DOTALL)

table = {}
for m in pattern.finditer(text):
    r = int(m.group(1))
    l = int(m.group(2))
    ma = int(m.group(3))
    table[(r, l)] = ma

print(f"Loaded {len(table)} (rarity, level) combinations.")
for r in range(1, 6):
    print(f"Rarity {r} Lv 60: {table.get((r, 60))}")
    print(f"Rarity {r} Lv 48: {table.get((r, 48))}")
    print(f"Rarity {r} Lv 41: {table.get((r, 41))}")
    print(f"Rarity {r} Lv 28: {table.get((r, 28))}")
