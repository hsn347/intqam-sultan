# -*- coding: utf-8 -*-
import json
import os
import re

tools_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(tools_dir)
tech_file = os.path.join(root_dir, "game_file", "src", "app", "localtb", "config_server", "technology.lua")

beetoo2_techs = {'24021': 2, '24018': 5, '24004': 3, '24033': 1, '24027': 2, '24104': 2, '24017': 1, '24016': 3, '24002': 3, '25009': 4, '24112': 1, '24116': 1, '24117': 3, '24011': 1, '24001': 2, '22003': 5, '24006': 3, '24022': 2, '24019': 2, '21002': 5, '24009': 3, '25002': 5, '25029': 1, '22005': 8, '25007': 4, '24111': 1, '24106': 2, '25003': 2, '22004': 2, '21001': 5, '21006': 1, '25001': 5, '25006': 1, '24101': 2, '24115': 1, '24010': 3, '25030': 1, '22002': 5, '24032': 2, '22007': 2, '24110': 1, '25005': 1, '24023': 3, '24012': 3, '24014': 3, '25004': 2, '24103': 2, '24107': 2, '22001': 10, '24015': 3, '22006': 1, '21004': 9, '24003': 3, '24007': 3, '21005': 3, '25010': 4, '22009': 10, '21003': 1, '24020': 2, '22008': 5, '24105': 2, '25008': 4, '24008': 3, '24114': 1, '25011': 1, '24113': 1, '24109': 1, '24005': 3, '24013': 3, '24108': 1}

# We will parse technology.lua record by record
# Each record starts around ;(nil).index = X
print("Parsing technology.lua...")
with open(tech_file, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Split by index
records = re.split(r';\(nil\)\.index\s*=\s*\d+', text)
print(f"Total records in technology.lua: {len(records)}")

march_techs = []
for rec in records:
    # check technologyID
    m_id = re.search(r';\(nil\)\.technologyID\s*=\s*(\d+)', rec)
    if not m_id:
        continue
    tech_id = int(m_id.group(1))
    
    m_buff = re.search(r';\(nil\)\.buffType\s*=\s*(\d+)', rec)
    if not m_buff:
        continue
    buff_type = int(m_buff.group(1))
    
    m_pow = re.search(r';\(nil\)\.powerNum\s*=\s*([\d\.]+)', rec)
    pow_num = float(m_pow.group(1)) if m_pow else 0.0
    
    m_bnt = re.search(r';\(nil\)\.buffNumType\s*=\s*(\d+)', rec)
    bnt = int(m_bnt.group(1)) if m_bnt else 0
    
    # Check if buff_type is 43 (SINGLE_TROOP_STRENGTH), 73, 77, 95
    if buff_type in (43, 73, 77, 95):
        # Base tech id = tech_id // 100, level = tech_id % 100
        base_tid = tech_id // 100
        lv = tech_id % 100
        march_techs.append((base_tid, lv, buff_type, pow_num, bnt))

print(f"Found {len(march_techs)} march tech entries across all technologies!")
# Check which ones beetoo2 has
print("\n--- Beetoo2 March Techs ---")
total_beetoo2_add = 0
for base_tid, lv, buff_type, pow_num, bnt in march_techs:
    str_tid = str(base_tid)
    if str_tid in beetoo2_techs:
        current_lv = beetoo2_techs[str_tid]
        if lv == current_lv:
            cardinal = 1 if bnt == 2 else 1000
            val = int(pow_num / cardinal)
            total_beetoo2_add += val
            print(f"MATCH: Tech {base_tid} Lv.{lv} -> buffType={buff_type}, powerNum={pow_num}, bnt={bnt} => +{val}")

print(f"\nTOTAL TECH SINGLE TROOP STRENGTH: {total_beetoo2_add}")
