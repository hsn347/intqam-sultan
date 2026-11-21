import os
import re

for root, dirs, files in os.walk("game_file/src/app/localtb/config_server"):
    for file in files:
        if file.startswith("build") and file.endswith(".lua"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        if "capacity" in line:
                            print(f"{file}:{i+1}: {line.strip()[:100]}")
                            break
            except Exception:
                pass
