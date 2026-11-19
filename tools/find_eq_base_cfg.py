import os

src_dir = r"e:\intqam-sultan\game_file\src"
for root, dirs, files in os.walk(src_dir):
    for f in files:
        if "equipment_base" in f:
            print(os.path.join(root, f))
