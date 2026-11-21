import os
import re

patterns = [
    "MARCH_LIMIT_BOOST",
    "MARCH_VALUE_LIMIT_BOOST",
    "DISPATCH_TROOP_COUNT_NUM",
]

for root, dirs, files in os.walk("game_file/src"):
    for file in files:
        if file.endswith(".lua"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        for p in patterns:
                            if p in line:
                                print(f"{path}:{i+1}: {line.strip()[:120]}")
            except Exception:
                pass
