import re
import json

with open('game_file/src/app/localtb/config_client/hero_stuntskill_view.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_arab = json.load(f)

entries = re.split(r'id\s*=\s*', text)[1:]
print(f"Total stunt entries by split: {len(entries)}")
parsed_stun = []
for e in entries:
    m_id = re.match(r'(\d+)', e)
    m_skill = re.search(r'skillID\s*=\s*(\d+)', e)
    m_name = re.search(r'\.name\s*=\s*"([^"]+)"', e)
    m_des = re.search(r'\.des\s*=\s*"([^"]+)"', e)
    m_icon = re.search(r'icon\s*=\s*(?:[^;\n]*,)?\s*"([^"]+\.png)"', e)
    if m_skill and m_name and m_des and m_icon:
        name_k = m_name.group(1)
        des_k = m_des.group(1)
        parsed_stun.append({
            'skillID': int(m_skill.group(1)),
            'name_key': name_k,
            'name': local_arab.get(name_k, name_k),
            'des_key': des_k,
            'description': local_arab.get(des_k, des_k),
            'icon': m_icon.group(1)
        })

print(f"Successfully parsed stun skills: {len(parsed_stun)}")
unique_icons = {p['icon'] for p in parsed_stun}
print(f"Unique stun icons: {len(unique_icons)}")
print("Sample:", parsed_stun[:3])
