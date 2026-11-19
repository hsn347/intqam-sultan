with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_read\militaryRankRead.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for l in content.splitlines():
    if "buff" in l.lower() or "march" in l.lower() or "capacity" in l.lower() or "troop" in l.lower():
        print(" ", l.strip()[:100])
