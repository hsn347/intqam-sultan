with open(r"e:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "MARCH_VALUE_LIMIT_BOOST" in l or "MARCH_LIMIT_BOOST" in l:
        print(f"{i+1}: {l.strip()}")
