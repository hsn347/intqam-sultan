# -*- coding: utf-8 -*-
import os
import re

def search_skills():
    path = "game_file/src/app/localtb/config_client/lordskilldes.lua"
    if not os.path.exists(path):
        print(f"File not found: {path}")
        return

    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()

    # Find blocks
    blocks = re.split(r'\[(\d+)\]\s*=\s*\{', content)
    print(f"Total skill entries found: {len(blocks)//2}")
    
    rally_skills = []
    for i in range(1, len(blocks), 2):
        sid = blocks[i]
        body = blocks[i+1]
        name_m = re.search(r'name\s*=\s*"([^"]+)"', body)
        des_m = re.search(r'des\s*=\s*"([^"]+)"', body)
        name = name_m.group(1) if name_m else ""
        des = des_m.group(1) if des_m else ""
        
        if "حشد" in name or "حشد" in des or "rally" in name.lower() or "rally" in des.lower():
            rally_skills.append((sid, name, des))

    print(f"Found {len(rally_skills)} skills mentioning 'حشد' or 'rally' in lordskilldes:")
    for sid, name, des in rally_skills:
        print(f"- ID: {sid} | Name: {name} | Description: {des}")

if __name__ == "__main__":
    search_skills()
