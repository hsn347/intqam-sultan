with open(r"E:\intqam-sultan\game_file\src\fgui\views\troopFlagView\WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

lines = text.splitlines()
for idx, line in enumerate(lines):
    if "getExpArmyCount" in line or "maxArmy" in line or "armyMax" in line or "maxTroop" in line or "capacity" in line:
        for j in range(max(0, idx-5), min(len(lines), idx+15)):
            print(f"{j+1}: {lines[j]}")
        print("="*40)
