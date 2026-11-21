import os
import sys

SOURCE_DIR = r"e:\intqam-sultan\march_capacity_files"
OUTPUT_FILE = r"e:\intqam-sultan\all_march_capacity_code.lua"

# List of files in logical, structured order
FILES_ORDERED = [
    # Category 1: Core Mathematical Formulas & Main Controllers
    ("1. المعادلات الرياضية المركزية ومتحكمات الحساب", [
        ("src__app__module__city__buildLogic.lua", "buildLogic.lua: دوال حساب سعة المسيرة الفردية getExpArmyCount()، والحشد getHallofwarCapacity()، والساحة getArenaExpArmyCount()"),
        ("src__fgui__views__troopFlagView__WorldDispatchArmyViewPanel.lua", "WorldDispatchArmyViewPanel.lua: واجهة إرسال الجيوش وحساب السعة الميدانية مع الأبطال والرونات والوحوش"),
        ("src__fgui__views__troopFlagView__troopFlagTeamsPanel.lua", "troopFlagTeamsPanel.lua: ضبط وتجميع سعة ألوية ورايات المسيرات المحفوظة"),
    ]),

    # Category 2: Building Capacities & Glory Stars
    ("2. مباني ساحة العرض وصالة الحرب ونجوم قصر المجد", [
        ("src__app__localtb__config_server__build121.lua", "build121.lua: السعة الأساسية لميدان العرض (Drill Grounds Lv.1 - 130)"),
        ("src__app__localtb__config_server__buildstar121.lua", "buildstar121.lua: سعة نجوم قصر المجد لميدان العرض (Star Lv.1 - 70)"),
        ("src__app__localtb__config_server__build111.lua", "build111.lua: السعة الأساسية لمبنى صالة الحرب للحشود (Hall of War Lv.1 - 130)"),
        ("src__app__localtb__config_server__buildstar111.lua", "buildstar111.lua: سعة نجوم قصر المجد لصالة الحرب للحشود (Star Lv.1 - 70)"),
        ("src__app__constdef__buildDef.lua", "buildDef.lua: تعريفات معرفات المباني BUILDID"),
    ]),

    # Category 3: Global Game Constants
    ("3. ثوابت اللعبة الأساسية", [
        ("src__app__constdef__constValue.lua", "constValue.lua: ثابت سعة المسيرة الافتراضي DEFAULT_EXP_ARMY_COUNT = 1000 وسقف الجيش"),
    ]),

    # Category 4: Hero System: Level, Skills, Dress & Combos
    ("4. منظومة الأبطال وسعة الفيلق والمساعدين والمظاهر", [
        ("src__app__localtb__config_read__heroltCtrl.lua", "heroltCtrl.lua: حساب سعة الأبطال getHerosMarchCapacity() وقراءة مستويات ومظاهر الأبطال"),
        ("src__app__module__hero__heroCtrl.lua", "heroCtrl.lua: حساب سعة البطل الواحد وبافات المظاهر السلبية والمساعدين"),
        ("src__app__localtb__config_server__hero_level_config.lua", "hero_level_config.lua: جدول سعة المسيرة لكل مستوى بطل وندرته (march_add)"),
        ("src__app__localtb__config_server__hero_skill_conf.lua", "hero_skill_conf.lua: مهارات معركة الأبطال التي تمنح باف زيادة سعة المسيرة (buffType 96)"),
        ("src__app__localtb__config_server__hero_dress_server.lua", "hero_dress_server.lua: مظاهر الأبطال التي تمنح زيادة سعة مسيرة سلبية بمجرد الامتلاك"),
        ("src__app__localtb__config_server__hero_combos_skill.lua", "hero_combos_skill.lua: مهارات اندماج الأبطال والمساعدين التي تزيد السعة"),
        ("src__fgui__views__NewHeroView__HeroAttributePanel.lua", "HeroAttributePanel.lua: واجهة وعرض خصائص وسعة البطل"),
    ]),

    # Category 5: Technology & Alliance Research
    ("5. العلوم وأبحاث المعهد والتحالف", [
        ("src__app__constdef__technologyDef.lua", "technologyDef.lua: معرفات أبحاث القيادة (43)، وحرب الفتح (73)، والهرم (77)، والأساطير (95)، وصالة الحرب (90)"),
        ("src__app__game__view__worldMapWarDef.lua", "worldMapWarDef.lua: جلب إضافات علوم التحالف لسعة الحشد getHallOfWarArmyCount()"),
        ("src__app__module__alliance__allianceScience.lua", "allianceScience.lua: نظام علوم التحالف"),
    ]),

    # Category 6: Buffs & Attribute System
    ("6. البافات ونظام السمات الإحصائي", [
        ("src__app__constdef__buffDef.lua", "buffDef.lua: تعريف أرقام بافات المسيرة (19 و 96) والحشود (736 و 737 و 56 و 62)"),
        ("src__app__module__buff__buffCtrl.lua", "buffCtrl.lua: متحكم قراءة البافات والـ virtualBuff.marchMaxCount"),
        ("src__app__module__newBuff__attributeDef.lua", "attributeDef.lua: تعريف سمات زيادة جنود الإرسال والحشد DISPATCH_TROOP_COUNT_NUM"),
        ("src__app__module__newBuff__attributeSystem.lua", "attributeSystem.lua: نظام السمات الإحصائية"),
    ]),

    # Category 7: VIP / SVIP & Achievement Medals
    ("7. امتيازات كبار الشخصيات وأوسمة الإنجازات", [
        ("src__app__localtb__config_server__vipbuff.lua", "vipbuff.lua: مستويات الـ VIP/SVIP وقيم الباف للامتياز 7219"),
        ("src__app__localtb__config_client__vipprivilege.lua", "vipprivilege.lua: تعريف امتياز 7219 (زيادة الحد الأقصى لعدد جنود المسيرة لفيلق واحد)"),
        ("src__app__module__achievement__achievementctrl.lua", "achievementctrl.lua: ربط باف المسيرة بإنجازات اللورد (Property 14)"),
        ("src__app__constdef__achieveDef.lua", "achieveDef.lua: تعريف خاصية إنجاز المسيرة MARCH_LIMIT_BOOST = 14"),
        ("src__app__localtb__config_client__achievement_info.lua", "achievement_info.lua: مستويات ونسب وسام توحيد القوة (9003017)"),
    ]),

    # Category 8: Runes, Divine Beasts, Pets & Equipment
    ("8. الرونات والعتاد الإلهي والوحوش والحيوانات والمعدات", [
        ("src__app__module__equipment__godArmsRuneCtrl.lua", "godArmsRuneCtrl.lua: استخراج سعة رونات العتاد الإلهي المجهزة"),
        ("src__app__localtb__config_server__rune_property_config.lua", "rune_property_config.lua: خصائص الرونات التي تمنح سعة مسيرة"),
        ("src__app__localtb__config_server__rune_properties_level_config.lua", "rune_properties_level_config.lua: مستويات خصائص الرونات"),
        ("src__app__module__divineBeast__divineBeastCtrl.lua", "divineBeastCtrl.lua: حساب سعة الوحوش الإلهية المسيرة getDispatchAddCount()"),
        ("src__app__localtb__config_server__divine_beast_attribute_config.lua", "divine_beast_attribute_config.lua: سمات الوحوش الإلهية"),
        ("src__app__localtb__config_client__divine_beast_march.lua", "divine_beast_march.lua: إعدادات مسيرات الوحوش الإلهية"),
        ("src__app__module__pet__petCtrl.lua", "petCtrl.lua: سمات الحيوانات الأليفة التي ترفع سعة المسيرة"),
        ("src__app__constdef__petDef.lua", "petDef.lua: تعريف خصائص الحيوانات (MARCH_VALUE_LIMIT_BOOST = 18)"),
        ("src__app__module__equipment__equipmentAdditionMgr.lua", "equipmentAdditionMgr.lua: إضافات المعدات العسكرية لسعة المسيرة"),
        ("src__app__constdef__equipmentDef.lua", "equipmentDef.lua: تعريف خاصية المعدات (MARCH_VALUE_LIMIT_BOOST = 78)"),
        ("src__app__localtb__config_read__wargemResRead.lua", "wargemResRead.lua: أحجار وجواهر الحرب التي تمنح سعة مسيرة وحشود"),
    ]),

    # Category 9: Kingdom Officials & Wonder Titles
    ("9. المناصب والألقاب الملكية", [
        ("src__app__localtb__config_server__kingofficial.lua", "kingofficial.lua: مناصب المملكة التي تمنح باف سعة مسيرة"),
        ("src__app__localtb__config_client__kingofficialconfig.lua", "kingofficialconfig.lua: إعدادات مناصب المملكة"),
        ("src__app__localtb__config_client__official_buff_des.lua", "official_buff_des.lua: توصيف بافات المناصب"),
        ("src__app__localtb__config_read__officialBuffRead.lua", "officialBuffRead.lua: قراءة بافات المناصب الملكية"),
    ]),

    # Category 10: Network Dispatch & War Utils
    ("10. أوامر إرسال الشبكة والعمليات الميدانية", [
        ("src__app__module__world__kingdomMapCtrl.lua", "kingdomMapCtrl.lua: حزم إرسال المسيرة addKingdomQueue مع قوائم بافات المسيرة"),
        ("src__app__module__world__warUtil.lua", "warUtil.lua: تجميع بافات الحرب الشاملة من الـ VIP والمدينة والأدوات"),
    ]),

    # Category 11: Special Battle Modes
    ("11. الفعاليات والساحات ذات السعات الخاصة", [
        ("src__fgui__views__BuildDrillGround__ArenaTeamSetViewPanel.lua", "ArenaTeamSetViewPanel.lua: فيلق ساحة المنافسة (Arena)"),
        ("src__app__game__eventCenterView__eventTemplate__heroTrial__heroTrialDispatchArmy.lua", "heroTrialDispatchArmy.lua: تجربة البطل (Hero Trial)"),
        ("src__fgui__views__heroTrial__heroTrialDispatchArmyPanel.lua", "heroTrialDispatchArmyPanel.lua: لوحة إرسال تجربة البطل"),
        ("src__app__game__remainsView__teamView__teamDispatchArmyView.lua", "teamDispatchArmyView.lua: فيلق حرب الأطلال (سعة مخصصة 3 ملايين + باف + علوم)"),
        ("src__app__game__epicBattle__epicBattleDispatchArmyView.lua", "epicBattleDispatchArmyView.lua: معارك ملحمية"),
        ("src__app__game__epicWar__epicWarDispatchView.lua", "epicWarDispatchView.lua: حرب ملحمية"),
        ("src__app__module__alliance__allianceResPoint.lua", "allianceResPoint.lua: تقييد مسيرة نقطة موارد التحالف بالسعة القصوى"),
    ]),

    # Category 12: UI Displays & Backpack
    ("12. واجهات العرض واستخدام الأدوات في الحقيبة", [
        ("src__app__module__backpack__itemLogic.lua", "itemLogic.lua: تفعيل أدوات سعة المسيرة المؤقتة من الحقيبة"),
        ("src__app__module__lord__lordInfoCtrl.lua", "lordInfoCtrl.lua: عرض سعة المسيرة في بروفايل اللورد"),
        ("src__app__localtb__config_read__buildMoreInfoRead.lua", "buildMoreInfoRead.lua: قراءة الزيادة المعروضة في تفاصيل ساحة العرض"),
        ("src__fgui__views__BuildEmbassy__ReinforcementsMsgBoxPanel.lua", "ReinforcementsMsgBoxPanel.lua: تحديد سقف تعزيزات السفارة بسعة صالة الحرب"),
    ]),
]

def main():
    print("Building unified march capacity file...")
    
    total_files = sum(len(items) for _, items in FILES_ORDERED)
    processed = 0

    with open(OUTPUT_FILE, "w", encoding="utf-8") as out:
        # File Header & Table of Contents
        out.write("-- " + "="*78 + "\n")
        out.write("-- 🏰 الموسوعة البرمجية الشاملة لمنطق سعة المسيرة القصوى - لعبة انتقام السلاطين\n")
        out.write("-- UNIFIED MARCH CAPACITY CODEBASE (REVENGE OF SULTANS)\n")
        out.write("-- " + "="*78 + "\n")
        out.write("-- هذا الملف يجمع كود كافة ملفات المنطق البرمجي، المعادلات، الكنترولرات،\n")
        out.write("-- الجداول القيادية، وواجهات العرض والشبكة المسؤولة عن تحديد سعة المسيرة القصوى.\n")
        out.write(f"-- إجمالي الملفات المدمجة: {total_files} ملفاً برمجياً.\n")
        out.write("-- تم استبعاد جداول البيانات الضخمة (مثل technology.lua وقاموس الترجمة) للحفاظ على خفة وسرعة الملف.\n")
        out.write("-- " + "="*78 + "\n\n")

        # Table of contents
        out.write("-- 📑 فهرس محتويات الملف:\n")
        file_num = 1
        for cat_name, file_list in FILES_ORDERED:
            out.write(f"--\n-- 📁 {cat_name}:\n")
            for fname, fdesc in file_list:
                orig_path = fname.replace("__", "/")
                out.write(f"--   [{file_num:02d}] {orig_path}\n--        -> {fdesc}\n")
                file_num += 1
        out.write("\n-- " + "="*78 + "\n\n")

        # Concatenate files with clear separators
        current_num = 1
        for cat_name, file_list in FILES_ORDERED:
            out.write("\n\n" + "-"*80 + "\n")
            out.write(f"-- 📂 القسم: {cat_name}\n")
            out.write("-"*80 + "\n\n")

            for fname, fdesc in file_list:
                src_path = os.path.join(SOURCE_DIR, fname)
                orig_path = fname.replace("__", "/")

                out.write("\n\n" + "#"*80 + "\n")
                out.write(f"-- 📜 ملف [{current_num:02d}/{total_files}]: {orig_path}\n")
                out.write(f"-- 📝 الوصف: {fdesc}\n")
                out.write("#"*80 + "\n\n")

                if os.path.exists(src_path):
                    try:
                        with open(src_path, "r", encoding="utf-8", errors="ignore") as f:
                            content = f.read()
                        out.write(content)
                        out.write("\n\n")
                        processed += 1
                        print(f"[{current_num:02d}/{total_files}] Merged: {fname}")
                    except Exception as e:
                        out.write(f"-- [ERROR READING FILE: {e}]\n\n")
                        print(f"Error reading {fname}: {e}")
                else:
                    out.write(f"-- [FILE NOT FOUND IN SOURCE DIR: {src_path}]\n\n")
                    print(f"File not found: {fname}")

                current_num += 1

    size_mb = os.path.getsize(OUTPUT_FILE) / (1024.0 * 1024.0)
    print(f"\nSuccessfully generated: {OUTPUT_FILE}")
    print(f"Total files merged: {processed}/{total_files}")
    print(f"Final file size: {size_mb:.2f} MB")

if __name__ == "__main__":
    main()
