with open(r"e:\intqam-sultan\game_file\src\app\constdef\petDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(0, min(len(lines), 72)):
    print(f"{i+1}: {lines[i]}", end="")
