# -*- coding: utf-8 -*-
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from tools.disassemble_lua53 import Lua53Bytecode

path = r"e:\intqam-sultan\game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua"
with open(path, "rb") as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
proto = bc.parse_function()

def print_proto(p, idx=0, name="root"):
    # constants strings
    strings = [str(k) for k in p['constants'] if isinstance(k, str)]
    print(f"Proto {idx} ({name}): params={p['num_params']}, consts={strings[:10]}")
    for i, sub in enumerate(p['prototypes']):
        # try find sub name from parent's instructions or constants
        print_proto(sub, i, f"{name}.sub{i}")

print_proto(proto)
