import os
import re

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]

unmatched_wes = []
unmatched_tools = []

for fname in sorted(files):
    path = os.path.join(dir_path, fname)
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    for lno, line in enumerate(lines, 1):
        if re.search(r'\.costWEs.*\[', line):
            m = re.search(r'\.costWEs(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
            if not m:
                unmatched_wes.append((fname, lno, line.strip()))
        if re.search(r'\.costTools.*\[', line):
            m = re.search(r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
            if not m:
                unmatched_tools.append((fname, lno, line.strip()))

print(f"Unmatched costWEs (indexed): {len(unmatched_wes)}")
for u in unmatched_wes[:5]:
    print(" ", u)
print(f"Unmatched costTools (indexed): {len(unmatched_tools)}")
for u in unmatched_tools[:5]:
    print(" ", u)
