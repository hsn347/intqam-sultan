import os
import re

pattern = r"WorldDispatchArmyView"
for root, dirs, files in os.walk("game_file/src"):
    for file in files:
        if file.endswith(".lua"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        if pattern in line:
                            print(f"{path}:{i+1}: {line.strip()[:120]}")
            except Exception:
                pass
