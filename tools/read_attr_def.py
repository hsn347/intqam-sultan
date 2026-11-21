import os

for root, dirs, files in os.walk(r"E:\intqam-sultan\game_file\src\app"):
    for f in files:
        if "attribute" in f.lower():
            print("attribute file:", os.path.join(root, f))
            try:
                with open(os.path.join(root, f), "r", encoding="utf-8", errors="ignore") as fl:
                    for line in fl:
                        if "DISPATCH_TROOP_COUNT_NUM" in line:
                            print("  FOUND:", line.strip())
            except Exception:
                pass
