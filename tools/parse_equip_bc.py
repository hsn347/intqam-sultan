# -*- coding: utf-8 -*-
import sys, os
sys.path.insert(0, os.getcwd())
from tools.disassemble_lua53 import Lua53Bytecode

with open('game_file/src/app/localtb/config_server/equipment_base_property_config.lua', 'rb') as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
fn = bc.parse_function('root')
code = fn['code']
consts = fn['constants']

# In Lua bytecode table constructors or setters:
# Let's track when a table is created and fields are set
# Each row has 'equipmentID'
# Let's inspect instructions 1470 to 1510
print('=== Instructions 1470 - 1500 ===')
for pc in range(1470, 1505):
    inst = code[pc]
    op = inst & 0x3F
    a = (inst >> 6) & 0xFF
    c = (inst >> 14) & 0x1FF
    b = (inst >> 23) & 0x1FF
    bx = (inst >> 14) & 0x3FFFF
    opname = Lua53Bytecode.OPNAMES[op] if op < len(Lua53Bytecode.OPNAMES) else str(op)
    def rk(val):
        if val & 0x100:
            idx = val & 0xFF
            return f"K({repr(consts[idx]) if idx < len(consts) else idx})"
        return f"R({val})"
    if opname == 'LOADK':
        print(f"[{pc:04d}] LOADK R({a}) = {repr(consts[bx]) if bx < len(consts) else bx}")
    elif opname in ('SETTABLE', 'SETTABUP'):
        print(f"[{pc:04d}] {opname} A={a} {rk(b)} = {rk(c)}")
    else:
        print(f"[{pc:04d}] {opname} A={a} B={b} C={c} Bx={bx}")
