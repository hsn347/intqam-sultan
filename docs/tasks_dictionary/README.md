# الموسوعة الشاملة لمهام وفعاليات انتقام السلاطين ودليل أتمتتها البرمجية
## (Revenge of Sultans Master Task & Automation Encyclopedia)

مرحباً بك في أضخم وأشمل توثيق تحليلي وتطبيقي لجميع مهام، فعاليات، وشروط لعبة **انتقام السلاطين (`and.onemt.war.ar`)**.

تم استخراج وبناء هذا القاموس بالكامل اعتماداً على الهندسة العكسية لجداول وشفرات بايتكود اللعبة الأصلية (13,337 ملف Lua مفكك وقابل للقراءة)، وربطها ببروتوكول الحقن والتحكم المباشر عبر الشبكة (Zero-Click Protocol).

---

## 📑 فهرس أقسام الموسوعة

| القسم | الملف التوثيقي | محتوى القسم وتفاصيله | عدد العناصر الموثقة |
| :---: | :--- | :--- | :---: |
| **1** | [**`01_daily_tasks.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/01_daily_tasks.md) | دليل المهام اليومية، صناديق الـ 500 نقطة، وحزم الاستلام الفوري عبر `cmd: 2027` | **33 مهمة يومية و 8 صناديق** |
| **2** | [**`02_main_quests_part1.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/02_main_quests_part1.md) | مهام القصة وتطوير القلعة من المستوى 1 إلى 15 مع شروط البناء والجيش | **650+ مهمة قصة** |
| **3** | [**`03_main_quests_part2.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/03_main_quests_part2.md) | مهام القصة المتقدمة من القلعة 16 إلى 30 ومستويات المجد والهيبة | **650+ مهمة متقدمة** |
| **4** | [**`04_branch_and_growth.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/04_branch_and_growth.md) | مهام الفصول للمبتدئين، مسار النمو السريع عبر `cmd: 2045`، والـ 7 أيام | **فصول النمو الكاملة** |
| **5** | [**`05_alliance_mobilization.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/05_alliance_mobilization.md) | الدليل الكامل لمهام حشد التحالف (Mobilization) عبر `cmd: 2044` والنقاط | **32 نوع مهمة حشد** |
| **6** | [**`06_events_and_competitions.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/06_events_and_competitions.md) | الفعاليات الكبرى الرسمية: حرب الأهرامات، الغزو KvK، السديم، حرب العرش | **10 فعاليات كبرى دورية** |
| **7** | [**`07_special_mini_events.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/07_special_mini_events.md) | الفعاليات المصغرة: كنز النجوم، بساط الريح، المصباح السحري، البتراء، رمضان | **10 ألعاب مصغرة وموسمية** |
| **8** | [**`automation_engine_reference.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/automation_engine_reference.md) | الدليل البرمجي الكامل لحزم الشبكة، التشفير، ودوال الأتمتة المباشرة للبوت | **أكواد الحقن الرسمية** |

---

## 📊 إحصائيات قاعدة البيانات المستخرجة

- **معرف الحزمة الرسمي**: `and.onemt.war.ar` (Revenge of Sultans / `onemt-ros-ar`).
- **إجمالي المهام المفككة والموثقة**: **أكثر من 1,310 مهمة رئيسية و 33 مهمة يومية و 32 مهمة حشد تحالف**.
- **مفردات القاموس اللغوي العربي المستخرجة**: **25,564 مصطلح ونص رسمي معتمد في اللعبة**.
- **عدد أكواد الأوامر الشبكية الموثقة**: **100% من حزم التحكم (CMD / Sub-CMD)** مطابقة لـ `cmdDef.lua`.
- **مستوى الاعتماد على المحاكي أو الشاشة**: **0% (صفر نقرات - صفر لقطات شاشة)**.

---

## 🚀 كيفية استخدام هذا القاموس في تطوير البوت

1. لمعرفة كود حزمة أي مهمة وكيفية إرسالها لسيرفر اللعبة، افتح [**`automation_engine_reference.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/automation_engine_reference.md).
2. لبرمجة روتين البوت اليومي والصناديق، اتبع خطوات [**`01_daily_tasks.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/01_daily_tasks.md).
3. لترقية القلعة والمهام المتسلسلة من الصفر حتى المستوى 30، راجع الجزئين [**`02_main_quests_part1.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/02_main_quests_part1.md) و [**`03_main_quests_part2.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/03_main_quests_part2.md).
4. لبرمجة روبوت التحالف والمشاركة في الحشد، راجع [**`05_alliance_mobilization.md`**](file:///e:/intqam-sultan/docs/tasks_dictionary/05_alliance_mobilization.md).
