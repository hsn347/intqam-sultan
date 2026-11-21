# -*- coding: utf-8 -*-
import sys
sys.path.insert(0, '.')
from tools.parse_lua53_proto import parse_lua53

data = open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb').read()
root = parse_lua53(data)
p22 = root['protos'][22]

print("Constants in p22:", p22['consts'])
