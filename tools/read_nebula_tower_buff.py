with open(r"E:\intqam-sultan\game_file\src\app\module\nebulaWar\nebulaActivityCtrl.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines):
    if "getNebulaTowerBuffEffect" in line:
        for j in range(max(0, idx-2), min(len(lines), idx+30)):
            print(f"{j+1}: {lines[j]}")
        break
