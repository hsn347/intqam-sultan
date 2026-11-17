import re
import json

with open('game_file/src/app/localtb/config_server/divine_beast_skill_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_arab = json.load(f)

entries = re.split(r'index\s*=\s*', text)[1:]
print(f"Total beast entries by split: {len(entries)}")
parsed_beast = []
for e in entries:
    m_id = re.search(r'skillID\s*=\s*(\d+)', e)
    m_active = re.search(r'isActive\s*=\s*(\d+)', e)
    m_name = re.search(r'skillName\s*=\s*nil,\s*"([^"]+)"', e)
    m_des = re.search(r'skillDes.*?\[1\]\s*=\s*nil,\s*"([^"]+)"', e, re.DOTALL)
    m_icon = re.search(r'skillIcon\s*=\s*nil,\s*nil,\s*"([^"]+\.png)"', e)
    if m_id and m_name and m_icon:
        name_k = m_name.group(1)
        des_k = m_des.group(1) if m_des else ''
        act_val = int(m_active.group(1)) if m_active else 2
        parsed_beast.append({
            'skillID': int(m_id.group(1)),
            'name_key': name_k,
            'name': local_arab.get(name_k, name_k),
            'des_key': des_k,
            'description': local_arab.get(des_k, des_k) if des_k else '',
            'icon': m_icon.group(1),
            'type': 'active' if act_val == 1 else 'passive',
            'type_ar': 'نشطة' if act_val == 1 else 'سلبية'
        })

print(f"Successfully parsed beast skills: {len(parsed_beast)}")
unique_icons = {p['icon'] for p in parsed_beast}
print(f"Unique beast icons: {len(unique_icons)}")
print("Sample:", parsed_beast[:3])
