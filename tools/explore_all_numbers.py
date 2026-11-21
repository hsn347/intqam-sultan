import math

# Let's explore ALL possible variations of the formula:
# Castle:
# Drill grounds: 87500
# Tech: 12000
# Default: 1000 (or 100?)

# Beetoo1 heroes:
# What if the 5 heroes are:
# 1) [1717, 1711, 1710, 1704, 1718] => [7500, 7000, 7000, 7000, 6000] = 34500
# 2) [1717, 1711, 1710, 1704, 1712] => [7500, 7000, 7000, 7000, 5550] = 34050
# 3) What if Hero 1718 has quality 2, but level 60 with rarity 2 gives 6000...
#    Wait! What if hero quality 2 at level 60 is NOT 6000?
#    Let's check rare_levels table!
