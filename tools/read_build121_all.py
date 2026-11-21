with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re
matches = re.findall(r'blv\s*=\s*(?:nil,\s*)?(\d+).*?capacity\s*=\s*(?:nil,\s*)*(\d+)', text, re.DOTALL)
for blv, cap in matches:
    if int(blv) in [25, 26, 27, 28, 29, 30]:
        print(f"Drill Grounds Level {blv}: capacity = {cap}")
