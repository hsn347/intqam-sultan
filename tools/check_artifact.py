# -*- coding: utf-8 -*-
with open('game_file/src/app/localtb/config_server/artifact_attributes_config.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()[:50]
    print(''.join(lines))
