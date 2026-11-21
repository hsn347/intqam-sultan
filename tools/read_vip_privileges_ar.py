# -*- coding: utf-8 -*-
with open("game_file/localtb/delta_patch_tables/local_arab.lua", "r", encoding="utf-8", errors="ignore") as f:
    text = f.read()

import re
matches = re.findall(r"(vip_Privilege_name_\d+)[\s\xa0]+([^\r\n\t]+)", text)
for k, v in matches:
    # take first 40 chars
    print(f"{k}: {v[:50].strip()}")
