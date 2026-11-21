import re

with open('game_file/src/app/localtb/config_server/technology.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# find technologies with march effect or single_troop_strength
# technologyType or effectType
techs = {}
for line in text.split('\n'):
    m_id = re.search(r'\[(\d+)\]\s*=\s*\{', line)
    # search lines that have property or effect
    pass

# Let's search by grep for properties
