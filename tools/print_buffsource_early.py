with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines[:704], 1):
    if "gBuffSource" in line or "CITY" in line or "NEWBIE" in line:
        print(f"{idx}: {line}")
