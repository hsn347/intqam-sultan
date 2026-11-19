import os
import re

src_dir = r"e:\intqam-sultan\game_file\src"
matches = []
for root, dirs, files in os.walk(src_dir):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            try:
                with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                    content = fp.read()
                    if "attributeSystem.add" in content or "attributeSystem.initAttr" in content:
                        matches.append(fpath)
            except Exception:
                pass
print("Files calling attributeSystem.add/initAttr:")
for m in matches:
    print("  -", m)
