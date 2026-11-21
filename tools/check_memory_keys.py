import json
import os

candidates = [
    "docs/beetoo2_live_memory.json",
    "tools/beetoo2_full_init_data.json",
    "scratch/beetoo2_fresh_dump.json",
    "docs/LUCIFER@g4.coom_live_memory.json"
]

for fname in candidates:
    if os.path.exists(fname):
        with open(fname, "r", encoding="utf-8") as f:
            d = json.load(f)
        print("Found:", fname, "Keys count:", len(d))
        print("Equip keys:", [k for k in d.keys() if "equip" in k.lower()])
        print("Buff keys:", [k for k in d.keys() if "buff" in k.lower()])
        print("Talent keys:", [k for k in d.keys() if "talent" in k.lower() or "skill" in k.lower()])
        print("Lord keys:", [k for k in d.keys() if "lord" in k.lower()])
        print("Nebula keys:", [k for k in d.keys() if "nebula" in k.lower() or "tower" in k.lower()])
        print("All keys:", sorted(list(d.keys())))
        break
