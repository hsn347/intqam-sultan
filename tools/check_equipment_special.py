# -*- coding: utf-8 -*-
import os
import re

worn_eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]

# Let's search config files for these eids
config_dir = r"game_file\src\app\localtb\config_client"
for f in os.listdir(config_dir):
    if "equip" in f:
        path = os.path.join(config_dir, f)
        with open(path, "r", encoding="utf-8", errors="ignore") as fp:
            content = fp.read()
            for eid in worn_eids:
                if str(eid) in content:
                    print(f"Found {eid} in {f}")

# Also check equipmentBasePropertyConfig
prop_path = r"game_file\src\app\localtb\config_client\equipment_base_property.lua"
if os.path.exists(prop_path):
    print("Reading equipment_base_property.lua...")
    with open(prop_path, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
        for i, l in enumerate(lines):
            for eid in worn_eids:
                if str(eid) in l:
                    print(f"Line {i}: {l.strip()[:100]}")
                    for j in range(max(0, i-5), min(len(lines), i+25)):
                        print(f"  {j}: {lines[j].strip()}")
