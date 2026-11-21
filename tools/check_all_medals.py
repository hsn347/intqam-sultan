import json
import re

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

ach_list = diag.get("achievementctrl", {}).get("list", {})

with open("game_file/src/app/localtb/config_server/achievement.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for mid, mdata in ach_list.items():
    max_done = mdata.get("maxDoneID", 0)
    has_buff = mdata.get("hasBuff", 0)
    if max_done > 0 and has_buff == 1:
        # find in achievement.lua
        pattern = rf"achievementID\s*=\s*{max_done}.*?property\s*=\s*(\d+).*?powerNum\s*=\s*([0-9.]+)"
        m = re.search(pattern, text, re.DOTALL)
        if m:
            prop = m.group(1)
            pnum = m.group(2)
            print(f"Medal {mid} (done {max_done}): prop={prop}, powerNum={pnum}")
        else:
            # try finding achievementID = max_done
            m2 = re.search(rf"achievementID\s*=\s*{max_done}[^}}]+", text)
            if m2:
                print(f"Medal {mid} (done {max_done}): {m2.group(0)[:120]}")
