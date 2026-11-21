import json
import re

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d = json.load(f)
skillBasic = d.get('lordInfoCtrl', {}).get('skill', {}).get('skillBasic', {})

skills_by_full_id = {}
current_id = None

with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    for line in f:
        m_id = re.search(r'\.skillID\s*=\s*(\d+)', line)
        if m_id:
            current_id = int(m_id.group(1))
            continue
        if current_id is not None:
            m_prop = re.search(r'\.skillProperty\s*=\s*"([^"]+)"', line)
            if m_prop:
                skills_by_full_id[current_id] = m_prop.group(1)
                current_id = None

print(f"Total skills parsed: {len(skills_by_full_id)}")

total_capacity_from_skills = 0
for s_id, s_val in skillBasic.items():
    s_id_int = int(s_id)
    lv = s_val[1]
    full_id = s_id_int * 100 + lv
    prop = skills_by_full_id.get(full_id, "")
    print(f"Skill {s_id} (lv {lv}) [ID={full_id}]: prop={prop}")
    if prop and len(prop) >= 10:
        for i in range(0, len(prop), 10):
            chunk = prop[i:i+10]
            if len(chunk) == 10:
                p_type = int(chunk[:2])
                p_sub = int(chunk[2:4])
                p_val = int(chunk[4:])
                if p_type == 43:
                    print(f"   >>> FOUND MARCH LIMIT (Type 43): sub={p_sub}, val={p_val}")
                    total_capacity_from_skills += p_val

print(f"\nTOTAL MARCH CAPACITY FROM LORD SKILLS: {total_capacity_from_skills}")



