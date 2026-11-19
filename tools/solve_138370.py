# -*- coding: utf-8 -*-
import json

target = 138370
print(f"TARGET: {target}")

# In buildLogic.lua:
# base = 87500
# default = 1000
# tech_add = 12000
# attrAdd = attributeSystem.query(gAttributeEnum.DISPATCH_TROOP_COUNT_NUM)
# buff_value_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
# hero_add = heroCtrl:getTheActiveBuff(gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
# total_add = default + tech_add + buff_value_add + attrAdd + hero_add
# buff_percent_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST) / 1000
# buff_add = math.floor((base + total_add) * buff_percent_add)
# ret.total = base + total_add + buff_add

# In WorldDispatchArmyViewPanel.lua:
# allCount = ret.total + heroCount + armRuneCount + armyDivineBeastCount

# Let's search all possible integer combinations!
# If base = 87500, default = 1000, tech_add = 12000 => base + default + tech = 100500.
# If heroCount = 32000 (the 5 top heroes)
# Then 138370 - 32000 = 106370!
# If ret.total = 106370:
# 106370 - 100500 = 5870!
# Where does 5870 come from?
# Could buff_add be 5870?
# If buff_add = floor((base + total_add) * p) = 5870:
# If base + total_add = 100500: p = 5870 / 100500 = 0.05840796...
# What if base + total_add had an extra flat addition X?
# (100500 + X) * (1 + p) = 106370
# Let's test standard values for p (e.g. 1%, 2%, 3%, 5%, 10%, 15%, 20%, 50%):

print("\n--- Testing ret.total = 106370 (heroCount = 32000) ---")
for p_percent in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 15, 20, 25, 30, 50]:
    p = p_percent / 100.0
    # (100500 + X) * (1 + p) = 106370
    # 100500 + X = 106370 / (1 + p)
    flat = 106370 / (1 + p)
    X = flat - 100500
    if abs(X - round(X)) < 0.01:
        print(f"p = {p_percent}% => X = {round(X)}, base_flat = {round(flat)}")

# What if heroCount is NOT 32000?
# What if allCount = math.floor((base + total_add + heroCount) * (1 + p)) = 138370?
print("\n--- Testing percentage on (base + total_add + heroes) ---")
# If base + total_add + heroes = 132500 + X:
for p_percent in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 50]:
    p = p_percent / 100.0
    flat = 138370 / (1 + p)
    X = flat - 132500
    if abs(X - round(X)) < 0.01:
        print(f"p = {p_percent}% => X = {round(X)}, base_flat = {round(flat)}")
