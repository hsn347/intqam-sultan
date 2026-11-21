# -*- coding: utf-8 -*-
import json
import itertools

with open("tools/march_data_tables.json", "r", encoding="utf-8") as f:
    tables = json.load(f)

rare_levels = tables["rare_levels"]
meta = tables["heroes"]

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
        "cap": cap,
        "state": h.get("state", 1),
        "qual": h.get("quality", 1)
    }

print("Beetoo 1 hero capacities:")
for hid, h in sorted(heroes1.items(), key=lambda x: -x[1]["cap"]):
    print(f"Hero {hid}: cap={h['cap']}, lv={h['level']}, rarity={h['rarity']}, state={h['state']}")

# If Beetoo 2 was 138,370 = 137,000 * 1.01:
# What was Beetoo 2's base?
# 137,000 - 32,000 = 105,000!
# WAIT!
# 137,000 - 32,000 = 105,000!
# 105,000 is an exact, perfectly clean round number: ONE HUNDRED AND FIVE THOUSAND!
# (105,000 + 32,000) * 1.01 = 137,000 * 1.01 = 138,370!
print("\n" + "="*50)
print("CHECKING BASE 105,000 + HEROES:")
print(f"Beetoo 2: (105000 + 32000) * 1.01 = {137000 * 1.01}")

# If base is 105,000:
# For each 5-hero combination in Beetoo 1:
# Calculate (105000 + hero_sum) * 1.01
# And check which ones are close to 136,350!
print("\n" + "="*50)
print("TESTING ALL 5-HERO COMBINATIONS FOR BEETOO 1:")
print("="*50)

combos = []
all_hids = list(heroes1.keys())
for combo in itertools.combinations(all_hids, 5):
    h_sum = sum(heroes1[h]["cap"] for h in combo)
    # Formula 1: (105000 + h_sum) * 1.01
    val1 = (105000 + h_sum) * 1.01
    int_val1 = int(round(val1))
    
    # Formula 2: floor(105000 * 1.01) + h_sum = 106050 + h_sum
    val2 = 106050 + h_sum
    
    # Formula 3: 100500 base + h_sum + floor(...)
    # If unbuffed base was 100500, but there was another buff?
    
    diff_from_target = abs(int_val1 - 136350)
    combos.append({
        "heroes": combo,
        "h_sum": h_sum,
        "val1": val1,
        "int_val1": int_val1,
        "diff": diff_from_target
    })

combos.sort(key=lambda x: x["diff"])

print(f"Top 15 closest combinations to 136,350 using (105000 + h_sum) * 1.01:")
for c in combos[:15]:
    heroes_str = ", ".join(f"{h}({heroes1[h]['cap']})" for h in c["heroes"])
    print(f"Heroes: [{heroes_str}]")
    print(f"  h_sum = {c['h_sum']}, val1 = {c['val1']:.2f}, int = {c['int_val1']}, diff = {c['diff']}")
