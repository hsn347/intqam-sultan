with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\vipbuff.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "level =" in l or "troop" in l or "limit" in l:
        print(f"{i+1}: {l.strip()}")
