with open(r"E:\intqam-sultan\game_file\src\app\module\achievement\achievementctrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines):
    if "getBuffValue" in line:
        for j in range(max(0, idx-2), min(len(lines), idx+35)):
            print(f"{j+1}: {lines[j]}")
        break
