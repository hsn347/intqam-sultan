import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if "cityctrl.lua" in f.lower():
            print(os.path.join(root, f))
