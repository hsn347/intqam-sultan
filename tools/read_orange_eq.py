with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\forge_equipment_orange.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

idx = content.find("6304501")
if idx != -1:
    print(content[idx-100:idx+400])
else:
    print("not found")
