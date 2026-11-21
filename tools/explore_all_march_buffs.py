import os
import re

root = r"e:\intqam-sultan\game_file\src"

def search_patterns(patterns):
    findings = {p: [] for p in patterns}
    for dirpath, _, filenames in os.walk(root):
        for f in filenames:
            if f.endswith(".lua"):
                fpath = os.path.join(dirpath, f)
                try:
                    with open(fpath, "r", encoding="utf-8", errors="ignore") as fp:
                        for lno, line in enumerate(fp, 1):
                            for p in patterns:
                                if p in line:
                                    findings[p].append((fpath, lno, line.strip()))
                except Exception:
                    pass
    return findings

patterns = [
    "MARCH_VALUE_LIMIT_BOOST",
    "MARCH_LIMIT_BOOST",
    "DISPATCH_TROOP_COUNT_NUM",
    "MASS_MARCH_VALUE_LIMIT_BOOST",
    "MASS_MARCH_LIMIT_BOOST",
    "MARCH_TROOP_TOTAL_BOOST"
]

res = search_patterns(patterns)
for p in patterns:
    print(f"=== Pattern: {p} ({len(res[p])} occurrences) ===")
    for path, lno, line in res[p]:
        rel = os.path.relpath(path, root)
        print(f"  {rel}:{lno} -> {line[:120]}")
