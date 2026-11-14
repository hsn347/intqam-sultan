import re

with open('game_file/src/app/constdef/cmdDef.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

matches = re.findall(r';\(nil\)\.(NOTIFY_\w+)\s*=\s*"(\d+)"', text)
print(f"Total NOTIFY_ constants: {len(matches)}")
for name, val in matches:
    print(f'{val:>4} : {name}')
