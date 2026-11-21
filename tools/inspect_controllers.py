import os

files = {
    "nebula": r"e:\intqam-sultan\game_file\src\app\module\nebulaWar\nebulaActivityCtrl.lua",
    "hegemon": r"e:\intqam-sultan\game_file\src\app\module\legendLordWarCtrl\hegemonCtrl.lua",
    "legendLord": r"e:\intqam-sultan\game_file\src\app\module\legendLordWarCtrl\legendLordCtrl.lua",
    "intetior": r"e:\intqam-sultan\game_file\src\app\module\intetior\intetiorCtrl.lua",
    "godArmsRune": r"e:\intqam-sultan\game_file\src\app\module\equipment\godArmsRuneCtrl.lua",
    "lordSkill": r"e:\intqam-sultan\game_file\src\app\module\lordSkill\lordSkillCtrl.lua",
    "divineBeast": r"e:\intqam-sultan\game_file\src\app\module\divineBeast\divineBeastCtrl.lua",
    "pet": r"e:\intqam-sultan\game_file\src\app\module\pet\petCtrl.lua",
    "allianceScience": r"e:\intqam-sultan\game_file\src\app\module\alliance\allianceScience.lua",
}

for name, p in files.items():
    if os.path.exists(p):
        with open(p, "r", encoding="utf-8", errors="ignore") as f:
            lines = f.readlines()
        print(f"\n=================== {name} ({len(lines)} lines) ===================")
        for i, l in enumerate(lines):
            if any(k in l for k in ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "getNebulaTowerBuffEffect", "getRuneBuff", "getDispatchAddCount", "getPetAttributeAdd", "getBuff", "getBuffEffect"]):
                print(f"  Line {i+1}: {l.strip()[:110]}")
