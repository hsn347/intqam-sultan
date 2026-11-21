with open("game_file/src/app/localtb/config_server/achievement_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for line in lines[:50]:
    print(line, end="")
