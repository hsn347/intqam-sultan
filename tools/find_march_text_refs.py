# -*- coding: utf-8 -*-
import os

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
localtb = os.path.join(root_dir, "game_file", "src", "app", "localtb")

matches = []
for root, dirs, files in os.walk(localtb):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                content = fp.read()
                if "common_text_2955" in content:
                    matches.append(os.path.relpath(fpath, root_dir))

print(f"Files referencing common_text_2955 ({len(matches)}):")
for m in matches:
    print(" -", m)
