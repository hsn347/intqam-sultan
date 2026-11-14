import os

for root, dirs, files in os.walk('game_file'):
    for f in files:
        if f.endswith(('.lua', '.json')):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fl:
                if '91010008' in fl.read():
                    print(f'{p}: found 91010008')
