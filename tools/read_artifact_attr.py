with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\artifact_attributes_config.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("6100131")
if idx != -1:
    print(content[idx-50:idx+400])
else:
    print("6100131 not found in artifact_attributes_config")
