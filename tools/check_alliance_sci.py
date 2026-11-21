import re

text = open('game_file/src/app/localtb/config_server/alliance_science_lv.lua', encoding='utf-8', errors='ignore').read()
sciences = [(31001, 4), (31002, 1), (31003, 5), (31004, 1), (31005, 1), (32003, 3), (32005, 1)]

for sid, lv in sciences:
    pattern = rf'\.id\s*=\s*{sid}\s*;\(nil\)\.level\s*=\s*{lv}\s*;\(nil\)\.technologyPower\s*=\s*"([^"]+)"'
    m = re.search(pattern, text)
    if m:
        power = m.group(1)
        attr_type = int(power[:2])
        val_type = int(power[2:4])
        val = int(power[4:])
        print(f"Alliance Sci {sid} Lv {lv}: power={power} -> attrType={attr_type}, valType={val_type}, val={val}")
