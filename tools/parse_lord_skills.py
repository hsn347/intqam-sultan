import re

with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

b1_skills = {'13021', '13011', '13005', '13029', '11004', '13003', '11001', '13033', '13001', '13015', '13032', '13017', '13019', '13009', '13002', '13020', '13010', '11002', '11011', '13007', '13025', '13022', '13013', '13031', '13027', '13023'}

# Find all skillID and skillProperty
for line in text.split('\n'):
    m_id = re.search(r'skillID\s*=\s*(\d+)', line)
    if m_id:
        cur_id = m_id.group(1)
        base_skill = cur_id[:-2]
        if base_skill in b1_skills:
            # check next lines for skillProperty
            pass

# Let's search by regex
matches = re.findall(r'skillID\s*=\s*(\d+)[^;]*;[^;]*;[^;]*;[^;]*;[^;]*;\(nil\)\.skillProperty\s*=\s*"([^"]+)"', text)
print(f"Parsed {len(matches)} skill properties")
for sid, prop in matches:
    base_sid = sid[:-2]
    if base_sid in b1_skills:
        # Check property
        print(f"Skill {sid} (base {base_sid}): property={prop}")
