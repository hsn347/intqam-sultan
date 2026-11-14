import os
import re

ctrl_dir = 'game_file/src/app/module'
pattern = re.compile(r'register\s*\(\s*gNotifyID\.(\w+)', re.IGNORECASE)

results = {}

for root, dirs, files in os.walk(ctrl_dir):
    for f in files:
        if not f.endswith('.lua'):
            continue
        p = os.path.join(root, f)
        try:
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                content = fp.read()
                matches = pattern.findall(content)
                if matches:
                    results[f] = sorted(list(set(matches)))
        except Exception:
            pass

print(f"Total module files registering gNotifyID: {len(results)}")
for f, n_list in sorted(results.items()):
    print(f"{f}: {n_list}")
