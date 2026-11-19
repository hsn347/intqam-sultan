# -*- coding: utf-8 -*-
p = 'game_file/src/app/localtb/config_server/hero_stuntskill_config.lua'
with open(p, 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    for sid in ['17120601', '17120602', '17120603', '17120604']:
        if sid in l:
            for j in range(max(0, i-2), min(len(lines), i+15)):
                print(lines[j].strip())
            print("="*40)
