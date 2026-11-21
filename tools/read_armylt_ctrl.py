path = r"E:\intqam-sultan\game_file\src\app\localtb\config_read\armyltCtrl.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines in armyltCtrl.lua: {len(lines)}")
for i, line in enumerate(lines):
    if "function" in line:
        print(f"{i+1}: {line.strip()[:100]}")
