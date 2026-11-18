import re
import json

def parse_lang(file_path):
    names = {}
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    for m in re.finditer(r'\["(Dear_pet_name_\d+)"\]\s*=\s*"([^"]+)"', content):
        names[m.group(1)] = m.group(2)
    return names

arab = parse_lang('game_file/src/app/localtb/config_client/local_arab.lua')
en = parse_lang('game_file/src/app/localtb/config_client/local_en.lua')

# Also check turkish if available or other files
for i in range(1, 19):
    key = f"Dear_pet_name_{i:02d}"
    print(f"Key: {key:<18} | AR: {arab.get(key, 'N/A'):<22} | EN: {en.get(key, 'N/A')}")
