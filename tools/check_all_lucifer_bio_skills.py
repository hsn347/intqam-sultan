import json
import re

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    lucifer = json.load(f)

active_skills = lucifer.get("heroBiographyCtrl", {}).get("activeSkillList", {})
print("Active skills in Lucifer:", len(active_skills))

with open("game_file/src/app/localtb/config_server/hero_biography_skill.lua", "r", encoding="utf-8", errors="ignore") as f:
    lua_code = f.read()

# Let's search each skillID in the lua code
for sid in sorted(active_skills.keys()):
    # search for skillID = sid
    pos = lua_code.find(f"skillID = {sid}")
    if pos != -1:
        snippet = lua_code[pos:pos+400]
        # extract buffType, buffNum
        print(f"\n--- Skill {sid} ---")
        lines = snippet.split("\n")[:10]
        for l in lines:
            print(" ", l.strip())
