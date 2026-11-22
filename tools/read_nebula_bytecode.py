with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

idx = data.find(b"getNebulaTowerBuffEffect")
if idx != -1:
    # search around for strings or bytecode constants
    chunk = data[max(0, idx-500):idx+1500]
    # find ascii strings in chunk
    import re
    strings = re.findall(b"[a-zA-Z_0-9]{3,}", chunk)
    print([s.decode('ascii', errors='ignore') for s in strings])
else:
    print("Not found")
