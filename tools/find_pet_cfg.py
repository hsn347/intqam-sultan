import os
import re

# Find pet level config and rank config
for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if "pet" in f.lower() and f.endswith(".lua"):
            if any(term in f.lower() for term in ["level", "rank"]):
                print(os.path.join(root, f))
