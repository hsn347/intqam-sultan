with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

idx = 0
matches = []
while True:
    pos = data.find(b"getNebulaTowerBuffEffect", idx)
    if pos == -1:
        break
    matches.append(pos)
    idx = pos + 1

print("Matches at offsets:", matches)

# For each match, print surrounding 200 bytes in hex/ascii
for m in matches:
    chunk = data[max(0, m-50):m+250]
    print(f"\nOffset {m}:")
    print(" ".join(f"{b:02x}" for b in chunk[:60]))
