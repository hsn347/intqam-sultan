import re

def parse_kl_buffs():
    path = r"E:\intqam-sultan\game_file\src\app\localtb\config_server\kingdom_lv_config.lua"
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    lines = text.splitlines()
    
    current_klv = None
    buff_pairs = {}
    
    klv_data = {}
    
    for line in lines:
        line = line.strip()
        m_klv = re.search(r'kingdomLv\s*=\s*(\d+)', line)
        if m_klv:
            current_klv = int(m_klv.group(1))
            klv_data[current_klv] = {}
            continue
            
        if current_klv is not None and "buff" in line:
            # e.g.: _UPVALUE2_, (nil).buff, (nil)[1] = nil, nil, 96
            # or: ;(nil).buff, (nil)[1] = nil, 96
            # or: ;(nil).buff, (96)[1] = 96, 2
            m_idx = re.search(r'buff.*?\[(\d+)\]\s*=\s*.*?,?\s*(\d+)', line)
            if m_idx:
                idx = int(m_idx.group(1))
                val = int(m_idx.group(2))
                klv_data[current_klv][idx] = val

    print(f"Parsed {len(klv_data)} kingdom levels.")
    
    for klv in sorted(klv_data.keys()):
        raw_map = klv_data[klv]
        # convert pairs [1]->type, [2]->val, [3]->type, [4]->val
        buff_map = {}
        for i in range(1, len(raw_map)+1, 2):
            if i in raw_map and (i+1) in raw_map:
                buff_map[raw_map[i]] = raw_map[i+1]
        
        if 96 in buff_map:
            print(f"KingdomLv {klv:3d}: Buff 96 = {buff_map[96]:,}")

if __name__ == "__main__":
    parse_kl_buffs()
