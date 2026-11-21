import json
import re

# Where is equipmentBasePropertyConfig loaded from?
# Let's check equipmentltCtrl.lua to see the file name
with open('game_file/src/app/localtb/config_read/equipmentltCtrl.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

idx = text.find('equipmentBasePropertyConfig')
print("In equipmentltCtrl:")
print(text[idx-100:idx+200])
