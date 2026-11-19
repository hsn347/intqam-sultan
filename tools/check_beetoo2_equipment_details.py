# -*- coding: utf-8 -*-
import json
import os
import re

# EIDs worn by beetoo2:
# 1. eid: 6304501, slv: 0, qly: 3 (Helmet?) extra: [[17, 25], [30, 37], [34, 65]]
# 2. eid: 6204501, slv: 0, qly: 3 (Armor?) extra: [[14, 34], [32, 15], [28, 20]]
# 3. eid: 6404501, slv: 0, qly: 3 (Weapon?) extra: [[16, 20], [28, 27], [34, 42]]
# 4. eid: 6604501, slv: 0, qly: 3 (Ring?) extra: [[30, 37], [32, 20], [33, 20]]
# 5. eid: 6105001, slv: 0, qly: 3 (Ring/Necklace?) extra: [[26, 36], [30, 42], [23, 41]]
# 6. eid: 6504501, slv: 0, qly: 3 (Boots?) extra: [[23, 42], [26, 47], [32, 17]]

# Let's inspect equipment_config.lua and equipment_base_property.lua
eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]

cfg_path = r"game_file\src\app\localtb\config_client\equipment_config.lua"
with open(cfg_path, "r", encoding="utf-8", errors="ignore") as f:
    cfg_text = f.read()

for eid in eids:
    idx = cfg_text.find(f"equipid = {eid}")
    if idx != -1:
        snippet = cfg_text[idx-50:idx+350]
        print(f"=== EID {eid} in equipment_config ===")
        print(snippet[:300])
