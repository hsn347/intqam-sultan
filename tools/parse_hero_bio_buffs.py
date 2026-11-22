import re
import json

with open(r'e:\intqam-sultan\game_file\src\app\localtb\config_server\hero_biography_skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's find all entries in hero_biography_skill.lua
# Structure:
# ;(nil).ID = ...
# ;(nil).skillID = ...
# ;(nil).GroupID = ...
# ...
# buffType, ... = ...
# buffNum, ... = ...

entries = text.split(';(nil).ID = ')
skills = []
for e in entries[1:]:
    skill_id_m = re.search(r'skillID\s*=\s*(\d+)', e)
    group_id_m = re.search(r'GroupID\s*=\s*(\d+)', e)
    type_m = re.search(r'type\s*=\s*(\d+)', e)
    mission_m = re.search(r'missionNum\s*=\s*nil,\s*(\d+)', e)
    
    # buffType
    btypes = [int(x) for x in re.findall(r'buffType.*?(\d+)', e)]
    # buffNum
    bnums = [int(x) for x in re.findall(r'buffNum.*?(\d+)', e)]
    
    if skill_id_m:
        sid = int(skill_id_m.group(1))
        # check if 96 or 19 in buffTypes
        skills.append({
            'skillID': sid,
            'groupID': int(group_id_m.group(1)) if group_id_m else None,
            'type': int(type_m.group(1)) if type_m else None,
            'raw': e[:300]
        })

print(f"Total biography skills: {len(skills)}")

# Search for 96 or 19 in text
for p in re.finditer(r'buffType[^\n]*?=\s*nil,\s*nil,\s*(96|19)\b', text):
    start = max(0, p.start() - 200)
    end = min(len(text), p.end() + 200)
    print("MATCH BUFF 96 or 19:")
    print(text[start:end])
