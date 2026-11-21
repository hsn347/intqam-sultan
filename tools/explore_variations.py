# Let's explore all possible calculations that give numbers close to 136350:

base = 87500
tech = 12000
default = 1000
heroes_34500 = [7500, 7000, 7000, 7000, 6000]

print("=== Possible Variations Around 136350 ===")

# Variation 1: Default cap is 100 instead of 1000:
# Total flat = 87500 + 100 + 12000 + 34500 = 134100
# 134100 * 1.01 = 135441 (too far)

# Variation 2: Default cap does not get buffed by percentage:
# (87500 + 12000 + 34500) * 1.01 + 1000 = 134000 * 1.01 + 1000 = 135340 + 1000 = 136340
# Diff = -10
print("Var 2 (Default unbuffed):", 134000 * 1.01 + 1000, "-> 136340 (diff -10)")

# Variation 3: Default is 0, but tech has something, or default is 900?

# Variation 4: Percentage buff is slightly different:
# What if the medal buff is 1.01? What if lord level gives a small buff?
# Let's check lord level in beetoo1:
# What is lord level in beetoo1?

# Variation 5: Individual hero rounding:
# 7500 * 1.01 = 7575
# 7000 * 1.01 = 7070
# 6000 * 1.01 = 6060
# All are exact integers, so no rounding difference there.

# Variation 6: What if the 5th hero is different?
# Could the 5th hero be 1718 with a different march_add?
# What if hero level is 60, but rarity 2 level 60 is NOT 6000?
# In hero_level_config.lua:
# Rarity 2, Level 60: is it 6000? Let's verify.
