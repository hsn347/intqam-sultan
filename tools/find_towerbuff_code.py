with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# Let's find all occurrences of "towerBuffList" or "getNebulaTowerBuffEffect"
pos = 0
while True:
    idx = data.find(b"towerBuffList", pos)
    if idx == -1:
        break
    print(f"Found towerBuffList at {idx}")
    print(data[max(0, idx-100):min(len(data), idx+150)])
    pos = idx + 1
