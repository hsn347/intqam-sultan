import math

# Let's test with exact osmanli logic:
# base_castle_cap = 87500 + 13000 + floor(100500 * 0.01) = 100500 + 1005 = 101505

# For beetoo2 heroes: [7500, 7500, 7500, 7000, 7000]
# Each hero: round(h * 1.01)
# 7500 * 1.01 = 7575
# 7000 * 1.01 = 7070
# Total heroes = 7575*3 + 7070*2 = 22725 + 14140 = 36865
# total_capacity = 101505 + 36865 = 138370 (Exact for beetoo2!)

# For beetoo1 heroes:
# Hero 1717: 7500 * 1.01 = 7575
# Hero 1711: 7000 * 1.01 = 7070
# Hero 1710: 7000 * 1.01 = 7070
# Hero 1704: 7000 * 1.01 = 7070
# Hero 1718: 6000 * 1.01 = 6060
# Total heroes = 7575 + 7070*3 + 6060 = 34845
# total_capacity = 101505 + 34845 = 136350!

print("Total with 1718:", 101505 + 34845)
