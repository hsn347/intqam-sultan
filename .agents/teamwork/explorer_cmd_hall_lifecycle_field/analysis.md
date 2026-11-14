# تقرير التحقيق الميداني والذاكرة الحية لمهام قاعة القيادة (Command Hall)
**مسار التقرير:** `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_lifecycle_field\analysis.md`  
**تاريخ التحقيق:** 2026-11-01  
**الوكيل المحقق:** مستكشف الفريق (Teamwork Explorer)  
**المرجعية:** دستور العمل (`GEMINI.md`)، والطلب الأساسي (`ORIGINAL_REQUEST.md`)

---

## 1. الملخص التنفيذي (Executive Summary)

كشف التحقيق الميداني والمصدري الشامل لمهام قاعة القيادة (`Command Hall`) في سيرفرات اللعبة الحية وقاعدة بيانات القلاع (`database/castles.db`) وكود العميل المصدري (`game_file/src/app/module/commandHall/` و `game_file/src/app/module/world/`) عن الأسباب الجذرية الدقيقة لظاهرة **الجمود لمدة 300 ثانية (5 دقائق)** وخروج البوت بـ **0 مكافأة** بعد إرسال الفيالق.

تم تأكيد النتائج التالية بأدلة برمجية وميدانية قطعية:
1. **الجمود الميداني (300s Freeze):** نتج عن حلقة مفرغة في دالة `run()` بملف `tasks/command_hall.py:971-1041`، حيث يتم ضبط عداد الفيالق `total_marches > 0` وتغيير حالة المهمة محلياً إلى `TASK_STATUE_PREPARE` دون أي متابعة ميدانية لمسير الفيلق ودون إرسال استعلام إعادة المزامنة الرسمي (`CMD 2274 / SUBCMD 1`). يظل شرط الخروج معطلاً، ويستمر البوت في النوم العشوائي حتى انتهاء المهلة القصوى للحلقة (`LOOP_MAX_DURATION_SECONDS = 300`).
2. **الخروج بـ 0 مكافأة (Zero-Rewards Exit):** نظراً لعدم تحديث الذاكرة أثناء مسير الفيلق، لا يعلم البوت بانتهاء المعركة وفوز الفيلق، وبالتالي لا يستدعي دالة استلام الجوائز `_claim_finished_tasks()` (التي ترسل استعلام `CMD 2274 / SUBCMD 8`)، فينتهي الوقت ويخرج بـ 0 مكافأة.
3. **التوقيت الحقيقي لمسير الفيالق في كود اللعبة:** أثبت كود اللعبة (`commandHallUtil.lua:310-318` و `queueTimeUtil.lua:327-333`) أن وقت مسير فيالق قاعة القيادة لا يتجاوز **5 ثوانٍ** (`COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5`) للمتمردين، و **2 ثانية** (`COMMANDHALL_COMMON_TASK_MARCH_TIME = 2`) للمهام العادية، ما يجعل النوم لمدة 300 ثانية خللاً جسيماً ومنافياً لنمط العميل الرسمي.
4. **بنية الذاكرة الحية (`conn.init_data`):** قاعة القيادة **ليست** من ضمن الـ 277 متحقماً التي يتم تحميلها تلقائياً عند الدخول للبوابة، بل تتطلب استعلام المزامنة الأولي `CMD 2274 / SUBCMD 1` (`REQ_COMMAND_HALL_INIT`). تم سحب البنية الحية للذاكرة مباشرة من خوادم اللعبة للحسابين `beetoo1` و `beetoo3` وتوثيق حقولها بدقة متناهية.

---

## 2. التحقيق في سكربتات وسجلات الفحص بـ `tools/` (Live Testing Scripts & Execution Logs)

### 2.1 فحص السكربتات الميدانية الموجودة
تم فحص كافة الأدوات في `tools/`:
1. `tools/test_command_hall_live.py`:
   - يقوم بتسجيل الدخول وإرسال استعلام المزامنة الأولي `conn.safe_query("2274", "1", {})` وطباعة النتيجة، ثم إغلاق الاتصال فوراً.
   - لا يختبر دورة حياة المهمة ولا يرسل فيالق ولا يتتبع الطوابير.
2. `tools/field_test_command_hall.py`:
   - يقوم بإنشاء كائن `CommandHallTask` ثم يستدعي `await task.safe_execute()`.
   - عند استدعاء `safe_execute()`، يدخل البوت في `task.run()`. فإذا كان الحساب يمتلك جنوداً وأبطالاً (مثل `beetoo3`)، يتم إرسال فيلق عبر الخريطة، ثم يدخل السكربت في نوم مستمر لمدة 300 ثانية دون أي استجابة حتى انتهاء المهلة القصوى، ويخرج برسالة `انتهاء مدة الدورة الزمنية (5 دقائق)`.
3. `tools/test_task_method.py`:
   - أداة ممتازة للاختبار المنفصل، ولكن تبين وجود نقص بسيط في السطر 43: استدعاء `import tasks` مباشرة دون إضافة مسار الجذر `sys.path.insert(0, _ROOT)`، مما يتسبب في `ModuleNotFoundError: No module named 'tasks'` عند التشغيل المباشر دون ضبط `PYTHONPATH=.`.
4. `tools/test_live_field_command_hall_verification.py`:
   - يتحقق من سلامة قاعدة البيانات `castles.db`، ويتحقق من حسابي `beetoo1` و `beetoo3`. لكنه يتوقف عند قراءة البيانات واستلام المهام الفورية دون متابعة مسير الفيالق ديناميكياً.

### 2.2 التشريح البرمجي الدقيق لخلل الـ 300 ثانية و 0 مكافأة
بالرجوع إلى `tasks/command_hall.py`:
- **السطر 66:**
  ```python
  LOOP_MAX_DURATION_SECONDS = 300
  ```
- **الأسطر 940-945 (`_handle_march_tasks`):**
  ```python
  res = await self.safe_query(CMD_KINGDOM_QUEUE_MODULE, REQ_ADD_KINGDOM_QUEUE, march_payload, ...)
  if res is not None:
      dispatched += 1
      task["statue"] = TASK_STATUE_PREPARE
      self._deduct_march_resources_in_memory(selected_troops, stamina_cost=5)
      self._update_hall_data_from_response(hall_data, res)
  ```
  * المشكلة الأولى: استجابة `CMD 1007 / SubCMD 2` هي `{"err": "0", "data": ...}`، ولا تحتوي على بيانات `rspdata.initData` الخاصة بقاعة القيادة.
  * المشكلة الثانية: تم وسم المهمة في الذاكرة المحلية بـ `task["statue"] = TASK_STATUE_PREPARE`.
- **الأسطر 1024-1041 (`run`):**
  ```python
  elapsed = int(time.time() - start_time)
  has_active_marches = (total_marches > 0)
  has_preparing_tasks = any(self._safe_int(t.get("statue", 0)) == TASK_STATUE_PREPARE for t in tasks)

  # شرط الخروج:
  if not pending_tasks and not has_active_marches and not has_preparing_tasks and elapsed >= 30:
      self.log("[CommandHall] ✓ تم إنجاز كافة مهام قاعة القيادة المتاحة واستلام جوائزها بنجاح.")
      break

  # النوم المتكرر:
  sleep_sec = random.uniform(4.0, 7.0)
  remaining_time = LOOP_MAX_DURATION_SECONDS - (time.time() - start_time)
  if remaining_time <= 0:
      exit_reason = "انتهاء مدة الدورة الزمنية (5 دقائق)"
      break
  await asyncio.sleep(min(sleep_sec, max(0.5, remaining_time)))
  ```
- **سلسلة الانهيار المنطقي (Logic Failure Chain):**
  1. المتغير `total_marches` عداد تراكمي (Accumulator)؛ بمجرد إرسال فيلق واحد يصبح `total_marches = 1`، وبالتالي `has_active_marches` تصبح `True` **بشكل دائم ومطلق** طوال عمر الحلقة ولا تعود إلى `False` أبداً!
  2. حالة المهمة `task["statue"]` بقيت `TASK_STATUE_PREPARE` في الذاكرة المحلية، لأن البوت لم يقم أبداً بإعادة إرسال استعلام `CMD 2274 / SUBCMD 1` لتحديث حالة المهمة بعد وصول الفيلق!
  3. دالة `_ensure_synced_data()` في السطر 556 تعيد البيانات المخزنة محلياً إذا كان `self._is_synced == True`، ولا ترسل أي استعلام للسيرفر!
  4. نتيجة لذلك: شرط الخروج `if not pending_tasks and not has_active_marches and not has_preparing_tasks` يستحيل أن يتحقق رياضياً ومنطقياً!
  5. يدخل البوت في حلقة نوم مستمرة (4-7 ثوانٍ) حتى تنقضي 300 ثانية كاملة.
  6. نظراً لعدم تحديث الذاكرة بالسيرفر، تظل المهمة في حالة `PREPARE` بدلاً من `FINISH`، فلا يتم استدعاء استلام المكافآت، ويخرج البوت بـ `claimed: 0`!

---

## 3. بنية الذاكرة الحية في القلاع النشطة (Live Memory Data Structures)

تم فحص حسابات قاعدة البيانات الحقيقية في `database/castles.db` والاتصال المباشر بخادم اللعبة:
- `sultan_beetoo1` (`beetoo1@hotmail.com`) — قلعة يو00نس (Lv.44، المملكة 150، UID: 11299184).
- `sultan_beetoo3` (`beetoo3@hotmail.com`) — قلعة محمد1رضى (Lv.60، المملكة 150، UID: 11307263).

### 3.1 حالة `conn.init_data` عند المصافحة الأولية
عند نجاح اتصال البوابة والمصافحة الرسمية (`CMD 1000 / SUBCMD 1`):
- يتم شحن **277 متحكماً** في الذاكرة الحية.
- المتحكمات المطابقة للكلمات الدلالية هي: `everydayTaskCtrl`, `mirajChallengeCtrl`, `questCtrl`, `conquestWarInfo`, `phoenixChallengeCtrl`, `newPlayerTaskCtrl`.
- **كائن `commandHall` غير موجود إطلاقاً** في الذاكرة الحية المبدئية عند تسجيل الدخول!
- **الاستنتاج الحاسم:** لا يمكن الاعتماد على وجود `commandHall` في `conn.init_data` عند الإقلاع؛ وإرسال `CMD 2274 / SUBCMD 1` إلزامي لشحنه في الذاكرة الحية لأول مرة.

### 3.2 البنية الميدانية الدقيقة لبيانات قاعة القيادة (`CMD 2274 / SUBCMD 1`)
من خلال الاستجابة الحية الرسمية الواردة مباشرة من خوادم اللعبة:

```json
{
  "cmd": "2274",
  "subcmd": "1",
  "err": "0",
  "rspdata": {
    "initData": {
      "commandLv": 9,
      "commandExp": 500,
      "powerLv": 1,
      "armyGroupID": 12,
      "firstArmyGroupTime": 1671529385,
      "autoTaskID": 3220,
      "nextRefreshTime": 1793558975,
      "armyPioneerTaskCount": 1,
      "version": 2,
      "armyGroupTaskData": { ... },
      "armyPioneerTaskData": { ... },
      "commonTaskData": [ ... ],
      "finishTaskData": { ... },
      "defendData": { ... }
    }
  }
}
```

#### تفصيل الحقول الرئيسية:
1. **`commandLv` & `commandExp`:** المستوى الحالي لقاعة القيادة والخبرة المتراكمة. يتم الترقية عند توفر الخبرة عبر `CMD 2274 / SUBCMD 2`.
2. **`armyGroupID`:** رقم دفعة/موجة الغزاة الحالية (مثال: الدفعة 2 في `beetoo1`، والدفعة 12 في `beetoo3`). كل دفعة تحتوي على مهام فرعية وفيلق مهاجم.
3. **`armyGroupTaskData` (مهمة جيش الغزاة المهاجم - Type 1):**
   - كائن يحتوي على: `type: 1`, `index: 91`, `taskID: 1012`, `statue: 2` (جاهز للقتال), `rabelHp: 800` (نقاط حياة العدو), `hurtHp: 100` (الضرر المتراكم المنفذ عليه), `armyGroupIsMoving: false`.
   - شن الهجوم الاستباقي عليه يتم عبر `CMD 2274 / SUBCMD 7` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`) بتكلفة **0 طاقة**.
   - عند اكتمال الضرر (`hurtHp >= rabelHp`) أو `statue == 3`، يتم استلام الجائزة عبر `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) بـ `commitType: 1`، مما يُفجر ترقية `armyGroupID` وظهور الدفعة التالية وتجديد كافة المهام!
4. **`armyPioneerTaskData` (طليعة الغزاة - Type 2 - مهمة فيلق):**
   - كائن يحتوي على: `type: 2`, `index: 100`, `taskID: 2012`, `statue: 2`, `npcId: 3306`, مع إحداثيات الهدف على الخريطة: `obj: {"x": 397, "y": 423, "faceTo": 2}`.
   - يتطلب إرسال فيلق عبر الخريطة بواسطة `CMD 1007 / SUBCMD 2`.
5. **`commonTaskData` (المهام الشائعة - Types 3, 4, 5, 6):**
   - في القلاع ذات المستويات المتقدمة (مثل `beetoo3`)، يكون هذا الحقل **قائمة (List)** تحتوي على عدة مهام (مثلاً 3 مهام معارك Type 5 في الدفعة 12):
     * مهمة 3216 (Type 5) عند `(398, 428)`.
     * مهمة 3217 (Type 5) عند `(388, 426)`.
     * مهمة 3219 (Type 5) عند `(393, 426)`.
   - في بعض الدفعات، يحتوي على مهام فورية مجانية لا تتطلب فيالق: الحوار (`Type 3`)، الإنقاذ (`Type 4`)، القنص (`Type 6`) والتي تُنجز فوراً عبر `CMD 2274 / SUBCMD 5` دون تحريك أي جيش.
6. **`finishTaskData` (قاموس المهام المنتهية المستلمة سابقاً):**
   - قاموس يسجل كافة المهام المكتملة عبر التاريخ وعدد مرات إنجازها (مثل: `{"1001": 1, "2001": 1, "3091": 1, "6091": 1, ...}`).

---

### 3.3 تمثيل الطوابير النشطة (`queueCtrl` ومسيرات الخريطة)

#### أ. كيف يمثل كود اللعبة طوابير المسير؟
من خلال فحص `kingdomQueueObjCell.lua:14-91`:
- يمثل كائن الطابور بالخصائص التالية:
  * `id`: المعرف الفريد لطابور المسير على الخريطة.
  * `type` / `queueType`: نوع الطابور (لقاعة القيادة: `15` وهو `moveLineTypeCommandHallNpc`).
  * `moveLineType`: نوع حركة المسير (`15`).
  * `status`: حالة الطابور المشتقة من `mapDef.lua:427-430`:
    - `0 = moveLineStatusTypeRally` (حشد)
    - `1 = moveLineStatusTypeMoving` (الفيلق في الطريق نحو الهدف)
    - `2 = moveLineStatusTypeWorking` (الفيلق في موقع الهدف يخوض المعركة)
    - `3 = moveLineStatusTypeFinished` (انتهت المعركة والفيلق في طريق العودة للقلعة)
  * `statusStartTime`: الطابع الزمني لبدء الحالة الحالية.
  * `statusEndTime`: الطابع الزمني لنهاية الحالة (وقت وصول الفيلق للهدف!).
  * `statusRemainTime`: الثواني المتبقية حتى الوصول (`statusEndTime - now`).
  * `from`: إحداثيات القلعة `{"x", "y", "uid"}`.
  * `to`: إحداثيات موقع مهمة قاعة القيادة `{"x", "y", "id"}`.

#### ب. كيف تصل تحديثات الطوابير من السيرفر؟
1. عند إرسال فيلق عبر `CMD 1007 / SUBCMD 2` (`REQ_ADD_KINGDOM_QUEUE`)، يرد السيرفر بـ `{"err": "0", "data": ...}`. هذا الرد يؤكد فقط قبول الخادم لأمر الإرسال.
2. تفاصيل الطابور النشط (بدايته، حركته، نهايته) يرسلها السيرفر كإشعار فوري (Server Push Notification):
   - اسم الإشعار: `NOTIFY_LOCAL_QUEUE_SYNC` (معرف `202`).
   - في `core/game_client.py:1438-1440` يتم تحديث:
     ```python
     self.local_queues = notify_data
     self.init_data['queueCtrl'] = {"queues": notify_data}
     ```
3. يمكن أيضاً للعميل طلب مزامنة فورية لطوابير الخريطة بإرسال:
   `CMD 1007 / SUBCMD 1000` (`REQ_KINGDOM_LOCAL_QUEUE_SYNC`).

#### ج. المدة الزمنية الحقيقية لمسير الفيلق (الحقيقة الصادمة):
كشف فحص `commandHallUtil.lua:310-318` و `queueTimeUtil.lua:327-333` عن الثوابت الرسمية للعبة:
- `COMMANDHALL_REBEL_ARMY_MARCH_TIME = 5` (وقت مسير فيلق المتمردين = **5 ثوانٍ فقط**!).
- `COMMANDHALL_COMMON_TASK_MARCH_TIME = 2` (وقت مسير المهام الشائعة = **ثانيتان فقط**!).
- دالة `queueTimeUtil.getArmyMoveDistance()` تنص صراحة:
  ```lua
  if worldMapTipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
      local marchTime = commandHallUtil.getRebelArmyMarchTime()
      if totalTime > marchTime then
          totalTime = marchTime
      end
  end
  ```
- **الخلاصة الميدانية:** مهام قاعة القيادة صُممت لتكون سريعة جداً؛ فالفيلق يصل إلى الهدف ويحسم المعركة في غضون **5 إلى 15 ثانية كحد أقصى**! وبالتالي فإن نوم البوت لمدة 300 ثانية هو خطأ برمجي كارثي تسبب في جمود تام.

---

## 4. استراتيجية التحقق الميداني وأداة الفحص المتخصصة (Field Verification Strategy)

لبناء أو تحديث أداة فحص واختبار متخصصة في `tools/`، نقترح هيكلية تحقق صارمة وميدانية تحقق المعايير التالية:

### 4.1 مصفوفة حسابات الاختبار في `database/castles.db`
1. **الحساب المقاتل (Combat March & Wave Testing):** `beetoo3@hotmail.com`
   - يمتلك **14,380 جندياً مقاتلاً** جاهزاً (مشاة، رماة، فرسان، عربات).
   - يمتلك أبطال قتال مؤهلين (مثل البطل 1705 و 1718).
   - قاعة القيادة بمستوى 9 والدفعة الحالية 12، وتحتوي على 3 مهام معارك Type 5 ومهمة طليعة Type 2.
   - هو الحساب المثالي لاختبار: إرسال الفيلق، والتتبع الديناميكي، واستلام المكافآت، وانتقال الدفعات.
2. **الحساب الآمن الفوري (Zero-Army Instant & Group Attack):** `beetoo1@hotmail.com`
   - يمتلك 0 جنود في `armyCtrl`.
   - يختبر مسار التجاوز الآمن للفيالق، وتنفيذ المهام الفورية، وشن هجوم جيش الغزاة المباشر (0 طاقة و 0 متطلبات جنود).

---

### 4.2 آلية التتبع الديناميكي الذكي للفيالق (Dynamic Queue Tracking)
بدلاً من حلقة النوم الثابتة (300s):
1. **لحظة إرسال الفيلق:**
   - إرسال `CMD 1007 / SUBCMD 2`.
   - تسجيل وقت الإرسال `march_dispatch_time = time.time()`.
   - تحديد مهلة التتبع الديناميكية: الحد الأدنى 5 ثوانٍ، الحد الأقصى 25 ثانية (لتغطية مسافة السير 5-10ث + المعركة 2-3ث + هامش تأخير شبكي).
2. **حلقة التتبع النشطة (Active Tracking Loop):**
   - حلقة تكرار كل **2.0 إلى 3.0 ثوانٍ** فقط.
   - في كل دورة: إرسال استعلام إعادة المزامنة `CMD 2274 / SUBCMD 1` لجلب أحدث حالة لقاعة القيادة.
   - فحص استجابة السيرفر:
     * إذا تغيرت حالة المهمة إلى `statue == 3` (`TASK_STATUE_FINISH`) أو أُضيفت إلى `finishTaskData`:
       يعلن البوت فوراً: `✓ حُسمت معركة الفيلق بنجاح! الانتقال لاستلام الجوائز...` ويخرج من حلقة انتظار الفيلق فوراً!
     * إذا انقضت المهلة القصوى (مثلاً 25 ثانية) دون تغير، يتم إرسال استعلام `CMD 1007 / SUBCMD 1000` للتأكد من طوابير الخريطة والخروج النظيف دون تعليق.

---

### 4.3 بروتوكول استلام المكافآت وتجديد الدفعات
1. **استلام الجوائز المستحقة فورياً:**
   - استدعاء استعلام `CMD 2274 / SUBCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`) مع المعاملات الحقيقية:
     `{"commitType": task_type, "index": task_index}`.
   - التحقق من نجاح الاستعلام وقراءة `rspdata.reward` أو زيادة عدد الجوائز المستلمة (`claimed > 0`).
2. **تجديد قائمة المهام وانتقال الدفعات (Wave Transition):**
   - عند استلام مكافأة هزيمة فيلق الغزاة (Type 1)، يعيد السيرفر دفعة جديدة برقم `armyGroupID` أعلى، وقائمة مهام جديدة.
   - يقوم البوت بتحديث الذاكرة فوراً ومتابعة المهام الجديدة في نفس الجلسة دون توقف.
3. **الخروج النظيف والآمن:**
   - عندما تكون كافة المهام الفرعية للدفعة منجزة ومستلمة، ويكون `nextRefreshTime` في المستقبل، يخرج البوت فوراً بنجاح ورسالة موجزة:
     `✓ تم إنجاز كافة مهام قاعة القيادة للدورة الحالية واستلام X مكافأة.` دون أي انتظار عشوائي.

---

### 4.4 معايير الأمان وحماية الموارد (Zero-Gold & Safe Teardown)
- **فحص الذهب الصارم (Zero-Gold Invariant):**
  تسجيل الذهب من `conn.init_data['lordInfoCtrl']['base']['gold']` قبل وبعد التشغيل، مع توكيد برمجي:
  `assert gold_after >= gold_before, "Gold was spent!"`.
- **فحص التسريعات والعناصر:** حظر أي مهمة تحتوي على `consumeGold` أو `consumeItem` أو `consumeSpeedup`.
- **الإغلاق النظيف للمقابس (Clean Socket Closure):**
  إغلاق الاتصال دائماً في كتلة `finally:` عبر `await conn.close()` لمنع تراكم اتصالات معلقة (Orphan Sockets).

---

## 5. الخلاصة والتوصيات (Conclusion & Recommendations)

| الجانب | الوضع الحالي المرصود | الحل الموصى به للتنفيذ |
|---|---|---|
| **مدة الحلقة** | جمود لمدة تصل إلى 300 ثانية بسبب `has_active_marches` المعلق | إزالة منطق `total_marches > 0` واستبداله بمتابعة الفيلق النشط والخروج فور انتهاء المهام |
| **تتبع الفيلق** | لا يوجد أي تتبع لمسير الفيلق بعد الإرسال | تتبع ديناميكي خفيف (كل 2-3 ثوانٍ) بحد أقصى 20-25 ثانية |
| **مزامنة الذاكرة** | `_ensure_synced_data` تمنع المزامنة إذا كانت `_is_synced == True` | إرسال `CMD 2274 / 1` فور وصول الفيلق لتحديث الذاكرة بحالة المعركة |
| **استلام الجوائز** | خروج بـ 0 مكافأة بسبب عدم علم البوت بانتهاء المهمة | استدعاء `CMD 2274 / 8` فورياً عند تحول المهمة لـ `statue == 3` |
| **أدوات الفحص بـ `tools/`** | `field_test_command_hall.py` يتجمد، و `test_task_method.py` ينقصه مسار الجذر | تحديث `test_task_method.py` بـ `sys.path.insert(0, _ROOT)`، وبناء أداة فحص ميداني ديناميكية |
