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

print("=== DISASSEMBLY OF PROTO 125 (getHeroPalaceBuff) ===")
print("\n".join(disassemble_func(proto['prototypes'][125])))

print("\n=== DISASSEMBLY OF PROTO 124 (getHeroPalaceLevel) ===")
print("\n".join(disassemble_func(proto['prototypes'][124])))
