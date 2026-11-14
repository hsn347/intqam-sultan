import os

for root, dirs, files in os.walk(r'e:\intqam-sultan\dashboard\src'):
    for f in files:
        if f == 'TaskTabContent.tsx':
            continue
        if f.endswith('.tsx') or f.endswith('.ts'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8', errors='ignore') as fp:
                txt = fp.read()
                if "'building'" in txt or '"building"' in txt:
                    for line_no, line in enumerate(txt.splitlines(), 1):
                        if 'building' in line.lower():
                            safe_line = line.strip().encode('ascii', 'replace').decode('ascii')
                            print(f"{f}:{line_no}: {safe_line[:100]}")

