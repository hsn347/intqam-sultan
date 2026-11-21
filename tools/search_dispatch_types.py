import re

with open("game_file/src/fgui/views/troopFlagView/WorldDispatchArmyViewPanel.lua", "r", encoding="utf-8") as f:
    text = f.read()

keywords = ["gather", "res", "collect", "load", "weight", "limit", "allowMaxCount", "occupy"]
for kw in ["gMapMoveLineServerType", "allowMaxCount", "load", "weight"]:
    matches = re.findall(rf".{{0,50}}{kw}.{{0,50}}", text, re.IGNORECASE)
    print(f"=== Keyword: {kw} (count: {len(matches)}) ===")
    for m in matches[:10]:
        print("  ", m.strip().replace("\n", " "))
