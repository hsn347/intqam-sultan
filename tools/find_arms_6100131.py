import os

for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            try:
                with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                    if "6100131" in fp.read():
                        print(fpath)
            except Exception:
                pass
