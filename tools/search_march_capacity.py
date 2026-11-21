import os
import json
import re

print("--- Searching in local_arab for march capacity terms ---")
import os
import json
import re

local_arab_path = r"E:\intqam-sultan\game_file\localtb\local_arab.json"
if os.path.exists(local_arab_path):
    with open(local_arab_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    
    terms = ["مسيرة", "ساحة", "الحد الأقصى للجيش", "عدد الجنود", "سعة القوات"]
    matches = {}
    for k, v in data.items():
        if isinstance(v, str):
            for t in terms:
                if t in v:
                    matches[k] = (t, v)
                    break
    print(f"Found {len(matches)} matching strings in local_arab.json:")
    for k, (t, v) in list(matches.items())[:40]:
        print(f"  [{k}] ({t}) = {v}")

else:
    print("local_arab.json not found")
