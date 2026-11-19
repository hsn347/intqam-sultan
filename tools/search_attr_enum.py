import json
import os
import re

def main():
    # 1. Search for DISPATCH_TROOP_COUNT_NUM in lua files
    src_dir = r"e:\intqam-sultan\game_file\src"
    matches = []
    for root, dirs, files in os.walk(src_dir):
        for f in files:
            if f.endswith(".lua"):
                fpath = os.path.join(root, f)
                try:
                    with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                        content = fp.read()
                        if "DISPATCH_TROOP_COUNT_NUM" in content or "dispatch_troop_count_num" in content.lower():
                            matches.append(fpath)
                except Exception:
                    pass
    print("Files with DISPATCH_TROOP_COUNT_NUM:")
    for m in matches:
        print("  -", m)

if __name__ == "__main__":
    main()
