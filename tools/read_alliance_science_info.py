with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\alliance_science_info.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for l in content.splitlines():
    if "buff" in l.lower() or "19" in l or "96" in l:
        print(" ", l.strip()[:100])
