# -*- coding: utf-8 -*-
import re

content = open("game_file/src/app/localtb/config_client/vipprivilege.lua", "r", encoding="utf-8").read()
# match each entry block
blocks = content.split("index =")
for b in blocks[1:]:
    id_m = re.search(r"id\s*=\s*(\d+)", b)
    name_m = re.search(r"name\s*=\s*[\"']([^\"']+)[\"']", b)
    if id_m and name_m:
        print(f"ID {id_m.group(1)}: {name_m.group(1)}")
