# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/science_study.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

entries = re.split(r';\(nil\)\.id\s*=\s*\d+', text)
tech_props = {}
for e in entries[1:]:
    m_t = re.search(r'techID\s*=\s*(\d+)', e)
    m_l = re.search(r'level\s*=\s*(\d+)', e)
    m_p = re.search(r'property\s*=\s*(\d+)', e)
    m_v = re.search(r'value\s*=\s*(\d+)', e)
    if m_t and m_l and m_p and m_v:
        tid = int(m_t.group(1))
        lvl = int(m_l.group(1))
        prop = int(m_p.group(1))
        val = int(m_v.group(1))
        if tid not in tech_props:
            tech_props[tid] = {}
        tech_props[tid][lvl] = (prop, val)

# Beetoo2 tech
beetoo2_tech = [
    (24021, 2), (24018, 5), (24004, 3), (24033, 1), (24027, 2), (24104, 2), (24017, 1), (24016, 3), (24002, 3),
    (25009, 4), (24112, 1), (24116, 1), (24117, 3), (24011, 1), (24001, 2), (22003, 5), (24006, 3), (24022, 2),
    (24019, 2), (21002, 5), (24009, 3), (25002, 5), (25029, 1), (22005, 8), (25007, 4), (24111, 1), (24106, 2),
    (25003, 2), (22004, 2), (21001, 5), (21006, 1), (25001, 5), (25006, 1), (24101, 2), (24115, 1), (24010, 3),
    (25030, 1), (22002, 5), (24032, 2), (22007, 2), (24110, 1), (25005, 1), (24023, 3), (24012, 3), (24014, 3),
    (25004, 2), (24103, 2), (24107, 2), (22001, 10), (24015, 3), (22006, 1), (21004, 9), (24003, 3), (24007, 3),
    (21005, 3), (25010, 4), (22009, 10), (21003, 1), (24020, 2), (22008, 5), (24105, 2), (25008, 4), (24008, 3),
    (24114, 1), (25011, 1), (24113, 1), (24109, 1), (24005, 3), (24013, 3), (24108, 1)
]

print("Checking Beetoo2 technologies:")
total_single_troop = 0
for tid, lvl in beetoo2_tech:
    if tid in tech_props and lvl in tech_props[tid]:
        prop, val = tech_props[tid][lvl]
        if prop in (43, 73, 77, 95):
            print(f"Tech {tid} Lv.{lvl}: property={prop}, val={val}")
            total_single_troop += val
        elif 'march' in str(prop).lower() or prop in (19, 96):
            print(f"Tech {tid} Lv.{lvl}: SPECIAL property={prop}, val={val}")

print(f"Total tech add: {total_single_troop}")
