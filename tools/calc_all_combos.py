# -*- coding: utf-8 -*-
import json
import itertools

table = {
    (1, 60): 5000, (1, 48): 3700, (1, 41): 3000, (1, 28): 2060,
    (2, 60): 6000, (2, 48): 4440, (2, 41): 3600, (2, 28): 2466,
    (3, 60): 7000, (3, 48): 5180, (3, 41): 4200, (3, 28): 2877,
    (4, 60): 7000, (4, 48): 5180, (4, 41): 4200, (4, 28): 2877,
    (5, 60): 7500, (5, 48): 5550, (5, 41): 4500, (5, 28): 3086,
}

# Beetoo1 heroes:
heroes = [
    {"id": 1717, "lv": 60, "q": 5, "r": 2, "state": 3},
    {"id": 1711, "lv": 60, "q": 4, "r": 3, "state": 3},
    {"id": 1704, "lv": 60, "q": 3, "r": 2, "state": 3},
    {"id": 1710, "lv": 60, "q": 3, "r": 3, "state": 3},
    {"id": 1718, "lv": 60, "q": 2, "r": 2, "state": 1},
    {"id": 1712, "lv": 48, "q": 5, "r": 3, "state": 3},
    {"id": 1700, "lv": 41, "q": 4, "r": 1, "state": 1},
    {"id": 1707, "lv": 28, "q": 4, "r": 2, "state": 1},
]

# Base castle capacity
base_castle = 87500 + 12000 + 1000 # 100,500

print("=== CANDIDATE 5-HERO COMBINATIONS FOR BEETOO1 ===")
combos = list(itertools.combinations(heroes, 5))

results = []
for c in combos:
    ids = [h["id"] for h in c]
    # calculation by quality
    hero_add_q = sum(table[(h["q"], h["lv"])] for h in c)
    tot_q_101 = int((base_castle + hero_add_q) * 1.01)
    tot_q_unbuff = base_castle + hero_add_q
    tot_q_separate = int(base_castle * 1.01) + hero_add_q

    # calculation by rarity
    hero_add_r = sum(table[(h["r"], h["lv"])] for h in c)
    tot_r_101 = int((base_castle + hero_add_r) * 1.01)
    tot_r_separate = int(base_castle * 1.01) + hero_add_r

    results.append({
        "ids": ids,
        "hero_add_q": hero_add_q,
        "tot_q_101": tot_q_101,
        "tot_q_separate": tot_q_separate,
        "hero_add_r": hero_add_r,
        "tot_r_101": tot_r_101,
        "tot_r_separate": tot_r_separate,
    })

# filter for anything close to 136,350 (within 2000)
close = [r for r in results if any(abs(v - 136350) < 2000 for v in [r["tot_q_101"], r["tot_q_separate"], r["tot_r_101"], r["tot_r_separate"]])]

print(f"Total combinations: {len(results)}, Close to 136,350: {len(close)}")
for r in close:
    print(f"Heroes {r['ids']}:")
    print(f"  Quality (1.01): {r['tot_q_101']} (diff = {r['tot_q_101'] - 136350:+d})")
    print(f"  Quality (sep):  {r['tot_q_separate']} (diff = {r['tot_q_separate'] - 136350:+d})")
    print(f"  Rarity  (1.01): {r['tot_r_101']} (diff = {r['tot_r_101'] - 136350:+d})")
    print(f"  Rarity  (sep):  {r['tot_r_separate']} (diff = {r['tot_r_separate'] - 136350:+d})")
