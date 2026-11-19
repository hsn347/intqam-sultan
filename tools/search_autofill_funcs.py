import os
import re

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
                m = re.findall(r'function\s+[\w\.:]*autoFill[\w\.:]*', content, re.IGNORECASE)
                if m:
                    print(fpath, m)
