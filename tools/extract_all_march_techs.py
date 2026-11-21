# -*- coding: utf-8 -*-
import re
import json

tech_file = "game_file/src/app/localtb/config_server/technology.lua"

tech_map = {}
current_id = None
current_tech = {}

with open(tech_file, "r", encoding="utf-8", errors="ignore") as f:
    for line in f:
        m_id = re.search(r"technologyID\s*=\s*(\d+)", line)
        if m_id:
            if current_id and current_tech.get("buffType") in (43, 73, 77, 95):
                tech_map[current_id] = current_tech
            current_id = int(m_id.group(1))
            current_tech = {"id": current_id}
            continue
        
        m_lv = re.search(r"technologyLevel\s*=\s*.*?(\d+)", line)
        if m_lv and current_id:
            current_tech["level"] = int(m_lv.group(1))
            
        m_bt = re.search(r"buffType\s*=\s*(\d+)", line)
        if m_bt and current_id:
            current_tech["buffType"] = int(m_bt.group(1))
            
        m_pn = re.search(r"powerNum\s*=\s*(\d+)", line)
        if m_pn and current_id:
            current_tech["powerNum"] = int(m_pn.group(1))
            
        m_bnt = re.search(r"buffNumType\s*=\s*(\d+)", line)
        if m_bnt and current_id:
            current_tech["buffNumType"] = int(m_bnt.group(1))

if current_id and current_tech.get("buffType") in (43, 73, 77, 95):
    tech_map[current_id] = current_tech

print(f"Total march tech levels found in technology.lua: {len(tech_map)}")
by_type = {}
for tid, info in tech_map.items():
    bt = info.get("buffType")
    base_id = tid // 100
    lv = tid % 100
    by_type.setdefault(bt, {}).setdefault(base_id, {})[lv] = info.get("powerNum")

print(json.dumps(by_type, indent=2))
