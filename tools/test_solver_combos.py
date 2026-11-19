import json

# Let's inspect everything we know about beetoo2:
# Drill grounds base:
# Lv 27: 87500
# Default: 1000
# Researched tech:
# Type 43 (SINGLE_TROOP_STRENGTH): 12000
# Base sum so far = 87500 + 1000 + 12000 = 100500.

# Medal buff: 1% (achieveadd = 0.01)
# Beetoo2 heroes:
# 1712: rarity 3, lv 60 -> march_add = 7000
# 1711: rarity 3, lv 60 -> march_add = 7000
# 1717: rarity 2, lv 60 -> march_add = 6000
# 1707: rarity 2, lv 60 -> march_add = 6000
# 1708: rarity 2, lv 60 -> march_add = 6000
# Other heroes...

# We know:
# 138370 / 1.01 = 137000.0 ! EXACT INTEGER!
# 137000 - 100500 = 36500.
# If 5 heroes = 32000 (7000+7000+6000+6000+6000), then remaining = 4500.
# If 2 heroes (7000+7000=14000), then remaining = 22500.
# What if 138370 is NOT (137000 * 1.01)?
# Could 138370 = totoalCount + heroCount?
# E.g. totoalCount = floor(X * 1.01), and heroCount = Y?
# Let's check:
# If totoalCount = floor(100500 * 1.01) = 101505.
# Then heroCount + runes + beast = 138370 - 101505 = 36865.
# Or if totoalCount = floor((100500 + Z) * 1.01)...

print("Testing permutations...")
for base_flat in [100500, 100500 + 4500, 100500 + 5000, 100500 + 2000]:
    for buff_pct in [0, 0.01]:
        mult = int(base_flat * (1 + buff_pct))
        diff = 138370 - mult
        print(f"base_flat={base_flat}, mult={mult}, diff={diff}")
