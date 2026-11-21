import re

with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    for line in f:
        if "25030" in line:
            print(line.strip())
