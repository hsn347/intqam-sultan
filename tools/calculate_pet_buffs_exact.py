# -*- coding: utf-8 -*-
import json
import re

with open("game_file/src/app/localtb/config_server/pet_level_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    level_text = f.read()

with open("game_file/src/app/localtb/config_server/pet_rank_conf.lua", "r", encoding="utf-8", errors="ignore") as f:
    rank_text = f.read()

# Parse pet_level_conf: key is (petid, lv) -> talent_skill (list of strings)
# Pattern: petid = X, lv = Y, talent_skill = { ... }
level_entries = re.split(r';\([^\)]*\)\.index\s*=\s*\d+|;\(nil\)\.index\s*=\s*\d+', level_text)
pet_levels = {}
for e in level_entries:
    m_pid = re.search(r'petid\s*=\s*(?:nil,\s*)?(\d+)', e)
    m_lv = re.search(r'\blv\s*=\s*(?:nil,\s*)?(\d+)', e)
    if m_pid and m_lv:
        pid = int(m_pid.group(1))
        lv = int(m_lv.group(1))
        # find talent_skill strings
        m_skills = re.findall(r'talent_skill.*?\"(\d+)\"', e)
        if not m_skills:
            m_skills = re.findall(r'\"(\d{6,})\"', e)
        pet_levels[(pid, lv)] = m_skills

print(f"Parsed {len(pet_levels)} pet level entries.")

# Parse pet_rank_conf: key is (petid, rank) -> special_skill_add (list of strings)
rank_entries = re.split(r';\([^\)]*\)\.index\s*=\s*\d+|;\(nil\)\.index\s*=\s*\d+', rank_text)
pet_ranks = {}
for e in rank_entries:
    m_pid = re.search(r'petid\s*=\s*(?:nil,\s*)?(\d+)', e)
    m_rk = re.search(r'rank\s*=\s*(?:nil,\s*)?(\d+)', e)
    if m_pid and m_rk:
        pid = int(m_pid.group(1))
        rk = int(m_rk.group(1))
        m_skills = re.findall(r'special_skill_add.*?\"(\d+)\"', e)
        if not m_skills:
            m_skills = re.findall(r'\"(\d{6,})\"', e)
        pet_ranks[(pid, rk)] = m_skills

print(f"Parsed {len(pet_ranks)} pet rank entries.")

def check_account_pets(json_path, name):
    d = json.load(open(json_path, 'r', encoding='utf-8'))
    pets = d.get('petCtrl', {}).get('petList', {})
    print(f"\n=== PET ANALYSIS FOR {name} ===")
    total_march_val = 0
    total_march_pct = 0
    for pid_str, pinfo in pets.items():
        pid = int(pinfo.get('petid', pid_str))
        rk = int(pinfo.get('rank', 1))
        lv = int(pinfo.get('level', 1))
        print(f"Pet {pid}: Rank {rk}, Lv {lv}")
        
        # Check level talents
        l_skills = pet_levels.get((pid, lv), [])
        for s in l_skills:
            atype = int(s[:2])
            vtype = int(s[2:4])
            val = int(s[4:])
            if atype == 18: # MARCH_VALUE_LIMIT_BOOST
                print(f"  [Talent Lv] MARCH_VALUE_LIMIT_BOOST: raw={s}, val={val}")
                total_march_val += val
            elif atype in [15, 30]:
                print(f"  [Talent Lv] attr {atype}: raw={s}, val={val}")
        
        # Check rank skills
        r_skills = pet_ranks.get((pid, rk), [])
        for s in r_skills:
            atype = int(s[:2])
            vtype = int(s[2:4])
            val = int(s[4:])
            if atype == 18: # MARCH_VALUE_LIMIT_BOOST
                print(f"  [Special Rank] MARCH_VALUE_LIMIT_BOOST: raw={s}, val={val}")
                total_march_val += val
            elif atype in [15, 30]:
                print(f"  [Special Rank] attr {atype}: raw={s}, val={val}")
    print(f"TOTAL Pet MARCH_VALUE_LIMIT_BOOST for {name}: {total_march_val}")

check_account_pets("tools/beetoo1_full_init_data.json", "BEETOO 1")
check_account_pets("tools/beetoo2_full_init_data.json", "BEETOO 2")
