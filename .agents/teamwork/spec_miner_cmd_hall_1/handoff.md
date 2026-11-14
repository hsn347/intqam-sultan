# Handoff Report: Specification Mining for Command Hall (قاعة القيادة)

**Agent**: Game Spec Miner (`teamwork_spec_miner`)  
**Assigned Directory**: `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_1\`  
**Milestone**: Command Hall Specification Mining (Milestone 1)  
**Deliverable Document**: `analysis.md`  
**Handoff Type**: Hard (Task Complete)

---

## 1. Observation (الملاحظات المباشرة والأدلة الصريحة)

1. **وحدة التحكم الرسمية وأوامر الشبكة**:
   - في `game_file/src/app/constdef/cmdDef.lua` (السطر 3242-3254):
     ```lua
     CMD_COMMAND_HALL_MODULE = "2274"
     REQ_COMMAND_HALL_INIT = "1"
     REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"
     REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"
     REQ_COMMAND_HALL_FINISH_GUIDE = "4"
     REQ_COMMAND_HALL_FINISH_TASK = "5"
     REQ_COMMAND_HALL_SET_DEFEND = "6"
     REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"
     REQ_COMMAND_HALL_COMMIT_TASK = "8"
     REQ_COMMAND_HALL_REFRESH_POS = "9"
     REQ_COMMAND_HALL_REFRESH_POS2 = "10"
     REQ_COMMAND_HALL_GET_BATTLE_INFO = "11"
     REQ_COMMAND_HALL_GET_RANK_INFO = "12"
     ```
   - إشعار السيرفر التلقائي في `cmdDef.lua` (السطر 650):
     `NOTIFY_COMMAND_HALL = "608"`
   - معرّف المبنى الرسمي في `buildDef.lua` (السطر 270) و `cityBuildConstDef.lua` (السطر 72):
     `BUILDID.CommandHall = 30009`

2. **أنواع المهام وحالاتها في كود اللعبة**:
   - في `game_file/src/app/constdef/wholeDefine.lua` (السطور 1365-1382):
     ```lua
     gCommandHallTaskType:
       REBEL_ARMY_GROUP_TASK   = 1, -- فيلق الغزاة
       REBEL_ARMY_PIONEER_TASK = 2, -- طليعة الغزاة
       DIALOGUE_TASK           = 3, -- المعلومات العسكرية
       RESCUE_TASK             = 4, -- إنقاذ القرويين
       BATTLE_TASK             = 5, -- فريق الغزاة
       SNIPE_HUNTER_TASK       = 6  -- القناص الصامت

     gCommandHallTaskStatue:
       PREPARE = 1,
       BEGIN   = 2,
       FINISH  = 3

     gCommandHallTaskNotifyType:
       TIME_REFRESH            = 1,
       CASTLE_UPGRADE          = 2,
       GROUP_TASK              = 3,
       PIONEER_TASK            = 4,
       COMMON_TASK             = 5,
       MOVE_CITY_REFRESH_POS   = 6,
       SNIPE_HUNTER_TASK_REACH = 7
     ```

3. **ارتباط قاعة القيادة بالنشاط اليومي (Daily Activity Quest 33)**:
   - في `game_file/src/app/constdef/wholeDefine.lua` (السطر 501):
     `gEverydayTaskType.COMMAND_HALL_TASK = 33`
   - في `game_file/src/app/localtb/config_server/daily_reward_point_config.lua` (السطور 258-265):
     ```lua
     ID = 4100033
     type = 33
     quest = 3      -- يتطلب إنجاز 3 مهام قاعة قيادة
     point = 10     -- يمنح 10 نقاط نشاط يومي
     limitTime = 1
     ```
   - في `game_file/src/app/localtb/config_client/daily_reward_data.lua` (السطور 162-166):
     ```lua
     ID = 4100033
     name = "commandhall_text_82"   -- "مهام القيادة"
     des = "daily_reward_des_33"    -- "أكمل 3 مهام من مهام قاعة القيادة"
     image = "img_commandhall_entrance.png"
     hidden = "5"                   -- فتح عند قلعة مستوى 5
     ```
   - في `game_file/src/app/game/gameGuide/gameMildGuideManager.lua` (السطر 882):
     `self.mildEverydayTaskFun[gEverydayTaskType.COMMAND_HALL_TASK] = handler(self, self.starToCommandHall)`

4. **شروط استهلاك الموارد واستهلاك الذهب**:
   - تم فحص جميع سجلات المهام الـ 475 في `newcommandhalltask.lua`:
     - استهلاك فيلق الغزاة (Type 1): `consume = 0`.
     - استهلاك جميع المهام الأخرى (Type 2-6): `consume = 5`.
     - في `CommandHallTaskPanel.lua` (السطر 95-97):
       `self.fields.Button_attack:setCostIcon("icon_lord_sp.png")`
       `self.fields.Button_attack:setCostNum(consume, self.curPhysical)`
     - هذا الاستهلاك هو حصراً نقاط لياقة الأمير (Lord Stamina / Physical Power)، ولا توجد أي متطلبات لصرف الذهب أو التسريعات في أي مهمة فرعية.

5. **فحص متطلبات الجيش وطابور المسير (Troop March)**:
   - في `game_file/src/app/module/commandHall/commandHallUtil.lua` (السطور 114-120):
     ```lua
     function commandHallUtil.checkTaskTypeNeedArmy(taskType)
         config[gCommandHallTaskType.RESCUE_TASK] = true
         config[gCommandHallTaskType.SNIPE_HUNTER_TASK] = true
         config[gCommandHallTaskType.DIALOGUE_TASK] = true
         return not config[taskType]
     end
     ```
     المهام 3 (حوار)، 4 (إنقاذ)، و 6 (قناص) **لا تحتاج أي جيش على الإطلاق** (`checkTaskTypeNeedArmy` يعيد `false`).
   - في `game_file/src/app/game/worldMap/worldMapFunction.lua` (السطر 353-355):
     ```lua
     elseif tipButtonType == worldMapDefine.worldMapTipButtonType_commandHallNpc then
         moveLineType = gMapMoveLineType.moveLineTypeCommandHallNpc -- (15)
         matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop -- (1)
     ```
   - أمر إرسال الفيلق الرسمي في `kingdomMapCtrl.lua` (السطر 180):
     `serverproxy:Request(gCmd.CMD_KINGDOM_QUEUE_MODULE, gCmd.ADD_KINGDOM_QUEUE, data)` -> `CMD 1007 SubCMD 2`.

6. **آلية استلام جوائز المهام واعتمادها**:
   - في `CommandHallTaskPanel.lua` (السطور 122-127):
     ```lua
     if statue == gCommandHallTaskStatue.FINISH then
         commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
     ```
   - في `commandHallCtrl.lua` (السطور 370-375):
     `serverproxy:Request(gCmd.CMD_COMMAND_HALL_MODULE, gCmd.REQ_COMMAND_HALL_COMMIT_TASK, { commitType = commitType, index = index })` -> `CMD 2274 SubCMD 8`.
   - الاستجابة تعيد: `rspdata.initData` (محدثة) و `rspdata.reward` (قائمة الأدوات المكتسبة).

---

## 2. Logic Chain (سلسلة الاستدلال المنطقي)

1. **الاستعلام والمزامنة الحية (Live Memory & Fallback)**:
   - بما أن بيانات قاعة القيادة لا تأتي مدمجة تلقائياً في حزمة تسجيل الدخول الأولية (لاحظنا غيابها في تفريغ الذاكرة `beetoo1_live_memory.json` و `lucifer_live_memory.json`)، فإن العميل الرسمي يرسل دائماً `REQ_COMMAND_HALL_INIT` (CMD 2274 SubCMD 1) عند تشغيل القاعة.
   - بالتالي: يجب على مهمة البوت فحص كائن `conn.init_data.get("commandHallCtrl")` أولاً، وإذا لم يكن موجوداً ترسل استعلام المزامنة الآمن `CMD 2274 SubCMD 1` مرة واحدة فقط وتخزن النتيجة في الذاكرة الحية.

2. **الأمان المطلق وقاعدة الذهب الصفري (Zero-Gold & Zero-Speedup)**:
   - أثبت فحص الكود أن كافة المهام تستهلك إما 0 أو 5 نقاط لياقة (SP).
   - الاستدلال: إذا كانت طاقة الأمير `curPhysical < 5`، يجب تخطي المهام دون لمس أي ذهب أو شراء طاقة. وعند إرسال الفيالق، يُحظر إرسال أمر التسريع `REQ_SPEED_QUEUE` (CMD 1007 SubCMD 7).

3. **تسلسل التنفيذ المتوازن والتعامل مع الفيالق**:
   - بما أن المهام 3 و 4 و 6 لا تحتاج جيشاً وتكتمل بطلب `REQ_COMMAND_HALL_FINISH_TASK` (CMD 2274 SubCMD 5) ثم `REQ_COMMAND_HALL_COMMIT_TASK` (SubCMD 8)، فيجب تنفيذها أولاً فورياً ومجانياً.
   - إذا صادفت المهمة متطلب إرسال فيلق على الخريطة (Type 2 أو Type 5) ولم تكن هناك فيالق متاحة (`remain_queues == 0`):
     - يستلزم منطق R1 إتمام كافة المهام الفورية المتبقية، ثم الخروج السليم فوراً دون تعطيل حلقة القلعة.
   - عند توفر فيالق: إرسال فيلق بأدنى عدد ممكن (1 جندي) عبر `CMD 1007 SubCMD 2` مع `moveLineType: 15`.

4. **تكامل دورة الـ 5 دقائق والنشاط اليومي**:
   - المهمة تستمر في فحص وتدوير المهام المتاحة لمدة 5 دقائق، ثم تخرج بعد اكتمال المتاح. إنجاز 3 مهام يحقق تلقائياً متطلب النشاط اليومي رقم 33 ويمنح القلعة 10 نقاط نشاط يومي.

---

## 3. Caveats (الافتراضات والحدود)

- **حزم حماية الحساب (Secondary Lock)**: في حال كان الحساب مفعلاً لقفل الأمان الثانوي (`SecondaryLock`) على إرسال الفيالق، سيقتصر البوت على تنفيذ المهام الفورية غير المحتاجة لجيش (المهام 3 و 4) لتجنب أخطاء قفل كلمة المرور.
- **مستوى القلعة المطلوب**: القاعة تفتح رسمياً عند مستوى قلعة 5 (`COMMANDHALL_OPEN_LV = 1` إلى 5، ومحدد `hidden = "5"` في `daily_reward_data.lua`). القلاع الأقل من مستوى 5 يجب تخطيها تلقائياً.

---

## 4. Conclusion (الخلاصة والتوصيات القاطعة للتنفيذ)

1. **معمارية المهمة الخلفية (`tasks/command_hall.py`)**:
   - الاسم: `command_hall`.
   - الأوامر الشبكية:
     - مزامنة القاعة: `CMD 2274 SubCMD 1`.
     - إنهاء مهمة فورية (حوار / إنقاذ / قناص): `CMD 2274 SubCMD 5` مع `{"index": index}`.
     - استلام جائزة مهمة مكتملة: `CMD 2274 SubCMD 8` مع `{"commitType": type, "index": index}`.
     - هجوم فيلق الغزاة: `CMD 2274 SubCMD 7`.
     - ترقية القاعة: `CMD 2274 SubCMD 2`.
     - مسير الخريطة: `CMD 1007 SubCMD 2` مع `moveLineType: 15`.
2. **الواجهة وقاعدة البيانات**:
   - زر تحكم Toggle واحد في تبويب `daily` (المهام اليومية) تحت المفتاح `command_hall`.
   - استخدام الأيقونة المستخرجة من اللعبة `img_commandhall_entrance.png`.
   - تمرير المفتاح عبر المراحل الست كاملة والترحيل في `castles.db`.

---

## 5. Verification Method (طريقة التحقق المستقل)

1. **فحص نصوص التعدين والمواصفات**:
   - مراجعة ملف المواصفات الشامل المكتمل:
     `e:\intqam-sultan\.agents\teamwork\spec_miner_cmd_hall_1\analysis.md`
2. **التحقق من الأوامر عبر كود اللعبة**:
   - تشغيل الفحص السريع لمعرفات الأوامر وأنواع المهام:
     ```powershell
     python -c "import re; f=open('game_file/src/app/constdef/cmdDef.lua', 'r'); [print(l.strip()) for l in f if 'COMMAND_HALL' in l]"
     ```
3. **التحقق الميداني البرمجي (عند بدء التنفيذ)**:
   - تشغيل تجريبي لـ `CMD 2274 SubCMD 1` على حساب قلعة فعلي من `database/castles.db` للتأكد من استرجاع قائمة المهام بنجاح.
