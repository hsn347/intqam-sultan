# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if 'powerNum = 4500' in l:
        for j in range(max(0, i-6), min(len(lines), i+15)):
            print(lines[j].strip())
        print("="*40)
