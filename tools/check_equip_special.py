import json
import re

with open('game_file/src/app/localtb/config_server/equipment_base_property_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

eids = [6504001, 6204501, 6404001, 6104501, 6604001, 6304001]
for eid in eids:
    m = re.search(r'eid\s*=\s*' + str(eid) + r'\b.*?specialType\s*=\s*\{([^}]+)\}', text, re.DOTALL)
    if m:
        print(f"EID {eid} specialType: {m.group(1).strip()}")
    else:
        # check if eid exists
        idx = text.find(str(eid))
        if idx != -1:
            print(f"EID {eid} found: {text[idx:idx+200]}")
        else:
            print(f"EID {eid} NOT found")
