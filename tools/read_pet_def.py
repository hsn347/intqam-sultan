with open(r"e:\intqam-sultan\game_file\src\app\constdef\petDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "gPetAttributeType" in l:
        for j in range(i, min(len(lines), i+50)):
            print(f"{j+1}: {lines[j]}", end="")
        break
