with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

for idx, line in enumerate(lines):
    if "technologyID = 2503001" in line:
        start = max(0, idx - 5)
        end = min(len(lines), idx + 35)
        for i in range(start, end):
            print(f"{i+1}: {lines[i]}", end="")
        break
