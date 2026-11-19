import re

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

entries = re.findall(r'blv\s*=\s*(?:nil,\s*)?(\d+).*?capacity\s*=\s*(?:nil,\s*)*(\d+)', content, re.DOTALL)
for lv, cap in entries:
    print(f"Level {lv}: capacity = {cap}")
