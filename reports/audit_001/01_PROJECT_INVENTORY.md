# 📋 سجل جرد مشروع بوت انتقام السلاطين (Project Inventory)
### دورة التدقيق رقم: `audit_001`
### تاريخ الإنشاء: 2026-11-15
### حالة البيئة: Antigravity CLI 1.4.3 | النموذج: Gemini 3.8 Flash (High) | وضع التشغيل: READ-ONLY

---

## 1. بطاقة الجرد العامة
- **مسار المشروع:** `E:\intqam-sultan`
- **إجمالي ملفات المهام الفعلية:** 21 ملف مهمة (+ كلاس الأساس `base_task.py` وملف التصدير `__init__.py`).
- **محركات المنظومة الأساسية:** 4 ملفات في `core/` (`live_memory.py`, `game_client.py`, `database.py`, `tenants.py`).
- **قواعد ومصادر سورس كود اللعبة:** أكثر من 13,398 ملفاً في `game_file/src/`، و 58 جدولاً في `localtb/`، وملف تفكيك Unity C# بحجم 28.7 MB في `il2cpp_dump/dump.cs`.

---

## 2. جدول جرد ملفات مهام البوت (Bot Tasks Inventory)

| # | اسم الملف | المسار | اسم الكلاس | كود الوحدة الرسمية (CMD) | دوره في اللعبة | مستوى الخطورة المتوقع | حالة التدقيق (audit_001) |
|---|---|---|---|---|---|---|---|
| 1 | `hero_trial.py` | `tasks/hero_trial.py` | `HeroTrialTask` | `1059` | تحدي كفاءة الجندي وإنجاز النشاط اليومي 25 | **CRITICAL** (استهلاك جنود/حزم شبكية) | **IN_PROGRESS** (ملف التجربة الأولى) |
| 2 | `arena.py` | `tasks/arena.py` | `ArenaTask` | `1021` | مباريات حلبة الفرسان والتصنيف اليومي | **HIGH** (مباريات وتحديات شبكية) | NOT_STARTED |
| 3 | `building.py` | `tasks/building.py` | `BuildingTask` | `1002` / `1004` | ترقية مباني القلعة واستخدام التسريعات والعمال | **CRITICAL** (استهلاك موارد وذهب) | NOT_STARTED |
| 4 | `train.py` | `tasks/train.py` | `TrainTask` | `1003` | تدريب قوات الثكنات والمصانع والإسطبل | **CRITICAL** (استهلاك موارد وحصص) | NOT_STARTED |
| 5 | `cure_wounded.py` | `tasks/cure_wounded.py` | `CureWoundedTask` | `1003` | علاج المصابين في الخيمة الطبية | **HIGH** (استهلاك موارد/حماية قوات) | NOT_STARTED |
| 6 | `research.py` | `tasks/research.py` | `ResearchTask` | `1005` | بحوث المعهد وترقية العلوم العسكرية والاقتصادية | **HIGH** (استهلاك موارد وأوقات) | NOT_STARTED |
| 7 | `alliance.py` | `tasks/alliance.py` | `AllianceTask` | `1010` | مساعدات التحالف، تبرعات العلوم، وصناديق التحالف | **MEDIUM** (تبرعات ومساعدات) | NOT_STARTED |
| 8 | `daily_quest.py` | `tasks/daily_quest.py` | `DailyQuestTask` | `1018` | استلام نقاط وصناديق النشاط اليومي (500 نقطة) | **HIGH** (اعتمادية على كافة المهام) | NOT_STARTED |
| 9 | `daily_train.py` | `tasks/daily_train.py` | `DailyTrainTask` | `1003` | تدريب رمزي بأقل جندي لإنجاز مهام النشاط | **MEDIUM** (استهلاك رمزي) | NOT_STARTED |
| 10 | `shield.py` | `tasks/shield.py` | `ShieldTask` | `1001` | تفعيل درع الحماية للحفاظ على القلعة من الهجوم | **CRITICAL** (حماية القلعة من التدمير) | NOT_STARTED |
| 11 | `city_harvest.py` | `tasks/city_harvest.py` | `CityHarvestTask` | `1002` | جمع موارد مزارع وخشب وحديد وفضة القلعة | **LOW** (جمع موارد داخلي) | NOT_STARTED |
| 12 | `port.py` | `tasks/port.py` | `PortTask` | `1007` | جمع جوائز الميناء اليومية والتجارة البحرية | **LOW** (جمع جوائز ثابتة) | NOT_STARTED |
| 13 | `merchant_ship.py` | `tasks/merchant_ship.py` | `MerchantShipTask` | `1007` | التبادل التجاري بسفينة الميناء | **MEDIUM** (تبادل موارد) | NOT_STARTED |
| 14 | `imperial_mausoleum.py` | `tasks/imperial_mausoleum.py` | `ImperialMausoleumTask` | `1040` | استكشاف الضريح الإمبراطوري اليومي | **MEDIUM** (استكشاف مجاني) | NOT_STARTED |
| 15 | `flower.py` | `tasks/flower.py` | `FlowerTask` | `1035` | زراعة وسقي وحصاد زهور السعادة | **LOW** (فعالية ترفيهية) | NOT_STARTED |
| 16 | `wonder_merchant.py` | `tasks/wonder_merchant.py` | `WonderMerchantTask` | `1038` | شراء العروض المجانية لتاجر العجائب | **LOW** (شراء مجاني) | NOT_STARTED |
| 17 | `material_synthesis.py` | `tasks/material_synthesis.py` | `MaterialSynthesisTask` | `1008` | دمج مواد ورشة الحدادة لترقية رتبها | **LOW** (دمج داخلي) | NOT_STARTED |
| 18 | `forge_equipment.py` | `tasks/forge_equipment.py` | `ForgeEquipmentTask` | `1008` | تصنيع وتفكيك عتاد الأمير في الحدادة | **MEDIUM** (استهلاك مواد وفولاذ) | NOT_STARTED |
| 19 | `war_medal.py` | `tasks/war_medal.py` | `WarMedalTask` | `1048` | جمع أوسمة الحرب وتفعيل الشارات | **LOW** (جمع جوائز) | NOT_STARTED |
| 20 | `pet.py` | `tasks/pet.py` | `PetTask` | `1065` | تدريب وإطعام الحيوانات الأليفة | **MEDIUM** (استهلاك طعام وجوائز) | NOT_STARTED |
| 21 | `treasure.py` | `tasks/treasure.py` | `TreasureTask` | `1030` | البحث عن الكنوز وفتح الخرائط السرية | **MEDIUM** (استهلاك خرائط) | NOT_STARTED |

---

## 3. ملفات البنية التحتية والتحكم (Infrastructure & Core Files)

| اسم الملف | المسار | الدور والمسؤولية | مستوى الحساسية |
|---|---|---|---|
| `base_task.py` | `tasks/base_task.py` | الكلاس الأب لجميع المهام، يوفر `safe_query`، والتسجيل، وحماية الأخطاء | **CRITICAL** |
| `live_memory.py` | `core/live_memory.py` | إدارة وتحليل وتخزين شجرة كائنات `conn.init_data` في الذاكرة الحية | **CRITICAL** |
| `game_client.py` | `core/game_client.py` | محرك الاتصال المشفر ببروتوكول DES و Socket، وتوليد حزم الشبكة وتلقي الردود | **CRITICAL** |
| `bot_manager.py` | `bot_manager.py` | المنسق التنفيذي لحلقات القلاع، والتحكم بالجدولة وإعادة تحميل الإعدادات | **CRITICAL** |
| `api_server.py` | `api_server.py` | واجهة الـ API لربط لوحة التحكم وتصفية الإعدادات في `clean_config` | **HIGH** |
| `database.py` | `core/database.py` | إدارة الاتصال بقاعدة بيانات SQLite وتخزين إعدادات القلاع | **HIGH** |
