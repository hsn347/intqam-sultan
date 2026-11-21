# -*- coding: utf-8 -*-
import re
import json

with open("game_file/src/app/localtb/config_server/hero_dress_server.lua", "r", encoding="utf-8") as f:
    text = f.read()

# Let's split by dressId =
entries = text.split("dressId =")
print(f"Total entries: {len(entries)}")

dress_map = {}

for e in entries[1:]:
    # get dressId
    m_id = re.match(r"\s*(\d+)", e)
    if not m_id:
        continue
    did = int(m_id.group(1))
    
    # check heroID
    m_hero = re.search(r"heroID\s*=\s*(?:nil,\s*)*(\d+)", e)
    hid = int(m_hero.group(1)) if m_hero else None
    
    # check defaultDress
    m_def = re.search(r"defaultDress\s*=\s*(\d+)", e)
    is_default = int(m_def.group(1)) if m_def else 0
    
    # parse getBuff
    # e.g.: getBuff, (nil)[1] = nil, nil, 96
    # getBuff, (nil)[2] = nil, nil, 2000
    buff_pairs = re.findall(r"getBuff.*?\[(\d+)\]\s*=\s*(?:nil,\s*)*(\d+)", e)
    # pair them
    buff_dict = {}
    if buff_pairs:
        # sort by index
        sorted_pairs = sorted([(int(k), int(v)) for k, v in buff_pairs], key=lambda x: x[0])
        # chunk into pairs (id, val)
        vals = [v for idx, v in sorted_pairs]
        for i in range(0, len(vals)-1, 2):
            b_id = vals[i]
            b_val = vals[i+1]
            buff_dict[b_id] = b_val
            
    if 96 in buff_dict:
        dress_map[did] = {
            "dress_id": did,
            "hero_id": hid,
            "march_flat_boost": buff_dict[96],
            "all_buffs": buff_dict
        }

print(f"Found {len(dress_map)} hero dresses providing effect 96 (MARCH_VALUE_LIMIT_BOOST):")
for did, info in sorted(dress_map.items()):
    print(f"  • Dress {did} (Hero {info['hero_id']}): +{info['march_flat_boost']:,} troops")

# save to json
with open("tools/hero_dress_march_buffs.json", "w", encoding="utf-8") as out:
    json.dump({str(k): v["march_flat_boost"] for k, v in dress_map.items()}, out, indent=2)
print("Saved to tools/hero_dress_march_buffs.json")
