with open(r"e:\intqam-sultan\game_file\src\app\module\pet\petCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

for l in content.splitlines():
    if "buff" in l.lower() or "march" in l.lower() or "dispatch" in l.lower() or "capacity" in l.lower():
        print(" ", l.strip()[:100])
