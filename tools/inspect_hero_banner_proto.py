# -*- coding: utf-8 -*-
import struct
import sys
import os

filepath = r"game_file\src_bytecode\app\game\heroView\heroSelect\heroSelectBanner.lua"
if not os.path.exists(filepath):
    print("Not found:", filepath)
    sys.exit(1)

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

# header: 30 bytes
hdr = read_bytes(30)
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
            b = ord(read_bytes(1))
            consts.append(bool(b))
        elif tag == 3: # float / int
            v = struct.unpack('<q', read_bytes(8))[0]
            consts.append(v)
        elif tag == 0x13: # integer
            v = struct.unpack('<q', read_bytes(8))[0]
            consts.append(v)
        elif tag == 4 or tag == 0x14: # short / long string
            s = read_str()
            consts.append(s)
        else:
            consts.append(f"tag_{tag}")
            
    n_upval = struct.unpack('<I', read_bytes(4))[0]
    upvals = []
    for _ in range(n_upval):
        instack = ord(read_bytes(1))
        idx = ord(read_bytes(1))
        upvals.append((instack, idx))
        
    n_proto = struct.unpack('<I', read_bytes(4))[0]
    protos = []
    for _ in range(n_proto):
        protos.append(parse_proto(depth+1))
        
    # debug info
    n_lineinfo = struct.unpack('<I', read_bytes(4))[0]
    lineinfo = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_lineinfo)]
    
    n_locvars = struct.unpack('<I', read_bytes(4))[0]
    locvars = []
    for _ in range(n_locvars):
        varname = read_str()
        startpc = struct.unpack('<I', read_bytes(4))[0]
        endpc = struct.unpack('<I', read_bytes(4))[0]
        locvars.append((varname, startpc, endpc))
        
    n_upvalnames = struct.unpack('<I', read_bytes(4))[0]
    upvalnames = [read_str() for _ in range(n_upvalnames)]
    
    return {
        "source": source,
        "line1": line1,
        "line2": line2,
        "numparams": numparams,
        "consts": consts,
        "locvars": locvars,
        "protos": protos,
    }

top_proto = parse_proto()

def print_proto(p, path=""):
    c_str = [str(c) for c in p['consts'] if isinstance(c, str)]
    vars = [v[0] for v in p['locvars']]
    print(f"Proto {path} lines {p['line1']}-{p['line2']}: params={p['numparams']}")
    print(f"  consts: {c_str[:15]}")
    print(f"  locvars: {vars[:15]}")
    for i, sub in enumerate(p['protos']):
        print_proto(sub, f"{path}/{i}")

print_proto(top_proto)
