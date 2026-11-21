import json
import os

with open('docs/beetoo1_live_memory.json', 'r', encoding='utf-8') as f:
    d = json.load(f)

print("=== CHECKING ALL 12 SOURCES IN BEETOO1 FOR 9000 ===")

# 1. Technologies
techs = d.get('technologyCtrl', {}).get('techlist', {})
print(f"\n1. Technology list ({len(techs)} techs):")
for tid, tlv in techs.items():
    print(f"   Tech {tid}: lv {tlv}")

# 2. Lord Skills
ls = d.get('lordSkillCtrl', {})
print(f"\n2. LordSkillCtrl:")
print(json.dumps(ls, ensure_ascii=False, indent=2)[:500])

# 3. Alliance Science
alli = d.get('allianceCtrl', {})
print(f"\n3. Alliance sciencelist:")
sci = alli.get('sciencelist', {})
print(json.dumps(sci, ensure_ascii=False, indent=2)[:500])

# 4. Building stars and mastery
city = d.get('cityCtrl', {})
print(f"\n4. City mastery:")
print(city.get('mastery'))
print("   Building stars > 0:")
for b in city.get('blist', []):
    bi = b.get('binfo', {})
    if int(bi.get('starLv', 0)) > 0:
        print(f"   Bid {bi.get('bid')}: lv={bi.get('lv')}, star={bi.get('starLv')}")

# 5. PetCtrl
pet = d.get('petCtrl', {})
print(f"\n5. PetCtrl:")
print(json.dumps(pet, ensure_ascii=False, indent=2)[:500])

# 6. Hero Biography
bio = d.get('heroBiographyCtrl', {})
print(f"\n6. HeroBiographyCtrl:")
print(json.dumps(bio, ensure_ascii=False, indent=2))

# 7. Nebula Tower
nt = d.get('nebulaTowerCtrl', {})
print(f"\n7. NebulaTowerCtrl:")
print(json.dumps(nt, ensure_ascii=False, indent=2))

# 8. Kingdom Level
kl = d.get('playerKingdomLevelCtrl', {})
print(f"\n8. PlayerKingdomLevelCtrl:")
print(json.dumps(kl, ensure_ascii=False, indent=2))

# 9. Miraculous Weapon
mw = d.get('miraculousWeaponCtrl', {})
print(f"\n9. MiraculousWeaponCtrl:")
print(json.dumps(mw, ensure_ascii=False, indent=2))

# 10. War Gem
wg = d.get('warGemCtrl', {})
print(f"\n10. WarGemCtrl:")
print(json.dumps(wg, ensure_ascii=False, indent=2)[:500])
