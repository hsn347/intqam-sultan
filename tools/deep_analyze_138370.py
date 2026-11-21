import json

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

TARGET = 138370

print(f"=== DEEP ANALYSIS OF 138,370 FOR BEETOO1 ===")

# 1. Drill grounds
# Let's check drill grounds level and star
drill_cell = None
city = d.get('cityCtrl', {})
for b in city.get('blist', []):
    binfo = b.get('binfo', {})
    if str(binfo.get('bid')) == '121':
        drill_cell = binfo
        break
print("Drill grounds cell:", drill_cell)

# 2. Hero list and hero details
heroes = d.get('heroSysCtrl', {}).get('heroList', {})
print(f"Total heroes: {len(heroes)}")
for hid, h in heroes.items():
    print(f"  Hero {hid}: lv={h.get('level')}, state={h.get('state')}, quality={h.get('quality')}, isAwake={h.get('isAwake')}")

# 3. Best 2 heroes vs Best 5 heroes:
# If 2 heroes are selected:
# What if 2 heroes = 7000 + 7000 = 14000?
# What if 5 heroes = 32000?
# What if 138370 - 32000 = 106370?
# What if 138370 - 14000 = 124370?

# 4. Check all numbers in beetoo1_live_memory that could sum or multiply to 138370:
# Let's search if 138370 or any component appears anywhere in memory:
def search_numbers(obj, path=""):
    found = []
    if isinstance(obj, dict):
        for k, v in obj.items():
            found.extend(search_numbers(v, f"{path}.{k}"))
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            found.extend(search_numbers(v, f"{path}[{i}]"))
    elif isinstance(obj, (int, float)):
        if obj in [138370, 37870, 5870, 106370, 9090, 27500, 40500]:
            found.append((path, obj))
    return found

print("\nNumbers in memory matching key values:")
for p, val in search_numbers(d):
    print(f"  {p} = {val}")
