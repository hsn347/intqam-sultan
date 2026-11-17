# -*- coding: utf-8 -*-
import os
import re

def extract_strings(filepath):
    if not os.path.exists(filepath):
        return []
    with open(filepath, 'rb') as f:
        data = f.read()
    # Find ascii strings
    strings = re.findall(b'[\x20-\x7e]{3,}', data)
    return [s.decode('ascii', errors='ignore') for s in strings]

views_dir = "game_file/src_bytecode/fgui/views/newLordView"
for fname in os.listdir(views_dir):
    if "skill" in fname.lower():
        fpath = os.path.join(views_dir, fname)
        strs = extract_strings(fpath)
        print(f"=== {fname} ({len(strs)} strings) ===")
        # print strings that look like tabs, keys, controllers, commands
        interesting = [s for s in strs if any(w in s.lower() for w in ('tab', 'page', 'type', 'title', 'ctrl', 'cmd', 'btn', 'group', 'list', 'lord', 'skill', 'rally', 'mass'))]
        print("Interesting:", interesting[:40])
