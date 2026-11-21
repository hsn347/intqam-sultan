import json

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

print("Checking live memory keys:")
for k in d.keys():
    if any(term in k.lower() for term in ['rune', 'beast', 'pet', 'boe', 'attr', 'buff', 'army', 'hero', 'medal', 'build']):
        print(" ", k)

# Check boeAttributeCtrl
boe = d.get('boeAttributeCtrl', {})
print("\nboeAttributeCtrl:", boe)

# Check petCtrl
pet = d.get('petCtrl', {})
print("\npetCtrl keys:", list(pet.keys()))

# Check divineBeast / rune
for k in d.keys():
    if 'beast' in k.lower() or 'rune' in k.lower():
        print(f"\n{k}:", d[k])
