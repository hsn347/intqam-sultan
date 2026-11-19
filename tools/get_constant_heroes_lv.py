# -*- coding: utf-8 -*-
with open(r"game_file\src\app\localtb\config_server\constant.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re
matches = re.findall(r"HIRED_HEROES_\d_LV[^\n]*", text)
for m in matches:
    print(m)

# Also let's search for HIRED_HEROES anywhere in the file with context
for m in re.finditer(r"HIRED_HEROES", text):
    start = max(0, m.start() - 50)
    end = min(len(text), m.end() + 150)
    print("--- Context ---")
    print(text[start:end])
