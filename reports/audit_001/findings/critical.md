# 🔴 سجل النتائج الحرجة (Critical Findings Log)
### دورة التدقيق: `audit_001`
### المعيار: أخطاء تؤدي لخطر الحظر المباشر (BAN) أو خرق معيار التحقق المسبق (0-Network Pre-flight)

---

## 📌 [CRITICAL-001]: تلفيق جنود وهميين وإرسال حزمة هجوم بقوات منعدمة
- **الملف المتأثر:** `tasks/hero_trial.py`
- **الأسطر البرمجية:** [tasks/hero_trial.py#L264-L265](file:///e:/intqam-sultan/tasks/hero_trial.py#L264-L265) و [tasks/hero_trial.py#L208-L212](file:///e:/intqam-sultan/tasks/hero_trial.py#L208-L212)
- **ملف السجال التحكيمي:** [debates/claim_001.md](file:///e:/intqam-sultan/reports/audit_001/debates/claim_001.md)
- **طبيعة الخلل:**
  عندما تكون القلعة خالية من الجنود في الذاكرة الحية (`armyCtrl.armys` فارغ و `battleData.soldiers` فارغ)، تقوم الدالة `_get_minimal_soldiers` بتوليد جندي افتراضي `[{"id": 401, "num": 1}]` بدلاً من إرجاع قائمة فارغة والتوقف الآمن. يتبع ذلك إرسال حزمة هجوم رسمية عبر المقبس المشفر `safe_query("1059", "3", {"stageID": current_stage, "soldiers": [{"id": 401, "num": 1}]})`.
- **الدليل المصدري المانع من اللعبة:**
  عميل اللعبة الرسمي في [game_file/src/app/module/heroTrial/htBattle/htBattleMgr.lua#L81-L100](file:///e:/intqam-sultan/game_file/src/app/module/heroTrial/htBattle/htBattleMgr.lua#L81-L100) يتحقق من القوات عبر `matchSoldiers` ويرفض إرسال الحزمة محلياً ويعيد `Err_HT_SOLDIER_NOT_ENOUGH (35010)`.
- **تقييم خطر الحظر (Ban Risk):**
  **حرج جداً (CRITICAL BAN RISK).** إرسال حزم بهجوم لقوات غير موجودة في قاعدة بيانات خادم اللعبة يمثل نمطاً شاذاً يفضح كون العميل بوتاً اصطناعياً ويؤدي للرصد والحظر الآلي الفوري.
- **الحل الهندسي المطلوب:**
  إرجاع قائمة فارغة `[]` من `_get_minimal_soldiers` وإضافة فحص مانع (0-Network Guard) قبل استدعاء الشبكة ينهي المهمة بـ `TaskResult.skip("No soldiers available for attack")`.
