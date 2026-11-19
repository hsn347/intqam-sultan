with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build301.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("(nil).blv = nil, 35")
if idx == -1:
    idx = content.find("blv = nil, 35")
print(content[idx:idx+1200])
