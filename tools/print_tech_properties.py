with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

for idx, line in enumerate(lines):
    if "technologyID = 2503001" in line:
        for i in range(idx-10, idx+50):
            print(f"{lines[i]}", end="")
        break
