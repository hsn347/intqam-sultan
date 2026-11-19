from tools.disassemble_lua53 import Lua53Bytecode, disassemble_func

with open(r'e:\intqam-sultan\game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua', 'rb') as f:
    bc = Lua53Bytecode(f.read())
bc.parse_header()
root = bc.parse_function()

# In root, opcodes:
# CLOSURE R(x) proto=N
# SETTABLE or SETTABUP or LOADKX R(target) R(val) K(method_name)
method_map = {}
for i, inst in enumerate(root['code']):
    op = inst & 0x3F
    a = (inst >> 6) & 0xFF
    bx = (inst >> 14) & 0x3FFFF
    if op == 44: # CLOSURE
        proto_idx = bx
        # next instruction might be SETTABLE
        if i + 1 < len(root['code']):
            next_inst = root['code'][i+1]
            next_op = next_inst & 0x3F
            c = (next_inst >> 14) & 0x1FF
            b = (next_inst >> 23) & 0x1FF
            k_name = None
            if c & 0x100 and (c & 0xFF) < len(root['constants']):
                k_name = root['constants'][c & 0xFF]
            elif b & 0x100 and (b & 0xFF) < len(root['constants']):
                k_name = root['constants'][b & 0xFF]
            method_map[proto_idx] = (k_name, next_op, root['prototypes'][proto_idx]['line_defined'], root['prototypes'][proto_idx]['last_line_defined'])

print("Proto mappings:")
for proto_idx in sorted(method_map.keys()):
    info = method_map[proto_idx]
    fn = root['prototypes'][proto_idx]
    locs = [lv[0] for lv in fn['locvars']]
    consts = [c for c in fn['constants'] if isinstance(c, str)]
    print(f"Proto {proto_idx:2d}: lines {info[2]}-{info[3]} | key={info[0]} | locs={locs[:6]} | consts={consts[:6]}")
