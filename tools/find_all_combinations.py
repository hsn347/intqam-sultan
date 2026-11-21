# -*- coding: utf-8 -*-
import json
import itertools

# Load tables
with open("tools/march_data_tables.json", "r", encoding="utf-8") as f:
    tables = json.load(f)

rare_levels = tables["rare_levels"]

# Load beetoo2 heroes
d2 = json.load(open("tools/beetoo2_full_init_data.json", "r", encoding="utf-8"))
heroes2_raw = d2["heroSysCtrl"]["heroList"]

# Hero rarities from meta
meta = tables["heroes"]

heroes2 = {}
for hid_str, h in heroes2_raw.items():
    hid = int(hid_str)
    r = meta.get(str(hid), {}).get("rarity", 1)
    lv = h.get("level", 1)
    cap = rare_levels.get(str(r), {}).get(str(lv), 0)
    heroes2[hid] = {
        "rarity": r,
        "level": lv,
        "quality": h.get("quality", 1),
        "state": h.get("state", 1),
        "cap": cap,
        "isAwake": h.get("isAwake", False)
    }

print("=== BEETOO 2 ALL HERO CAPACITIES ===")
for hid, h in sorted(heroes2.items(), key=lambda x: -x[1]["cap"]):
    print(f"Hero {hid}: Rarity {h['rarity']}, Lv {h['level']}, Quality {h['quality']}, Cap={h['cap']}, State={h['state']}, Awake={h['isAwake']}")

# Load beetoo1 heroes
d1 = json.load(open("tools/beetoo1_full_init_data.json", "r", encoding="utf-8"))
heroes1_raw = d1["heroSysCtrl"]["heroList"]
heroes1 = {}
for hid_str, h in heroes1_raw.items():
    hid = int(hid_str)
    r = meta.get(str(hid), {}).get("rarity", 1)
    lv = h.get("level", 1)
    cap = rare_levels.get(str(r), {}).get(str(lv), 0)
    heroes1[hid] = {
        "rarity": r,
        "level": lv,
        "quality": h.get("quality", 1),
        "state": h.get("state", 1),
        "cap": cap,
        "isAwake": h.get("isAwake", False)
    }

print("\n=== BEETOO 1 ALL HERO CAPACITIES ===")
for hid, h in sorted(heroes1.items(), key=lambda x: -x[1]["cap"]):
    print(f"Hero {hid}: Rarity {h['rarity']}, Lv {h['level']}, Quality {h['quality']}, Cap={h['cap']}, State={h['state']}, Awake={h['isAwake']}")
