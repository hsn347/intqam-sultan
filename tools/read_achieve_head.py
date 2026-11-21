with open(r"E:\intqam-sultan\game_file\src\app\module\achievement\achievementctrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx in range(min(90, len(lines))):
    print(f"{idx+1}: {lines[idx]}")
