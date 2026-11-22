import struct

with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    raw = f.read()

# Let's search where the prototype names are assigned
# In Lua 5.1, the main chunk has a string table, instructions, constants, sub-prototypes
# Let's find all function names in the main chunk
# Let's see how many sub-prototypes are in the main chunk or disassemble them
def parse_string(data, offset):
    size = struct.unpack_from("<I", data, offset)[0]
    offset += 4
    if size == 0:
        return "", offset
    s = data[offset:offset+size-1] # without null terminator
    return s.decode('latin1', errors='ignore'), offset + size

print("Parsing started...")
