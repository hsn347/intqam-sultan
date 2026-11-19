# -*- coding: utf-8 -*-
import glob, os, re

files = glob.glob('game_file/**/pet_level*', recursive=True) + glob.glob('game_file/**/pet_rank*', recursive=True)
print("Pet conf files:", files)

for f in files:
    if f.endswith('.lua'):
        with open(f, 'r', encoding='utf-8', errors='ignore') as fp:
            text = fp.read()
            # check for 1254, 1251
            for pid in [1254, 1251, 1259, 1255]:
                if str(pid) in text:
                    print(f"Pet {pid} in {f}")
