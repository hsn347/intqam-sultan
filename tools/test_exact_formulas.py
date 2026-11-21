import math

# beetoo2 components:
# Base = 87500, Tech = 12000, Default = 1000 (or other)
# Heroes: 7500, 7500, 7500, 7000, 7000 (sum = 36500)
# Known Target for beetoo2 = 138370

# beetoo1 components:
# Base = 87500, Tech = 12000, Default = 1000
# 4 fixed heroes: 7500, 7000, 7000, 7000 (sum = 28500)
# 5th hero candidates:
# 1718: 6000 -> heroes sum = 34500
# 1712: 5550 -> heroes sum = 34050
# 1700: 4200 -> heroes sum = 32700
# 1707: 2877 -> heroes sum = 31377

def test_formulas():
    print("Testing mathematical formulas that yield EXACTLY 138370 for beetoo2:\n")
    
    b2_base = 87500
    b2_tech = 12000
    b2_heroes = [7500, 7500, 7500, 7000, 7000]
    
    b1_base = 87500
    b1_tech = 12000
    
    # Try different values of default_cap (1000, 100, 0)
    # Try different ways of rounding/flooring
    # Try different combinations
    
    formulas = []
    
    # Formula A: Total = floor((Base + Default + Tech + sum(Heroes)) * 1.01)
    for d in [1000, 100, 0]:
        tot_b2 = math.floor((b2_base + d + b2_tech + sum(b2_heroes)) * 1.01)
        if tot_b2 == 138370:
            formulas.append(('A', f'floor((Base + {d} + Tech + sum(H)) * 1.01)', lambda base, tech, heroes, d=d: math.floor((base + d + tech + sum(heroes)) * 1.01)))
            
        tot_b2_round = round((b2_base + d + b2_tech + sum(b2_heroes)) * 1.01)
        if tot_b2_round == 138370:
            formulas.append(('A_round', f'round((Base + {d} + Tech + sum(H)) * 1.01)', lambda base, tech, heroes, d=d: round((base + d + tech + sum(heroes)) * 1.01)))

    # Formula B: BaseCastle = floor((Base + Default + Tech) * 1.01), Heroes = sum(floor(H * 1.01))
    for d in [1000, 100, 0]:
        castle_b2 = math.floor((b2_base + d + b2_tech) * 1.01)
        h_b2 = sum(math.floor(h * 1.01) for h in b2_heroes)
        if castle_b2 + h_b2 == 138370:
            formulas.append(('B', f'floor((Base + {d} + Tech)*1.01) + sum(floor(H*1.01))', lambda base, tech, heroes, d=d: math.floor((base + d + tech) * 1.01) + sum(math.floor(h * 1.01) for h in heroes)))
            
        # with round for heroes
        h_b2_rnd = sum(round(h * 1.01) for h in b2_heroes)
        if castle_b2 + h_b2_rnd == 138370:
            formulas.append(('B_rnd', f'floor((Base + {d} + Tech)*1.01) + sum(round(H*1.01))', lambda base, tech, heroes, d=d: math.floor((base + d + tech) * 1.01) + sum(round(h * 1.01) for h in heroes)))

    # Formula C: BaseCastle = floor((Base + Tech) * 1.01) + Default, Heroes = sum(...)
    for d in [1000, 100, 0]:
        castle_b2 = math.floor((b2_base + b2_tech) * 1.01) + d
        h_b2 = sum(math.floor(h * 1.01) for h in b2_heroes)
        if castle_b2 + h_b2 == 138370:
            formulas.append(('C', f'floor((Base + Tech)*1.01) + {d} + sum(floor(H*1.01))', lambda base, tech, heroes, d=d: math.floor((base + tech) * 1.01) + d + sum(math.floor(h * 1.01) for h in heroes)))
            
    # Formula D: BaseCastle = floor((Base + Default + Tech) * 1.01), Heroes = floor(sum(H) * 1.01)
    for d in [1000, 100, 0]:
        castle_b2 = math.floor((b2_base + d + b2_tech) * 1.01)
        h_b2 = math.floor(sum(b2_heroes) * 1.01)
        if castle_b2 + h_b2 == 138370:
            formulas.append(('D', f'floor((Base + {d} + Tech)*1.01) + floor(sum(H)*1.01)', lambda base, tech, heroes, d=d: math.floor((base + d + tech) * 1.01) + math.floor(sum(heroes) * 1.01)))

    print(f"Found {len(formulas)} valid formulas matching beetoo2 = 138370:\n")
    for fid, desc, fn in formulas:
        print(f"[{fid}] {desc}")
        # Test on beetoo1 with 1718 (34500)
        b1_heroes_1718 = [7500, 7000, 7000, 7000, 6000]
        res_1718 = fn(b1_base, b1_tech, b1_heroes_1718)
        print(f"   -> beetoo1 with Hero 1718: {res_1718}")
        
        # Test on beetoo1 with 1712 (34050)
        b1_heroes_1712 = [7500, 7000, 7000, 7000, 5550]
        res_1712 = fn(b1_base, b1_tech, b1_heroes_1712)
        print(f"   -> beetoo1 with Hero 1712: {res_1712}")
        print()

if __name__ == "__main__":
    test_formulas()
