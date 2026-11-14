# تقرير التحقيق الفني الشامل: تحسين مهمة البناء ومعالجة مشاكل واجهة المستخدم (R3 & R4)

**المحقق**: Building & Dashboard Explorer (Teamwork Swarm)  
**التاريخ**: 2026-11-01  
**نطاق التحقيق**: المتطلبان R3 و R4 من `ORIGINAL_REQUEST.md`  
**الملفات المفحوصة**:
- `tasks/building.py`
- `tasks/base_task.py`
- `api_server.py`
- `core/database.py`
- `bot_manager.py`
- `dashboard/src/components/accounts/CastleCard.tsx`
- `dashboard/src/components/accounts/ConfirmStopModal.tsx`
- `dashboard/src/components/accounts/TaskTabContent.tsx`
- `dashboard/src/hooks/useCastles.ts`
- `dashboard/src/pages/Accounts.tsx`
- `dashboard/src/lib/botApi.ts`
- `dashboard/src/lib/queryClient.ts`

---

## 1. ملخص تنفيذي (Executive Summary)

أجرى فريق الاستكشاف تدقيقاً عميقاً وشاملاً لمسارات الأكواد البرمجية للباك إند والفرونت إند الخاصة بمهمة البناء الذكية وواجهة لوحة التحكم (Dashboard). أثبت التحقيق بالدليل القاطع النتائج التالية:

1. **فواصل مهمة البناء (R3)**:
   تحتوي `tasks/building.py` حالياً على فواصل غير منسجمة؛ فبعض الطلبات تستخدم مدى كبيراً يصل إلى 1.5 ثانية (`min_delay=0.8, max_delay=1.5`)، وأخرى تبدأ من 0.3 ثانية أو 0.4 ثانية، بينما تخلو الحلقات المتتالية (مثل الانتقال الفوري من أمر الترقية إلى أمر التسريع أو بين تسريع الطوابير المتعددة) من أي تأخير بشري (`0ms` pause). يمكن توحيد كافة الطلبات لتكون بدقة بين `0.5s` و `0.9s` عبر `asyncio.sleep(random.uniform(0.5, 0.9))` و `safe_query` دون أي تعطيل للـ Event Loop أو انتهاء مهلة.

2. **استجابة زر إيقاف القلعة (R4 - النقر المزدوج)**:
   تم كشف **سباق زمني خبيث (Race Condition)** في `CastleCard.tsx`:
   عندما ينقر المستخدم تأكيد الإيقاف، يرسل `botControl.mutate` طلباً للباك إند، وفور نجاحه في `onSuccess` يتم تعيين `isStopping = false` وتعيين الحالة محلياً إلى `idle`. ولكن بمجرد أن تصبح `isStopping = false`، تنشط حلقة `useEffect([realStatus, isStopping, isStarting])`. نظراً لأن مقبس الويب (WebSocket) في الباك إند يعمل بحلقة نوم مدتها ثانيتان (`await asyncio.sleep(2.0)`)، فإن قيمة `realStatus` القادمة من السيرفر تكون **ما تزال "running"**! فيقوم الـ Effect فوراً وفي نفس جزء الثانية بإعادة كتابة `setLiveState('running')` و `setConnState('running')`، مما يلغي التحديث المتفائل (Optimistic Update) ويعيد الزر إلى حالة "يعمل" في ثوانٍ معدودة، مما يجبر المستخدم على النقر عليه مرة ثانية!

3. **حالة القلاع "الشبحية" التي تظهر كأنها تعمل (R4 - Ghost Running Status)**:
   ترجع هذه المشكلة إلى تقاطع 3 أسباب جذرية:
   - **الباك إند (`api_server.py`)**: في دالتي `list_castles` (السطر 527) و `get_castle_detail` (السطر 563)، عندما لا يكون البوت موجوداً في الذاكرة الحية (`bot_manager.get_bot(em)` يعيد `None`)، لا يقوم الكود بإعادة تعيين `c["state"]` أو `c["conn_state"]` إلى `"idle"`! فإذا كانت قاعدة البيانات تحوي حالة سابقة `"running"` (بسبب إعادة تشغيل السيرفر أو إغلاق البوت)، يستمر الـ API في إرسال `"running"` للواجهة!
   - **غياب تنظيف بدء التشغيل (No Reboot Reconcile)**: لا يوجد كود عند تشغيل `api_server.py` يقوم بتصفير الحالات العالقة في SQLite.
   - **تضارب كاش المتصفح المحلي (`localStorage`)**: يقوم `useCastles` بتحميل البيانات فورياً من `localStorage` مع `staleTime: 60_000` (دقيقة كاملة). فإذا فُتحت الصفحة، تعرض القلعة كأنها تعمل بناءً على الكاش القديم دون جلب فوري، ولا تختفي إلا بعد التحديث أو انقضاء الدقيقة.
   - **صيغة التحقق في `CastleCard.tsx`**: تحوي متغيرات `isActuallyRunning` و `isBotActive` شرطاً صريحاً يقرأ `castle.bot_status?.state === 'running'` مباشرة، متجاهلاً كون حالة الـ WebSocket تشير إلى أنه غير متصل أو خامل.

4. **إعادة التصيير واستهلاك الموارد في الواجهة (R4 - UI Re-renders)**:
   - مكون `CastleCard` معرّف بـ `React.memo`، ولكنه يُعاد تصييره بالكامل عند أي نقرة أو كتابة في مربع البحث لأن دالة `onToggleExpand` تمرر كدالة سهمية جديدة غير محفوظة (`() => ...`) في ملف `Accounts.tsx`، وكذلك دوال الحذف والتعديل.
   - مكون `TaskTabContent` الضخم (3,164 سطراً) يتم إبقاؤه في الـ DOM بمجرد فتحه، وهو **غير محاط بـ `React.memo` مطلقاً**، مما يجعله يعيد الحسابات والمقارنات العميقة (`countConfigChanges`) على كل إعادة تصيير للبطاقة الأب.
   - يفتح كل كارد قناة WebSocket مستقلة خاصة به (`/ws/status/{castle_id}`)، وكل قناة تقوم بتشغيل حلقة قراءة مستمرة لقاعدة بيانات SQLite كل ثانيتين في الباك إند، مما يرهق المعالج مع تعدد القلاع.

---

## 2. التحقيق التفصيلي للمتطلب R3: فواصل مهمة البناء (Building Delays)

### 2.1. فحص طلبات الشبكة في `tasks/building.py`
تم مسح كافة الاستعلامات والطلبات الشبكية المنفذة في دورة البناء ومطابقتها:

| م | الدالة / السطر | الاستعلام (CMD / SubCMD) | الغرض | الفاصل الحالي (Min-Max) | الفاصل المستهدف (R3) |
|---|---|---|---|---|---|
| 1 | `refresh_active_queues` (السطر 526) | `CMD 1003 / SubCMD 1` | استعلام حالة طوابير البناء | `0.6s - 1.2s` | `0.5s - 0.9s` |
| 2 | `harvest_building_resource` (السطر 798) | `CMD 1001 / SubCMD 8` | جمع محصول مبنى الموارد قبل الترقية | `0.3s - 0.7s` | `0.5s - 0.9s` |
| 3 | فاصل ما بعد الحصاد (السطر 1146) | `asyncio.sleep(0.3)` | انتظار خادم اللعبة بعد الحصاد | ثابت `0.3s` | `0.5s - 0.9s` عشوائي |
| 4 | `construct_missing_building` (السطر 863) | `CMD 1001 / SubCMD 2` | تشييد مبنى مفقود (المستوى 1) | `0.8s - 1.5s` | `0.5s - 0.9s` |
| 5 | `execute_building_action` (السطر 1114) | `CMD 1001 / SubCMD 2` | أمر تشييد مبنى في الموقع الشاغر | `0.8s - 1.5s` | `0.5s - 0.9s` |
| 6 | `execute_building_action` (السطر 1150) | `CMD 1001 / SubCMD 3` | أمر بدء ترقية مبنى قائم | `0.8s - 1.5s` | `0.5s - 0.9s` |
| 7 | `accelerate_queue_to_completion` (السطر 1260) | `CMD 1003 / SubCMD 2` (mode 0) | التسريع المجاني الفوري | `0.5s - 0.9s` | `0.5s - 0.9s` (مطابق) |
| 8 | `accelerate_queue_to_completion` (السطر 1325) | `CMD 1003 / SubCMD 2` (mode 2) | تسريع الحقيبة المجمّع | `0.8s - 1.5s` | `0.5s - 0.9s` |
| 9 | `accelerate_queue_to_completion` (السطر 1340) | `CMD 1003 / SubCMD 2` (mode 0) | التسريع المجاني التكميلي (الذيل) | `0.4s - 0.8s` | `0.5s - 0.9s` |

### 2.2. الحلقات المفقودة للفواصل البشرية بين العمليات المتتالية
في دالة `run()` الرئيسية:
1. **تسريع الدخول للدورة (السطور 1506-1523)**:
   عند تسريع طوابير متعددة في حلقة `for qt in list(active_queues.keys()):`، لا يوجد أي فاصل زمني بين تسريع الطابور الأول والثاني في حال وجود طابورين.
   - **المطلوب**: إضافة `await asyncio.sleep(random.uniform(0.5, 0.9))` بين كل طابور وآخر.
2. **تسريع الترقية الفوري (السطر 1596)**:
   بمجرد نجاح ترقية المبنى عبر `execute_building_action`، يتم استدعاء `accelerate_queue_to_completion` فوراً في السطر 1597 بفارق زمني `0ms`! وهذا سلوك غير بشري قد يرصده نظام الحماية.
   - **المطلوب**: إضافة فاصل بشري `await asyncio.sleep(random.uniform(0.5, 0.9))` قبل استدعاء التسريع.
3. **الفاصل بين المرشحين داخل الشجرة (السطر 1606)**:
   عند ترقية عدة متطلبات مسبقة داخل نفس الدورة، يجب الفصل بين كل مبنى وآخر بـ `await asyncio.sleep(random.uniform(0.5, 0.9))`.
4. **الفاصل بين دورات شجرة القلعة (السطر 1610)**:
   السطر الحالي: `await asyncio.sleep(random.uniform(0.5, 1.2))` يُعدّل ليكون منسجماً: `await asyncio.sleep(random.uniform(0.5, 0.9))`.
5. **ترقية المباني الداعمة (السطور 1618-1627)**:
   في حلقة `for s_cand in support_cands:`، عند ترقية مبنيين داعمين (في حال توفر طابورين شاغرين)، لا يوجد فاصل بين المبنى الأول والثاني.
   - **المطلوب**: إضافة `await asyncio.sleep(random.uniform(0.5, 0.9))` بعد كل ترقية ناجحة لمبنى داعم.

### 2.3. سلامة الـ Event Loop والأمان
- تم التأكد من أن جميع الفواصل تُستخدم عبر `await asyncio.sleep(...)` غير المعطلة للـ Event loop، وتفادي استخدام `time.sleep` قطعياً.
- نظراً لأن المهمة محكومة بسقف 5 تسريعات كحد أقصى (`max_speedups_per_run = 5`) وسقف طابورين، فإن إجمالي الفواصل المضافة في الدورة الواحدة لا يتجاوز 3 إلى 6 ثوانٍ، وهو آمن تماماً ولا يسبب أي Timeouts لبوت القلعة.

---

## 3. التحقيق التفصيلي للمتطلب R4: استجابة زر إيقاف القلعة (Stop Button Responsiveness)

### 3.1. تتبع مسار أمر الإيقاف (Execution Trace)
1. يضغط المستخدم على زر الإيقاف (الأيقونة المربعة `Square`) في `CastleCard.tsx` (السطر 563).
2. يُستدعى المعالج `handleToggleClick` (السطر 241):
   - يكتشف أن `isBotActive` مفعل، فيفتح نافذة التأكيد `setShowStopModal(true)`.
3. يضغط المستخدم "تأكيد الإيقاف" في `ConfirmStopModal.tsx`، فيستدعى `handleConfirmStop` في `CastleCard.tsx` (السطر 283):
   ```typescript
   const handleConfirmStop = () => {
     setIsStopping(true)
     botControl.mutate({ castle, state: 'idle' }, {
       onSuccess: () => {
         toast.success(t('accounts.botStoppedSuccess'))
         setShowStopModal(false)
         setLiveState('idle')
         setConnState('idle')
         setIsStopping(false)
       },
       onError: () => { ... }
     })
   }
   ```
4. يرسل `botControl.mutate` طلباً غير متزامن إلى الباك إند: `POST /api/bot/stop/{castle_id}`.
5. في الباك إند (`api_server.py` السطر 808):
   - يُستدعى `bot_manager.stop_bot(email)`.
   - يتم تحديث SQLite عبر `db.upsert_castle_conn_state(..., state="idle", conn_state="idle")`.
   - يعود الرد للواجهة: `{"status": "stopped"}`.

### 3.2. تشريح سبب مشكلة "النقر المزدوج" (The Root Cause of Double Click)
السبب الرئيسي ليس في الباك إند، بل في **التداخل والتعارض بين الـ WebSocket وحالة المكون المحلية في `CastleCard.tsx`**:

1. **السباق الزمني (Race Condition)**:
   - فور عودة الرد الناجح من السيرفر، ينفذ الـ `onSuccess`:
     `setLiveState('idle')`
     `setConnState('idle')`
     `setIsStopping(false)`
   - تغير قيمة `isStopping` من `true` إلى `false` يتسبب فوراً في إطلاق التأثير الجانبي في السطر 151:
     ```typescript
     useEffect(() => {
       if (isStopping || isStarting) return

       if (realStatus && realStatus !== 'offline') {
         const bs = realStatus === 'starting' ? 'starting' : (realStatus === 'idle' ? 'idle' : (realStatus === 'error' ? 'error' : 'running'))
         setLiveState(bs)
         setConnState(realStatus)
       }
     }, [realStatus, isStopping, isStarting])
     ```
   - **الكارثة**: بما أن `isStopping` أصبحت `false`، فإن الشرط `if (isStopping || isStarting) return;` لم يعد يتحقق!
   - وفي هذا الوقت بالذات، ما هي قيمة `realStatus` المستلمة من الـ WebSocket؟
     الـ WebSocket في `api_server.py` السطر 1214 ينام لمدة ثانيتين (`await asyncio.sleep(2.0)`). إذن هو **لم يرسل بعد التحديث الجديد "idle"**! فقيمة `realStatus` المخزنة في الـ Hook ما تزال `"running"`.
   - فيقوم الكود في نفس اللحظة باستدعاء:
     `setLiveState('running')`
     `setConnState('running')`
   - **النتيجة الميدانية**: يتم سحق القيمة المتفائلة `idle` فوراً وإعادتها إلى `running` في غمضة عين!
   - يرى المستخدم البطاقة والزر وكأنهما لم يستجيبا للإيقاف، فيضطر للنقر مرة ثانية! وعند النقر الثاني (الذي يكون قد مر عليه أكثر من ثانيتين)، يكون الـ WebSocket قد استيقظ وأرسل `"idle"`، فينجح الإيقاف.

2. **التأخير الزائد في `useBotControl` (السطر 451 من `useCastles.ts`)**:
   ```typescript
   onSettled: (_data, _err, vars) => {
     if (vars?.state === 'idle') {
       setTimeout(() => {
         qc.invalidateQueries({ queryKey: ['castles', userId] })
       }, 1500)
     } else {
       qc.invalidateQueries({ queryKey: ['castles', userId] })
     }
   }
   ```
   هذا التأخير التعسفي (1500ms) يجعل كاش React Query متأخراً عن الواقع، ويمنع تحديث بيانات القلعة في الصفحة الرئيسية فورياً.

---

## 4. التحقيق التفصيلي للمتطلب R4: كاردات القلاع الشبحية (Ghost "Running" Status)

### 4.1. الخلل في نقطة النهاية بالباك إند (`api_server.py`)
في دالة `list_castles` (السطور 509-536) ودالة `get_castle_detail` (السطور 548-571):
```python
    for c in castles:
        em = c.get("email", "")
        bot = bot_manager.get_bot(em)
        if bot:
            # دمج الحالة الحية من كائن الذاكرة
            live = bot.get_live_info()
            ...
            c["state"] = "running" if live.get("is_running") else "idle"
            c["conn_state"] = live.get("conn_state", c.get("conn_state"))
        else:
            # البوت غير مشغل إطلاقاً في الذاكرة الحية!
            if c.get("conn_state") == "error" or c.get("state") == "error":
                ...
            elif c.get("conn_state") == "sealed" or c.get("state") == "sealed":
                ...
            # ثغرة قاتلة: لا يوجد تعيين لـ c["state"] أو c["conn_state"] إلى "idle"!
```
**الأثر المباشر**:
إذا أُعيد تشغيل السيرفر، أو تعطل البوت، وكانت القلعة مسجلة في SQLite بقيمة `state = 'running'` أو `conn_state = 'connected'`، فإن `bot_manager.get_bot(em)` يعيد `None`. لكن في فرع `else`، **لا يتم تصفير الحالة إلى idle**! فيقوم الـ API بإرجاع `state: 'running'` و `conn_state: 'connected'` للواجهة، وتظهر القلعة وكأنها تعمل وهي في الحقيقة ميتة تماماً في السيرفر!

### 4.2. تضارب الكاش المحلي (`localStorage`) في `useCastles.ts`
- في `useCastles.ts` السطر 184: `staleTime: 60_000` مع `initialData: () => getCachedCastles(userId)`.
- عند حفظ الحسابات في الكاش أثناء تشغيل البوت، يتم تخزين كائن بحالة `"running"`.
- عند فتح المستخدم للوحة التحكم، يقرأ React Query الكاش من `localStorage` ويعرضه فوراً كحالة ابتدائية. وبما أن مدة الصلاحية دقيقة، فإن الواجهة تفترض أن القلعة تعمل!
- إذا توقف البوت في الخلفية أو من تبويب آخر، فإن المتصفح لا يعلم بذلك إلا بعد إعادة التحميل بالكامل (F5) أو انتهاء الدقيقة.

### 4.3. الجمود المنطقي في `CastleCard.tsx` (The State Machine Trap)
في `CastleCard.tsx` السطر 110:
```typescript
  const isActuallyRunning = Boolean(
    realStatus === 'running' ||
    realStatus === 'waiting' ||
    connState === 'connected' ||
    connState === 'waiting' ||
    (castle.bot_status?.state === 'running' && castle.bot_status?.conn_state !== 'starting')
  )
```
وفي السطر 182:
```typescript
  const isBotActive = !isError && !isStoppingActive && !isStartingActive && (
    isRunningNow || isWaitingCycle || isActuallyRunning ||
    (!isDeploying && (liveState === 'running' || castle.bot_status?.state === 'running')) ||
    Boolean(castle.bot_status?.state === 'running')
  )
```
**الخلل المنطقي**:
الشرط `Boolean(castle.bot_status?.state === 'running')` مدمج بـ OR غير مشروط!
حتى لو أرسل الـ WebSocket حالة `idle`، أو كان الاتصال مقطوعاً `offline`، فإن مجرد وجود قيمة `running` في خاصية `castle` (القادمة من كاش React Query أو localStorage) يجعل `isActuallyRunning` و `isBotActive` تعودان بقيمة `true` حتماً! ولا يمكن كسر هذا القفل المنطقي إلا بتحديث كامل للصفحة.

---

## 5. التحقيق التفصيلي للمتطلب R4: استهلاك الموارد وإعادة التصيير (UI Re-renders & Resource Optimization)

### 5.1. كسر الميمويزيشن في `Accounts.tsx`
في `Accounts.tsx` السطور 605-643، يتم تمرير الخصائص لـ `CastleCard` بالطريقة التالية:
```tsx
<CastleCard
  key={castle.id}
  castle={castle}
  userId={uid}
  index={idx}
  isExpanded={expandedCastleId === castle.id}
  onToggleExpand={() => setExpandedCastleId(prev => prev === castle.id ? null : castle.id)}
  onDelete={handleDelete}
  onEdit={setEditingCastle}
  onSetBatchTemplate={handleSetAsBatchTemplate}
  isStopAllPending={stopAllBots.isPending}
/>
```
- دالة `onToggleExpand` يتم إنشاؤها كدالة سهمية جديدة (`() => ...`) في كل دورة تصيير لصفحة `AccountsPage`.
- دالة `handleDelete` لم تُغلف بـ `useCallback`.
- **النتيجة**: مقارنة الخصائص في `React.memo(CastleCardInner)` تفشل دائماً (`prevProps.onToggleExpand !== nextProps.onToggleExpand`). وبالتالي، أي كتابة في شريط البحث، أو فتح أي كارد، يؤدي إلى إعادة تصيير **كافة بطاقات القلاع الخمسين دفعة واحدة**!

### 5.2. عبء الشجرة الضخمة لـ `TaskTabContent` (3,164 سطر)
- بمجرد أن يفتح المستخدم إعدادات أي قلعة، تصبح `hasBeenExpanded = true`.
- يظل مكون `TaskTabContent` موجوداً في الـ DOM مخفياً بـ `display: none` (`hidden`).
- مكون `TaskTabContent` **غير مغلف بـ `React.memo` نهائياً**.
- في كل مرة يُعاد فيها تصيير `CastleCard`، يعاد تشغيل كامل شجرة `TaskTabContent` بآلاف أسطرها ومصفوفات المهام، وفحص التغييرات المتكرر `countConfigChanges`.

### 5.3. استنزاف موارد السيرفر بقنوات الـ WebSocket المتعددة
- يفتح كل كارد قناة WebSocket مستقلة خاصة به على المسار: `/ws/status/{castle_id}`.
- في الباك إند (`api_server.py` السطور 1162-1215):
  كل قناة تدير حلقة لا نهائية تقرأ قاعدة بيانات SQLite كل ثانيتين: `c_data = db.get_castle_by_id(castle_id)`.
  إذا كان لدى المستخدم 20 قلعة تعمل، فإن السيرفر ينفذ 10 استعلامات SQLite في الثانية الواحدة بصورة مستمرة، مما يسبب إشغالاً دائماً للمعالج وقفل ملف WAL دون داعٍ.

---

## 6. حزمة الحلول والتعديلات المقترحة (Proposed Solutions & Code Snippets)

لتمكين وكيل التنفيذ (Implementer) من إنجاز العمل بأعلى دقة وشفافية وفق المعايير، هذه المقترحات الدقيقة والجاهزة للتطبيق:

### 6.1. حلول مهمة البناء `tasks/building.py` (R3)

1. **توحيد فواصل `safe_query` لتكون دائماً بين 0.5s و 0.9s**:
   - في السطر 526 (`refresh_active_queues`):
     ```python
     # قبل:
     resp = await self.safe_query("1003", "1", {}, min_delay=0.6, max_delay=1.2)
     # بعد:
     resp = await self.safe_query("1003", "1", {}, min_delay=0.5, max_delay=0.9)
     ```
   - في السطر 798 (`harvest_building_resource`):
     ```python
     # قبل:
     resp = await self.safe_query("1001", "8", {"bid": bid, "iid": iid}, min_delay=0.3, max_delay=0.7)
     # بعد:
     resp = await self.safe_query("1001", "8", {"bid": bid, "iid": iid}, min_delay=0.5, max_delay=0.9)
     ```
   - في السطر 1146 (فاصل ما بعد الحصاد):
     ```python
     # قبل:
     await asyncio.sleep(0.3)
     # بعد:
     await asyncio.sleep(random.uniform(0.5, 0.9))
     ```
   - في السطر 863 والسطر 1114 (التشييد `1001/2`):
     ```python
     # قبل:
     resp = await self.safe_query("1001", "2", payload, min_delay=0.8, max_delay=1.5)
     # بعد:
     resp = await self.safe_query("1001", "2", payload, min_delay=0.5, max_delay=0.9)
     ```
   - في السطر 1150 (الترقية `1001/3`):
     ```python
     # قبل:
     resp = await self.safe_query("1001", "3", payload, min_delay=0.8, max_delay=1.5)
     # بعد:
     resp = await self.safe_query("1001", "3", payload, min_delay=0.5, max_delay=0.9)
     ```
   - في السطر 1330 والسطر 1345 (تسريع الحقيبة والذيل):
     ```python
     # السطر 1330:
     # قبل: min_delay=0.8, max_delay=1.5
     # بعد: min_delay=0.5, max_delay=0.9

     # السطر 1345:
     # قبل: min_delay=0.4, max_delay=0.8
     # بعد: min_delay=0.5, max_delay=0.9
     ```

2. **إضافة فواصل بشرية بين العمليات المتتالية في `run()`**:
   - بين تسريع طوابير الدخول (بعد السطر 1519):
     ```python
     if completed:
         self.speedup_count += 1
         actions_taken.append(f"⚡ تسريع استباقي: {b_name}")
         await asyncio.sleep(random.uniform(0.5, 0.9))
     ```
   - قبل استدعاء التسريع الفوري للمتطلب بعد بدء الترقية (قبل السطر 1597):
     ```python
     if do_speedup and not speedup_exhausted and self.speedup_count < self.max_speedups_per_run:
         await asyncio.sleep(random.uniform(0.5, 0.9))
         completed, red, r_msg = await self.accelerate_queue_to_completion(allocated_qtype)
     ```
   - بين دورات شجرة القلعة (السطر 1610):
     ```python
     # قبل:
     await asyncio.sleep(random.uniform(0.5, 1.2))
     # بعد:
     await asyncio.sleep(random.uniform(0.5, 0.9))
     ```
   - بين ترقيات المباني الداعمة (بعد السطر 1624):
     ```python
     if ok_s:
         actions_taken.append(s_msg)
         free_slots -= 1
         await asyncio.sleep(random.uniform(0.5, 0.9))
     ```

---

### 6.2. حلول الباك إند لمنع القلاع الشبحية `api_server.py` (R4)

1. **إعادة تعيين الحالة الصريحة إلى `idle` عند غياب كائن البوت**:
   في `api_server.py` السطر 527 (داخل `list_castles`) والسطر 563 (داخل `get_castle_detail`):
   ```python
   # قبل:
   else:
       if c.get("conn_state") == "error" or c.get("state") == "error":
           ...
       elif c.get("conn_state") == "sealed" or c.get("state") == "sealed":
           ...

   # بعد (التصحيح المعتمد):
   else:
       if c.get("conn_state") == "error" or c.get("state") == "error":
           c["state"] = "error"
           c["conn_state"] = "error"
           if "كلمة" in str(c.get("status_message", "")) or "password" in str(c.get("status_message", "")).lower():
               c["is_password_error"] = True
       elif c.get("conn_state") == "sealed" or c.get("state") == "sealed":
           c["state"] = "sealed"
           c["conn_state"] = "sealed"
       else:
           # إذا لم يكن البوت قيد التشغيل ولم يكن محظوراً أو به خطأ، فهو متوقف حتماً
           c["state"] = "idle"
           c["conn_state"] = "idle"
           if c.get("status_message") in ("البوت يعمل الآن...", "جاري الاتصال بخادم اللعبة..."):
               c["status_message"] = "متوقف"
   ```

2. **تنظيف وتصفير حالات القلاع العالقة عند بدء تشغيل السيرفر**:
   في `api_server.py` عند بدء التشغيل أو داخل حدث التهيئة:
   تصفير أي قلاع كانت مسجلة كـ `running` في SQLite قبل تشغيل السيرفر لتفادي بقاء قلاع شبحية بعد إعادة التشغيل:
   ```python
   with db.get_connection() as conn:
       conn.execute("""
           UPDATE castle_states 
           SET state = 'idle', conn_state = 'idle', status_message = 'جاهز للتشغيل' 
           WHERE state = 'running' OR conn_state IN ('connected', 'starting', 'waiting')
       """)
   ```

---

### 6.3. حلول استجابة زر الإيقاف وتزامن الحالة في الواجهة (R4)

1. **إصلاح السباق الزمني في `CastleCard.tsx`**:
   - إضافة قفل زمني صغير أو مرجع `isJustStoppedRef` لمنع `useEffect([realStatus])` من إعادة كتابة الحالة القديمة خلال أول ثانيتين بعد الإيقاف الناجح:
   ```typescript
   const isJustStoppedRef = useRef(false)

   const handleConfirmStop = () => {
     setIsStopping(true)
     botControl.mutate({ castle, state: 'idle' }, {
       onSuccess: () => {
         toast.success(t('accounts.botStoppedSuccess'))
         setShowStopModal(false)
         isJustStoppedRef.current = true
         setLiveState('idle')
         setConnState('idle')
         setIsStopping(false)
         setTimeout(() => {
           isJustStoppedRef.current = false
         }, 2500)
       },
       onError: () => {
         toast.error(t('accounts.botStopError'))
         setShowStopModal(false)
         setIsStopping(false)
       }
     })
   }
   ```
   - وفي تأثير التزامن مع الـ WebSocket (السطر 151):
   ```typescript
   useEffect(() => {
     if (isStopping || isStarting || isJustStoppedRef.current) return

     if (realStatus && realStatus !== 'offline') {
       const bs = realStatus === 'starting' ? 'starting' : (realStatus === 'idle' ? 'idle' : (realStatus === 'error' ? 'error' : 'running'))
       setLiveState(bs)
       setConnState(realStatus)
     }
   }, [realStatus, isStopping, isStarting])
   ```

2. **تصحيح شروط `isActuallyRunning` و `isBotActive` في `CastleCard.tsx`**:
   - إزالة الشرط غير المحمي `Boolean(castle.bot_status?.state === 'running')` وتفضيل حالة الذاكرة الحية الحالية:
   ```typescript
   const isActuallyRunning = Boolean(
     !isStoppingActive && !isJustStoppedRef.current && (
       realStatus === 'running' ||
       realStatus === 'waiting' ||
       connState === 'connected' ||
       connState === 'waiting' ||
       (liveState === 'running' && connState !== 'starting' && connState !== 'idle')
     )
   )
   ```

3. **إلغاء التأخير التعسفي (1500ms) وتحديث الكاش المحلي فورياً في `useCastles.ts`**:
   في `useBotControl` (السطر 450):
   ```typescript
   onSettled: (_data, _err, vars) => {
     qc.invalidateQueries({ queryKey: ['castles', userId] })
   }
   ```
   وفي `onMutate`، تحديث الـ `localStorage` فورياً بالتزامن مع `qc.setQueryData` حتى لا يسترجع المتصفح الحالة الشبحية عند التحديث.

---

### 6.4. حلول إعادة التصيير وخفة الأداء في الواجهة (R4)

1. **استقرار الدوال في `Accounts.tsx` عبر `useCallback`**:
   - تعريف `handleToggleExpand` بـ `useCallback`:
   ```typescript
   const handleToggleExpand = useCallback((castleId: string) => {
     setExpandedCastleId(prev => prev === castleId ? null : castleId)
   }, [])
   ```
   - تمريرها للكارد بدون دوال سهمية مضمنة:
   ```tsx
   onToggleExpand={() => handleToggleExpand(castle.id)} // أو الأفضل تمرير معرف القلعة داخل الكارد
   ```
2. **تغليف `TaskTabContent` بـ `React.memo`**:
   في نهاية `dashboard/src/components/accounts/TaskTabContent.tsx`:
   ```typescript
   export const TaskTabContent = React.memo(TaskTabContentInner)
   ```
   مما يمنع إعادة تصيير الشجرة المكونة من 3,164 سطراً إلا إذا تغيرت إعدادات تلك القلعة المحددة بالفعل!

---

## 7. خطة التحقق والاختبار (Verification Method)

1. **التحقق من فواصل البناء (R3)**:
   - فحص كود `tasks/building.py` والتأكد من مطابقة كافة قيم `min_delay` و `max_delay` لمدى `0.5s` و `0.9s`.
   - تشغيل اختبار المحاكاة عبر `test_task_method.py`:
     ```powershell
     python test_task_method.py --email LUCIFER@g4.com --task building run
     ```
   - التأكد من خلال السجلات (`log`) من وجود فواصل بشرية بين بدء الترقية وأمر التسريع.

2. **التحقق من استجابة زر الإيقاف وغياب النقر المزدوج (R4)**:
   - تشغيل بوت القلعة من لوحة التحكم، والتأكد من تحوله إلى اللون الأخضر (يعمل).
   - النقر على زر الإيقاف وتأكيده في النافذة المنبثقة:
     - التحقق من تحول الزر وحالة البطاقة فوراً وبشكل حاسم إلى حالة "متوقف" (`idle`) بنقرة واحدة فقط.
     - مراقبة عدم ارتداد الزر إلى "يعمل" خلال الثواني الثلاث التالية.

3. **التحقق من سلامة الكاش ومنع القلاع الشبحية (R4)**:
   - إيقاف خادم البوت بالكامل (`api_server.py`) ثم إعادة تشغيله.
   - فتح لوحة التحكم في المتصفح والتأكد بنسبة 100% أن القلاع تظهر كـ "متوقفة" (`idle`) دون أي قلاع شبحية عالقة بحالة "يعمل".

---
*انتهى تقرير التحقيق الفني لـ R3 & R4، وهو موثق وجاهز لإحالة خطوات التنفيذ لفرق العمل المعنية.*
