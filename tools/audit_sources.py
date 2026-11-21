import os
import re

root = r"e:\intqam-sultan\game_file\src"

sources = [
    "EQUIPMENT", "MILITARY", "PET", "KINGDOM_LEVEL", "WAR_GEM", "PARLIAMENT", 
    "LEGEND_TITLE", "HEGEMON_TITLE", "ALLIANCE_OFFICIAL", "ABEAST_BLESSING", 
    "HERO_CENOTAPH", "HERO_SYSTEM", "MIRACULOUS_WEAPON", "BUILD_MASTERY", 
    "GUARD_ACTIVITY", "BUILD_STAR", "ALLIANCE_PROSPERITY", "HERO_BIOGRAPHY", 
    "ANN20_CAMPFIRE", "SULTAN_BACK_REBATE", "KINGDOM_CHRONICLES", "ATLANTIS_PRIVILEGE", 
    "NEBULA_PRIVILEGE", "ATLANTIS_SKILL", "ALLIANCE_STRONGHOLD", "FOREIGN_PAVILION", 
    "ATLANTIS_WIN_SEASON", "PALACE_OF_WISDOM_ACTIVITY", "METEOR_MAGIC", 
    "NEBULA_WAR_FINISH_OCCUPY", "NEBULA_TOWER", "MAGIC_LAMP", "EQUIP_RESONANCE", 
    "NEBULA_EMPEROR_TITLE", "NEBULA_EMPEROR_WAR", "DIVINE_BEAST", "WAR_ORDER", 
    "WAR_HORN", "NEBULA_ALLSTAR_WAR", "HONOR_BACK_PRIVILEGES", "GHOLD_EMERGENCE", 
    "HERO_APPOINT", "ROARING_FLAME_WAR", "GARDEN", "NACKLACE_TEC", "ACHIEVEMENT", "ACTIVITY", "VIP"
]

print("=== Scanning which sources reference MARCH_VALUE_LIMIT_BOOST or MARCH_LIMIT_BOOST ===")

# Also check controllers mentioned in buffCtrl.lua
ctrl_methods = {
    "EQUIPMENT": ["equipmentAdditionMgr.queryByBuffEffectType", "equipmentMgr"],
    "EQUIP_RESONANCE": ["equipmentMgr.getWearWeaponEnhanceBuff"],
    "ACHIEVEMENT": ["achievementctrl:getBuffValue"],
    "ACTIVITY": ["activityBuffCtrl:getActivityBoost"],
    "MILITARY": ["militaryRankCtrl:getTotalBuffValue"],
    "PET": ["petCtrl:getPetAttributeAdd"],
    "KINGDOM_LEVEL": ["kingdomLevelDataModuleAPI:getBuff"],
    "WAR_GEM": ["warGemCtrl:getBuffPlus"],
    "PARLIAMENT": ["intetiorCtrl:getBuffPlus"],
    "LEGEND_TITLE": ["legendLordCtrl:getBuff", "kingStarCtrl:getBuff"],
    "HEGEMON_TITLE": ["hegemonCtrl:getBuff"],
    "ALLIANCE_OFFICIAL": ["allianceCtrl:getBuffEffect"],
    "ABEAST_BLESSING": ["alliancePetCtrl:getBuffEffect"],
    "HERO_CENOTAPH": ["heroCenotaphCtrl:getHeroCenotaphBuffEffect"],
    "HERO_SYSTEM": ["heroCtrl:getHeroTotalPassiveBuff"],
    "MIRACULOUS_WEAPON": ["miraculousWeaponCtrl:getBuffEffect"],
    "BUILD_MASTERY": ["cityCtrl:getBuildMasteryEffect"],
    "GUARD_ACTIVITY": ["guardianCtrl:getBuffEffect"],
    "BUILD_STAR": ["cityCtrl:getBuffEffect"],
    "ALLIANCE_PROSPERITY": ["allianceScience:getProsperityBuffEffect"],
    "HERO_BIOGRAPHY": ["heroBiographyCtrl:queryHeroBiographyBuff"],
    "SULTAN_BACK_REBATE": ["sultansBackRebateUtil.getBuffEffect"],
    "PRINCE_GIFT_ACTIVITY": ["princeGiftRead.getBuffEffect"],
    "PRINCE_GIFT_NEW": ["princeGiftNewCtrl:getBuffEffect"],
    "KINGDOM_CHRONICLES": ["legendMCtrl:getKingdomAchiBuffEffect"],
    "ATLANTIS_PRIVILEGE": ["atlantisPrivilegeCtrl:getBuff"],
    "NEBULA_PRIVILEGE": ["nebulaPrivilegeCtrl:getBuff"],
    "ATLANTIS_SKILL": ["atlantisActivityCtrl:getBuffEffect"],
    "ALLIANCE_STRONGHOLD": ["allianceStrontholdCtrl:getStrongholdBuffByType"],
    "FOREIGN_PAVILION": ["exoticPavilionCtrl:getBuffByType"],
    "ATLANTIS_WIN_SEASON": ["atlantisActivityCtrl:getPalaceBuffEffect"],
    "PALACE_OF_WISDOM_ACTIVITY": ["wiseTutorCtrl:getBuffVale", "artisanHouseCtrl:getBuffVale"],
    "METEOR_MAGIC": ["meteorMagicCtrl:getBuffEffect"],
    "NEBULA_WAR_FINISH_OCCUPY": ["nebulaActivityCtrl:getBuffEffect"],
    "NEBULA_TOWER": ["nebulaActivityCtrl:getNebulaTowerBuffEffect"],
    "MAGIC_LAMP": ["magicLampCtrl:getBuffEffect"],
    "NEBULA_EMPEROR_TITLE": ["nebulaEmperorCtrl:getTitleBuff"],
    "NEBULA_EMPEROR_WAR": ["nebulaEmperorCtrl:getBuffEffect"],
    "DIVINE_BEAST": ["divineBeastCtrl:getBuffEffect"],
    "WAR_ORDER": ["warOrderCtrl:getBuffVale"],
    "WAR_HORN": ["warHornCtrl:getBuffVale"],
    "RECHARGE_ACTIVITY": ["rechargeActivityCtrl:getRechargeBuffValue"],
    "ACTIVITY_9001565": ["activity_9001565_Ctrl:getBuffVale"],
    "NEBULA_ALLSTAR_WAR": ["nebulaAllStarCtrl:getBuffEffect"],
    "ACTIVITY_9001601": ["activity_9001601_Ctrl:getBuffVale"],
    "ACTIVITY_9001656": ["activity_9001656_Ctrl:getBuffVale"],
    "HERO_APPOINT": ["heroAppointCtrl:getBuffVale"],
    "ACTIVITY_9001683": ["activity_9001683_Ctrl:getBuffVale"],
    "ROARING_FLAME_WAR": ["roaringFlameWarCtrl:getBuffEffect"],
    "ACTIVITY_9001701": ["activity_9001701_Ctrl:getBuffVale"],
    "KOH_MIGRATE_HELP_9001708": ["activity_9001708_Ctrl:getBuffVale"],
    "GARDEN": ["manorCityCtrl:getBuffVale"],
    "NACKLACE_TEC": ["necklaceTecCtrl:getBuffVale"],
}

for src, methods in ctrl_methods.items():
    print(f"Checking Source: {src} -> methods: {methods}")
