import os
import re
from test_parse import parse_lua_build_file

dir_path = r"e:\intqam-sultan\game_file\src\app\localtb\config_server"
files = [f for f in os.listdir(dir_path) if re.match(r'^build\d+\.lua$', f)]

max_pre_k = 0
max_res_k = 0
max_wes_k = 0
max_tools_k = 0

for fname in sorted(files):
    path = os.path.join(dir_path, fname)
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()
    
    for line in text.splitlines():
        if '.preCond' in line:
            m = re.search(r'\.preCond(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]', line)
            if m:
                max_pre_k = max(max_pre_k, int(m.group(1)))
        if '.costRes' in line:
            m = re.search(r'\.costRes(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]', line)
            if m:
                max_res_k = max(max_res_k, int(m.group(1)))
        if '.costWEs' in line:
            m = re.search(r'\.costWEs(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]', line)
            if m:
                max_wes_k = max(max_wes_k, int(m.group(1)))
        if '.costTools' in line:
            m = re.search(r'\.costTools(?:,\s*|\s+)?(?:\([^\)]*\))?\[(\d+)\]', line)
            if m:
                max_tools_k = max(max_tools_k, int(m.group(1)))

print(f"Max preCond index: {max_pre_k}")
print(f"Max costRes index: {max_res_k}")
print(f"Max costWEs index: {max_wes_k}")
print(f"Max costTools index: {max_tools_k}")
