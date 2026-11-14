# تقرير التسليم الهندسي للمتطلب R1: مهمة استلام صناديق النشاط اليومي (Handoff Report)

**من:** Codebase Researcher — Backend & Game Protocol Specialist (`explorer_r2_backend`)  
**إلى:** Supreme Orchestrator (`967591d1-7169-433b-9cdd-f72cc70bcd57`)  
**المهمة:** التحقيق الفني وتوفير المخطط الهندسي للمتطلب R1 (Daily Activity Quest Chest Collection Task)  
**نوع التسليم:** Hard Handoff (اكتملت مهمة التحقيق والبحث البرمجي بنسبة 100%)

---

## 1. الملاحظات المباشرة (Observation)

1. **كود اللعبة الرسمي لوحدة الأوامر:**
   - ملف `game_file/src/app/constdef/cmdDef.lua`:
     - السطر 1488: `;(nil).CMD_EVERYDAY_TASK_MODULE = "2027"`
     - السطر 1489: `;(nil).REQ_EVERYDAY_TASK_INIT = "1"`
     - السطر 1490: `;(nil).REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"`
     - السطر 1491: `;(nil).REQ_EVERYDAY_TASK_REFRESH = "3"`
     - السطر 1492: `;(nil).REQ_EVERYDAY_TASK_RECEIVE_CHEST = "4"`
     - السطر 1493: `;(nil).REQ_EVERYDAY_TASK_USE_FAST_PASS = "5"`

2. **منطق استلام الصناديق في عميل اللعبة الرسمي (`everydayTaskCtrl.lua`):**
   - السطور 14-17:
     ```lua
     msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_INIT, handler(self, self.everydayTaskInitResp))
     msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_NORMAL, handler(self, self.everydayTaskReceiveNormalResp))
     msgCtrl.register(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_CHEST, handler(self, self.everydayTaskReceiveChestResp))
     ```
   - السطور 134-138 (دالة إرسال استلام الصناديق اليومية):
     ```lua
     function everydayTaskCtrl:sendReceiveNormalMsg(index)
         local serverproxy, data
         data.index = index
         serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_NORMAL, data)
     end
     ```
   - السطور 164-175: استجابة `everydayTaskReceiveNormalResp` تحدث `self.normalRecord = ret.data.normalRecord`.
   - السطور 277-292 (دالة احتساب النقاط التراكمية `calCurPoint`):
     ```lua
     function everydayTaskCtrl:calCurPoint()
         local ret = 0
         for everydayTaskID, tmpCount in pairs(self.eventInfo) do
             local tempConfig = self.localRewardPoint[tonumber(everydayTaskID)]
             if tempConfig and tempConfig.point and tempConfig.limitTime then
                 local point = tempConfig.point
                 local count = math.min(tmpCount, tempConfig.limitTime)
                 ret = ret + point * count
             end
         end
         return ret
     end
     ```
   - السطور 430-435 و 470-475:
     ```lua
     function everydayTaskCtrl:isReceiveNormalReward(index)
         local ret = false
         if self.normalRecord and type(self.normalRecord) == "table" and self.normalRecord[tostring(index)] then
             ret = true
         end
         return ret
     end
     ```

3. **واجهة الصناديق اليومية (`Com_box2.lua` مقابل `dailyAwardTreasureDetailPanel.lua`):**
   - في `game_file/src/fgui/gcomponent/QuestView/Com_box2.lua` السطور 23-24:
     ```lua
     if self.data.curGoal >= self.data.goal and not self.data.isReceived then
         everydayTaskCtrl:sendReceiveNormalMsg(self.data.index)
     ```
     تستدعي `sendReceiveNormalMsg` أي Subcmd 2 مجاناً بدون أي تكلفة ذهب.
   - في `game_file/src/fgui/views/QuestView/dailyAwardTreasureDetailPanel.lua` السطور 41 و 143-146:
     ```lua
     self.fields.btn_gold:initData(gIDDef.GOLD, self.data.reward.offPrice, self.data.reward.price)
     -- عند الضغط:
     everydayTaskCtrl:sendReceiveChestMsg(self.data.index) -- Subcmd 4 بخصم ذهب
     ```

4. **عتبات النقاط الرسمية في `daily_reward_point_items.lua`:**
   - الصناديق الـ 8 بعتبات: 30, 70, 120, 180, 260, 340, 420, 500 نقطة.

5. **الذاكرة الحية المشحونة في `docs/sample_live_memory.json` و `docs/beetoo1_live_memory.json`:**
   - الحقول المشحونة عند تسجيل الدخول داخل `everydayTaskCtrl`:
     `eventInfo`: قاموس بعدد التكرارات للمهام المنجزة.
     `normalRecord`: قاموس بالفهارس المستلمة اليوم (`{"1": 1, ...}`).
     `tomorrowZeroUTC`: موعد بداية اليوم التالي بتوقيت UTC.

6. **ترتيب المهام في `bot_manager.py`:**
   - السطور 66-86: `REGISTERED_TASKS` قائمة تتابعية تضم 18 مهمة تبدأ بـ `PortTask` وتنتهي بـ `TrainTask`.
   - السطور 596-621: حلقة `execute_tasks()` تمر على عناصر القائمة تتابعياً، مما يتيح لكافة المهام السابقة إنجاز أهدافها ورفع نقاط النشاط قبل وصول الدور لآخر مهمة.

---

## 2. سلسلة الاستدلال والمنطق (Logic Chain)

1. **الاستدلال على أمر فتح الصناديق الصحيح:**  
   من الملاحظة (1) و (2) و (3)، ثبُت أن الأمر الفرعي المخصص لصناديق النشاط اليومي الثمانية هو `CMD "2027" / SUBCMD "2"` مع حزمة البيانات `{"index": index}`. استخدام Subcmd "4" يعتبر خطأ فادحاً لأنه مخصص لشراء عروض الكنز الإضافية بالذهب (`offPrice`).

2. **الاستدلال على تطبيق معيار 0-Network:**  
   من الملاحظة (2) و (5)، بما أن `conn.init_data` يحتوي مسبقاً على `eventInfo` و `normalRecord`، يمكن للبوت احتساب النقاط الحالية محلياً بالكامل عبر ضرب التكرار في نقاط كل مهمة وسقفها، ثم مقارنة النقاط الحالية بعتبات الصناديق. فإذا لم يكن هناك أي صندوق جاهز غير مستلم، تنهي المهمة دورتها فوراً دون إجراء أي استعلام شبكي (0 طلبات مرسلة)، مما يحقق حماية كاملة من الحظر.

3. **الاستدلال على الاستعلام الاحتياطي:**  
   من الملاحظة (1) و (2)، إذا غاب كائن `everydayTaskCtrl` من الذاكرة الحية أو كان الطابع الزمني قد تجاوز `tomorrowZeroUTC`، يتم إرسال `CMD "2027" / SUBCMD "1"` (`data={}`)، فيعيد السيرفر الحزمة الرسمية المحدثة لنقوم بمزامنتها في `conn.init_data["everydayTaskCtrl"]` فوراً.

4. **الاستدلال على ضمان التنفيذ كآخر مهمة:**  
   من الملاحظة (6)، وضع الفئة الجديدة `DailyQuestTask` في نهاية `REGISTERED_TASKS` (العنصر رقم 19) يضمن حتمياً ورياضياً عدم تشغيلها إلا بعد انتهاء كافة المهام الـ 18 الأخرى، مما يحصد أقصى نقاط ممكنة (من تدريب الجنود، البناء، الأبحاث، التحالف، إلخ) قبل فتح الصناديق.

5. **الاستدلال على التوافق مع دستور المشروع والطبقات الست:**  
   لتفادي فقدان الإعدادات (البند 3 و 5 من `GEMINI.md`)، يجب تسجيل المهمة في `ALWAYS_AUTO_TASKS` و `DEFAULT_BOT_CONFIG`، وتبييض مفتاحها في `CastleConfigModel` في `api_server.py`، وترحيل قاعدة البيانات `castles.db`، وتوفير خيار الواجهة المتوافق.

---

## 3. التحفظات والحدود (Caveats)

1. **المهام الحصرية لمستوى القلعة 80+ أو 30+:** بعض المهام في `daily_reward_point_config.lua` (مثل تبادل وسام الحرب 4100027 لقلعة Lv.30+، وتقوية المباني 4100032 لقلعة Lv.80+) لا تؤثر على حساب النقاط إذا لم تكن منجزة؛ خوارزمية `calculate_cur_points` تعالج فقط ما هو موجود ومسجل في `eventInfo` بأمان.
2. **سقف الـ 500 نقطة:** تم حصر الصناديق في 8 صناديق فقط (الأول 30 نقطة والأخير 500 نقطة) وفق جدول اللعبة الرسمي؛ لا توجد صناديق بعد 500 نقطة.
3. **لا تحفظات إضافية بخصوص بروتوكول الشبكة أو الذاكرة الحية.**

---

## 4. الاستنتاج والقرار الهندسي (Conclusion)

- **الملف المطلوب إنشاؤه:** `tasks/daily_quest.py` (الفئة: `DailyQuestTask` ترث من `BaseTask`، الاسم البرمجي `daily_quest` والاسم المستعار `daily_activity`).
- **أمر الفتح الرسمي:** `CMD: "2027"` / `SUBCMD: "2"` مع `{"index": index}` (من 1 إلى 8).
- **أمر الاستعلام الاحتياطي:** `CMD: "2027"` / `SUBCMD: "1"` مع `{}`.
- **الترتيب في دورة البوت:** إدراج `DailyQuestTask` كآخر مهمة في `REGISTERED_TASKS` في `bot_manager.py`.
- **التفعيل التلقائي:** إدراجها ضمن `ALWAYS_AUTO_TASKS` لتكون إلزامية تلقائية وتعمل لكافة القلاع دون الحاجة لتدخل المستخدم.
- **التوثيق التفصيلي:** تم تضمين الكود المصدري الكامل الجاهز للتنفيذ في ملف `analysis.md`.

---

## 5. طريقة التحقق المستقلة (Verification Method)

1. **التحقق من صحة أوامر البروتوكول:**
   - فحص ملف `game_file/src/app/constdef/cmdDef.lua` الأسطر 1488-1493 للتأكد من مطابقة `CMD_EVERYDAY_TASK_MODULE = "2027"` و `REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"`.
2. **التحقق من حساب النقاط محلياً واختبار 0-Network:**
   - تشغيل فحص بايثون المستقل عبر ملفات الذاكرة الحية الحقيقية (`docs/sample_live_memory.json` و `docs/beetoo1_live_memory.json`):
     ```bash
     python -c "import json; from tasks.daily_quest import DailyQuestTask; d = json.load(open('docs/sample_live_memory.json')); pts = DailyQuestTask.calculate_cur_points(d['everydayTaskCtrl']['eventInfo']); print('Calculated points:', pts)"
     ```
3. **التحقق من ترتيب التنفيذ في `bot_manager.py`:**
   - فحص `REGISTERED_TASKS[-1] == DailyQuestTask`.
4. **التحقق من عدم وجود استعلامات زائدة:**
   - فحص أن المهمة عند توفر الصناديق المستلمة أو عدم بلوغ العتبة لا تستدعي `safe_query` نهائياً (0-Network).
