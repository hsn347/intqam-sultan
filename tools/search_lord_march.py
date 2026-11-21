import os
import re

for root, dirs, files in os.walk("game_file/src"):
    for file in files:
        if "lord" in file.lower() and file.endswith(".lua"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        if "march" in line.lower() or "capacity" in line.lower() or "army" in line.lower():
                            if "exp" in line.lower() or "troop" in line.lower():
                                print(f"{file}:{i+1}: {line.strip()[:100]}")
            except Exception:
                pass
