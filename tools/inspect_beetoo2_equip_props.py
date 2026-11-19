# -*- coding: utf-8 -*-
import re

eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]

path = r"game_file\src\app\localtb\config_server\equipment_base_property_config.lua"
with open(path, "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for eid in eids:
    idx = text.find(f"equipmentID = {eid}")
    if idx != -1:
        snippet = text[idx-50:idx+600]
        print(f"=== EID {eid} in equipment_base_property_config ===")
        # find propertyType and specialType
        for line in snippet.splitlines()[:25]:
            if any(k in line for k in ["propertyType", "propertyValue", "specialType", "addition", "eType"]):
                print("  ", line.strip())
