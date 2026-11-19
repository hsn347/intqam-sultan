with open(r"e:\intqam-sultan\game_file\src\app\module\city\buildLogic.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "function buildLogic.getBuildBaseValue" in l:
        for j in range(i, min(len(lines), i+60)):
            print(f"{j+1}: {lines[j]}", end="")
        break
