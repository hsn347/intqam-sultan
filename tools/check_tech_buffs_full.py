import json
import re

with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tech_ctrl = data.get("technologyCtrl", {})
researched = {}
for k, v in tech_ctrl.items():
    if isinstance(v, list) and len(v) >= 2:
        researched[int(v[0])] = int(v[1])

print(f"Researched techs count: {len(researched)}")

with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

entries = re.findall(r'technologyID\s*=\s*(\d+).*?technologyType\s*=\s*(\d+).*?technologyLevel\s*(?:=\s*nil,\s*|=\s*)(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+).*?buffNumType\s*=\s*(\d+)', content, re.DOTALL)

tech_db = {}
for full_id, ttype, tlv, btype, pw, bnt in entries:
    key = (int(ttype), int(tlv))
    tech_db[key] = (int(pw), int(btype), int(bnt), int(full_id))

print(f"Loaded {len(tech_db)} unique tech entries.")

buff_sums = {}
for ttype, tlv in researched.items():
    entry = tech_db.get((ttype, tlv))
    if entry:
        pw, bt, bnt, fid = entry
        cardinal = 1 if bnt == 2 else 1000
        val = pw / cardinal
        buff_sums[bt] = buff_sums.get(bt, 0) + val
        if bt == 43:
            print(f"Type 43 (March Strength): techType={ttype}, lv={tlv}, pw={pw}, val={val}")
        elif val == 4500 or pw == 4500:
            print(f"FOUND 4500: techType={ttype}, lv={tlv}, bt={bt}, val={val}")

print("\nAll buff totals from researched tech:")
for bt, s in sorted(buff_sums.items()):
    print(f"  buffType {bt}: {s}")
