with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\technology.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("24021")
if idx != -1:
    print(content[idx-100:idx+300])
else:
    print("24021 not found")
