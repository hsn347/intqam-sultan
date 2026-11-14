# تقرير الفحص التجريبي والتحقق الخصومي (Adversarial Empirical Analysis - R1)

**تاريخ الفحص:** 2026-11-01  
**المدقق:** Empirical Game Protocol & Live Memory Verification Challenger (`challenger_task_protocol_r2`)  
**الهدف:** التحقق الخصومي والتجريبي الصارم من مهمة صناديق النشاط اليومي (`DailyQuestTask` - المتطلب R1) عبر سيناريوهات الضغط، محاكاة السلوك الخصومي، وفحص سلامة الذاكرة وقاعدة البيانات.

---

## 1. ملخص النتائج التنفيذية (Executive Summary)

- **الحكم الهندسي:** **REQUEST_CHANGES** (طلب تعديل محدد ذو أولوية عالية لحماية الحسابات من الحظر).
- **أداة الاختبار التجريبية المنجزة:** تم بناء وتشغيل الأداة الموحدة `tools/test_adversarial_daily_quest.py` المكونة من 9 محاور فحص خصومي تغطي كافة الحالات الحدية (Edge Cases) وحقن الأعطال (Fault Injection).
- **نسبة اجتياز الاختبارات القياسية:** 100% (اجتياز كافة فحوصات Baseline في `tools/test_daily_quest_task.py`).
- **الثغرات المرصودة:** رصد ثغرة واحدة مؤكدة تجريبياً ومصنفة بدرجة خطورة **عالية (High Severity)** تتعلق بتسريب نقاط اليوم السابق عند فشل الاستعلام الاحتياطي بعد تصفير اليوم الجديد (UTC Reset Anomaly).

---

## 2. جدول نتائج الفحوصات التجريبية (Empirical Test Metrics)

| # | حالة الاختبار الخصومي (Scenario) | السلوك المتوقع (Expected) | السلوك الفعلي التجريبي (Empirical Actual) | النتيجة |
|---|----------------------------------|---------------------------|------------------------------------------|---------|
| 1 | ذاكرة اصطناعية برصيد 0 نقطة | 0 حزم شبكية (0-Network Pre-flight) | 0 حزم مرسلة، خرجت فوراً برسالة 0-Network | ✅ PASS |
| 2 | ذاكرة اصطناعية برصيد 500 نقطة وكافة الصناديق الـ 8 مستلمة | 0 حزم شبكية (0-Network Pre-flight) | 0 حزم مرسلة، النقاط المحتسبة 670/500 مع تطابق normalRecord | ✅ PASS |
| 3 | رصيد 180 نقطة وصناديق 1..3 غير مستلمة (صندوق 4 مستلم مسبقاً) | إرسال حزم CMD 2027 / SUBCMD 2 للفهارس 1، 2، 3 فقط، وتحديث الذاكرة فوراً | أُرسلت 3 حزم مطابقة بدقة، حُدثت normalRecord بالذاكرة، وتوقف التشغيل الثاني فوراً بـ 0 حزم | ✅ PASS |
| 4 | غياب كائن الذاكرة الحية بالكامل (`init_data = {}` أو `None`) | تفعيل الاستعلام الاحتياطي الآمن CMD 2027 / SUBCMD 1 دون انهيار | أُرسل CMD 2027/1 وحُدثت الذاكرة ونُفذ الاستلام دون أي crash | ✅ PASS |
| 5 | انقضاء صلاحية اليوم الجديد (`now >= tomorrowZeroUTC`) | رصد التصفير اليومي وتفعيل الاستعلام الاحتياطي CMD 2027/1 | رُصد التجدد وأُرسل CMD 2027/1 لتحديث الذاكرة واستلام صناديق اليوم الجديد | ✅ PASS |
| 6 | منع الأمر الفرعي SubCMD "4" (شراء كنز النشاط بالذهب) | عدم استدعاء SubCMD 4 نهائياً وخلو الكود منه | تم تأكيد خلو الكود عبر فحص شجرة الـ AST ومراقبة كافة الحزم، ولم يُستدعَ SubCMD 4 قط | ✅ PASS |
| 7 | حقن أعطال الشبكة (Network Fault Injection) | عزل الأعطال دون تعليق البوت وعدم استخدام بيانات منتهية | - 7A: ذاكرة فارغة وفشل الاستعلام لم يسقط البوت.<br>- 7B: **رصد ثغرة V-01 (تسريب نقاط الأمس عند فشل استعلام اليوم الجديد).**<br>- 7C: فشل صندوق 2 قيد الاستلام بنجاح للصندوق 1 فقط دون إفساد الذاكرة. | ⚠️ VULNERABILITY FOUND |
| 8 | تسلسل المهام في `bot_manager.py` | `REGISTERED_TASKS[-1] == DailyQuestTask` وإدراجها في المهام التلقائية | العنصر رقم 19 (الأخير)، موجودة في `ALWAYS_AUTO_TASKS` و `DEFAULT_BOT_CONFIG` | ✅ PASS |
| 9 | تكامل قاعدة البيانات (GEMINI.md Rule 5) | شمول 100% من القلاع في `database/castles.db` | فحص مباشر لـ 4 قلاع من أصل 4 (100%) وجميعها تملك `daily_quest.enabled == True` | ✅ PASS |

---

## 3. التحليل التفصيلي للثغرة المرصودة (Vulnerability Deep-Dive: V-01)

### اسم الثغرة:
**Stale Memory Fallback Leakage upon UTC Day Reset (تسريب نقاط اليوم السابق واستدعاء استلام غير قانوني عند فشل الاستعلام الاحتياطي)**

### مستوى الخطورة:
**HIGH (خطر متعلق بسلامة الحسابات ومخالفة GEMINI.md Rule 2)**

### التوصيف التقني الدقيق:
في ملف `tasks/daily_quest.py`، الأسطر 145-172:
```python
    async def _ensure_synced_memory(self) -> Tuple[Optional[Dict[str, Any]], bool]:
        ctrl = self.get_ctrl("everydayTaskCtrl")
        now_ts = int(time.time())

        # فحص هل البيانات الحالية صالحة ومحدثة
        if isinstance(ctrl, dict) and isinstance(ctrl.get("eventInfo"), dict) and isinstance(ctrl.get("normalRecord"), dict):
            tomorrow_zero = int(ctrl.get("tomorrowZeroUTC", 0) or 0)
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
```

### آلية الفشل (Failure Mechanism):
1. عند حلول اليوم الجديد وتصفير خادم اللعبة، تصبح `tomorrowZeroUTC` أقل من الوقت الحالي `now_ts`.
2. تكتشف المهمة ذلك وتُطلق الاستعلام الاحتياطي `CMD 2027 / SUBCMD 1`.
3. في حال حدوث أي انقطاع مؤقت في الشبكة، أو تأخر الخادم، أو عودة `resp = None`، لا يدخل الكود في شرط التحديث `if resp and isinstance(resp.get("data"), dict):`.
4. ينتقل التنفيذ إلى السطر 164:
   ```python
   return (ctrl if isinstance(ctrl, dict) else None), True
   ```
   هنا يكون المتغير `ctrl` لا يزال يحمل كائن اليوم السابق (بما فيه من نقاط مجمعة مثل 30 إلى 500 نقطة وسجلات صناديق قديمة).
5. وبما أن `ctrl` هو `dict`، تعود الدالة بـ `(ctrl, True)` بدلاً من `(None, True)`.
6. تدخل الدالة `run()` وتتعامل مع `everyday_ctrl` على أنه بيانات صالحة! فتحتسب نقاط الأمس المنتهية، وتجد صناديق غير مستلمة وفق سجل الأمس، فتُطلق طلباً شبكياً رسمياً `CMD 2027 / SUBCMD 2` لاستلام الصناديق على خادم أصبحت نقاط اللاعب فيه صفراً!
7. يرد الخادم بخطأ رسمي: `Err_EVERYDAY_TASK_POINT_NOT_ENOUGH` (رمز الخطأ 2700 في `everydayTaskCtrl.lua`).
8. إرسال طلبات استلام غير مستحقة عند الصفر يمثل شذوذاً عن السلوك البشري وسلوك العميل الرسمي، ويخالف قواعد الأمان الصارمة ضد الحظر (GEMINI.md Rule 2).

### الدليل التجريبي المباشر (Empirical Proof):
تمت محاكاة السيناريو برمجياً في `tools/test_adversarial_daily_quest.py` (Sub-case 7B):
```text
[daily_quest] 📡 [صناديق النشاط] استعلام احتياطي لتحديث بيانات المهام اليومية من السيرفر (CMD 2027/1)...
[daily_quest] 🎁 [صناديق النشاط] تم رصد 1 صندوق جاهز للاستلام (النقاط: 30/500 | الصناديق: [1]).
[daily_quest] 📦 [صناديق النشاط] جاري استلام الصندوق 1 (30 نقطة)...
⚠️ VULNERABILITY CONFIRMED [V-01]: Fallback query failed, but task emitted 1 claim packet(s) using expired yesterday points: [{'cmd': '2027', 'subcmd': '2', 'data': {'index': 1}, 'timestamp': 1793514058.521992}]
```

### الأثر الجانبي الإضافي (Dead Code):
السطر 171 في `tasks/daily_quest.py`:
```python
if not isinstance(everyday_ctrl, dict):
    return TaskResult.skip("تعذر الحصول على بيانات everydayTaskCtrl من الذاكرة أو السيرفر.")
```
يعتبر حالياً كوداً غير قابل للوصول (Dead Code) في حال فشل الاستعلام مع ذاكرة فارغة؛ لأن `self.get_ctrl()` في `BaseTask` يعيد دائماً `{}` (dict) عند غياب المفتاح، وبالتالي السطر 164 يعيد `{}` دائماً، فتخرج المهمة بـ `TaskResult.ok(لا توجد صناديق جديدة)` بدلاً من التخطي الصريح `TaskResult.skip`.

---

## 4. الإصلاح الهندسي المقترح (Proposed Remediation)

الإصلاح فائق البساطة ويتطلب تعديل سطرين فقط في `tasks/daily_quest.py` داخل دالة `_ensure_synced_memory()`:

```python
        # تنفيذ الاستعلام الاحتياطي الآمن عند نقص البيانات أو تجدد اليوم
        self.log("📡 [صناديق النشاط] استعلام احتياطي لتحديث بيانات المهام اليومية من السيرفر (CMD 2027/1)...")
        resp = await self.safe_query(CMD_EVERYDAY_TASK_MODULE, REQ_EVERYDAY_TASK_INIT, {})
        if resp and isinstance(resp.get("data"), dict):
            if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                ctrl = self.conn.init_data.setdefault("everydayTaskCtrl", {})
                ctrl.update(resp["data"])
                return ctrl, True
            return resp["data"], True

        # في حال فشل الاستعلام الاحتياطي بعد ثبوت نقص البيانات أو انتهاء صلاحيتها:
        # يُمنع منعاً باتاً إعادة ctrl القديم/الفارغ لتفادي استلام صناديق بنقاط ملغاة
        return None, True
```

بهذا التعديل:
- إذا فشل الاستعلام الاحتياطي، تعيد الدالة `(None, True)`.
- يدخل التنفيذ مباشرة في السطر 170:
  ```python
  if not isinstance(everyday_ctrl, dict):
      return TaskResult.skip("تعذر الحصول على بيانات everydayTaskCtrl من الذاكرة أو السيرفر.")
  ```
- تتخطى المهمة دورتها بأمان تام (0-Network للمطالبات) دون إرسال أي حزم غير مستحقة، وتنتظر الدورة التالية للبوت لإعادة المحاولة.

---

## 5. سجل التحقق من قاعدة البيانات وتسلسل البوت

### تسلسل البوت (`bot_manager.py`):
```text
REGISTERED_TASKS length: 19
Index 0..17: Preceding tasks (Shield, Resources, Alliance, Train, etc.)
Index 18 (LAST): DailyQuestTask (guaranteed last in cycle)
ALWAYS_AUTO_TASKS: includes 'daily_quest'
DEFAULT_BOT_CONFIG['tasks']['daily_quest']: {'enabled': True}
```

### قاعدة البيانات (`database/castles.db`):
```text
Total rows in castle_states: 4
1. beetoo1@hotmail.com (ID: sultan_beetoo1) -> daily_quest: {'enabled': True}
2. beetoo2@hotmail.com (ID: sultan_beetoo2) -> daily_quest: {'enabled': True}
3. beetoo3@hotmail.com (ID: sultan_beetoo3) -> daily_quest: {'enabled': True}
4. LUCIFER@g4.com (ID: sultan_LUCIFER) -> daily_quest: {'enabled': True}
Compliance rate: 100% (4/4 castles migrated)
```
