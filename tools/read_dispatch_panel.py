with open(r"e:\intqam-sultan\game_file\src\fgui\views\troopFlagView\WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i in range(145, 175):
    if i < len(lines):
        print(f"{i+1}: {lines[i]}", end="")

print("\n--- lines 1815-1870 ---")
for i in range(1815, 1870):
    if i < len(lines):
        print(f"{i+1}: {lines[i]}", end="")
