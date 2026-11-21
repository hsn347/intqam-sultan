import math

# Castle components
drill = 87500
tech = 12000
default = 1000
heroes = [7500, 7000, 7000, 7000, 6000] # sum = 34500
buff = 0.01 # 1.0%

results = {}

# Formula 1: Pure proportional
# (drill + tech + default + heroes) * 1.01 = 135000 * 1.01 = 136350
results["1. Standard all * 1.01"] = (drill + tech + default + sum(heroes)) * 1.01

# Formula 2: default is 100 instead of 1000 (like in osmanli)
# (drill + tech + 100 + heroes) * 1.01 = 134100 * 1.01 = 135441
results["2. default=100"] = (drill + tech + 100 + sum(heroes)) * 1.01

# Formula 3: default is NOT buffed
# (drill + tech + heroes) * 1.01 + 1000 = 134000 * 1.01 + 1000 = 136340
results["3. default not buffed"] = (drill + tech + sum(heroes)) * 1.01 + default

# Formula 4: heroes are NOT buffed
# (drill + tech + default) * 1.01 + heroes = 101505 + 34500 = 136005
results["4. heroes not buffed"] = math.floor((drill + tech + default) * 1.01) + sum(heroes)

# Formula 5: each hero is rounded or floored individually with buff
# floor(h * 1.01) for each h
h_buffed_floor = sum(math.floor(h * 1.01) for h in heroes)
results["5. heroes floored individually + castle"] = math.floor((drill + tech + default) * 1.01) + h_buffed_floor

# Formula 6: ceil on buff
results["6. ceil buff"] = math.ceil(135000 * 1.01)

# Formula 7: What if one of the heroes has quality/rarity slightly different?
# In hero_view_info.lua:
# Hero 1718: quality = 2 in beetoo1, but what if rarity is 2: 6000.
# What if Hero 1718 is level 60, but what if its base march is different?
# What about Hero 1717? Quality 5, level 60: 7500.

# Formula 8: What if Lord level adds march capacity?
# Lord level of beetoo1 is 51!
# Does Lord Level add march capacity in this game?
# Let's check!

for name, val in results.items():
    print(f"{name}: {val} (diff from 136350: {val - 136350})")
