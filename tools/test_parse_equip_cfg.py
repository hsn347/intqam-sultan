# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tools.parse_lua53_proto import parse_lua53

filepath = r"game_file\src\app\localtb\config_server\equipment_base_property_config.lua"
data = open(filepath, "rb").read()
p = parse_lua53(data)

print(f"Num consts: {len(p['consts'])}, num protos: {len(p['protos'])}")
eids = [6304501, 6204501, 6404501, 6604501, 6105001, 6504501]
for eid in eids:
    if eid in p['consts']:
        print(f"EID {eid} is in consts at index {p['consts'].index(eid)}")

# Check if any const is 'specialType'
for i, c in enumerate(p['consts']):
    if c in ("specialType", "propertyType", "addition"):
        print(f"Const [{i}] = {c}")
