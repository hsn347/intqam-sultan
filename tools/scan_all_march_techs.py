"""
Scan technology.lua for all buffType 43, 73, 77, 95
"""
import re, json

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Pattern matching each technology definition block
# Each block has an ID like 2401601, and then properties
# Notice: (2401601).buffType = ...
# or ;(something).buffType = ...
blocks = re.split(r'\n(?=[0-9]{7}\b)', text)
print(f"Total blocks: {len(blocks)}")

march_techs = {}

for block in blocks:
    m_id = re.match(r'([0-9]{7})', block)
    if not m_id:
        continue
    tech_full_id = m_id.group(1)
    
    m_buff = re.search(r'\.buffType\s*=\s*([0-9]+)', block)
    m_power = re.search(r'\.powerNum\s*=\s*([0-9]+)', block)
    m_numtype = re.search(r'\.buffNumType\s*=\s*([0-9]+)', block)
    
    if m_buff and m_power:
        btype = int(m_buff.group(1))
        pnum = int(m_power.group(1))
        ntype = int(m_numtype.group(1)) if m_numtype else 1
        
        # We are interested in single troop strength: 43, 73, 77, 95 or march limit 19, 96
        if btype in (43, 73, 77, 95, 19, 96):
            base_id = tech_full_id[:-2]
            level = int(tech_full_id[-2:])
            if base_id not in march_techs:
                march_techs[base_id] = {}
            march_techs[base_id][level] = {
                "full_id": tech_full_id,
                "buffType": btype,
                "powerNum": pnum,
                "buffNumType": ntype
            }

print(f"March Techs found ({len(march_techs)}):")
print(json.dumps(march_techs, indent=2))
