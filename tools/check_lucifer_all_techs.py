# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

pattern = re.compile(r'technologyID\s*=\s*(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+).*?buffNumType\s*=\s*(\d+)', re.S)
tech_map = {}
for m in pattern.finditer(text):
    tid = int(m.group(1))
    btype = int(m.group(2))
    pnum = int(m.group(3))
    bnumtype = int(m.group(4))
    tech_map[tid] = {'buffType': btype, 'powerNum': pnum, 'buffNumType': bnumtype}

print(f'Parsed {len(tech_map)} tech details from technology.lua')

lucifer_techs = {
    21001: 4, 21002: 1, 21003: 1, 22001: 10, 22002: 5, 22003: 1, 23001: 10,
    23005: 1, 23007: 1, 23008: 1, 23009: 1, 23010: 1, 23011: 4, 23012: 1,
    24001: 5, 24006: 2, 24011: 1, 24016: 2, 24017: 1, 24022: 2, 24027: 2,
    24032: 2, 24033: 1, 24038: 1, 24101: 1, 110001: 1, 110002: 1, 120001: 4,
    120002: 3, 120003: 2, 120004: 1, 140001: 15, 140002: 14, 140003: 6,
    140004: 6, 140006: 1, 140007: 4, 140008: 3, 140009: 3, 140010: 2,
    140011: 1, 140012: 1, 150001: 6, 150002: 6, 150003: 6, 150004: 3,
    150005: 6, 150006: 5, 150007: 3, 150008: 2, 150009: 3, 150010: 3,
    150011: 2, 150018: 2
}

march_related_buffs = [12, 19, 41, 42, 43, 73, 77, 90, 95, 96, 100]

print("\n--- ALL LUCIFER TECHS ---")
for tech_id, lvl in lucifer_techs.items():
    mosaic_id = int(f'{tech_id}{lvl:02d}')
    detail = tech_map.get(mosaic_id)
    if detail:
        btype = detail['buffType']
        is_march = btype in march_related_buffs
        flag = " *** MARCH RELATED ***" if is_march else ""
        print(f"Tech {tech_id:6d} Lv {lvl:2d} (ID {mosaic_id}): buffType={btype:3d}, powerNum={detail['powerNum']:6d}, buffNumType={detail['buffNumType']}{flag}")
    else:
        print(f"Tech {tech_id:6d} Lv {lvl:2d} (ID {mosaic_id}): NOT FOUND")
