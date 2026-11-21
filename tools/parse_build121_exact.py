with open("game_file/src/app/localtb/config_server/build121.lua", "r", encoding="utf-8") as f:
    text = f.read()

import re

blocks = re.split(r";\(nil\)\.index\s*=\s*\d+", text)
table = {}
for b in blocks:
    m_lv = re.search(r"blv\s*=\s*[^,]+,\s*(\d+)", b)
    m_cap = re.search(r"capacity\s*=\s*[^,]+,\s*(\d+)", b)
    if m_lv and m_cap:
        lv = int(m_lv.group(1))
        cap = int(m_cap.group(1))
        table[lv] = cap

for lv in sorted(table.keys()):
    print(f"Level {lv}: {table[lv]:,}")
