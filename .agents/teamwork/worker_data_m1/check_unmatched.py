import os
import re

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]

unmatched_pre = []
unmatched_res = []
unmatched_wes = []
unmatched_tools = []

for fname in sorted(files):
    path = os.path.join(dir_path, fname)
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    for lno, line in enumerate(lines, 1):
        if '.preCond' in line:
            # Check if it's the declaration like (nil).preCond = {} or an assignment like (nil).preCond[1] = ...
            if '[' in line and '=' in line:
                m = re.search(r'\.preCond(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if not m:
                    unmatched_pre.append((fname, lno, line.strip()))
        if '.costRes' in line:
            if '[' in line and '=' in line:
                m = re.search(r'\.costRes(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if not m:
                    unmatched_res.append((fname, lno, line.strip()))
        if '.costWEs' in line:
            if '[' in line and '=' in line:
                m = re.search(r'\.costWEs(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if not m:
                    unmatched_wes.append((fname, lno, line.strip()))
        if '.costTools' in line:
            if '[' in line and '=' in line:
                m = re.search(r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]\s*=\s*([^\n;]+)', line)
                if not m:
                    unmatched_tools.append((fname, lno, line.strip()))

print(f"Unmatched preCond: {len(unmatched_pre)}")
for u in unmatched_pre[:5]:
    print(" ", u)
print(f"Unmatched costRes: {len(unmatched_res)}")
for u in unmatched_res[:5]:
    print(" ", u)
print(f"Unmatched costWEs: {len(unmatched_wes)}")
for u in unmatched_wes[:5]:
    print(" ", u)
print(f"Unmatched costTools: {len(unmatched_tools)}")
for u in unmatched_tools[:5]:
    print(" ", u)
