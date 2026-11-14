# تقرير التحليل والتدقيق الهندسي المعمق (Backend Logic & Process Lifecycle Review)

**التاريخ:** 2026-11-01  
**المراجع والمدقق:** Backend Logic and Live Memory Reviewer (`reviewer_backend_r2`)  
**الأدوار:** Reviewer & Adversarial Critic  
**النطاق:** التدقيق المستقل للميلستون 1 (صناديق النشاط اليومي R1) والميلستون 2 (دورة حياة العمليات واستئصال المهام اليتيمة R2)  
**القرار الهندسي (Verdict):** **APPROVE** (مصادقة تامة 100% بدون أي تحفظات مع إثبات النزاهة الجنائية)

---

## 1. ملخص المراجعة والقرار (Review Summary)

| المعيار | النتيجة المستقلة | التقييم |
|---|---|---|
| **بروتوكول أوامر النشاط اليومي** | CMD 2027 / SUBCMD 2 (مجاني)، وحظر تام لـ SUBCMD 4 (الذهب) | ✅ متطابق 100% مع سورس اللعبة الرسمي |
| **دقة احتساب النقاط التراكمية** | مطابقة تامة لدالة `everydayTaskCtrl:calCurPoint()` وحدود `DAILY_QUEST_POINT_RULES` الـ 33 | ✅ تم الفحص والمطابقة الحسابية |
| **معيار 0-Network Pre-flight** | تصفير استهلاك الشبكة تماماً إذا لم تكن هناك صناديق مستحقة غير مستلمة | ✅ تم إثبات خروج الكود بـ 0 حزم شبكية |
| **الاستعلام الاحتياطي الآمن** | CMD 2027 / SUBCMD 1 عند غياب الذاكرة أو انقضاء `tomorrowZeroUTC` | ✅ استعلام آمن وموثق |
| **مزامنة الذاكرة الفورية** | تحديث `conn.init_data['everydayTaskCtrl']['normalRecord']` محلياً فور كل استلام ناجح | ✅ يمنع تكرار أي طلب لاحق |
| **تسلسل دورة المهام الحتمي** | `DailyQuestTask` هو العنصر الأخير حتماً (رقم 19 من 19) في `REGISTERED_TASKS` | ✅ مضمون رياضياً وتتابعياً |
| **دورة حياة العمليات واستئصال الزومبي** | `CastleBot.run()` مغلف بـ `try...finally: await self.stop()` | ✅ تنظيف حتمي لا يفشل أبداً عند الإلغاء |
| **إنهاء المهام الفرعية والمقابس** | انتظار إلغاء المهام الفرعية وإغلاق مقابس TCP مع `sock.shutdown(SHUT_RDWR)` | ✅ تفريغ تام لمقابس الويندوز |
| **منع التكرار وقفل القلعة** | قفل متزامن لكل قلعة `_start_locks` وتفادي الإطلاق المزدوج في `start_bot()` | ✅ رفض محاولات التشغيل المكررة |
| **تفريغ سجل العمليات الحية** | إزالة البوتات المتوقفة من `self.bots.pop(email, None)` وفلترة `list_all_bots()` | ✅ صفر مهام شبحية في الذاكرة الحية |
| **نزاهة الأكواد ومكافحة التزييف** | خلو الكود تماماً من الأكواد الوهمية (Facades) أو النتائج الثابتة (Hardcoded) | ✅ اجتياز فحص النزاهة بنسبة 100% |

---

## 2. التدقيق الفني للميلستون 1: مهمة صناديق النشاط اليومي (R1)

### 2.1 مطابقة بروتوكول الشبكة لسورس اللعبة الرسمي
- تم فحص ملفات سورس اللعبة في `game_file/src/app/constdef/cmdDef.lua`:
  * السطر 1488: `CMD_EVERYDAY_TASK_MODULE = "2027"`
  * السطر 1489: `REQ_EVERYDAY_TASK_INIT = "1"` (استعلام المزامنة الشامل الاحتياطي)
  * السطر 1490: `REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"` (استلام الصناديق اليومية الثمانية المجانية)
  * السطر 1492: `REQ_EVERYDAY_TASK_RECEIVE_CHEST = "4"` (استلام كنز النشاط بالذهب)
- **التحقق في `tasks/daily_quest.py`:**
  * المهمة تستخدم حصراً `CMD_EVERYDAY_TASK_MODULE = "2027"` و `REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"` لاستلام الصناديق مع تمرير `{"index": index}`.
  * لم يتم استخدام الأمر الفرعي 4 (`REQ_EVERYDAY_TASK_RECEIVE_CHEST`) في أي موضع، مما يضمن الحظر القطعي لاستهلاك الذهب (Zero-Gold Enforcement).
  * عتبات الصناديق الثمانية في `CHEST_MILESTONES` تطابق تماماً عتبات ملف `game_file/src/app/localtb/config_server/daily_reward_point_items.lua`:
    `[30, 70, 120, 180, 260, 340, 420, 500]`.

### 2.2 خوارزمية احتساب النقاط ومطابقة `calCurPoint()`
- في سورس اللعبة `game_file/src/app/module/everydayTask/everydayTaskCtrl.lua` السطر 277:
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
- في كود البايثون `tasks/daily_quest.py` السطر 104:
  * دالة `calculate_cur_points(event_info)` تستخرج المهام الـ 33 من `DAILY_QUEST_POINT_RULES`.
  * تدعم كلاً من المفاتيح المباشرة (1..33) والمفاتيح الكاملة للعبة (4100001..4100033) عبر `k_int % 4100000 if k_int > 4100000 else k_int`.
  * تطبق سقف التكرار بدقة: `point * min(count, limit_time)`.
  * تم اختبار الدالة ضد ملفات الذاكرة الحية الحقيقية في `docs/` (`sample_live_memory.json` -> 49 نقطة، `beetoo1_live_memory.json` -> 30 نقطة، `lucifer_live_memory.json` -> 1 نقطة)، وجاءت كافة النتائج مطابقة بنسبة 100%.

### 2.3 تطبيق مبدأ 0-Network Pre-flight والاستعلام الاحتياطي
- في `_ensure_synced_memory()`:
  * تفحص أولاً وجود `everydayTaskCtrl` و `eventInfo` و `normalRecord`.
  * تفحص سريان وقت اليوم الحالي: `now_ts < tomorrow_zero`. في حال سريانها، لا ترسل أي حزمة شبكية إطلاقاً (`was_queried = False`).
  * في حال غياب المتحكم من الذاكرة الحية أو تجاوز وقت منتصف الليل (`now_ts >= tomorrow_zero`)، تنفذ المهمة استعلاماً احتياطياً واحداً آمناً `CMD 2027 / SUBCMD 1` لتحديث الذاكرة.
- في `run()`:
  * بعد احتساب النقاط وفحص `get_unclaimed_ready_chests(cur_points, normal_record)`: إذا كانت القائمة فارغة، تخرج المهمة فوراً بـ `TaskResult.ok()` بـ 0 حزم شبكية.
  * عند وجود صناديق مستحقة، يتم استدعاء `safe_query` مع فواصل بشرية عشوائية `min_delay=0.6, max_delay=1.2` لكل صندوق (Anti-BAN Jitter).
  * فور نجاح استلام كل صندوق (`res.get("err") in (None, 0)`): يتم تحديث `normal_record[str(index)] = 1` محلياً في الذاكرة الحية، مما يضمن أن أي دورة تالية لن ترسل أي طلبات مكررة.

### 2.4 تدقيق مسار الطبقات الست الكامل (The 6-Stage Pipeline)
1. **Backend Task:** تم إنشاء فئة `DailyQuestTask` في `tasks/daily_quest.py` وتصديرها في `tasks/__init__.py`.
2. **Bot Manager:** تم استيرادها في `bot_manager.py` وإدراجها كالعنصر الأخير تماماً رقم 19 في `REGISTERED_TASKS`، وإضافتها في `ALWAYS_AUTO_TASKS`، وفي `DEFAULT_BOT_CONFIG["tasks"]["daily_quest"] = {"enabled": True}`، وفي دالة `reload_config_from_db()`.
3. **API Whitelist:** تم تسجيل `daily_quest: Optional[SimpleToggleConfig] = None` في `CastleConfigModel` داخل `api_server.py`.
4. **Database Migration:** تم فحص ملف `database/castles.db` برمجياً؛ وُجد أن 100% من القلاع الـ 4 تحتوي على `"daily_quest": {"enabled": true}`.
5. **Frontend Defaults & Hooks:** تم تحديث `dashboard/src/types/index.ts` بإضافة `daily_quest` في `CastleConfig` و `DEFAULT_CASTLE_CONFIG`، وتحديث `dashboard/src/hooks/useCastles.ts` داخل `mergeCastleConfig`.
6. **Frontend UI & Dual-Save:** تم تدقيق `dashboard/src/components/accounts/TaskTabContent.tsx`:
   - مسار الحفظ التلقائي `performSave()` يتضمن `daily_quest`.
   - مسار الحفظ اليدوي `handleSave()` يتضمن `daily_quest`.
   - عنصر التحكم التفاعلي `TaskRow` موجود في تبويب المهام اليومية (`tab === 'daily'`).
   - ملفات الترجمة الثلاثية محدثة في `ar.json`, `en.json`, `tr.json`.
   - بناء الواجهة عبر `npm run build` اجتاز بنجاح في 1.43 ثانية دون أي أخطاء.

---

## 3. التدقيق الفني للميلستون 2: دورة حياة العمليات واستئصال الزومبي (R2)

### 3.1 ضمان التنظيف الحتمي في `CastleBot.run()`
- تم فحص الحلقة الرئيسية في `bot_manager.py:656-760`:
  * تم تغليف كامل حلقة التشغيل بكتلة:
    ```python
    try:
        while self.is_running and not self._stop_event.is_set() and not self._async_stop.is_set():
            ...
    except asyncio.CancelledError:
        self.log("🛑 تم استلام إشارة إلغاء المهمة الرئيسية للبوت.")
    except Exception as e:
        self.log(f"⚠️ خطأ غير متوقع في الحلقة الرئيسية: {e}")
    finally:
        await self.stop()
    ```
  * هذا الضمان يمنع تماماً ترك أي موارد عالقة؛ فحتى لو تم إلغاء المهمة عبر `task.cancel()` أثناء الانتظار الطويل (`asyncio.wait_for(...)`)، يتم تنفيذ كتلة `finally: await self.stop()` حتماً.

### 3.2 فحص الجاهزية وحواجز الإقلاع في `CastleBot.connect()`
- تم رصد وجود حاجزين حاسمين (Pre-flight Early Abort Guards):
  1. قبل إنشاء كائن اتصال البوابة:
     `if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set(): return False`
  2. بعد تهيئة `GameConnection`:
     `if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set(): if self.conn: await self.conn.close(); return False`
- هذا يحول دون إنشاء أي اتصالات أو مقابس جديدة إذا وصل أمر الإيقاف أثناء فترة المصادقة غير المتزامنة مع خادم تسجيل الدخول (`async_login`).

### 3.3 استئصال المهام الفرعية ومقابس TCP في `GameConnection.close()`
- في `core/game_client.py:1574-1630`:
  * يتم إرسال إشعار الخروج الرسمي أولاً (CMD 1037 SUBCMD 2 مع `switch=False`).
  * يتم حصر كافة المهام الفرعية النشطة (`_recv_task`, `_init_flow_task`, `_heartbeat_task`) وإلغاؤها، والأهم: **انتظار إنهائها فعلياً** عبر:
    `await asyncio.wait_for(asyncio.gather(*child_tasks, return_exceptions=True), timeout=2.0)`.
  * يتم إغلاق مقبس الويندوز بأمان على مستوى النواة:
    `sock.shutdown(socket.SHUT_RDWR)` متبوعة بـ `_writer.close()` و `wait_closed()`، مع معالجة بديلة لإغلاق المقبس الخام `sock.close()` فوراً عند تعليق الويندوز.

### 3.4 حماية منع التكرار والقفل المتزامن في `BotManager`
- في `bot_manager.py:861-955`:
  * تم إضافة قاموس أقفال خاص بكل قلعة: `self._start_locks: Dict[str, asyncio.Lock]`.
  * في `start_bot()`:
    - الدخول يتم عبر `async with castle_lock:`.
    - فحص البوت والمهمة القائمة: إذا كان البوت قيد التشغيل أو في طور الإقلاع والمهمة لم تنتهِ بعد، يتم رفض الطلب المكرر وإرجاع `True` فوراً (`task_before is task_after`) دون استبدال المهمة أو فتح مقبس مكرر.
    - في حال وجود مهمة قديمة متوقفة أو عالقة، يتم إلغاؤها وانتظار إنهائها بمهلة زمنية قبل إطلاق البوت الجديد.
  * في `stop_bot()`:
    - يتم ضبط `bot.conn_state = "stopping"`.
    - يتم استدعاء `await bot.stop()`.
    - يتم إلغاء المهمة وانتظارها `await asyncio.wait_for(task, timeout=4.0)`.
    - يتم تفريغ البوت نهائياً من الذاكرة الحية: `self.bots.pop(email, None)`.
  * في `list_all_bots()`:
    - تم تطبيق فلتر صارم: `if bot.is_running or (task and not task.done())`، مما يضمن أن البوتات المتوقفة لا تظهر إطلاقاً في سجل العمليات الحية ولا في واجهة `/api/admin/live-processes`.
  * في `stop_all()`:
    - إيقاف متزامن وشامل لكافة البوتات عبر `asyncio.gather`.

---

## 4. نتائج الفحوصات التجريبية المستقلة (Empirical Verification Runs)

### 4.1 فحص مهمة النشاط اليومي (`tools/test_daily_quest_task.py`)
تم تشغيل الاختبار البرمجي المستقل:
```powershell
python tools/test_daily_quest_task.py
```
**النتيجة الموثقة:**
- `calculate_cur_points`: اجتاز بنجاح لكافة الحالات الفردية والتراكمية وسقف المهام وملفات الذاكرة الحقيقية الثلاثة.
- `get_unclaimed_ready_chests`: اجتاز بنجاح لكافة العتبات (0، 29، 30، 150، 500 نقطة).
- `0-Network Pre-flight`: تم التحقق بنجاح من إرسال **صفر** حزم شبكية عند عدم وجود صناديق جاهزة.
- `Chest claiming & in-memory sync`: إرسال الأمر الرسمي 2027/2 وتحديث `normalRecord` في الذاكرة الحية، والدورة الثانية أجرت صفر استعلامات.
- `Safe fallback query`: تنفيذ استعلام 2027/1 عند غياب الذاكرة ومزامنة الحالة واستلام الصناديق.
- `Bot Manager registration`: التحقق من أن `DailyQuestTask` هو العنصر الأخير في `REGISTERED_TASKS` وتسجيله في `ALWAYS_AUTO_TASKS`.
- `API Whitelist & Database Integrity`: مطابقة كلاس Pydantic ومطابقة قاعدة بيانات `database/castles.db` بنسبة 100% (4 من أصل 4 قلاع).
- **كافة مجموعات الاختبار الـ 8 اجتازت بنجاح 100% (Exit Code: 0).**

### 4.2 فحص دورة حياة العمليات والمقابس (`tools/test_process_lifecycle.py`)
تم تشغيل الاختبار المؤتمت:
```powershell
python tools/test_process_lifecycle.py
```
**النتيجة الموثقة:**
- `[UNIT TEST]`: تم إلغاء كافة المهام الفرعية الثلاث في `GameConnection.close()` وتفريغها بنجاح خلال 0.000 ثانية.
- `[TEST 1]`: تشغيل البوت وتتبعه اللحظي في `list_all_bots()` كعملية نشطة.
- `[TEST 2]`: محاولة تشغيل مكرر لنفس الحساب أثبتت عمل الـ Anti-Duplication Guard ومنعت أي تكرار للمهام (`task_before is task_after`).
- `[TEST 3]`: إيقاف البوت وتحقق الحذف الفوري من `self.tasks` و `self.bots` واختفاؤه تماماً من قائمة `list_all_bots()` وخلو حلقة الأحداث من أي مهام يتيمة (0 Orphan asyncio Tasks).
- `[TEST 4]`: اختبار الإجهاد التكراري لـ 3 دورات متتالية من البدء والإيقاف السريع (Start -> Wait 0.3s -> Stop -> Wait 0.3s) واجتيازها جميعاً دون أي تسريب أو تعليق.
- **كافة الفحوصات اجتازت بنجاح 100% (Exit Code: 0).**

### 4.3 فحص التجميع البرمجي للباك إند وبناء الواجهة
- فحص ملفات البايثون:
  ```powershell
  python -m py_compile tasks/daily_quest.py bot_manager.py core/game_client.py tools/test_daily_quest_task.py tools/test_process_lifecycle.py
  ```
  -> تم بنجاح بدون أي أخطاء صياغية (Exit code: 0).
- بناء الواجهة الأمامية:
  ```powershell
  cd dashboard && npm run build
  ```
  -> تم البناء بنجاح (`built in 1.43s`) بدون أي أخطاء في الـ TypeScript أو الـ Bundler.

---

## 5. التدقيق الجنائي للنزاهة ومكافحة التزييف (Forensic Integrity & Anti-Cheating Audit)

بناءً على تعليمات النزاهة الإلزامية المشددة:
1. **التحقق من عدم وجود نتائج ثابتة مزيفة (No Hardcoded Test Outputs):**
   - تم فحص كود `tasks/daily_quest.py`: منطق احتساب النقاط ديناميكي وحقيقي يعتمد على مسح القاموس والضرب بالسقف، ولا يحتوي على أي قيم ثابتة مشروطة لاختبارات معينة.
   - منطق `CastleBot.run()` و `BotManager` حقيقي يدير مهام `asyncio.Task` فعلية.
2. **التحقق من عدم وجود واجهات وهمية (No Facade/Dummy Implementations):**
   - المهمة ترث فعلياً من `BaseTask` وتستخدم `safe_query` و `conn.init_data`.
   - إغلاق المقابس في `GameConnection.close()` يستدعي توابع المقبس الحقيقية لنظام التشغيل (`sock.shutdown`, `_writer.close`, `wait_closed`).
3. **التحقق من خلو العمل من الاختصارات الملتوية (No Task Bypassing):**
   - كافة المتطلبات الستة لمسار الطبقات نُفذت كاملة دون تفريط.
   - لم يتم استيراد أو نسخ حلول خارجية غير متوافقة؛ بل تم استخراج وتطبيق المنطق من ملفات اللعبة Lua الأصلية.
4. **الخلو التام من الشهادات الذاتية الزائفة (Independent Genuine Verification):**
   - تم إجراء الاختبارات وإعادة تشغيلها ميدانياً والتحقق المباشر من مخرجات سطر الأوامر وقاعدة بيانات SQLite وملفات الواجهة.

**النتيجة الجنائية:** **خلو كامل وتام من أي انتهاك للنزاهة (Zero Integrity Violations).**

---

## 6. التحليل التنافسي ونقاط الضعف الافتراضية (Adversarial Stress-Testing)

| الفرضية الهجومية | سيناريو الفشل المحتمل | آلية الدفاع والتحصين في الكود | النتيجة |
|---|---|---|---|
| **بيانات `eventInfo` مشوهة أو تحتوي أنواعاً مختلطة** | رفع `TypeError` أو `ValueError` أثناء احتساب النقاط | تم تحصين الدالة بكتلة `try...except (ValueError, TypeError): continue` مع معالجة `None` و القيم النصية | ✅ محصنة تماماً |
| **انقضاء موعد اليوم الجديد أثناء عمل البوت** | اعتماد البوت على ذاكرة اليوم السابق القديمة | فحص `now_ts < tomorrow_zero` يكتشف انقضاء اليوم تلقائياً ويطلق استعلام 2027/1 فوراً لتحديث الذاكرة | ✅ محصنة تماماً |
| **انقطاع الاتصال أثناء فتح الصناديق المتتابعة** | بقاء الصناديق غير مستلمة أو ادعاء استلامها خطأ | يتم تحديث `normalRecord` لكل صندوق بمفرده فقط بعد التحقق من `res.get('err') in (None, 0)` | ✅ محصنة تماماً |
| **ضغط النقر المتكرر على زر تشغيل القلعة في الواجهة** | تنافس المهام وإنشاء مقابس مكررة لنفس القلعة | استخدام قفل متزامن خاص بالقلعة `_start_locks[email]` مع فحص الحالة والمهمة القائمة لمنع التكرار | ✅ محصنة تماماً |
| **إيقاف البوت أثناء وجود اتصال شبكي نشط** | بقاء مقابس الويندوز في حالة `CLOSE_WAIT` أو مهام فرعية معلقة | إلغاء وانتظار المهام الفرعية الثلاث بمهلة 2 ثانية، وإغلاق المقبس عبر `sock.shutdown(SHUT_RDWR)` مع إغلاق خام احتياطي | ✅ محصنة تماماً |

---

## 7. القرار النهائي (Verdict)

بصفتي مدقق الباك إند والذاكرة الحية والمنافس التنافسي (Reviewer & Adversarial Critic):
- أؤكد أن العمل المنجز في **الميلستون 1 (Daily Activity Quest Chests)** و **الميلستون 2 (Process Lifecycle & Zombie Elimination)** قد استوفى كافة المتطلبات الهندسية والمعايير الصارمة لدستور المشروع بنسبة 100%.
- القرار الهندسي الصادر: **APPROVE (مصادقة نهائية واعتماد كامل للميلستون 1 و 2)**.
