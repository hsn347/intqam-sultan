# -*- coding: utf-8 -*-
import itertools

hero_adds = {
    1700: 5000,
    1701: 500,
    1702: 500,
    1703: 4880,
    1704: 600,
    1705: 600,
    1706: 600,
    1707: 6000,
    1708: 6000,
    1709: 4932,
    1710: 700,
    1711: 7000,
    1712: 7000,
    1713: 700,
    1714: 700,
    1717: 6000,
    1718: 600,
}

targets = [36500, 37870, 36865, 32000, 37000, 36000]

for k in range(1, 6):
    for combo in itertools.combinations(hero_adds.keys(), k):
        s = sum(hero_adds[h] for h in combo)
        for t in targets:
            if s == t:
                print(f"Match for target {t}: k={k}, heroes={combo}")
        # also check if 100500 + s + floor((100500 + s)*0.01) == 138370
        total_with_1pct = (100500 + s) + int((100500 + s) * 0.01)
        if total_with_1pct == 138370:
            print(f"!!! FOUND HERO COMBO FOR 138370 !!!: heroes={combo}, hero_sum={s}")
        # also check if 101505 + s == 138370
        if 101505 + s == 138370:
            print(f"!!! FOUND HERO COMBO FOR 101505 + s = 138370 !!!: heroes={combo}, hero_sum={s}")

print("Search complete.")
