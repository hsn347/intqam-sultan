# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tools.disassemble_lua53 import Lua53Bytecode, disassemble_func

path = r"e:\intqam-sultan\game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua"
with open(path, "rb") as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
proto = bc.parse_function()

p21 = proto['prototypes'][21]
full_text = disassemble_func(p21)
for line in full_text.splitlines():
    if any(f"[{i:03d}]" in line for i in range(50, 136)):
        print(line)
