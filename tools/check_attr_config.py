import re

with open('game_file/src/app/localtb/config_server/attribute_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

chunks = re.split(r';\(nil\)\.id\s*=\s*', text)
for c in chunks[1:]:
    atype_m = re.search(r'attrType\s*=\s*5\b', c)
    if atype_m:
        id_m = re.search(r'\(nil\)\.id\s*=\s*(\d+)', c)
        des_m = re.search(r'des\s*=\s*"([^"]+)"', c)
        print(f"attrType=5: id={id_m.group(1) if id_m else None}, des={des_m.group(1) if des_m else None}")
