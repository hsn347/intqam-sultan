import os

with open("game_file/src/app/localtb/config_server/build121.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines[:100]):
    print(line, end="")
