import os
import re
import json

GAME_DIR = r"e:\intqam-sultan\game_file"

def read_file(rel_path):
    full = os.path.join(GAME_DIR, rel_path.replace("/", os.sep))
    if not os.path.exists(full):
        return ""
    with open(full, "r", encoding="utf-8", errors="ignore") as f:
        return f.read()

def find_file_recursive(name):
    for root, dirs, files in os.walk(GAME_DIR):
        if "src_bytecode" in root:
            continue
        if name in files:
            return os.path.join(root, name)
    return None

def inspect_system(name, ctrl_rel_path, method_name, tables):
    print(f"\n{'='*70}\n[SYSTEM] {name}\n{'='*70}")
    ctrl_path = find_file_recursive(os.path.basename(ctrl_rel_path))
    if ctrl_path:
        print(f"Controller: {os.path.relpath(ctrl_path, GAME_DIR)}")
        content = read_file(os.path.relpath(ctrl_path, GAME_DIR))
        # Find method
        pattern = re.compile(rf"function\s+[a-zA-Z0-9_]+[:\.]{method_name}\s*\([^\)]*\)(.*?)end\b", re.DOTALL)
        m = pattern.search(content)
        if m:
            print(f"--- Method {method_name} ---")
            lines = m.group(0).split("\n")
            print("\n".join(lines[:35]))
            if len(lines) > 35:
                print(f"... [{len(lines)-35} lines truncated]")
        else:
            # Try searching for method line
            print(f"Method {method_name} not found by regex, searching lines:")
            for l in content.split("\n"):
                if method_name in l:
                    print("  ", l.strip())
    else:
        print(f"Controller {ctrl_rel_path} NOT found.")

    # Inspect tables
    for tbl in tables:
        t_path = find_file_recursive(tbl)
        if t_path:
            rel = os.path.relpath(t_path, GAME_DIR)
            txt = read_file(rel)
            # Search for 96, 19, 78, 18, 5 in property fields
            has_96 = bool(re.search(r"\b(96|buffType\s*=\s*96|effectType\s*=\s*96|propertyType\s*=\s*96)\b", txt))
            has_19 = bool(re.search(r"\b(19|buffType\s*=\s*19|effectType\s*=\s*19|propertyType\s*=\s*19)\b", txt))
            has_78 = bool(re.search(r"\b(78|propertyType\s*=\s*78|prop\s*=\s*78)\b", txt))
            has_18 = bool(re.search(r"\b(18|attrType\s*=\s*18|propertyType\s*=\s*18)\b", txt))
            has_5 = bool(re.search(r"\b(attrID\s*=\s*3|attrType\s*=\s*5|attrID\s*=\s*5)\b", txt))
            print(f"Table {tbl}: 96={has_96}, 19={has_19}, 78={has_78}, 18={has_18}, 5={has_5}")
        else:
            print(f"Table {tbl} NOT found.")

if __name__ == "__main__":
    inspect_system("Equipment", "equipmentAdditionMgr.lua", "queryByBuffEffectType", [
        "equipment_base_property_config.lua", "equipment_extra_property_config.lua", "equipment_set_config.lua", "equipmentsuit.lua"
    ])
    inspect_system("Pet", "petCtrl.lua", "getPetAttributeAdd", [
        "pet_attribute_config.lua", "pet_skill_config.lua", "pet_talent_config.lua", "pet_level_config.lua"
    ])
    inspect_system("WarGem", "warGemCtrl.lua", "getBuffPlus", [
        "wargem_config.lua", "wargem_suit_config.lua", "wargem_inlay_config.lua", "wargem_level_config.lua"
    ])
    inspect_system("NebulaTower", "nebulaActivityCtrl.lua", "getNebulaTowerBuffEffect", [
        "nebula_tower.lua", "nebula_tower_stage.lua", "nebula_tower_floor.lua"
    ])
    inspect_system("KingdomLevel", "kingdomLevelDataModuleAPI.lua", "getBuff", [
        "kingdom_level.lua", "kingdom_level_buff.lua", "kingdom_level_config.lua"
    ])
    inspect_system("MilitaryRank", "militaryRankCtrl.lua", "getTotalBuffValue", [
        "military_rank_level.lua", "military_rank_skill.lua"
    ])
    inspect_system("HeroBiography", "heroBiographyCtrl.lua", "queryHeroBiographyBuff", [
        "hero_biography.lua", "hero_biography_skill.lua"
    ])
    inspect_system("MiraculousWeapon", "miraculousWeaponCtrl.lua", "getBuffEffect", [
        "miraculous_weapon.lua", "miraculous_weapon_skill.lua"
    ])
    inspect_system("MagicLamp", "magicLampCtrl.lua", "getBuffEffect", [
        "adventure_magic_lamp.lua", "adventure_magic.lua"
    ])
    inspect_system("Parliament", "intetiorCtrl.lua", "getBuffPlus", [
        "parliament_official.lua", "parliament_skill.lua", "intetior_official.lua"
    ])
    inspect_system("HeroCenotaph", "heroCenotaphCtrl.lua", "getHeroCenotaphBuffEffect", [
        "hero_cenotaph.lua", "hero_cenotaph_buff.lua"
    ])
    inspect_system("ManorCity", "manorCityCtrl.lua", "getBuffVale", [
        "manor_buff.lua", "manor_level.lua"
    ])
    inspect_system("ExoticPavilion", "exoticPavilionCtrl.lua", "getBuffByType", [
        "exotic_pavilion.lua", "foreign_pavilion.lua"
    ])
    inspect_system("DivineBeast", "divineBeastCtrl.lua", "getBuffEffect", [
        "divine_beast_attribute_config.lua", "divine_beast_skill_config.lua"
    ])
    inspect_system("HeroAppoint", "heroAppointCtrl.lua", "getBuffVale", [
        "hero_appoint.lua"
    ])
    inspect_system("KingdomChronicles", "legendMCtrl.lua", "getKingdomAchiBuffEffect", [
        "kingdom_achievement.lua", "kingdom_chronicles.lua"
    ])
