# Handoff Report: Live Account & Field Exploration for Command Hall
═══════════════════════════════════════════════════════════════════════════

**Agent**: Live Account & Field Explorer (`teamwork_explorer`)  
**Working Directory**: `e:\intqam-sultan\.agents\teamwork\explorer_cmd_hall_field_3\`  
**Milestone**: Command Hall & Field Testing Exploration  
**Deliverables**: `analysis.md`, `handoff.md`  
**Handoff Type**: Hard (Task Complete)

---

## 1. Observation (الملاحظات المباشرة والأدلة الصريحة)

1. **غياب `commandHall` عن حزمة تسجيل الدخول الأولية**:
   - تم فحص `docs/beetoo1_live_memory.json`، `docs/beetoo3_live_memory.json`، و `docs/lucifer_live_memory.json`:
     `commandHall in init_data == False` في جميع الملفات.
   - في كود اللعبة `game_file/src/app/module/commandHall/commandHallCtrl.lua` (السطور 25-26):
     يتم جلب البيانات لأول مرة عبر إرسال `CMD 2274 / SubCMD 1` (`REQ_COMMAND_HALL_INIT`).

2. **بنية الأبطال في الذاكرة الحية (`heroSysCtrl` وليس `heroCtrl`)**:
   - في تفريغ الذاكرة `docs/beetoo1_live_memory.json` (السطور 1981+):
     المفتاح الحقيقي هو `heroSysCtrl` وليس `heroCtrl`. يحتوي على `heroList` كقاموس لأرقام الأبطال:
     `heroID` (رقم البطل)، `level` (المستوى 1-60)، `quality` (الرتبة 1-5)، `state` (1=متاح، 2=ميت، 4=مسير)، و `queue` (طابور المسير).
   - في `game_file/src/app/module/general/PlayerTopModule.lua` (السطر 699-700):
     `name = "heroCtrl", key = "heroSysCtrl"`.
   - تصنيف أنواع الأبطال في `game_file/src/app/localtb/config_client/hero_view_info.lua` و `heroDef.lua`:
     * أبطال الجمع والمساعدة (`heroType == 1`): `[1711, 1717, 1724, 1733]`.
     * أبطال القتال المؤهلين للمسير (`heroType in (2, 3, 4, 5)`): كافة الأبطال الأخرى (مثل `1700, 1701, 1703, 1705, 1707, 1718, 1721`).

3. **بنية الجيوش في `armyCtrl` وتصنيف الوحدات**:
   - في تفريغات الذاكرة: `armyCtrl.totalArmy` يحتوي على أزواج `{"unit_id": "count"}`.
     - في `beetoo3`: `{'705': '1735', '606': '1735', '504': '5205', '401': '5705'}` (14,380 جندي).
     - في `lucifer`: `{'822': '5', '801': '1293', '812': '5', '401': '6431'}`.
     - في `beetoo1`: `{}` (0 جنود).
   - تصنيف الوحدات العسكرية في `armyDef.lua:35-38` و `armyinfo.lua:1-50`:
     * مشاة (`Infantry`): `401` إلى `410`.
     * رماة (`Archer`): `501` إلى `510`.
     * فرسان (`Cavalry`): `601` إلى `610`.
     * عربات وحصار (`Chariots/Siege`): `701` إلى `710`.
     * أفخاخ دفاعية ثابتة بالسور لا تسير: `801` إلى `825`.

4. **بنية الطوابير والمسيرات في `queueCtrl`**:
   - `queueCtrl` في الذاكرة الحية هو قاموس مباشر لأنواع الطوابير (مثل `'1202'` علاج، `'1203'` عربات، `'1204'` فرسان، `'1205'` رماة، `'1206'` مشاة، `'1212'` بحوث، و `'1221'` مسير خريطة).
   - ملاحظة خطأ كامن في `tasks/base_task.py:397`:
     البحث عن `queue_ctrl.get("queues")` يعيد دائماً قائمة فارغة لأن المفتاح غير موجود بصيغة الجمع.

5. **معلومات اللورد في `lordInfoCtrl`**:
   - في الذاكرة الحية:
     - الطاقة الحالية (Stamina / Health): `lordInfoCtrl.base.health` (100).
     - مستوى اللورد: `lordInfoCtrl.base.level` (beetoo1: 51, beetoo3: 52, lucifer: 57).
     - رصيد الذهب: `lordInfoCtrl.base.gold` (beetoo1: 103,473, beetoo3: 142,350, lucifer: 6,747).
     - مستوى الـ VIP: `lordInfoCtrl.vip.level` (beetoo1: 10, beetoo3: 9, lucifer: 11).

6. **حسابات قاعدة البيانات `database/castles.db` المتاحة**:
   - `sultan_beetoo1` (`beetoo1@hotmail.com`): `Active = 1`, `ConnState = idle`, `0` جنود.
   - `sultan_beetoo2` (`beetoo2@hotmail.com`): `Active = 1`, `ConnState = idle`.
   - `sultan_beetoo3` (`beetoo3@hotmail.com`): `Active = 1`, `ConnState = idle`, `14,380` جندي مقاتل.
   - `sultan_LUCIFER` (`LUCIFER@g4.com`): `Active = 1`, `ConnState = stopped`, `6,431` جندي مشاة.

7. **الأوامر الرسمية للمهام الست**:
   - فيلق الغزاة المهاجمين (نوع 1): `CMD 2274 SubCMD 7` (`REQ_COMMAND_HALL_ATTACK_ARMY_GROUP`).
   - طليعة الغزاة (نوع 2): مسير خريطة `CMD 1007 SubCMD 2` (`moveLineType: 15`).
   - المعلومات العسكرية (نوع 3): إنهاء فوري `CMD 2274 SubCMD 5` مع `{"index": index}`.
   - إنقاذ القرويين (نوع 4): إنهاء فوري `CMD 2274 SubCMD 5` مع `{"index": index}`.
   - فريق الغزاة (نوع 5): مسير خريطة `CMD 1007 SubCMD 2` (`moveLineType: 15`).
   - القناص الصامت (نوع 6): إنهاء فوري بحزمة الشبكة المباشرة `CMD 2274 SubCMD 5` مع `{"index": index}` دون محاكاة رسومية.
   - استلام جوائز أي مهمة منجزة (`statue == 3`): `CMD 2274 SubCMD 8` (`REQ_COMMAND_HALL_COMMIT_TASK`).
   - ترقية قاعة القيادة عند توفر الخبرة: `CMD 2274 SubCMD 2` (`REQ_COMMAND_HALL_UPGRADE_COMMAND_LV`).

---

## 2. Logic Chain (سلسلة الاستدلال المنطقي)

1. **من غياب `commandHall` إلى بروتوكول الـ 0-Network المسبق (Observation 1)**:
   - بما أن حزمة تسجيل الدخول لا تحتوي على بيانات قاعة القيادة، فإن إرسال استعلام المزامنة الأولي `CMD 2274 SubCMD 1` إلزامي لمرة واحدة فقط عند بدء الدورة.
   - لتفادي الحظر وحماية الخادم، يتم تخزين النتيجة فوراً في الذاكرة الحية `conn.init_data["commandHall"]`، وتتم كافة الفحوصات اللاحقة خلال مدة الـ 5 دقائق من الذاكرة مباشرة دون أي استعلام شبكي إضافي.

2. **من فحص الأبطال إلى الانتقاء الذكي الآمن (Observation 2)**:
   - استبعاد الأبطال المعرفين في جداول اللعبة كأبطال جمع (`[1711, 1717, 1724, 1733]`) يضمن عدم تعريض أبطال الموارد للخطر أو إشغالهم عن مهام الجمع.
   - اشتراط `hero.state == 1` و `not hero.queue` يضمن اختيار بطل متاح وحر داخل القلعة، مما يمنع أخطاء رفض السيرفر لطلب المسير.

3. **من فحص القوات إلى تجنب إرسال الأفخاخ وتحديد سعة المسير (Observation 3)**:
   - وحدات `801..825` هي أفخاخ دفاعية للسور ومحاولة إرسالها في طابور مسير تسفر عن خطأ رفض من الخادم.
   - جمع القوات الحقيقية من وحدات `4xx, 5xx, 6xx, 7xx` يتيح ضبط حجم الفيلق المرسل بما يتوافق مع القوات المتوفرة بالقلعة دون تجاوزها.

4. **من بروتوكول مهمة القناص الصامت إلى تنفيذ الحزمة المباشرة (Observation 7)**:
   - في كود العميل الرسمي (`commandHallCtrl.lua:194-195`)، تنتهي اللعبة المصغرة بإرسال `commandHallCtrl:reqFinishTask(index)` الذي يوجه `CMD 2274 SubCMD 5`.
   - الاستدلال المباشر: البوت ليس بحاجة لأي محاكاة رسومية؛ إرسال الحزمة المباشرة يحقق متطلب R3 بنسبة 100% وبطريقة مطابقة تماماً لسلوك العميل الرسمي الفائز في اللعبة.

5. **من هجوم فيلق الغزاة المهاجمين إلى التجديد التلقائي للمهام (Observation 7)**:
   - مهمة فيلق الغزاة المهاجمين (نوع 1) تنفذ عبر `CMD 2274 SubCMD 7` مباشرة من القلعة.
   - استلام مكافأتها عبر `CMD 2274 SubCMD 8` هو المفتاح الذي يعيد تدوير وتوليد مهام فرعية جديدة في القائمة، محققاً متطلب R2.

---

## 3. Caveats (الافتراضات والحدود)

- **انعدام القوات في بعض الحسابات (`beetoo1`)**:
  قلعة `beetoo1` تحتوي على 0 جنود في `armyCtrl.totalArmy`. لا يمكن اختبار مهام مسير الخريطة (النوع 2 و 5) عليها، لكنها مثالية لاختبار الخروج النظيف الآمن عند حظر الفيالق والمهام الفورية (حوار، إنقاذ، قناص).
- **توفر القوات في `beetoo3`**:
  قلعة `beetoo3` تحتوي على 14,380 جندي، وهي المرشح المثالي للاختبار الحي الشامل لمهام الفيالق.
- **القفل الثانوي (`SecondaryLock`)**:
  إذا كان الحساب يمتلك قفلاً ثانوياً على إرسال الجيوش، يجب على البوت الاكتفاء بالمهام الفورية دون محاولة إرسال مسيرات لتفادي أخطاء كلمة المرور.

---

## 4. Conclusion (الخلاصة والتوصيات القاطعة للتنفيذ)

1. **التعامل مع مهام قاعة القيادة الست**:
   - **النوع 1 (فيلق الغزاة المهاجمين)**: إرسال `CMD 2274 SubCMD 7` بهجوم فوري من القلعة، يليه استلام الجائزة `SubCMD 8` لتجديد المهام.
   - **النوع 2 (طليعة الغزاة)**: إرسال فيلق عبر `CMD 1007 SubCMD 2` مع `moveLineType: 15`، جنود حقيقيين (4xx, 5xx, 6xx, 7xx)، وبطل قتالي مؤهل (`heroType != 1`).
   - **الأنواع 3 (حوار)، 4 (إنقاذ)، و 6 (قناص صامت)**: إنجاز فوري مجاني عبر `CMD 2274 SubCMD 5` مع `{"index": task_index}` يليه استلام الجوائز `SubCMD 8`.
   - **النوع 5 (معركة الغزاة)**: مسير خريطة عبر `CMD 1007 SubCMD 2` مع `moveLineType: 15`.
2. **قواعد اختيار الأبطال والقوات**:
   - حظر أبطال الجمع: استبعاد المعرفات `1711, 1717, 1724, 1733`.
   - اختيار بطل قتال متاح (`state == 1` و `queue == {}`).
   - استبعاد الأفخاخ (`unit_id >= 800`) واستخدام القوات المتاحة فقط.
3. **الأمان الصارم وفق دستور `GEMINI.md`**:
   - فحص الذاكرة المسبق وتخزين كائن `commandHall` في `conn.init_data`.
   - منع صرف الذهب أو التسريعات نهائياً (0-Gold, 0-Speedup).
   - التوقف وتخطي المهام إذا كانت طاقة اللورد `stamina < 5`.

---

## 5. Verification Method (طريقة التحقق المستقل)

1. **فحص تفريغات الذاكرة الحية برمجياً**:
   ```powershell
   python -c "import json; d=json.load(open('docs/beetoo3_live_memory.json', encoding='utf-8')); print('Total Army:', d.get('armyCtrl', {}).get('totalArmy')); print('Heroes count:', len(d.get('heroSysCtrl', {}).get('heroList', {}))); print('Health:', d.get('lordInfoCtrl', {}).get('base', {}).get('health'))"
   ```

2. **التحقق من قائمة أبطال الجمع والمساعدة في جداول اللعبة**:
   ```powershell
   python -c "import re; lines=open('game_file/src/app/localtb/config_client/hero_view_info.lua', encoding='utf-8').readlines(); h={}; cur=None
   for i, l in enumerate(lines):
       m = re.search('heroID\s*=\s*(\d+)', l)
       if m: cur = int(m.group(1)); h[cur] = {}
       if cur and 'heroType' in l:
           nums = re.findall('\d+', l)
           if nums: h[cur]['type'] = int(nums[-1])
   print('Ancillary heroes (Type 1):', [k for k, v in h.items() if v.get('type') == 1])"
   ```

3. **تشغيل الاختبار الميداني الآمن لحساب حي عبر أدوات `tools/`**:
   ```powershell
   # 1. اختبار نمط الذاكرة دون اتصال
   python tools/test_task_method.py --offline --task command_hall

   # 2. اختبار القلعة الحية الحقيقية (beetoo3 مع الجيوش)
   python tools/field_test_command_hall.py
   ```
