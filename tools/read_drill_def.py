path = r"E:\intqam-sultan\game_file\src\app\constdef\buildDef.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for line in text.splitlines():
    if "drill_grouds" in line.lower() or "drill_grounds" in line.lower() or "121" in line:
        print(line)
