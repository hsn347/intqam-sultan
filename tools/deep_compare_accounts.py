import json

with open('tools/beetoo1_full_init_data.json', encoding='utf-8') as f:
    d1 = json.load(f)

with open('tools/beetoo2_full_init_data.json', encoding='utf-8') as f:
    d2 = json.load(f)

print("=== Comparing beetoo1 vs beetoo2 ===")

# 1. Check all technology keys in d1 that are not in d2 or have different levels
t1 = d1.get('technologyCtrl', {})
t2 = d2.get('technologyCtrl', {})
diff_tech = {}
for k, v in t1.items():
    if t2.get(k) != v:
        diff_tech[k] = (v, t2.get(k))
print(f"Technology differences ({len(diff_tech)}):")
for k, (v1, v2) in diff_tech.items():
    print(f"  Tech {k}: beetoo1={v1}, beetoo2={v2}")

# 2. Check lord skill or talents
s1 = d1.get('lordSkillCtrl', {})
s2 = d2.get('lordSkillCtrl', {})
print("\nLordSkill beetoo1:", s1)
print("LordSkill beetoo2:", s2)

# 3. Check equipment
eq1 = d1.get('equipmentCtrl', {})
eq2 = d2.get('equipmentCtrl', {})
print("\nEquipment beetoo1 keys:", list(eq1.keys()))
print("Equipment beetoo2 keys:", list(eq2.keys()))

# 4. Check petCtrl
p1 = d1.get('petCtrl', {})
p2 = d2.get('petCtrl', {})
print("\nPet beetoo1:", p1)
print("Pet beetoo2:", p2)

# 5. Check walls / defense
w1 = d1.get('wallsCtrl', {})
w2 = d2.get('wallsCtrl', {})
print("\nWalls beetoo1:", w1)
print("Walls beetoo2:", w2)
