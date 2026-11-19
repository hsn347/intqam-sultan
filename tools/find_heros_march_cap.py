import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            with open(os.path.join(root, f), "r", encoding="utf-8", errors="ignore") as fp:
                if "getHerosMarchCapacity" in fp.read():
                    print(os.path.join(root, f))
