import json
import re

lucifer = json.load(open('docs/lucifer_live_memory.json', encoding='utf-8'))
active_skills = lucifer.get('heroBiographyCtrl', {}).get('activeSkillList', {})
print("Active skills in Lucifer:", list(active_skills.keys()))

with open(r'e:\intqam-sultan\game_file\src\app\localtb\config_server\hero_biography_skill.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Parse hero_biography_skill.lua entries
# Let's see how hero_biography_skill.lua is structured
lines = text.split('\n')
for i in range(min(50, len(lines))):
    print(lines[i])
