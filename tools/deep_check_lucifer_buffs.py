import json
import os

lucifer = json.load(open('docs/lucifer_live_memory.json', encoding='utf-8'))

print("=== CHECKING ALL CONTROLLERS IN LUCIFER FOR BUFFS & MARCH ===")

# 1. Check buffCtrl
buff_ctrl = lucifer.get("buffCtrl", {})
print("buffCtrl keys:", list(buff_ctrl.keys()) if isinstance(buff_ctrl, dict) else type(buff_ctrl))
print("buffCtrl content:", buff_ctrl)

# 2. Check militaryRankCtrl
mil = lucifer.get("militaryRankCtrl", {})
print("militaryRankCtrl:", mil)

# 3. Check cityCtrl build mastery & build stars
city = lucifer.get("cityCtrl", {})
print("cityCtrl mastery:", city.get("mastery"))

# 4. Check dressCtrl
dress = lucifer.get("dressCtrl", {})
print("dressCtrl keys:", list(dress.keys()) if isinstance(dress, dict) else type(dress))
if isinstance(dress, dict):
    print("dressCtrl active / list:", dress.get("activeDress"), dress.get("dressList"))

# 5. Check equipmentCtrl
eq = lucifer.get("equipmentCtrl", {})
print("equipmentCtrl keys:", list(eq.keys()) if isinstance(eq, dict) else type(eq))

# 6. Check warGemCtrl
wg = lucifer.get("warGemCtrl", {})
print("warGemCtrl keys:", list(wg.keys()) if isinstance(wg, dict) else type(wg))

# 7. Check miraculousWeaponCtrl
mw = lucifer.get("miraculousWeaponCtrl", {})
print("miraculousWeaponCtrl:", mw)

# 8. Check heroBiographyCtrl
hb = lucifer.get("heroBiographyCtrl", {})
print("heroBiographyCtrl activeSkillList:", hb.get("activeSkillList"))

# 9. Check nebulaTowerCtrl
nt = lucifer.get("nebulaTowerCtrl", {})
print("nebulaTowerCtrl:", nt)

# 10. Check playerKingdomLevelCtrl
pkl = lucifer.get("playerKingdomLevelCtrl", {})
print("playerKingdomLevelCtrl:", pkl)
