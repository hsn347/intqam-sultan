with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx in range(620, 680):
    print(f"{idx+1}: {lines[idx]}")
