import re

def parse_dress_type_config():
    with open('game_file/src/app/localtb/config_server/dress_type_config.lua', 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    # The file has entries like:
    # ;(nil).ownAttribute, (nil)[1] = nil, 3
    # ...
    # Let's inspect lines around index 36, 41, etc.
    lines = content.splitlines()
    print(f"Total lines in dress_type_config.lua: {len(lines)}")

    # Let's see how entries are structured
    for i in range(min(150, len(lines))):
        print(f"{i+1}: {lines[i]}")

if __name__ == '__main__':
    parse_dress_type_config()
