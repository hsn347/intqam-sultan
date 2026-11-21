import json
import re
import os

# Let's find achievement config files
for root, dirs, files in os.walk('game_file/src/app/localtb'):
    for f in files:
        if 'achi' in f.lower():
            print(os.path.join(root, f))
