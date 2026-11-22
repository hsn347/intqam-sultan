import json

with open("docs/lucifer_live_memory.json", "r", encoding="utf-8") as f:
    data = json.load(f)

print("=== 1. Equipment count:", len(data.get("equipmentCtrl", {}).get("equipment_array", [])))
for item in data.get("equipmentCtrl", {}).get("equipment_array", []):
    if item.get("wear") == 1:
        print("  Wearing:", item)

print("\n=== 2. Pets:", len(data.get("petCtrl", {}).get("petList", {})))

print("\n=== 3. Alliance:", data.get("allianceCtrl", {}).get("allianceInfo", {}).get("property", {}).get("name"))

print("\n=== 4. City blist count:", len(data.get("cityCtrl", {}).get("blist", [])))
for b in data.get("cityCtrl", {}).get("blist", []):
    binfo = b.get("binfo", {})
    if str(binfo.get("bid")) in ["121", "101", "301", "116"]:
        print("  Building:", binfo)

print("\n=== 5. Military Rank:", data.get("militaryRankCtrl", {}).get("level"), data.get("militaryRankCtrl", {}).get("curRank"))

print("medal 17:", data.get("achievementctrl", {}).get("list", {}).get("17"))



print("\n=== 7. Hero Biography:", data.get("heroBiographyCtrl", {}).get("activeSkillList"))

print("\n=== 8. Kingdom Level:", data.get("playerKingdomLevelCtrl", {}))

print("\n=== 9. Nebula Tower:", data.get("nebulaTowerCtrl", {}))

print("\n=== 10. War Gems:", data.get("warGemCtrl", {}))

print("\n=== 11. Technologies:", data.get("technologyCtrl", {}))
