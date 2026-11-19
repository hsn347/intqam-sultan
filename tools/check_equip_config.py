# -*- coding: utf-8 -*-
p = 'game_file/src/app/localtb/config_server/equipment_config.lua'
with open(p, 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    for eid in [6105001, 6204501, 6304501, 6404501, 6504501, 6604501]:
        if f'equipmentID = {eid}' in l:
            for j in range(max(0, i-2), min(len(lines), i+25)):
                print(lines[j].strip())
            print("="*40)
