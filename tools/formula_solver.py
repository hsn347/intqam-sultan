import math

# beetoo2 parameters:
b2_drill = 87500
b2_tech = 12000
b2_default = 1000
b2_heroes = [7500, 7500, 7500, 7000, 7000] # sum = 36500
b2_target = 138370

# beetoo1 parameters:
b1_drill = 87500
b1_tech = 12000
b1_default = 1000
b1_heroes = [7500, 7000, 7000, 7000, 6000] # sum = 34500

print(f"Target beetoo2: {b2_target}")

# Let's test various mathematical formulas F(drill, tech, default, heroes, buff)
# where buff = 0.01

formulas = [
    ("Standard: floor((drill + tech + default + sum(h)) * (1 + buff))",
     lambda d, t, deflt, h, b: math.floor((d + t + deflt + sum(h)) * (1 + b))),
    
    ("Heroes buffed separately: floor((d + t + deflt) * (1+b)) + sum(floor(x * (1+b)) for x in h)",
     lambda d, t, deflt, h, b: math.floor((d + t + deflt) * (1+b)) + sum(math.floor(x * (1+b)) for x in h)),
    
    ("Heroes buffed with round: floor((d + t + deflt) * (1+b)) + sum(round(x * (1+b)) for x in h)",
     lambda d, t, deflt, h, b: math.floor((d + t + deflt) * (1+b)) + sum(round(x * (1+b)) for x in h)),

    ("Sum heroes buffed then floored: floor((d + t + deflt) * (1+b)) + floor(sum(h) * (1+b))",
     lambda d, t, deflt, h, b: math.floor((d + t + deflt) * (1+b)) + math.floor(sum(h) * (1+b))),

    ("Default outside buff: floor((d + t + sum(h)) * (1+b)) + deflt",
     lambda d, t, deflt, h, b: math.floor((d + t + sum(h)) * (1+b)) + deflt),

    ("Only castle buffed: floor((d + t + deflt) * (1+b)) + sum(h)",
     lambda d, t, deflt, h, b: math.floor((d + t + deflt) * (1+b)) + sum(h)),

    ("Only drill grounds buffed: floor(d * (1+b)) + t + deflt + sum(h)",
     lambda d, t, deflt, h, b: math.floor(d * (1+b)) + t + deflt + sum(h)),
]

for name, fn in formulas:
    val2 = fn(b2_drill, b2_tech, b2_default, b2_heroes, 0.01)
    val1 = fn(b1_drill, b1_tech, b1_default, b1_heroes, 0.01)
    match2 = (val2 == b2_target)
    print(f"\nFormula: {name}")
    print(f"  beetoo2: {val2} (Matches target: {match2})")
    print(f"  beetoo1: {val1} (Diff from 136350: {val1 - 136350})")
