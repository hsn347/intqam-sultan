import re
import json

with open('game_file/src/app/localtb/config_server/achievement_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's inspect how achievement_config is structured
print("Length of achievement_config:", len(text))
for line in text.splitlines()[:60]:
    print(line)
