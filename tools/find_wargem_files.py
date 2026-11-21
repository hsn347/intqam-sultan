import os
import re

for r, d, files in os.walk(os.path.join(r'e:\intqam-sultan\game_file', 'src')):
    if 'src_bytecode' in r:
        continue
    for f in files:
        if 'gem' in f.lower():
            p = os.path.join(r, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                txt = fp.read()
            if 'MARCH_VALUE_LIMIT_BOOST' in txt or '96' in txt:
                print(f'{f}: {os.path.relpath(p, r"e:\intqam-sultan\game_file")}')
