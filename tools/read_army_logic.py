with open(r"E:\intqam-sultan\game_file\src\app\module\army\armyLogic.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

print("Length of armyLogic.lua:", len(text))
for line in text.splitlines():
    if any(k in line.lower() for k in ["max", "troop", "capacity", "limit", "num", "hero", "build", "buff"]):
        print(line[:120])
