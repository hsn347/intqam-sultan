import os

files_to_check = [
    'game_file/src/app/module/alliance/allianceCtrl.lua',
    'game_file/src/app/module/quest/questCtrl.lua',
    'game_file/src/app/module/walls/wallsCtrl.lua',
    'game_file/src/app/module/treviFountain/treviFountainCtrl.lua',
    'game_file/src/app/module/pyramid/pyramidCtrl.lua',
    'game_file/src/app/module/allianceTreasure/allianceTreasureCtrl.lua',
    'game_file/src/app/module/badgeExchange/badgeExchangeCtrl.lua',
]

for p in files_to_check:
    if not os.path.exists(p):
        print(f"NOT FOUND: {p}")
        continue
    print(f"\n=== {os.path.basename(p)} ===")
    with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
        lines = fp.readlines()
    for i, line in enumerate(lines):
        if 'notifyHandler' in line or 'onNotify' in line or ('notify' in line.lower() and 'function' in line):
            print(f"Line {i+1}: {line.strip()}")
            for j in range(i+1, min(i+20, len(lines))):
                print(f"  {lines[j].rstrip()}")
            break
