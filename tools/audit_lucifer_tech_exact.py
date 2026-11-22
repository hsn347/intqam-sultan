import json
import re

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

tctrl = data.get("technologyCtrl", {})

with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    tech_lua = f.read()

for tid, tval in tctrl.items():
    tlv = int(tval[1] if isinstance(tval, list) else tval)
    full_id = f"{tid}{tlv:02d}"
    idx = tech_lua.find(f".technologyID = {full_id}")
    if idx != -1:
        chunk = tech_lua[idx:idx+1500]
        # find buffType
        m_bt = re.search(r"\.buffType\s*=\s*(?:nil,\s*)*(\d+)", chunk)
        m_pw = re.search(r"\.powerNum\s*=\s*(?:nil,\s*)*(\d+)", chunk)
        if m_bt:
            bt = int(m_bt.group(1))
            pw = int(m_pw.group(1)) if m_pw else 0
            if bt in (43, 19, 73, 77, 95, 96):
                print(f"Tech {tid} Lv {tlv} -> buffType {bt}, powerNum {pw}")
