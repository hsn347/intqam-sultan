import re

with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# Let's search for 'getNebulaTowerBuffEffect'
pattern = b"getNebulaTowerBuffEffect"
matches = [m.start() for m in re.finditer(pattern, data)]
print("Matches for getNebulaTowerBuffEffect:", matches)

for pos in matches:
    print(f"--- Chunk around {pos} ---")
    chunk = data[max(0, pos-100):min(len(data), pos+300)]
    print(chunk)
