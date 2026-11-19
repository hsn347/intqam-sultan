# -*- coding: utf-8 -*-
import math

target = 138370
print(f"Target: {target}")

# Possible bases:
# Base 1: 87500 (Drill grounds) + 1000 (default) + 12000 (tech) = 100,500
# Heroes = 32,000
# Total flat = 132,500

# Let's check differences:
print("target - 132500 =", target - 132500)  # 5870
print("target - 100500 =", target - 100500)  # 37870

# Check percentage on 100,500:
# 100500 * (1 + p) + 32000 = 138370 => 100500 * p = 5870 => p = 5870 / 100500 = 0.0584079... (not a round permille: 58.4 permille?)
# What about (100500 + 32000) * (1 + p) = 138370 => 132500 * p = 5870 => p = 5870 / 132500 = 0.0443018...

# What if heroes give MORE than 32000?
# Or what if some buff gives a flat amount + percentage?
# Let's check all factors of 5870:
# 5870 = 10 * 587 (587 is prime!)
