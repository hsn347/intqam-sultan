with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\equipment_base_property_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()
for l in lines[:50]:
    print(l, end="")
