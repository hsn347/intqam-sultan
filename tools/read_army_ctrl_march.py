path = r"E:\intqam-sultan\game_file\src\app\module\army\armyCtrl.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines in armyCtrl.lua: {len(lines)}")
for i, line in enumerate(lines):
    if any(k in line.lower() for k in ["capacity", "maxmarch", "exparmy", "marchexp", "dispatchcount"]):
        print(f"{i+1}: {line.strip()[:140]}")
