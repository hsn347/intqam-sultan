import itertools

heroes = {
    1712: 7000,
    1711: 7000,
    1717: 6000,
    1707: 6000,
    1708: 6000,
    1700: 6000,
    1703: 5000,
    1709: 5000,
    1706: 1000,
    1702: 1000,
    1713: 1000,
    1718: 1000,
    1714: 1000,
    1710: 1000,
    1704: 1000,
    1705: 1000,
    1701: 1000,
}

# Check all combinations of length 1..5
print("Checking hero sums...")
for r in range(1, 6):
    for combo in itertools.combinations(heroes.items(), r):
        s = sum(v for k, v in combo)
        if s in (36865, 36500, 32000, 37870):
            print(f"Match {s}: {[k for k, v in combo]}")

print("\nAll possible sums from 5 heroes:")
sums_5 = set()
for combo in itertools.combinations(heroes.items(), 5):
    sums_5.add(sum(v for k, v in combo))
print(sorted(sums_5))
