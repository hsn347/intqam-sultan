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
        ktype = ord(read_bytes(1))
        if ktype == 0: # NIL
            consts.append(None)
        elif ktype == 1: # BOOLEAN
            consts.append(ord(read_bytes(1)) != 0)
        elif ktype == 3: # FLOAT
            consts.append(struct.unpack('<d', read_bytes(8))[0])
        elif ktype == 0x13: # INT
            consts.append(struct.unpack('<q', read_bytes(8))[0])
        elif ktype in (4, 0x14): # STRING
            consts.append(read_str())
        else:
            raise ValueError(f"Unknown ktype {ktype}")
            
    n_upvals = struct.unpack('<I', read_bytes(4))[0]
    upvals = []
    for _ in range(n_upvals):
        instack = ord(read_bytes(1))
        idx = ord(read_bytes(1))
        upvals.append((instack, idx))
        
    n_protos = struct.unpack('<I', read_bytes(4))[0]
    protos = [parse_proto(depth+1) for _ in range(n_protos)]
    
    n_lines = struct.unpack('<I', read_bytes(4))[0]
    lines = [struct.unpack('<I', read_bytes(4))[0] for _ in range(n_lines)]
    
    n_locs = struct.unpack('<I', read_bytes(4))[0]
    locs = []
    for _ in range(n_locs):
        varname = read_str()
        startpc = struct.unpack('<I', read_bytes(4))[0]
        endpc = struct.unpack('<I', read_bytes(4))[0]
        locs.append((varname, startpc, endpc))
        
    n_upval_names = struct.unpack('<I', read_bytes(4))[0]
    upval_names = [read_str() for _ in range(n_upval_names)]
    
    return {
        'source': source,
        'line1': line1,
        'line2': line2,
        'numparams': numparams,
        'is_vararg': is_vararg,
        'maxstack': maxstack,
        'consts': consts,
        'upvals': upvals,
        'protos': protos,
        'locs': locs,
        'code': code,
        'upval_names': upval_names
    }

main_proto = parse_proto()

OPCODES = [
    "MOVE", "LOADK", "LOADKX", "LOADBOOL", "LOADNIL", "GETUPVAL", "GETTABUP", "GETTABLE",
    "SETTABUP", "SETUPVAL", "SETTABLE", "NEWTABLE", "SELF", "ADD", "SUB", "MUL", "MOD",
    "POW", "DIV", "IDIV", "BAND", "BOR", "BXOR", "SHL", "SHR", "UNM", "BNOT", "NOT",
    "LEN", "CONCAT", "JMP", "EQ", "LT", "LE", "TEST", "TESTSET", "CALL", "TAILCALL",
    "RETURN", "FORLOOP", "FORPREP", "TFORCALL", "TFORLOOP", "SETLIST", "CLOSURE", "VARARG",
    "EXTRAARG"
]

def disassemble(p):
    code = p['code']
    consts = p['consts']
    
    def rk(val):
        if val & 0x100:
            kidx = val & 0xFF
            if kidx < len(consts):
                return f"K({repr(consts[kidx])})"
            return f"K({kidx})"
        return f"R({val})"
        
    lines = []
    for pc, ins in enumerate(code):
        op = ins & 0x3F
        a = (ins >> 6) & 0xFF
        c = (ins >> 14) & 0x1FF
        b = (ins >> 23) & 0x1FF
        bx = (ins >> 14) & 0x3FFFF
        sbx = bx - 131071
        ax = ins >> 6
        opname = OPCODES[op] if op < len(OPCODES) else f"OP_{op}"
        
        desc = ""
        if opname == "GETTABUP":
            desc = f"R({a}) = Up[{b}][{rk(c)}]"
        elif opname == "SETTABUP":
            desc = f"Up[{a}][{rk(b)}] = {rk(c)}"
        elif opname == "LOADK":
            k = consts[bx] if bx < len(consts) else f"const_{bx}"
            desc = f"R({a}) = {repr(k)}"
        elif opname == "LOADKX":
            extra = code[pc+1] >> 6 if pc+1 < len(code) else 0
            k = consts[extra] if extra < len(consts) else f"const_{extra}"
            desc = f"R({a}) = {repr(k)} (via extra={extra})"
        elif opname == "EXTRAARG":
            desc = f"extra={ax}"
        elif opname == "LOADBOOL":
            desc = f"R({a}) = {bool(b)}"
        elif opname == "GETTABLE":
            desc = f"R({a}) = R({b})[{rk(c)}]"
        elif opname == "SETTABLE":
            desc = f"R({a})[{rk(b)}] = {rk(c)}"
        elif opname == "SELF":
            desc = f"R({a+1}) = R({b}); R({a}) = R({b})[{rk(c)}]"
        elif opname == "CALL":
            desc = f"R({a})...({b-1} args, {c-1} rets)"
        elif opname == "MOVE":
            desc = f"R({a}) = R({b})"
        elif opname == "SUB":
            desc = f"R({a}) = {rk(b)} - {rk(c)}"
        elif opname == "ADD":
            desc = f"R({a}) = {rk(b)} + {rk(c)}"
        elif opname == "LEN":
            desc = f"R({a}) = #{rk(b)}"
        elif opname in ("JMP", "FORPREP", "FORLOOP"):
            desc = f"jump to pc={pc + 1 + sbx}"
        elif opname == "EQ":
            desc = f"if ({rk(b)} == {rk(c)}) != {a} jump next"
        elif opname == "LT":
            desc = f"if ({rk(b)} < {rk(c)}) != {a} jump next"
        elif opname == "LE":
            desc = f"if ({rk(b)} <= {rk(c)}) != {a} jump next"
        elif opname == "TEST":
            desc = f"if not R({a}) == {c} jump next"
        elif opname == "TFORCALL":
            desc = f"R({a+3})...R({a+2+c}) = R({a})(R({a+1}), R({a+2}))"
        elif opname == "TFORLOOP":
            desc = f"if R({a+1}) ~= nil then R({a}) = R({a+1}); jump to pc={pc + 1 + sbx}"
            
        lines.append(f"[{pc:03d}] {opname:<10} A={a:<3} B={b:<3} C={c:<3} ; {desc}")
    return "\n".join(lines)

for idx in [5, 8]:
    p = main_proto['protos'][idx]
    print(f"=== PROTO {idx} (params={p['numparams']}, lines={p['line1']}-{p['line2']}) ===")
    print("Consts:", p['consts'])
    print("Locs:", [x[0] for x in p['locs']])
    print(disassemble(p))
    print()
