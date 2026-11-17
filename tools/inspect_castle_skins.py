import re

with open('game_file/src/app/localtb/config_client/castleskinconfig.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Pattern for types:
# ;(nil).type = 1\n;(nil).texture = "mainCitySkin_1" ...
types = re.findall(r'type\s*=\s*(\d+)', text)
mains = re.findall(r'main\s*=\s*"([^"]+)"', text)
remarks = re.findall(r'remark\s*=\s*nil,\s*nil,\s*"([^"]+)"', text)

print(f"Counts: types={len(types)}, mains={len(mains)}, remarks={len(remarks)}")
for i in range(min(len(types), len(mains), len(remarks))):
    print(f"Type {types[i]:>3}: main={mains[i]:<32} remark={remarks[i]}")
