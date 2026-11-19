with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build121.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("level = 27")
if idx != -1:
    print(content[idx-50:idx+300])
else:
    print("level 27 not found")
