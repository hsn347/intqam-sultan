# ⚖️ سجل السجال التحكيمي: ادعاء رقم 001 (Debate Claim 001)
### الملف المستهدف: `tasks/hero_trial.py`
### الموضوع: توليد جندي وهمي (Fallback Soldier Fabrication) وإرسال حزمة هجوم بقوات منعدمة
### تاريخ السجال: 2026-11-15
### مستوى الخطورة المحسوم: `CRITICAL` 🔴 (خطر حظر فوري وخرق صريح لمعيار الفحص المسبق)

---

## 1. بطاقة الادعاء الأصلي (The Original Claim)
- **موقع الكود:** `tasks/hero_trial.py#L239-L265` و `tasks/hero_trial.py#L208-L212`
- **نص الكود المعني:**
  ```python
  # tasks/hero_trial.py#L264-L265
  # افتراضي آمن: جندي مشاة رتبة 1 (ID: 401)
  return [{"id": 401, "num": 1}]
  ```
- **سياق التنفيذ:** عند استدعاء `_get_minimal_soldiers`، إذا لم تكن هناك قوات متبقية في `battle_data.soldiers`، ولم تكن هناك قوات في `armyCtrl.armys` (مثل قلعة مصفرة، أو حساب جديد، أو نقل القوات للخيمة الطبية)، تقوم الدالة بإرجاع جندي وهمي `[{"id": 401, "num": 1}]`.
- **الادعاء:** يزعم الكود في التعليق أن هذا "افتراضي آمن" لإتمام الهجوم بأقل تكلفة، لكنه يمرر هذه المصفوفة مباشرة إلى طلب الشبكة الرسمي `REQ_HT_GENERAL_TRIAL (3)` في السطر 211.

---

## 2. مرافعة المحلل الأساسي (Task Logic Analyst & Network Analyst)
- الكود يرسل الحزمة التالية عبر المقبس المشفر:
  `safe_query("1059", "3", {"stageID": current_stage, "soldiers": [{"id": 401, "num": 1}]})`
- الذاكرة الحية تحتوي على `armyCtrl.armys = {}` أو قيم أصفار، مما يعني أن الحقل في الذاكرة صريح بانعدام القوات.
- تم تجاهل حقيقة الذاكرة وتلفيق مصفوفة جنود غير موجودين أصلاً.

---

## 3. هجمات ومرافعات الخصوم الأربعة (The 4 Adversarial Defenses & Attacks)

### ⚔️ مرافعة الخصم المنطقي (Logic Challenger)
- **موقف الخصم:** اعتراض جوهري مدعوم ببرهان منطقي.
- **البرهان:** الدالة `_get_minimal_soldiers` تخلط بين "تحديد جندي من القوات المتاحة" وبين "اختلاق جندي عند انعدام القوات".
- منطقياً، إذا كانت القلعة خالية من الجنود تماماً، فإن إمكانية شن هجوم هي **مستحيلة قطعية**.
- تحويل القيمة المنعدمة `0` إلى `1` هو مغالطة منطقية تؤدي حتماً إلى كسر الشرط الأساسي للمعركة. الكود كان يجب أن يعيد قائمة فارغة `[]` أو يرمي استثناء يوقف المهمة بتخطي آمن `TaskResult.skip("No soldiers available for trial")` بدلاً من المضي قدماً في مسار الهجوم.

### ⚔️ مرافعة خصم كود اللعبة المصدري (Source Code Challenger)
- **موقف الخصم:** دحض قاطع بالاستناد إلى كود اللعبة الأصلي.
- **الدليل من سورس اللعبة:**
  - في `game_file/src/app/module/heroTrial/htBattle/htBattleMgr.lua#L81-L101`:
    ```lua
    function htBattleMgr.whetherCanGeneralTrial(stageID, soldiers)
        ...
        if not matchSoldiers(soldiers) then
            htBattleMgr.soldiersStatus = false
            return gErrDef.Err_HT_SOLDIER_NOT_ENOUGH -- 35010
        end
        return gErrDef.Err_None
    end
    ```
  - وفي `game_file/src/app/module/heroTrial/heroTrialCtrl.lua#L65-L70`:
    ```lua
    local ret = htBattleMgr.whetherCanGeneralTrial(stageID, soldiers)
    if gErrDef.Err_None ~= ret then
        print("heroTrialCtrl.attackStage: stageID, ret = ", stageID, ret)
        return
    end
    REQ.reqGeneralTrial(stageID, soldiers)
    ```
  - عميل اللعبة الرسمي **يمنع منعاً باتاً** إرسال الحزمة `REQ_HT_GENERAL_TRIAL` إذا كانت القوات غير كافية أو غير متطابقة، ويعود محلياً برمز الخطأ `35010` دون أن تلامس الحزمة السيرفر!
  - إرسال الحزمة من البوت مباشرة رغم انعدام الجنود يخالف سلوك العميل الرسمي الصريح.

### ⚔️ مرافعة خصم الذاكرة الحية (Memory Challenger)
- **موقف الخصم:** إثبات خرق صريح لمعيار صلاحية الذاكرة.
- **البرهان:**
  - الذاكرة الحية توفر بيانات دقيقة في `init_data["armyCtrl"]["armys"]` وفي `init_data["htData"]["battleData"]["soldiers"]`.
  - حالة الذاكرة هنا هي `Valid` (تؤكد أن عدد الجنود = 0).
  - تصرف كود البوت تجاهل القيمة الحقيقية المؤكدة في الذاكرة، وقام بإنشاء حالة وهمية (`Fabricated State`).
  - هذا انتهاك مباشر للمعيار الخامس من دستور المشروع: *"لا يجوز إرسال أي طلب شبكي يعتمد نجاحه على شرط معين في حالة اللعبة قبل التحقق من ذلك الشرط تلقائياً باستخدام مصدر موثوق وحديث من الذاكرة الحية"*.

### ⚔️ مرافعة الخصم الشبكي ومكافحة الحظر (Network Challenger)
- **موقف الخصم:** **تحذير أمني أحمر - خطر حظر مباشر (CRITICAL BAN RISK)**.
- **البرهان:**
  - خادم اللعبة الرسمي (ONEMT Server) يمتلك سجلاً دقيقاً لكل جندي في القلعة.
  - عندما يستقبل السيرفر حزمة هجوم تتضمن جندياً من الرتبة 1 (ID: 401) من قلعة لا تملك هذا الجندي في قاعدة بيانات السيرفر، يتم تسجيل الحدث كـ "طلب غير طبيعي / تلاعب بالحزم (Packet Tampering / Injection)".
  - الرد السيرفري المباشر هو `ERR_HT_HAVE_NOT_SOLDIERS ("35004")` أو `ERR_HT_SOLDIER_NOT_ENOUGH ("35010")`.
  - تكرار تلقي السيرفر لمثل هذه الأخطاء من نفس الـ IP وجلسة البوت هو أحد المعايير القياسية لأنظمة الحظر الآلي (Anti-Bot Pattern Detection).

---

## 4. حكم المنسق النهائي وقرار التحكيم (Adjudication & Verdict)
- **القرار:** **قبول طعن الخصوم الأربعة بالإجماع وإدانة هذا المنطق البرمجي.**
- **التصنيف:** `CRITICAL` 🔴
- **سبب الإدانة:**
  1. خرق صريح لقاعدة التحقق المسبق (0-Network Pre-flight).
  2. إرسال حزمة شبكية بحقول ملفقة (`[{"id": 401, "num": 1}]`) عند انعدام الجنود في الذاكرة.
  3. تعريض حساب القلعة لمخاطر الرصد والحظر الآلي.
- **التوصية البرمجية الإلزامية:**
  - تعديل `_get_minimal_soldiers` لتعيد قائمة فارغة `[]` عند عدم توفر أي جنود في `battleData` و `armyCtrl`.
  - في دالة `run()`، قبل استدعاء `safe_query`، يجب إضافة فحص مانع حاسم:
    ```python
    if not dispatch_soldiers:
        self.log("0-Network Pre-flight: No soldiers available in castle or trial. Aborting attack safely.")
        return TaskResult.skip("No soldiers available for attack", exec_time=time.time() - start_time)
    ```
