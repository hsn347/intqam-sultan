import re

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

chunks = text.split(';(nil).heroID = ')
for c in chunks[1:]:
    hid_m = re.match(r'(\d+)', c)
    rar_m = re.search(r'rarity\s*=\s*.*?(\d+)', c)
    name_m = re.search(r'name\s*=\s*"([^"]+)"', c)
    htype_m = re.search(r'heroType.*?(\d+)', c)
    if hid_m and rar_m:
        hid = int(hid_m.group(1))
        print(f"Hero {hid}: rarity={rar_m.group(1)}, heroType={htype_m.group(1) if htype_m else None}, name={name_m.group(1) if name_m else None}")
