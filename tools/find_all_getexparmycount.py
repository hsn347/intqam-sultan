import os

results = []
for root, dirs, files in os.walk(r"E:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            path = os.path.join(root, f)
            try:
                with open(path, "r", encoding="utf-8", errors="ignore") as fl:
                    for i, line in enumerate(fl):
                        if "getexparmycount" in line.lower():
                            results.append((path, i+1, line.strip()))
            except Exception:
                pass

print(f"Total occurrences of getExpArmyCount: {len(results)}")
for path, line, text in results:
    rel = os.path.relpath(path, r"E:\intqam-sultan\game_file\src")
    print(f"  {rel}:{line} -> {text}")
