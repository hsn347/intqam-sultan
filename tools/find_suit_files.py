import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src\app\localtb"):
    for f in files:
        if "suit" in f.lower() and f.endswith(".lua"):
            print(os.path.join(root, f))
