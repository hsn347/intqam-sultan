# -*- coding: utf-8 -*-
import json
import os
import re

tools_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(tools_dir)

tech_keys = {'24021': ['24021', 2], '24018': ['24018', 5], '24004': ['24004', 3], '24033': ['24033', 1], '24027': ['24027', 2], '24104': ['24104', 2], '24017': ['24017', 1], '24016': ['24016', 3], '24002': ['24002', 3], '25009': ['25009', 4], '24112': ['24112', 1], '24116': ['24116', 1], '24117': ['24117', 3], '24011': ['24011', 1], '24001': ['24001', 2], '22003': ['22003', 5], '24006': ['24006', 3], '24022': ['24022', 2], '24019': ['24019', 2], '21002': ['21002', 5], '24009': ['24009', 3], '25002': ['25002', 5], '25029': ['25029', 1], '22005': ['22005', 8], '25007': ['25007', 4], '24111': ['24111', 1], '24106': ['24106', 2], '25003': ['25003', 2], '22004': ['22004', 2], '21001': ['21001', 5], '21006': ['21006', 1], '25001': ['25001', 5], '25006': ['25006', 1], '24101': ['24101', 2], '24115': ['24115', 1], '24010': ['24010', 3], '25030': ['25030', 1], '22002': ['22002', 5], '24032': ['24032', 2], '22007': ['22007', 2], '24110': ['24110', 1], '25005': ['25005', 1], '24023': ['24023', 3], '24012': ['24012', 3], '24014': ['24014', 3], '25004': ['25004', 2], '24103': ['24103', 2], '24107': ['24107', 2], '22001': ['22001', 10], '24015': ['24015', 3], '22006': ['22006', 1], '21004': ['21004', 9], '24003': ['24003', 3], '24007': ['24007', 3], '21005': ['21005', 3], '25010': ['25010', 4], '22009': ['22009', 10], '21003': ['21003', 1], '24020': ['24020', 2], '22008': ['22008', 5], '24105': ['24105', 2], '25008': ['25008', 4], '24008': ['24008', 3], '24114': ['24114', 1], '25011': ['25011', 1], '24113': ['24113', 1], '24109': ['24109', 1], '24005': ['24005', 3], '24013': ['24013', 3], '24108': ['24108', 1]}

# Search across all lua files for these tech IDs
localtb = os.path.join(root_dir, "game_file", "src", "app", "localtb")
tech_files = []
for root, dirs, files in os.walk(localtb):
    for f in files:
        if "technology" in f.lower() and f.endswith(".lua"):
            tech_files.append(os.path.join(root, f))

print(f"Checking {len(tech_files)} tech files...")

found_techs = {}
for tf in tech_files:
    with open(tf, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
        
    for i, line in enumerate(lines):
        # Look for [2401603] or buffType
        for tid, (t_id, tlv) in tech_keys.items():
            # Check combined ID like 2401603 or 24016_3
            comb1 = f"{t_id}{tlv:02d}"
            comb2 = f"{t_id}_{tlv}"
            if f"[{comb1}]" in line or f'["{comb1}"]' in line:
                # inspect nearby lines
                block = "".join(lines[max(0, i-5):min(len(lines), i+25)])
                m_buff = re.search(r'buffType\s*=\s*(\d+)', block)
                m_power = re.search(r'powerNum\s*=\s*([\d\.]+)', block)
                m_bnt = re.search(r'buffNumType\s*=\s*(\d+)', block)
                if m_buff:
                    bt = int(m_buff.group(1))
                    pw = float(m_power.group(1)) if m_power else 0.0
                    bnt = int(m_bnt.group(1)) if m_bnt else 0
                    found_techs[t_id] = (tlv, bt, pw, bnt, os.path.basename(tf))

print("\nMatched techs for beetoo2:")
total_single_troop = 0
for tid, info in found_techs.items():
    tlv, bt, pw, bnt, fname = info
    cardinal = 1 if bnt == 2 else 1000
    val = pw / cardinal
    if bt in (43, 73, 77, 95):
        print(f"  Tech {tid} Lv.{tlv}: buffType={bt}, powerNum={pw}, bnt={bnt} => val={val} (from {fname})")
        if bt == 43:
            total_single_troop += val

print(f"\nTotal Single Troop Strength Tech Add: {total_single_troop}")
