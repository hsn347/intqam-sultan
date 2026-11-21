import os
import re
import json

GAME_DIR = r"e:\intqam-sultan\game_file"

# We want to check all modules in src/app/module/
# and all configs in src/app/localtb/

MODULES_DIR = os.path.join(GAME_DIR, "src", "app", "module")
CONFIG_SERVER_DIR = os.path.join(GAME_DIR, "src", "app", "localtb", "config_server")
CONFIG_CLIENT_DIR = os.path.join(GAME_DIR, "src", "app", "localtb", "config_client")
CONFIG_READ_DIR = os.path.join(GAME_DIR, "src", "app", "localtb", "config_read")
DELTA_DIR = os.path.join(GAME_DIR, "localtb", "delta_patch_tables")

def scan_all_controllers_for_sources():
    """
    Check all methods called in buffCtrl:getBuffEffectFromSource:
    - equipmentAdditionMgr.queryByBuffEffectType
    - equipmentMgr.getWearWeaponEnhanceBuff
    - achievementctrl:getBuffValue
    - activityBuffCtrl:getActivityBoost
    - militaryRankCtrl:getTotalBuffValue
    - petCtrl:getPetAttributeAdd
    - kingdomLevelDataModuleAPI:getBuff
    - warGemCtrl:getBuffPlus
    - intetiorCtrl:getBuffPlus
    - legendLordCtrl:getBuff / kingStarCtrl:getBuff
    - hegemonCtrl:getBuff
    - allianceCtrl:getBuffEffect
    - alliancePetCtrl:getBuffEffect
    - heroCenotaphCtrl:getHeroCenotaphBuffEffect
    - miraculousWeaponCtrl:getBuffEffect
    - cityCtrl:getBuildMasteryEffect / cityCtrl:getBuffEffect
    - guardianCtrl:getBuffEffect
    - allianceScience:getProsperityBuffEffect
    - heroBiographyCtrl:queryHeroBiographyBuff
    - sultansBackRebateUtil.getBuffEffect
    - princeGiftRead.getBuffEffect / princeGiftNewCtrl:getBuffEffect
    - legendMCtrl:getKingdomAchiBuffEffect
    - atlantisPrivilegeCtrl:getBuff / nebulaPrivilegeCtrl:getBuff / atlantisActivityCtrl:getBuffEffect
    - allianceStrontholdCtrl:getStrongholdBuffByType
    - exoticPavilionCtrl:getBuffByType
    - wiseTutorCtrl:getBuffVale / artisanHouseCtrl:getBuffVale
    - meteorMagicCtrl:getBuffEffect
    - nebulaActivityCtrl:getNebulaTowerBuffEffect
    - magicLampCtrl:getBuffEffect
    - nebulaEmperorCtrl:getTitleBuff / nebulaEmperorCtrl:getBuffEffect
    - divineBeastCtrl:getBuffEffect
    - warOrderCtrl:getBuffVale / warHornCtrl:getBuffVale
    - rechargeActivityCtrl:getRechargeBuffValue
    - heroAppointCtrl:getBuffVale
    - manorCityCtrl:getBuffVale
    - necklaceTecCtrl:getBuffVale
    """
    sources_to_check = [
        ("equipmentAdditionMgr", "src/app/module/equipment/equipmentAdditionMgr.lua"),
        ("equipmentMgr", "src/app/module/equipment/equipmentMgr.lua"),
        ("militaryRankCtrl", "src/app/module/militaryRank/militaryRankCtrl.lua"),
        ("petCtrl", "src/app/module/pet/petCtrl.lua"),
        ("petltCtrl", "src/app/localtb/config_read/petltCtrl.lua"),
        ("kingdomLevel", "src/app/module/lord/kingdomLevelDataModuleAPI.lua"),
        ("warGemCtrl", "src/app/module/warGem/warGemCtrl.lua"),
        ("wargemResRead", "src/app/localtb/config_read/wargemResRead.lua"),
        ("intetiorCtrl", "src/app/module/parliament/intetiorCtrl.lua"),
        ("legendLordCtrl", "src/app/module/legendLord/legendLordCtrl.lua"),
        ("kingStarCtrl", "src/app/module/kingStar/kingStarCtrl.lua"),
        ("hegemonCtrl", "src/app/module/hegemon/hegemonCtrl.lua"),
        ("allianceCtrl", "src/app/module/alliance/allianceCtrl.lua"),
        ("alliancePetCtrl", "src/app/module/alliance/alliancePetCtrl.lua"),
        ("heroCenotaphCtrl", "src/app/module/hero/heroCenotaphCtrl.lua"),
        ("miraculousWeaponCtrl", "src/app/module/miraculousWeapon/miraculousWeaponCtrl.lua"),
        ("cityCtrl", "src/app/module/city/cityCtrl.lua"),
        ("allianceScience", "src/app/module/alliance/allianceScience.lua"),
        ("heroBiographyCtrl", "src/app/module/hero/heroBiographyCtrl.lua"),
        ("legendMCtrl", "src/app/module/legendMCtrl/legendMCtrl.lua"),
        ("allianceStrontholdCtrl", "src/app/module/alliance/allianceStrontholdCtrl.lua"),
        ("exoticPavilionCtrl", "src/app/module/exoticPavilion/exoticPavilionCtrl.lua"),
        ("meteorMagicCtrl", "src/app/module/meteor/meteorMagicCtrl.lua"),
        ("nebulaActivityCtrl", "src/app/module/nebula/nebulaActivityCtrl.lua"),
        ("magicLampCtrl", "src/app/module/magicLamp/magicLampCtrl.lua"),
        ("divineBeastCtrl", "src/app/module/divineBeast/divineBeastCtrl.lua"),
        ("heroAppointCtrl", "src/app/module/hero/heroAppointCtrl.lua"),
        ("manorCityCtrl", "src/app/module/manor/manorCityCtrl.lua"),
        ("dressMgr", "src/app/module/dress/dressMgr.lua"),
        ("talentSkillCtrl", "src/app/module/talentSkill/talentSkillCtrl.lua"),
        ("godArmsCtrl", "src/app/module/equipment/godArmsCtrl.lua"),
        ("equipmentCell", "src/app/module/equipment/equipmentCell.lua"),
    ]

    print("Checking each controller for references to 96, 19, 78, 18, 5, MARCH_VALUE_LIMIT_BOOST, MARCH_LIMIT_BOOST, DISPATCH_TROOP_COUNT_NUM...")
    
    found_info = {}
    for name, rel_path in sources_to_check:
        full_path = os.path.join(GAME_DIR, rel_path.replace("/", os.sep))
        if not os.path.exists(full_path):
            # Try searching for filename
            base = os.path.basename(rel_path)
            matches = []
            for r, d, files in os.walk(os.path.join(GAME_DIR, "src")):
                if "src_bytecode" in r:
                    continue
                if base in files:
                    matches.append(os.path.join(r, base))
            if matches:
                full_path = matches[0]
            else:
                print(f"[MISSING] {name} -> {rel_path}")
                continue

        with open(full_path, "r", encoding="utf-8", errors="ignore") as f:
            content = f.read()

        matches = []
        for kw in ["MARCH_VALUE_LIMIT_BOOST", "MARCH_LIMIT_BOOST", "DISPATCH_TROOP_COUNT_NUM"]:
            if kw in content:
                matches.append(kw)

        if matches:
            print(f"[FOUND] {name} ({os.path.relpath(full_path, GAME_DIR)}): {matches}")
            found_info[name] = (full_path, matches)
        else:
            print(f"[NONE] {name}")

    return found_info

if __name__ == "__main__":
    scan_all_controllers_for_sources()
