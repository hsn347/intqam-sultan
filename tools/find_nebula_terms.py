with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# In Lua bytecode, functions have string constants.
# Let's search for "nebulaTowerLvDesRead" or "queryBuffData" in the bytecode!
for term in [b"nebulaTowerLvDesRead", b"queryBuffData", b"towerData", b"isNebulaActivityOpen"]:
    pos = 0
    while True:
        pos = data.find(term, pos)
        if pos == -1: break
        print(f"Found {term.decode()} at {pos}")
        pos += len(term)
