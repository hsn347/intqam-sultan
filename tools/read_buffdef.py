with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for line in text.splitlines():
    if "MARCH_VALUE_LIMIT_BOOST" in line or "MARCH_LIMIT_BOOST" in line or "gBuffSource" in line:
        print(line)
