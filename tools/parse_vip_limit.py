# -*- coding: utf-8 -*-
with open("game_file/src/app/localtb/config_server/vipbuff.lua", "r", encoding="utf-8") as f:
    text = f.read()

import re
# find blocks where level is defined or blocks separated by level
# in vipbuff.lua, levels are indexed
# let's find all level = X and the limit associated with it
levels = text.split(".level =")
print(f"Levels found: {len(levels)}")

for idx, block in enumerate(levels[1:], 1):
    # search for limit
    m = re.search(r"\.limit.*?\[1\]\s*=\s*[^,]+,\s*[^,]+,\s*(\d+).*?\[2\]\s*=\s*[^,]+,\s*[^,]+,\s*(\d+).*?\[3\]\s*=\s*[^,]+,\s*[^,]+,\s*(\d+)", block, re.DOTALL)
    if m:
        p_id, p_type, val = m.groups()
        print(f"VIP Lv {idx}: ID={p_id}, type={p_type}, val={val}")
    else:
        # try another regex
        m2 = re.search(r"\.limit.*?\[3\]\s*=\s*[^,]+,\s*[^,]+,\s*(\d+)", block, re.DOTALL)
        if m2:
            print(f"VIP Lv {idx}: val={m2.group(1)}")
        else:
            print(f"VIP Lv {idx}: no limit found")
