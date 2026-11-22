import struct

with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# Let's search for 'getNebulaTowerBuffEffect'
str_pos = data.find(b"getNebulaTowerBuffEffect")
print("str_pos:", str_pos)

# Let's inspect bytes around str_pos and see where the function prototype is
# In Lua 5.1 bytecode, header is 12 bytes: \x1bLua\x51...
print("Header:", data[:12])
