import re
import json

with open('game_file/src/app/localtb/config_client/hero_view_info.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Let's inspect lines around each heroID
lines = text.split('\n')
current_hid = None
heroes = {}

for line in lines:
    m_id = re.search(r'heroID\s*=\s*(\d+)', line)
    if m_id:
        current_hid = int(m_id.group(1))
        heroes[current_hid] = {'id': current_hid, 'lines': []}
    if current_hid:
        heroes[current_hid]['lines'].append(line)

print(f"Total heroes found: {len(heroes)}")

# For each hero, look for heroType
for hid, hdata in sorted(heroes.items()):
    block = '\n'.join(hdata['lines'])
    # Search for heroType assignment
    # e.g.: heroType, ... = ...
    # or ;(nil).heroType, (nil)[1] = nil, 3
    # or ;("heroModle_171901").heroType, (1720)[1] = 1720, 5
    m_ht = re.search(r'heroType[^\n]*?=\s*.*?(?:,\s*(\d+)|=\s*(\d+))', block)
    # also search for herName, name, rarity
    m_name = re.search(r'herName\s*=\s*"([^"]+)"', block)
    m_cname = re.search(r'\bname\s*=\s*"([^"]+)"', block)
    m_rar = re.search(r'rarity\s*=\s*(\d+)', block)
    
    # Let's find the exact line with heroType
    ht_val = None
    for l in hdata['lines']:
        if 'heroType' in l:
            # check the last number in this line
            nums = re.findall(r'\b(\d+)\b', l)
            if nums:
                ht_val = int(nums[-1])
            break
    
    hdata['type'] = ht_val
    hdata['name'] = m_cname.group(1) if m_cname else ''
    hdata['herName'] = m_name.group(1) if m_name else ''
    hdata['rarity'] = int(m_rar.group(1)) if m_rar else 1

for hid, hdata in sorted(heroes.items()):
    print(f"Hero {hid}: type={hdata['type']}, rarity={hdata['rarity']}, name={hdata['name']}, herName={hdata['herName']}")
