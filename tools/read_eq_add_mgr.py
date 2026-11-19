with open(r"e:\intqam-sultan\game_file\src\app\module\equipment\equipmentAdditionMgr.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for l in content.splitlines():
    if "query" in l.lower() or "march" in l.lower() or "buff" in l.lower():
        print(" ", l.strip()[:100])
