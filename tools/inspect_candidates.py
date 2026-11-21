import os, re

BASE_DIR = r"e:\intqam-sultan\game_file"

def find_file(fname):
    for root, dirs, files in os.walk(BASE_DIR):
        if fname.lower() in [f.lower() for f in files]:
            for f in files:
                if f.lower() == fname.lower():
                    return os.path.join(root, f)
    return None

candidates = [
    "military_rank_skill.lua",
    "adventure_magic.lua",
    "divine_beast_attribute_config.lua",
    "war_stone_config.lua",
    "war_stone_describe.lua",
    "foreign_pavilion.lua",
    "miraculous_weapon.lua",
    "miraculous_weapon_skill.lua",
    "intetior_policy.lua",
    "intetior_decree.lua",
    "intetior_official.lua",
    "alliance_science.lua",
    "alliance_stronghold.lua",
]

for c in candidates:
    p = find_file(c)
    if not p:
        print(f"[-] {c}: NOT FOUND")
        continue
    with open(p, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Check for 96, 19, 78, 18, 5
    m96 = re.findall(r'(\b(?:buffType|effectType|buff_type|prop_id|property_id|attrType|buff|type)\s*[:=]\s*96\b|\b96\b)', content)
    m19 = re.findall(r'(\b(?:buffType|effectType|buff_type|prop_id|property_id|attrType|buff|type)\s*[:=]\s*19\b)', content)
    m78 = re.findall(r'(\b(?:buffType|effectType|buff_type|prop_id|property_id|attrType|buff|type|id)\s*[:=]\s*78\b)', content)
    m18 = re.findall(r'(\b(?:buffType|effectType|buff_type|prop_id|property_id|attrType|buff|type|id)\s*[:=]\s*18\b)', content)
    m5 = re.findall(r'(\b(?:attrType|attrID|attributeType)\s*[:=]\s*(?:5|3)\b)', content)

    print(f"[+] {c}: len={len(content)} | 96={len(m96)} | 19={len(m19)} | 78={len(m78)} | 18={len(m18)} | attr={len(m5)}")

