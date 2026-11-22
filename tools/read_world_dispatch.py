with open(r"E:\intqam-sultan\game_file\src\app\game\worldMap\worldAssistView\worldDispatchArmyView\worldDispatchArmyView.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")
for i, line in enumerate(lines):
    if any(k in line.lower() for k in ["max", "capacity", "limit", "drill", "121", "totalsoldier", "maxarmy", "maxsoldier", "maxtroop"]):
        print(f"{i+1}: {line.strip()[:140]}")
