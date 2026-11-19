with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build101.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("blv = 40")
print(content[idx:idx+1000])
