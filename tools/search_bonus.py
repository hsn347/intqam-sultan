import os
import re

patterns = [r'bonus', r'بونص']

results = []

for root, dirs, files in os.walk("game_file"):
    for file in files:
        if not file.endswith((".lua", ".json", ".xml", ".txt")):
            continue
        filepath = os.path.join(root, file)
        try:
            with open(filepath, "r", encoding="utf-8", errors="ignore") as f:
                content = f.read()
            for p in patterns:
                matches = list(re.finditer(p, content, re.IGNORECASE))
                if matches:
                    for m in matches[:3]:
                        start = max(0, m.start() - 60)
                        end = min(len(content), m.end() + 60)
                        snippet = content[start:end].replace('\n', ' ')
                        results.append((filepath, snippet))
        except Exception:
            pass

print(f"Total occurrences found: {len(results)}")
# print those that also mention march or army or capacity
march_results = [r for r in results if any(w in r[1].lower() for w in ['march', 'army', 'count', 'capacity', 'مسيرة', 'فيلق', 'جيش', 'سعة'])]
print(f"Occurrences with march/army/capacity: {len(march_results)}")
for r in march_results[:50]:
    print(f"[{r[0]}]: {r[1]}")
