with open(r"e:\intqam-sultan\game_file\src\app\game\heroView\heroSelect\heroSelectBanner.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "autoFillHeros" in l:
        for j in range(max(0, i-5), min(len(lines), i+60)):
            print(f"{j+1}: {lines[j]}", end="")
        break
