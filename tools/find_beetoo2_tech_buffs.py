# -*- coding: utf-8 -*-
import os
import re

tools_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(tools_dir)
tech_file = os.path.join(root_dir, "game_file", "src", "app", "localtb", "config_server", "technology.lua")

beetoo2_techs = {'24021': 2, '24018': 5, '24004': 3, '24033': 1, '24027': 2, '24104': 2, '24017': 1, '24016': 3, '24002': 3, '25009': 4, '24112': 1, '24116': 1, '24117': 3, '24011': 1, '24001': 2, '22003': 5, '24006': 3, '24022': 2, '24019': 2, '21002': 5, '24009': 3, '25002': 5, '25029': 1, '22005': 8, '25007': 4, '24111': 1, '24106': 2, '25003': 2, '22004': 2, '21001': 5, '21006': 1, '25001': 5, '25006': 1, '24101': 2, '24115': 1, '24010': 3, '25030': 1, '22002': 5, '24032': 2, '22007': 2, '24110': 1, '25005': 1, '24023': 3, '24012': 3, '24014': 3, '25004': 2, '24103': 2, '24107': 2, '22001': 10, '24015': 3, '22006': 1, '21004': 9, '24003': 3, '24007': 3, '21005': 3, '25010': 4, '22009': 10, '21003': 1, '24020': 2, '22008': 5, '24105': 2, '25008': 4, '24008': 3, '24114': 1, '25011': 1, '24113': 1, '24109': 1, '24005': 3, '24013': 3, '24108': 1}

# Let's search each beetoo2 tech ID directly
print(f"Scanning for {len(beetoo2_techs)} technologies...")

with open(tech_file, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

results = {}
for i, line in enumerate(lines):
    if "technologyID = " in line:
        m = re.search(r'technologyID\s*=\s*(\d+)', line)
        if m:
            tid_full = m.group(1)
            # base tech id = tid_full[:-2]
            base_tid = tid_full[:-2]
            tlv = int(tid_full[-2:])
            if base_tid in beetoo2_techs and beetoo2_techs[base_tid] == tlv:
                # inspect following 25 lines
                block = "".join(lines[i:min(len(lines), i+30)])
                m_buff = re.search(r'buffType\s*=\s*(\d+)', block)
                m_pow = re.search(r'powerNum\s*=\s*([\d\.]+)', block)
                m_bnt = re.search(r'buffNumType\s*=\s*(\d+)', block)
                if m_buff:
                    bt = int(m_buff.group(1))
                    pw = float(m_pow.group(1)) if m_pow else 0.0
                    bnt = int(m_bnt.group(1)) if m_bnt else 0
                    cardinal = 1 if bnt == 2 else 1000
                    val = pw / cardinal
                    results[base_tid] = (tlv, bt, pw, bnt, val)

print(f"Matched {len(results)} technologies:")
total_single_troop = 0
for btid, (tlv, bt, pw, bnt, val) in sorted(results.items()):
    if bt in (43, 73, 77, 95):
        print(f"  * Tech {btid} Lv.{tlv}: buffType={bt}, powerNum={pw}, bnt={bnt} => +{val}")
        if bt == 43:
            total_single_troop += val

print(f"\nTotal SINGLE_TROOP_STRENGTH (Type 43) = {total_single_troop}")
