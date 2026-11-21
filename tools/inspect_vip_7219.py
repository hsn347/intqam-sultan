# -*- coding: utf-8 -*-
with open("game_file/src/app/localtb/config_server/vip.lua", "r", encoding="utf-8") as f:
    vip_text = f.read()

# Let's inspect each VIP level block in vip.lua
import re
levels = vip_text.split("level =")
print(f"Total level blocks: {len(levels)}")

# We can parse buffList
# In vip.lua:
# buffList has triples: [buffType, effectType, value]
# e.g., 7219 is buffType!
for idx, block in enumerate(levels[1:], 1):
    # find all occurrences of 7219
    m = re.findall(r"7219.*?(\d+)\s*,\s*(\d+)", block)
    if "7219" in block:
        # let's find the numbers around 7219
        sub = block[block.find("7219"):block.find("7219")+80]
        print(f"VIP Level {idx}: {sub.strip()}")
