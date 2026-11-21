import re

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8') as f:
    text = f.read()

for hid in [1717, 1711, 1710, 1704, 1718, 1712, 1700, 1707]:
    idx = text.find(str(hid))
    if idx != -1:
        print(f"--- Hero {hid} ---")
        print(text[max(0, idx-20):min(len(text), idx+250)])
