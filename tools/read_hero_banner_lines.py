with open(r"e:\intqam-sultan\game_file\src\app\game\heroView\heroSelect\heroSelectBanner.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(25, 80):
    if i < len(lines):
        print(f"{i+1}: {lines[i]}", end="")
