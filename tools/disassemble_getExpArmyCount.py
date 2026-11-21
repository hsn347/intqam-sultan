# -*- coding: utf-8 -*-
import sys
sys.path.insert(0, '.')
from tools.parse_lua53_proto import parse_lua53

data = open('game_file/src_bytecode/app/module/city/buildLogic.lua', 'rb').read()
p = parse_lua53(data)

# OPCODES for Lua 5.3
OPNAMES = [
    "MOVE", "LOADK", "LOADKX", "LOADBOOL", "LOADNIL", "GETUPVAL",
    "GETTABUP", "GETTABLE", "SETTABUP", "SETUPVAL", "SETTABLE",
    "NEWTABLE", "SELF", "ADD", "SUB", "MUL", "MOD", "POW",
    "DIV", "IDIV", "BAND", "BOR", "BXOR", "SHL", "SHR",
    "UNM", "BNOT", "NOT", "LEN", "CONCAT", "JMP", "EQ",
    "LT", "LE", "TEST", "TESTSET", "CALL", "TAILCALL", "RETURN",
    "FORLOOP", "FORPREP", "TFORCALL", "TFORLOOP", "SETLIST", "CLOSURE",
    "VARARG", "EXTRAARG"
]

def disassemble(proto):
    code = proto['code']
    consts = proto['consts']
    lines = proto.get('lines', [])
    print(f"Num instructions: {len(code)}")
    for pc, inst in enumerate(code):
        op = inst & 0x3F
        opname = OPNAMES[op] if op < len(OPNAMES) else f"OP_{op}"
        a = (inst >> 6) & 0xFF
        c = (inst >> 14) & 0x1FF
        b = (inst >> 23) & 0x1FF
        bx = (inst >> 14) & 0x3FFFF
        sbx = bx - 131071
        
        def k_or_r(val):
            if val & 0x100:
                kidx = val & 0xFF
                kval = consts[kidx] if kidx < len(consts) else f"K[{kidx}]"
                return f"K({kval})"
            return f"R({val})"
        
        extra = ""
        if opname in ["GETTABUP", "SETTABUP"]:
            extra = f"R({a}), Up[{b}], {k_or_r(c)}"
        elif opname in ["GETTABLE", "SETTABLE"]:
            extra = f"R({a}), R({b}), {k_or_r(c)}"
        elif opname == "LOADK":
            kval = consts[bx] if bx < len(consts) else f"K[{bx}]"
            extra = f"R({a}), K({kval})"
        elif opname in ["ADD", "SUB", "MUL", "DIV", "IDIV"]:
            extra = f"R({a}), {k_or_r(b)}, {k_or_r(c)}"
        elif opname == "CALL":
            extra = f"R({a}), {b-1} args, {c-1} rets"
        elif opname == "RETURN":
            extra = f"R({a}), {b-1} rets"
        elif opname == "MOVE":
            extra = f"R({a}), R({b})"
        elif opname == "JMP":
            extra = f"R({a}), pc -> {pc + 1 + sbx}"
        else:
            extra = f"A={a}, B={b}, C={c}, Bx={bx}, sBx={sbx}"
        
        line = lines[pc] if pc < len(lines) else "?"
        print(f"[{pc:3d}] (L{line}) {opname:10s} {extra}")

for proto in p['protos']:
    consts = proto.get('consts', [])
    if 'DEFAULT_EXP_ARMY_COUNT' in consts and len(proto.get('code', [])) == 160:
        disassemble(proto)
        break
