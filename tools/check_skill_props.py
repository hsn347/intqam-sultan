# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

pattern = r'skillID\s*=\s*(\d+).*?skillProperty\s*=\s*"(\d+)"'
matches = re.findall(pattern, text, re.DOTALL)
print(f'Total skills found: {len(matches)}')
buff_types = set()
for sid, prop in matches:
    btype = prop[:2]
    buff_types.add(btype)
    if btype in ['19', '96', '43', '14', '05', '78']:
        print(f'Skill {sid}: buffType = {btype}, prop = {prop}')
print('All buff types in skill.lua:', sorted(list(buff_types)))
