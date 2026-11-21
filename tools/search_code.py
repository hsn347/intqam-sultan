import re
import os

pattern = "SINGLE_TROOP_STRENGTH"
root = "game_file/src"

for r, d, files in os.walk(root):
    for f in files:
        if f.endswith(".lua"):
            path = os.path.join(r, f)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as fp:
                    for i, line in enumerate(fp):
                        if pattern in line:
                            print(f"{path}:{i+1}: {line.strip()}")
            except Exception:
                pass
