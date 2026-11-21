path = r"E:\intqam-sultan\game_file\src\app\module\city\buildLogic.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

print(f"Total lines in buildLogic.lua: {len(lines)}")
for i, line in enumerate(lines):
    if "getexparmycount" in line.lower():
        print(f"Found on line {i+1}: {line}")
        # print the next 100 lines
        for j in range(i, min(i+120, len(lines))):
            print(f"{j+1}: {lines[j]}", end="")
        break
