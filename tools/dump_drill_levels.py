path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re

# find (nil).blv = ... and (nil).capacity = ...
blvs = re.findall(r"blv\s*=\s*(?:nil,\s*)?(\d+)", text)
caps = re.findall(r"capacity\s*=\s*(?:nil,\s*)?(\d+)", text)

print(f"Found blvs: {len(blvs)}, caps: {len(caps)}")
for b, c in zip(blvs[:35], caps[:35]):
    print(f"Level {b}: {c} troops")
