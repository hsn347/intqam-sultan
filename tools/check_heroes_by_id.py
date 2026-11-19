with open(r"e:\intqam-sultan\game_file\src\app\localtb\config_client\hero_view_info.lua", "r", encoding="utf-8", errors="ignore") as f:
    content = f.read()

import re
heroes = [1711, 1708, 1709, 1706, 1713, 1704]
for h in heroes:
    idx = content.find(f";(nil).id = {h}\n")
    if idx == -1:
        idx = content.find(f"id = {h}")
    if idx != -1:
        print(f"Hero {h}:")
        print(content[idx:idx+250])
    else:
        print(f"Hero {h} not found by id")
