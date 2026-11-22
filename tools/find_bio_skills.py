import re

with open("game_file/src/app/localtb/config_client/hero_biography_skill.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

# Let's find all skills where buffType has 96
entries = text.split(";(nil).id = ")
print("Total skills in hero_biography_skill.lua:", len(entries))

for e in entries[1:]:
    m_id = re.search(r"^(\d+)", e)
    if "96" in e:
        print(f"Skill {m_id.group(1) if m_id else '?'}:")
        for line in e.split("\n"):
            if any(k in line for k in ("buffType", "buffNum", "type", "GroupID", "missionNum")):
                print(" ", line.strip())
