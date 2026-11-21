with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
start = False
for idx, line in enumerate(lines):
    if "gBuffSource" in line:
        for j in range(max(0, idx-5), min(len(lines), idx+60)):
            print(f"{j+1}: {lines[j]}")
        break
