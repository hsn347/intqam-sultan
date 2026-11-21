with open(r"E:\intqam-sultan\game_file\src\app\module\achievement\achievementctrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

for i, line in enumerate(text.splitlines()):
    if "function achievementctrl:getbuffvalue" in line.lower():
        print(f"Found on line {i+1}: {line}")
        for j in range(i, min(i+40, len(text.splitlines()))):
            print(f"{j+1}: {text.splitlines()[j]}")
        break
