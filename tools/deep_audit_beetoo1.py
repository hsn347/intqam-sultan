import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    d1 = json.load(f)

print("=== Checking all possible bonus sources in beetoo1 ===")

# 1. equipmentCtrl
equip = d1.get("equipmentCtrl", {})
print("equipmentCtrl:", json.dumps(equip, indent=2)[:300])

# 2. petCtrl
pet = d1.get("petCtrl", {})
print("petCtrl:", json.dumps(pet, indent=2)[:300])

# 3. hero dresses / lieutenants
hlist = d1.get("heroSysCtrl", {}).get("heroList", {})
for hid, h in hlist.items():
    if h.get("dress") or h.get("weaponUid"):
        print(f"Hero {hid} dress/weapon:", h.get("dress"), h.get("weaponUid"))

# 4. runes or divine beast
for k in d1:
    if "rune" in k.lower() or "beast" in k.lower() or "god" in k.lower() or "divine" in k.lower() or "arm" in k.lower():
        print(f"Key matching rune/beast/arm: {k}")
