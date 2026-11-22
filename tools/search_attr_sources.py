# -*- coding: utf-8 -*-
import json
import os
import re

tools_dir = os.path.dirname(os.path.abspath(__file__))
root_dir = os.path.dirname(tools_dir)

def search_files_for_attr():
    matches = []
    # Search in game_file/src/app/localtb
    localtb = os.path.join(root_dir, "game_file", "src", "app", "localtb")
    for root, dirs, files in os.walk(localtb):
        for f in files:
            if f.endswith(".lua"):
                fpath = os.path.join(root, f)
                with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                    content = fp.read()
                    if "attrID = 3" in content or "attrID = \"3\"" in content or "attrType = 5" in content or "attrType = \"5\"" in content or "attrId = 3" in content:
                        matches.append(fpath)
    print(f"Found {len(matches)} files matching attrID 3 / attrType 5 in localtb:")
    for m in matches:
        print(" -", os.path.relpath(m, root_dir))

if __name__ == "__main__":
    search_files_for_attr()
