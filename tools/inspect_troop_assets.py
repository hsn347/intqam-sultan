import re

with open('game_file/src/app/localtb/config_client/armydescribe.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

for sid in ['401', '501', '601', '701']:
    pattern = rf'\["{sid}"\]\s*=\s*\{{([^}}]+)\}}'
    m = re.search(pattern, text)
    if m:
        print(f"=== {sid} ===")
        for line in m.group(1).split(','):
            if any(k in line for k in ['armyPic', 'icon', 'head', 'res']):
                print(line.strip())
