# -*- coding: utf-8 -*-
import os
import re
import json

beetoo2_heroes = {
    1712: {"level": 60, "quality": 5, "isAwake": True, "skills": [171204, 171201, 171202, 171203], "mastery": 171205, "power": [17120601, 17120603, 17120602, 17120604]},
    1706: {"level": 1, "quality": 3, "isAwake": False, "skills": [170604, 170601, 170603, 170602]},
    1711: {"level": 60, "quality": 4, "isAwake": False, "skills": [171103, 171102, 171101, 171104]},
    1709: {"level": 52, "quality": 5, "isAwake": False, "skills": [170904, 170902, 170903, 170901]},
    1707: {"level": 60, "quality": 3, "isAwake": False, "skills": [170701, 170704, 170702, 170703]},
    1703: {"level": 59, "quality": 2, "isAwake": False, "skills": [170302, 170304, 170303, 170301]},
    1702: {"level": 1, "quality": 2, "isAwake": False, "skills": [170204, 170202, 170201, 170203]},
    1713: {"level": 1, "quality": 1, "isAwake": False, "skills": [171301, 171304, 171303, 171302]},
    1718: {"level": 1, "quality": 2, "isAwake": False, "skills": [171804, 171801, 171802, 171803]},
    1714: {"level": 1, "quality": 1, "isAwake": False, "skills": [171402, 171403, 171404, 171401]},
    1717: {"level": 60, "quality": 5, "isAwake": False, "skills": [171704, 171701, 171703, 171702]},
    1710: {"level": 1, "quality": 1, "isAwake": False, "skills": [171001, 171002, 171003, 171004]},
    1708: {"level": 60, "quality": 3, "isAwake": False, "skills": [170803, 170804, 170801, 170802]},
    1704: {"level": 1, "quality": 3, "isAwake": False, "skills": [170401, 170404, 170403, 170402]},
    1705: {"level": 1, "quality": 3, "isAwake": False, "skills": [170502, 170503, 170504, 170501]},
    1700: {"level": 60, "quality": 5, "isAwake": False, "skills": [170002, 170003, 170004, 170001]},
    1701: {"level": 1, "quality": 4, "isAwake": False, "skills": [170103, 170101, 170102, 170104]},
}

# In getBuffList:
# realSkillID = skillType * 100 + quality
# queries heroltCtrl:querySkillBuffInfo(realSkillID)

# Let's check where querySkillBuffInfo reads from
# Usually skill.lua or hero_skill_config.lua
skill_cfg_path = r"game_file\src\app\localtb\config_server\skill.lua"
with open(skill_cfg_path, "r", encoding="utf-8", errors="ignore") as f:
    skill_content = f.read()

for hid, info in beetoo2_heroes.items():
    q = info["quality"]
    for st in info["skills"]:
        real_id = st * 100 + q
        # Let's search real_id in skill.lua
        pattern = rf'skillID\s*=\s*{real_id}\b'
        idx = skill_content.find(f"skillID = {real_id}")
        if idx != -1:
            snippet = skill_content[idx:idx+300]
            # check buffType
            m_bt = re.search(r'buffType[^\n=]*=\s*(\d+)', snippet)
            m_bv = re.search(r'buffValue[^\n=]*=\s*([\d\.]+)', snippet)
            bt = m_bt.group(1) if m_bt else "unknown"
            bv = m_bv.group(1) if m_bv else "unknown"
            if bt in ("96", "19", "5"):
                print(f"Hero {hid} skill {st} (real {real_id}): buffType={bt}, buffValue={bv}")
            # print all for debug
            # print(f"Hero {hid} skill {st}: bt={bt}, bv={bv}")

print("Checked all hero basic skills.")
