import re
import glob

def find_buff_sources():
    print("Searching for effectType 19 and 96 across configs...")
    
    # 1. military rank
    for fn in glob.glob('game_file/**/military*.lua', recursive=True):
        with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
            t = f.read()
        if '19' in t or '96' in t:
            print(f"Military file: {fn}")
            
    # 2. pet
    for fn in glob.glob('game_file/**/pet*.lua', recursive=True):
        with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
            t = f.read()
        if 'MARCH_LIMIT_BOOST' in t or 'MARCH_VALUE_LIMIT_BOOST' in t:
            print(f"Pet file: {fn}")

    # 3. war gem
    for fn in glob.glob('game_file/**/gem*.lua', recursive=True):
        with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
            t = f.read()
        if '19' in t or '96' in t:
            print(f"Gem file: {fn}")

    # 4. alliance science
    for fn in glob.glob('game_file/**/alliance*.lua', recursive=True):
        with open(fn, 'r', encoding='utf-8', errors='ignore') as f:
            t = f.read()
        if 'MARCH_LIMIT_BOOST' in t or 'MARCH_VALUE_LIMIT_BOOST' in t:
            print(f"Alliance file: {fn}")

if __name__ == '__main__':
    find_buff_sources()
