import os
import glob
import re

modules = glob.glob("game_file/src/app/module/**/*.lua", recursive=True)

for m in sorted(modules):
    try:
        content = open(m, "r", encoding="utf-8").read()
    except Exception:
        continue
    
    idx = content.find("EnterGame")
    if idx != -1:
        eg_block = content[idx:idx+1500]
        # find serverproxy:Request(CMD, REQ)
        reqs = re.findall(r'serverproxy:Request\(([^)]+)\)', eg_block)
        if reqs:
            basename = os.path.basename(m)
            print(f"{basename}: {reqs}")
