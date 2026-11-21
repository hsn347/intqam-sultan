with open("game_file/src/app/localtb/config_server/technology.lua", "r", encoding="utf-8") as f:
    text = f.read()

import re
matches = re.findall(r"technologyID\s*=\s*(\d+).*?technologyType\s*=\s*(\d+)", text, re.DOTALL)
type_map = {}
for tid, ttype in matches[:200]:
    type_map.setdefault(ttype, []).append(tid)

for ttype, tids in type_map.items():
    print(f"Type {ttype}: {len(tids)} techs, e.g. {tids[:5]}")
