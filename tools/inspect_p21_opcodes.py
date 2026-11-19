from tools.disassemble_lua53 import Lua53Bytecode

with open(r'e:\intqam-sultan\game_file\src_bytecode\fgui\gcomponent\CommonNew\heroSelectBanner.lua', 'rb') as f:
    bc = Lua53Bytecode(f.read())
bc.parse_header()
root = bc.parse_function()
p21 = root['prototypes'][21]

print("Constants of Proto 21:")
for idx, c in enumerate(p21['constants']):
    print(f"  [{idx}] = {repr(c)}")

print("\nOpcodes 110 to 135:")
for pc in range(110, 135):
    inst = p21['code'][pc]
    op = inst & 0x3F
    a = (inst >> 6) & 0xFF
    c = (inst >> 14) & 0x1FF
    b = (inst >> 23) & 0x1FF
    bx = (inst >> 14) & 0x3FFFF
    sbx = bx - 131071
    print(f"[{pc:03d}] op={op} ({Lua53Bytecode.OPNAMES[op]}) A={a} B={b} C={c} Bx={bx} sBx={sbx}")
