# تقرير استكشاف مدير البوت، خادم الـ API، وخط أنابيب قاعدة البيانات (Explorer Survey 2 Handoff)

**المسار**: `e:\intqam-sultan\.agents\teamwork\explorer_survey_2\handoff.md`  
**المهمة**: فحص البنية التحتية البرمجية لمدير البوت (`bot_manager.py`) وخادم الـ API (`api_server.py`) وقاعدة بيانات SQLite (`core/database.py` و `database/castles.db`) وتجهيز كود ترحيل قاعدة البيانات لمهمة تصنيع العتاد (`forge_equipment`).

---

## 1. الملاحظات المباشرة (Observation)

### أ. ملف مدير البوت (`bot_manager.py`)
1. **استيراد المهام وقائمة المهام المسجلة (`REGISTERED_TASKS`)**:
   - الموقع: السطور 43-61 والسطور 64-80:
   ```python
   # السطور 43-61
   from tasks import (
       BaseTask,
       TaskResult,
       PortTask,
       MerchantShipTask,
       TreasureTask,
       CityHarvestTask,
       TrainTask,
       ShieldTask,
       ResearchTask,
       FlowerTask,
       WonderMerchantTask,
       ImperialMausoleumTask,
       PetTask,
       MaterialSynthesisTask,
       CureWoundedTask,
       AllianceTask,
       WarMedalTask,
   )

   # السطور 64-80
   REGISTERED_TASKS = [
       PortTask,
       MerchantShipTask,
       ImperialMausoleumTask,
       CityHarvestTask,
       ShieldTask,
       ResearchTask,
       FlowerTask,
       WonderMerchantTask,
       MaterialSynthesisTask,
       CureWoundedTask,
       AllianceTask,
       WarMedalTask,
       PetTask,
       TreasureTask,
       TrainTask,
   ]
   ```
2. **الإعدادات الافتراضية للبوت (`DEFAULT_BOT_CONFIG`)**:
   - الموقع: السطور 96-156:
   ```python
   DEFAULT_BOT_CONFIG: Dict[str, Any] = {
       "enabled": True,
       "min_loop_interval_minutes": 40,
       "max_loop_interval_minutes": 60,
       "task_delay_min_seconds": 1.0,
       "task_delay_max_seconds": 3.0,
       "reconnect_wait_seconds": 30,
       "max_reconnect_attempts": 2,
       "tasks": {
           "port": {"enabled": True},
           "merchant_ship": {"enabled": True},
           "city_harvest": {"enabled": True},
           "imperial_mausoleum": {"enabled": True},
           "war_medal": {"enabled": True},
           "fountain": {...},
           "train": {...},
           "shield": {...},
           "research": {"enabled": False},
           "flower": {"enabled": False, "allow_gold": False},
           "wonder_merchant": {"enabled": False},
           "material_synthesis": {"enabled": False},
           "cure_wounded": {"enabled": False, "mode": "daily"},
           "pet": {"enabled": False, "target_pet": 1256},
           "alliance": {"enabled": False},
       }
   }
   ```
   - نلاحظ خلو `DEFAULT_BOT_CONFIG["tasks"]` حالياً من مفتاح `"forge_equipment"`.

3. **دالة إعادة تحميل الإعدادات من قاعدة البيانات (`reload_config_from_db`)**:
   - الموقع: السطور 225-249:
   ```python
   def reload_config_from_db(self):
       try:
           import core.database as db
           c_data = db.get_castle_by_id(self.email)
           if not c_data or not c_data.get("config"):
               return
           saved_cfg = c_data["config"] if isinstance(c_data["config"], dict) else json.loads(c_data["config"])
           if not isinstance(saved_cfg, dict):
               return

           tasks_cfg = self.config.setdefault("tasks", {})
           for t_name in ("fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
               if t_name in saved_cfg:
                   tasks_cfg[t_name] = saved_cfg[t_name]

           if "tasks" in saved_cfg and isinstance(saved_cfg["tasks"], dict):
               tasks_cfg.update(saved_cfg["tasks"])

           for k, v in saved_cfg.items():
               if k not in ("tasks", "fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
                   self.config[k] = v
       except Exception:
           pass
   ```
   - **ملاحظة حرجة**: يوجد مصفوفة أسماء مهام ثابتة (Hardcoded Tuple) في موضعين بالسطرين 237 و 245. إذا لم يُضف `"forge_equipment"` إليهما، فلن يتم نسخ إعدادات المهمة المحفوظة في جذر جدول قاعدة البيانات إلى قاموس `self.config["tasks"]` الداخلي، وسيتم معاملة المفتاح كإعداد عام بدلاً من إعداد مهمة!

4. **دورة حياة تنفيذ المهام وعزل الأخطاء (`execute_tasks`)**:
   - الموقع: السطور 554-613:
   - الدالة تستدعي `self.reload_config_from_db()` في بداية كل دورة.
   - تقوم بالمرور على كل كلاس مهمة في `REGISTERED_TASKS`، وقراءة `t_name = getattr(task_cls, "name", task_cls.__name__)`.
   - تستخرج الإعداد `t_cfg = tasks_config.get(t_name) or ...`.
   - تفحص التفعيل الصريح `is_user_enabled = t_cfg.get("enabled", default_enabled)`؛ وإذا كان `False` تتخطى المهمة بـ `continue`.
   - تنشئ كائناً جديداً لكل دورة: `task_instance = task_cls(self.conn, self.log, t_cfg)` وتنفذ `await task_instance.safe_execute()`.
   - عزل الأخطاء:
     - تُعيد رمي `ConcurrentLoginError` للتعامل مع رصد الدخول المتزامن من جهاز آخر.
     - تلتقط أي `Exception as e` آخر وتسجله في السجلات دون تعطيل حلقة القلعة.
     - في كتلة `finally`: تقوم صراحة بتصفير المراجع `task_instance = None; res = None` لمنع تراكم كائنات المهام في الذاكرة.

---

### ب. ملف خادم الـ API (`api_server.py`)
1. **نماذج التحقق Pydantic**:
   - الموقع: السطور 263-344:
   - توجد نماذج مخصصة للمهام التي تحتوي على إعدادات فرعية مثل `TrainConfig`, `ShieldConfig`, `CureWoundedConfig`, `PetConfig`.
   - نموذج إعدادات القلعة الموحد (`CastleConfigModel`):
   ```python
   class CastleConfigModel(BaseModel):
       fountain: Optional[FountainConfig] = None
       train: Optional[TrainConfig] = None
       shield: Optional[ShieldConfig] = None
       research: Optional[SimpleToggleConfig] = None
       flower: Optional[FlowerConfig] = None
       wonder_merchant: Optional[SimpleToggleConfig] = None
       material_synthesis: Optional[SimpleToggleConfig] = None
       cure_wounded: Optional[CureWoundedConfig] = None
       alliance: Optional[SimpleToggleConfig] = None
       war_medal: Optional[SimpleToggleConfig] = None
       pet: Optional[PetConfig] = None
   ```
   - خلو `CastleConfigModel` من أي تعريف لـ `forge_equipment`.

2. **فلتر التحديث وقائمة السماح (`clean_config`) في نقطة النهاية `PUT /api/castles/{castle_id}`**:
   - الموقع: السطور 581-611:
   ```python
   @app.put("/api/castles/{castle_id}")
   def update_castle(castle_id: str, req: CastleUpdateRequest, current_user: Dict[str, Any] = Depends(get_current_user)):
       ...
       if req.config is not None:
           clean_config = dict(castle.get("config") or {})
           clean_config.pop("pet_patrol", None)

           # استخراج الحقول المرسلة فقط بعد فحصها وتصفيتها تلقائياً عبر Pydantic
           validated_updates = req.config.model_dump(exclude_none=True)
           clean_config.update(validated_updates)
           updates["config"] = clean_config

       updated = db.update_castle_db(castle_id, updates, None if is_admin else current_user["uid"])
       
       em = castle.get("email") or (updated.get("email") if updated else "")
       bot = bot_manager.get_bot(em)
       if bot:
           bot.reload_config_from_db()
       ...
   ```
   - **ملاحظة حرجة**: نظراً لأن `req.config` هو كائن من `CastleConfigModel`، فإن استدعاء `req.config.model_dump(exclude_none=True)` سيتجاهل تماماً مفتاح `forge_equipment` إن لم يكن معرّفاً داخل `CastleConfigModel`، ولن يصل إلى `clean_config` أو قاعدة البيانات إطلاقاً!

3. **نقاط النهاية لاستعلام القلاع**:
   - `GET /api/castles`: تعيد كافة القلاع من SQLite مع فك تشفير JSON لحقل `config`.
   - `GET /api/castles/{castle_id}`: تعيد تفاصيل القلعة المحددة مع `config`.
   - `GET /api/castles/data/{email:path}`: تعيد البيانات اللحظية من كائن `CastleBot` النشط أو قاعدة البيانات.

---

### ج. قاعدة البيانات (`core/database.py` و `database/castles.db`)
1. **آلية تخزين واسترجاع الإعدادات في SQLite**:
   - الموقع: السطور 93-111، 177-223، 275-290، 402-419 في `core/database.py`.
   - الجدول: `castle_states`.
   - حقل الإعدادات: `config TEXT DEFAULT '{}'`.
   - دالة `_row_to_castle(row)` تحول نص الـ JSON في عمود `config` إلى `dict` بايثون تلقائياً.
   - دالة `save_castle(castle_data)` تقوم بتشفير `dict` إلى نص JSON عبر `json.dumps(cfg, ensure_ascii=False)`.

2. **الفحص الفعلي المباشر لملف `database/castles.db`**:
   - تم تشغيل سكربت الفحص المباشر `inspect_db.py` على ملف قاعدة البيانات الفعلي.
   - **عدد القلاع الإجمالي**: 4 قلاع.
   - **بيانات القلاع الفعلية**:
     1. `sultan_beetoo1` (`beetoo1@hotmail.com`): يحتوي `config` على 12 مفتاحاً.
     2. `sultan_beetoo2` (`beetoo2@hotmail.com`): يحتوي `config` على 12 مفتاحاً.
     3. `sultan_beetoo3` (`beetoo3@hotmail.com`): يحتوي `config` على 12 مفتاحاً.
     4. `sultan_LUCIFER` (`LUCIFER@g4.com`): يحتوي `config` على 11 مفتاحاً.
   - **المفاتيح الموجودة في كائن الـ JSON**:
     `fountain`, `train`, `shield`, `research`, `flower`, `wonder_merchant`, `imperial_mausoleum`, `pet`, `material_synthesis`, `cure_wounded`, `alliance`, `tasks` (تحتوي على `war_medal`).
   - **النتيجة**: لا تحتوي أي قلعة حالياً على المفتاح `forge_equipment`.

---

## 2. سلسلة المنطق والاستنتاج (Logic Chain)

1. **الاستناد إلى الملاحظة أ-1 وأ-2**:
   - بما أن حلقة البوت في `bot_manager.py` تنفذ فقط المهام المدرجة في `REGISTERED_TASKS` وتقرأ إعداداتها من `DEFAULT_BOT_CONFIG`، فإن إدراج مهمة `ForgeEquipmentTask` يستلزم:
     1. استيراد الكلاس من `tasks`.
     2. إضافته إلى قائمة `REGISTERED_TASKS` (الموضع المثالي: بعد `MaterialSynthesisTask`، لكونهما يخصان ورشة الحدادة والنشاط اليومي).
     3. تسجيل الإعداد الافتراضي داخل `DEFAULT_BOT_CONFIG["tasks"]`:
        ```python
        "forge_equipment": {"enabled": False, "category": "weapon"},
        ```

2. **الاستناد إلى الملاحظة أ-3**:
   - بما أن دالة `reload_config_from_db()` في `bot_manager.py` تقوم بتصفية مفاتيح المهام من جدول قاعدة البيانات باستخدام قائمة أسماء ثابتة في السطرين 237 و 245، فإن عدم إضافة `"forge_equipment"` سيؤدي إلى فشل تحديث إعدادات المهمة الحية عند قيام المستخدم بتغيير الصنف أو تفعيل المهمة من الواجهة.
   - يلزم تحديث كلا السطرين لإدراج `"forge_equipment"`.

3. **الاستناد إلى الملاحظة ب-1 وب-2**:
   - بما أن `api_server.py` يقوم بتصفية الإعدادات القادمة من الواجهة الأمامية عبر نموذج `CastleConfigModel` بواسطة `req.config.model_dump(exclude_none=True)`، فإن أي مفتاح غير موجود في النموذج يتم حذفه فوراً.
   - يلزم إنشاء نموذج `ForgeEquipmentConfig`:
     ```python
     class ForgeEquipmentConfig(BaseModel):
         enabled: bool = False
         category: Literal["weapon", "clothes", "helmet", "trousers", "shoes", "ring"] = "weapon"

         @field_validator("category", mode="before")
         @classmethod
         def normalize_category(cls, v: Any) -> str:
             val = str(v or "weapon").lower().strip()
             return val if val in ("weapon", "clothes", "helmet", "trousers", "shoes", "ring") else "weapon"
     ```
   - وإضافته إلى `CastleConfigModel`:
     ```python
     forge_equipment: Optional[ForgeEquipmentConfig] = None
     ```

4. **الاستناد إلى الملاحظة ج-1 وج-2 والـ GEMINI.md Rules 3 & 5**:
   - بما أن قاعدة البيانات `database/castles.db` تضم 4 قلاع نشطة حالياً خالية من المفتاح `forge_equipment`، ولضمان عدم حدوث أخطاء `KeyError` أو تفاوت في الواجهة الأمامية، يجب تشغيل سكربت ترحيل (Migration Script) يقوم بتحديث القلاع الأربع بالقيم الافتراضية `{"enabled": False, "category": "weapon"}` دون المساس بأي من إعداداتها السابقة.
   - تم اختبار خوارزمية الترحيل في الذاكرة بنجاح تام (100% نجاح واحتفاظ كامل بالمفاتيح السابقة).

---

## 3. المحاذير والاستثناءات (Caveats)

1. **الذاكرة المشتركة بين خادم الـ API وعمليات البوت**:
   - خادم `api_server.py` يقوم باستدعاء `bot.reload_config_from_db()` فقط إذا كان البوت قيد التشغيل في كائن `bot_manager` المشترك بنفس العملية.
   - إذا تم تشغيل `bot_manager.py` كعملية CLI منفصلة عن `api_server.py`، فإن `bot_manager` يقوم تلقائياً باستدعاء `self.reload_config_from_db()` في بداية كل دورة تنفيذ في السطر 561 (`execute_tasks`)، وبالتالي سيقرأ التحديثات من قاعدة البيانات فور بدء الدورة الجديدة.
2. **عدم تنفيذ التعديلات في هذه المرحلة**:
   - التزاماً بالدور الاستكشافي للقائم بالمسح (Survey Explorer) ودستور المشروع في `GEMINI.md` (البند 8: حظر التعديل المسبق)، لم يتم إجراء أي تعديل فعلي على ملفات الكود أو ملف قاعدة البيانات الحقيقي؛ وتم الاكتفاء بالفحص المباشر وإعداد الأكواد بدقة تامة.

---

## 4. الاستنتاج والكود المقترح (Conclusion & Proposed Code)

### أ. التعديلات الدقيقة المطلوبة في `bot_manager.py`

#### 1. استيراد الكلاس (سطر 60):
```python
# Before (Line 60):
    AllianceTask,
    WarMedalTask,
)

# After:
    AllianceTask,
    WarMedalTask,
    ForgeEquipmentTask,
)
```

#### 2. التسجيل في `REGISTERED_TASKS` (سطر 73):
```python
# Before (Line 73):
    MaterialSynthesisTask,
    CureWoundedTask,

# After:
    MaterialSynthesisTask,
    ForgeEquipmentTask,
    CureWoundedTask,
```

#### 3. الإعداد الافتراضي في `DEFAULT_BOT_CONFIG` (سطر 144):
```python
# Before (Line 144):
        "material_synthesis": {               # تجميع المواد بورشة الحدادة (النشاط اليومي)
            "enabled": False,
        },
        "cure_wounded": {                     # علاج المصابين بالخيمة الطبية (النشاط اليومي)

# After:
        "material_synthesis": {               # تجميع المواد بورشة الحدادة (النشاط اليومي)
            "enabled": False,
        },
        "forge_equipment": {                  # تصنيع العتاد بورشة الحدادة (النشاط اليومي)
            "enabled": False,
            "category": "weapon",
        },
        "cure_wounded": {                     # علاج المصابين بالخيمة الطبية (النشاط اليومي)
```

#### 4. تحديث مصفوفتي المهام في `reload_config_from_db` (السطرين 237 و 245):
```python
# Before (Line 237):
            for t_name in ("fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
                if t_name in saved_cfg:
                    tasks_cfg[t_name] = saved_cfg[t_name]

# After:
            for t_name in ("fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
                if t_name in saved_cfg:
                    tasks_cfg[t_name] = saved_cfg[t_name]
```
```python
# Before (Line 245):
            for k, v in saved_cfg.items():
                if k not in ("tasks", "fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
                    self.config[k] = v

# After:
            for k, v in saved_cfg.items():
                if k not in ("tasks", "fountain", "train", "shield", "research", "flower", "wonder_merchant", "material_synthesis", "forge_equipment", "cure_wounded", "city_harvest", "port", "merchant_ship", "imperial_mausoleum", "pet", "alliance", "war_medal"):
                    self.config[k] = v
```

---

### ب. التعديلات الدقيقة المطلوبة في `api_server.py`

#### 1. إضافة نموذج التحقق `ForgeEquipmentConfig` (بعد سطر 300):
```python
class ForgeEquipmentConfig(BaseModel):
    enabled: bool = False
    category: Literal["weapon", "clothes", "helmet", "trousers", "shoes", "ring"] = "weapon"

    @field_validator("category", mode="before")
    @classmethod
    def normalize_category(cls, v: Any) -> str:
        val = str(v or "weapon").lower().strip()
        return val if val in ("weapon", "clothes", "helmet", "trousers", "shoes", "ring") else "weapon"
```

#### 2. إدراج المهمة في `CastleConfigModel` (سطر 335):
```python
# Before (Line 334):
    alliance: Optional[SimpleToggleConfig] = None
    war_medal: Optional[SimpleToggleConfig] = None
    pet: Optional[PetConfig] = None

# After:
    alliance: Optional[SimpleToggleConfig] = None
    war_medal: Optional[SimpleToggleConfig] = None
    pet: Optional[PetConfig] = None
    forge_equipment: Optional[ForgeEquipmentConfig] = None
```

---

### ج. سكربت ترحيل قاعدة البيانات المعتمد والخالي من أي فقدان بيانات (`migrate_castles_forge_equipment.py`)

كود بايثون متكامل ومستقل يضمن:
1. أخذ نسخة احتياطية فورية قبل أي كتابة (`castles.db.bak_{timestamp}`).
2. قراءة كل قلعة وتحديث حقل `config` بإضافة `forge_equipment: {"enabled": False, "category": "weapon"}` دون المساس بأي إعداد موجود.
3. التحقق الذاتي الصارم بعد التحديث والتأكد من نجاح العملية لكل القلاع بنسبة 100%.

```python
# -*- coding: utf-8 -*-
"""
scripts/migrate_castles_forge_equipment.py
ترحيل آمن لقاعدة بيانات castles.db لإضافة إعدادات forge_equipment الافتراضية لجميع القلاع
"""

import os
import shutil
import sqlite3
import json
from datetime import datetime, timezone

DB_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "database", "castles.db")

def run_migration():
    if not os.path.exists(DB_PATH):
        print(f"[-] ملف قاعدة البيانات غير موجود في المسار: {DB_PATH}")
        return False

    # 1. إنشاء نسخة احتياطية أولاً
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = f"{DB_PATH}.bak_{timestamp}"
    shutil.copy2(DB_PATH, backup_path)
    print(f"[✓] تم إنشاء نسخة احتياطية آمنة في: {backup_path}")

    # 2. فتح الاتصال وتحديث السجلات داخل Transaction
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT castle_id, config FROM castle_states")
        rows = cursor.fetchall()
        print(f"[*] جاري فحص وترحيل {len(rows)} قلعة...")

        updated_count = 0
        now_iso = datetime.now(timezone.utc).isoformat()

        for row in rows:
            cid = row["castle_id"]
            cfg_raw = row["config"]
            cfg = json.loads(cfg_raw) if cfg_raw else {}

            if "forge_equipment" not in cfg or not isinstance(cfg["forge_equipment"], dict):
                cfg["forge_equipment"] = {"enabled": False, "category": "weapon"}
            else:
                cfg["forge_equipment"].setdefault("enabled", False)
                cfg["forge_equipment"].setdefault("category", "weapon")

            new_cfg_str = json.dumps(cfg, ensure_ascii=False)
            cursor.execute(
                "UPDATE castle_states SET config = ?, updated_at = ? WHERE castle_id = ?",
                (new_cfg_str, now_iso, cid)
            )
            updated_count += 1

        conn.commit()
        print(f"[✓] تم تحديث وحفظ {updated_count} قلعة بنجاح.")

        # 3. التحقق الصارم بعد التحديث (Post-migration Verification)
        cursor.execute("SELECT castle_id, config FROM castle_states")
        verify_rows = cursor.fetchall()
        for r in verify_rows:
            v_cfg = json.loads(r["config"])
            assert "forge_equipment" in v_cfg, f"فشل التحقق: القلعة {r['castle_id']} لا تحتوي على forge_equipment"
            assert v_cfg["forge_equipment"].get("category") == "weapon", f"الصنف الافتراضي غير صحيح في {r['castle_id']}"
            assert v_cfg["forge_equipment"].get("enabled") is False, f"حالة التفعيل الافتراضية غير صحيحة في {r['castle_id']}"

        print("[✓✓✓] اكتمل التحقق البرمجي المباشر بنسبة 100%: جميع القلاع تم تحديثها بسلام دون أي فقدان بيانات.")
        return True

    except Exception as e:
        conn.rollback()
        print(f"[❌] حدث خطأ أثناء الترحيل: {e}")
        print("[!] جاري استعادة النسخة الاحتياطية...")
        shutil.copy2(backup_path, DB_PATH)
        return False
    finally:
        conn.close()

if __name__ == "__main__":
    run_migration()
```

---

## 5. طريقة التحقق المستقلة (Verification Method)

لأي وكيل أو للمطور للتحقق من صحة هذه النتائج بشكل مستقل:

1. **التحقق من كود `bot_manager.py`**:
   - استعراض الأسطر 64-80 للتأكد من بنية `REGISTERED_TASKS`.
   - استعراض الأسطر 230-249 للتأكد من مصفوفة الأسماء في `reload_config_from_db`.
2. **التحقق من كود `api_server.py`**:
   - استعراض الأسطر 323-335 للتأكد من بنية `CastleConfigModel`.
   - استعراض الأسطر 593-603 للتأكد من منطق الفلترة في `clean_config`.
3. **التحقق المباشر من ملف قاعدة البيانات**:
   - تشغيل الأمر التالي في سطر الأوامر لقراءة وفحص ملف `database/castles.db` مباشرة:
   ```powershell
   python .agents/teamwork/explorer_survey_2/inspect_db.py
   ```
   - سيظهر وجود 4 قلاع وقوائم مفاتيحها الحالية وخلوها من `forge_equipment`.
4. **شروط إبطال التقرير (Invalidation Conditions)**:
   - في حال إضافة أو حذف أي قلعة في قاعدة البيانات قبل تشغيل الترحيل (سيتغير عدد القلاع عن 4 لكن خوارزمية الترحيل مصممة لترحيل أي عدد ديناميكياً).
   - في حال تعديل هيكلية `REGISTERED_TASKS` في `bot_manager.py` من قِبل وكيل آخر.
