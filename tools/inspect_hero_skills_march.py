# -*- coding: utf-8 -*-
import sys, re

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Check skills for 1712, 1711, 1717, 1707, 1708
# realSkillID = skillType * 100 + quality
# or check all entries where skillID starts with 1712, 1711, 1717, 1707, 1708
skills = [
    (1712, 5), (1711, 4), (1717, 5), (1707, 3), (1708, 3)
]

print("Checking skills in hero_skill_conf.lua...")
for hid, q in skills:
    print(f"\n=== Hero {hid} (quality {q}) ===")
    for sk_idx in [1, 2, 3, 4]:
        stype = hid * 100 + sk_idx
        # realID could be stype * 100 + q
        real_id = stype * 100 + q
        # Let's search for stype in text
        pattern = rf'skillID\s*=\s*{real_id}\b'
        m = re.search(pattern, text)
        if not m:
            # try pattern without real_id
            pattern2 = rf'skillID\s*=\s*{stype}\d{{2}}\b'
            matches = re.findall(pattern2, text)
            print(f"  Skill {stype} matches: {matches[:3]}")
        else:
            print(f"  Skill {real_id} found!")

# Also let's search for any buffType == 96 in hero_skill_conf.lua!
print("\n=== Searching for buffType = 96 (MARCH_VALUE_LIMIT_BOOST) in hero_skill_conf.lua ===")
b96_matches = re.findall(r'(\{[^}}]*buffType\s*=\s*96[^}}]*\})', text)
print(f"Total buffType 96 skills: {len(b96_matches)}")
for m in b96_matches[:10]:
    print("  ", m[:150])
