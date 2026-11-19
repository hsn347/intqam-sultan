# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/hero_skill_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

entries = re.split(r';\(nil\)\.id\s*=\s*\d+', text)
print(f"Total chunks: {len(entries)}")

hero_skills = {}
march_skills = []

for chunk in entries[1:]:
    m_hero = re.search(r'heroID\s*=\s*(\d+)', chunk)
    m_skill = re.search(r'skillID\s*=\s*(\d+)', chunk)
    m_buff = re.search(r'buffType\s*=\s*(\d+)', chunk)
    m_val = re.search(r'buffValue\s*=\s*nil,\s*nil,\s*(\d+)', chunk) or re.search(r'buffValue\s*=\s*(\d+)', chunk)
    m_act = re.search(r'activeType\s*=\s*(\d+)', chunk)

    if m_hero and m_skill and m_buff and m_val:
        hid = int(m_hero.group(1))
        sid = int(m_skill.group(1))
        btype = int(m_buff.group(1))
        bval = int(m_val.group(1))
        act = int(m_act.group(1)) if m_act else 0
        if btype in (19, 96):
            march_skills.append({
                'heroID': hid,
                'skillID': sid,
                'buffType': btype,
                'activeType': act,
                'val': bval
            })

print(f"Total march skills found: {len(march_skills)}")
for ms in march_skills:
    print(ms)
