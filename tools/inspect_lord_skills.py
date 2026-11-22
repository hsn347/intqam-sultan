import json
import re

skill_list = {
    "13021": 1, "13011": 20, "13005": 5, "13029": 20, "11004": 5,
    "13003": 5, "11001": 5, "13033": 10, "13001": 5, "13015": 20,
    "13032": 1, "13017": 20, "13019": 20, "13009": 20, "13002": 5,
    "13020": 1, "13010": 20, "11002": 5, "11011": 1, "13007": 5,
    "13025": 20, "13022": 1, "13013": 20, "13031": 20, "13027": 20,
    "13023": 20
}

with open("game_file/src/app/localtb/config_server/skill.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

with open("game_file/localtb/local_arab.json", "r", encoding="utf-8") as f:
    arab = json.load(f)

for sid, lv in skill_list.items():
    # skill ID pattern in skill.lua: sid + lv format
    full_id = f"{sid}{lv:02d}"
    name_key = f"lordskill_name_{sid}"
    name = arab.get(name_key, sid)
    
    # search skill in skill.lua
    # pattern: ;(nil).skillID = full_id ... buffType = ... powerNum = ...
    # or [full_id]
    m = re.search(rf"skillID\s*=\s*{full_id}.*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*([0-9.]+)", text, re.DOTALL)
    if not m:
        m = re.search(rf"skillID\s*=\s*{full_id}.*?powerNum\s*=\s*([0-9.]+).*?buffType\s*=\s*(\d+)", text, re.DOTALL)
    if m:
        print(f"Skill {sid} Lv.{lv} ({name}): {m.group(0)[:150]}")
    else:
        # try without regex DOTALL across lines
        print(f"Skill {sid} Lv.{lv} ({name}): not matched in first pattern")
