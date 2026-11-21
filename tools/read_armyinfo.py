with open("game_file/src/app/localtb/config_server/armyinfo.lua", "r", encoding="utf-8") as f:
    text = f.read()

import re

for aid in ["601", "701", "502", "804", "801", "404"]:
    m = re.search(rf"armyID\s*=\s*{aid}[^}}]+freeWeight\s*=\s*([0-9.]+)", text)
    if not m:
        m = re.search(rf"freeWeight\s*=\s*([0-9.]+)[^}}]+armyID\s*=\s*{aid}", text)
    if m:
        print(f"Army {aid}: freeWeight = {m.group(1)}")
    else:
        # let's just find lines with aid
        for line in text.splitlines():
            if f"armyID = {aid}" in line or f".armyID = {aid}" in line:
                print(line)
