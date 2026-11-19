# -*- coding: utf-8 -*-
import struct

def parse_lua_header(data):
    # Lua 5.3 header is 30 bytes
    return data[30:]

with open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
    raw = f.read()

# Let's inspect all strings in this bytecode file
import re
strings = re.findall(b'[\x20-\x7e]{3,}', raw)
print(f"Total ASCII strings in heroSelectBanner.lua: {len(strings)}")
for s in strings:
    s_str = s.decode('latin1')
    if any(k in s_str for k in ['hero', 'Hero', 'sort', 'auto', 'Fill', 'Site', 'site', 'open', 'Lieut', 'lieut', 'dress', 'rarity']):
        print('  ', s_str)
