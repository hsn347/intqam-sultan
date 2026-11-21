with open("game_file/src/app/module/city/buildLogic.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "function buildLogic.getBuildBaseValue" in line:
        for j in range(i, min(len(lines), i+45)):
            print(f"{j+1}: {lines[j]}", end="")
        break
