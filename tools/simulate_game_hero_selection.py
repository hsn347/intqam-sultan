# -*- coding: utf-8 -*-
import json
import os
import sys

_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT not in sys.path:
    sys.path.insert(0, _ROOT)

from tasks.base_task import _load_march_data_tables

# Let's inspect all 17 heroes of beetoo2 from our live dump
# Hero data from beetoo2 live memory:
heroes_data = {
    "1712": {"level": 60, "state": 1, "quality": 5, "isAwake": True, "skills": ['171204', '171201', '171202', '171203']},
    "1706": {"level": 1, "state": 1, "quality": 3, "isAwake": False, "skills": ['170604', '170601', '170603', '170602']},
    "1711": {"level": 60, "state": 1, "quality": 4, "isAwake": False, "skills": ['171103', '171102', '171101', '171104']},
    "1709": {"level": 52, "state": 1, "quality": 5, "isAwake": False, "skills": ['170904', '170902', '170903', '170901']},
    "1707": {"level": 60, "state": 1, "quality": 3, "isAwake": False, "skills": ['170701', '170704', '170702', '170703']},
    "1703": {"level": 59, "state": 1, "quality": 2, "isAwake": False, "skills": ['170302', '170304', '170303', '170301']},
    "1702": {"level": 1, "state": 1, "quality": 2, "isAwake": False, "skills": ['170204', '170202', '170201', '170203']},
    "1713": {"level": 1, "state": 1, "quality": 1, "isAwake": False, "skills": ['171301', '171304', '171303', '171302']},
    "1718": {"level": 1, "state": 1, "quality": 2, "isAwake": False, "skills": ['171804', '171801', '171802', '171803']},
    "1714": {"level": 1, "state": 1, "quality": 1, "isAwake": False, "skills": ['171402', '171403', '171404', '171401']},
    "1717": {"level": 60, "state": 1, "quality": 5, "isAwake": False, "skills": ['171704', '171701', '171703', '171702']},
    "1710": {"level": 1, "state": 1, "quality": 1, "isAwake": False, "skills": ['171001', '171002', '171003', '171004']},
    "1708": {"level": 60, "state": 1, "quality": 3, "isAwake": False, "skills": ['170803', '170804', '170801', '170802']},
    "1704": {"level": 1, "state": 1, "quality": 3, "isAwake": False, "skills": ['170401', '170404', '170403', '170402']},
    "1705": {"level": 1, "state": 1, "quality": 3, "isAwake": False, "skills": ['170502', '170503', '170504', '170501']},
    "1700": {"level": 60, "state": 1, "quality": 5, "isAwake": False, "skills": ['170002', '170003', '170004', '170001']},
    "1701": {"level": 1, "state": 1, "quality": 4, "isAwake": False, "skills": ['170103', '170101', '170102', '170104']},
}

tables = _load_march_data_tables()
hero_cfg = tables.get("heroes", {})
rare_levels = tables.get("rare_levels", {})

print("=== ALL HEROES MARCH CAPACITY ===")
for hid, hd in heroes_data.items():
    rarity = hero_cfg.get(hid, {}).get("rarity", 1)
    name = hero_cfg.get(hid, {}).get("name", hid)
    r_lvs = rare_levels.get(str(rarity), {})
    march_add = r_lvs.get(str(hd["level"]), 0)
    print(f"Hero {hid} ({name}): level={hd['level']}, rarity={rarity}, march_add={march_add}")
