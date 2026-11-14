import os, glob

for root, dirs, files in os.walk(r'e:\intqam-sultan\dashboard\src'):
    for f in files:
        if f.endswith('.tsx') or f.endswith('.ts'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                txt = fp.read()
                if "'building'" in txt or '"building"' in txt:
                    for line_no, line in enumerate(txt.splitlines(), 1):
                        if 'building' in line.lower() and any(w in line.lower() for w in ['tab', 'id', 'key', 'comingsoon', 'disabled']):
                            print(f"{f}:{line_no}: {line.strip()[:100]}")

