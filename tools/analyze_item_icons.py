import re
from collections import Counter

with open('game_file/src/app/localtb/config_client/itemdescribe.lua', 'r', encoding='utf-8', errors='ignore') as f:
    text = f.read()

icons = re.findall(r'icon\s*=\s*"([^"]+)"', text)
print(f"Total icons found in itemdescribe: {len(icons)}")
c = Counter(icons)
print("Most common 20 icons:")
for name, cnt in c.most_common(20):
    print(f"  {name}: {cnt}")

unique_icons = sorted(list(set(icons)))
print("\nFirst 50 unique icons:")
print(unique_icons[:50])

print("\nIcons with '200' in them:")
for u in unique_icons:
    if '200' in u:
        print(f"  {u}")
