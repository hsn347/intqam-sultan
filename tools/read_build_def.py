with open(r"e:\intqam-sultan\game_file\src\app\constdef\buildDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for l in lines:
    if "301" in l or "121" in l or "101" in l or "119" in l:
        print(l.strip())
