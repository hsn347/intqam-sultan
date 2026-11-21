with open(r"E:\intqam-sultan\game_file\src\app\localtb\config_server\build301.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Let's see what keys are defined for level 40 in build301
lines = text.splitlines()
for idx, line in enumerate(lines):
    if "blv = 40" in line:
        for j in range(max(0, idx-10), min(len(lines), idx+30)):
            print(f"{j+1}: {lines[j]}")
        break
