path = r"E:\intqam-sultan\game_file\src\fgui\views\troopFlagView\WorldDispatchArmyViewPanel.lua"

with open(path, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

def print_range(start, end):
    print(f"=== Lines {start} to {end} ===")
    for i in range(start-1, min(end, len(lines))):
        print(f"{i+1}: {lines[i]}", end="")

print_range(145, 170)
print_range(720, 750)
print_range(1815, 1865)
