# هيكلية ومعمارية المشروع الشاملة (Project Architecture & Structure Guide)

هذا الدليل يوضح الهيكل الدقيق لمشروع بوت **"انتقام السلاطين" (Intqam-Sultan)**، ملفاته الأساسية، ومسؤولية كل جزء، لمنع أي خلط أو أخطاء برمجية وضمان تدفق العمل بسلاسة وأمان.

---

## 1. المعمارية العامة للنظام (System Architecture Overview)
النظام مبني كمنصة روبوتية ذاتية التشغيل بالكامل:
1. **بروتوكول شبكي مخصص:** اتصال TCP مباشر مشفر بـ DES مع سيرفرات اللعبة يحاكي تطبيق الهاتف الرسمي.
2. **محرك إدارة وتنسيق المهام (Orchestrator):** `bot_manager.py` يدير خيوط الاتصال المستقلة والمهام المجدولة لكل قلعة.
3. **خادم الواجهة الخلفية (Backend API):** `api_server.py` مبني بـ FastAPI ويوفر واجهات التحكم وتوثيق الحسابات.
4. **لوحة التحكم الأمامية (Frontend Dashboard):** مبنية بـ React 18 + TypeScript + Vite + Tailwind CSS.
5. **قاعدة البيانات (Database):** SQLite (`database/castles.db`) لتخزين بيانات القلاع والإعدادات بصيغة JSON.

---

## 2. تفصيل المجلدات والملفات الأساسية (Directory & File Map)

### أ. النواة والاتصال الشبكي (`core/`)
* **`core/game_client.py`:**
  * قلب الاتصال الشبكي باللعبة.
  * إدارة مقابس TCP، التشفير وفك التشفير عبر `des_key.bin`.
  * حزم البيانات، المصافحة (Handshake)، نبضات القلب (Heartbeat)، وفك تشفير الرسائل الواردة.
  * **الذاكرة الحية (`conn.init_data`):** يحتوي على كامل كائنات اللعبة (`storesCtrl`, `bagCtrl`, `everydayTaskCtrl`, إلخ) المحدثة مباشرة من السيرفر.
  * إرسال الطلبات الرسمية فقط عبر `query()` أو `send_and_wait()`.
* **`core/database.py`:**
  * طبقة الاستعلام والتحديث لقاعدة بيانات SQLite (`castles.db`).
  * عمليات القراءة والكتابة الخاصة بالحسابات والقلاع والاشتراكات.
* **`core/tenants.py`:**
  * منطق إدارة الحسابات المتعددة وتوزيع القلاع على المستخدمين والصلاحيات.

---

### ب. مهام البوت المستقلة (`tasks/`)
* **`tasks/base_task.py`:**
  * الفئة الأساسية (Base Class) لجميع مهام البوت والمستودع المركزي لكافة دوال منطق اللعبة الأصلي (Game-Authentic Logic).
  * محكوم بالمعيار الصارم للدوال (القاعدة 14 في الدستور): الاعتماد الأولي على الذاكرة الحية (0-Network Direct Read)، والاستعلام الاحتياطي المشروط بالتحذير الصارخ، والتسكين الوظيفي المنظم بالأقسام، وبساطة الكود (KISS).
  * تحدد دورة حياة المهمة (`run`, `interval`, `enabled`, `is_active`).
  * توفر أدوات الاستعلام الآمن والحماية من التعليق مع توثيق السجلات (Logging).
* **ملفات المهام التخصصية:**
  * `tasks/wonder_merchant.py`: مهمة التاجر العجيب (شراء الأصناف بغير الذهب، التحديث المجاني، وإكمال النشاط اليومي `CMD 1024`).
  * `tasks/flower.py`: مهمة ترتيب وإهداء الزهور (إرسال باقات الورد للأعضاء وفق الأولويات `CMD 1010` و `CMD 1029`).
  * `tasks/train.py`: تدريب الجنود بمختلف الفئات (مشاة، فرسان، رماة، عربات) وحساب سعة التدريب بدقة.
  * `tasks/shield.py`: إدارة درع الحماية الذاتي (تجديد الدروع لمنع التعرض للهجوم).
  * `tasks/research.py`: إدارة بحوث المعهد الموصى بها.
  * `tasks/city_harvest.py`: جمع الموارد تلقائياً من مباني المدينة داخل القلعة.
  * `tasks/treasure.py`: نافورة الثروة والسحب اليومي.
  * `tasks/imperial_mausoleum.py`: استكشاف الضريح الملكي.
  * `tasks/merchant_ship.py`: مبادلة الموارد في سفينة التاجر.
  * `tasks/port.py`: استلام مكافآت الميناء الدورية.
* **`tasks/__init__.py`:**
  * ملف التصدير المركزي، يجمع كافة الفئات لتسهيل استيرادها في `bot_manager.py`.

---

### ج. المشغل والمنسق المركزي (`bot_manager.py`)
* يدير كائن `BotManager` المسؤول عن دورة حياة تشغيل كل القلاع.
* **قاموس المهام المسجلة (`REGISTERED_TASKS`):** يربط الاسم البرمجي للمهمة بفئتها المنفذة.
* **الإعدادات الافتراضية (`DEFAULT_BOT_CONFIG`):** الهيكل الأساسي لإعدادات أي قلعة جديدة.
* **دالة `reload_config_from_db()`:** قراءة الإعدادات المحدثة من SQLite فور قيام المستخدم بحفظها في الواجهة وتطبيقها فوراً على المهام الجارية دون الحاجة لإعادة تشغيل البوت بالكامل.

---

### د. خادم الـ API الخلفي (`api_server.py`)
* خادم FastAPI يعمل على المنفذ `8080`.
* يدير عمليات تسجيل الدخول (Firebase Auth)، جلب القلاع، وحفظ التعديلات.
* **نقطة التدقيق الحرجة (`clean_config`):**
  * دالة لتنقية وتصفية بيانات الـ JSON القادمة من الواجهة قبل كتابتها في قاعدة البيانات.
  * **تنبيه حاسم:** أي مهمة جديدة تُضاف للواجهة **يجب** إضافتها في فلتر `clean_config`، وإلا سيقوم السيرفر بتجاهلها وحذفها قبل الوصول لـ SQLite!

---

### هـ. لوحة التحكم والواجهة الأمامية (`dashboard/`)
* **`src/types/index.ts`:**
  * يحتوي على واجهة `CastleConfig` و `DEFAULT_CASTLE_CONFIG`. يحدد شكل البيانات لكل المهام.
* **`src/hooks/useCastles.ts`:**
  * دالة `mergeConfigWithDefaults`: تضمن أن القلاع المحملة من الخادم يتم دمجها مع القيم الافتراضية حتى لو كانت قديمة في قاعدة البيانات.
* **`src/components/accounts/TaskTabContent.tsx`:**
  * مكون تبويب المهام في لوحة التحكم.
  * يحتوي على أزرار التفعيل (Toggles) والخيارات التفصيلية.
  * **محورا الحفظ الحرجان (Must be updated for ANY new task):**
    1. دالة `performSave()` (الحفظ التلقائي عند التبديل).
    2. دالة `handleSave()` (زر الحفظ اليدوي).
    *(يجب أن يشملا أي مهمة جديدة لضمان إرسالها إلى الـ API)*.
* **`src/locales/` (`ar.json`, `en.json`, `tr.json`):**
  * نصوص الترجمة لأسماء المهام، خياراتها، وتلميحاتها المساعدة.

---

### و. قاعدة البيانات (`database/castles.db`)
* قاعدة بيانات SQLite المركزية.
* جدول `castles` يحفظ: `id`, `name`, `user_id`, `credentials`, وعمود `config` (نص JSON يحتوي على حالة وخيارات كل المهام).

---

### ز. ملفات اللعبة المفككة والمرجعية (`game_file/` & `docs/`)
* **`game_file/src/`:** كود اللعبة المصدري المكتوب بلغة Lua (مثل `storesCtrl.lua`, `everydayTaskCtrl.lua`, `gameIDDef.lua`).
  * يُمنع التخمين أو افتراض معرفات العناصر أو أكواد الـ CMD؛ يجب الرجوع دائماً لهذه الملفات للتحقق.
* **`docs/live_memory_guide.md` & `sample_live_memory.json`:**
  * توثيق كامل لشكل الذاكرة الحية `conn.init_data` ومسارات البيانات فيها (0-Network Verification).

---

### ح. أدوات وسكربتات الاختبار والفحص الميداني (`tools/`)
* **المستودع المركزي لكافة الأدوات:** تم نقل وتوحيد جميع أدوات الفحص، التشغيل، والتحديث الميداني إلى مجلد `tools/`:
  * `tools/refresh_live_memory.py`: تفريغ وتحديث كائنات الذاكرة الحية للحسابات وحفظها في `docs/`.
  * `tools/test_task_method.py`: أداة التشغيل والفحص الميداني الأساسية للمهام عبر الحسابات الحقيقية.
  * `tools/test_empirical_challenger.py`: سكربت التحدي الميداني والتأكد من استقرار المنطق وتطبيق الفواصل البشرية.
  * `tools/test_ensure_resources.py`: فحص وتأمين الموارد وحقيبة القلعة دون استهلاك ذهب.
  * `tools/test_vip_slots_speedup.py`: فحص طوابير البناء والتدريب وميزات وتسريعات الـ VIP.
  * `tools/check_accounts_state.py`: فحص حالة اتصالات الحسابات، وصحة الجلسات والتفويض.
* **قاعدة تنظيمية إلزامية لكافة الوكلاء:**
  يُحظر تماماً وضع أو ترك أي أداة أو سكربت فحص في المجلد الرئيسي للجذر (Root)؛ وأي أداة جديدة يتم إنشاؤها مستقبلاً أثناء عمل الوكلاء **يجب حصراً وإلزاماً وضعها داخل مجلد `tools/`**.

---

## 3. المسار الإلزامي الصارم لإضافة أي مهمة جديدة (The 6-Stage Task Pipeline)
لكي تظهر أي مهمة جديدة للمستخدم وتعمل بنسبة 100% دون فقدان البيانات في قاعدة البيانات:
1. **Task Class:** إنشاء ملف المهمة داخل `tasks/` وتصديرها في `tasks/__init__.py`.
2. **Bot Manager Registration:** تسجيل المهمة في `bot_manager.py` داخل:
   - `REGISTERED_TASKS`
   - `DEFAULT_BOT_CONFIG["tasks"]`
   - دالة `reload_config_from_db()`
3. **API Whitelist:** إضافة مفتاح المهمة في فلتر الحفظ `clean_config` داخل `api_server.py`.
4. **Database Migration:** تنفيذ سكربت ترحيل لتحديث القلاع الحالية في `database/castles.db` بإعدادات المهمة الافتراضية.
5. **Frontend State & Defaults:** تحديث `dashboard/src/types/index.ts` و `useCastles.ts`.
6. **Frontend UI & Dual-Save:** إضافة الصف في `TaskTabContent.tsx` وتضمين المفتاح في **كلا** الدالتين:
   - `performSave()`
   - `handleSave()`
   مع إضافة الترجمات في ملفات `src/locales/`.

---

## 4. الهيكل البرمجي القياسي للمهمة (Standard Task Code Template)
كل مهمة جديدة تُبنى في `tasks/<task_name>.py` يجب أن تتبع النمط المعياري الموحد للمشروع:

```python
import asyncio
import logging
from typing import Dict, Any, Optional
from tasks.base_task import BaseTask

class CustomNewTask(BaseTask):
    """
    اسم المهمة بالعربية: وصف دقيق للمهمة
    البروتوكول الرسمي: CMD xxx / SUBCMD yyy
    """
    def __init__(self, bot, config: Optional[Dict[str, Any]] = None):
        super().__init__(bot, config)
        self.name = "task_key"          # يجب أن يطابق تماماً المفتاح في الإعدادات والواجهة
        self.interval = 300             # الفاصل الزمني الافتراضي بين الدورات (بالثواني)

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة الحالية"""
        return bool(self.config.get("enabled", False))

    async def execute(self) -> bool:
        """
        دورة التنفيذ الأساسية مع الالتزام الصارم بـ:
        1. 0-Network Pre-flight check (الاعتماد على الذاكرة الحية conn.init_data)
        2. safe_query للاستعلامات الضرورية فقط
        3. تحديث الذاكرة الحية ذاتياً بعد نجاح الطلب
        4. عزل الأخطاء لمنع تعطيل حلقة القلعة
        """
        if not self.is_active:
            return False

        conn = self.bot.conn
        if not conn or not conn.init_data:
            return False

        try:
            # 1. فحص الذاكرة الحية (0-Network)
            # مثال: if condition_not_met: return True

            # 2. إرسال الطلب الرسمي الوحيد
            # resp = await self.safe_query("CMD", "SUBCMD", params)

            # 3. تحديث الذاكرة محلياً
            # conn.init_data["ctrl"]["property"] = new_value

            return True
        except Exception as e:
            self.logger.error(f"[{self.name}] خطأ غير متوقع: {e}", exc_info=True)
            return False
```

