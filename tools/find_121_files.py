import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src\app\localtb"):
    for f in files:
        if "121" in f:
            print(os.path.join(root, f))
