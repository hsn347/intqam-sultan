import struct
import sys

def parse_lua53(data):
    pos = 0
    def read_bytes(n):
        nonlocal pos
        b = data[pos:pos+n]
        pos += n
        return b
        
    def read_str():
        nonlocal pos
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

    # header
    hdr = read_bytes(34)
    # nups of main
    nups = ord(read_bytes(1))
    print(f"Header parsed, main nups={nups}")

    def parse_proto(depth=0):
        nonlocal pos
        source = read_str()
        line1 = struct.unpack('<I', read_bytes(4))[0]
        line2 = struct.unpack('<I', read_bytes(4))[0]
        numparams = ord(read_bytes(1))
        is_vararg = ord(read_bytes(1))
        maxstack = ord(read_bytes(1))
        
        # code
        n_code = struct.unpack('<I', read_bytes(4))[0]
        code = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_code)]
        
        # constants
        n_const = struct.unpack('<I', read_bytes(4))[0]
        consts = []
        for _ in range(n_const):
            tag = ord(read_bytes(1))
            if tag == 0:
                consts.append(None)
            elif tag == 1:
                consts.append(ord(read_bytes(1)) != 0)
            elif tag == 3: # float
                consts.append(struct.unpack('<d', read_bytes(8))[0])
            elif tag == 0x13: # integer
                consts.append(struct.unpack('<q', read_bytes(8))[0])
            elif tag in (4, 0x14): # string
                consts.append(read_str())
            else:
                raise ValueError(f"Unknown const tag {tag} at depth {depth}, pos={pos}")
                
        # upvalues
        n_upval = struct.unpack('<I', read_bytes(4))[0]
        upvals = []
        for _ in range(n_upval):
            instack = ord(read_bytes(1))
            idx = ord(read_bytes(1))
            upvals.append((instack, idx))
            
        # protos
        n_protos = struct.unpack('<I', read_bytes(4))[0]
        protos = []
        for _ in range(n_protos):
            protos.append(parse_proto(depth + 1))
            
        # lineinfo
        n_lines = struct.unpack('<I', read_bytes(4))[0]
        lines = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_lines)]
        
        # locvars
        n_loc = struct.unpack('<I', read_bytes(4))[0]
        locs = []
        for _ in range(n_loc):
            vname = read_str()
            s_pc = struct.unpack('<I', read_bytes(4))[0]
            e_pc = struct.unpack('<I', read_bytes(4))[0]
            locs.append((vname, s_pc, e_pc))
            
        # upval names
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

    return parse_proto()

if __name__ == '__main__':
    with open('e:/intqam-sultan/game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
        data = f.read()
    main_proto = parse_lua53(data)
    print("Parsed main proto successfully!")
    print(f"Num protos in main: {len(main_proto['protos'])}")
    for i, p in enumerate(main_proto['protos']):
        strs = [c for c in p['consts'] if isinstance(c, str)]
        print(f"Proto {i}: lines={p['lines']}, locs={[l[0] for l in p['locs']]}, consts={strs[:10]}")
