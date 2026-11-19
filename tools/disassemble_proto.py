# -*- coding: utf-8 -*-
import struct
import sys
import os

filepath = r"game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua"

with open(filepath, "rb") as f:
    data = f.read()

pos = 0

def read_bytes(n):
    global pos
    b = data[pos:pos+n]
    pos += n
    return b

def read_str():
    global pos
    if pos >= len(data):
        return ""
    b0 = data[pos]
    pos += 1
    if b0 == 0:
        return ""
    elif b0 == 0xFF:
        sz = struct.unpack('<Q', read_bytes(8))[0]
    else:
        sz = b0
    s = data[pos:pos+sz-1]
    pos += sz - 1
    return s.decode('utf-8', errors='ignore')

hdr = read_bytes(34)
nups = ord(read_bytes(1))

def parse_proto(depth=0):
    global pos
    source = read_str()
    line1 = struct.unpack('<I', read_bytes(4))[0]
    line2 = struct.unpack('<I', read_bytes(4))[0]
    numparams = ord(read_bytes(1))
    is_vararg = ord(read_bytes(1))
    maxstack = ord(read_bytes(1))
    
    n_code = struct.unpack('<I', read_bytes(4))[0]
    code = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_code)]
    
    n_const = struct.unpack('<I', read_bytes(4))[0]
    consts = []
    for _ in range(n_const):
        tag = ord(read_bytes(1))
        if tag == 0:
            consts.append(None)
        elif tag == 1:
            consts.append(ord(read_bytes(1)) != 0)
        elif tag == 3:
            consts.append(struct.unpack('<d', read_bytes(8))[0])
        elif tag == 0x13:
            consts.append(struct.unpack('<q', read_bytes(8))[0])
        elif tag in (4, 0x14):
            consts.append(read_str())
            
    n_upval = struct.unpack('<I', read_bytes(4))[0]
    upvals = []
    for _ in range(n_upval):
        instack = ord(read_bytes(1))
        idx = ord(read_bytes(1))
        upvals.append((instack, idx))
        
    n_protos = struct.unpack('<I', read_bytes(4))[0]
    protos = []
    for _ in range(n_protos):
        protos.append(parse_proto(depth + 1))
        
    n_lines = struct.unpack('<I', read_bytes(4))[0]
    lines = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_lines)]
    
    n_loc = struct.unpack('<I', read_bytes(4))[0]
    locs = []
    for _ in range(n_loc):
        vname = read_str()
        s_pc = struct.unpack('<I', read_bytes(4))[0]
        e_pc = struct.unpack('<I', read_bytes(4))[0]
        locs.append((vname, s_pc, e_pc))
        
    n_upval_names = struct.unpack('<I', read_bytes(4))[0]
    upval_names = [read_str() for _ in range(n_upval_names)]
    
    return {
        'source': source,
        'lines': (line1, line2),
        'params': numparams,
        'consts': consts,
        'upvals': upvals,
        'protos': protos,
        'locs': locs,
        'code': code,
        'upval_names': upval_names
    }

if __name__ == '__main__':
    data = None
    # Can test here if executed directly

