# -*- coding: utf-8 -*-
import re

skill_ids = [
    17120105, 17120205, 17120305, 17120405,
    17110104, 17110204, 17110304, 17110404,
    17070103, 17070203, 17070303, 17070403,
    17170105, 17170205, 17170305, 17170405,
    17080103, 17080203, 17080303, 17080403,
    17000105, 17000205, 17000305, 17000405,
]

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    c = f.read()

for sid in skill_ids:
    idx = c.find(f'[{sid}]')
    if idx == -1:
        idx = c.find(f'["{sid}"]')
    if idx != -1:
        block = c[idx:idx+300]
        # find matching closing brace
        end_brace = block.find('}')
        if end_brace != -1:
            block = block[:end_brace+1]
        print(f"Skill {sid}: {block}")
    else:
        print(f"Skill {sid}: Not found directly")
