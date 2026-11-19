# -*- coding: utf-8 -*-
import re

for filename in ['hero_awakeskill_config.lua', 'hero_stuntskill_config.lua', 'hero_masteryskill_config.lua']:
    path = f'game_file/src/app/localtb/config_server/{filename}'
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    print(f"=== {filename} ===")
    entries = re.split(r';\(nil\)\.id\s*=\s*\d+', text)
    march_items = []
    for chunk in entries[1:]:
        if '96' in chunk or '19' in chunk:
            m_buff = re.search(r'buffType\s*=\s*(\d+)', chunk) or re.search(r'buffType\s*=\s*\{([^}]+)\}', chunk)
            if m_buff:
                val = m_buff.group(1)
                if '96' in val or '19' in val:
                    march_items.append(chunk[:300].replace('\n', ' '))
    print(f"Found {len(march_items)} march entries in {filename}")
    for item in march_items[:5]:
        print(" ", item)
