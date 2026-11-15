# ⚖️ سجل السجال التحكيمي: ادعاء رقم 002 (Debate Claim 002)
### الملف المستهدف: `tasks/hero_trial.py`
### الموضوع: التحديث المحلي الكاذب لإنجاز المهمة (Phantom In-Memory Sync) عند فشل الهجوم
### تاريخ السجال: 2026-11-15
### مستوى الخطورة المحسوم: `HIGH` 🟠 (تضليل الذاكرة وكسر تكامل المهام المتقاطعة)

---

## 1. بطاقة الادعاء الأصلي (The Original Claim)
- **موقع الكود:** `tasks/hero_trial.py#L225-L237` و `tasks/hero_trial.py#L267-L285`
- **نص الكود المعني:**
  ```python
  # tasks/hero_trial.py#L225-L237
  elif err == ERR_HT_HAVE_NOT_SOLDIERS or err == ERR_HT_SOLDIER_NOT_ENOUGH:
      self.log(f"Not enough soldiers for trial battle (err={err}).")
      self._sync_task_completion_in_memory(point_data, ht_point)
      return TaskResult.ok("Opened trial (insufficient troops for attack)", exec_time=time.time() - start_time)
  else:
      self.log(f"Attack stage returned err={err}.")
      self._sync_task_completion_in_memory(point_data, ht_point)
      return TaskResult.ok(f"Trial processed (attack returned {err})", exec_time=time.time() - start_time)
  ```
  ودالة المزامنة:
  ```python
  # tasks/hero_trial.py#L271-L276
  everyday_ctrl = init_data.setdefault("everydayTaskCtrl", {})
  event_info = everyday_ctrl.setdefault("eventInfo", {})
  event_info[DAILY_QUEST_HERO_TRIAL_TYPE] = 1
  ```
- **سياق التنفيذ:** عند فشل الهجوم على مرحلة كفاءة الجندي، سواء بسبب خطأ جنود (`35004`, `35010`) أو أي خطأ غير متوقع (`err != "0"`):
  1. يقوم الكود بتسجيل `TaskResult.ok()`.
  2. يستدعي `_sync_task_completion_in_memory` التي تضع `eventInfo["25"] = 1`.
- **الادعاء:** يزعم الكود أن مجرد فتح التحدي أو محاولة الهجوم يكفي لاعتبار المهمة منجزة وتعديل الذاكرة لمنع إعادة التنفيذ.

---

## 2. مرافعة المحلل الأساسي ومحلل الذاكرة
- المتغير `eventInfo["25"]` في الذاكرة يمثل عداد إنجاز مهمة النشاط اليومي رقم 25 (المشاركة في كفاءة الجندي).
- جدول مهام النشاط اليومي الرسمي `new_quest_config.lua` يمنح 20 نقطة نشاط فقط عند **تسجيل مشاركة فعلية** في المعركة عبر الخادم.
- عند إرجاع السيرفر لخطأ `35004`، فإن السيرفر لم يخصم جولة، ولم يفتح معركة، ولم يمنح نقاط النشاط.
- قيام البوت بوضع `eventInfo["25"] = 1` محلياً هو تزوير لحالة الذاكرة الحقيقية (`Phantom Sync`).

---

## 3. هجمات ومرافعات الخصوم الأربعة (The 4 Adversarial Defenses & Attacks)

### ⚔️ مرافعة الخصم المنطقي (Logic Challenger)
- **موقف الخصم:** إدانة قاطعة للمنطق السببي.
- **البرهان:**
  - الدالة تسمى `TaskResult.ok()` وتكتب في السجل `Completed` بينما العملية البرمجية المطلوبة فشلت ولم تتم.
  - هذا انتهاك لمفهوم النجاح البرمجي؛ الفشل لا يجوز تحت أي ظرف أن يعامل كنجاح.
  - إذا تعذر الهجوم بسبب انعدام الجنود، فالنتيجة المنطقية الصحيحة هي `TaskResult.fail("Attack rejected by server: err=" + err)` أو `TaskResult.skip()`، مع الامتناع المطلق عن تعديل عداد الإنجاز.

### ⚔️ مرافعة خصم كود اللعبة المصدري (Source Code Challenger)
- **موقف الخصم:** إثبات سلوك اللعبة الرسمي من سورس كود المتحكم.
- **الدليل من سورس اللعبة:**
  - في `game_file/src/app/module/heroTrial/heroTrialCtrl.lua#L193-L203`:
    ```lua
    elseif "march" == notifyType then
        ...
        htBattleMgr.generalTrial(stageID, soldiers, bTime, marchTime)
        stageID.msg = "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE"
    ```
  - العميل الرسمي للعبة لا يغير حالة المعركة ولا يحدث المهام إلا عند استلام إشعار بدء المعركة الفعلي `MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE` الصادر من السيرفر.
  - عند حدوث خطأ في الطلب، لا يطرأ أي تحديث على عدادات النشاط اليومي في العميل.

### ⚔️ مرافعة خصم الذاكرة الحية (Memory Challenger)
- **موقف الخصم:** إثبات حدوث تلوث للذاكرة الحية (Memory Corruption / Desync).
- **البرهان:**
  - تعديل `event_info[DAILY_QUEST_HERO_TRIAL_TYPE] = 1` محلياً ينتج حالة ذاكرة تالفة ومخالفة للواقع (`Invalid State`).
  - في الدورة التالية للبوت، عندما يفحص الفحص المسبق `quest_done_count >= 1` في السطر 83، سيجد القيمة `1` التي زورها الكود بنفسه سابقاً، فيتخطى المهمة متوهماً أنها منجزة!
  - القلعة لن تعاود المحاولة حتى إعادة تشغيل البوت وإعادة تسجيل الدخول، مما يحرم الحساب من 20 نقطة نشاط يومية يومياً.

### ⚔️ مرافعة الخصم الشبكي والاعتماديات (Network & Dependency Challenger)
- **موقف الخصم:** **إثبات خطأ عابر للملفات (Cross-Task Cascading Failure)**.
- **البرهان:**
  - في جدول مهام البوت المسجلة `REGISTERED_TASKS` في `bot_manager.py#L90-L91`:
    المهمة التالية مباشرة بعد `hero_trial.py` هي `daily_quest.py` (DailyQuestTask).
  - مهمة `daily_quest.py` تعتمد كلياً على فحص مجموع نقاط `everydayTaskCtrl.eventInfo` للمطالبة بصناديق الجوائز اليومية (100، 200، 300، 400، 500 نقطة).
  - عندما تحسب `daily_quest.py` أن النقاط وصلت إلى عتبة صندوق الجائزة (مثلاً 500 نقطة) اعتماداً على الـ 20 نقطة الوهمية لكفاءة الجندي، فإنها ترسل حزمة استلام الجائزة `safe_query(CMD_DAILY_QUEST, REQ_CLAIM_BOX, ...)`.
  - سيرفر اللعبة يرفض طلب استلام الصندوق لأن النقاط الفعلية لديه لم تصل للعتبة، مما يتسبب في فشل مهمة المهام اليومية وإثارة الشبهات الشبكية.

---

## 4. حكم المنسق النهائي وقرار التحكيم (Adjudication & Verdict)
- **القرار:** **قبول طعن الخصوم وإدانة المزامنة الوهمية.**
- **التصنيف:** `HIGH` 🟠
- **سبب الإدانة:**
  1. تحديث الذاكرة الحية محلياً بقيمة كاذبة عند فشل الطلب الشبكي.
  2. التسبب في فشل تسلسلي عابر للملفات يؤثر على مهمة `daily_quest.py`.
  3. حرمان القلعة من إعادة محاولة إنجاز المهمة عند توفر جنود لاحقاً.
- **التوصية البرمجية الإلزامية:**
  - حصر استدعاء `_sync_task_completion_in_memory` داخل مسارات النجاح المؤكدة فقط (`err in ("0", ERR_HT_IN_MARCH)`).
  - عند استقبال `ERR_HT_HAVE_NOT_SOLDIERS` أو أي خطأ آخر، الامتناع التام عن تعديل `eventInfo["25"]`، وإرجاع `TaskResult.fail()` أو `TaskResult.skip()` ببيان واضح لسبب الفشل الحقيقي.
