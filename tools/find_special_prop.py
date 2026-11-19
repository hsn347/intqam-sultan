import os

src_dir = r"e:\intqam-sultan\game_file\src"
for root, dirs, files in os.walk(src_dir):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                if "getEquipmentSpecialProperty" in fp.read():
                    print(fpath)
