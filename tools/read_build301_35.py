with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\build301.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

print("Length of build301.lua:", len(content))
idx = content.find("blv = 35")
if idx == -1:
    idx = content.find("35")
if idx != -1:
    print(content[idx-50:idx+400])
else:
    print("Not found")
