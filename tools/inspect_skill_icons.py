import re
import sys
sys.path.insert(0, '.')
from tasks.base_task import LORD_ACTIVE_SKILLS_CATALOG

with open('game_file/src/app/localtb/config_client/skilltree.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

print("Skill mapping from skilltree.lua:")
for sid, info in LORD_ACTIVE_SKILLS_CATALOG.items():
    # look for ["sid"] = { ... }
    m = re.search(rf'\["{sid}"\]\s*=\s*\{{([^}}]+)\}}', text)
    if m:
        chunk = m.group(1)
        icon_m = re.search(r'icon\s*=\s*"([^"]+)"', chunk)
        icon = icon_m.group(1) if icon_m else "N/A"
        print(f"{sid}: {info['name_ar']} ({info['name_en']}) -> icon: {icon}")
    else:
        print(f"{sid}: {info['name_ar']} -> not found in skilltree.lua")
