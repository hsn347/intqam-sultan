# تقرير التشخيص الجنائي الفني الشامل — لغز فشل استلام صناديق النشاط اليومي (رمز الخطأ: 0)

**تاريخ التقرير:** 2026-11-01  
**المحقق الجنائي:** Explorer 1 (Diagnostic Investigation Swarm)  
**حالة التحقيق:** مكتمل 100% — تشخيص جنائي قطعي وموثق بالأدلة البرمجية (Read-Only Mode)  
**الملف المستهدف:** `tasks/daily_quest.py`  

---

## 1. الملاحظات المباشرة (Direct Forensic Observations)

### 1.1 موقع العطب البرمجي في `tasks/daily_quest.py`
في الملف `tasks/daily_quest.py` بالأسطر **201 إلى 220**:

```python
201:             # إرسال حزمة الاستلام الرسمية (CMD 2027 / SUBCMD 2)
202:             res = await self.safe_query(
203:                 CMD_EVERYDAY_TASK_MODULE,
204:                 REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
205:                 {"index": index},
206:                 min_delay=0.6,
207:                 max_delay=1.2,
208:             )
209: 
210:             # فحص الاستجابة وتحديث الذاكرة الحية فورياً
211:             if res and res.get("err") in (None, 0):
212:                 claimed_count += 1
213:                 claimed_indices.append(index)
214:                 normal_record[str(index)] = 1
215:                 everyday_ctrl["normalRecord"] = normal_record
216:                 self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
217:             else:
218:                 err_code = res.get("err") if res else "NoResponse"
219:                 self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")
```

### 1.2 بنية استجابة سيرفر اللعبة الرسمي (Official Server Protocol Evidence)
1. **في كود اللعبة الرسمي العميل (`game_file/src/app/constdef/errDef.lua`):**
   - السطر 2:
     ```lua
     ;(nil).Err_None = "0"
     ```
   - السطور 959-966:
     ```lua
     ;(nil).Err_EVERYDAY_TASK_INDEX_ILLEGAL = "470001"
     ;(nil).Err_EVERYDAY_TASK_POINT_NOT_ENOUGH = "470002"
     ;(nil).Err_EVERYDAY_TASK_ALREADY_RECEIVE = "470003"
     ```
   - **الملاحظة الحاسمة:** جميع رموز الأخطاء والنجاح في بروتوكول اللعبة هي سلاسل نصية (`str` / `"0"`) وليست أرقاماً صحيحة (`int` / `0`).

2. **في متحكم اللعبة الرسمي (`game_file/src/app/module/everydayTask/everydayTaskCtrl.lua`):**
   - الأسطر 134-138 و 164-168:
     ```lua
     function everydayTaskCtrl:sendReceiveNormalMsg(index)
         data.index = index
         serverproxy:Request(gCmd.CMD_EVERYDAY_TASK_MODULE, gCmd.REQ_EVERYDAY_TASK_RECEIVE_NORMAL, data)
     end
     
     function everydayTaskCtrl:everydayTaskReceiveNormalResp(ret)
         if ret.err == gErrDef.Err_None then
             if ret.data and ret.data.normalRecord then
                 self.normalRecord = ret.data.normalRecord
             ...
     ```
   - الحزمة تُرسل بالرمزين: `CMD_EVERYDAY_TASK_MODULE = "2027"`, `REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"` مع الحمولة `{"index": index}`.
   - استجابة السيرفر تحتوي على الحقل `err` وتفحص نجاحها بمطابقة `ret.err == "0"`.

3. **في سجلات الالتقاط الحية الرسمية (`sctipt_test/sniffer_log.txt`):**
   - السطر 22 والسطر 105:
     ```json
     {
       "source": "c",
       "err": "0",
       "subcmd": "2",
       "cmd": "1005",
       ...
     }
     ```
   - الاستجابة القادمة عبر بوابة اللعبة ومحللة بـ `decode_gate_packet()` تُعيد قاموس بايثون يحتوي على `"err": "0"` من النوع `str`.

4. **إعادة الإنتاج الميدانية التامة للخطأ برمجياً:**
   عند اختبار `DailyQuestTask` بمحاكي يُعيد استجابة السيرفر الحقيقية `{"err": "0", "data": {}}` تم تسجيل الناتج التالي بالحرف:
   ```text
   [daily_quest] 🎁 [صناديق النشاط] تم رصد 1 صندوق جاهز للاستلام (النقاط: 30/500 | الصناديق: [1]).
   [daily_quest] 📦 [صناديق النشاط] جاري استلام الصندوق 1 (30 نقطة)...
   [daily_quest] ⚠️ [صناديق النشاط] تعذر استلام الصندوق 1 (رمز الخطأ: 0).
   RESULT: <TaskResult [FAILED]: فشل استلام الصناديق الجاهزة [1].>
   ```

---

## 2. سلسلة الاستدلال المنطقي (Logic Chain)

1. **الخطوة 1: فحص حزمة الطلب والاستجابة لـ CMD 2027 SUBCMD 2**
   - الأمر المرسل: `CMD 2027` (وحدة المهام اليومية) / `SUBCMD 2` (استلام الصندوق المجاني) بالحمولة `{"index": index}` صحيح تماماً ومطابق 100% لدالة `everydayTaskCtrl:sendReceiveNormalMsg(index)`.
   - ترقيم الصناديق من 1 إلى 8 ومطابق لمصفوفة `CHEST_MILESTONES`.
   - السيرفر الرسمي يستلم الطلب بنجاح، ويمنح المكافأة للاعب، ويُعيد حزمة رد تحوي:
     `{"cmd": "2027", "subcmd": "2", "err": "0", "data": {"normalRecord": {"1": 1}, "reward": [...]}}`.

2. **الخطوة 2: فحص حقول الاستجابة (code vs error vs err)**
   - هل استجابة السيرفر تحتوي على حقل `code` أو `error`؟ **لا مطلقاً**.
   - بروتوكول لعبة انتقام السلاطين بأكمله يعتمد حصرياً على مفتاح `"err"` (مختصر Error Code) الموثق في `errDef.lua` ومحرك `game_client.py`.
   - كود `tasks/daily_quest.py` استعلم بالفعل عن `res.get("err")` ولم يستعلم عن `code` أو `error`.

3. **الخطوة 3: كشف الخلل النوعي الحاسم (Type Mismatch Bug)**
   - في السطر 211 من `tasks/daily_quest.py`:
     ```python
     if res and res.get("err") in (None, 0):
     ```
   - القيمة المعادة من السيرفر هي: `res.get("err") == "0"` (من النوع النصي `str`).
   - المجموعة التي تم الفحص مقابلها هي التوبل: `(None, 0)` التي تضم الكائن `None` والعدد الصحيح `0` (`int`).
   - في بايثون 3:
     - `"0" == None` تُعطي `False`.
     - `"0" == 0` تُعطي `False` (بسبب اختلاف النوع بين `str` و `int`).
     - بالتالي فإن: `"0" in (None, 0)` تُعطي قطيعاً **`False`**.

4. **الخطوة 4: مسار التنفيذ الذي يقود إلى رسالة الخطأ الظاهرة للمستخدم**
   - لما كان الشرط في السطر 211 غير متحقق (`False`)، تجاوز المفسر كتلة النجاح (الأسطر 212-216) وانتقل مباشرة إلى كتلة `else` في السطر 217.
   - في السطر 218: `err_code = res.get("err") if res else "NoResponse"` فقيمة `err_code` هي السلسلة النصية `"0"`.
   - في السطر 219: يتم تسجيل الرسالة:
     `self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")`
     فتظهر في لوحة التحكم وسجلات البوت:
     `"⚠️ [صناديق النشاط] تعذر استلام الصندوق 1 (رمز الخطأ: 0)."`
   - في السطر 227: لما ظل `claimed_count == 0`، تُنهي الدالة تقريرها بـ `TaskResult.fail()`.

5. **الخطوة 5: لماذا لم تكتشف الاختبارات الآلية السابقة (`tools/test_*.py`) هذا الخلل؟**
   - بالرجوع إلى ملف `tools/test_daily_quest_task.py` (السطر 67 والسطر 210) وملف `tools/test_adversarial_daily_quest.py` (السطور 73, 190, 213, 247, 352):
     كافة محاكيات الاتصال الوهمية (`MockGameConnection`) كتبت استجابة السيرفر الوهمية كعدد صحيح:
     `return {"err": 0, "data": {}}`  <-- `0` عدد صحيح `int`!
   - وبسبب هذا التزييف، كان التعبير `0 in (None, 0)` يُعطي `True` أثناء تشغيل الاختبارات الآلية، مما أعطى انطباعاً خادعاً بنجاح الاختبارات، بينما فشلت فور ملامسة السيرفر الحقيقي الذي يُرجع `"0"` كنص.

---

## 3. المقارنة المعيارية عبر كامل مهام البوت (Cross-Task Architectural Comparison)

يوضح الجدول التالي كيف تعالج سائر مهام المشروع فحص رمز الاستجابة `err`:

| اسم المهمة | مسار الملف والسطر | كود فحص الاستجابة المعتمد | مطابقة نوع البيانات |
| :--- | :--- | :--- | :--- |
| **مهام التحالف** | `tasks/alliance.py:278` | `if r_rcv and str(r_rcv.get("err", "")) in ("0", 0):` | تدعم `str` و `int` معاً بتحويل `str(...)` |
| **مباني القلعة** | `tasks/building.py:799` | `str(resp.get("err", "-1")) == "0"` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **حصاد الموارد** | `tasks/city_harvest.py:137` | `if r and str(r.get("err", "-1")) == "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **علاج المصابين** | `tasks/cure_wounded.py:345` | `err_code = _safe_int(err, -1); if err_code != 0:` | تحويل آمن إلى عدد صحيح وتجاوز الصفر |
| **استكشاف الهرم** | `tasks/imperial_mausoleum.py:142` | `if resp_claim and str(resp_claim.get("err", "-1")) == "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **سفينة الميناء** | `tasks/port.py:47` | `if not r or str(r.get("err", "-1")) != "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **السفينة التجارية**| `tasks/merchant_ship.py:49` | `if not r or str(r.get("err", "-1")) != "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **الحيوان الأليف** | `tasks/pet.py:251` | `if res and str(res.get("err", "-1")) == "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **أوسمة الحرب** | `tasks/war_medal.py:74` | `if not r or str(r.get("err", "0")) != "0":` | تحويل صريح إلى نص ومقارنة مع `"0"` |
| **صناديق النشاط (المعطوبة)** | `tasks/daily_quest.py:211` | `if res and res.get("err") in (None, 0):` | **شذوذ معماري**: فحص `int` و `None` وإغفال `str` |

**الخلاصة المعيارية:** كافة المهام المستقرة في المشروع تعتمد أسلوب التحويل الصريح للنص `str(res.get("err", "-1")) == "0"` أو مطابقة المجموعة الثنائية `in ("0", 0)`. انفردت `tasks/daily_quest.py` بفحص `(None, 0)` المجرد دون تحويل، وهو المتسبب الحصري في هذا الخطأ.

---

## 4. التحفظات والحدود (Caveats)

1. **الالتزام الصارم بوضع القراءة الصرفة (Read-Only Mode):**
   لم يتم إجراء أي تعديل، أو حفظ، أو حذف لأي ملف برمجي في المشروع تنفيذاً لتوجيه المطور والمهمة المرسلة.
2. **سلوك السيرفر في الحسابات الميدانية:**
   نظراً لأن السيرفر كان يستلم طلب الاستلام بنجاح وينفذه قبل أن تسجل المهمة فشلها محلياً، فإن السيرفر قد يُرجع رمز الخطأ `"470003"` (`Err_EVERYDAY_TASK_ALREADY_RECEIVE`) في الدورة التالية للصناديق التي فُتحت بالفعل ولم تُحدّث محلياً في `normalRecord`. لذلك فإن معالجة الاستجابة يجب أن تقبل أيضاً تحديث الذاكرة الحية في حال ورد الرمز `470003` أو مزامنة `normalRecord` عبر الاستعلام الاحتياطي.

---

## 5. الاستنتاج النهائي والحل المقترح (Conclusion & Recommended Solution)

### 5.1 الاستنتاج
1. الحزمة المرسلة `CMD 2027 / SUBCMD 2` بالحمولة `{"index": index}` **صحيحة ورسمية 100%**.
2. حقل الاستجابة هو `"err"` وقيمته الناجحة من سيرفر اللعبة الرسمي هي السلسلة النصية `"0"`.
3. رمز الخطأ `(رمز الخطأ: 0)` ليس فشلاً من السيرفر، بل هو **نجاح تام (Success / Err_None)** أخطأ كود بايثون في التعرف عليه بسبب فحص `res.get("err") in (None, 0)` الذي رفض السلسلة النصية `"0"`.

### 5.2 الحل البرمجي الموصى به للمنفذ اللاحق (Code Proposal)
في الملف `tasks/daily_quest.py` بالسطر **211**:

**الكود الحالي (المعطوب):**
```python
if res and res.get("err") in (None, 0):
```

**الكود المقترح المطابق لمعايير المشروع:**
```python
if res and str(res.get("err", "-1")) in ("0", "None", "") or res.get("err") in (0, None):
```
أو بالصيغة المعيارية الأكثر بساطة المعتمدة في `building.py` و `pet.py`:
```python
if res and str(res.get("err", "-1")) == "0":
```
مع دعم التعامل المرن إذا كان الصندوق مستلماً مسبقاً على السيرفر (`"470003"`):
```python
err_val = str(res.get("err", "-1")) if res else "-1"
if res and err_val in ("0", "470003"):
    claimed_count += 1
    claimed_indices.append(index)
    normal_record[str(index)] = 1
    everyday_ctrl["normalRecord"] = normal_record
    if err_val == "0":
        self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")
    else:
        self.log(f"ℹ️ [صناديق النشاط] الصندوق {index} مستلم مسبقاً على السيرفر — تم تحديث الذاكرة.")
```

---

## 6. طريقة التحقق المستقلة (Verification Method)

يمكن لأي مدقق أو وكيل مستقل التحقق من هذا التشخيص عبر الخطوات التالية:

1. **التحقق من تعريف الخطأ في كود اللعبة:**
   معاينة السطر 2 في `game_file/src/app/constdef/errDef.lua`:
   ```bash
   python -c "with open('game_file/src/app/constdef/errDef.lua', 'r', encoding='utf-8') as f: print([line for line in f if 'Err_None' in line][0])"
   ```
   النتيجة المتوقعة: `;(nil).Err_None = "0"`

2. **التحقق من فشل الشرط الحالي في بايثون:**
   ```bash
   python -c "res = {'err': '0'}; print('Evaluation with current code:', res.get('err') in (None, 0))"
   ```
   النتيجة المتوقعة: `Evaluation with current code: False`

3. **التحقق من نجاح الشرط المقترح:**
   ```bash
   python -c "res = {'err': '0'}; print('Evaluation with standard fix:', str(res.get('err', '-1')) == '0')"
   ```
   النتيجة المتوقعة: `Evaluation with standard fix: True`

4. **تشغيل المحاكاة الميدانية الكاملة لمهمة `DailyQuestTask`:**
   ```bash
   python -c "import asyncio; from tasks.daily_quest import DailyQuestTask; from tools.test_daily_quest_task import MockGameConnection; conn = MockGameConnection({'everydayTaskCtrl': {'eventInfo': {'7': 1}, 'normalRecord': {}}}); conn.query_responses['2027_2'] = {'err': '0', 'data': {}}; task = DailyQuestTask(conn=conn, log_func=print); res = asyncio.run(task.run()); print('RESULT:', res)"
   ```
   النتيجة المتوقعة: ظهور رسالة الخطأ بالحرف `[daily_quest] ⚠️ [صناديق النشاط] تعذر استلام الصندوق 1 (رمز الخطأ: 0).` وفشل المهمة تماماً.
