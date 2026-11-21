# -*- coding: utf-8 -*-
with open("game_file/src/app/localtb/config_server/vipbuff.lua", "r", encoding="utf-8") as f:
    text = f.read()

# in vipbuff.lua, look at limit
import re
# e.g.: (nil).limit, (nil)[1] = nil, nil, 7219
# let's see how vipbuff.lua defines limit
for line in text.splitlines():
    if "7219" in line or "limit" in line:
        if "7219" in line:
            print(line)
