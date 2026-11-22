import re

with open("game_file/src/app/localtb/config_server/hero_biography_skill.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

entries = text.split(";(nil).skillID = ")
print("Total skills:", len(entries))

for e in entries[1:]:
    m_id = re.search(r"^(\d+)", e)
    sid = m_id.group(1) if m_id else "?"
    if "96" in e:
        # check if 96 is in buffType
        m_bt = re.search(r"buffType,\s*\(nil\)\[\d+\]\s*=\s*(?:nil,\s*)*96", e)
        if m_bt or "buffType" in e:
            lines = [l.strip() for l in e.split("\n") if any(k in l for k in ("buffType", "buffNum", "type", "GroupID", "missionNum"))]
            print(f"Skill {sid}:")
            for l in lines:
                print(" ", l)
