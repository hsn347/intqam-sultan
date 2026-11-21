import json
import re

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

lord_skills = d1.get('lordSkillCtrl', {}).get('setListData', {}).get('1', {}).get('list', {})
print("beetoo1 active lord skills:", lord_skills)

with open('game_file/src/app/localtb/config_server/skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern: skillID = (\d+).*?skillProperty = "(\d+)"
matches = re.findall(r'skillID\s*=\s*(\d+).*?skillProperty\s*=\s*"([^"]+)"', text, re.DOTALL)
skill_map = {}
for sid, prop in matches:
    skill_map[int(sid)] = prop

print(f"Total skills matched: {len(skill_map)}")

for skid, slv in sorted(lord_skills.items()):
    full_id = int(skid) * 100 + int(slv)
    prop = skill_map.get(full_id, "NOT FOUND")
    # Parse property:
    # First 2 digits = buffType or property ID
    btype = prop[:2] if len(prop) >= 2 else ""
    val = prop[4:] if len(prop) > 4 else ""
    print(f"Skill {skid} Lv {slv} (ID {full_id}) -> Property: {prop} (Type={btype}, Val={val})")
