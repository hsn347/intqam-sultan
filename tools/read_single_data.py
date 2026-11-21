with open("game_file/src/app/localtb/config_read/collegeDesRead.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "singleData" in line:
        for j in range(max(0, i-5), min(len(lines), i+30)):
            print(f"{lines[j]}", end="")
        break
