import os
import re

results = set()
search_dirs = [
    'game_file/src/app/game/buildView',
    'game_file/src/fgui',
    'game_file/src/app/localtb',
    'game_file/src/app/module/arena',
    'game_file/src/app/constdef',
    'game_file/localtb'
]

pattern = re.compile(r'[\w\-]*121[\w\-]*\.png|[\w\-]*arena[\w\-]*\.png|[\w\-]*drill[\w\-]*\.png', re.I)

for sdir in search_dirs:
    for root, dirs, files in os.walk(sdir):
        if 'meshData' in root:
            continue
        for f in files:
            if f.endswith(('.lua', '.json')):
                p = os.path.join(root, f)
                with open(p, 'r', encoding='utf-8', errors='ignore') as fl:
                    c = fl.read()
                    for m in pattern.findall(c):
                        results.add((m, p))

for m, p in sorted(results):
    print(f'{m} -> {p}')
