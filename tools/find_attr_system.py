import os

root = r"e:\intqam-sultan\game_file\src"

matches = []
for dirpath, _, filenames in os.walk(root):
    for f in filenames:
        if f.endswith(".lua"):
            fpath = os.path.join(dirpath, f)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                for lno, line in enumerate(fp, 1):
                    if "attributeSystem" in line:
                        matches.append((fpath, lno, line.strip()))

print(f"Total attributeSystem matches: {len(matches)}")
for m in matches:
    print(f"{os.path.relpath(m[0], root)}:{m[1]} -> {m[2]}")
