import struct

OPCODES = [
    "MOVE", "LOADK", "LOADKX", "LOADBOOL", "LOADNIL", "GETUPVAL",
    "GETTABUP", "GETTABLE", "SETTABUP", "SETUPVAL", "SETTABLE",
    "NEWTABLE", "SELF", "ADD", "SUB", "MUL", "MOD", "POW",
    "DIV", "IDIV", "BAND", "BOR", "BXOR", "SHL", "SHR", "UNM",
    "BNOT", "NOT", "LEN", "CONCAT", "JMP", "EQ", "LT", "LE",
    "TEST", "TESTSET", "CALL", "TAILCALL", "RETURN", "FORLOOP",
    "FORPREP", "TFORCALL", "TFORLOOP", "SETLIST", "CLOSURE",
    "VARARG", "EXTRAARG"
]

def decode_ins(ins):
    op = ins & 0x3F
    opname = OPCODES[op] if op < len(OPCODES) else f"OP_{op}"
    a = (ins >> 6) & 0xFF
    c = (ins >> 14) & 0x1FF
    b = (ins >> 23) & 0x1FF
    bx = (ins >> 14) & 0x3FFFF
    sbx = bx - 131071
    return opname, a, b, c, bx, sbx

def rk(val, consts):
    if val >= 256:
        idx = val - 256
        if idx < len(consts):
            return f"K({repr(consts[idx])})"
        return f"K({idx})"
    return f"R({val})"

def disassemble(proto, consts, upval_names):
    code = proto['code']
    lines = proto['lines']
    print(f"=== Disassembly lines {lines} (len {len(code)}) ===")
    for pc, ins in enumerate(code):
        opname, a, b, c, bx, sbx = decode_ins(ins)
        extra = ""
        if opname in ("GETTABUP", "SETTABUP"):
            up = upval_names[b] if b < len(upval_names) else f"up_{b}"
            extra = f"R({a}) {up}[{rk(c, consts)}]"
        elif opname in ("GETTABLE", "SETTABLE"):
            extra = f"R({a}) R({b})[{rk(c, consts)}]"
        elif opname == "SELF":
            extra = f"R({a}) R({b}) : {rk(c, consts)}"
        elif opname == "LOADK":
            k = consts[bx] if bx < len(consts) else bx
            extra = f"R({a}) = {repr(k)}"
        elif opname in ("CALL", "TAILCALL"):
            extra = f"R({a})(args={b-1}, rets={c-1})"
        elif opname == "JMP":
            extra = f"-> {pc + 1 + sbx}"
        elif opname in ("EQ", "LT", "LE"):
            extra = f"{rk(b, consts)} vs {rk(c, consts)} (a={a}) -> jump next if cond"
        elif opname in ("FORLOOP", "FORPREP"):
            extra = f"R({a}) -> {pc + 1 + sbx}"
        elif opname in ("TFORCALL", "TFORLOOP"):
            extra = f"R({a}) -> {pc + 1 + sbx}"
        elif opname == "CLOSURE":
            extra = f"proto[{bx}]"
            
        print(f"  [{pc:3d}] {opname:10s} A={a:3d} B={b:3d} C={c:3d} Bx={bx:6d} sBx={sbx:6d}  | {extra}")

import os, sys
sys.path.append(os.path.dirname(__file__))
from parse_lua53_proto import parse_lua53

if __name__ == '__main__':
    with open('e:/intqam-sultan/game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
        data = f.read()
    main = parse_lua53(data)
    
    print("\n--- PROTO 21 (autoFillHeros) ---")
    p21 = main['protos'][21]
    disassemble(p21, p21['consts'], [u[0] for u in main['locs']])
    
    print("\n--- PROTO 27 (exportNewHeros) ---")
    p27 = main['protos'][27]
    disassemble(p27, p27['consts'], [u[0] for u in main['locs']])
