import json
import re

with open('game_file/localtb/local_arab.json', 'r', encoding='utf-8') as f:
    local_ar = json.load(f)

# Search for hero building names
matches = {}
for k, v in local_ar.items():
    if any(w in v for w in ["أبطال", "ابطال", "الأبطال"]):
        if any(b in v for b in ["قاعة", "مبنى", "قصر", "معبد", "برج", "صالة", "ساحة", "مجلس"]):
            matches[k] = v

for k, v in list(matches.items())[:30]:
    print(f"{k}: {v}")
