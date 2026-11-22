with open("game_file/src/fgui/views/troopFlagView/WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8") as f:
    lines = f.readlines()

print("=== LINES 140 to 180 ===")
for i in range(139, min(len(lines), 180)):
    print(f"{i+1}: {lines[i]}", end="")

print("\n=== LINES 1815 to 1860 ===")
for i in range(1814, min(len(lines), 1860)):
    print(f"{i+1}: {lines[i]}", end="")
