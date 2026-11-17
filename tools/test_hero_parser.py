import re
import json

with open('game_file/src/app/localtb/config_client/hero_skill_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

entries = re.split(r'skillID\s*=\s*', text)[1:]
print(f"Total hero entries by split: {len(entries)}")
parsed_hero = []
for e in entries:
    m_id = re.match(r'(\d+)', e)
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', e)
    m_des = re.search(r'\.des\s*=\s*"([^"]*)"', e)
    m_icon = re.search(r'herIcon\s*=\s*(?:[^;\n]*,)?\s*"([^"]+\.png)"', e)
    if m_id and m_name and m_icon:
        parsed_hero.append({
            'skillID': int(m_id.group(1)),
            'herName': m_name.group(1),
            'des': m_des.group(1) if m_des else '',
            'herIcon': m_icon.group(1)
        })

print(f"Successfully parsed hero skills: {len(parsed_hero)}")
unique_icons = {p['herIcon'] for p in parsed_hero}
print(f"Unique hero icons: {len(unique_icons)}")
print("Sample:", parsed_hero[:3])
