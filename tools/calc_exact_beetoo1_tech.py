import json
import re

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

tech_data = d.get('technologyCtrl', {})

with open(r'game_file\src\app\localtb\config_server\technology.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

total_tech_43 = 0
found_techs = []

for k, v in tech_data.items():
    if isinstance(v, list) and len(v) >= 2:
        tid, tlv = v[0], v[1]
    elif isinstance(v, (int, str)):
        tid, tlv = k, v
    else:
        continue
    
    cid = f"{int(tid)}{int(tlv):02d}"
    
    idx = text.find(f".technologyID = {cid}")
    if idx != -1:
        chunk = text[idx:idx+600]
        m_bt = re.search(r'buffType\s*=\s*(\d+)', chunk)
        m_pn = re.search(r'powerNum\s*=\s*(\d+)', chunk)
        m_bn = re.search(r'buffNumType\s*=\s*(\d+)', chunk)
        if m_bt and m_pn:
            bt = int(m_bt.group(1))
            pn = int(m_pn.group(1))
            bn = int(m_bn.group(1)) if m_bn else 2
            val = pn / 1000.0 if bn == 1 else pn
            found_techs.append((tid, tlv, cid, bt, val))
            if bt == 43:
                total_tech_43 += val
                print(f"Tech {cid} (TID {tid} Lv {tlv}): buffType={bt}, powerNum={val}")

print(f"\nTOTAL Tech 43 (SINGLE_TROOP_STRENGTH): {total_tech_43}")
