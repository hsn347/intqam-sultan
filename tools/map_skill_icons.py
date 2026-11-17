import re
import sys
sys.path.insert(0, '.')
from tasks.base_task import LORD_ACTIVE_SKILLS_CATALOG

with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

# Pattern in lordskilldes.lua:
# (nil).id = 11001
# (nil).name = "lordskill_name_11001"
# (nil).des = "lordskill_des_11001"
# _ENV, (nil)[11001], (nil).icon = nil, nil, "Battle_1.png"

for sid, info in LORD_ACTIVE_SKILLS_CATALOG.items():
    pat = rf'\(nil\)\.id\s*=\s*{sid}\b.*?\((?:nil|\w+)\)\.icon\s*=\s*(?:nil,\s*nil,\s*)?"([^"]+)"'
    m = re.search(pat, text, re.DOTALL)
    if m:
        icon = m.group(1)
        print(f"{sid}: {info['name_ar']} -> {icon}")
    else:
        # try finding anywhere near sid
        idx = text.find(str(sid))
        if idx != -1:
            chunk = text[idx:idx+200]
            print(f"{sid}: {info['name_ar']} -> CHUNK: {chunk}")
        else:
            print(f"{sid}: {info['name_ar']} -> NOT FOUND")
