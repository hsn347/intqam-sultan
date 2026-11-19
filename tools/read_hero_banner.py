with open(r"e:\intqam-sultan\game_file\src\app\game\heroView\heroSelect\heroSelectBanner.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "dispatch" in l or "exportHeros" in l or "autoFillHeros" in l:
        print(f"{i+1}: {l.strip()[:100]}")
