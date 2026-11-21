with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines):
    if "= 55" in line or " 55" in line:
        print(f"{idx+1}: {line}")
