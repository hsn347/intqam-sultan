import os

for root, dirs, files in os.walk("game_file/src/app"):
    for file in files:
        if file.endswith(".lua"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        if "technologyType" in line:
                            print(f"{path}:{i+1}: {line.strip()}")
            except Exception:
                pass
