import re

path = r"e:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua"
with open(path, 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

start_pos = text.find("function buffCtrl:getBuffEffectFromSource")
end_pos = text.find("function buffCtrl:getBuffEffectFromSourceNoAlliance", start_pos)
if end_pos == -1:
    end_pos = start_pos + 10000

func_text = text[start_pos:end_pos]
lines = func_text.splitlines()

branches = []
current_source = None

for line in lines:
    m = re.search(r'elseif\s+source\s*==\s*(\w+\.\w+)', line) or re.search(r'if\s+source\s*==\s*(\w+\.\w+)', line)
    if m:
        current_source = m.group(1)
        branches.append((current_source, []))
    elif current_source and len(branches) > 0:
        branches[-1][1].append(line.strip())

print(f"Total branches in getBuffEffectFromSource: {len(branches)}")
for src, blines in branches:
    bcode = " ".join(blines[:3])
    print(f"Source: {src:<35} | Code: {bcode[:70]}")
