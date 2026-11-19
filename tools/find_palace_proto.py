# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tools.disassemble_lua53 import Lua53Bytecode, disassemble_func

path = r"e:\intqam-sultan\game_file\src_bytecode\app\module\hero\heroCtrl.lua"
with open(path, "rb") as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
proto = bc.parse_function()

# Find proto with 'getHeroPalaceBuff' or related
for i, sub in enumerate(proto['prototypes']):
    consts = [str(k) for k in sub['constants'] if isinstance(k, str)]
    if any("Palace" in c or "palace" in c for c in consts):
        print(f"Proto {i}: {consts[:10]}")
        print("\n".join(disassemble_func(sub)[:30]))
