# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Match each technology block:
# Look for technologyID = (\d+)
pattern = re.compile(r'technologyID\s*=\s*(\d+)(.*?)(?=technologyID|\Z)', re.DOTALL)

tech_map = {}
for m in pattern.finditer(text):
    tid = int(m.group(1))
    body = m.group(2)
    m_buff = re.search(r'buffType\s*=\s*(\d+)', body)
    m_power = re.search(r'powerNum\s*=\s*(\d+)', body)
    m_numtype = re.search(r'buffNumType\s*=\s*(\d+)', body)
    buffType = int(m_buff.group(1)) if m_buff else 0
    powerNum = int(m_power.group(1)) if m_power else 0
    numType = int(m_numtype.group(1)) if m_numtype else 0
    tech_map[tid] = {
        'buffType': buffType,
        'powerNum': powerNum,
        'buffNumType': numType
    }

print(f"Total mapped techs: {len(tech_map)}")

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

by_buff = {}
for tid, lvl in beetoo2_tech:
    mosaic = int(f"{tid}{lvl:02d}")
    if mosaic in tech_map:
        d = tech_map[mosaic]
        bt = d['buffType']
        by_buff.setdefault(bt, []).append((tid, lvl, d['powerNum'], d['buffNumType']))
    else:
        print(f"Missing tech: {mosaic}")

print("\n--- Beetoo2 Tech Grouped by buffType ---")
for bt, items in sorted(by_buff.items()):
    total = sum(x[2] for x in items)
    print(f"buffType {bt}: {len(items)} techs, sum powerNum={total}")
    for item in items:
        print(f"   Tech {item[0]} Lv.{item[1]}: powerNum={item[2]}, numType={item[3]}")
