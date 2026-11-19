import os
import re

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

chunks = re.split(r';\(nil\)\.id\s*=\s*', text)
print(f'Total skill chunks: {len(chunks)}')

hero_march_skills = []
for c in chunks[1:]:
    btype_m = re.search(r'buffType\s*=\s*(\d+)', c)
    if btype_m and int(btype_m.group(1)) in (96, 19):
        hid_m = re.search(r'heroID\s*=\s*(\d+)', c)
        sid_m = re.search(r'skillID\s*=\s*(\d+)', c)
        q_m = re.search(r'quality\s*=\s*(\d+)', c)
        act_m = re.search(r'activeType\s*=\s*(\d+)', c)
        val_m = re.search(r'buffValue\s*=\s*(\d+)', c)
        hero_march_skills.append({
            'heroID': int(hid_m.group(1)) if hid_m else None,
            'skillID': int(sid_m.group(1)) if sid_m else None,
            'quality': int(q_m.group(1)) if q_m else None,
            'activeType': int(act_m.group(1)) if act_m else None,
            'buffType': int(btype_m.group(1)),
            'buffValue': int(val_m.group(1)) if val_m else 0,
        })

print(f'Total march skills in hero_skill_conf: {len(hero_march_skills)}')
by_hero = {}
for s in hero_march_skills:
    hid = s['heroID']
    by_hero.setdefault(hid, []).append(s)

print(f'Heroes with march skills: {list(by_hero.keys())}')
for hid in sorted(by_hero.keys()):
    skills = by_hero[hid]
    print(f'Hero {hid}: {len(skills)} march skills')
    for sk in skills[:3]:
        print(f"   skillID={sk['skillID']} q={sk['quality']} actType={sk['activeType']} buffType={sk['buffType']} val={sk['buffValue']}")
