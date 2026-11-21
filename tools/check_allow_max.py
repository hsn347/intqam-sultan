with open("game_file/src/fgui/views/troopFlagView/WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if "allowMaxCount" in line:
            print(f"Line {i+1}: {line.strip()}")
