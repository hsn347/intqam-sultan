# تقرير التسليم المعماري الشامل (Handoff Report): استكشاف الذاكرة الحية وبروتوكول العتاد

**المحقق**: Explorer 1 (Live Memory & Game Protocol Explorer)  
**تاريخ التقرير**: 2026-10-31T11:44:00Z  
**المرجع**: `e:\intqam-sultan\.agents\teamwork\ORIGINAL_REQUEST.md`  
**الخطة المعتمدة**: `C:\Users\Computer Home\.gemini\antigravity\brain\c9dda83e-09db-4998-9bd3-36c6eb6ad6d0\forge_equipment_plan.md`  

---

## 1. الملاحظات المباشرة (Observation)

### 1.1 بنية `conn.init_data` وتفريغ المتحكمات في `core/game_client.py`
- في الملف `core/game_client.py`:
  - **الأسطر 1207 و 1297-1307**:
    ```python
    self.init_data: Dict[str, Any] = {}
    ...
    log.info(f"[{self.account.email}] 📡 إرسال طلب التهيئة الشامل الرسمي (CMD=1000, SUBCMD=1, Session=0)...")
    self.send_request("1000", "1", {}, session=0)
    ```
  - **الأسطر 1342-1353**:
    تفريغ كافة متحكمات القلعة القادمة من السيرفر دفعة واحدة:
    ```python
    if sess_id == 0 or cmd_s in ('1000', 'onemt_1000'):
        retdata = c_data.get('retdata', {}) if isinstance(c_data, dict) else (parsed.get('retdata', {}) if isinstance(parsed, dict) else {})
        if isinstance(retdata, dict) and retdata:
            self.init_data.update(retdata)
            if 'heroCtrl' in retdata:
                h_ctrl = retdata.get('heroCtrl', [])
                if isinstance(h_ctrl, list):
                    self.heroes = list(h_ctrl)
            self.controllers_ready.set()
    ```
  - **المتحكمات المعنية في كائن `conn.init_data`**:
    1. `equipmentCtrl`:
       - مفحوص في `docs/sample_live_memory.json` (الأسطر 8317-8380) و `docs/beetoo1_live_memory.json` (الأسطر 5580-5630).
       - يحتوي على `equipment_array: List[Dict[str, Any]]`.
       - هيكل كل عنصر عتاد داخل المصفوفة:
         ```json
         {
           "epid": 1,
           "eid": 6100101,
           "wear": 0,
           "endTime": 0,
           "qly": 2,
           "remakeTimes": 0,
           "extra": [[15, 2], [31, 9]],
           "isCle": 1,
           "slv": 0
         }
         ```
         - `epid`: المعرف الفريد للقطعة (Instance ID).
         - `eid`: نوع القطعة ورقم الوصفة (Recipe ID).
         - `wear`: حالة الارتداء (`1` = يرتديها الأمير، `0` = في الحقيبة).
         - `endTime`: وقت اكتمال التصنيع بالثواني UTC (`0` = جاهزة ومستلمة، `> now` = قيد التصنيع حالياً، `> 0 and <= now` = انتهى تصنيعها وتنتظر أمر الاستلام).
         - `qly`: جودة القطعة ولونها (0=أبيض، 1=أخضر، 2=أزرق، 3=بنفسجي، 4=برتقالي، 5=ذهبي).
    2. `backpackCtrl` (مكرر كـ `bagCtrl` بالسطر 1367-1368 في `game_client.py`):
       - خريطة بالمواد والعناصر: `{"200601": {"count": 12, "id": 200601}, ...}` أو `{"200601": 12}`.
    3. `cityCtrl`:
       - يحتوي على `reslist` و `resList` (قاموس بالموارد المتاحة بالقلعة).
       - مورد الصلب (Steel) هو المفتاح `"1006"` بقيمة رقمية مباشرة (مثلاً `345733` كما لوحظ في `docs/sample_live_memory.json`).
       - يحتوي أيضاً على مباني القلعة `blist` (حيث مبنى الحدادة هو `BUILDID.BLACK_SMITH = 217` ومستوى القلعة `buildingId 4000`).
    4. `questCtrl` و `everydayTaskCtrl`:
       - `questCtrl`: يحتوي على `questArray`, `pGuideQuest`, `guideQuest`, `completeQuest`, `oQuestArray`.
       - `everydayTaskCtrl` (مفحوص في `docs/sample_live_memory.json` سطر 11500 و `game_file/src/app/module/everydayTask/everydayTaskCtrl.lua` سطر 36-52):
         - يحتوي على `eventInfo: Dict[str, int]` حيث تسجل إنجازات المهام اليومية:
           - مهمة تصنيع العتاد: المعرف `4100009` أو النوع `9` (الهدف: `1` قطعة، النقاط: `20` نقطة).
           - إذا كان `eventInfo.get("4100009", 0) >= 1` أو `eventInfo.get("9", 0) >= 1`، فالمهمة متممة مسبقاً اليوم.

### 1.2 بنية المهام في `tasks/` ونظام `BaseTask`
- في الملف `tasks/base_task.py`:
  - **الوراثة**: ترث كافة المهام من `BaseTask(ABC)` وتعرّف `name: str = "forge_equipment"`.
  - **التهيئة (الأسطر 272-280)**:
    ```python
    def __init__(self, conn: Any, log_func: Optional[Callable[[str], None]] = None, config: Optional[Dict[str, Any]] = None):
        self.conn = conn
        self._log_func = log_func
        self.config = config or {}
    ```
  - **الاستعلام الآمن والمحاكاة البشرية (الأسطر 407-435)**:
    `await self.safe_query(cmd, subcmd, data, min_delay=0.8, max_delay=1.5)`
    يقوم بإدراج تأخير بشري عشوائي (Human Jitter) وإرسال الطلب عبر `self.conn.query(cmd, subcmd, data)`.
  - **الوصول للذاكرة الحية (الأسطر 297-313)**:
    - خاصية `self.init_data`: وصول مباشر لـ `self.conn.init_data`.
    - دالة `self.get_ctrl(name)`: قراءة المتحكم بأمان من الذاكرة الحية بدون أي استثناءات.
  - **دالة توفير الموارد `ensure_resources` (الأسطر 501-650)**:
    - تقبل `requirements: Dict[str | int, int], multiplier: int = 3, force_open: bool = False`.
    - **ملاحظة حرجة**: جدول `RESOURCE_CATALOG` في `tasks/base_task.py` (الأسطر 96-263) يغطي فقط:
      - `food` (`1002`)
      - `wood` (`1003`)
      - `iron` (`1004`)
      - `silver` (`1005`)
      - `crystal` (`1027`)
      **ولا يحتوي حالياً على الصلب `steel` (`1006`)**. صناديق الصلب في اللعبة هي عائلة `1004xx` (`100401` = 10 صلب، `100402` = 100 صلب، `100403` = 500 صلب، `100404` = 1,000 صلب، `100405` = 5,000 صلب).

### 1.3 بروتوكول وحدة العتاد (Equipment Module Protocol - CMD 1047)
- في الملف `game_file/src/app/constdef/cmdDef.lua` (الأسطر 1125-1127):
  ```lua
  CMD_EQUIPMENT_MODULE = "1047"
  REQ_FORGE_EQUIPMENT = "1"
  REQ_GET_EQUIPMENT = "2"
  ```
- في الملف `game_file/src/app/module/equipment/equipmentCtrl.lua`:
  - **طلب بدء التصنيع (`CMD=1047, SUBCMD=1`) - الأسطر 818-824**:
    ```lua
    function REQ.reqForgeEquipment(eid, materialArray, mainMaterialID)
        serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_FORGE_EQUIPMENT, {
            eid = eid,
            materialArray = materialArray,
            mainMaterialID = mainMaterialID
        })
    end
    ```
    - حمولة الطلب الرسمية (JSON):
      ```json
      {
        "eid": 6100101,
        "materialArray": [200601, 200301],
        "mainMaterialID": 0
      }
      ```
    - استجابة السيرفر `RSP:forgeEquipmentRsp` (الأسطر 999-1039):
      تعيد `err = 0` و `data.equipment` (كائن القطعة الجديدة شاملاً `epid`, `eid`, `qly`, `wear: 0`) و `data.bTime` و `data.costTime`.
  - **طلب استلام القطعة المنتهية (`CMD=1047, SUBCMD=2`) - الأسطر 874-878**:
    ```lua
    function REQ.reqGetEquipment(epid)
        serverproxy:Request(gCmd.CMD_EQUIPMENT_MODULE, gCmd.REQ_GET_EQUIPMENT, {
            epid = epid
        })
    end
    ```
    - حمولة الطلب الرسمية (JSON):
      ```json
      {
        "epid": 105
      }
      ```
    - استجابة السيرفر `RSP:getEquipmentRsp` (الأسطر 1202-1215):
      تعيد `err = 0`، وتصبح القطعة جاهزة في الحقيبة برصيد `endTime = 0`.

### 1.4 وصفات وأصناف العتاد ومستوياتها (138 وصفة رسمية)
- في الملف `game_file/src/app/localtb/config_server/forge_equipment_config.lua`:
  - يحتوي على كافة وصفات الحدادة للأصناف الستة، كل صنف يضم **23 مستوى** بالتحديد:
    `[1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110]`
  - توزيع الأصناف الستة وأرقام بادئاتها وخاماتها:
    | الصنف | المفتاح | بادئة المعرف | نطاق المعرفات | المواد المطلوبة (عائلة) | قطعة أساسية سابقة (`mainMaterialID`) |
    | :--- | :--- | :--- | :--- | :--- | :--- |
    | السلاح | `weapon` | `61` | 6100101 إلى 6111001 | 2006xx (ريش/بلور) + 2003xx (عنبر/عظم) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
    | الثوب | `clothes` | `62` | 6200101 إلى 6211001 | 2001xx (حديد) + 2005xx (خشب/قماش) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
    | الخوذة | `helmet` | `63` | 6300101 إلى 6311001 | 2001xx (حديد) + 2002xx (فراء/جلود) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
    | البنطلون | `trousers` | `64` | 6400101 إلى 6411001 | 2003xx (عنبر/عظم) + 2005xx (خشب/قماش) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
    | الحذاء | `shoes` | `65` | 6500101 إلى 6511001 | 2002xx (فراء/جلود) + 2004xx (فحم/حجر) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
    | الخاتم | `ring` | `66` | 6600101 إلى 6611001 | 2004xx (فحم/حجر) + 2006xx (ريش/بلور) | `0` لـ Lv.1، وقطعة سابقة للمستويات $\ge 5$ |
  - مواصفات المستوى 1 (`Level 1`) لجميع الأصناف الستة:
    - لا يتطلب أي قطعة سابقة (`mainMaterialID = 0`).
    - يتطلب **100 صلب فقط** (`needSteel = 100`).
    - يتطلب قطعتين من المواد الأولية البيضاء الشائعة (رتبة 1).

---

## 2. سلسلة الاستنتاج المنطقي (Logic Chain)

1. **التحقق من إنجاز المهمة اليومية مسبقاً (0-Network Pre-flight)**:
   - *الاستناد للملاحظة 1.1*: المهمة اليومية الرسمية رقم `4100009` مسجلة في `everydayTaskCtrl.eventInfo` برقم المعرف `"4100009"` أو النوع `"9"`.
   - *الاستنتاج*: يجب فحص `everydayTaskCtrl.eventInfo`؛ إذا كانت القيمة $\ge 1$، يتم التخطي فوراً بنتيجة `TaskResult.skip("Daily quest already completed (0-Network)")`. ولضمان التوافق مع نص طلب المطور ووثائق الخطط السابقة، يتم فحص `questCtrl.point_finish_list` بالتزامن إن وجد.

2. **فحص ورشة الحدادة واستلام القطعة المكتملة أولاً**:
   - *الاستناد للملاحظة 1.1 و 1.3*: بالمرور على `equipmentCtrl.equipment_array`:
     - إذا وُجدت قطعة تحقق `endTime > 0 and endTime <= int(time.time())`:
       - *الاستنتاج*: توجد قطعة تم الانتهاء من تصنيعها وتنتظر أمر الاستلام. يتم إرسال `CMD 1047 / SubCMD 2` مع `{"epid": item["epid"]}`. استلام هذه القطعة ينجز مهمة النشاط اليومي رسمياً بنسبة 100% دون استهلاك ذرة صلب واحدة أو أي مواد جديدة!
       - يتم فوراً تحديث الذاكرة محلياً: `item["endTime"] = 0` و `everydayTaskCtrl.eventInfo["4100009"] = 1`.
     - إذا وُجدت قطعة تحقق `endTime > int(time.time())`:
       - *الاستنتاج*: ورشة الحدادة مشغولة بتصنيع جارٍ في اللعبة؛ وبما أن السيرفر يمنع تصنيع قطعتين بالتوازي، يجب التوقف فوراً بنتيجة `TaskResult.skip("Blacksmith is busy forging (0-Network)")` دون إرسال أي طلب شبكي.

3. **خوارزمية تصنيع أعلى قطعة ممكنة والتدرج حتى المستوى 1**:
   - *الاستناد للملاحظة 1.4*:
     - إذا كانت الورشة فارغة، يجلب البوت وصفات الصنف المختار (مثلاً `weapon`) مرتبة تنازلياً من `Lv.110` إلى `Lv.1`.
     - لكل وصفة:
       1. التأكد أن مستوى الوصفة $\le$ مستوى مبنى الحدادة / القلعة.
       2. إذا كانت الوصفة $\ge 5$: التحقق من وجود قطعة أساسية غير ملبوسة بالحقيبة (`wear == 0` و `endTime == 0`) بالمستوى الأدنى السابق المطلوب. إذا لم تتوفر، يتم تخطي الوصفة فوراً والانتقال للمستوى الأقل.
       3. التحقق من توفر المواد المطلوبة في `backpackCtrl`، مع اختيار الجودة الأدنى المتوفرة (أبيض ثم أخضر ثم أزرق) لحماية المواد النادرة والبنفسجية.
       4. التحقق من رصيد الصلب في `cityCtrl.reslist["1006"]`. إذا كان هناك عجز، يُستدعى منطق توفير الصلب أو التدرج للمستوى الأدنى.
     - في حال عدم توفر متطلبات المستويات العالية، يتدرج البوت تلقائياً حتى المستوى 1 (`Level 1`) الذي لا يتطلب أي قطعة سابقة ويتطلب فقط 100 صلب ومادتين أوليتين، مما يضمن إنجاز المهمة اليومية بنسبة 100% تحت أي ظرف.

4. **تحديث كائنات الذاكرة الحية محلياً فور الإنجاز (In-Memory State Sync)**:
   - *الاستناد للملاحظة 1.1*: فور نجاح طلب التصنيع (`CMD 1047 / SubCMD 1`):
     - خصم المواد المستهلكة من `backpackCtrl`.
     - خصم الصلب من `cityCtrl.reslist["1006"]`.
     - إذا كان `mainMaterialID > 0`، حذف القطعة الأساسية المستهلكة من `equipmentCtrl.equipment_array`.
     - إضافة القطعة المصنعة الجديدة إلى `equipment_array` مع تحديد `endTime = int(time.time()) + costTime`.
     - ضبط `everydayTaskCtrl.eventInfo["4100009"] = 1` و `"9" = 1`.

---

## 3. التحفظات والمناطق الخاصة (Caveats)

1. **الصلب ودالة `ensure_resources`**:
   - جدول `RESOURCE_CATALOG` في `tasks/base_task.py` لا يعرّف الصلب `steel` (`1006`)، وصناديق الصلب هي عائلة `1004xx` وليس `1006xx` (عائلة `1006xx` مخصصة للفضة).
   - *توصية للمطور ووكيل البناء*: إذا رغبنا في فتح صناديق الصلب عند وجود عجز، يجب إما توسيع `RESOURCE_CATALOG` في `base_task.py` لدعم `steel: 1006` مع صناديق `100401-100405`، أو التعامل مع عجز الصلب داخلياً في مهمة العتاد بفتح الصناديق مباشرة عبر `CMD 1004 / SubCMD 2` أو التدرج للمستوى 1 (100 صلب فقط متوفرة دائماً).
2. **ازدواجية متحكم المهام اليومية**:
   - كود اللعبة الرسمي يعتمد على `everydayTaskCtrl.eventInfo`، بينما ذكرت مسودة الخطة الأصلية `questCtrl.point_finish_list`.
   - *توصية قاطعة*: فحص كلا المسارين في كود المهمة لتفادي أي فراغ في الفحص القبلي (0-Network Pre-flight).

---

## 4. الخلاصة والتوصيات القاطعة للمطورين اللاحقين (Conclusion)

1. **تصميم كلاس المهمة**:
   - إنشاء `ForgeEquipmentTask` داخل `tasks/forge_equipment.py` وارثة من `BaseTask`.
   - الاسم البرمجي الثابت: `name = "forge_equipment"`.
   - قراءة الإعدادات: `self.config.get("enabled", False)` و `self.config.get("category", "weapon")`.
2. **الأوامر الشبكية المعتمدة 100%**:
   - `CMD = "1047"`.
   - تصنيع: `SUBCMD = "1"`, Payload: `{"eid": int, "materialArray": [int, ...], "mainMaterialID": int}`.
   - استلام: `SUBCMD = "2"`, Payload: `{"epid": int}`.
3. **الأصناف الستة المدعومة**:
   - `weapon` (61), `clothes` (62), `helmet` (63), `trousers` (64), `shoes` (65), `ring` (66).
   - توفير مصفوفة وصفات المستويات تنازلياً مع المستوى 1 كصمام أمان مضمون.

---

## 5. طريقة التحقق المستقل (Verification Method)

1. **التحقق من صحة ملفات التكوين والوصفات**:
   ```powershell
   python -c "from tasks.base_task import BaseTask; print('BaseTask loaded successfully')"
   ```
2. **التحقق من صحة قراءة كائنات الذاكرة الحية الحقيقية**:
   ```powershell
   python -c "import json; d = json.load(open('docs/sample_live_memory.json', encoding='utf-8')); eq = d.get('equipmentCtrl', {}); assert 'equipment_array' in eq; print('equipment_array count:', len(eq['equipment_array']))"
   ```
3. **التحقق من تطابق كود المهام اليومية مع الذاكرة**:
   ```powershell
   python -c "import json; d = json.load(open('docs/sample_live_memory.json', encoding='utf-8')); ev = d.get('everydayTaskCtrl', {}); assert 'eventInfo' in ev; print('eventInfo keys:', list(ev['eventInfo'].keys()))"
   ```
