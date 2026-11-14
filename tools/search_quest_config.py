import re

paths = [
    r'e:\intqam-sultan\game_file\localtb\delta_patch_tables\new_quest_describe.lua',
    r'e:\intqam-sultan\game_file\localtb\delta_patch_tables\new_quest_config.lua',
    r'e:\intqam-sultan\game_file\src\app\localtb\config_server\new_quest_config.lua'
]

for p in paths:
    print('Searching:', p)
    try:
        with open(p, 'rb') as f:
            buf = f.read()
        for term in [b'CommandHall', b'commandhall', b'command_hall', b'Command']:
            count = buf.count(term)
            if count > 0:
                print(f'  Found {term.decode()}: {count} times')
    except Exception as e:
        print('Error:', e)
