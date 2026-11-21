# -*- coding: utf-8 -*-

target_total = 106370

# ret.total = S + floor(S * p)
# where p = buff_percent_add (in permille: p = buff_val / 1000.0)

print(f"Target ret.total: {target_total}")

# We know base = 87500, default = 1000.
# tech_add could be 12000, or something else.
# S = 87500 + 1000 + tech_add + buff_value_add + attrAdd + hero_add

# Let's check for integer permille p (from 0 to 200, i.e., 0% to 20%):
solutions = []
for p_permille in range(0, 500):
    p = p_permille / 1000.0
    # ret.total = S + floor(S * p)
    # So S <= 106370 / (1 + p)
    # Let's check S in a range around 106370 / (1 + p)
    S_est = int(target_total / (1 + p))
    for S in [S_est - 1, S_est, S_est + 1]:
        if S + int(S * p) == target_total:
            solutions.append((p_permille, S, target_total - S))

print(f"Found {len(solutions)} exact integer solutions:")
for p_permille, S, buff_add in solutions:
    # Check if S relates to 87500 or 100500:
    diff_from_100500 = S - 100500
    diff_from_88500 = S - 88500
    if abs(diff_from_100500) < 10000 or abs(diff_from_88500) < 10000:
        print(f"Permille: {p_permille:3d} ({p_permille/10.0:4.1f}%) | S = {S:6d} | buff_add = {buff_add:5d} | S - 100500 = {diff_from_100500:+5d} | S - 88500 = {diff_from_88500:+5d}")
