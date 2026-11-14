# تقرير التعدين الجنائي ومواصفات كود اللعبة: قاعة القيادة ومهام القيادة (Command Hall)

**المهمة**: التنقيب الجنائي العميق في كود اللعبة المصدري Lua وملفات التكوين الرسمية لاستخراج وتوثيق كافة مواصفات نظام "قاعة القيادة" (Command Hall / مهام القيادة في النشاط اليومي).  
**تاريخ التحليل**: 2026-11-01  
**نطاق الفحص**: `game_file/src/app/`, `game_file/localtb/`, `game_file/src/fgui/`, `game_file/src/app/localtb/`  
**المرجعية الدستورية**: `GEMINI.md`, `ORIGINAL_REQUEST.md`

---

## 1. الملفات والتكوينات والجداول المرجعية (Exact Lua Files & Configurations)

تم التحديد الدقيق لجميع ملفات النظام في كود اللعبة المصدري:

| تصنيف الملف | مسار الملف في كود اللعبة | الوظيفة ودوره في النظام |
|-------------|-------------------------|-------------------------|
| **وحدة التحكم المركزية** | `game_file/src/app/module/commandHall/commandHallCtrl.lua` | إدارة حالة قاعة القيادة، معالجة استجابات الشبكة، استقبال إشعارات السيرفر `NOTIFY_COMMAND_HALL` (608)، حساب الجوائز ومستويات القيادة. |
| **دوال ومساعدات النظام** | `game_file/src/app/module/commandHall/commandHallUtil.lua` | فحص الشروط، أنواع المهام المحتاجة لجيش، حساب أوقات المسير، مستويات الوحوش، ونقاط الخريطة. |
| **قارئ جداول الإعدادات** | `game_file/src/app/localtb/config_read/commandHallRead.lua` | قارئ الجداول الحي: جودة المهام، استهلاك الطاقة، جوائز النصر، أسماء وشخصيات NPC، واحتساب الخبرة. |
| **قاعدة بيانات المهام** | `game_file/src/app/localtb/config_server/newcommandhalltask.lua` (و `commandhalltask.lua`) | جدول المهام الـ 475 بكامل تفاصيلها (المعرفات، الأنواع 1-6، استهلاك اللياقة، الجودة، الجوائز). |
| **مجموعات وتصنيفات المهام** | `game_file/src/app/localtb/config_server/newcommandhallgroup.lua` (و `commandhallgroup.lua`) | توزيع المهام حسب درجات القوة والجودة من 1 إلى 5. |
| **مستويات القيادة والخبرة** | `game_file/src/app/localtb/config_server/newcommandhalllv.lua` (و `commandhalllv.lua`) | مستويات قاعة القيادة، الخبرة المطلوبة لكل مستوى، مضاعفات الضرر والجوائز. |
| **مستويات القوة والترقية** | `game_file/src/app/localtb/config_server/commandhallpower.lua` | شروط فتح مستويات القوة وجوائز الانتقال بين المراحل. |
| **حوارات المهام** | `game_file/src/app/localtb/config_client/newcommandhalldialogue.lua` | حوارات وأسئلة مهام المعلومات العسكرية (Type 3). |
| **واجهات وعناصر العرض** | `game_file/src/app/localtb/config_client/newcommandhallshow.lua` | أسماء المهام وأيقوناتها الست الرسمية ونصوص الأزرار. |
| **مهمة النشاط اليومي** | `game_file/src/app/localtb/config_server/daily_reward_point_config.lua` | تعريف المهمة رقم 33 بالنشاط اليومي (المعرف 4100033، تتطلب إنجاز 3 مهام، وتمنح 10 نقاط نشاط). |
| **بيانات النشاط اليومي** | `game_file/src/app/localtb/config_client/daily_reward_data.lua` | السجل 4100033: الاسم `commandhall_text_82` ("مهام القيادة")، الوصف `daily_reward_des_33` ("أكمل 3 مهام من مهام قاعة القيادة")، والأيقونة الرسمية `img_commandhall_entrance.png`. |
| **معرف المبنى ونظام التوجيه** | `game_file/src/app/game/gameGuide/gameMildGuideManager.lua` | السطر 882 يربط `gEverydayTaskType.COMMAND_HALL_TASK` (33) بمبنى قاعة القيادة `BUILDID.CommandHall = 30009`. |

---

## 2. المهام الفرعية لقاعة القيادة وشروط إنجازها (Subtasks, Task Types & Criteria)

يحدد تعداد اللعبة الرسمي `gCommandHallTaskType` (المعرف في `wholeDefine.lua` السطر 1365-1370) ستة أنواع من المهام الفرعية:

```lua
gCommandHallTaskType = {
    REBEL_ARMY_GROUP_TASK   = 1, -- فيلق الغزاة (Rebel Army Group)
    REBEL_ARMY_PIONEER_TASK = 2, -- طليعة الغزاة (Rebel Army Vanguard/Pioneer)
    DIALOGUE_TASK           = 3, -- المعلومات العسكرية / الحوار (Military Information)
    RESCUE_TASK             = 4, -- إنقاذ القرويين (Rescue Villagers)
    BATTLE_TASK             = 5, -- فريق الغزاة / قتال الخريطة (Rebel Squad Battle)
    SNIPE_HUNTER_TASK       = 6, -- القناص الصامت (Silent Sniper)
}
```

حالات المهمة `gCommandHallTaskStatue` (المعرفة في `wholeDefine.lua` السطر 1372-1374):
- `PREPARE = 1`: قيد التجهيز / لم تبدأ بعد.
- `BEGIN = 2`: قيد التنفيذ أو معروضة في الخريطة / القائمة.
- `FINISH = 3`: مكتملة وجاهزة لاستلام الجائزة عبر `REQ_COMMAND_HALL_COMMIT_TASK`.

### جدول تفصيلي للمهام الفرعية:

| النوع | اسم المهمة (عربي / كود) | نطاق المعرفات (Task IDs) | استهلاك اللياقة (SP) | هل تتطلب فيلق/جيش؟ | آلية التنفيذ والإنجاز البرمجي |
|---|---|---|---|---|---|
| **Type 1** | **فيلق الغزاة**<br>`REBEL_ARMY_GROUP_TASK` | 1001 – 1051 | **0 لياقة** (مجاني تماماً) | نعم (تشكيل دفاع وهجوم) | هجوم مباشر عبر الأمر الشبكي `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP` (CMD 2274 SubCMD 7). لا يتطلب مسيراً على الخريطة الخارجية. |
| **Type 2** | **طليعة الغزاة**<br>`REBEL_ARMY_PIONEER_TASK` | 2001 – 2050 | 5 لياقة (SP) | نعم (مسير خريطة) | ظهور NPC على الخريطة الخارجية عند `(obj.x, obj.y)`، إرسال فيلق عبر أمر الزحف `CMD 1007 SubCMD 2` بنوع خط السير `moveLineTypeCommandHallNpc = 15`. |
| **Type 3** | **المعلومات العسكرية**<br>`DIALOGUE_TASK` | 3001 – 3094 | 5 لياقة (SP) | **لا (بدون جيش)** | مهمة حوارية داخلية. تنتهي فوراً بإرسال أمر الإنهاء `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) ثم استلام الجائزة عبر أمر الاعتماد (SubCMD 8). |
| **Type 4** | **إنقاذ القرويين**<br>`RESCUE_TASK` | 4001 – 4093 | 5 لياقة (SP) | **لا (بدون جيش)** | مهمة فورية آمنة 100%. تنتهي فوراً بإرسال أمر الإنهاء `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) ثم استلام الجائزة عبر أمر الاعتماد (SubCMD 8). |
| **Type 5** | **فريق الغزاة**<br>`BATTLE_TASK` | 5001 – 5094 | 5 لياقة (SP) | نعم (مسير خريطة) | ظهور NPC على الخريطة عند إحداثيات `(obj.x, obj.y)`، يتطلب إرسال فيلق مسير بـ `CMD 1007 SubCMD 2`. عند وصول الفيلق والانتصار تتحول الحالة إلى `FINISH` (3). |
| **Type 6** | **القناص الصامت**<br>`SNIPE_HUNTER_TASK` | 6001 – 6093 | 5 لياقة (SP) | **لا (بدون جيش)** | لعبة تصويب مصغرة (`SneakSnipeGame`). سيرفر اللعبة يقبل إكمالها مباشرة عند إرسال `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) مثل مهام الحوار والإنقاذ. |

---

## 3. حزم بروتوكول الشبكة والأوامر والحمولات (Network Packets: CMD & SubCMD)

تستخدم قاعة القيادة وحدة الأوامر الرسمية:
**`CMD_COMMAND_HALL_MODULE = "2274"`** (من `cmdDef.lua` السطر 3242)

| SubCMD | اسم الأمر في كود اللعبة | الوظيفة | حمولة الطلب (Request Payload) | بنية استجابة السيرفر (Response Payload) |
|---|---|---|---|---|
| **1** | `REQ_COMMAND_HALL_INIT` | استعلام حالة قاعة القيادة والمهام والخبرة | `{}` (فارغ) | `{ "err": 0, "rspdata": { "initData": { "commandLv": int, "commandExp": int, "powerLv": int, "armyGroupID": int, "commonTaskData": [...], "armyGroupTaskData": {...}, "armyPioneerTaskData": {...}, "finishTaskData": {...}, "nextRefreshTime": int } } }` |
| **2** | `REQ_COMMAND_HALL_UPGRADE_COMMAND_LV` | ترقية مستوى قاعة القيادة عند اكتمال الخبرة | `{}` (فارغ) | `{ "err": 0, "rspdata": { "initData": {...}, "reward": [ { "id": int, "count": int }, ... ] } }` |
| **3** | `REQ_COMMAND_HALL_UPGRADE_POWER_LV` | ترقية مستوى القوة | `{}` (فارغ) | `{ "err": 0, "rspdata": { "initData": {...}, "reward": [...] } }` |
| **4** | `REQ_COMMAND_HALL_FINISH_GUIDE` | إنهاء خطوة التعليمات | `{}` | `{ "err": 0, "rspdata": {...} }` |
| **5** | `REQ_COMMAND_HALL_FINISH_TASK` | **إنهاء المهام الفورية** (الإنقاذ، الحوار، القناص) | `{ "index": <task_index> }` | `{ "err": 0, "rspdata": { "initData": {...}, "reward": [...] } }` |
| **6** | `REQ_COMMAND_HALL_SET_DEFEND` | ضبط تشكيلة الدفاع ضد فيلق الغزاة | `{ "armyInfo": [...], "heroInfo": [...], "armsInfo": [...], "divineBeastInfo": [...] }` | `{ "err": 0, "rspdata": { "initData": {...} } }` |
| **7** | `REQ_COMMAND_HALL_ATTACK_ARMY_GROUP` | **مهاجمة فيلق الغزاة** (Type 1) | `{ "armyInfo": [...], "heroInfo": [...], "armsInfo": [...], "divineBeastInfo": [...] }` | `{ "err": 0, "rspdata": { "initData": {...} } }` |
| **8** | `REQ_COMMAND_HALL_COMMIT_TASK` | **استلام جائزة المهمة المكتملة** (حالة FINISH) | `{ "commitType": <task.type>, "index": <task.index> }` | `{ "err": 0, "rspdata": { "initData": {...}, "reward": [ { "id": int, "count": int }, ... ] } }` |
| **9** | `REQ_COMMAND_HALL_REFRESH_POS` | تجديد موقع NPC على الخريطة | `{ "x": int, "y": int }` | `{ "err": 0, "rspdata": { "x": int, "y": int } }` |
| **10** | `REQ_COMMAND_HALL_REFRESH_POS2` | تجديد الموقع والانتقال إليه بالخريطة | `{ "x": int, "y": int }` | `{ "err": 0, "rspdata": { "x": int, "y": int } }` |

### حزمة إرسال الفيلق للمسير على الخريطة (Troop March Packet):
للمهمات التي تتطلب خروج فيلق على الخريطة (Type 2 و Type 5):
- **الأمر**: `CMD_KINGDOM_QUEUE_MODULE = "1007"`, `ADD_KINGDOM_QUEUE = "2"`
- **الحمولة (Payload)**:
```json
{
  "to": { "x": <target_x>, "y": <target_y>, "id": <instanceID> },
  "moveLineType": 15,
  "matrixType": 1,
  "army": [ { "id": <unit_id>, "num": 1 } ],
  "heroInfo": [],
  "armsInfo": [],
  "divineBeastInfo": [],
  "data": {
    "commandHallTaskType": <task.type>,
    "commandHallTaskID": <task.taskID>
  }
}
```
*ملاحظة فنية*: `moveLineType = 15` يطابق `gMapMoveLineType.moveLineTypeCommandHallNpc`، و `matrixType = 1` يطابق `moveLineMatrixTypeTroop`.

### إشعارات السيرفر التلقائية (Server Push Notifications):
- معرّف الإشعار: `gNotifyID.COMMAND_HALL` وهو القيمة `"NOTIFY_COMMAND_HALL"` (رقم الإشعار `608` في `cmdDef.lua`).
- يرسل السيرفر تحديثات فورية تتضمن `notifyType` و `initData` المحدثة:
  - `1`: `TIME_REFRESH` (تحديث التوقيت اليومي).
  - `2`: `CASTLE_UPGRADE` (ترقية القلعة).
  - `3`: `GROUP_TASK` (تحديث فيلق الغزاة).
  - `4`: `PIONEER_TASK` (وصول أو نتيجة طليعة الغزاة).
  - `5`: `COMMON_TASK` (نتيجة معركة NPC فريق الغزاة في الخريطة).
  - `6`: `MOVE_CITY_REFRESH_POS` (نقل المدينة وتجديد المواقع).
  - `7`: `SNIPE_HUNTER_TASK_REACH` (وصول القناص).

---

## 4. تدقيق الأمان واستهلاك الموارد وقاعدة الذهب الصفري (Zero-Gold & Resource Audit)

بناءً على الفحص الصارم لملفات `newcommandhalltask.lua` و `commandHallCtrl.lua`:
1. **لا يوجد أي شرط ذهب في مهام قاعة القيادة على الإطلاق:**
   - حقل `consume` في كافة المهام إما `0` (لفيلق الغزاة Type 1) أو `5` (لباقي المهام Type 2-6).
   - هذا الاستهلاك هو **نقاط لياقة الأمير (Lord Stamina / SP)** فقط، وليس ذهباً.
2. **محظورات الأمان الصارمة (Zero-Gold & Zero-Speedup Rule):**
   - **حظر شراء اللياقة بالذهب:** إذا كانت طاقة الأمير الحالية `curPhysical < 5`، يجب تخطي المهام والتوقف فوراً دون فتح نافذة شراء اللياقة `physicalBuyView` ودون صرف أي ذهب أو استخدام جرعات اللياقة من الحقيبة.
   - **حظر تسريع المسير:** يُمنع منعاً باتاً استدعاء أمر تسريع المسير (`CMD 1007 SubCMD 7` / `REQ_SPEED_QUEUE`) أو صرف عناصر التسريع أو الذهب على فيالق قاعة القيادة.
3. **تصنيف المهام الآمنة والمجانية 100%:**
   - **Type 3 (المعلومات العسكرية)** و **Type 4 (إنقاذ القرويين)**: مهام فورية بالكامل لا تحرك قوات، لا تتعرض لأي مخاطر، وتكتمل بطلب شبكي واحد وتستلم جائزتها فوراً.
   - **Type 1 (فيلق الغزاة)**: استهلاك طاقة = 0، قتال فوري عبر السيرفر.
   - **Type 2 (طليعة الغزاة)** و **Type 5 (فريق الغزاة)**: تتطلب مسيراً على الخريطة؛ تُنفذ فقط في حال توفر فيالق فارغة، وتُترك لتسير وتعود طبيعياً دون أي تسريع.

---

## 5. منطق إرسال الفيالق والتعامل مع عدم توفر فيالق (Troop March Logic & Slot Constraints)

وفق متطلبات `ORIGINAL_REQUEST.md` (R1) وكود `localUserQueueMgr.lua`:
1. **فحص الفيالق المتاحة مسبقاً (Pre-flight March Check):**
   - فحص طوابير المسير الحالية في الذاكرة الحية `conn.init_data.get("queueCtrl", {})` ومقارنتها بالحد الأقصى لفيالق القلعة.
2. **إلزامية الخروج السليم عند عدم توفر فيالق (Graceful Exit):**
   - إذا صادفت المهمة متطلب إرسال فيلق على الخريطة (Type 2 أو Type 5) ولم يكن هناك أي طابور مسير متاح (`remain_queues == 0`):
     - تلتزم المهمة بإكمال كافة المهام الفورية المتبقية (إنقاذ القرويين، حوار المعلومات العسكرية، استلام الصناديق الجاهزة).
     - ثم تخرج المهمة بنجاح (`TaskResult(success=True)`) مع تسجيل رسالة واضحة دون تعليق أو تكرار استعلامات غير مجدية.
3. **أقل قوة ممكنة للفيالق الآمنة:**
   - لإرسال الفيلق بأمان ومحاكاة العميل الرسمي، يتم إرسال جندي واحد فقط (أو التشكيلة المتاحة) لتجنب حجز القوات العسكرية للقلعة.

---

## 6. استلام الجوائز وتحديث الذاكرة الحية (Reward Claiming & State Synchronization)

1. **استلام جوائز المهام الفردية:**
   - عند اكتمال المهمة (الحالة `statue == 3` / `FINISH`)، يتم إرسال:
     `CMD 2274, SubCMD 8 (REQ_COMMAND_HALL_COMMIT_TASK)` مع `{ "commitType": task.type, "index": task.index }`.
   - السيرفر يعيد `rspdata.initData` المحدثة و `rspdata.reward`.
   - يتم تحديث `conn.init_data` محلياً لمنع إرسال أي استعلام تالٍ (0-Network Cache Sync).
2. **استلام جوائز ترقية المستوى (Level-up):**
   - عند اكتمال الخبرة `commandExp >= needExp`:
     إرسال `CMD 2274, SubCMD 2 (REQ_COMMAND_HALL_UPGRADE_COMMAND_LV)`.
3. **أثر المهمة على النشاط اليومي:**
   - كل مهمة يتم اعتمادها تسجل نقطة في عداد المهمة 33 في النشاط اليومي (`daily_reward_point_config.lua`).
   - عند إنجاز 3 مهام، تكتمل المهمة اليومية رقم 33 وتمنح القلعة **10 نقاط نشاط يومي** إضافية، مما يساهم في بلوغ عتبات صناديق الـ 500 نقطة التي تستلمها مهمة `daily_quest.py`.

---

## 7. الأيقونة الرسمية ومعلومات الواجهة (UI & Official Game Asset)

- **اسم المهمة الرسمي باللعبة**: `مهام القيادة` (من المفتاح المترجم `commandhall_text_82`).
- **وصف المهمة الرسمي**: `أكمل 3 مهام من مهام قاعة القيادة` (من المفتاح `daily_reward_des_33`).
- **الأيقونة الرسمية في ملفات اللعبة**:
  - `img_commandhall_entrance.png` (محددة في `daily_reward_data.lua` السطر 165، ومكون زر القاعة `Btn_commandHall.lua` السطر 10).
  - الأيقونات الفرعية: `icon_commandhall_task_01.png` إلى `icon_commandhall_task_06.png`.
- **الموقع في لوحة التحكم**:
  - قسم "المهام اليومية" (`daily` tab) في `TaskTabContent.tsx`.
  - عنصر تحكم واحد (Toggle Switch) تحت المعرف `command_hall`.

---

## 8. جدول الميزات المكتشفة (Features Discovered Table)

| # | الفئة (Category) | الميزة (Feature) | الوصف (Description) | المدخلات (Inputs) | المخرجات (Outputs) | سلوك الخطأ (Error Behavior) | تم الاكتشاف عبر |
|---|---|---|---|---|---|---|---|
| 1 | استعلام | مزامنة قاعة القيادة | جلب الحالة الحية والمهام والمستويات | `CMD 2274 SubCMD 1`, Payload `{}` | `initData` تحوي المهام والخبرة والمستويات | لا يحدث خطأ، يعيد `err: 0` | `commandHallCtrl.lua:241` |
| 2 | مهام فورية | إنهاء مهمة إنقاذ القرويين | إنهاء فوري بدون معركة أو مسير | `CMD 2274 SubCMD 5`, `{ "index": index }` | تحديث حالة المهمة والجوائز | `Err_COMMAND_HALL_NOT_ENOUGH_PHYSICAL` (716008) إذا اللياقة < 5 | `commandHallCtrl.lua:302` |
| 3 | مهام فورية | إنهاء مهمة المعلومات العسكرية | إتمام الحوار وإنهاء المهمة فوراً | `CMD 2274 SubCMD 5`, `{ "index": index }` | تحويل المهمة إلى `FINISH` | `716008` عند نقص اللياقة | `CommandHallTalkPanel.lua:66` |
| 4 | مهام فورية | إنهاء لعبة القناص الصامت | إتمام مهمة القناص برمجياً | `CMD 2274 SubCMD 5`, `{ "index": index }` | تحويل المهمة إلى `FINISH` | `716008` عند نقص اللياقة | `commandHallCtrl.lua:195` |
| 5 | استلام جوائز | اعتماد واستلام جائزة المهمة | استلام الموارد والخبرة للمهمة المنجزة | `CMD 2274 SubCMD 8`, `{ "commitType": type, "index": index }` | `rspdata.reward` و `initData` | `Err_COMMAND_HALL_NOT_FINISH_TASK` (716005) إذا لم تكتمل | `commandHallCtrl.lua:374` |
| 6 | ترقية | ترقية مستوى قاعة القيادة | رفع المستوى والحصول على جوائز الترقية | `CMD 2274 SubCMD 2`, Payload `{}` | مستوى جديد وجوائز بريد | `Err_COMMAND_HALL_NOT_ENOUGH_EXP` (716004) إذا الخبرة غير كافية | `commandHallCtrl.lua:256` |
| 7 | معارك حية | قتال فيلق الغزاة | هجوم مباشر ضد فيلق المتمردين (0 طاقة) | `CMD 2274 SubCMD 7`, تشكيلة الجيش | نتيجة المعركة وتحديث الضرر | `Err_COMMAND_HALL_ARMY_ILLEGAL` (716010) | `commandHallCtrl.lua:349` |
| 8 | مسير خريطة | مسير مهاجمة طليعة أو فريق الغزاة | إرسال فيلق على الخريطة إلى موقع NPC | `CMD 1007 SubCMD 2`, `moveLineType: 15` | طابور مسير جديد في `queueCtrl` | `Err_COMMAND_HALL_QUEUE_STATUE_ERROR` (716013) عند عدم وجود فيالق | `worldMapFunction.lua:237` |
| 9 | إشعارات | استقبال تحديثات السيرفر الحية | تحديث فوري للحالة بدون استعلام شبكي | Push Notification `608` | كائن بيانات الحدث | معالجة الحالات السبع بأمان وعزل تام | `commandHallCtrl.lua:43` |
| 10 | نشاط يومي | التقدم في نقاط النشاط اليومي | احتساب نقاط النشاط عند إنجاز 3 مهام | إنجاز 3 مهام قاعة القيادة | 10 نقاط في عداد الـ 500 نقطة اليومي | تكتمل مرة واحدة يومياً | `daily_reward_point_config.lua:260` |

---

## 9. جدول الحالات الحدية والاستثنائية (Edge Cases Table)

| # | الميزة (Feature) | الحالة الحدية (Input / Condition) | السلوك المرصود / الموصى به برمجياً (Observed / Recommended Behavior) |
|---|---|---|---|
| 1 | نقص اللياقة | `curPhysical < 5` عند محاولة تنفيذ مهمة | التوقف فوراً وتخطي المهمة، حظر شراء اللياقة بالذهب وفق قاعدة Zero-Gold. |
| 2 | عدم توفر فيالق مسير | جميع طوابير المسير مشغولة (`remain_queues == 0`) | إنجاز المهام الفورية غير المحتاجة لجيش (Type 3 و 4)، ثم الخروج السليم فوراً دون انتظار أو تعليق. |
| 3 | الوصول للحد الأقصى للمستوى | القاعة بلغت أقصى مستوى قيادة متاح | تخطي استدعاء أمر الترقية SubCMD 2 لتجنب الخطأ `716003`. |
| 4 | انعدام المهام الجاهزة | عدم وجود مهام بحالة `FINISH` (3) | عدم إرسال أمر الاعتماد SubCMD 8 نهائياً (0-Network). |
| 5 | عدم استجابة السيرفر | بطء الشبكة أو انتهاء المهلة الزمنية للطلب | التعامل عبر `safe_query` بمهلة محددة دون تعطيل حلقة البوت الرئيسية. |
| 6 | وجود فيلق الغزاة المتقدم | وصول فيلق الغزاة للقلعة أثناء الدورة | التعامل الآمن دون حظر الحساب ودون مقاطعة باقي المهام اليومية. |
