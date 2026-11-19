import json
import os
import re

# 1. Check all 70 researched technologies of Beetoo2
with open(r"e:\intqam-sultan\tools\beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tech_ctrl = data.get("technologyCtrl", {})
print(f"Total researched technologies in beetoo2: {len(tech_ctrl)}")

# Load technology.lua
with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    tech_content = f.read()

# Let's inspect tech_ctrl items and see what properties/powers they have
tech_entries = re.findall(r'\[(\d+)\]\s*=\s*\{([^}]+)\}', tech_content)
tech_map = {}
for tid_str, body in tech_entries:
    tid = int(tid_str)
    # find levels: [1] = { ... }
    levels = re.findall(r'\[(\d+)\]\s*=\s*\{([^}]+)\}', body)
    tech_map[tid] = {}
    for lv_str, lv_body in levels:
        lv = int(lv_str)
        # power, buffType, buffNumType
        parts = [p.strip() for p in lv_body.split(',')]
        if len(parts) >= 3:
            try:
                pw = int(parts[0])
                bt = int(parts[1])
                bnt = int(parts[2])
                tech_map[tid][lv] = (pw, bt, bnt)
            except ValueError:
                pass

print("Loaded tech map entries:", len(tech_map))

# Check each researched tech in beetoo2
total_by_type = {}
for tid_key, tdata in tech_ctrl.items():
    tid = int(tdata[0]) if isinstance(tdata, (list, tuple)) else int(tid_key)
    tlv = int(tdata[1]) if isinstance(tdata, (list, tuple)) else int(tdata)
    info = tech_map.get(tid, {}).get(tlv)
    if info:
        pw, bt, bnt = info
        cardinal = 1 if bnt == 2 else 1000
        val = pw / cardinal
        total_by_type[bt] = total_by_type.get(bt, 0) + val
        if bt == 43 or val == 4500 or pw == 4500:
            print(f"Tech {tid} Lv {tlv}: power={pw}, type={bt}, numType={bnt}, val={val}")

print("\nTech totals by buffType:")
for bt, val in sorted(total_by_type.items()):
    print(f"  Type {bt}: {val}")
