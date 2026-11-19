# -*- coding: utf-8 -*-
import re

with open('game_file/src/app/localtb/config_server/pet_level_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

matches = re.findall(r'"(18\d+)"', text)
print('Any 18xxxx in pet_level_conf:', set(matches))

with open('game_file/src/app/localtb/config_server/pet_rank_conf.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text_rank = f.read()
matches_rank = re.findall(r'"(18\d+)"', text_rank)
print('Any 18xxxx in pet_rank_conf:', set(matches_rank))
