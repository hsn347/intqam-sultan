import re

with open("game_file/src/app/game/worldMap/worldMapResource.lua", "r", encoding="utf-8") as f:
    text = f.read()

for line in text.splitlines():
    if "dispatch" in line.lower() or "buttonType" in line or "maxcount" in line.lower():
        print(line[:120])
