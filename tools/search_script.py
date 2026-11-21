import os
import sys

root = r"e:\intqam-sultan\game_file\src"
target_words = ["DISPATCH_TROOP_COUNT_NUM", "MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "MASS_MARCH_VALUE_LIMIT_BOOST", "MASS_MARCH_LIMIT_BOOST", "MARCH_TROOP_TOTAL_BOOST"]

results = []
for dirpath, dirnames, filenames in os.walk(root):
    for f in filenames:
        if f.endswith(".lua"):
            p = os.path.join(dirpath, f)
            try:
                with open(p, "r", encoding="utf-8", errors="ignore") as fp:
                    for i, line in enumerate(fp):
                        for tw in target_words:
                            if tw in line:
                                results.append(f"{p}:{i+1}:{tw}:{line.strip()[:100]}")
            except Exception:
                pass

print(f"Total found: {len(results)}")
for r in results[:100]:
    print(r)
