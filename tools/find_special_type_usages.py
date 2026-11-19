# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tools.parse_lua53_proto import parse_lua53

filepath = r"game_file\src\app\localtb\config_server\equipment_base_property_config.lua"
data = open(filepath, "rb").read()
p = parse_lua53(data)

code = p['code']
consts = p['consts']
# find all instructions setting specialType (const 30)
special_ins = []
for pc, ins in enumerate(code):
    op = ins & 0x3F
    c = (ins >> 14) & 0x1FF
    b = (ins >> 23) & 0x1FF
    # SETTABLE or SETTABUP
    if (c & 0x100) and (c & 0xFF) == 30:
        special_ins.append(pc)
    elif (b & 0x100) and (b & 0xFF) == 30:
        special_ins.append(pc)

print(f"Total instructions referencing specialType: {len(special_ins)}")
# Let's inspect context around these instructions
for pc in special_ins[:10]:
    print(f"--- PC {pc} ---")
    for j in range(max(0, pc-10), min(len(code), pc+10)):
        ins = code[j]
        op = ins & 0x3F
        bx = (ins >> 14) & 0x3FFFF
        c = (ins >> 14) & 0x1FF
        b = (ins >> 23) & 0x1FF
        def rk(val):
            if val & 0x100 and (val & 0xFF) < len(consts):
                return repr(consts[val & 0xFF])
            return str(val)
        print(f"  [{j:05d}] op={op} B={rk(b)} C={rk(c)} Bx={bx}")
