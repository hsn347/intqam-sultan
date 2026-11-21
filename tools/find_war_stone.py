import os

for root, dirs, files in os.walk("game_file"):
    for file in files:
        if file.endswith(".lua") or file.endswith(".json") or file.endswith(".lang"):
            path = os.path.join(root, file)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as f:
                    for i, line in enumerate(f):
                        if "war_stone_name_16" in line:
                            print(f"{path}:{i+1}: {line.strip()[:100]}")
            except Exception:
                pass
