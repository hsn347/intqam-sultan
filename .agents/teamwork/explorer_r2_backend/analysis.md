# التقرير الفني الشامل: مهمة استلام صناديق النشاط اليومي (Daily Activity Quest Chests)
## Technical Blueprint & Architectural Investigation for Requirement R1

**تاريخ الإعداد:** 2026-11-01  
**المحقق:** Codebase Researcher — Backend & Game Protocol Specialist (`explorer_r2_backend`)  
**نطاق العمل:** الباك إند وبروتوكول شبكة اللعبة وهيكلية الذاكرة الحية ونظام إدارة البوت (`bot_manager.py`)

---

## 1. الملخص التنفيذي وأهداف التحقيق (Executive Summary)

يهدف هذا التحقيق إلى وضع التصميم الهندسي الكامل والدقيق لتنفيذ متطلب **R1** الوارد في وثيقة المتطلبات الأصلية (`ORIGINAL_REQUEST.md`):
> "إضافة مهمة إلزامية في الباك إند لاستلام وفتح صناديق النشاط اليومي الجاهزة كآخر مهمة في دورة البوت، بالاعتماد الكلي على الذاكرة الحية المشحونة مسبقاً (`conn.init_data`) دون إرسال طلبات شبكية غير مبررة (0-Network Check)، مع تنفيذ استعلام شبكي آمن واحتياطي في حال عدم توفر أو تزامن بيانات الصناديق في الذاكرة الحية."

تم استخراج كافة التفاصيل والبيانات الواردة في هذا التقرير مباشرة من:
1. الكود المصدري الأصلي لعميل اللعبة بلغة Lua في:
   - `game_file/src/app/module/everydayTask/everydayTaskCtrl.lua`
   - `game_file/src/app/constdef/cmdDef.lua`
   - `game_file/src/app/localtb/config_server/daily_reward_point_config.lua`
   - `game_file/src/app/localtb/config_server/daily_reward_point_items.lua`
   - `game_file/src/fgui/gcomponent/QuestView/Com_box2.lua`
   - `game_file/src/fgui/views/QuestView/questViewPanel.lua`
   - `game_file/src/fgui/views/QuestView/dailyAwardTreasureDetailPanel.lua`
2. ملفات تفريغ الذاكرة الحية الحقيقية للحسابات:
   - `docs/sample_live_memory.json`
   - `docs/lucifer_live_memory.json`
   - `docs/beetoo1_live_memory.json`
   - `scratch/init_LUCIFER.json`
3. البنية التحتية البرمجية للبوت:
   - `tasks/base_task.py`
   - `tasks/daily_train.py`
   - `tasks/train.py`
   - `tasks/cure_wounded.py`
   - `tasks/forge_equipment.py`
   - `bot_manager.py`
   - `api_server.py`
   - `core/database.py`

---

## 2. بروتوكول شبكة اللعبة الرسمي لصناديق ومهام النشاط اليومي (Game Protocol Details)

### 2.1 كود وحدة الأوامر الرسمية (Module Command)
- **`CMD_EVERYDAY_TASK_MODULE = "2027"`**  
  (موثق في `game_file/src/app/constdef/cmdDef.lua` السطر 1488)

### 2.2 الأوامر الفرعية (Subcommands)
| الثابت الرسمي | القيمة | الغرض الوظيفي | شكل البيانات المرسلة (`data`) |
| :--- | :---: | :--- | :--- |
| `REQ_EVERYDAY_TASK_INIT` | `"1"` | استعلام استرجاع بيانات المهام والصناديق (Fallback Query) | `{}` |
| `REQ_EVERYDAY_TASK_RECEIVE_NORMAL` | `"2"` | **استلام الصناديق اليومية الثمانية (30 - 500 نقطة)** | `{"index": index}` (حيث `index` من 1 إلى 8) |
| `REQ_EVERYDAY_TASK_REFRESH` | `"3"` | تجديد عروض كنز النشاط بالذهب | `{"index": index}` |
| `REQ_EVERYDAY_TASK_RECEIVE_CHEST` | `"4"` | شراء صناديق كنز النشاط الخاصة بالذهب (`offPrice`) | `{"index": index}` |
| `REQ_EVERYDAY_TASK_USE_FAST_PASS` | `"5"` | استخدام تذاكر المرور السريع لإنهاء المهام | `{"index": index, "shopItemID": id}` |

---

### 2.3 تدقيق بالغ الأهمية: التمييز بين Subcmd 2 و Subcmd 4 (Critical Protocol Distinction)
- **الملاحظة الدقيقة:** ورد في بعض توثيقات المشروع المبدئية (`docs/tasks_dictionary/01_daily_tasks.md` السطر 18) إشارة إلى الأمر الفرعي `"4"` لفتح الصناديق.
- **الحقيقة البرمجية المثبتة من كود اللعبة الرسمي (`everydayTaskCtrl.lua` و `Com_box2.lua`):**
  1. الصناديق الثمانية المجانية المتدرجة من 30 إلى 500 نقطة تسمى برمجياً **`NormalReward`** (وتُعرض في `List_box` بواسطة مكوّن `Com_box2`). عند الضغط على أي صندوق مكتمل، يستدعي العميل:
     ```lua
     everydayTaskCtrl:sendReceiveNormalMsg(self.data.index)
     ```
     وهي ترسل:
     ```json
     {"cmd": "2027", "subcmd": "2", "data": {"index": index}}
     ```
     والاستجابة تعيد `ret.data.normalRecord` التي تسجل الصندوق كمستلم مجاناً!
  2. بينما الأمر الفرعي `"4"` (`REQ_EVERYDAY_TASK_RECEIVE_CHEST`) مخصص حصراً لصناديق **"كنز النشاط"** (Treasure Boxes المعروضة في `List_treasure` عبر `dailyAwardTreasureDetailPanel.lua`)، وهي **تتطلب خصم ذهب (`offPrice`)** من القلعة (`self.fields.btn_gold:initData(gIDDef.GOLD, self.data.reward.offPrice)`).
  3. **القرار الهندسي القاطع:** مهمة البوت لاستلام صناديق النشاط اليومي المجانية **يجب حصراً وإلزاماً أن تستخدم Subcmd 2** لمنع استهلاك أو هدر ذهب القلاع التزاماً بالبند 2 من دستور العمل (`GEMINI.md`).

---

### 2.4 عتبات النقاط الرسمية للصناديق الثمانية (Chest Milestones & Point Thresholds)
مستخرجة مباشرة من `daily_reward_point_items.lua` وعميل `everydayTaskCtrl.lua` (`self.localGoalArray`):

| رقم الصندوق | الفهرس (`index`) | النقاط المطلوبة (`goal`) | أهم المكافآت المستلمة مجاناً | حزمة الاستلام الرسمية |
| :---: | :---: | :---: | :--- | :--- |
| **الصندوق 1** | `1` | **30 نقطة** | ذهب، خشب 3,000، قمح 3,000، حديد 600، فضة 300، بلور 60، تسريع 1 دقيقة | `{"cmd": "2027", "subcmd": "2", "data": {"index": 1}}` |
| **الصندوق 2** | `2` | **70 نقطة** | ذهب، خبرة الأمير 150، تسريع تدريب، أوسمة ومواد صقل العتاد | `{"cmd": "2027", "subcmd": "2", "data": {"index": 2}}` |
| **الصندوق 3** | `3` | **120 نقطة** | ذهب، موارد آمنة (قمح وخشب 10,000، حديد 2,000)، تسريع 5 دقائق × 2 | `{"cmd": "2027", "subcmd": "2", "data": {"index": 3}}` |
| **الصندوق 4** | `4` | **180 نقطة** | ذهب، فضة 5,000، حجر صقل، تسريع 15 دقيقة × 2، طاقة الأمير | `{"cmd": "2027", "subcmd": "2", "data": {"index": 4}}` |
| **الصندوق 5** | `5` | **260 نقطة** | ذهب، فضة 12,000، تسريع بناء 1 ساعة × 2، شظايا أبطال، نقاط شرف | `{"cmd": "2027", "subcmd": "2", "data": {"index": 5}}` |
| **الصندوق 6** | `6` | **340 نقطة** | ذهب، فضة 25,000، تسريع عام 2 ساعة × 2، صندوق مواد عتاد برتقالي | `{"cmd": "2027", "subcmd": "2", "data": {"index": 6}}` |
| **الصندوق 7** | `7` | **420 نقطة** | ذهب، بلور متقدم، تسريع عام 3 ساعات × 2، شظايا مهارات أسطورية | `{"cmd": "2027", "subcmd": "2", "data": {"index": 7}}` |
| **الصندوق 8** | `8` | **500 نقطة** | ذهب × 200+، فضة 50,000، تسريعات 3 ساعات × 4، أوسمة حرب نادرة | `{"cmd": "2027", "subcmd": "2", "data": {"index": 8}}` |

---

## 3. هيكلية الذاكرة الحية المشحونة (`conn.init_data`) وخوارزمية احتساب النقاط

### 3.1 موضع البيانات في الذاكرة الحية
يتم شحن متحكم `everydayTaskCtrl` تلقائياً من خادم اللعبة أثناء تسجيل الدخول عند معالجة حزمة التهيئة الشاملة (CMD 1000 / Session 0) داخل `core/game_client.py` (الأسطر 1342-1353).

الهيكل الداخلي الدقيق لـ `conn.init_data["everydayTaskCtrl"]`:
```json
{
  "everydayTaskCtrl": {
    "tomorrowZeroUTC": 1793404800,
    "serverLv": 100,
    "eventInfo": {
      "7": 1,
      "11": 5,
      "17": 1,
      "21": 1,
      "22": 4,
      "26": 1
    },
    "normalRecord": {
      "1": 1
    },
    "chestReward": { ... },
    "chestRecord": {}
  }
}
```

### 3.2 تفصيل الحقول ودلالاتها
1. **`eventInfo` (سجل إنجاز المهام):**
   - قاموس (`dict`) مفاتيحه هي أرقام أنواع المهام (`"1"` إلى `"33"`) أو معرفات المهام الكاملة (`"4100001"` إلى `"4100033"`).
   - قيمه تمثل عدد مرات التكرار المنجزة حتى اللحظة لكل مهمة (`tmpCount`).
   - لا يخزن الخادم حقلاً جاهزاً باسم `curPoint` أو `dailyScore`؛ بل يعتمد العميل الرسمي للعبة على الدالة `everydayTaskCtrl:calCurPoint()` لاحتساب المجموع تراكمياً.
2. **`normalRecord` (سجل الصناديق المستلمة اليوم):**
   - قاموس (`dict`) مفاتيحه هي فهارس الصناديق المستلمة كسلاسل نصية (`"1"` إلى `"8"`).
   - إذا كان `"1"` موجوداً في `normalRecord`: يعني أن الصندوق رقم 1 تم استلامه مسبقاً.
   - إذا كان `"1"` غير موجود في `normalRecord`: يعني أن الصندوق رقم 1 لم يتم استلامه بعد اليوم.
3. **`tomorrowZeroUTC` (موعد تصفير اليوم الجديد):**
   - الطابع الزمني بتوقيت UTC (ثوانٍ) لموعد بداية اليوم الجديد وتصفير المهام اليومية والصناديق.
   - إذا كان `current_time >= tomorrowZeroUTC`: يعني أن اليوم قد تغيّر وأن الذاكرة الحية بحاجة لتحديث (Stale Data).

---

### 3.3 خوارزمية احتساب نقاط النشاط اليومي الحالية (`cal_cur_points`)
تطابق تماماً المنطق الرسمي لـ `everydayTaskCtrl:calCurPoint()` في كود اللعبة:
$$\text{TotalPoints} = \sum_{\text{task} \in \text{eventInfo}} \text{point} \times \min(\text{count}, \text{limitTime})$$

جدول إعدادات المهام الـ 33 الرسمية (مستخرج من `daily_reward_point_config.lua`):
```python
# DAILY_QUEST_CONFIG: {task_type_or_id: (points_per_action, max_limit_time)}
DAILY_QUEST_CONFIG: Dict[int, Tuple[int, int]] = {
    1: (3, 5),      # جمع قمح (4100001) -> 15 نقطة
    2: (3, 5),      # جمع خشب (4100002) -> 15 نقطة
    3: (3, 5),      # جمع حديد (4100003) -> 15 نقطة
    4: (3, 5),      # جمع فضة (4100004) -> 15 نقطة
    5: (3, 5),      # قتل وحوش (4100005) -> 15 نقطة
    6: (30, 1),     # تطوير مبنى (4100006) -> 30 نقطة
    7: (30, 1),     # بحث معهد (4100007) -> 30 نقطة
    8: (2, 10),     # إهداء زهور (4100008) -> 20 نقطة
    9: (20, 1),     # تصنيع عتاد (4100009) -> 20 نقطة
    10: (10, 1),    # تجميع مواد (4100010) -> 10 نقطة
    11: (3, 5),     # علاج مصابين (4100011) -> 15 نقطة
    12: (5, 5),     # تدريب مشاة (4100012) -> 25 نقطة
    13: (5, 5),     # تدريب رماة (4100013) -> 25 نقطة
    14: (5, 5),     # تدريب فرسان (4100014) -> 25 نقطة
    15: (5, 5),     # تدريب عربات (4100015) -> 25 نقطة
    16: (3, 5),     # تصنيع فخاخ (4100016) -> 15 نقطة
    17: (10, 1),    # دعم موارد / بطاقة (4100017) -> 10 نقطة
    18: (1, 40),    # مساعدة تحالف (4100018) -> 40 نقطة
    19: (10, 1),    # دعم بقوات (4100019) -> 10 نقطة
    20: (10, 1),    # دعم بالموارد (4100020) -> 10 نقطة
    21: (1, 20),    # تبرع لعلوم التحالف (4100021) -> 20 نقطة
    22: (2, 10),    # استلام بضائع الميناء (4100022) -> 20 نقطة
    23: (1, 20),    # استكشاف نافورة الكنوز (4100023) -> 20 نقطة
    24: (2, 10),    # التاجر العجيب (4100024) -> 20 نقطة
    25: (20, 1),    # كفاءة الجندي (4100025) -> 20 نقطة
    26: (15, 1),    # استكشاف الهرم (4100026) -> 15 نقطة
    27: (20, 1),    # متجر وسام الحرب (4100027) -> 20 نقطة
    28: (20, 1),    # إطعام الحيوان (4100028) -> 20 نقطة
    29: (10, 5),    # استهلاك ذهب (4100029) -> 50 نقطة
    30: (5, 3),     # تحدي الحلبة (4100030) -> 15 نقطة
    31: (5, 5),     # الحرب الملحمية (4100031) -> 25 نقطة
    32: (30, 1),    # تقوية المباني / نجوم (4100032) -> 30 نقطة
    33: (10, 1),    # قاعة الأوامر (4100033) -> 10 نقطة
}
```
*ملاحظة توافقية:* إذا ورد المفتاح كمعرف كامل مثل `"4100011"`، يتم تحويله بمعادلة `key % 4100000` أو مطابقته مباشرة في قاموس موسّع يدمج كلا الرقمين (`11` و `4100011`).

---

## 4. معيار فحص الذاكرة المسبق ومبدأ 0-Network (Zero-Network Pre-flight)

### 4.1 منطق التحقق الصارم بدون شبكة
عند استدعاء المهمة، تنفذ أولاً فحصاً كاملاً للذاكرة الحية الحالية:
1. تقرأ `everyday_ctrl = self.get_ctrl("everydayTaskCtrl")`.
2. إذا كان `everyday_ctrl` متوفراً ويحتوي على `eventInfo` و `normalRecord`، والوقت الحالي لم يتجاوز `tomorrowZeroUTC`:
   - تحسب النقاط الحالية `cur_points`.
   - تستخرج قائمة الصناديق الجاهزة للاستلام:
     `ready = [idx for idx, goal in CHEST_THRESHOLDS.items() if cur_points >= goal and str(idx) not in normalRecord]`
   - **إذا كانت القائمة فارغة (`len(ready) == 0`):**
     تتوقف المهمة فوراً وتعيد `TaskResult.ok(message=f"لا توجد صناديق جاهزة للاستلام (النقاط الحالية: {cur_points})")`.
   - **النتيجة المحققة:** تم التحقق بنسبة 100% دون إرسال بايت واحد عبر الشبكة! (0-Network Check كامل ومطابق للبند 2 والبند 6 من دستور المشروع).

---

## 5. الاستعلام الاحتياطي الآمن وإعادة المزامنة (Safe Fallback Query)

### 5.1 حالات تفعيل الاستعلام الاحتياطي
يتم تفعيل الاستعلام الشبكي الاحتياطي حصراً في الحالات التالية:
1. عدم وجود كائن `everydayTaskCtrl` نهائياً داخل `conn.init_data`.
2. عدم وجود قاموس `eventInfo` أو `normalRecord` داخل المتحكم (حالة بيانات غير مكتملة).
3. تجاوز الطابع الزمني الحالي لموعد التصفير اليومي (`time.time() >= tomorrowZeroUTC > 0`).

### 5.2 حزمة الاستعلام الاحتياطي
- إرسال استعلام آمن عبر فئة الأساس:
  ```python
  resp = await self.safe_query("2027", "1", {}, min_delay=0.3, max_delay=0.7)
  ```
- معالجة الاستجابة ومزامنة الذاكرة الحية فورياً:
  ```python
  if resp and isinstance(resp.get("data"), dict):
      ctrl = self.conn.init_data.setdefault("everydayTaskCtrl", {})
      ctrl.update(resp["data"])
  ```
- بعد المزامنة، يتم استئناف عملية فحص الصناديق الجاهزة واستلامها.

---

## 6. التكامل في `bot_manager.py` وضمان التنفيذ كآخر مهمة (Task Sequencing Guarantee)

### 6.1 كيفية جدولة المهام في حلقة `CastleBot`
في `bot_manager.py` (الأسطر 582-641)، تنفذ الدالة `execute_tasks()` المهام بالترتيب التتابعي الصارم المسجل في قائمة `REGISTERED_TASKS`:
```python
for task_cls in REGISTERED_TASKS:
    # تشغيل المهمة وانتظار نتيجتها...
```

### 6.2 الضمان الرياضي لتنفيذها كآخر مهمة
بما أن قوائم بايثون (`list`) تحتفظ بترتيب العناصر كما أُدخلت، فإن وضع فئة المهمة الجديدة `DailyQuestTask` (أو `DailyActivityTask`) كـ **آخر عنصر تماماً** في نهاية قائمة `REGISTERED_TASKS` يضمن بنسبة 100% ما يلي:
1. تشغيل كافة مهام البوت الـ 18 السابقة أولاً:
   - مهام تدريب الجنود (`TrainTask`, `DailyTrainTask`) -> تضيف حتى 100+ نقطة.
   - مهام البناء والمعهد (`BuildingTask`, `ResearchTask`) -> تضيف 60 نقطة.
   - مهام التحالف (`AllianceTask`) -> تضيف حتى 60 نقطة.
   - مهام المشفى والحدادة والمواد والزهور والهرم والحيوان والمتجر والميناء.
2. كافة هذه المهام تزيد عدادات `everydayTaskCtrl.eventInfo` تلقائياً أثناء تنفيذها.
3. عند وصول دور `DailyQuestTask` في نهاية الدورة، تكون القلعة قد حصدت أقصى نقاط نشاط ممكنة لذلك اليوم.
4. تقوم المهمة بفتح كافة الصناديق التي فُتحت عتباتها دفعة واحدة.

### 6.3 التصنيف التلقائي والإلزامي (`ALWAYS_AUTO_TASKS`)
وفق نص المتطلب R1:
> "Implement a mandatory task to collect and claim ready daily activity quest chests."

- يتم إضافة اسم المهمة البرمجي (`"daily_quest"`) إلى مجموعة المهام الإلزامية في `bot_manager.py`:
  ```python
  ALWAYS_AUTO_TASKS: Set[str] = {
      "port", "merchant_ship", "daily_sign", "city_harvest",
      "imperial_mausoleum", "war_medal", "daily_quest"
  }
  ```
- وإدراجها في التكوين الافتراضي:
  ```python
  DEFAULT_BOT_CONFIG["tasks"]["daily_quest"] = {"enabled": True}
  ```
- وبذلك تعمل تلقائياً وإلزامياً لكافة القلاع دون الحاجة لأي تفعيل يدوي من المستخدم، مع بقاء إمكانية التعطيل الصريح إن رغب المستخدم بذلك.

---

## 7. الالتزام الصارم بمسار الطبقات الست (The 6-Stage Pipeline Alignment)

وفقاً للبند 3 والبند 5 من دستور `GEMINI.md`، يجب أن تمر المهمة بالطبقات الست دون أي استثناء:
1. **Backend Task:** إنشاء الملف `tasks/daily_quest.py` وتصديره في `tasks/__init__.py`.
2. **Bot Manager:** تسجيل الفئة في `REGISTERED_TASKS` (كآخر عنصر)، وفي `DEFAULT_BOT_CONFIG`، وفي `ALWAYS_AUTO_TASKS`، ومتابعة قراءتها في `reload_config_from_db()`.
3. **API Whitelist:** إضافة `daily_quest: Optional[SimpleToggleConfig] = None` في `CastleConfigModel` داخل `api_server.py`.
4. **Database Migration:** تنفيذ سكربت ترحيل لتحديث حقل `config` لكافة القلاع في `database/castles.db` بالقيمة الافتراضية `{"daily_quest": {"enabled": True}}`.
5. **Frontend Defaults:** إضافة `daily_quest?: BaseTaskConfig` في `dashboard/src/types/index.ts` وقيمتها الافتراضية في `useCastles.ts`.
6. **Frontend UI & Dual-Save:** إضافة مفتاح التحكم في `TaskTabContent.tsx` ضمن قسم النشاط اليومي وتحديث كلا مساري الحفظ (`performSave()` و `handleSave()`) مع ملفات الترجمة الثلاثة (`ar.json`, `en.json`, `tr.json`).

---

## 8. التصميم البرمجي الجاهز للتنفيذ (Concrete Code Implementation Blueprints)

### 8.1 ملف المهمة: `tasks/daily_quest.py`
```python
# -*- coding: utf-8 -*-
"""
tasks/daily_quest.py — مهمة استلام صناديق النشاط اليومي الجاهزة (DailyQuestTask)
══════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. تعمل كآخر مهمة في دورة البوت بعد إنجاز كافة الأنشطة اليومية الأخرى.
  2. فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight):
     - احتساب مجموع نقاط النشاط الحالية من everydayTaskCtrl.eventInfo.
     - استخراج الصناديق الجاهزة ومقارنتها بسجل الصناديق المستلمة everydayTaskCtrl.normalRecord.
     - إذا لم يكن هناك أي صندوق جاهز، تتوقف فوراً دون إرسال أي طلب شبكي.
  3. استعلام احتياطي آمن (Safe Fallback Query):
     - في حال غياب المتحكم من الذاكرة الحية أو انتهاء صلاحية اليوم (tomorrowZeroUTC)،
       يتم إرسال CMD 2027 / SUBCMD 1 لإعادة مزامنة الذاكرة ثم استلام الصناديق.
  4. استلام الصناديق عبر CMD 2027 / SUBCMD 2 حصراً (الأمر الرسمي المجاني) مع فواصل بشرية.
  5. مزامنة فورية للذاكرة الحية محلياً لمنع أي استعلامات لاحقة.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية للمهام اليومية
CMD_EVERYDAY_TASK_MODULE = "2027"
REQ_EVERYDAY_TASK_INIT = "1"            # استعلام المزامنة الشامل
REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"   # استلام الصناديق اليومية الثمانية المجانية

# جدول الصناديق الثمانية وعتبات النقاط المطلوبة لكل صندوق (من daily_reward_point_items.lua)
CHEST_MILESTONES: List[Tuple[int, int]] = [
    (1, 30),
    (2, 70),
    (3, 120),
    (4, 180),
    (5, 260),
    (6, 340),
    (7, 420),
    (8, 500),
]

# جدول إعدادات نقاط المهام الـ 33 الرسمية: {task_type: (points_per_action, max_limit_time)}
# مستخرج ومطابق تماماً لـ daily_reward_point_config.lua
DAILY_QUEST_POINT_RULES: Dict[int, Tuple[int, int]] = {
    1: (3, 5),      # جمع قمح (4100001)
    2: (3, 5),      # جمع خشب (4100002)
    3: (3, 5),      # جمع حديد (4100003)
    4: (3, 5),      # جمع فضة (4100004)
    5: (3, 5),      # قتل وحوش (4100005)
    6: (30, 1),     # تطوير مبنى (4100006)
    7: (30, 1),     # بحث معهد (4100007)
    8: (2, 10),     # إهداء زهور (4100008)
    9: (20, 1),     # تصنيع عتاد (4100009)
    10: (10, 1),    # تجميع مواد (4100010)
    11: (3, 5),     # علاج مصابين (4100011)
    12: (5, 5),     # تدريب مشاة (4100012)
    13: (5, 5),     # تدريب رماة (4100013)
    14: (5, 5),     # تدريب فرسان (4100014)
    15: (5, 5),     # تدريب عربات (4100015)
    16: (3, 5),     # تصنيع فخاخ (4100016)
    17: (10, 1),    # قلب بطاقة دعم الموارد (4100017)
    18: (1, 40),    # مساعدة أعضاء التحالف (4100018)
    19: (10, 1),    # دعم التحالف بالقوات (4100019)
    20: (10, 1),    # دعم التحالف بالموارد (4100020)
    21: (1, 20),    # تبرع لعلوم التحالف (4100021)
    22: (2, 10),    # استلام بضائع الميناء (4100022)
    23: (1, 20),    # استكشاف نافورة الكنوز (4100023)
    24: (2, 10),    # الشراء من التاجر العجيب (4100024)
    25: (20, 1),    # كفاءة الجندي (4100025)
    26: (15, 1),    # استكشاف الهرم (4100026)
    27: (20, 1),    # متجر وسام الحرب (4100027)
    28: (20, 1),    # إطعام الحيوان (4100028)
    29: (10, 5),    # استهلاك الذهب (4100029)
    30: (5, 3),     # تحدي الحلبة (4100030)
    31: (5, 5),     # الحرب الملحمية (4100031)
    32: (30, 1),    # تقوية المباني (4100032)
    33: (10, 1),    # قاعة الأوامر (4100033)
}


class DailyQuestTask(BaseTask):
    """
    مهمة فحص واستلام صناديق النشاط اليومي الجاهزة (صناديق الـ 500 نقطة).
    """
    name = "daily_quest"
    alias = "daily_activity"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    @property
    def is_active(self) -> bool:
        """المهمة مفعلة افتراضياً كنشاط تلقائي ما لم يعطلها المستخدم صراحة."""
        return bool(self.config.get("enabled", True))

    @staticmethod
    def calculate_cur_points(event_info: Dict[str | int, Any]) -> int:
        """
        احتساب مجموع نقاط النشاط اليومي الحالية من سجل eventInfo.
        يطابق دالة everydayTaskCtrl:calCurPoint() الرسمية.
        """
        if not isinstance(event_info, dict):
            return 0

        total = 0
        for raw_k, raw_count in event_info.items():
            try:
                k_int = int(raw_k)
                # مطابقة النوع سواء أكان رقماً مجرداً (1..33) أو ID كامل (4100001..4100033)
                task_type = k_int % 4100000 if k_int > 4100000 else k_int
                rule = DAILY_QUEST_POINT_RULES.get(task_type)
                if rule:
                    point, limit_time = rule
                    count = int(raw_count or 0)
                    total += point * min(count, limit_time)
            except (ValueError, TypeError):
                continue
        return total

    @staticmethod
    def get_unclaimed_ready_chests(cur_points: int, normal_record: Dict[str | int, Any]) -> List[int]:
        """
        استخراج قائمة فهارس الصناديق الجاهزة للاستلام التي لم تُستلم اليوم بعد.
        """
        claimed_keys = {str(k) for k in normal_record.keys()} if isinstance(normal_record, dict) else set()
        ready = []
        for index, threshold in CHEST_MILESTONES:
            if cur_points >= threshold and str(index) not in claimed_keys:
                ready.append(index)
        return ready

    async def _ensure_synced_memory(self) -> Tuple[Optional[Dict[str, Any]], bool]:
        """
        التحقق من جاهزية متحكم everydayTaskCtrl في الذاكرة الحية.
        إذا كان مفقوداً أو منتهي الصلاحية، يتم إرسال الاستعلام الاحتياطي الآمن (CMD 2027 / SUBCMD 1).
        يعيد: (everyday_ctrl, was_queried_over_network)
        """
        ctrl = self.get_ctrl("everydayTaskCtrl")
        now_ts = int(time.time())

        # فحص هل البيانات الحالية صالحة ومحدثة
        if isinstance(ctrl, dict) and isinstance(ctrl.get("eventInfo"), dict) and isinstance(ctrl.get("normalRecord"), dict):
            tomorrow_zero = int(ctrl.get("tomorrowZeroUTC", 0) or 0)
            # إذا لم ينتهِ اليوم بعد، نعتمد على الذاكرة الحية فوراً (0-Network)
            if tomorrow_zero == 0 or now_ts < tomorrow_zero:
                return ctrl, False

        # تنفيذ الاستعلام الاحتياطي الآمن عند نقص البيانات أو تجدد اليوم
        self.log("📡 [صناديق النشاط] استعلام احتياطي لتحديث بيانات المهام اليومية من السيرفر (CMD 2027/1)...")
        resp = await self.safe_query(CMD_EVERYDAY_TASK_MODULE, REQ_EVERYDAY_TASK_INIT, {})
        if resp and isinstance(resp.get("data"), dict):
            if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                ctrl = self.conn.init_data.setdefault("everydayTaskCtrl", {})
                ctrl.update(resp["data"])
                return ctrl, True

        return (ctrl if isinstance(ctrl, dict) else None), True

    async def run(self) -> TaskResult:
        """تنفيذ دورة فحص واستلام الصناديق الجاهزة كآخر مهمة في الدورة."""
        # 1. جلب/مزامنة بيانات متحكم النشاط اليومي
        everyday_ctrl, queried = await self._ensure_synced_memory()
        if not isinstance(everyday_ctrl, dict):
            return TaskResult.skip("تعذر الحصول على بيانات everydayTaskCtrl من الذاكرة أو السيرفر.")

        event_info = everyday_ctrl.get("eventInfo") if isinstance(everyday_ctrl.get("eventInfo"), dict) else {}
        normal_record = everyday_ctrl.get("normalRecord") if isinstance(everyday_ctrl.get("normalRecord"), dict) else {}

        # 2. احتساب النقاط الحالية
        cur_points = self.calculate_cur_points(event_info)

        # 3. فحص الصناديق الجاهزة
        ready_chests = self.get_unclaimed_ready_chests(cur_points, normal_record)

        # فحص 0-Network: إذا لم يكن هناك أي صندوق جاهز ولم نرسل استعلاماً، ننهي فوراً دون شبكة
        if not ready_chests:
            network_status = "عبر الاستعلام الاحتياطي" if queried else "من الذاكرة الحية 0-Network"
            return TaskResult.ok(f"لا توجد صناديق جديدة جاهزة للاستلام ({network_status}) — النقاط الحالية: {cur_points}/500.")

        self.log(f"🎁 [صناديق النشاط] تم رصد {len(ready_chests)} صندوق جاهز للاستلام (النقاط: {cur_points}/500 | الصناديق: {ready_chests}).")

        # 4. فتح الصناديق الجاهزة تتابعياً مع فواصل بشرية آمنة
        claimed_count = 0
        claimed_indices = []

        for index in ready_chests:
            threshold = dict(CHEST_MILESTONES).get(index, 0)
            self.log(f"📦 [صناديق النشاط] جاري استلام الصندوق {index} ({threshold} نقطة)...")

            # إرسال حزمة الاستلام الرسمية (CMD 2027 / SUBCMD 2)
            res = await self.safe_query(
                CMD_EVERYDAY_TASK_MODULE,
                REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
                {"index": index},
                min_delay=0.6,
                max_delay=1.2,
            )

            # فحص الاستجابة وتحديث الذاكرة الحية فورياً
            if res and res.get("err") in (None, 0):
                claimed_count += 1
                claimed_indices.append(index)
                normal_record[str(index)] = 1
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
            else:
                err_code = res.get("err") if res else "NoResponse"
                self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")

        if claimed_count > 0:
            return TaskResult.ok(
                f"تم استلام {claimed_count} صندوق نشاط يومي بنجاح (الصناديق: {claimed_indices}) — الرصيد: {cur_points} نقطة.",
                data={"claimed_chests": claimed_indices, "total_points": cur_points}
            )

        return TaskResult.fail(f"فشل استلام الصناديق الجاهزة {ready_chests}.")
```

---

### 8.2 التعديلات المطلوبة في `tasks/__init__.py`
```python
from tasks.daily_quest import DailyQuestTask

# وإضافتها في قائمة __all__:
__all__ = [
    # ... المهام السابقة ...
    "DailyQuestTask",
]
```

---

### 8.3 التعديلات المطلوبة في `bot_manager.py`
1. استيراد الفئة:
   ```python
   from tasks import (
       # ... المهام السابقة ...
       DailyQuestTask,
   )
   ```
2. إدراجها كـ **آخر عنصر** في `REGISTERED_TASKS`:
   ```python
   REGISTERED_TASKS = [
       PortTask,
       MerchantShipTask,
       ImperialMausoleumTask,
       CityHarvestTask,
       ShieldTask,
       BuildingTask,
       ResearchTask,
       FlowerTask,
       WonderMerchantTask,
       MaterialSynthesisTask,
       ForgeEquipmentTask,
       CureWoundedTask,
       AllianceTask,
       WarMedalTask,
       DailyTrainTask,
       PetTask,
       TreasureTask,
       TrainTask,
       DailyQuestTask,  # <--- تضمن التنفيذ الصارم كآخر مهمة في نهاية الدورة
   ]
   ```
3. تسجيلها في `ALWAYS_AUTO_TASKS`:
   ```python
   ALWAYS_AUTO_TASKS: Set[str] = {
       "port", "merchant_ship", "daily_sign", "city_harvest",
       "imperial_mausoleum", "war_medal", "daily_quest"
   }
   ```
4. تسجيل قيمتها الافتراضية في `DEFAULT_BOT_CONFIG`:
   ```python
   "daily_quest": {"enabled": True},
   ```

---

### 8.4 التعديلات المطلوبة في `api_server.py`
إضافة مفتاح المهمة في `CastleConfigModel`:
```python
class CastleConfigModel(BaseModel):
    # ... الإعدادات السابقة ...
    daily_quest: Optional[SimpleToggleConfig] = None
```

---

### 8.5 سكربت ترحيل قاعدة البيانات: `tools/migrate_daily_quest_config.py`
لتحديث كافة القلاع الحالية في `database/castles.db` بإعداد المهمة الافتراضي:
```python
import sqlite3
import json
import os

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

def migrate():
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute("SELECT castle_id, email, config FROM castle_states")
    rows = cur.fetchall()
    updated = 0
    for cid, email, cfg_str in rows:
        cfg = json.loads(cfg_str or "{}")
        if "daily_quest" not in cfg:
            cfg["daily_quest"] = {"enabled": True}
            cur.execute("UPDATE castle_states SET config = ? WHERE castle_id = ?", (json.dumps(cfg, ensure_ascii=False), cid))
            updated += 1
    conn.commit()
    conn.close()
    print(f"Migrated {updated} castles with daily_quest config.")

if __name__ == "__main__":
    migrate()
```

---

## 9. التقييم النهائي وجاهزية التسليم

كافة التفاصيل الهندسية، البروتوكولية، الذاكرية، والشفرات البرمجية محددة بدقة بالغة بنسبة 100% ومستوفية لجميع معايير القبول الخاصة بالمتطلب R1 ودستور العمل (`GEMINI.md` و `AGENTS_CONSTITUTION.md`).
تم إعداد تقرير التسليم `handoff.md` للمتابعة والتنفيذ.
