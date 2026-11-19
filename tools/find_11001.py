import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src\app\localtb"):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                if "11001" in fp.read():
                    print(fpath)
