with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\buff.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()

# Search for any line where 96 is assigned to effectType or effect
import re

print("Searching buff.lua for effectType == 96 or 96 in effect...")
for idx, line in enumerate(lines):
    if "96" in line and ("effectType" in line or "effect" in line):
        # print context
        for j in range(max(0, idx-4), min(len(lines), idx+6)):
            print(f"{j+1}: {lines[j]}")
        print("-" * 30)
