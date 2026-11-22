import sys
sys.path.insert(0, 'e:/intqam-sultan')
import re

# Find hero skill 172101 in game files to verify exact march boost values
with open('game_file/src/app/localtb/config_server/hero_biography_skill.lua', 'r', encoding='utf-8') as f:
    bio_text = f.read()

# Search in hero skill config files
import os
hero_skill_files = []
for root, dirs, files in os.walk('game_file/src/app/localtb'):
    for f in files:
        if 'hero' in f.lower() and 'skill' in f.lower():
            hero_skill_files.append(os.path.join(root, f))

print("Hero skill files:", hero_skill_files)
print()

# Look for 172101 in all hero files
for fpath in hero_skill_files:
    try:
        with open(fpath, 'r', encoding='utf-8') as f:
            text = f.read()
        if '172101' in text:
            idx = text.find('172101')
            print(f"Found 172101 in {os.path.basename(fpath)}:")
            print(text[max(0,idx-200):idx+500])
            print("---")
    except Exception as e:
        print(f"Error reading {fpath}: {e}")

# Also check hero skill server config
skill_server_files = []
for root, dirs, files in os.walk('game_file/src/app/localtb/config_server'):
    for f in files:
        if 'hero' in f.lower() and 'skill' in f.lower():
            skill_server_files.append(os.path.join(root, f))

print("Server skill files:", skill_server_files)
for fpath in skill_server_files:
    try:
        with open(fpath, 'r', encoding='utf-8') as f:
            text = f.read()
        if '172101' in text:
            idx = text.find('172101')
            print(f"Found 172101 in {os.path.basename(fpath)}:")
            print(text[max(0,idx-100):idx+600])
    except Exception as e:
        print(f"Error: {e}")
