with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_server\alliance_science_lv.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

import re
entries = re.findall(r'sciType\s*=\s*(\d+).*?buffType\s*=\s*(\d+).*?powerNum\s*=\s*(\d+)', content, re.DOTALL)
print(f"Total entries: {len(entries)}")
for st, bt, pw in entries:
    if bt in ('19', '96') or pw == '4500':
        print(f"sciType={st}, buffType={bt}, powerNum={pw}")
