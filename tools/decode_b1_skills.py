import re

with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's parse all skillID = X, skillProperty = Y
# In lua bytecode dump:
# skillID = 1300101
# skillProperty = "4101000050"
props = {}
cur_id = None
for line in text.split('\n'):
    m_id = re.search(r'skillID\s*=\s*(\d+)', line)
    if m_id:
        cur_id = m_id.group(1)
    m_prop = re.search(r'skillProperty\s*=\s*"([^"]+)"', line)
    if m_prop and cur_id:
        props[cur_id] = m_prop.group(1)
        cur_id = None

# beetoo1 active skills and levels
b1_skill_levels = {'13021': 1, '13011': 20, '13005': 5, '13029': 20, '11004': 5, '13003': 5, '11001': 5, '13033': 10, '13001': 5, '13015': 20, '13032': 1, '13017': 20, '13019': 20, '13009': 20, '13002': 5, '13020': 1, '13010': 20, '11002': 5, '11011': 1, '13007': 5, '13025': 20, '13022': 1, '13013': 20, '13031': 20, '13027': 20, '13023': 20}

print("Active skills in beetoo1:")
for base_id, lv in b1_skill_levels.items():
    full_id = f"{base_id}{lv:02d}"
    prop = props.get(full_id, "None")
    # property string structure: first 2 digits = property type
    prop_type = prop[:2] if prop != "None" else "None"
    print(f"Skill {base_id} Lv.{lv} ({full_id}) -> property: {prop} (type {prop_type})")
