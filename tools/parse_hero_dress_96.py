# -*- coding: utf-8 -*-
import re
import json

with open("game_file/src/app/localtb/config_server/hero_dress_server.lua", "r", encoding="utf-8") as f:
    text = f.read()

# Let's inspect hero_dress_server.lua structure
# Entries have:
# [dressID] = { heroID = ..., getBuff = { 96, 2000, ... }, ... }
# Or Lua assignment format

# Let's parse all blocks
# e.g.: (nil)[171602] ... getBuff ...
# Let's write a parser for all dress IDs and their getBuff containing 96

dresses_with_96 = {}

lines = text.splitlines()
curr_dress_id = None
curr_hero_id = None

# In the compiled Lua script:
# e.g.:
# ;(nil).activationItem, _ENV, (nil).dressBuff, _ENV, (nil).getBuff, _ENV, (nil).heroID = nil, nil, nil, nil, nil, nil, 1716
# _UPVALUE6_, (nil).getBuff, (nil)[1] = nil, nil, 96
# _UPVALUE6_, (nil).getBuff, (nil)[2] = nil, nil, 2000
# ...
# ;(nil)[171602], (nil).defaultDress = ...

# Let's search for (nil)[<dress_id>] and match with getBuff
# Or let's use a regex to scan all dress IDs and their getBuff
dress_blocks = re.findall(r";\(nil\)\[(\d{6})\].*?(?=;\(nil\)\[\d{6}\]|\Z)", text, re.DOTALL)
print(f"Total dress ID references found: {len(dress_blocks)}")

# Let's also look at hero_dress.lua in config_client if it has cleaner tables
