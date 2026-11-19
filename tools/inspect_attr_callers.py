files = [
    r"e:\intqam-sultan\game_file\src\app\module\dress\dressMgr.lua",
    r"e:\intqam-sultan\game_file\src\app\module\equipment\equipmentCell.lua",
    r"e:\intqam-sultan\game_file\src\app\module\equipment\godArmsCtrl.lua",
    r"e:\intqam-sultan\game_file\src\app\module\world\talentSkillCtrl.lua",
]

for fpath in files:
    print(f"=== {fpath} ===")
    with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
        lines = fp.readlines()
    for i, line in enumerate(lines):
        if "attributeSystem" in line or "DISPATCH_TROOP_COUNT_NUM" in line:
            print(f"  Line {i+1}: {line.strip()[:100]}")
