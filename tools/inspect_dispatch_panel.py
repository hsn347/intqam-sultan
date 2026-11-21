path = r"E:\intqam-sultan\game_file\src\fgui\views\troopFlagView\WorldDispatchArmyViewPanel.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
for i, line in enumerate(lines):
    if any(k in line.lower() for k in ["max", "capacity", "limit", "drill", "total", "march", "soldier"]):
        print(f"{i+1}: {line.strip()[:140]}")
