from disassemble_lua53 import Lua53Bytecode, disassemble_func

with open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
fn = bc.parse_function()

for i, p in enumerate(fn['prototypes']):
    if 'stateList' in p['constants'] or any('stateList' in str(c) for c in p['constants']):
        print(f"Match stateList in proto {i}: constants={p['constants']}")
        print("".join(disassemble_func(p)))
