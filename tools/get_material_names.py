with open('game_file/src/app/localtb/config_client/local_arab.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

import re
for i in range(10, 16):
    k = f"item_name_{i}"
    m = re.search(r'\[' + f'"{k}"' + r'\]\s*=\s*"([^"]+)"', text)
    if m:
        print(f"{k}: {m.group(1)}")
