import os
import shutil

ROOT_DIR = r"e:\intqam-sultan"
GAME_FILE_DIR = os.path.join(ROOT_DIR, "game_file")
DEST_DIR = os.path.join(ROOT_DIR, "march_capacity_files")

# Mapping of relative paths inside game_file to flat filenames inside march_capacity_files
FILES_TO_COPY = [
    # 1. Core formulas & logic
    r"src/app/module/city/buildLogic.lua",
    r"src/fgui/views/troopFlagView/WorldDispatchArmyViewPanel.lua",
    r"src/fgui/views/troopFlagView/troopFlagTeamsPanel.lua",
    
    # 2. Buildings: Drill Grounds & Hall of War
    r"src/app/localtb/config_server/build121.lua",
    r"src/app/localtb/config_server/buildstar121.lua",
    r"src/app/localtb/config_server/build111.lua",
    r"src/app/localtb/config_server/buildstar111.lua",
    r"src/app/constdef/buildDef.lua",
    
    # 3. Game constants
    r"src/app/constdef/constValue.lua",
    
    # 4. Hero system: capacity, level, skills, dress, combos
    r"src/app/localtb/config_read/heroltCtrl.lua",
    r"src/app/module/hero/heroCtrl.lua",
    r"src/app/localtb/config_server/hero_level_config.lua",
    r"src/app/localtb/config_server/hero_skill_conf.lua",
    r"src/app/localtb/config_server/hero_dress_server.lua",
    r"src/app/localtb/config_server/hero_combos_skill.lua",
    r"src/fgui/views/NewHeroView/HeroAttributePanel.lua",
    
    # 5. Technology & Research
    r"src/app/constdef/technologyDef.lua",
    r"src/app/localtb/config_server/technology.lua",
    r"src/app/module/alliance/allianceScience.lua",
    r"src/app/localtb/config_server/alliance_science_lv.lua",
    r"src/app/game/view/worldMapWarDef.lua",
    
    # 6. Buffs & Attributes
    r"src/app/constdef/buffDef.lua",
    r"src/app/module/buff/buffCtrl.lua",
    r"src/app/module/newBuff/attributeDef.lua",
    r"src/app/module/newBuff/attributeSystem.lua",
    
    # 7. VIP & SVIP privileges
    r"src/app/localtb/config_server/vipbuff.lua",
    r"src/app/localtb/config_client/vipprivilege.lua",
    
    # 8. Achievements & Medals
    r"src/app/module/achievement/achievementctrl.lua",
    r"src/app/constdef/achieveDef.lua",
    r"src/app/localtb/config_client/achievement_info.lua",
    
    # 9. Runes, Divine Beasts, Pets & Equipment
    r"src/app/module/equipment/godArmsRuneCtrl.lua",
    r"src/app/localtb/config_server/rune_property_config.lua",
    r"src/app/localtb/config_server/rune_properties_level_config.lua",
    r"src/app/module/divineBeast/divineBeastCtrl.lua",
    r"src/app/localtb/config_server/divine_beast_attribute_config.lua",
    r"src/app/localtb/config_server/divine_beast_march.lua",
    r"src/app/module/pet/petCtrl.lua",
    r"src/app/constdef/petDef.lua",
    r"src/app/module/equipment/equipmentAdditionMgr.lua",
    r"src/app/constdef/equipmentDef.lua",
    r"src/app/localtb/config_read/wargemResRead.lua",
    
    # 10. Officials & Titles
    r"src/app/localtb/config_server/kingofficial.lua",
    r"src/app/localtb/config_client/kingofficialconfig.lua",
    r"src/app/localtb/config_client/official_buff_des.lua",
    r"src/app/localtb/config_read/officialBuffRead.lua",
    
    # 11. Network Dispatch & War Utils
    r"src/app/module/world/warUtil.lua",
    r"src/app/module/world/kingdomMapCtrl.lua",
    
    # 12. Special Battle Modes & Views
    r"src/fgui/views/BuildDrillGround/ArenaTeamSetViewPanel.lua",
    r"src/app/game/eventCenterView/eventTemplate/heroTrial/heroTrialDispatchArmy.lua",
    r"src/fgui/views/heroTrial/heroTrialDispatchArmyPanel.lua",
    r"src/app/game/remainsView/teamView/teamDispatchArmyView.lua",
    r"src/app/game/epicBattle/epicBattleDispatchArmyView.lua",
    r"src/app/game/epicWar/epicWarDispatchView.lua",
    
    # 13. UI & Information Display
    r"src/app/module/backpack/itemLogic.lua",
    r"src/app/module/lord/lordInfoCtrl.lua",
    r"src/app/localtb/config_read/buildMoreInfoRead.lua",
    r"src/fgui/views/BuildEmbassy/ReinforcementsMsgBoxPanel.lua",
    r"src/app/module/alliance/allianceResPoint.lua",
    
    # 14. Key descriptors / patch tables
    r"localtb/delta_patch_tables/itemdescribe.lua",
    r"localtb/local_arab.json",
]

def make_flat_name(rel_path: str) -> str:
    # Normalize forward slashes
    clean = rel_path.replace("\\", "/").strip("/")
    # Replace slashes with double underscore or underscore
    # E.g. src/app/module/city/buildLogic.lua -> src__app__module__city__buildLogic.lua
    parts = clean.split("/")
    return "__".join(parts)

def main():
    os.makedirs(DEST_DIR, exist_ok=True)
    copied_count = 0
    missing = []
    manifest = []

    for rel in FILES_TO_COPY:
        src_path = os.path.join(GAME_FILE_DIR, rel.replace("/", os.sep))
        flat_name = make_flat_name(rel)
        dst_path = os.path.join(DEST_DIR, flat_name)

        if os.path.exists(src_path):
            shutil.copy2(src_path, dst_path)
            copied_count += 1
            size_kb = os.path.getsize(dst_path) / 1024.0
            manifest.append((rel, flat_name, f"{size_kb:.1f} KB"))
            print(f"Copied: {rel} -> {flat_name} ({size_kb:.1f} KB)")
        else:
            missing.append(rel)
            print(f"MISSING: {src_path}")

    print(f"\nFinished copying {copied_count} files to: {DEST_DIR}")
    if missing:
        print(f"Warning: {len(missing)} files were not found.")

    # Create README index in the destination folder
    readme_path = os.path.join(DEST_DIR, "README.md")
    with open(readme_path, "w", encoding="utf-8") as f:
        f.write("# 🏰 ملفات منطق سعة المسيرة القصوى (March Capacity Game Files)\n\n")
        f.write("تم استخراج ونسخ هذه الملفات من حزمة اللعبة الأصلية في `game_file` بصيغة مسطحة (Flat Structure)\n")
        f.write("مع حفظ المسار الأصلي في اسم كل ملف باستخدام الفاصل `__` لتفادي أي تعارض في الأسماء.\n\n")
        f.write(f"**إجمالي الملفات المنسوخة:** {copied_count}\n\n")
        f.write("| # | المسار الأصلي في اللعبة | الاسم المسطح في هذا المجلد | الحجم |\n")
        f.write("|---|------------------------|---------------------------|-------|\n")
        for idx, (orig, flat, sz) in enumerate(manifest, 1):
            f.write(f"| {idx} | `{orig}` | `{flat}` | {sz} |\n")

    print(f"Index created at: {readme_path}")

if __name__ == "__main__":
    main()
