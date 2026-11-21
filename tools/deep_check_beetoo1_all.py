# -*- coding: utf-8 -*-
import json

with open('tools/beetoo1_full_init_data.json', 'r', encoding='utf-8') as f:
    b1 = json.load(f)

print("=== CHECKING HERO SKILLS IN BEETOO1 ===")
hl = b1.get('heroSysCtrl', {}).get('heroList', {})
for hid, h in sorted(hl.items(), key=lambda x: int(x[0])):
    if h.get('level', 0) > 1:
        print(f"Hero {hid} (lv {h.get('level')}, Q {h.get('quality')}):")
        print(f"  skills: {h.get('skillList')}")
        print(f"  star: {h.get('star')}, awake: {h.get('awake')}")

print("\n=== CHECKING BUFFS IN BEETOO1 ===")
buffCtrl = b1.get('buffCtrl')
print("buffCtrl:", buffCtrl)

print("\n=== CHECKING LORD SKILLS / TALENT ===")
lskill = b1.get('lordSkillCtrl')
print("lordSkillCtrl:", lskill)

print("\n=== CHECKING VIP ===")
vip = b1.get('vipCtrl')
print("vipCtrl:", vip)

print("\n=== CHECKING GOD ARMS / ARTIFACT / RUNES ===")
arms = b1.get('godArmsCtrl')
print("godArmsCtrl:", arms)

print("\n=== CHECKING PET / DIVINE BEAST ===")
pet = b1.get('petCtrl')
print("petCtrl:", pet)
