"""
Inspect beetoo2 heroes and their march capacity addition
"""
import json, os, sys

with open('tools/march_data_tables.json', 'r', encoding='utf-8') as f:
    march_tables = json.load(f)

# Let's inspect heroRare2LevelInfo and hero configs in game_file
# Where is heroRare2LevelInfo defined in heroltCtrl.lua?
with open('game_file/src/app/localtb/config_read/heroltCtrl.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

pos = text.find('heroRare2LevelInfo')
while pos != -1:
    print(text[max(0, pos-50):pos+300])
    print('='*50)
    pos = text.find('heroRare2LevelInfo', pos+1)
