with open(r"E:\intqam-sultan\game_file\src\app\module\kingdomLevel\kingdomLevelCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines[:100], 1):
    print(f"{idx}: {line}")
