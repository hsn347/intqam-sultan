# -*- coding: utf-8 -*-
import json

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d = json.load(f)

# check for any lieutenant in init_data
txt = json.dumps(d)
for kw in ['lieutenant', 'heroCombos', 'deputy', 'subHero']:
    if kw in txt:
        print(f"Found keyword '{kw}' in init_data!")
