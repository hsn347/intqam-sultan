path = r"E:\intqam-sultan\game_file\src\app\module\technology\technologyCtrl.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "function technologyctrl:gettechnologypower" in line.lower():
        print(f"Found on line {i+1}: {line}")
        for j in range(i, min(i+40, len(lines))):
            print(f"{j+1}: {lines[j]}", end="")
        break
