# -*- coding: utf-8 -*-
import sys
sys.path.insert(0, '.')
from tools.parse_lua53_proto import parse_lua53

data = open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb').read()
root = parse_lua53(data)

def dump_all(proto, path="root"):
    consts = [str(c) for c in proto.get('consts', [])]
    for c in consts:
        if 'auto' in c.lower() or 'fill' in c.lower() or 'hero' in c.lower():
            print(f"{path}: const {c}")
    for i, p in enumerate(proto.get('protos', [])):
        dump_all(p, f"{path}->p[{i}]")

dump_all(root)
