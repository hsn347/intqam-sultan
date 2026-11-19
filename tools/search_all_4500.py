import os
import re

matches = []
for root, dirs, files in os.walk(r"e:\intqam-sultan\game_file\src"):
    for f in files:
        if f.endswith(".lua"):
            fpath = os.path.join(root, f)
            try:
                with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                    content = fp.read()
                    if "4500" in content:
                        for line in content.splitlines():
                            if "4500" in line and any(term in line.lower() for term in ["march", "army", "troop", "dispatch", "capacity", "limit", "power", "buff", "val", "add"]):
                                matches.append((fpath, line.strip()[:120]))
            except Exception:
                pass

print(f"Total matching lines with 4500: {len(matches)}")
for fpath, l in matches[:30]:
    fname = os.path.basename(fpath)
    print(f"  [{fname}] {l}")
