# تقرير التحقيق الشامل: حل تعارض مهمتي التدريب train و daily_train ومزامنة الذاكرة الحية (R1)
═══════════════════════════════════════════════════════════════════════════════════════

**المحقق**: مستكشف مزامنة التدريب (Training Sync Explorer)  
**تاريخ التحقيق**: 2026-11-01  
**المهمة المستهدفة**: المطلب R1 من وثيقة `ORIGINAL_REQUEST.md` ودستور العمل `GEMINI.md`  
**الملفات المفحوصة**:
- `tasks/train.py`
- `tasks/daily_train.py`
- `tasks/base_task.py`
- `core/game_client.py`
- `bot_manager.py`
- `docs/beetoo1_live_memory.json`
- `docs/beetoo3_live_memory.json`
- `docs/lucifer_live_memory.json`
- `docs/sample_live_memory.json`
- سورس اللعبة الرسمي في `game_file/src/` (خاصة `queueCtrl.lua`, `armyCtrl.lua`, `everydayTaskCtrl.lua`, `daily_reward_point_config.lua`, `queueTypeDef.lua`)

---

## 1. الملخص التنفيذي (Executive Summary)

أظهر التحقيق الميداني والتدقيق البرمجي لسورس اللعبة وملفات الذاكرة الحية الحقيقية أسباب التعارض والأخطاء الشبكية بين مهمة تدريب الجيش الرئيسية `train` ومهمة تدريب النشاط اليومي `daily_train`:

1. **السبب الجذري لخطأ 4002 ("الثكنة مشغولة"):**
   عندما تطلق مهمة `daily_train` (أو `train`) أمراً بتدريب جنود (`cmd: "1005", subcmd: "2"`) ويقبل السيرفر الطلب، لا يتم تحديث كائن طوابير الثكنات في الذاكرة الحية `conn.init_data['queueCtrl']` إطلاقاً. وبالتالي، عندما تبدأ المهمة التالية (`train`) بعد ثوانٍ معدودة، تقرأ `queueCtrl` فتجد الثكنة فارغة وظاهرياً خاملة، فترسل استعلاماً شبكياً للتدريب، فيرفضه السيرفر فوراً بالخطأ **4002 (Barracks Busy)**، مما يخالف مبدأ "0 استعلامات شبكية فاشلة" المنصوص عليه في `GEMINI.md`.

2. **التحقق من النشاط اليومي في الذاكرة الحية (`everydayTaskCtrl` و `questCtrl`):**
   تتبع مهام النشاط اليومي لتدريب القوات الأربعة والفخاخ يتم عبر كائن `everydayTaskCtrl.eventInfo` بالأرقام النوعية `12` للمشاة، `13` للرماة، `14` للخيالة، `15` للعربات، و `16` للفخاخ، حيث كل دورة تدريب (50 وحدة) تزيد العداد بمقدار 1، والهدف الأقصى هو 5 (أي 250 وحدة). وقد أثبت فحص ملف `beetoo3_live_memory.json` الفعلي وجود هذه القيم مكتملة بالقيمة `5` (`'12': 5, '13': 5, '14': 5, '15': 5`).

3. **حلقة التكرار المفرطة عند انقطاع الاتصال أو تجاوز السعة:**
   دالة `_train_adaptive` في `train.py` تحتوي على حلقة `while` تعيد المحاولة حتى 3 مرات مع تخفيض العدد عند حدوث `timeout` أو أخطاء السعة. وإذا انقطع الاتصال أو أرجع السيرفر `None`، يدخل البوت في إعادة محاولة متكررة لكل نوع من القوات الخمس (ما يصل إلى 15 طلباً فاشلاً على اتصال مقطوع).

4. **آلية فض النزاع والترتيب الذكي:**
   تعمل `DailyTrainTask` في الترتيب الدوري في `bot_manager.py` (الخطوة 82) قبل `TrainTask` (الخطوة 85). يجب استبعاد أي نوع قوات يتكفل به التدريب الرئيسي ليتدرب بأعلى رتبة وسعة للمستخدم، وتدريب رتبة 1 فقط للأنواع غير المشمولة بالتدريب العادي شريطة عدم اكتمال نشاطها اليومي، مع التحديث الفوري المتبادل للذاكرة الحية محلياً.

---

## 2. النقطة الأولى: حالة النشاط اليومي (questCtrl و everydayTaskCtrl)

### أ) البنية الرسمية في سورس اللعبة
من خلال فحص الملف الرسمي:  
`game_file/src/app/localtb/config_server/daily_reward_point_config.lua`:
```lua
-- المشاة (Infantry)
ID = 4100012, type = 12, quest = 50, point = 5, limitTime = 5
-- الرماة (Archers)
ID = 4100013, type = 13, quest = 50, point = 5, limitTime = 5
-- الخيالة (Cavalry)
ID = 4100014, type = 14, quest = 50, point = 5, limitTime = 5
-- العربات (Chariots)
ID = 4100015, type = 15, quest = 50, point = 5, limitTime = 5
-- الفخاخ (Traps / Fortress)
ID = 4100016, type = 16, quest = 50, point = 3, limitTime = 5
```
- **حساب الهدف**: تدريب 50 وحدة = دورة واحدة (+1 في العداد).
- **الحد الأقصى اليومي**: `limitTime = 5` (أي 5 × 50 = **250 وحدة**).

### ب) تموضع البيانات في الذاكرة الحية (`conn.init_data`)
1. **المتحكم الأساسي**: `conn.init_data["everydayTaskCtrl"]`
2. **الحقل الحاسم**: `eventInfo`
   - قاموس يربط رقم النوع (`str(event_type)`) بعدد مرات الإنجاز اليومي.
   - **دليل مادي مباشر من `docs/beetoo3_live_memory.json`**:
     ```json
     "everydayTaskCtrl": {
       "eventInfo": {
         "12": 5,
         "13": 5,
         "14": 5,
         "15": 5,
         "7": 1,
         "8": 10,
         "9": 1,
         "10": 1,
         "11": 5,
         "22": 5,
         "23": 20,
         "24": 10,
         "26": 1,
         "27": 1,
         "28": 1
       },
       "tomorrowZeroUTC": 1793491200
     }
     ```
   - نلاحظ بوضوح أن:
     - `'12': 5` تعني اكتمال تدريب المشاة بنسبة 100% (250/250 وحدة).
     - `'13': 5` تعني اكتمال تدريب الرماة بنسبة 100% (250/250 وحدة).
     - `'14': 5` تعني اكتمال تدريب الخيالة بنسبة 100% (250/250 وحدة).
     - `'15': 5` تعني اكتمال تدريب العربات بنسبة 100% (250/250 وحدة).
     - النوع `16` (الفخاخ) غير موجود أو أقل من 5، وبالتالي لم يكتمل.

3. **المتحكم المساعد `questCtrl`**:
   يحتوي على:
   - `point_finish_list`: قائمة محلية في الذاكرة تستخدمها مهام البوت (مثل `forge_equipment.py`) لتوثيق المهام المكتملة فوراً (`[4100012, 4100013, ...]`).
   - `completeQuest`: قائمة أرقام المهام المكتملة في رحلة اللورد.

### ج) خوارزمية الفحص الاستباقي (0-Network Pre-flight) في `daily_train`
```python
def is_daily_quest_finished(self, quest_id: int, event_type: str) -> bool:
    # 1. فحص everydayTaskCtrl.eventInfo
    everyday = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
    if isinstance(everyday, dict):
        ev_info = everyday.get("eventInfo", {})
        if isinstance(ev_info, dict):
            # فحص برقم النوع (12..16) أو برقم المهمة (4100012..4100016)
            if int(ev_info.get(str(event_type), 0) or 0) >= 5:
                return True
            if int(ev_info.get(str(quest_id), 0) or 0) >= 5:
                return True

    # 2. فحص كاش point_finish_list في questCtrl
    quest_ctrl = self.get_ctrl("questCtrl")
    if isinstance(quest_ctrl, dict):
        pfl = quest_ctrl.get("point_finish_list", [])
        if isinstance(pfl, list) and quest_id in pfl:
            return True

    return False
```

### د) بروتوكول التحديث الفوري للذاكرة الحية محلياً عند إطلاق أو إتمام التدريب
فور نجاح أي طلب تدريب لعدد وحدات `actual_count`:
```python
# 1. تحديث everydayTaskCtrl.eventInfo
everyday = self.conn.init_data.setdefault("everydayTaskCtrl", {})
if isinstance(everyday, dict):
    ev_info = everyday.setdefault("eventInfo", {})
    if isinstance(ev_info, dict):
        cur_cycles = int(ev_info.get(str(event_type), 0) or 0)
        add_cycles = max(1, actual_count // 50)
        ev_info[str(event_type)] = min(5, cur_cycles + add_cycles)
        if actual_count >= 250:
            ev_info[str(event_type)] = 5

# 2. توثيق المهمة في questCtrl.point_finish_list
quest_ctrl = self.conn.init_data.setdefault("questCtrl", {})
if isinstance(quest_ctrl, dict):
    pfl = quest_ctrl.setdefault("point_finish_list", [])
    if isinstance(pfl, list) and quest_id not in pfl:
        pfl.append(quest_id)
```

---

## 3. النقطة الثانية: حالة طوابير التدريب والثكنات (queueCtrl و armyCtrl)

### أ) الهيكلية الرسمية لطوابير التدريب
من خلال `game_file/src/app/constdef/queueTypeDef.lua` و `queueCtrl.lua`:
- **خريطة أنواع الطوابير وثنائيات المباني**:
  - `bid = "118"` (المشاة / Infantry) ⟷ `queuetype = "1203"`
  - `bid = "116"` (الخيالة / Cavalry) ⟷ `queuetype = "1204"`
  - `bid = "117"` (الرماة / Archers) ⟷ `queuetype = "1205"`
  - `bid = "119"` (العربات / Chariots) ⟷ `queuetype = "1206"`
  - `bid = "120"` (الفخاخ / Fortress) ⟷ `queuetype = "1207"`

### ب) دليل مادي من الذاكرة الحية الحقيقية
من فحص `docs/beetoo3_live_memory.json` الفعلي:
```json
"queueCtrl": {
  "1203": {
    "qtype": "1203",
    "starttime": 1793454798,
    "totaltime": 12790,
    "ottime": 12790,
    "data": {
      "bid": "118",
      "armyid": "401",
      "armycount": "1735",
      "_uniqueid": 179345479814,
      "costres": [...]
    }
  },
  "1204": {
    "qtype": "1204",
    "starttime": 1793454800,
    "totaltime": 32974,
    "data": { "bid": "116", "armyid": "504", "armycount": "1735", ... }
  },
  "1205": {
    "qtype": "1205",
    "starttime": 1793454803,
    "totaltime": 61738,
    "data": { "bid": "117", "armyid": "606", "armycount": "1735", ... }
  },
  "1206": {
    "qtype": "1206",
    "starttime": 1793420527,
    "totaltime": 39892,
    "data": { "bid": "119", "armyid": "705", "armycount": "1735", ... }
  }
}
```

### ج) المقارنة بين `queueCtrl` و `armyCtrl.trainArmy`
هناك حالتان متميزتان في دورة حياة القوات:
1. **الثكنة قيد التدريب النشط**:
   توجد في `queueCtrl[qtype]` بشرط: `now_ts < (starttime + totaltime)`.
2. **الثكنة انتهى تدريبها وجاهزة للاستلام**:
   - عندما يكتمل التدريب أو عند الدخول إلى حساب انتهت قواته، ينقل السيرفر بيانات الجيش إلى `armyCtrl.trainArmy[bid]`.
   - **دليل مادي من `docs/beetoo1_live_memory.json` و `docs/lucifer_live_memory.json`**:
     ```json
     "armyCtrl": {
       "trainArmy": {
         "116": { "501": "1985" },
         "117": { "601": "1985" },
         "118": { "401": "1985" },
         "119": { "701": "1985" }
       }
     }
     ```
     هنا `queueCtrl` فارغ تماماً، لكن القوات جاهزة للاستلام في `trainArmy` لكل ثكنة.

### د) تشخيص الخلل الحالي بدقة (Root Cause)
1. في `core/game_client.py` (الأسطر 1396-1412):
   عند استقبال استجابة `cmd: 1005, subcmd: 2`، يقوم الكلاينت فقط بتحديث `armyCtrl.trainArmy[bid]`، ولا يمس `queueCtrl` بتاتاً!
2. في `tasks/train.py` (الأسطر 625-636) و `tasks/daily_train.py`:
   تقوم الدالة بفحص انشغال الثكنة بالاعتماد فقط على:
   `if bid in q_map:`
   ولا تفحص `armyCtrl['trainArmy']` ولا يتم تحديث `queueCtrl` في الذاكرة عند نجاح أمر التدريب.
3. النتيجة: عندما تطلق `daily_train` التدريب في مبنى `118`، يظل `queueCtrl` بدون طابور `1203`. فوراً بعدها تأتي مهمة `train` لتفحص `q_map`، فتجد `118` غير موجود! فتظن الثكنة خاملة، وترسل طلب تدريب للمبنى المشغول فيرد السيرفر بكود الخطأ `4002`.

### هـ) بروتوكول التحديث الفوري المباشر لـ `queueCtrl` محلياً
فور نجاح أمر التدريب (`cmd 1005 / subcmd 2`):
```python
BID_TO_QUEUE_TYPE = {
    "118": "1203",  # مشاة
    "116": "1204",  # خيالة
    "117": "1205",  # رماة
    "119": "1206",  # عربات
    "120": "1207",  # فخاخ
}

def sync_training_queue_in_memory(conn, bid: str, armyid: int, count: int, retdata: dict):
    bid_str = str(bid)
    qtype = str(retdata.get("queuetype") or BID_TO_QUEUE_TYPE.get(bid_str, "1203"))
    total_time = int(retdata.get("totaltime") or retdata.get("lefttime") or 1800)
    now_ts = int(time.time())

    # 1. تحديث queueCtrl
    queue_ctrl = conn.init_data.setdefault("queueCtrl", {})
    if isinstance(queue_ctrl, dict):
        queue_ctrl[qtype] = {
            "qtype": qtype,
            "starttime": now_ts,
            "totaltime": total_time,
            "ottime": total_time,
            "lefttime": total_time,
            "data": {
                "bid": bid_str,
                "armyid": str(armyid),
                "armycount": str(count),
                "_uniqueid": retdata.get("_uniqueid", int(now_ts * 100)),
                "costres": retdata.get("costres", []),
            }
        }

    # 2. تحديث armyCtrl.trainArmy
    army_ctrl = conn.init_data.setdefault("armyCtrl", {})
    if isinstance(army_ctrl, dict):
        train_map = army_ctrl.setdefault("trainArmy", {})
        if isinstance(train_map, dict):
            train_map[bid_str] = {
                "bid": bid_str,
                "armyid": str(armyid),
                "armycount": str(count),
                "lefttime": total_time,
                "totaltime": total_time,
                "queuetype": qtype,
                "_uniqueid": retdata.get("_uniqueid", int(now_ts * 100)),
                "updated_at": now_ts,
            }

    # 3. خصم الموارد من cityCtrl محلياً
    cost_res = retdata.get("costres")
    if isinstance(cost_res, list):
        city = conn.init_data.setdefault("cityCtrl", {})
        reslist = city.setdefault("reslist", {})
        if isinstance(reslist, dict):
            for cr in cost_res:
                if isinstance(cr, dict) and "resid" in cr and "curcount" in cr:
                    reslist[str(cr["resid"])] = cr["curcount"]
            city["resList"] = reslist
```

---

## 4. النقطة الثالثة: الفحوصات القبلية الصارمة (Pre-flight Checks)

### أ) فحص الاتصال ومنع التكرار المفرط (Connection & Network Guard)
- **المشكلة الحالية**:
  عند حدوث انقطاع في الاتصال، تعيد `_train_adaptive` المحاولة لعدة مرات، ثم تنتقل حلقة التدريب للنوع التالي فتعيد المحاولة لعدة مرات أيضاً، مما يولد رسائل خطأ متكررة وتأخيرات غير مبررة.
- **الحل الجذري**:
  1. قبل إرسال أي استعلام، فحص:
     ```python
     if not self.conn or not getattr(self.conn, "is_connected", False):
         self.log("⚠️ تم رصد انقطاع الاتصال بالبوابة، إيقاف التدريب فوراً.")
         return TaskResult.fail("انقطاع الاتصال بالبوابة")
     ```
  2. في دالة `_train_adaptive`:
     إذا أعادت `safe_query` القيمة `None`، يتم التحقق فوراً من `self.conn.is_connected`. فإذا كان `False`، يتم التوقف فوراً بدون أي إعادة محاولة (`return False, 0, "انقطاع الاتصال بالبوابة"`).
  3. حصر إعادة المحاولة التكيفية في حالة الأخطاء المبررة فقط (`4004` و `4003`) لمرة واحدة بتخفيض 15%، وإلغاء أي إعادة محاولة عند خطأ `4002` (المبنى مشغول) أو `4001` (المستوى غير كافٍ).

### ب) فحص السعة القصوى والموارد (0-Network Direct Calculation)
- **حساب السعة بدقة 100% من الذاكرة الحية**:
  - سعة خيام الجيش (المستوى الأساسي من `build205` + نجوم الهيبة من `buildstar205`).
  - مهارات الأمير (13003, 13011, 13023, 13037).
  - بافات التدريب (322, 318).
  - سمات المبنى (السمة 13 في `boeAttributeCtrl`).
  - بنود وأدوات زيادة التدريب (`armyCtrl.singleTrainAddInfo`).
- **شرط التخطي الفوري**:
  إذا كانت السعة المحسوبة `can_train <= 0` أو العدد النهائي `initial_count <= 0`، يتم تخطي الثكنة مباشرة بصفر استعلام شبكي مع تسجيل توضيحي نظيف:
  `⚠️ السعة المتاحة لتدريب [المشاة] هي 0، تم التخطي مسبقاً (0-Network).`

### ج) فحص الموارد المسبق:
- مطابقة الموارد المتوفرة في `cityCtrl.reslist` مع جدول التكاليف المدمج `_ARMY_COSTS`.
- إذا كان `res_train_cap < 1` (الموارد لا تكفي حتى لجندي واحد): التخطي الفوري بدون ملامسة السيرفر، مع ذكر الموارد الناقصة في السجل.

---

## 5. النقطة الرابعة: معمارية فض النزاع بين `train.py` و `daily_train.py`

### أ) ترتيب التنفيذ في البوت
في دورة البوت داخل `bot_manager.py`:
- الخطوة 82: `DailyTrainTask`
- الخطوة 85: `TrainTask`

### ب) منطق فض النزاع الذكي (Smart Delegation Logic)
1. **القاعدة الأولى — الأولوية للتدريب الرئيسي للأنواع المحددة**:
   - إذا كان المستخدم قد فعّل التدريب العادي (`train.enabled == True`) وحدد للنوع رتبة أكبر من صفر (`levels[troop_key] > 0`):
     - تقوم `DailyTrainTask` **بتجاوز هذا النوع فوراً** وتسجيل ملاحظة ذكية:
       `⏭️ [المشاة] مفعل في التدريب العادي للمستخدم — تم التجاوز بذكاء ليتكفل به التدريب العادي.`
     - **العلة والسبب**: تدريب النشاط اليومي يطلب رتبة 1 بحد 250 وحدة فقط. إذا قامت `daily_train` بتدريبه، ستنشغل الثكنة لمدة ~25 دقيقة وتمنع `TrainTask` من تدريب الرتبة العالية (مثلاً Lv.10) بكامل طاقة الخيام. وبما أن تدريب الرتبة العالية في `TrainTask` سيتجاوز حتماً 250 وحدة، فإنه سيتمم مهمة النشاط اليومي تلقائياً!
   - تم تصحيح دالة `_is_type_handled_by_main_train`:
     بحيث تقرأ الإعدادات سواء وُضعت في `config["train"]` أو `config["tasks"]["train"]`، وتدعم كلاً من أسلوب `levels` وقائمة `types`.

2. **القاعدة الثانية — حصر `DailyTrainTask` في سد الفجوات فقط**:
   - لأي نوع غير مفعّل في التدريب العادي (مثلاً المستخدم يدرب فقط مشاة ورماة، ولديه خيالة وعربات بمستوى 0):
     - تفحص `daily_train` حالة مهمة النشاط اليومي من `everydayTaskCtrl.eventInfo`.
     - إذا كانت مكتملة مسبقاً (5/5): يتم التخطي فوراً (0-Network).
     - إذا كانت غير مكتملة، والثكنة خاملة: تدرب 250 وحدة رتبة 1 بدقة لسد الفجوة وحصد نقاط النشاط اليومي.

3. **القاعدة الثالثة — التزامن اللحظي المتبادل لـ `queueCtrl`**:
   - عندما تدرب `daily_train` أي نوع، يتم فوراً إضافة الطابور إلى `conn.init_data['queueCtrl']` بوقت انتهائه الفعلي.
   - عندما تبدأ مهمة `train` بعدها بثوانٍ:
     - تفحص `queueCtrl`.
     - تجد الثكنة مشغولة (`now_ts < starttime + totaltime`).
     - تتخطى الثكنة بصفر استعلامات شبكية (`0-Network Pre-flight`).
     - يختفي خطأ `4002` نهائياً!

4. **القاعدة الرابعة — استلام القوات المنتهية قبل اتخاذ أي قرار**:
   - كلتا المهمتين تبدآن باستدعاء `_harvest_all_ready_barracks`.
   - يتم استلام أي قوات جاهزة في الثكنات عبر `cmd 1005 / subcmd 5`.
   - عند نجاح الاستلام، يتم فوراً إزالة المبنى من `armyCtrl.trainArmy` ومن `queueCtrl` في الذاكرة الحية لإتاحة الثكنة للتدريب الجديد.

---

## 6. مصفوفة التحقق والمطابقة للأدلة الواقعية

| المتحكم / الحقل | القيمة في الذاكرة الحية | المدلول والوظيفة في البوت |
|---|---|---|
| `everydayTaskCtrl.eventInfo['12']` | `5` (في beetoo3) | اكتمل نشاط تدريب المشاة (250/250 وحدة) — يجب التخطي 0-Network |
| `everydayTaskCtrl.eventInfo['13']` | `5` (في beetoo3) | اكتمل نشاط تدريب الرماة (250/250 وحدة) — يجب التخطي 0-Network |
| `everydayTaskCtrl.eventInfo['14']` | `5` (في beetoo3) | اكتمل نشاط تدريب الخيالة (250/250 وحدة) — يجب التخطي 0-Network |
| `everydayTaskCtrl.eventInfo['15']` | `5` (في beetoo3) | اكتمل نشاط تدريب العربات (250/250 وحدة) — يجب التخطي 0-Network |
| `everydayTaskCtrl.eventInfo['16']` | `None` / `0` (في beetoo3) | نشاط تدريب الفخاخ لم يكتمل — مؤهل للتدريب بـ 250 وحدة رتبة 1 |
| `queueCtrl['1203']` | `{"starttime": ..., "totaltime": ...}` | ثكنة المشاة (118) قيد التدريب حالياً — منع أي استعلام شبكي تالٍ |
| `queueCtrl['1204']` | `{"starttime": ..., "totaltime": ...}` | ثكنة الخيالة (116) قيد التدريب حالياً — منع أي استعلام شبكي تالٍ |
| `queueCtrl['1205']` | `{"starttime": ..., "totaltime": ...}` | ثكنة الرماة (117) قيد التدريب حالياً — منع أي استعلام شبكي تالٍ |
| `queueCtrl['1206']` | `{"starttime": ..., "totaltime": ...}` | ثكنة العربات (119) قيد التدريب حالياً — منع أي استعلام شبكي تالٍ |
| `armyCtrl.trainArmy['118']` | `{"401": "1985"}` (في lucifer) | قوات المشاة جاهزة للاستلام فوراً عبر CMD 1005 / 5 |

---

## 7. الخطة التنفيذية المقترحة للمطور (Action Plan for Implementer)

1. **في `tasks/train.py`**:
   - تحديث دالة `_train_adaptive`:
     - فحص `self.conn.is_connected` قبل أي طلب، والتوقف الفوري عند انقطاعه بدون تكرار.
     - عند نجاح الطلب (`err == "0"`): استدعاء دالة المزامنة الحية لتسجيل الطابور في `conn.init_data['queueCtrl']` وحفظ بياناته في `armyCtrl.trainArmy` وتحديث رصيد الموارد في `cityCtrl`.
     - تحديث `everydayTaskCtrl.eventInfo` و `questCtrl.point_finish_list` إذا كان العدد المدرب >= 50 وحدة.
   - تحديث دالة `_harvest_all_ready_barracks`:
     - عند نجاح استلام القوات (`cmd 1005 / subcmd 5`): مسح الطابور المقابل من `queueCtrl` ومسح الثكنة من `trainArmy` في `conn.init_data` الحقيقية.
   - تحديث حلقة فحص انشغال الثكنات في `run()`:
     - فحص شامل لكلا المصدرين: `queueCtrl` (بقراءة القاموس وقائمة `queues` والربط المباشر بـ `BID_TO_QUEUE_TYPE`) ومصدر `armyCtrl.trainArmy`.

2. **في `tasks/daily_train.py`**:
   - تحسين دالة `_is_type_handled_by_main_train`:
     - فحص مسارات الإعداد المتعددة (`config["train"]` و `config["tasks"]["train"]`)، ودعم كل من `levels` و `types`.
   - تحسين دالة `_is_quest_completed`:
     - مطابقة الأرقام النوعية (`12` إلى `16`) في `everydayTaskCtrl.eventInfo` والتحقق من `questCtrl.point_finish_list`.
   - إضافة فحص الاتصال الصارم داخل حلقة الفحص:
     - إيقاف المهمة فوراً عند انقطاع الاتصال بدلاً من تجربة بقية القوات.
   - مزامنة كائن `queueCtrl` والنشاط اليومي فور نجاح تدريب رتبة 1.

---
**تاريخ ومكان التقرير**:  
`e:\intqam-sultan\.agents\teamwork\explorer_training_sync\report.md`  
جاهز للتسليم إلى وكيل التنسيق (Orchestrator) لمرحلة التنفيذ المباشر.
