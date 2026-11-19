import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if "hero_dress_server" in f:
            print(os.path.join(root, f))
