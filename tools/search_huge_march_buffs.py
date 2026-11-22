import os
import re

patterns = [
    r'MARCH_VALUE_LIMIT_BOOST',
    r'MARCH_LIMIT_BOOST',
    r'DISPATCH_TROOP_COUNT_NUM',
    r'expArmyCount',
    r'getExpArmyCount',
]

results = []
for root, dirs, files in os.walk("game_file/src"):
    for file in files:
        if file.endswith(".lua"):
            path = os.path.join(root, file)
            with open(path, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
            for p in patterns:
                m = re.findall(rf'.{{0,50}}{p}.{{0,50}}', content)
                if m:
                    for line in m[:3]:
                        results.append(f"{file} ({p}): {line.strip()}")

print(f"Total occurrences: {len(results)}")
for r in results[:40]:
    print(" ", r)
