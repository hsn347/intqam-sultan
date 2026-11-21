with open(r"E:\intqam-sultan\game_file\src\app\constdef\buffDef.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines[700:], 701):
    if "gBuffSource" in line or "gBuffSource_ros" in line or "gBuffSource_koh" in line or "SoraDMergeDefineTable" in line:
        print(f"{idx}: {line}")
