import re
import sys
sys.path.insert(0, '.')
from tasks.base_task import LORD_ACTIVE_SKILLS_CATALOG

with open('game_file/src/app/localtb/config_client/lordskilldes.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

print("Search in lordskilldes.lua:")
for sid, info in LORD_ACTIVE_SKILLS_CATALOG.items():
    m = re.search(rf'\["{sid}"\]\s*=\s*\{{([^}}]+)\}}', text)
    if m:
        chunk = m.group(1)
        icon_m = re.search(r'icon\s*=\s*"([^"]+)"', chunk)
        print(f"{sid}: {info['name_ar']} -> {chunk[:120]}")
    else:
        # maybe without quotes: [11011]
        m2 = re.search(rf'\[{sid}\]\s*=\s*\{{([^}}]+)\}}', text)
        if m2:
            chunk = m2.group(1)
            print(f"{sid}: {info['name_ar']} -> {chunk[:120]}")
        else:
            print(f"{sid}: not found")
