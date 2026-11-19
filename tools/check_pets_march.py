# -*- coding: utf-8 -*-
import re

pets = [
    (1254, 48, 2), # pid, level, rank
    (1251, 30, 2),
    (1259, 1, 1),
    (1255, 2, 1),
]

# In pet_level_conf.lua:
with open('game_file/src/app/localtb/config_server/pet_level_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text_level = f.read()

# In pet_rank_conf.lua:
with open('game_file/src/app/localtb/config_server/pet_rank_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text_rank = f.read()

print("Checking pets for Beetoo2:")
total_pet_march_add = 0

for pid, plvl, prank in pets:
    # find entry in pet_level_conf:
    # petid = pid, level = plvl
    m_lvl = re.search(rf'petid\s*=\s*{pid}.*?level\s*=\s*{plvl}(.*?)(?=petid|\Z)', text_level, re.DOTALL)
    if m_lvl:
        body = m_lvl.group(1)
        # find talent_skill
        m_skills = re.findall(r'talent_skill.*?\"(\d+)\"', body)
        for s in m_skills:
            atype = int(s[:2])
            valtype = int(s[2:4])
            val = int(s[4:])
            if atype == 18:
                print(f"Pet {pid} Lv.{plvl} has talent attrType 18: val={val}")
                total_pet_march_add += val
            else:
                pass
                # print(f"Pet {pid} Lv.{plvl}: atype={atype}, val={val}")

    # find entry in pet_rank_conf:
    # petid = pid, rank = prank
    m_rnk = re.search(rf'petid\s*=\s*{pid}.*?rank\s*=\s*{prank}(.*?)(?=petid|\Z)', text_rank, re.DOTALL)
    if m_rnk:
        body = m_rnk.group(1)
        m_skills = re.findall(r'special_skill_add.*?\"(\d+)\"', body)
        for s in m_skills:
            atype = int(s[:2])
            valtype = int(s[2:4])
            val = int(s[4:])
            if atype == 18:
                print(f"Pet {pid} Rank {prank} has special_skill_add attrType 18: val={val}")
                total_pet_march_add += val

print(f"Total Pet March Add: {total_pet_march_add}")
