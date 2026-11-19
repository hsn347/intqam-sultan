import re
import json

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_ar = json.load(f)

with open('game_file/src/fgui/views/NewHeroView/newHeroListViewPanel.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

keys = re.findall(r'i18n\(["\']([^"\']+)["\']', text)
print("Keys in newHeroListViewPanel:")
for k in set(keys):
    print(f"  {k} -> {local_ar.get(k)}")

# Also inspect heroClassesInfo
with open('game_file/src/app/localtb/config_read/heroltCtrl.lua', 'r', encoding='utf-8', errors='ignore') as f:
    ctrl_text = f.read()

# Let's search for heroClassesInfo or class icons
classes = re.findall(r'hero_typename_\d+', ctrl_text)
print("Hero typenames:", set(classes))
for c in set(classes):
    print(f"  {c} -> {local_ar.get(c)}")
