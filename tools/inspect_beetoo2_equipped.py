# -*- coding: utf-8 -*-
import re, json

eids = [6105001, 6204501, 6304501, 6404501, 6504501, 6604501]

with open('game_file/src/app/localtb/config_server/equipment_base_property_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

for eid in eids:
    pattern = rf'\[{eid}\]\s*=\s*\{{([^}}]+)\}}'
    m = re.search(pattern, text)
    if m:
        print(f"EID {eid}: {m.group(1)[:200]}")
    else:
        print(f"EID {eid}: not found")
