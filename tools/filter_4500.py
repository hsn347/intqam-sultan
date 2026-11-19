# -*- coding: utf-8 -*-
import os

keywords = ['march', 'hero', 'build', 'tech', 'equip', 'lord', 'attribute', 'buff', 'army']
dir_path = 'game_file/src/app/localtb/config_server/'

for f in sorted(os.listdir(dir_path)):
    if f.endswith('.lua') and any(k in f.lower() for k in keywords):
        p = os.path.join(dir_path, f)
        with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
            txt = fp.read()
            if '4500' in txt:
                for line in txt.splitlines():
                    if '4500' in line and any(w in line for w in ['capacity', 'buff', 'value', 'power', 'march', 'army']):
                        print(f"{f}: {line.strip()[:100]}")
