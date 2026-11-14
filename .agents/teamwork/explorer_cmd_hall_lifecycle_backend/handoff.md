# تقرير التسليم والتحقق (Handoff Report)

## 1. Observation (الملاحظات المادية المباشرة)

1. **حلقة الجمود الـ 300 ثانية في `tasks/command_hall.py`**:
   - السطر 66:
     ```python
     LOOP_MAX_DURATION_SECONDS = 300
     ```
   - السطر 971:
     ```python
     while (time.time() - start_time) < LOOP_MAX_DURATION_SECONDS:
     ```
   - السطر 940-941 (داخل `_handle_march_tasks`):
     ```python
     if res is not None:
         dispatched += 1
         task["statue"] = TASK_STATUE_PREPARE
     ```
   - السطر 1008:
     ```python
     dispatched, blocked_on_march = await self._handle_march_tasks(hall_data)
     total_marches += dispatched
     ```
   - السطور 1024-1041:
     ```python
     elapsed = int(time.time() - start_time)
     has_active_marches = (total_marches > 0)
     has_preparing_tasks = any(self._safe_int(t.get("statue", 0)) == TASK_STATUE_PREPARE for t in tasks)

     # عدم الخروج مبكراً عند 30 ثانية إذا كانت هناك فيالق مرسلة بالخريطة أو مهام قيد الإعداد
     if not pending_tasks and not has_active_marches and not has_preparing_tasks and elapsed >= 30:
         self.log("[CommandHall] ✓ تم إنجاز كافة مهام قاعة القيادة المتاحة واستلام جوائزها بنجاح.")
         exit_reason = "تم إنجاز كافة المهام المتاحة بالكامل"
         break

     # فاصل زمني بشري عشوائي بين الدورات (4.0s - 7.0s)
     sleep_sec = random.uniform(4.0, 7.0)
     remaining_time = LOOP_MAX_DURATION_SECONDS - (time.time() - start_time)
     if remaining_time <= 0:
         exit_reason = "انتهاء مدة الدورة الزمنية (5 دقائق)"
         break

     await asyncio.sleep(min(sleep_sec, max(0.5, remaining_time)))
     ```

2. **منع تحديث البيانات من السيرفر في `_ensure_synced_data`**:
   - السطور 555-567 في `tasks/command_hall.py`:
     ```python
     hall_data = self.get_ctrl("commandHall")
     if self._is_synced and hall_data is not None and isinstance(hall_data, dict):
         return hall_data

     if isinstance(hall_data, dict) and (
         hall_data.get("taskList")
         or "commandLv" in hall_data
         or "armyGroupTaskData" in hall_data
         or "armyPioneerTaskData" in hall_data
         or "commonTaskData" in hall_data
     ):
         self._is_synced = True
         return hall_data
     ```
     بعد التكرار الأول، تظل `self._is_synced == True`، فلا ترسل الدالة أي استعلام للسيرفر نهائياً.

3. **تعطيل حلقة القلعة في `bot_manager.py`**:
   - السطور 642-644 في `bot_manager.py`:
     ```python
     task_instance = task_cls(self.conn, self.log, t_cfg)
     res = await task_instance.safe_execute()
     ```
     حلقة البوت تنتظر `safe_execute()` بشكل تسلسلي؛ وبالتالي فإن تعليق `CommandHallTask` لمدة 300 ثانية يجمد دورة القلعة بالكامل.

4. **غياب معالج إشعارات قاعة القيادة في عميل الشبكة**:
   - في `core/game_client.py` السطور 1433-1481، يتم فقط معالجة:
     `NOTIFY_LOCAL_QUEUE_SYNC`, `NOTIFY_ARMY`, `NOTIFY_CITY`, `NOTIFY_LORD`, `NOTIFY_TIME_REWARD`.
   - لا توجد أي معالجة لإشعار `NOTIFY_COMMAND_HALL` (الأمر 1009 / المعرف 608 المحدد في `cmdDef.lua:650` و `notifyCtrl.lua:947-949`).

5. **فحص مهام الفيالق الأخرى**:
   - البحث في مجلد `tasks/` أكد خلو المشروع من مهام `gather.py` أو `monster.py` أو `rally.py`.
   - `CommandHallTask` هي المهمة الأولى التي تتعامل مع `CMD 1007 / SubCMD 2` لإرسال الجيوش على الخريطة.

---

## 2. Logic Chain (سلسلة الاستدلال المنطقي)

1. استناداً إلى الملاحظة (1)، عندما يكون هناك مهمة فيلق (طليعة 2 أو معركة 5)، يقوم `_handle_march_tasks` بإرسال الفيلق ويزيد `total_marches` ليصبح 1، ويغير حالة المهمة بالذاكرة يدوياً إلى `TASK_STATUE_PREPARE`.
2. استناداً إلى الملاحظة (1)، في السطر 1025، تم تعريف `has_active_marches = (total_marches > 0)`. وبما أن `total_marches` عداد تراكمي لا يتناقص أبداً، فإن هذه القيمة تصبح `True` حتماً. وبالمثل، `has_preparing_tasks` تظل `True` لأن حالة المهمة أصبحت `PREPARE`.
3. استناداً إلى الملاحظة (1)، الشرط في السطر 1029 `not has_active_marches and not has_preparing_tasks` يستحيل أن يتحقق طالما أُرسل فيلق واحد.
4. استناداً إلى الملاحظة (2)، في كل دورة تالية داخل الـ `while`، ترجع دالة `_ensure_synced_data` نفس القاموس المخزن محلياً لأن `self._is_synced == True`.
5. استناداً إلى الملاحظة (4)، عميل الاتصال لا يتلقى أي تحديثات دفع تخص قاعة القيادة، وبالتالي لا تتغير حالة المهمة في الذاكرة من `PREPARE` إلى `FINISH` تلقائياً.
6. استناداً إلى الملاحظتين (1) و (2)، يدخل البوت في حلقة انتظار متواصلة `await asyncio.sleep(4.0 - 7.0)` مكررة حتى تنقضي الـ 300 ثانية كاملة المحددة بالسطر 66.
7. استناداً إلى الملاحظة (3)، يؤدي هذا إلى تجميد دورة البوت لحساب القلعة لمدة 5 دقائق كاملة في `bot_manager.py`.
8. أثناء نوم البوت، يصل الفيلق في سيرفر اللعبة الفعلي إلى الهدف (يبعد 1-5 مربعات فقط، يستغرق 15-25 ثانية)، وتنتصر القوات وتتحول حالة المهمة في السيرفر إلى `statue == 3`.
9. نظراً لعدم استعلام البوت عن `CMD 2274 / SubCMD 1` طوال فترة الـ 5 دقائق، فإن `_claim_finished_tasks` تفحص الذاكرة وتجد الحالة لا تزال `PREPARE`، فلا ترسل أمر الاستلام `CMD 2274 / SubCMD 8`.
10. عند انقضاء الـ 300 ثانية، تنتهي الدورة وتخرج المهمة محققة `claimed: 0` مع ضياع فرصة استلام المكافآت المستحقة للمسير.

---

## 3. Caveats (الافتراضات والحدود)

- لم يتم تعديل أي كود في ملفات المشروع تنفيذاً لمبدأ التحقيق للقراءة فقط (Read-Only Explorer).
- تم الاعتماد على مطابقة الأكواد الرسمية المستخرجة من كود اللعبة في `game_file/` لتحديد ثوابت المسير وسلوك السيرفر.
- لا توجد أي تحفظات أخرى (No further caveats).

---

## 4. Conclusion (الاستنتاج النهائي)

- سبب الجمود لمدة 300 ثانية هو **حلقة `while` بمهلة ثابتة 300 ثانية مقترنة بشرط خروج معيب يعتمد على عداد تراكمي `total_marches > 0` وكاش ذاكرة يمنع إعادة المزامنة**.
- سبب الخروج بـ 0 مكافأة هو **عدم إرسال استعلام المزامنة `CMD 2274 / SubCMD 1` فور وصول الفيلق لحسم المعركة وتحويل الحالة إلى `FINISH`، مما منع استدعاء أمر الاستلام `CMD 2274 / SubCMD 8`**.
- الحل الجذري يكمن في:
  1. استبدال مهلة الـ 300 ثانية بـ تتبع ديناميكي لخط المسير والوصول الفعلي (15 إلى 35 ثانية كحد أقصى).
  2. مزامنة الذاكرة عبر استدعاء صريح لـ `CMD 2274 / SubCMD 1` فور انتهاء وقت المسير المقدر.
  3. استلام المكافآت فورياً عبر `CMD 2274 / SubCMD 8`.
  4. استلام مكافأة النوع 1 لتجديد المهام والانتقال الفوري للموجة التالية دون توقف، ثم الخروج النظيف دون أي انتظار راكد.

---

## 5. Verification Method (طريقة التحقق المستقلة)

1. **فحص التقرير الشامل**:
   - مطالعة `analysis.md` في المجلد الحالي للاطلاع على كامل الأدلة والشفرات وتحليل كل نوع مهمة.
2. **فحص الكود المصدري مباشرة**:
   - التحقق من السطور 65-66، 555-567، 940-941، 971-1041 في `tasks/command_hall.py`.
   - التحقق من السطور 642-644 في `bot_manager.py`.
   - التحقق من السطور 1438-1445 في `core/game_client.py`.
3. **تشغيل اختبارات الوحدة المعاكسة**:
   ```powershell
   python -m unittest tools/test_command_hall_task.py
   python -m unittest tools/test_challenger_command_hall.py
   ```
4. **شروط إبطال النتيجة (Invalidation Conditions)**:
   - تبطل هذه النتيجة إذا ثبت أن سيرفر اللعبة يقوم بتحديث كائن `conn.init_data["commandHall"]` تلقائياً دون الحاجة لـ `CMD 2274 / SubCMD 1`، أو إذا كان زمن مسير الفيلق لقاعة القيادة يستلزم فعلياً 300 ثانية على الخريطة (وهو ما تم دحضه قطعياً ببيانات المسافة والسرعة 1-5 بلاطات).
