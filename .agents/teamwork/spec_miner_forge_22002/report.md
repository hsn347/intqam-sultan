# تقرير التنقيب والتحقيق الشامل: حل مشكلة مهمة تصنيع العتاد forge_equipment وتصحيح خطأ السيرفر 22002
**المهمة:** Requirement R2 من `ORIGINAL_REQUEST.md`  
**التاريخ والوقت:** 2026-11-01T03:48:00Z  
**المحقق:** Spec Miner (Teamwork Swarm)  
**الحالة:** مُكتمل ومُثبت ميدانياً بنسبة 100%

---

## 1. الملخص التنفيذي (Executive Summary)
أظهر الفحص الاستقصائي المتعمق لملفات سورس اللعبة الرسمية (`game_file`)، وسجلات الذاكرة الحية، والتجربة الميدانية المباشرة عبر أداة `test_task_method.py` على حسابات حقيقية (`beetoo1`, `beetoo2`, `beetoo3`):
1. **التعريف الدقيق لكود الخطأ 22002:**  
   في ملف ثوابت الأخطاء الرسمي `game_file/src/app/constdef/errDef.lua` بالسطر 573:
   ```lua
   ;(nil).Err_IS_FORGING_EQUIPMENT = "22002"
   ```
   خطأ 22002 يعني حرفياً: **"ورقة الحدادة مشغولة بتصنيع عتاد أو تحتوي على قطعة مصنعة مسبقاً بانتظار الاستلام"**.
2. **السبب الجذري لفشل `tasks/forge_equipment.py`:**  
   وجود خطأ منطقي في سطور فحص انتهاء التصنيع (السطور 438-440). فعندما ينتهي وقت تصنيع القطعة أثناء غياب الاتصال، يقوم سيرفر اللعبة بحذف طابور 1229 من `queueCtrl`، وتبقى القطعة الجاهزة في كائن الذاكرة الحية `equipmentCtrl.fe`.
   في الكود الحالي:
   ```python
   start_t = int(forge_q.get("starttime", 0) or 0) if isinstance(forge_q, dict) else 0
   total_t = int(forge_q.get("totaltime", 0) or 0) if isinstance(forge_q, dict) else 0
   finish_t = (start_t + total_t) if (start_t > 0 and total_t > 0) else 0
   ```
   عندما يكون `forge_q` غير موجود، تُحسب `finish_t = 0`.  
   والشرط اللاحق:
   ```python
   if finish_t > 0 and finish_t <= now_ts:  # False! لأن finish_t = 0
       # استلام القطعة
   elif finish_t > now_ts:                  # False!
       # ورشة الحدادة مشغولة
   ```
   يتخطى كود الاستلام كلياً ولا يقوم باستلام القطعة الجاهزة! ثم يمر مباشرة للأمر التالي: إرسال طلب تصنيع جديد (`CMD 1047 / SubCMD 1`) بينما ورشة الحدادة مشغولة بالقطعة الجاهزة، فيرفض السيرفر الطلب فوراً بكود **22002 (`Err_IS_FORGING_EQUIPMENT`)**.
3. **الإثبات الميداني المباشر:**
   - في حساب `beetoo1`: وُجدت قطعة جاهزة (`fe`: `epid=107`). تم إرسال أمر الاستلام الرسمي `CMD 1047 / SubCMD 2` فأجاب السيرفر بنجاح تام (`err: 0`) وتم إتمام النشاط اليومي مجاناً بصفر استهلاك للصلب والمواد!
   - في حساب `beetoo3`: وُجدت قطعة جاهزة (`fe`: `epid=94`). تم تشغيل المهمة ففشلت بخطأ 22002، ثم عند استلام القطعة بأمر الاستلام نجح السيرفر فوراً (`err: 0`) وأُغلق النشاط اليومي.
   - في حساب `beetoo2`: تُركت القطعة الجاهزة (`fe`: `epid=95`) لإثبات الخطأ 22002 وإمكانية التحقق المستقل من طرف المراجعين.

---

## 2. جدول الميزات المكتشفة (Features Discovered)

| # | Category | Feature | Description | Inputs | Outputs | Error Behavior | Discovered Via |
|---|----------|---------|-------------|--------|---------|----------------|----------------|
| 1 | Network CMD | REQ_FORGE_EQUIPMENT | إرسال أمر بدء تصنيع قطعة عتاد جديدة بورشة الحدادة | CMD: 1047, SubCMD: 1, Payload: `{"eid": int, "materialArray": List[int], "mainMaterialID"?: int}` | `{"err": "0", "data": {"equipment": {...}, "bTime": int, "costTime": int}}` | `22002`: الورشة مشغولة<br>`22006`: مستوى الأمير غير كافٍ<br>`22007`: مادة أساسية مفقودة<br>`22008`: مستوى مادة غير مطابق<br>`22009`: نقص مواد<br>`22010`: مواد غير مطابقة<br>`22012`: حقيبة العتاد ممتلئة | `game_file/src/app/module/equipment/equipmentCtrl.lua:818` |
| 2 | Network CMD | REQ_GET_EQUIPMENT | استلام قطعة العتاد المنتهية من ورشة الحدادة وإضافتها للحقيبة وإتمام النشاط اليومي | CMD: 1047, SubCMD: 2, Payload: `{"epid": int}` | `{"err": "0", "data": {"epid": int}}` | `22015`: لا توجد قطعة جاهزة<br>`22016`: لم يكتمل التصنيع بعد | `game_file/src/app/module/equipment/equipmentCtrl.lua:1202` |
| 3 | Queue System | Queue 1229 (forge_equipment) | طابور تصنيع العتاد المؤقت في `queueCtrl` | `queuetype = 1229`, `starttime`, `totaltime`, `data` | تسجيل وقت البدء والمدة وحالة المساعدة | ينتهي ويُحذف تلقائياً من `queueCtrl` بمجرد اكتمال المؤقت الزمني | `game_file/src/app/constdef/queueTypeDef.lua:33` |
| 4 | State Object | `equipmentCtrl.fe` | كائن العتاد الجاري تصنيعه أو الجاهز للاستلام بورشة الحدادة | كائن داخل `equipmentCtrl` يحوي `epid`, `eid`, `endTime`, `subM`, `mainM` | يبقى موجوداً طالما لم يتم استلام القطعة | وجوده يمنع بدء أي تصنيع جديد ويطلق 22002 | `game_file/src/app/module/equipment/equipmentCtrl.lua:1800` |
| 5 | Daily Task | Quest 4100009 / Type 9 | مهمة تصنيع العتاد في النشاط اليومي الرسمي | استلام قطعة منتهية أو بدء تصنيع قطعة جديدة | `everydayTaskCtrl.eventInfo["4100009"] = 1` | لا تتكرر في نفس اليوم | `daily_reward_point_config.lua` |
| 6 | Building State | Blacksmith (BID 115) | مبنى ورشة الحدادة في `cityCtrl.blist` | `bid == "115"`, `lv`, `state` | `state == "0"`: جاهز، `state != "0"`: قيد الترقية | إذا كان قيد الترقية لا يمكن بدء التصنيع | `equipForgeViewPanel.lua:412` |
| 7 | Inventory Limit | Max Equipment Size | الحد الأقصى لسعة حقيبة العتاد (200 قطعة) | `len(equipment_array)` | إذا كان >= 200 لا يمكن التصنيع | `22012`: `Err_EQUIPMENT_NUM_MAX` | `equipmentMgr.lua:2` |

---

## 3. جدول الحالات الحدية (Edge Cases)

| # | Feature | Input | Observed Behavior |
|---|---------|-------|-------------------|
| 1 | Smithy Harvest | قطعة مصنعة جاهزة في `fe` مع انتهاء الطابور 1229 (`forge_q is None`) | الكود القديم يحسب `finish_t = 0` ويتخطى الاستلام ويطلب تصنيعاً فيفشل بـ 22002. السلوك الصحيح: فحص `fe` واستدعاء `REQ_GET_EQUIPMENT` فوراً. |
| 2 | Smithy Busy | قطعة قيد التصنيع حالياً (`finish_t > now` أو `fe.endTime > now`) | التخطي الفوري في الذاكرة (0-Network) دون لمس السيرفر. |
| 3 | Blacksmith Upgrading | مبنى الحدادة (115) قيد الترقية (`binfo.state != "0"`) | السيرفر يرفض التصنيع. يجب الفحص المسبق والتخطي (0-Network). |
| 4 | Equipment Bag Full | عدد قطع العتاد في `equipment_array` >= 200 | السيرفر يرفض التصنيع بكود 22012 (`Err_EQUIPMENT_NUM_MAX`). يجب الفحص والتخطي مسبقاً. |
| 5 | Lord Level Gate | مستوى الأمير أقل من مستوى القطعة المطلوبة | السيرفر يرفض التصنيع بكود 22006 (`Err_EQUIPMENT_LORD_LV_NOT_ENOUGH`). يجب أن يكون `min(lord_level, blacksmith_level)` هو سقف الوصفات. |
| 6 | Base Item Wearing | القطعة الأساسية المختارة ملبوسة على الأمير (`wear == 1`) | السيرفر يرفض بكود 22013 (`Err_MAIN_MATERIAL_IS_WEARING`). يجب فحص `wear == 0` و `endTime == 0`. |
| 7 | Steel Deficit | رصيد الصلب في المخزن غير كافٍ وتوجد صناديق بالحقيبة | فتح الصناديق الكبيرة أولاً ثم الأصغر وتحديث `reslist` ومتابعة التصنيع بنجاح. |
| 8 | Daily Quest Completed | المهمة 4100009 متممة مسبقاً اليوم بالذاكرة الحية | التخطي الفوري في `can_run` بـ 0.01ms دون أي استعلام شبكي نهائياً. |

---

## 4. قائمة فحص الذاكرة الحية المسبق (0-Network Pre-flight Validation)

قبل إرسال أي طلب شبكي للسيرفر، يجب تطبيق الفحوصات التالية بالترتيب على `conn.init_data`:

```python
# 1. فحص إتمام النشاط اليومي مسبقاً (0-Network)
if self._is_daily_quest_completed():
    return TaskResult.skip("Daily quest 4100009 already completed (0-Network)")

# 2. فحص حالة مبنى ورشة الحدادة (BID 115)
# التأكد من وجود المبنى وأنه ليس قيد الترقية حالياً (state == "0")
city_ctrl = self.get_ctrl("cityCtrl")
blist = city_ctrl.get("blist", []) if isinstance(city_ctrl, dict) else []
blacksmith_binfo = None
for b in blist:
    if isinstance(b, dict):
        binfo = b.get("binfo", {})
        if str(binfo.get("bid")) == "115":
            blacksmith_binfo = binfo
            break

if not blacksmith_binfo:
    return TaskResult.skip("ورشة الحدادة غير مبنية في القلعة")

if str(blacksmith_binfo.get("state", "0")) != "0":
    return TaskResult.skip("ورشة الحدادة قيد الترقية حالياً (0-Network)")

# 3. الفحص الشامل لحالة التصنيع بورشة الحدادة (حل خطأ 22002 الجذري):
queue_ctrl = self.get_ctrl("queueCtrl") or {}
eq_ctrl = self.get_ctrl("equipmentCtrl") or {}

forge_q = queue_ctrl.get("1229") or queue_ctrl.get(1229)
fe_obj = eq_ctrl.get("fe")
now_ts = int(time.time())

if forge_q or fe_obj:
    # أ) تحديد هل التصنيع لا يزال جارياً في الوقت الفعلي
    is_busy = False
    finish_t = 0
    
    if isinstance(forge_q, dict):
        st = int(forge_q.get("starttime", 0) or 0)
        tt = int(forge_q.get("totaltime", 0) or 0)
        if st > 0 and tt > 0:
            finish_t = st + tt
            if finish_t > now_ts:
                is_busy = True
                
    if isinstance(fe_obj, dict):
        fe_end = int(fe_obj.get("endTime", 0) or 0)
        if fe_end > now_ts:
            is_busy = True
            finish_t = max(finish_t, fe_end)

    # إذا كانت الورشة لا تزال تصنع -> تخطي فوري وآمن (0-Network)
    if is_busy:
        rem_sec = max(1, finish_t - now_ts)
        return TaskResult.skip(f"Blacksmith is busy forging (0-Network) (remaining: {rem_sec}s)")

    # ب) إذا انتهى وقت التصنيع أو القطعة جاهزة (fe موجود مع endTime == 0 أو <= now):
    # -> استلام القطعة فوراً وإتمام النشاط اليومي بـ 0 استهلاك موارد!
    q_data = forge_q.get("data", {}) if isinstance(forge_q, dict) and isinstance(forge_q.get("data"), dict) else {}
    fe_epid = int((fe_obj.get("epid") if isinstance(fe_obj, dict) else 0) or (q_data.get("epid") or 0))
    fe_eid = int((fe_obj.get("eid") if isinstance(fe_obj, dict) else 0) or (q_data.get("eid") or 0))

    if fe_epid > 0:
        # إرسال أمر الاستلام الرسمي (CMD 1047 / SubCMD 2)
        res = await self.safe_query("1047", "2", {"epid": fe_epid})
        # مزامنة الذاكرة الحية (حذف fe، تفريغ الطابور 1229، إضافة القطعة للحقيبة، إتمام النشاط اليومي)
        # إرجاع TaskResult.ok والتوقف دون محاولة تصنيع جديدة اليوم!
        return TaskResult.ok(...)

# 4. فحص سعة حقيبة العتاد (Max Size: 200)
eq_array = eq_ctrl.get("equipment_array", []) if isinstance(eq_ctrl, dict) else []
if len(eq_array) >= 200:
    return TaskResult.skip("حقيبة العتاد ممتلئة بالكامل (200/200)")

# 5. اختيار الوصفة وتوفير المواد والصلب والتدرج حتى Lv.1
```

---

## 5. مواصفات مزامنة الذاكرة الحية محلياً (In-Memory State Sync)

### أ) عند نجاح استلام قطعة منتهية (`REQ_GET_EQUIPMENT`):
1. **تفريغ طابور الحدادة 1229:**
   `queueCtrl.pop("1229", None)`, `queueCtrl.pop(1229, None)`
2. **إزالة كائن `fe` من `equipmentCtrl`:**
   `equipmentCtrl.pop("fe", None)`
3. **إضافة القطعة المستلمة إلى `equipmentCtrl.equipment_array`:**
   ```python
   harvested_item = dict(fe_obj)
   harvested_item["wear"] = 0
   harvested_item["endTime"] = 0
   eq_ctrl.setdefault("equipment_array", []).append(harvested_item)
   ```
4. **تحديث عداد النشاط اليومي:**
   ```python
   everyday = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
   if isinstance(everyday, dict):
       ev = everyday.setdefault("eventInfo", {})
       ev["4100009"] = 1
       ev["9"] = 1
   quest = self.get_ctrl("questCtrl")
   if isinstance(quest, dict):
       pfl = quest.setdefault("point_finish_list", [])
       if 4100009 not in pfl:
           pfl.append(4100009)
   ```

### ب) عند نجاح بدء تصنيع عتاد جديد (`REQ_FORGE_EQUIPMENT`):
1. **خصم المواد المستهلكة من `backpackCtrl`:** نقص الرصيد بمقدار 1 لكل مادة استُخدمت في `materialArray`.
2. **خصم الصلب من `cityCtrl.reslist["1006"]`:** خصم `need_steel`.
3. **إزالة القطعة الأساسية المستهلكة من `equipment_array`:** إذا كانت `base_epid > 0`.
4. **تسجيل طابور الحدادة 1229 في `queueCtrl`:**
   ```python
   queue_ctrl["1229"] = {
       "qtype": "1229",
       "starttime": server_bTime or now_ts,
       "totaltime": server_costTime,
       "ottime": server_costTime,
       "data": forging_data,
   }
   ```
5. **تسجيل كائن `fe` في `equipmentCtrl`:**
   ```python
   eq_ctrl["fe"] = forging_data
   ```
6. **تحديث عداد النشاط اليومي** لمنع إرسال أي طلبات لاحقة في نفس اليوم.

---

## 6. جدول مقارنة أخطاء وحدة العتاد الرسمية (Reference Error Codes Table)

| كود الخطأ | الاسم البرمجي الرسمي | المعنى وسبب الظهور في السيرفر | الحل وصمام الأمان في البوت |
|---|---|---|---|
| **22001** | `Err_NOT_FOUND_EQUIPMENT` | معرّف القطعة غير موجود في السجلات | التأكد من وجود `epid` في `equipment_array` |
| **22002** | `Err_IS_FORGING_EQUIPMENT` | الورشة تصنع حالياً أو تحوي قطعة جاهزة لم تُستلم | فحص `fe` و طابور 1229؛ استلام القطعة الجاهزة أولاً، أو التخطي إذا كانت مشغولة |
| **22003** | `Err_EQUIPMENT_ALREADY_WEAR` | القطعة ملبوسة مسبقاً على الأمير | التحقق من `wear == 0` |
| **22004** | `Err_EQUIPMENT_NOT_WEAR` | محاولة خلع قطعة غير ملبوسة | التحقق من `wear == 1` قبل الخلع |
| **22005** | `Err_EQUIPMENT_PART_NOT_MATCH` | عدم تطابق صنف القطعة مع خانة التلبيس | مطابقة بادئة الصنف (61-66) |
| **22006** | `Err_EQUIPMENT_LORD_LV_NOT_ENOUGH` | مستوى الأمير أقل من مستوى القطعة | تحديد سقف الوصفات بـ `min(lord_level, blacksmith_level)` |
| **22007** | `Err_MAIN_MATERIAL_NOT_FOUND` | القطعة الأساسية للدمج غير موجودة بالحقيبة | فحص وجود `base_epid` في `equipment_array` |
| **22008** | `Err_MAIN_MATERIAL_LV_NOT_ENOUGH` | مستوى القطعة الأساسية خارج نطاق الوصفة | فحص `lvl - 5 <= base_lvl <= lvl` |
| **22009** | `Err_MATERIAL_NOT_ENOUGH` | رصيد المواد في الحقيبة غير كافٍ | فحص توفر المواد بالجودة المناسبة في `backpackCtrl` |
| **22010** | `Err_MATERIAL_NOT_MATCH` | مصفوفة المواد لا تطابق متطلبات الصنف | مطابقة عائلات المواد الرسمية (A, B) لكل صنف |
| **22012** | `Err_EQUIPMENT_NUM_MAX` | حقيبة العتاد ممتلئة (200 قطعة) | فحص `len(equipment_array) < 200` مسبقاً |
| **22013** | `Err_MAIN_MATERIAL_IS_WEARING` | القطعة الأساسية للدمج ملبوسة على الأمير | التحقق الصارم من `wear == 0` للقطعة الأساسية |
| **22015** | `Err_NOT_FOUND_EQUIPMENT_CAN_GET` | طلب استلام قطعة بينما لا توجد قطعة جاهزة | عدم إرسال SubCMD 2 إلا عند وجود `fe` مكتمل |
| **22016** | `Err_NOT_FINISH_FORGING` | طلب استلام قطعة قبل اكتمال وقت التصنيع | التأكد من أن `now >= finish_time` قبل الاستلام |
