# تقرير الاستكشاف المعماري والتحليل الفني: مهمة قاعة القيادة (Command Hall Backend Architecture)

**المستكشف المعماري**: teamwork_explorer (`explorer_cmd_hall_backend_2`)  
**التاريخ**: 2026-11-01  
**نطاق التحقيق**: كود البوت `tasks/command_hall.py`، الذاكرة الحية `conn.init_data`، كود اللعبة الرسمي Lua (`game_file/src/`)، ونظام البوت وقاعدة البيانات.  
**المرجعية الدستورية**: `ORIGINAL_REQUEST.md`, `GEMINI.md`, `PROJECT_STRUCTURE.md`.

---

## 1. ملخص تنفيذي (Executive Summary)

أجرينا تدقيقاً جنائياً ومعمارياً شاملاً لكود مهمة قاعة القيادة `tasks/command_hall.py` في ضوء متطلبات طلب التطوير المعتمد `ORIGINAL_REQUEST.md` (المتطلبات R1، R2، R3، R4) مقارنة بالأكواد البرمجية المصدرية الرسمية للعبة (`game_file/src/app/module/commandHall/`, `game_file/src/fgui/`, `game_file/src/app/localtb/`).

تم تحديد **5 ثغرات معمارية رئيسية** في الكود الحالي:
1. **انعدام اختيار القوات وتحديد سعة المسير (R1)**: حزمة إرسال الفيلق الحالية في السطر 527 ترسل إحداثيات الهدف فقط بدون حقل `army` أو `troops`، وبدون حقل `heroInfo`، مما يخالف بروتوكول الزحف الرسمي `CMD 1007 / SubCMD 2`.
2. **غياب انتقاء أبطال القتال واستبعاد أبطال الجمع (R1)**: لا يوجد أي منطق لاستخراج الأبطال من الذاكرة الحية `heroSysCtrl.heroList`، ولا يتم استبعاد أبطال الجمع (نوع الدعم `heroType == 1` مثل 1711, 1717, 1724, 1733)، ولا فحص جاهزية البطل `state in (1, 5)`.
3. **تجاهل هجوم فيلق الغزاة المهاجمين للقلعة Type 1 (R2)**: الكود الحالي يتجاهل تماماً مهمة `TASK_TYPE_REBEL_GROUP = 1`، مع أنها مهمة مجانية (0 طاقة) تنفذ عبر الأمر الرسمي `CMD 2274 / SubCMD 7` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`)، وهي المسؤولة عن تجديد قائمة المهام وتقدم موجات الغزاة.
4. **تدقيق حزم الحوار والقناص الصامت (R3)**: أكد التحليل الجنائي أن حوار المعلومات العسكرية (Type 3) ولعبة القناص الصامت (Type 6) يتم إنهاؤهما عبر الخادم مباشرة باستخدام الحزمة المباشرة `CMD 2274 / SubCMD 5` مع `{"index": task.index}`، ثم استلام الجائزة بـ `SubCMD 8`، دون أي حاجة لمحاكاة رسومية.
5. **مزامنة الذاكرة الحية واستهلاك الموارد (R4)**: الحاجة إلى خصم الجنود وطوابير المسير والطاقة محلياً في الذاكرة الحية عقب كل إرسال ناجح لمنع التكرار أو تجاوز الحدود في نفس الدورة.

---

## 2. التدقيق التفصيلي للملفات والمتحكمات بالذاكرة الحية (Live Memory Controllers)

من خلال فحص عينات الذاكرة الحية الحقيقية (`docs/sample_live_memory.json`, `docs/beetoo1_live_memory.json`, `docs/lucifer_live_memory.json`):

### 1) متحكم الأبطال (`heroSysCtrl`)
- **الموقع بالذاكرة**: `conn.init_data.get("heroSysCtrl", {})`
- **الهيكل الداخلي**:
  ```json
  {
    "heroList": {
      "1707": {
        "heroID": 1707,
        "level": 60,
        "quality": 4,
        "state": 1,
        "skillList": { ... }
      }
    },
    "defendList": { "1701": { "heroID": 1701 } }
  }
  ```
- **حالات الأبطال الرسمية (`gHeroState` من `heroDef.lua`)**:
  - `HERO_STATE_NORMAL = 1`: بطل متفرغ داخل القلعة (جاهز للمسير فوراً).
  - `HERO_STATE_DEAD = 2`: بطل ميت.
  - `HERO_STATE_CAPTURED = 3`: بطل مأسور في سجن العدو.
  - `HERO_STATE_BATTLE = 4`: بطل في مسير خارجي نشط (محظور اختياره).
  - `HERO_STATE_DEFEND = 5`: بطل معين للدفاع على السور (مؤهل للمسير الخارجي وفق `WorldDispatchArmyViewPanel.lua:1380`).
  - `HERO_STATE_ESCAPE = 6`: بطل هارب.
  - `HERO_STATE_GARRISON = 7`: بطل في حامية.

### 2) تصنيف الأبطال (أبطال القتال مقابل أبطال الجمع)
- استناداً إلى ملف `app/localtb/config_client/hero_type_info.lua` و `hero_view_info.lua` و `local_arab.lua`:
  - **النوع 1 (`hero_typename_01`) = "نوع الدعم" (Auxiliary / Gathering / Support)**:
    - الأبطال ذوو المعرفات: `[1711, 1717, 1724, 1733]` (مثل البطل "الأنيق" 1711، وبطلة "فرحة" 1717).
    - **القاعدة الإلزامية**: يُستبعد استبعاداً صارماً أي بطل من النوع 1 من مهام مسير القتال لقاعة القيادة.
  - **الأنواع 2-5 = أبطال القتال المؤهلين**:
    - النوع 2: العربات الحربية (`1702, 1708`)
    - النوع 3: الفرسان (`1700, 1704, 1714, 1718, 1721...`)
    - النوع 4: الرماة (`1701, 1705, 1706, 1707, 1716...`)
    - النوع 5: المشاة (`1703, 1709, 1710, 1712, 1713...`)
  - **معيار الأفضلية في الانتقاء**:
    ترتيب الأبطال المؤهلين (`state in (1, 5)` و `heroID not in GATHERING_HERO_IDS`) تنازلياً حسب الجودة (`quality`) ثم المستوى (`level`).

### 3) متحكم الجيش والجنود (`armyCtrl`)
- **الموقع بالذاكرة**: `conn.init_data.get("armyCtrl", {})`
- **الحقول الرئيسية**:
  - `totalArmy`: قاموس يحتوي على عدد القوات المتاحة داخل القلعة مصنفة حسب معرف الوحدة `unit_id`:
    - المشاة: 401 إلى 412 (من T1 إلى T12).
    - الفرسان: 501 إلى 512.
    - الرماة: 601 إلى 612.
    - العربات: 701 إلى 712.
  - الجنود المتاحون للإرسال = الوحدات التي رصيدها `> 0` داخل `totalArmy`.

### 4) حساب سعة مسير الجيش (March Capacity Calculation)
- استناداً إلى `buildLogic.lua:1861-1904` و `build121.lua`:
  - مبنى ساحة التدريب (Drill Grounds / ميدان العرض): المعرف `BUILDID.DRILL_GROUDS = 121`.
  - موجود داخل قائمة مباني المدينة `cityCtrl.blist`:
    العنصر ذو `binfo.bid == '121'` أو `121`.
  - سعة المسير الأساسية تبدأ من 3000 عند المستوى 1، وتتصاعد حسب مستوى المبنى (5000 عند Lv.2، 7100 عند Lv.3، وهكذا)، بالإضافة إلى مستوى القلعة والأبحاث.
  - **قاعدة الأمان الرياضية**:
    `max_march_capacity = max(3000, drill_grounds_capacity)`
    يتم اختيار جنود من `totalArmy` (بدءاً من المستويات الأعلى كفاءة) بحيث لا يتجاوز الإجمالي `min(available_troops, max_march_capacity)`.
    وإذا كانت القلعة تحتوي على عدد محدود، يتم إرسال المتاح بأمان دون تجاوز السعة.

### 5) متحكم الطوابير والمسير (`queueCtrl`)
- **الموقع بالذاكرة**: `conn.init_data.get("queueCtrl", {})`
- الطوابير النشطة: عناصر `queueCtrl.queues` ذات `type == 1` (طوابير الجيوش الخارجية).
- الطوابير الشاغرة = `max(2, config.get("max_marches", 2)) - active_marches`.

---

## 3. تدقيق الثغرات مقابل متطلبات ORIGINAL_REQUEST.md

### R1. مهام مسير الغزاة (طليعة الغزاة 2، وفريق الغزاة 5)
- **الوضع الحالي في `command_hall.py` (سطر 527-533)**:
  ```python
  march_payload = {
      "to": {"x": target_x, "y": target_y},
      "moveLineType": MOVE_LINE_TYPE_COMMAND_HALL_NPC,
      "matrixType": MOVE_LINE_MATRIX_TYPE_TROOP,
      "taskIndex": task_index,
      "taskType": task_type,
  }
  ```
- **العيوب المكتشفة**:
  1. لا يوجد حقل `army` نهائياً! السيرفر يتوقع مصفوفة وحدات: `[{"id": unit_id, "num": count}, ...]`. إرسال طلب بدون قوات يؤدي إلى فشل المسير أو رفض السيرفر (`Err_COMMAND_HALL_ARMY_ILLEGAL = 716010`).
  2. لا يوجد حقل `heroInfo` نهائياً! السيرفر والعميل الرسمي يرسلان `heroInfo: [{"heroID": hid}]`. غياب البطل يقلل قوة الجيش وقد يتسبب في هزيمة الفيلق في معارك NPC.
  3. لا يتم حساب سعة المسير؛ يتم فقط قراءة الإجمالي كعدد مجرد دون تشكيل حزمة القوات.
  4. البنية الرسمية الصحيحة لحزمة المسير المستخرجة من `worldMapFunction.lua:206-222` و `kingdomMapCtrl.lua:140-180`:
     - الأمر: `CMD_KINGDOM_QUEUE_MODULE = "1007"`, `ADD_KINGDOM_QUEUE = "2"`
     - الحمولة (Payload):
       ```json
       {
         "to": { "x": target_x, "y": target_y, "id": instance_id },
         "moveLineType": 15,
         "matrixType": 1,
         "army": [
           { "id": 501, "num": 1000 }
         ],
         "heroInfo": [
           { "heroID": 1705 }
         ],
         "armsInfo": [],
         "divineBeastInfo": [],
         "data": {
           "commandHallTaskType": task_type,
           "commandHallTaskID": task_id
         }
       }
       ```

### R2. مهام القضاء على الغزاة (Type 1) وإنقاذ القرويين (Type 4)
- **الوضع الحالي**:
  - إنقاذ القرويين (Type 4) مدعومة بالفعل كأمر فوري عبر `CMD 2274 / SubCMD 5` ثم استلام الجائزة عبر `SubCMD 8`.
  - **فيلق الغزاة (Type 1 - `TASK_TYPE_REBEL_GROUP`) مفقودة بالكامل**:
    - مستثناة تماماً في سطر 497: `if task_type not in (TASK_TYPE_REBEL_PIONEER, TASK_TYPE_BATTLE): continue`.
    - لا يوجد أي استدعاء للأمر الرسمي `CMD 2274 / SubCMD 7` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`).
- **المعالجة المطلوبة**:
  - إضافة دالة مخصصة `_handle_rebel_group_attack(hall_data)`:
    - فحص وجود `armyGroupTaskData` في بيانات قاعة القيادة.
    - إذا كانت `statue == TASK_STATUE_FINISH` (3): يتم استلام جائزتها فوراً عبر `CMD 2274 / SubCMD 8` (`commitType: 1, index: task.index`).
    - إذا كانت `statue == TASK_STATUE_BEGIN` (2): يتم شن الهجوم المباشر (تستهلك 0 طاقة، ولا تحتاج طابور مسير خريطة) عبر إرسال `CMD 2274 / SubCMD 7` مع تشكيلة الجيش والأبطال المتاحة:
      `{"armyInfo": selected_army, "heroInfo": selected_heroes, "armsInfo": [], "divineBeastInfo": []}`.
    - عند هزيمة فيلق الغزاة، تتجدد تلقائياً قائمة المهام وتتقدم الموجة في السيرفر، وتظهر المهام الجديدة لاستلام مكافآتها.

### R3. مهام المعلومات العسكرية (Type 3) والقناص الصامت (Type 6)
- **المعلومات العسكرية (Type 3 - الحوار)**:
  - أثبت فحص `CommandHallTalkPanel.lua:65-67` أن شجرة الحوار والخيارات (اختيار الإجابة 1 أو 2) هي منطق واجهة محلي فقط (Client-side UI)، وعند انتهاء الحوار يرسل العميل مباشرة:
    `CMD 2274 / SubCMD 5` مع `{"index": task.index}`.
  - لا توجد أي معاملات إضافية لخيارات الحوار مرسلة للسيرفر.
- **القناص الصامت (Type 6)**:
  - أثبت فحص `commandHallCtrl.lua:185-197` و `CommandHallMainPanel.lua:590-616` أن لعبة القناص تنتهي بمجرد إرسال `CMD 2274 / SubCMD 5` مع `{"index": task.index}` (محاكاة فوز اللعبة المصغرة)، وتتحول حالة المهمة مباشرة إلى `FINISH` (3).
  - ثم يتم استلام الجائزة عبر `CMD 2274 / SubCMD 8` مع `{"commitType": 6, "index": task.index}`.
  - تنفيذها الحالي كأمر شبكي مباشر صحيح وسليم 100% ويحقق متطلب R3 بدقة دون محاكاة رسومية.

### R4. معايير الأمان والتوافق والوراثة من `BaseTask`
- المهمة ترث بالفعل من `BaseTask` وتحتوي على حماية استثنائية `0-Gold / 0-Speedup`.
- التحسينات المعمارية الإضافية المطلوبة:
  1. خصم الطاقة (5 SP) محلياً عند كل مهمة مرسلة، والتوقف التام عند `stamina < 5`.
  2. خصم القوات المرسلة وطابور المسير محلياً من كائنات الذاكرة الحية المؤقتة أثناء دورة المهمة لضمان عدم حدوث تعارضات.
  3. عزل كل خطوة بأمان تام في `try...except` داخلية لضمان عدم توقف الدورة عند تعذر استجابة أي مهمة فرعية.

---

## 4. تدقيق تكامل النظام وخط الأنابيب (Pipeline Integration Audit)

تم فحص الطبقات الست وفق دستور المشروع:

| الطبقة | الملف | الحالة الحالية | الملاحظات |
|---|---|---|---|
| 1. Backend Task | `tasks/command_hall.py` | مسجلة وموجودة | بحاجة لتحديث منطق المسير واختيار القوات والأبطال ومهاجمة فيلق الغزاة Type 1. |
| 2. Bot Manager | `bot_manager.py` | مسجلة 100% | مستوردة ومسجلة في `REGISTERED_TASKS` (سطر 88)، و `DEFAULT_BOT_CONFIG` (سطر 187)، و `reload_config_from_db()` (سطر 282). |
| 3. API Whitelist | `api_server.py` | مسجلة 100% | موجودة كنموذج `command_hall: Optional[SimpleToggleConfig] = None` في السطر 384. |
| 4. Database Migration | `database/castles.db` | مرحّلة 100% | تم الفحص المباشر: كافة القلاع الأربع تحتوي على `command_hall` في الـ `config` وفي `tasks`. |
| 5. Frontend Defaults | `dashboard/src/types/index.ts`, `useCastles.ts` | مسجلة 100% | موجودة مع القيم الافتراضية. |
| 6. Frontend UI & Dual-Save | `TaskTabContent.tsx` و ملفات الترجمة الثلاثة | مكتملة 100% | مدعومة في `performSave()` و `handleSave()` ومترجمة بالعربية والإنجليزية والتركية. |

---

## 5. المخطط المعماري المقترح للتنفيذ (Implementation Architecture Blueprint)

نقترح إعادة هيكلة `tasks/command_hall.py` بإضافة الدوال المساعدة التالية:

```python
# 1. قائمة معرفات أبطال الجمع المستبعدين
GATHERING_HERO_IDS: Set[int] = {1711, 1717, 1724, 1733}

# 2. استخراج أفضل أبطال القتال المؤهلين
def _select_combat_heroes(self) -> List[Dict[str, int]]:
    # قراءة heroSysCtrl.heroList
    # تصفية: state in (1, 5) و heroID not in GATHERING_HERO_IDS
    # ترتيب تنازلي حسب quality ثم level
    # إعادة [{"heroID": best_hero_id}] أو []

# 3. حساب سعة المسير وانتقاء تشكيلة الجنود
def _select_march_troops(self, max_capacity: Optional[int] = None) -> List[Dict[str, int]]:
    # قراءة armyCtrl.totalArmy
    # حساب سعة ساحة التدريب من cityCtrl.blist (bid 121) بحد أدنى 3000
    # اختيار القوات المتاحة حتى الوصول للسعة المحددة
    # إعادة [{"id": int(unit_id), "num": count}, ...]

# 4. تنفيذ هجوم فيلق الغزاة المهاجمين للقلعة (Type 1)
async def _handle_rebel_group_attack(self, hall_data: Dict[str, Any]) -> bool:
    # فحص armyGroupTaskData
    # إذا statue == 3 -> استلام الجائزة CMD 2274 SubCMD 8
    # إذا statue == 2 -> هجوم مباشر CMD 2274 SubCMD 7 (0 طاقة)
    # تحديث الذاكرة الحية واستلام جوائز التجديد

# 5. معالجة مهام المسير الخارجية (Type 2 و Type 5)
async def _handle_march_tasks(self, hall_data: Dict[str, Any]) -> Tuple[int, bool]:
    # فحص الشواغر (طوابير، جنود، طاقة)
    # اختيار القوات والأبطال
    # تركيب حمولة CMD 1007 SubCMD 2 الرسمية المتكاملة
    # خصم الموارد محلياً وتحديث حالة المهمة
```

هذا المخطط يغطي متطلبات R1 و R2 و R3 و R4 بالكامل ويحقق كافة معايير القبول.
