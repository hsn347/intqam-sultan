with open(r"e:\intqam-sultan\game_file\src\fgui\views\troopFlagView\WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()

for i, l in enumerate(lines):
    if "nodeHero" in l or "exportHeros" in l or "exportLieutenantHeros" in l:
        print(f"{i+1}: {l.strip()[:100]}")
