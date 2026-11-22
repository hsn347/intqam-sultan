import re

with open("game_file/src_bytecode/app/module/nebulaWar/nebulaActivityCtrl.lua", "rb") as f:
    data = f.read()

# Let's find every occurrence of the string 'Tower' in the file
for m in re.finditer(rb"[^\x00]{4,}(?:Tower|tower)[^\x00]{0,30}", data):
    print(m.group())
