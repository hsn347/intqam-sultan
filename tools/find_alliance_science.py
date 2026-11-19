import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if "alliance_science" in f.lower() and f.endswith(".lua"):
            print(os.path.join(root, f))
