with open(r"e:\intqam-sultan\game_file\src\app\module\equipment\equipmentCell.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(180, 270):
    if i < len(lines):
        print(f"{i+1}: {lines[i]}", end="")
