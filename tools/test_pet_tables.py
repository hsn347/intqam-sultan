import os
import re

for fn in ['pet_level_conf.lua', 'pet_rank_conf.lua']:
    full = os.path.join(r'e:\intqam-sultan\game_file\src\app\localtb\config_server', fn)
    with open(full, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    # numbers starting with 18 that are 10 digits
    matches = re.findall(r'\b(18\d{8})\b', text)
    print(f'{fn}: found {len(matches)} matches for attrType 18')
    unique_m = sorted(set(matches))
    for m in unique_m[:10]:
        val_type = m[2:4]
        val = int(m[4:])
        print(f'  power: {m} => attrType=18, valType={val_type}, val={val}')
