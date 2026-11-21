import json
import itertools

b1 = json.load(open('tools/beetoo1_full_init_data.json', encoding='utf-8'))
b2 = json.load(open('tools/beetoo2_full_init_data.json', encoding='utf-8'))

# Base castle capacity
base_flat = 87500 + 1000 + 12000 # 100,500
achieve_mult = 0.01 # 1%

# Hero march values in Beetoo 1:
# Quality-based (as in base_task.py):
# 1717 (Q5, Lv60) -> 7500
# 1711 (Q4, Lv60) -> 7000
# 1704 (Q3, Lv60) -> 7000
# 1710 (Q3, Lv60) -> 7000
# 1718 (Q2, Lv60) -> 6000
# 1712 (Q5, Lv48) -> 5550
# 1700 (Q4, Lv41) -> 4200
# 1707 (Q4, Lv28) -> 2877
# 1709 (Q4, Lv1)  -> 700
# 1705 (Q3, Lv1)  -> 700
# 1708 (Q3, Lv1)  -> 700
# 1706 (Q3, Lv1)  -> 700
# 1701 (Q2, Lv1)  -> 600
# 1702 (Q2, Lv1)  -> 600
# 1703 (Q2, Lv1)  -> 600
# 1713 (Q1, Lv1)  -> 500
# 1714 (Q1, Lv1)  -> 500

heroes_b1_q = {
    1717: 7500,
    1711: 7000,
    1704: 7000,
    1710: 7000,
    1718: 6000,
    1712: 5550,
    1700: 4200,
    1707: 2877,
    1709: 700,
    1705: 700,
    1708: 700,
    1706: 700,
    1701: 600,
    1702: 600,
    1703: 600,
    1713: 500,
    1714: 500,
}

# Rarity-based (as in Lua client heroltCtrl:getHerosMarchCapacity with native rarity):
# If native rarity is used:
# What are native rarities of heroes?
# In hero_view_info.lua or client configs:
# Let's inspect native rarity of all these heroes.
