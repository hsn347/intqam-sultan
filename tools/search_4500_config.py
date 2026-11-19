# -*- coding: utf-8 -*-
import os
import re

dir_path = 'game_file/src/app/localtb/config_server/'
found = []
for f in os.listdir(dir_path):
    if f.endswith('.lua'):
        p = os.path.join(dir_path, f)
        with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
            txt = fp.read()
            if '4500' in txt:
                # find lines with 4500
                for line in txt.splitlines():
                    if '4500' in line:
                        found.append((f, line.strip()))

print(f"Total occurrences of 4500 in config_server: {len(found)}")
for fname, l in found[:30]:
    print(f"  {fname}: {l[:100]}")
