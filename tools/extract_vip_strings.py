# -*- coding: utf-8 -*-
with open("game_file/localtb/delta_patch_tables/local_arab.lua", "rb") as f:
    data = f.read()

import re
# find all vip_Privilege_name_XXXX
pattern = rb"(vip_Privilege_name_\d+)"
pos = 0
for m in re.finditer(pattern, data):
    start = m.start()
    # slice surrounding 150 bytes
    chunk = data[start:start+150]
    # replace nulls with space
    clean = chunk.replace(b"\x00", b" ")
    try:
        decoded = clean.decode("utf-8", errors="ignore")
        print(decoded.strip())
    except Exception:
        pass
