import re

# Read hero_level_config.lua
with open('game_file/src/app/localtb/config_server/hero_level_config.lua', 'r', encoding='utf-8') as f:
    text = f.read()

# Let's see how hero_level_config is structured
print("Length of hero_level_config:", len(text))
for line in text.splitlines()[:50]:
    print(line)
