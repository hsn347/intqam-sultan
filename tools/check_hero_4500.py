# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if 'march_add = 4500' in l:
        for j in range(max(0, i-5), min(len(lines), i+15)):
            print(lines[j].strip())
        print("="*40)
