# -*- coding: utf-8 -*-
import json

with open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8") as f:
    d = json.load(f)

tctrl = d.get("technologyCtrl", {})
print(f"Total researched technologies in Beetoo2: {len(tctrl)}")
for k, v in sorted(tctrl.items(), key=lambda x: str(x[0])):
    print(f"  Tech {k}: {v}")
