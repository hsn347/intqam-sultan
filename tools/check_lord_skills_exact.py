import json
import re

with open(r'game_file\src\app\localtb\config_server\skill.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

skills = d.get('lordSkillCtrl', {}).get('setListData', {}).get('1', {}).get('list', {})

found_march = []
for sid, slv in skills.items():
    prefix = str(sid)
    target_id = f"{prefix}{int(slv):02d}"
    idx = text.find(f"skillID = {target_id}")
    if idx != -1:
        chunk = text[idx:idx+300]
        m = re.search(r'skillProperty\s*=\s*"([^"]+)"', chunk)
        prop = m.group(1) if m else "None"
        btype = prop[:2]
        if btype in ['96', '19', '18']:
            found_march.append((sid, slv, prop))
        print(f"Skill {target_id}: prop={prop}")

print(f"\nFound march skills in Lord skills: {found_march}")
