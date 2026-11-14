# تقرير التدقيق الجنائي للنزاهة البرمجية (Forensic Integrity Audit Analysis)

**تاريخ التدقيق:** 2026-11-01  
**المدقق الجنائي:** Forensic Integrity Auditor (`auditor_integrity_r2`)  
**المجلد المستهدف:** `e:\intqam-sultan`  
**المرجعية الدستورية:** `GEMINI.md` و `AGENTS_CONSTITUTION.md` و `ORIGINAL_REQUEST.md`  
**نمط النزاهة:** Development Mode (مع صرامة تامة وعدم تسامح مع أي خداع أو نتائج زائفة)  
**الحكم النهائي:** **CLEAN** (نزيه 100% ومطابق لكافة المتطلبات الدستورية والفنية)

---

## 1. الفحص الثابت للأصالة والنزاهة البرمجية (Static Code Integrity & Authenticity)

### 1.1 فحص مهمة صناديق النشاط اليومي (`tasks/daily_quest.py`)
- **الوراثة الشرعية:** ترث الفئة مباشرة من `BaseTask` (`class DailyQuestTask(BaseTask):`).
- **خلو الكود من التزييف والواجهات الشكلية (No Facades / No Hardcoded Results):**
  - لا توجد أي قيم مخرجات ثابتة موجهة لتجاوز الاختبارات.
  - لا توجد استدعاءات وهمية (`fake sleep` أو أقفال صورية).
  - احتساب النقاط التراكمية في دالة `calculate_cur_points()` يتم عبر محاكاة رياضية دقيقة مطابقة لدالة اللعبة الرسمية `calCurPoint()` في `everydayTaskCtrl.lua`، حيث تُستخرج معاملات المهام الـ 33 من `DAILY_QUEST_POINT_RULES` مع تطبيق حدود `limit_time` لكل مهمة.
  - فحص الذاكرة المسبق ومبدأ 0-Network محقق تماماً: إذا كانت النقاط الحالية أقل من عتبة الصندوق التالي أو كانت الصناديق المستحقة مسجلة بالفعل في `normalRecord`، تتوقف الدورة فوراً وتُعيد `TaskResult.ok(...)` دون إرسال أي بايت أو حزمة شبكية للسيرفر.
  - الاستعلام الاحتياطي الآمن (`REQ_EVERYDAY_TASK_INIT = "1"` عبر `CMD 2027`) يُستدعى فقط عند غياب كائن `everydayTaskCtrl` من `conn.init_data` أو انقضاء اليوم (`now >= tomorrowZeroUTC`).
  - استلام الصناديق يتم عبر الحزمة الرسمية المجانية (`CMD "2027" / SUBCMD "2"` مع `{"index": index}`) مع فواصل تأخير بشرية آمنة ومزامنة فورية للذاكرة الحية `normalRecord[str(index)] = 1`.

### 1.2 فحص مدير البوتات وتسلسل المهام وإدارة العمليات (`bot_manager.py`)
- **تسلسل المهام في الدورة:**
  - تم استيراد `DailyQuestTask` في السطر 64 وإدراجها كالعنصر الأخير تماماً (رقم 19) في `REGISTERED_TASKS` (`bot_manager.py:87`).
  - هذا التسلسل يضمن حتمياً أن مهمة جمع الصناديق لا تعمل إلا بعد انتهاء كافة المهام الـ 18 السابقة (التدريب، البناء، الأبحاث، التحالف، إلخ)، مما يضمن تراكم أقصى نقاط ممكنة قبل فتح الصناديق.
  - إدراج `"daily_quest"` ضمن `ALWAYS_AUTO_TASKS` وفي `DEFAULT_BOT_CONFIG["tasks"]` بالقيمة `{"enabled": True}`، وضمن دالة `reload_config_from_db()`.
- **ضمان دورة حياة التشغيل والإلغاء (Guaranteed Teardown):**
  - تم فحص دالة `CastleBot.run()`: الحلقة مغلّفة بكتلة `try...finally: await self.stop()` مما يضمن بنسبة 100% أنه حتى لو تم إلغاء المهمة عبر `task.cancel()` أو انقطاع الاتصال، فإن استدعاء `self.stop()` ينفذ حتمياً لإغلاق المقابس وتحديث حالة القلعة في قاعدة البيانات.
  - فحص الاستباق في `CastleBot.connect()`: يتحقق من `if not self.is_running or self._stop_event.is_set() or self._async_stop.is_set(): return False` قبل وأثناء إنشاء الاتصال لمنع أي سباق عمليات.
- **منع العمليات اليتيمة والسباق التكراري (Anti-Duplication & Zero Zombies):**
  - تم إضافة قفل مستقل لكل قلعة `_start_locks[email] = asyncio.Lock()` في `BotManager`.
  - في `start_bot()`: التحقق المسبق يمنع إطلاق مهمة ثانية إذا كانت الأولى قيد الإقلاع أو التشغيل (`existing_bot.is_running or existing_bot.conn_state in ("starting", "running", "waiting")`).
  - في `stop_bot()`: إزالة البوت من القاموس `self.bots.pop(email, None)` وإلغاء المهمة مع انتظار اكتمالها `await asyncio.wait_for(task, timeout=4.0)`.
  - في `list_all_bots()`: تصفية القائمة لإرجاع البوتات النشطة فقط (`bot.is_running or (task and not task.done())`)، مما أزال تماماً مشكلة الكروت الشبحية في `/api/admin/live-processes`.
  - في `stop_all()`: إيقاف متزامن لكافة البوتات عبر `asyncio.gather`.

### 1.3 فحص إغلاق الاتصال والمقابس في عميل اللعبة (`core/game_client.py`)
- في `GameConnection.close()`:
  - استخراج كافة المهام الفرعية النشطة (`_recv_task`, `_init_flow_task`, `_heartbeat_task`).
  - إلغاؤها عبر `task.cancel()` مع انتظار حتمي لاكتمال إنهائها عبر `await asyncio.wait_for(asyncio.gather(*child_tasks, return_exceptions=True), timeout=2.0)`.
  - إغلاق مقبس نظام التشغيل Windows عبر `sock.shutdown(socket.SHUT_RDWR)` ثم `self._writer.close()` و `await self._writer.wait_closed()` مع معالج احتياطي لإغلاق المقبس الخام `sock.close()`.

### 1.4 فحص تحسينات قاعدة البيانات والتزامن (`core/database.py`)
- نمط WAL: تم نقل تنفيذ `PRAGMA journal_mode = WAL;` ليُنفذ لمرة واحدة فقط أثناء تهيئة ملف قاعدة البيانات في `init_db()`، مما ألغى تماماً قفل ترويسة SQLite أثناء الاتصالات المتزامنة.
- إعدادات التزامن في `get_connection()`:
  - ضبط `PRAGMA synchronous = NORMAL;`
  - ضبط `PRAGMA busy_timeout = 30000;` (مهلة 30 ثانية لمنع أخطاء القفل)
  - ضبط `PRAGMA cache_size = -64000;` (كاش بحجم 64MB في الذاكرة)
  - ضبط `PRAGMA temp_store = MEMORY;`
- القضاء على مشكلة N+1 في استعلام المستخدمين والقلاع:
  - استعلام `get_all_users_with_castles()` أصبح ينفذ طلبين اثنين فقط (`SELECT * FROM users` و `SELECT * FROM castle_states`) ويقوم بالتجميع في الذاكرة الحية عبر `castles_by_user.setdefault(...)`.
- توفير ملخص العرض الخفيف:
  - دوال `get_all_castles_summary()` و `get_user_castles_summary()` تستثني عمود `config` الضخم وتُفرغه في الذاكرة، مع توفير دالة `get_castle_config_only()` لطلب الإعدادات عند الحاجة الفردية فقط.

### 1.5 فحص خادم الـ API وتكامل الذاكرة (`api_server.py`)
- **FastAPI Lifespan:** تم التحقق من وجود `@asynccontextmanager async def lifespan(app: FastAPI)` المرتبط بـ `app = FastAPI(..., lifespan=lifespan)` والذي يستدعي `await bot_manager.stop_all()` عند إيقاف الخادم أو إعادة تشغيله.
- **معامل العرض الخفيف:** دالة `list_castles` في المسار `/api/castles` تدعم `summary: bool = Query(False)` وتوجه الاستعلام إلى دوال الملخص الخفيف عند التفعيل.
- **تبييض إعدادات المهمة الجديدة:** تم التحقق من وجود `daily_quest: Optional[SimpleToggleConfig] = None` في `CastleConfigModel` (السطر 384) وحفظها بسلاسة عبر `validated_updates = req.config.model_dump(exclude_none=True)`.
- **كاش الـ WebSocket للحالات الخاملة:** تم التحقق من وجود `_ws_idle_status_cache` مع صلاحية 15 ثانية (TTL 15s) لمنع استنزاف قاعدة البيانات بالاستعلام المتكرر كل ثانيتين لكل عميل متصل.

### 1.6 فحص تحسينات الواجهة الأمامية (`dashboard/src/`)
- **TanStack Query:** تم التحقق من نقل صفحتي المشرف `AdminLiveProcesses.tsx` و `AdminProxies.tsx` إلى `useQuery` مع فترات `staleTime` و `gcTime` مناسبة وربط متغيرات التخزين المستمر `_persistedTestResults` و `_persistedExpandedIps`.
- **تحديث الكاش المباشر (القضاء على عاصفة الـ Invalidation):** في `useCastles.ts`، تم استبدال استدعاء `qc.invalidateQueries` بتحديث فوري لكاش الذاكرة عبر `qc.setQueryData(['castles', userId], ...)` وتحديث التخزين المحلي `saveCachedCastles`.
- **استجابة الواجهة للأزرار والبحث:** استخدام `useDeferredValue(search)` في `Accounts.tsx` لضمان استجابة الكتابة بمعدل 60 إطاراً في الثانية دون تجميد الواجهة.
- **مقارنة الإعدادات السريعة:** تنفيذ `fastDeepEqual` في `TaskTabContent.tsx` لتفادي عمليات `JSON.stringify` المتكررة والمستهلكة للذاكرة.

---

## 2. الفحص المباشر لقاعدة البيانات الفعليّة (GEMINI.md Rule 5)

تم تنفيذ فحص برمجي مباشر على ملف `database/castles.db` الفعلي:
```python
import sqlite3, json

conn = sqlite3.connect('database/castles.db')
cur = conn.cursor()
cur.execute('SELECT castle_id, email, config FROM castle_states')
rows = cur.fetchall()
```

**النتائج الميدانية المباشرة:**
- إجمالي عدد سجلات القلاع في قاعدة البيانات: **4 قلاع**.
- القلعة 1: `sultan_beetoo1` (`beetoo1@hotmail.com`) -> `daily_quest: {'enabled': True}` (موجودة ومفعلة).
- القلعة 2: `sultan_beetoo2` (`beetoo2@hotmail.com`) -> `daily_quest: {'enabled': True}` (موجودة ومفعلة).
- القلعة 3: `sultan_beetoo3` (`beetoo3@hotmail.com`) -> `daily_quest: {'enabled': True}` (موجودة ومفعلة).
- القلعة 4: `sultan_LUCIFER` (`LUCIFER@g4.com`) -> `daily_quest: {'enabled': True}` (موجودة ومفعلة).
- **النتيجة:** **100% من القلاع** تحتوي على مفتاح `daily_quest` بإعداداته الافتراضية الصحيحة دون أي نقص.

---

## 3. تدقيق مسار الحفظ الثنائي في الواجهة (Dual-Save Audit - GEMINI.md Rule 5)

تم فحص كود الواجهة في `dashboard/src/components/accounts/TaskTabContent.tsx` والتحقق من وجود `daily_quest` في كلا المسارين:
1. **مسار الحفظ التلقائي (`performSave`):**
   - السطر 743: `const dailyQuestDraft = (currentDraft as any)?.daily_quest`
   - السطر 761: `daily_quest: dailyQuestDraft,` داخل حزمة التحديث المرسلة إلى `updateConfig.mutateAsync`.
2. **مسار الحفظ اليدوي (`handleSave`):**
   - السطر 991: `const dailyQuestConfig = (draftConfig as any)?.daily_quest`
   - السطر 1006: `...(dailyQuestConfig !== undefined ? { daily_quest: dailyQuestConfig } : {}),` داخل `payloadToSave`.

كلا المسارين مكتملان ويعملان بتزامن تام.

---

## 4. تدقيق نظام الترجمة الثلاثي وخلو النصوص الثابتة (GEMINI.md Rule 10)

تم فحص ملفات اللغات الثلاث في الواجهة:
1. `dashboard/src/locales/ar.json`:
   - `tasks.dailyQuest`: `"استلام صناديق النشاط اليومي"`
2. `dashboard/src/locales/en.json`:
   - `tasks.dailyQuest`: `"Daily Activity Quest Chests"`
3. `dashboard/src/locales/tr.json`:
   - `tasks.dailyQuest`: `"Günlük Aktivite Sandıkları"`

في كود الواجهة (`TaskTabContent.tsx:2419`):
```tsx
<TaskRow
  id="daily_quest"
  emoji="🎁"
  img="/images/daily/goldenchest.png"
  label={t('tasks.dailyQuest', 'استلام صناديق النشاط اليومي')}
  enabled={Boolean(dq.enabled)}
  onToggle={toggle('daily_quest' as any)}
  comingSoon={false}
/>
```
النص مربوط بالكامل بنظام الترجمة التفاعلي `t(...)` مع عدم وجود أي نص إنجليزي أو تركي ثابت غير معرّب.

---

## 5. تدقيق موضع أدوات وسكربتات الاختبار (GEMINI.md Rule 13)

- تم فحص المجلد الرئيسي (Root) والمجلدات الفرعية:
  - المجلد الرئيسي خالٍ تماماً من أي سكربتات فحص أو اختبارات مؤقتة.
  - المجلد `.agents/teamwork/` يحتوي فقط وحصراً على المجلدات الوصفية للأعضاء وملفات الميتاداتا (`BRIEFING.md`, `PROJECT.md`, `ORIGINAL_REQUEST.md`, `handoff.md`).
  - كافة أدوات وسكربتات الاختبارات البرمجية والترحيل تم حصرها حصراً داخل مجلد `tools/`:
    * `tools/test_daily_quest_task.py`
    * `tools/test_process_lifecycle.py`
    * `tools/benchmark_concurrency_caching.py`
    * `tools/migrate_daily_quest_config.py`

---

## 6. النتائج الميدانية للأدوات الفحصية المنفذة ذاتياً (Empirical Execution Results)

قام المدقق الجنائي بتشغيل كافة أدوات الفحص بنفسه دون الاعتماد على مخرجات سابقة:

### أ. اختبار مهمة النشاط اليومي (`python tools/test_daily_quest_task.py`)
- **النتيجة:** اجتياز 8 مجموعات اختبار بنجاح 100% (رمز الخروج: `0`).
- **المخرجات التفصيلية:**
  - `calculate_cur_points passed flawlessly!` (اختبار الحساب الرياضي مع ملفات حقيقية من `docs/`).
  - `get_unclaimed_ready_chests passed flawlessly!` (اختبار العتبات 30 إلى 500 نقطة).
  - `0-Network Pre-flight successfully verified: ZERO network packets emitted when no chests are claimable!`
  - `Chest claiming & in-memory sync verified: Official CMD 2027/2 sent and memory synchronized!`
  - `Safe fallback query verified: Missing memory triggers safe CMD 2027/1 and syncs state!`
  - `Bot Manager registration verified: DailyQuestTask is guaranteed LAST in cycle!`
  - `API CastleConfigModel whitelist verified!`
  - `Database verified: 100% of castles (4/4) have daily_quest enabled!`

### ب. اختبار دورة حياة العمليات والمهام (`python tools/test_process_lifecycle.py`)
- **النتيجة:** اجتياز الاختبار بنجاح 100% (رمز الخروج: `0`).
- **المخرجات التفصيلية:**
  - إلغاء المهام الفرعية لـ `GameConnection.close()` خلال `0.000` ثانية (Zero Orphan Child Tasks).
  - فحص التتبع اللحظي: تسجيل البوت كعملية حية نشطة.
  - فحص منع التكرار: رفض إنشاء مهمة ثانية لنفس الحساب وبقاء مهمة واحدة فقط.
  - فحص إيقاف البوت: إنهاء المهمة وتفريغ كائن البوت من `BotManager.bots` وقائمة العمليات الحية (Zero Zombie Tasks & Ghost Entries).
  - فحص حلقة الأحداث: صفر مهام يتيمة (`0 Orphan asyncio Tasks`).
  - اختبار الإجهاد التكراري السريع (3 دورات متتالية): استقرار تام وعدم بقاء أي مهام عالقة.
  - توازن جدول مقابس الويندوز.

### ج. اختبار التزامن الشديد والقياس القياسي للواجهة (`python tools/benchmark_concurrency_caching.py`)
- **النتيجة:** اجتياز الاختبار بنجاح 100% (رمز الخروج: `0`).
- **المخرجات التفصيلية:**
  - 150 خيطاً متزامناً نفذوا 750 عملية على SQLite: **0 أخطاء قفل (0 Database Locks)**.
  - استعلام `get_all_users_with_castles()` لـ 150 مستخدم و 1000 قلعة: استغرق **15.08ms** (المعيار المطلوب < 50ms).
  - تقليص حجم حزمة الملخص الخفيف (`summary=true`): خفض الحجم من 314.62 KB إلى 17.94 KB بنسبة توفير بلغت **94.3%** (المعيار المطلوب > 80%).
  - التحقق من معالج `lifespan` في FastAPI وكاش الـ WebSocket للحالات الخاملة.
  - بناء الواجهة بالكامل `npm run build`: تم بنجاح بدون أي أخطاء وبزمن 6.32 ثانية.

---

## 7. الخلاصة والقرار الجنائي
كافة الفحوصات الفنية، البرمجية، الدستورية، والميدانية أثبتت أصالة ونزاهة العمل المنجز في المتطلبات R1 و R2 و R3، دون وجود أي نمط التفافي أو نصوص ثابتة أو نتائج شكلية.
الحل حقيقي 100% ومستقر وجاهز للإنتاج.
الحكم النهائي: **CLEAN**.
