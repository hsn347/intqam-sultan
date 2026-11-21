import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

files_to_check = [
    r"src\app\localtb\config_server\weapon_config.lua",
    r"localtb\delta_patch_tables\weapon_config.lua",
    r"src\app\localtb\config_server\miraculous_resonance_config.lua",
    r"src\app\localtb\config_server\parliament_basic_policy.lua",
    r"src\app\localtb\config_read\foreignPavilionRead.lua",
    r"localtb\delta_patch_tables\war_stone_config.lua",
    r"src\app\localtb\config_server\war_stone_config.lua",
    r"localtb\delta_patch_tables\adventure_magic.lua",
    r"src\app\localtb\config_server\adventure_magic.lua",
    r"localtb\delta_patch_tables\military_rank_skill.lua"
]

def scan_file(relpath):
    fullpath = os.path.join(BASE_DIR, relpath)
    if not os.path.exists(fullpath):
        return
    print(f"\n======================================")
    print(f"FILE: {relpath}")
    print(f"======================================")
    with open(fullpath, 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    hits = []
    for idx, line in enumerate(lines):
        # search for 96 or 19 or 78 or 18 or attrType 5
        if re.search(r'\b(96|19|78|18)\b', line):
            # check if it looks like buffType, effectType, prop, attr, buff
            if any(k in line.lower() for k in ["buff", "effect", "prop", "type", "attr", "skill", "value"]):
                hits.append((idx+1, line.strip()))
    
    print(f"Total matching lines: {len(hits)}")
    for lno, text in hits[:25]:
        print(f"  L{lno}: {text}")

for f in files_to_check:
    scan_file(f)
