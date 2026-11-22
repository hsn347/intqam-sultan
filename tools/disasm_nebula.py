import re

with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# Let's search for occurrences of 'Tower' or 'getNebulaTowerBuffEffect'
pattern = b"getNebulaTowerBuffEffect"
for m in re.finditer(pattern, data):
    start = max(0, m.start() - 200)
    end = min(len(data), m.end() + 300)
    print("Match at", m.start())
    # print strings
    chunk = data[start:end]
    clean_strs = re.findall(rb"[A-Za-z0-9_]{3,}", chunk)
    print("Strings nearby:", [s.decode('latin1', errors='ignore') for s in clean_strs])
