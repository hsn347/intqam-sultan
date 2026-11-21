import os
import re

root = r"e:\intqam-sultan\game_file\src"

files_to_check = [
    r"app\module\buff\buffCtrl.lua",
    r"app\module\city\buildLogic.lua",
    r"app\module\pet\petCtrl.lua",
    r"app\module\equipment\equipmentAdditionMgr.lua",
    r"app\module\achievement\achievementctrl.lua",
    r"app\module\hegemon\hegemonCtrl.lua",
    r"app\module\legendLord\legendLordCtrl.lua",
    r"app\module\alliance\allianceCtrl.lua",
    r"app\module\nebula\nebulaActivityCtrl.lua",
    r"app\module\warGem\warGemCtrl.lua",
    r"app\module\interior\intetiorCtrl.lua",
    r"app\module\divineBeast\divineBeastCtrl.lua",
    r"app\module\godArms\godArmsRuneCtrl.lua",
    r"app\module\wonder\wonderWarDef.lua",
    r"app\module\prison\prisonCtrl.lua",
    r"app\module\lord\lordSkillCtrl.lua",
]

for rel in files_to_check:
    full = os.path.join(root, rel)
    if os.path.exists(full):
        with open(full, "r", encoding="utf-8", errors="ignore") as fp:
            content = fp.read()
        has_96 = "MARCH_VALUE_LIMIT_BOOST" in content or "96" in content
        has_19 = "MARCH_LIMIT_BOOST" in content or "19" in content
        has_march = "march" in content.lower()
        print(f"File {rel}: exists=True, has_96={has_96}, has_19={has_19}, has_march={has_march}")
    else:
        # try to search by basename
        bname = os.path.basename(rel)
        found = []
        for dp, _, fns in os.walk(root):
            if bname in fns:
                found.append(os.path.join(dp, bname))
        print(f"File {rel}: exists=False, found_elsewhere={found}")
