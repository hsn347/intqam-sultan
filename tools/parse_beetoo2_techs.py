import json
import re

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tech_ctrl = data.get("technologyCtrl", {})
researched_types = {}
for k, v in tech_ctrl.items():
    if isinstance(v, list) and len(v) >= 2:
        researched_types[int(v[0])] = int(v[1])

print(f"Researched techs count: {len(researched_types)}")

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

# Split by "technologyID ="
blocks = content.split("technologyID =")
techs = {}
for b in blocks[1:]:
    lines = b.splitlines()[:20]
    m_id = re.search(r'^\s*(\d+)', lines[0])
    if not m_id:
        continue
    full_id = int(m_id.group(1))
    
    m_type = re.search(r'technologyType\s*=\s*(\d+)', b[:500])
    m_lv = re.search(r'technologyLevel\s*=\s*(?:nil,\s*)?(\d+)', b[:500])
    m_buff = re.search(r'buffType\s*=\s*(\d+)', b[:500])
    m_pw = re.search(r'powerNum\s*=\s*(\d+)', b[:500])
    m_numtype = re.search(r'buffNumType\s*=\s*(\d+)', b[:500])
    
    if m_type and m_lv and m_buff and m_pw:
        ttype = int(m_type.group(1))
        tlv = int(m_lv.group(1))
        tbuff = int(m_buff.group(1))
        tpw = int(m_pw.group(1))
        tbnt = int(m_numtype.group(1)) if m_numtype else 1
        
        if ttype not in techs:
            techs[ttype] = {}
        techs[ttype][tlv] = (tpw, tbuff, tbnt, full_id)

print(f"Parsed {len(techs)} tech types from config.")

# Now check beetoo2's researched techs
buff_sums = {}
for ttype, tlv in researched_types.items():
    if ttype in techs and tlv in techs[ttype]:
        pw, bt, bnt, fid = techs[ttype][tlv]
        cardinal = 1 if bnt == 2 else 1000
        val = pw / cardinal
        buff_sums[bt] = buff_sums.get(bt, 0) + val
        if bt == 43:
            print(f"Type 43 (March Strength): techType={ttype}, lv={tlv}, pw={pw}, val={val}")
        elif val in (4500, 3500, 1000, 2000, 4500.0) or pw in (4500, 4500000):
            print(f"MATCH VAL {val}: techType={ttype}, lv={tlv}, buffType={bt}")

print("\nSummary of all researched tech buffs for beetoo2:")
for bt, val in sorted(buff_sums.items()):
    print(f"  buffType {bt}: {val}")
