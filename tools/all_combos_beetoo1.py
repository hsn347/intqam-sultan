import itertools
import math

heroes = [
    ("1717", 7500),
    ("1711", 7000),
    ("1710", 7000),
    ("1704", 7000),
    ("1718", 6000),
    ("1712", 5550),
    ("1700", 4200),
    ("1707", 2877),
]

print("=== All 5-Hero Combinations for beetoo1 ===")
results = []
for combo in itertools.combinations(heroes, 5):
    h_sum = sum(h[1] for h in combo)
    tot_flat = 100500 + h_sum
    tot_buffed = math.floor(tot_flat * 1.01)
    # also try individual hero buffing:
    tot_indiv = 101505 + sum(math.floor(h[1] * 1.01) for h in combo)
    # unbuffed heroes:
    tot_unbuff_h = 101505 + h_sum
    names = "+".join(h[0] for h in combo)
    results.append((tot_buffed, tot_indiv, tot_unbuff_h, h_sum, names))

results.sort(key=lambda x: x[0], reverse=True)
for r in results:
    print(f"Total: {r[0]} (indiv: {r[1]}, unbuff_h: {r[2]}) | H_sum={r[3]} | Heroes: {r[4]}")
