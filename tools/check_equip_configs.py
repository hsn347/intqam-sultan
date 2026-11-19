# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/equipment.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]

for eid in eids:
    idx = text.find(str(eid))
    if idx != -1:
        chunk = text[idx:idx+500]
        end = chunk.find(';(nil).index')
        if end != -1:
            chunk = chunk[:end]
        print(f"=== EID {eid} ===")
        print(chunk)
