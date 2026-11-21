import json

with open("game_file/src/app/localtb/config_server/arms.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re

# find soldier weight
# in arms: (nil).weight = ...
arms = ["601", "701", "502", "804", "801", "404"]
for aid in arms:
    m = re.search(rf"\(nil\)\.id\s*=\s*{aid}.*?\(nil\)\.weight\s*=\s*([0-9.]+)", text, re.DOTALL)
    if m:
        print(f"Soldier {aid}: weight = {m.group(1)}")
    else:
        # try another pattern
        m2 = re.search(rf"id\s*=\s*{aid}[^}}]+weight\s*=\s*([0-9.]+)", text, re.DOTALL)
        if m2:
            print(f"Soldier {aid}: weight = {m2.group(1)}")
