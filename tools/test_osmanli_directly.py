import sys
sys.path.insert(0, 'E:/osmanli')
import json

from tasks.march_capacity import (
    get_castle_base_march_capacity,
    get_hero_march_bonus,
    get_castle_march_capacity,
    BUILD121_CAPACITY,
    HERO_QUALITY_MAP,
    HERO_QUALITY_MODULUS,
)

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', encoding='utf-8') as f:
    d2 = json.load(f)

print("=== Running exact Osmanli march_capacity.py ===")

# Base castle capacity from Osmanli
base1 = get_castle_base_march_capacity(d1)
base2 = get_castle_base_march_capacity(d2)
print(f"Osmanli Base Castle: beetoo1={base1}, beetoo2={base2}")

# Chosen heroes for beetoo2
b2_heroes = [1700, 1712, 1717, 1711, 1707]
tot2 = get_castle_march_capacity(d2, chosen_heroes=b2_heroes)
print(f"Osmanli Total beetoo2 with {b2_heroes}: {tot2}")

# Chosen heroes for beetoo1
b1_heroes_1718 = [1717, 1711, 1710, 1704, 1718]
tot1_1718 = get_castle_march_capacity(d1, chosen_heroes=b1_heroes_1718)
print(f"Osmanli Total beetoo1 with {b1_heroes_1718}: {tot1_1718}")

b1_heroes_1712 = [1717, 1711, 1710, 1704, 1712]
tot1_1712 = get_castle_march_capacity(d1, chosen_heroes=b1_heroes_1712)
print(f"Osmanli Total beetoo1 with {b1_heroes_1712}: {tot1_1712}")
