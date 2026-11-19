with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\achievement_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for l in lines[:30]:
    print(l, end="")
