import json
import re

with open("tools/beetoo1_live_diag.json", "r", encoding="utf-8") as f:
    diag = json.load(f)

tech_ctrl = diag.get("technologyCtrl", {})
print(f"Total techs in beetoo1: {len(tech_ctrl)}")

with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    tech_lua = f.read()

# Let's inspect each tech that beetoo1 has
for tid_str, tdata in tech_ctrl.items():
    tid = tdata[0] if isinstance(tdata, (list, tuple)) else tid_str
    tlv = tdata[1] if isinstance(tdata, (list, tuple)) else tdata
    tech_id_str = f"{tid}{int(tlv):02d}"
    
    # search for technologyID = tech_id_str in technology.lua
    pattern = rf"technologyID\s*=\s*{tech_id_str}.*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*([0-9.]+).*?buffNumType\s*=\s*(\d+)"
    m = re.search(pattern, tech_lua, re.DOTALL)
    if m:
        btype = int(m.group(1))
        pnum = float(m.group(2))
        bnumtype = int(m.group(3))
        # If buffType is related to march or capacity or anything
        print(f"Tech {tid} Lv.{tlv} (full {tech_id_str}): buffType={btype}, powerNum={pnum}, buffNumType={bnumtype}")
