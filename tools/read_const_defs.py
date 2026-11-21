import os
import re

def search_in_files(folder, patterns, exts=[".lua"]):
    results = {}
    for root, dirs, files in os.walk(folder):
        for f in files:
            if any(f.endswith(ext) for ext in exts):
                path = os.path.join(root, f)
                try:
                    with open(path, "r", encoding="utf-8", errors="ignore") as fl:
                        for i, line in enumerate(fl):
                            for p in patterns:
                                if p in line:
                                    if p not in results:
                                        results[p] = []
                                    results[p].append((path, i+1, line.strip()))
                except Exception:
                    pass
    return results

patterns = [
    "DEFAULT_EXP_ARMY_COUNT",
    "SINGLE_TROOP_STRENGTH",
    "CONQUEST_WAR_SINGLE_TROOP_STRENGTH",
    "PYRAMID_SINGLE_TROOP_STRENGTH",
    "LEGEND_SINGLE_TROOP_STRENGTH",
    "MARCH_VALUE_LIMIT_BOOST",
    "MARCH_LIMIT_BOOST",
    "DISPATCH_TROOP_COUNT_NUM"
]

res = search_in_files(r"E:\intqam-sultan\game_file\src\app\constdef", patterns)
for p, matches in res.items():
    print(f"=== Pattern: {p} ===")
    for path, line_no, text in matches[:5]:
        print(f"  {os.path.basename(path)}:{line_no} -> {text}")
