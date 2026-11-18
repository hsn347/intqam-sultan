import re

def get_names(filepath):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        c = f.read()
    names = {}
    for i in range(1, 19):
        k = f"Dear_pet_name_{i:02d}"
        m = re.search(r'\b' + k + r'\b.*?=\s*"([^"]+)"', c)
        names[k] = m.group(1) if m else "N/A"
    return names

ar_names = get_names('game_file/src/app/localtb/config_client/local_arab.lua')
en_names = get_names('game_file/src/app/localtb/config_client/local_en.lua')

for i in range(1, 19):
    k = f"Dear_pet_name_{i:02d}"
    pid = 1250 + i
    print(f"ID {pid} ({k}): AR='{ar_names[k]}' | EN='{en_names[k]}'")
