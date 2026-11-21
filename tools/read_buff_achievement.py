with open(r"E:\intqam-sultan\game_file\src\app\module\buff\buffCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for i, line in enumerate(text.splitlines()):
    if "gBuffSource.ACHIEVEMENT" in line or "achievementctrl" in line.lower():
        print(f"{i+1}: {line}")
