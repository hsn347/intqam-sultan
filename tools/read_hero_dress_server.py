with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\hero_dress_server.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()
print("hero_dress_server length:", len(content))
print(content[:2000])
