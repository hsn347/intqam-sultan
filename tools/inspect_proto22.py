from disassemble_lua53 import Lua53Bytecode, disassemble_func

with open('game_file/src_bytecode/fgui/gcomponent/CommonNew/heroSelectBanner.lua', 'rb') as f:
    data = f.read()

bc = Lua53Bytecode(data)
bc.parse_header()
fn = bc.parse_function()
p22 = fn['prototypes'][22]
print("\n".join(disassemble_func(p22)))
