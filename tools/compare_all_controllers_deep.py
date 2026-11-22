import json
import os

with open("docs/beetoo1_live_memory.json", "r", encoding="utf-8") as f:
    b_data = json.load(f)

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    l_data = json.load(f)

print("=== 1. ACHIEVEMENTCTRL ===")
print("Beetoo1 list keys:", list(b_data.get("achievementctrl", {}).get("list", {}).keys()))
print("Beetoo1 m17:", b_data.get("achievementctrl", {}).get("list", {}).get("17"))
print("Lucifer list keys:", list(l_data.get("achievementctrl", {}).get("list", {}).keys()))
print("Lucifer m17:", l_data.get("achievementctrl", {}).get("list", {}).get("17"))

print("\n=== 2. MILITARY RANK CTRL ===")
print("Beetoo1 military:", b_data.get("militaryRankCtrl"))
print("Lucifer military:", l_data.get("militaryRankCtrl"))

print("\n=== 3. ALLIANCE CTRL ===")
b_all = b_data.get("allianceCtrl", {})
l_all = l_data.get("allianceCtrl", {})
print("Beetoo1 allianceKeys:", list(b_all.keys()) if isinstance(b_all, dict) else type(b_all))
print("Lucifer allianceKeys:", list(l_all.keys()) if isinstance(l_all, dict) else type(l_all))
if isinstance(l_all, dict):
    print("Lucifer science / skills:", l_all.get("science"), l_all.get("skills"), l_all.get("alData", {}).get("officialId"))

print("\n=== 4. PET CTRL ===")
b_pet = b_data.get("petCtrl", {})
l_pet = l_data.get("petCtrl", {})
print("Beetoo1 pet keys:", list(b_pet.keys()) if isinstance(b_pet, dict) else type(b_pet))
print("Lucifer pet keys:", list(l_pet.keys()) if isinstance(l_pet, dict) else type(l_pet))
if isinstance(l_pet, dict):
    print("Lucifer petTalentData:", l_pet.get("petTalentData"))
    print("Lucifer petList:", l_pet.get("petList"))

print("\n=== 5. EQUIPMENT CTRL ===")
b_eq = b_data.get("equipmentCtrl", {})
l_eq = l_data.get("equipmentCtrl", {})
print("Beetoo1 eq count:", len(b_eq.get("equipment_array", [])))
print("Lucifer eq count:", len(l_eq.get("equipment_array", [])))
if len(l_eq.get("equipment_array", [])) > 0:
    for eq in l_eq.get("equipment_array", []):
        if eq.get("wear") == 1:
            print("Lucifer worn eq:", eq.get("id"), eq.get("extra"))

print("\n=== 6. DRESS CTRL ===")
print("Beetoo1 dress:", b_data.get("dressCtrl"))
print("Lucifer dress:", l_data.get("dressCtrl"))

print("\n=== 7. BUFF CTRL ===")
print("Beetoo1 buffCtrl:", b_data.get("buffCtrl"))
print("Lucifer buffCtrl:", l_data.get("buffCtrl"))

print("\n=== 8. LORD SKILL CTRL ===")
print("Beetoo1 lordSkillCtrl:", b_data.get("lordSkillCtrl"))
print("Lucifer lordSkillCtrl:", l_data.get("lordSkillCtrl"))
