import re

with open(r'e:\intqam-sultan\game_file\src\app\localtb\config_server\skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

m = re.findall(r'skillID\s*=\s*13002\d+.*?(?=skillID|\Z)', text, re.DOTALL)
for x in m:
    print(x[:400])
