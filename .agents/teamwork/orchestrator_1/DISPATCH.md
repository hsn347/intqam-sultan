# Dispatch History

## 2026-10-31T11:27:12Z
فريق العمل المطلوب بتنسيق المطور:
"اريد فريق يعمل على تنفيذ هذه الخطة وبعض الامور الاخرى , اريد وكيل مسوول عن بناء المهمة نفسها ومنطقها و وكيل مسوول عن الواجهة وبناء الخيار هناك واختبارها وتجهيزها و وكيل مسوول عن قاعدة البيانات والتاكد انه مربوط بالواجهة ومربوط بالمهمة , و وكيل مسوول متابعة الوكيل الذي يقوم ببناء المهمة ومهمة متخصصة في اتباع مسارات الذاكرة الحية التي يكتبها الوكيل الاول للتاكد من انها سليمة ومطابقة للذاكرة الحية , وكيل اخير هو المشرف عن العملية كلها وينسق بينهم"

تنفيذ خطة تصنيع العتاد (Forge Equipment) المعتمدة وإدراجها كمهمة نشاط يومي جديدة في البوت ولوحة التحكم، مع الالتزام الصارم بدستور وقواعد المشروع في GEMINI.md وخطوات خط أنابيب المراحل الست.

Integrity mode: development

وثيقة الخطة المعتمدة: `C:\Users\Computer Home\.gemini\antigravity\brain\c9dda83e-09db-4998-9bd3-36c6eb6ad6d0\forge_equipment_plan.md`
الأيقونات المجهزة للاستخدام:
- أيقونة المهمة اليومية: `dashboard/public/images/daily/forge_equipment.png`
- أيقونات الأصناف الستة: `dashboard/public/images/daily/equip/{weapon, clothes, helmet, trousers, shoes, ring}.png`
(ونسخها الجاهزة في `dashboard/dist/images/daily/`)

## Requirements

### R1. مهمة تصنيع العتاد بالباك إند والذاكرة الحية (Backend Task & 0-Network Pre-flight)
بناء فئة `ForgeEquipmentTask` داخل `tasks/forge_equipment.py` وارثة حصراً من `BaseTask` وتصديرها في `tasks/__init__.py`.
- فحص الذاكرة الحية مسبقاً (0-Network Pre-flight): إذا كانت المهمة اليومية الرسمية (`4100009`) منجزة بالفعل في `questCtrl.point_finish_list`، أو إذا كانت ورشة الحدادة مشغولة بتصنيع جارٍ (`endTime > now`)، يتم تخطي المهمة فوراً دون إرسال أي طلب شبكي.
- إذا وُجدت قطعة مكتملة التصنيع تنتظر الاستلام، يتم استلامها بأمر الاستلام الرسمي (`CMD=1047, SUBCMD=2`).
- إذا كانت الورشة فارغة، يتم فرز وصفات الصنف المختار تنازلياً من المستوى الأعلى إلى المستوى 1 واختيار وتصنيع أعلى قطعة ممكنة تتوافق مع مستوى الحدادة ومخزون المواد والصلب، مع استدعاء `ensure_resources` لتوفير أي عجز بالموارد/الصلب، والتدرج التلقائي حتى المستوى 1 لضمان إنجاز المهمة.
- تحديث كائنات الذاكرة الحية محلياً فور إرسال أمر التصنيع أو الاستلام.

### R2. تسجيل المهمة وإعدادات مدير البوت (Bot Manager Integration)
تسجيل المهمة في `bot_manager.py` داخل `REGISTERED_TASKS` وتحديد الإعداد الافتراضي داخل `DEFAULT_BOT_CONFIG` بالقيمة `{"enabled": False, "category": "weapon"}`، وتحديث دالة `reload_config_from_db()` لقراءة الإعداد بسلاسة عند التعديل.

### R3. قائمة السماح والتحقق بخادم الـ API (API Server Whitelist)
إضافة مفتاح `forge_equipment` إلى Pydantic schema وفلتر `clean_config` في `api_server.py` لضمان استقبال وحفظ وتمرير إعدادات المهمة دون استبعادها.

### R4. ترحيل قاعدة البيانات والتحقق المباشر (Database Migration & Integrity)
إجراء ترحيل صريح لقاعدة البيانات `database/castles.db` لتحديث عمود `config` لجميع القلاع المسجلة بالقيمة الافتراضية للمهمة، والتحقق البرمجي المباشر من محتوى قاعدة البيانات لضمان عدم فقدان أي إعدادات.

### R5. إعدادات وأنواع الواجهة الأمامية (Frontend Types & Defaults)
تحديث تعريفات الأنواع في `dashboard/src/types/index.ts` وهوك القلاع في `dashboard/src/hooks/useCastles.ts` لتشمل مفتاح `forge_equipment` مع قيمها الافتراضية.

### R6. واجهة المستخدم والحفظ المزدوج والترجمة الثلاثية (Frontend UI, Dual-Save & Localization)
- إضافة عنصر التحكم بالمهمة داخل قسم المهام اليومية في `dashboard/src/components/accounts/TaskTabContent.tsx` باستخدام أيقونة المهمة الرسمية، مع توفير اختيار بصري مباشر للأصناف الستة بأيقوناتها المستخرجة.
- تحديث مساري الحفظ معاً: الحفظ التلقائي `performSave()` والحفظ اليدوي `handleSave()`.
- ربط جميع النصوص والوسوم بنظام الترجمة التفاعلي `t(...)` وتحديث ملفات الترجمة الثلاثة بالتزامن: `dashboard/src/locales/ar.json`، `en.json`، `tr.json` ومنع أي نصوص ثابتة مجردة (Hardcoded strings).

### R7. المراجعة والتنسيق (Live Memory Review & Quality Control)
مراجعة مسارات الذاكرة الحية والتحقق البرمجي من تطابق الحقول المستخدمة في المهمة مع كائنات الذاكرة الحية الحقيقية لعميل اللعبة بدون أي أخطاء أو طلبات شبكية مشبوهة.


## 2026-11-01T05:28:06Z
Perform a comprehensive multi-auditor review and implementation: add a mandatory backend task to collect ready daily activity quest chests as the last task in the cycle using synchronized live memory with fallback querying, eliminate orphan/zombie castle processes so no process runs without an active castle, and perform a comprehensive audit and optimization across all admin and client dashboard pages for state caching, system resource consumption, responsive buttons, and stability scaling up to 1000 castles and 150 users adhering to e:\intqam-sultan\AGENTS_CONSTITUTION.md with "فحص شامل بكل المدققين".

Working directory: e:\intqam-sultan
Integrity mode: development

## Requirements

### R1. Daily Activity Quest Chest Collection Task
- Implement a mandatory task to collect and claim ready daily activity quest chests.
- The task must execute as the last task in the castle bot cycle.
- The task must primarily inspect synchronized live memory (conn.init_data) to collect ready chests without unnecessary network requests (0-network check).
- If chest synchronization data is not present in live memory, execute a safe fallback query to retrieve status and claim ready chests.

### R2. Zombie / Orphan Process Lifecycle Elimination
- Ensure no background worker or live process remains running unless it is actively attached to a running castle.
- Cleanly terminate all associated processes and workers when a castle is stopped, eliminating any orphan or zombie operating system processes.
- Prevent duplicate or unattached process spawning.

### R3. Admin & Client Dashboard Optimization, State Caching, and Scaling
- Perform a comprehensive audit and optimization across all pages of the Admin Dashboard and Client Dashboard following e:\intqam-sultan\AGENTS_CONSTITUTION.md.
- Implement intelligent client-side data and state caching so that repeated or regular page navigation does not trigger redundant API fetch requests.
- Eliminate memory leaks, excessive CPU usage, and UI lag, ensuring UI button actions respond immediately.
- Ensure the architecture and state management remain stable, fast, and balanced under high concurrency (scaling up to 1000 castles and 150 users).
