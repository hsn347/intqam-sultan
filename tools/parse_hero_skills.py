# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

current = {}
skills = {}

for line in lines:
    line = line.strip()
    m_field = re.match(r';\(nil\)\.(\w+)\s*=\s*(\d+)', line)
    if m_field:
        k, v = m_field.group(1), int(m_field.group(2))
        current[k] = v
    m_val = re.search(r'buffValue\s*=\s*nil,\s*nil,\s*(\d+)', line)
    if m_val:
        current['buffValue'] = int(m_val.group(1))
    if 'id' in current and 'skillID' in current and 'buffType' in current and 'buffValue' in current:
        skills[current['skillID']] = dict(current)
        current = {}

print(f"Parsed {len(skills)} skills")

# Check skills for our heroes
my_hero_ids = [1712, 1711, 1709, 1707, 1703, 1717, 1708, 1700]
for sid, s in skills.items():
    if s.get('buffType') in (19, 96):
        hid = s.get('heroID')
        print(f"Skill {sid} (Hero {hid}): buffType={s['buffType']}, activeType={s.get('activeType')}, val={s.get('buffValue')}")
