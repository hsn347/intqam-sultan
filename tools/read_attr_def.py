with open(r"e:\intqam-sultan\game_file\src\app\module\newBuff\attributeDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()
for i, l in enumerate(lines):
    if "DISPATCH_TROOP" in l or "DISPATCH" in l or "MARCH" in l or "ARMY" in l:
        print(f"{i+1}: {l.strip()}")
