# -*- coding: utf-8 -*-
import os
import re

dir_path = 'game_file/'
found = []

for root, dirs, files in os.walk(dir_path):
    for f in files:
        if f.endswith('.lua'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                txt = fp.read()
                if 'MARCH_VALUE_LIMIT_BOOST' in txt or 'DISPATCH_TROOP_COUNT_NUM' in txt:
                    # check if 4500 is in txt as well
                    if '4500' in txt:
                        found.append(p)

print("Files containing both MARCH_VALUE_LIMIT_BOOST/DISPATCH_TROOP_COUNT_NUM and 4500:")
for p in found:
    print("  ", p)
