import os
import re

ctrl_dir = 'game_file/src/app/module'

allowed = [
    "cityCtrl", "lordInfoCtrl", "queueCtrl", "armyCtrl", "heroCtrl", "backpackCtrl",
    "mailCtrl", "vipCtrl", "allianceCtrl", "everydayTaskCtrl", "questCtrl", "buffCtrl",
    "wallsCtrl", "kingdomMapCtrl", "commandHallCtrl", "storesCtrl", "treviFountainCtrl",
    "salesRoomAgCtrl", "pyramidCtrl", "allianceTreasureCtrl", "badgeExchangeCtrl",
    "equipmentCtrl", "itemShop", "shopCtrl", "timeRewardCtrl"
]

results = {}

for root, dirs, files in os.walk(ctrl_dir):
    for f in files:
        if not f.endswith('.lua'):
            continue
        p = os.path.join(root, f)
        base = os.path.splitext(f)[0]
        try:
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                content = fp.read()
                matches = re.findall(r'gNotifyID\.(\w+)', content)
                if matches:
                    unique_matches = sorted(list(set(matches)))
                    results[base] = unique_matches
        except Exception:
            pass

print("=== Mappings for Allowed Controllers ===")
for ctrl in allowed:
    found = False
    for k, v in results.items():
        if k.lower() == ctrl.lower() or ctrl.lower() in k.lower():
            print(f"[{ctrl}] (file: {k}.lua) -> {v}")
            found = True
    if not found:
        print(f"[{ctrl}] -> NOT FOUND directly")
