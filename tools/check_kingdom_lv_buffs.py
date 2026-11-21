import os
import re

def check_kingdom_lv_buffs():
    path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server\kingdom_lv_config.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
        
    cur_klv = None
    klv_buffs = {}
    
    for line in lines:
        m_klv = re.search(r"kingdomLv\s*=\s*(\d+)", line)
        if m_klv:
            cur_klv = int(m_klv.group(1))
            
        # check buff
        # buff is typically pairs: buffType, buffValue
        # in lua: buff, (nil)[19] = nil, nil, 96 ; buff, (nil)[20] = nil, nil, 3000
        if cur_klv is not None and "96" in line and "buff" in line:
            # find surrounding lines
            pass
            
    # let's parse using python regex on blocks
    with open(path, "r", encoding="utf-8", errors="ignore") as fp:
        content = fp.read()
        
    blocks = re.split(r"kingdomLv\s*=\s*", content)
    for b in blocks[1:]:
        klv_match = re.match(r"(\d+)", b)
        if not klv_match:
            continue
        klv = int(klv_match.group(1))
        # find buff 96 in block
        # pattern: buff.*?96\s*\n.*?buff.*?(\d+)
        m = re.findall(r"buff.*?,\s*96\b.*?buff.*?,\s*(\d+)", b, re.DOTALL)
        if m:
            klv_buffs[klv] = int(m[0])
            
    print("Kingdom Level Buff 96 (March Capacity) values:")
    for klv in sorted(klv_buffs.keys()):
        print(f"  KingdomLv {klv:2d}: +{klv_buffs[klv]:,}")

if __name__ == "__main__":
    check_kingdom_lv_buffs()
