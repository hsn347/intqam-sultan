# تقرير التحقيق الجنائي الشامل — مهمة استلام صناديق النشاط اليومي (DailyQuestTask)
**Forensic Investigation Report: Daily Activity Chest Claim & Server Protocol Diagnosis**
**المحقق**: Explorer 3 (Investigation Swarm)  
**تاريخ التحقيق**: 2026-11-01  
**مسار العمل**: `e:\intqam-sultan\.agents\teamwork\teamwork_explorer_3`  
**طبيعة المهمة**: تشخيص جنائي صرف 100% Read-Only دون إجراء أي تعديل على كود المشروع.

---

## 1. الملاحظات الميدانية المباشرة (Observation)

### أ. كود فحص الاستجابة وتسجيل الخطأ في `tasks/daily_quest.py`
في الملف `tasks/daily_quest.py` الأسطر 201 إلى 220:
```python
# إرسال حزمة الاستلام الرسمية (CMD 2027 / SUBCMD 2)
res = await self.safe_query(
    CMD_EVERYDAY_TASK_MODULE,
    REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
    {"index": index},
    min_delay=0.6,
    max_delay=1.2,
)

# فحص الاستجابة وتحديث الذاكرة الحية فورياً
if res and res.get("err") in (None, 0):
    claimed_count += 1
    claimed_indices.append(index)
    normal_record[str(index)] = 1
    everyday_ctrl["normalRecord"] = normal_record
    self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
else:
    err_code = res.get("err") if res else "NoResponse"
    self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")
```

### ب. هيكل حزم استجابة سيرفر اللعبة الفعلي (Live Captured Packets)
في ملف التقاط الحزم الحية `sctipt_test/sniffer_log.txt` (الأسطر 20-25 و 100-108):
```json
========================================================
  <<< #1 session=496 cmd=1005 subcmd=2 [RECV]
========================================================
{
  "source": "c",
  "err": "0",
  "subcmd": "2",
  "cmd": "1005",
  "data": { ... },
  "pid": 32202050
}
```
**الملاحظة الحرفية**: حقل الخطأ الذي يعيده خادم اللعبة الرسمي هو `"err": "0"` كقيمة **نصية (String)** وليس عدداً صحيحاً (Integer `0`).

### ج. تعريف رمز النجاح في ملفات العميل الأصلية للعبة
في الملف المصدر `game_file/src/app/constdef/errDef.lua` (السطر 2):
```lua
_ENV = nil
;(nil).Err_None = "0"
```
وفي `game_file/src/app/module/everydayTask/everydayTaskCtrl.lua` (الأسطر 164-182):
```lua
function everydayTaskCtrl:everydayTaskReceiveNormalResp(ret)
    local _ENV, rewardList
    if ret.err == gErrDef.Err_None then
        if ret.data and ret.data.normalRecord then
            self.normalRecord = ret.data.normalRecord
            if ret.data.reward then
                for key, value in pairs(ret.data.reward) do
                    rewardList[value.itemid] = value.count
                end
            end
            SoraDMailGainItems(rewardList)
        end
    elseif ret.err == gErrDef.Err_EVERYDAY_TASK_INDEX_ILLEGAL then
        ...
```
رمز النجاح الرسمي في لعبة انتقام السلاطين هو النص `"0"` (`Err_None = "0"`).

### د. كيفية تمثيل المهام وصناديق النشاط في الذاكرة الحية `conn.init_data`
عند فحص ملفات تفريغ الذاكرة الحية الحقيقية:
- `docs/sample_live_memory.json` (الأسطر 18681-18751)
- `docs/beetoo1_live_memory.json` (الأسطر 2815-2875)
- `docs/beetoo3_live_memory.json` (الأسطر 2755-2810)
- `docs/lucifer_live_memory.json` (الأسطر 18913-18977)

تبين ما يلي:
1. **لا وجود لأي متحكم أو مصفوفة باسم `activity_box` أو `daily_quest` أو `box_info`**.
2. المتحكم الوحيد والمسؤول حصراً عن النشاط اليومي وصناديقه هو: **`everydayTaskCtrl`**.
3. يحتوي `everydayTaskCtrl` على الحقول التالية فقط:
   - `tomorrowZeroUTC`: طابع زمني (Timestamp) لوقت منتصف الليل بتوقيت UTC لتجدد اليوم.
   - `serverLv`: مستوى/طور السيرفر.
   - `eventInfo`: قاموس يحتوي على تكرارات إنجاز كل مهمة من المهام الـ 33 `{str(task_type): count}`.
   - `normalRecord`: قاموس يحتوي على فهارس الصناديق العادية المستلمة اليوم `{str(index): 1}`.
   - `chestReward`: الصناديق الكنز الأربعة الإضافية (عتبات 100، 200، 300، 400).
   - `chestRecord`: سجل الصناديق الكنز المستلمة.

### هـ. ترقيم وفهارس الصناديق (Chest Indices)
في الملفات:
- `game_file/src/fgui/views/QuestView/questViewPanel.lua` (الأسطر 256-265):
  ```lua
  self.boxArray, everydayTaskCtrl, self.goalArray = everydayTaskCtrl:getGoalArray(), everydayTaskCtrl:getGoalArray(), everydayTaskCtrl:getGoalArray()
  for i, v in ipairs(self.goalArray) do
      local isReceived = everydayTaskCtrl:isReceiveNormalReward(i)
      ...
      box.index = i
      ...
  ```
- `game_file/src/fgui/gcomponent/QuestView/Com_box2.lua` (السطر 24):
  ```lua
  everydayTaskCtrl:sendReceiveNormalMsg(self.data.index)
  ```
- `game_file/src/app/localtb/config_server/daily_reward_point_items.lua`:
  عتبات النقاط الثمانية هي: `[30, 70, 120, 180, 260, 340, 420, 500]`.

**الملاحظة الحرفية**:
- الترقيم الرسمي في بروتوكول اللعبة يبدأ من **1 إلى 8** (`1-based indexing`) عبر `index` صحيح (`index: 1`, `index: 2`, ... `index: 8`).
- ليس ترقيماً صفرياً (`0..7` أو `0..5`).
- لا يتم استخدام معرفات العناصر (Item IDs) أو أرقام النقاط (30, 70) في حقل الطلب؛ بل الفهرس الترتيبي فقط: `{"index": 1}` إلى `{"index": 8}`.

### و. سبب اجتياز اختبارات المحاكاة في مجلد `tools/`
في `tools/test_daily_quest_task.py` (السطر 67) و `tools/test_adversarial_daily_quest.py` (السطر 73):
```python
# Default success in mock
return {"err": 0, "data": {}}
```
محاكي الاختبار MockGameConnection قام بمحاكاة الرد بقيمة عددية صحيحة `0` (`int`) وليس نصية `"0"` (`str`)، مما جعل الشرط الخاطئ يمر أثناء الفحص الاصطناعي ويفشل حصراً أمام السيرفر الحقيقي.

---

## 2. سلسلة الاستدلال المنطقي (Logic Chain)

1. **الاستدلال 1 (سلوك لغة بايثون في المقارنة)**:
   - الكود في `tasks/daily_quest.py:211` يتحقق من:
     `if res and res.get("err") in (None, 0):`
   - عندما يستجيب سيرفر اللعبة الحقيقي بحزمة النجاح، فإنه يعيد:
     `res = {"cmd": "2027", "subcmd": "2", "err": "0", "data": {...}}`
   - استدعاء `res.get("err")` يعيد النص `"0"` (`type: str`).
   - في بايثون:
     `"0" in (None, 0)` يعيد **`False`** حتماً، لأن `"0" == 0` تعيد `False` لاختلاف النوعين (`str` مقابل `int`).

2. **الاستدلال 2 (توليد رسالة الخطأ الظاهرة للمطور)**:
   - عند فشل شرط `if` (بسبب إرجاع `False`)، ينتقل التنفيذ حتماً إلى فرع `else` (السطور 218-219):
     ```python
     err_code = res.get("err") if res else "NoResponse"
     self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")
     ```
   - بما أن قيمة `err_code` هي `"0"`، فإن نص السجل يُطبع حرفياً كالتالي:
     `⚠️ [صناديق النشاط] تعذر استلام الصندوق 1 (رمز الخطأ: 0).`
   - هذا يفسر بدقة رياضية وتجريبية سبب ظهور رسالة "رمز الخطأ: 0".

3. **الاستدلال 3 (منح السيرفر للجوائز والإنذار الكاذب من البوت)**:
   - وفقاً لـ `errDef.lua:2` و `everydayTaskCtrl.lua:166`، فإن رمز `"0"` هو المعرف الحصري لـ `Err_None` (النجاح التام للعملية).
   - خادم اللعبة **قام فعلياً بصرف مكافآت الصندوق للحساب** وسجل الصندوق كمستلم في قاعدة بيانات اللعبة الرسمية.
   - البوت هو من قام بإنذار كاذب (False Negative)؛ حيث اعتبر الاستجابة الناجحة فشلاً، وامتنع عن إضافة الفهرس إلى `normalRecord` المحلي، وسجل الدورة بالكامل كـ `TaskResult.fail()`.

4. **الاستدلال 4 (مقارنة المهام الأخرى في نفس المشروع)**:
   - كافة المهام المستقرة في المشروع تعاملت مع `err` بالتحويل الصريح إلى نص:
     - `tasks/pet.py:251`: `str(res.get("err", "-1")) == "0"`
     - `tasks/material_synthesis.py:205`: `str(res.get("err", "-1")) != "0"`
     - `tasks/port.py:47`: `str(r.get("err", "-1")) != "0"`
     - `tasks/wonder_merchant.py:142`: `str(res.get("err", "-1")) != "0"`
     - `tools/refresh_live_memory.py:286`: `str(res_treasure.get("err", "")) in ("0", 0)`
   - المهمة `daily_quest.py` كانت الاستثناء الوحيد الذي حصر المقارنة في `(None, 0)` دون شمول النص `"0"`.

---

## 3. التحفظات والحدود (Caveats)

1. **حالة الصناديق المستلمة مسبقاً (`Err_EVERYDAY_TASK_ALREADY_RECEIVE`)**:
   - إذا تم استلام الصندوق مسبقاً في نفس اليوم من تطبيق الهاتف الرسمي، فإن السيرفر يعيد رمز الخطأ `"470003"`.
   - الكود الحالي في `tasks/daily_quest.py` يعتبر هذا الخطأ فشلاً ويسجله كخطأ، بينما السلوك البشري الأمثل هو معاملته كصندوق مستلم مسبقاً وتحديث `normal_record[str(index)] = 1` لتفادي محاولة طلبه مجدداً.
2. **استجابة بوابة الـ HTTP مقابل مقبس اللعبة TCP**:
   - مصادقة الدخول عبر HTTP (`onemt_auth.py`) تعيد حقل `"code": 0`، بينما مقبس اللعبة المباشر TCP (`core/game_client.py`) يعيد حقل `"err": "0"`. المعالجة المثلى يجب أن تدعم كلا الاسمين `err` و `code` وكلا النوعين `int` و `str` لضمان المناعة المطلقة.
3. **لا تحفظات أخرى بخصوص هيكل الذاكرة والبروتوكول**؛ فقد تم فحص كود اللعبة المصدري بالكامل وملفات الذاكرة الحية المأخوذة من سيرفر اللعبة الفعلي.

---

## 4. الاستنتاج النهائي والحل المقترح (Conclusion & Proposed Solution)

### الخلاصة القطعية
1. **السبب الجذري**: خطأ فحص نوعي (Type Mismatch) في السطر 211 من `tasks/daily_quest.py`، حيث يفحص الشرط `res.get("err") in (None, 0)` بينما السيرفر يعيد نصاً `"0"`.
2. **معنى الرمز 0**: الرمز `"0"` يعني **النجاح التام (Success / Err_None)**. السيرفر قام فعلياً بمنح الصناديق ولم يفشل.
3. **ترقيم الصناديق**: الترقيم الرسمي للصناديق اليومية الثمانية هو من **1 إلى 8** (`index: 1` إلى `index: 8`)، وهو مطابق تماماً لما يرسله البوت حالياً ولا يحتاج إلى تغيير الفهارس.
4. **هيكل الذاكرة**: الصناديق لا تُخزن في `activity_box` ولا `quest`؛ بل حصراً في `conn.init_data["everydayTaskCtrl"]["normalRecord"]` كمفاتيح نصية `"1"`..`"8"`.

---

### الحل البرمجي الموصى به (Proposed Fix — For Implementer)

> **تنبيه التزام بالقيد الجنائي**: هذا التعديل موثق هنا لغرض التقرير فقط ولم يتم تطبيقه على الكود المصدري وفقاً لتوجيه "تشخيص فقط".

في الملف `tasks/daily_quest.py`، تعديل كتلة فحص الاستجابة (الأسطر 210 إلى 220):

```python
# ── قبل التعديل (الحالي) ──────────────────────────────────────────────────
            # فحص الاستجابة وتحديث الذاكرة الحية فورياً
            if res and res.get("err") in (None, 0):
                claimed_count += 1
                claimed_indices.append(index)
                normal_record[str(index)] = 1
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
            else:
                err_code = res.get("err") if res else "NoResponse"
                self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")

# ── بعد التعديل المقترح (الموصى به) ──────────────────────────────────────
            # فحص الاستجابة وتحديث الذاكرة الحية فورياً (يدعم "0" و 0 و None و كود 470003 للمستلم مسبقاً)
            err_raw = res.get("err") if res else (res.get("code") if res else None)
            err_str = str(err_raw).strip() if err_raw is not None else "0"

            if res and err_str in ("0", "None"):
                claimed_count += 1
                claimed_indices.append(index)
                normal_record[str(index)] = 1
                # مزامنة normalRecord المرتجع من السيرفر إن توفر
                if isinstance(res.get("data"), dict) and isinstance(res["data"].get("normalRecord"), dict):
                    normal_record.update(res["data"]["normalRecord"])
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
            elif err_str == "470003":
                # Err_EVERYDAY_TASK_ALREADY_RECEIVE: تم استلامه مسبقاً اليوم
                claimed_count += 1
                normal_record[str(index)] = 1
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"ℹ️ [صناديق النشاط] الصندوق {index} مستلم مسبقاً اليوم على السيرفر.")
            else:
                err_code = err_raw if res else "NoResponse"
                self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")
```

---

## 5. طريقة التحقق المستقل (Verification Method)

لإثبات هذا التشخيص والتحقق منه برمجياً بشكل مستقل:

1. **التحقق من عدم مساواة الأنواع في بايثون**:
   ```bash
   python -c "res = {'err': '0'}; print('Bug Reproduction:', res.get('err') in (None, 0)); print('Proposed Fix:', str(res.get('err')) in ('0', 'None'))"
   ```
   *النتيجة الحتمية*: `Bug Reproduction: False` | `Proposed Fix: True`.

2. **فحص حزم السيرفر الحقيقية الملتقطة**:
   معاينة الملف `sctipt_test/sniffer_log.txt` عند السطر 22 و 105 للتأكد من أن خادم اللعبة يرسل `"err": "0"`.

3. **فحص شجرة العمل ونظافة الكود**:
   التأكد من عدم وجود أي تعديل على ملفات المشروع وأن التقرير تم إيداعه حصراً في مجلد العمل المخصص للوكيل:
   `e:\intqam-sultan\.agents\teamwork\teamwork_explorer_3\handoff.md`
