with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build101.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("blv = nil, 40")
if idx == -1:
    idx = content.find("blv = 40")
if idx != -1:
    print(content[idx-50:idx+600])
else:
    print("Level 40 not found in build101")
