# -*- coding: utf-8 -*-
"""
tasks/base_task.py — الكلاس الأب الموحد لجميع مهام البوت (BaseTask & TaskResult)
═══════════════════════════════════════════════════════════════════════════════════
يوفر بنية تحتية صلبة ومرنة لكل مهام اللعبة:
  1. كائن نتيجة موحد (TaskResult) لتوحيد مخرجات المهام وسجلات الأخطاء.
  2. استخراج فوري صفر استهلاك للشبكة (0-Network) لبيانات الحساب:
     - رقم المملكة (kingdom_id)
     - كمية طاقة اللورد / الصحة (stamina / health)
     - الذهب والموارد ومستوى القلعة ودرع السلام
  3. استعلام آمن ومحاكاة بشرية (safe_query) بإدراج Jitter زمني عشوائي.
  4. فحص قبلي مشروط (can_run) وتغليف آمن مانع للأخطاء (safe_execute).
"""

from __future__ import annotations

import asyncio
from abc import ABC, abstractmethod
import math
import random
import sys
import time
from typing import Any, Callable, Dict, Optional, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


class TaskResult:
    """يمثل النتيجة الموحدة لتنفيذ أي مهمة في البوت."""

    def __init__(
        self,
        success: bool,
        message: str = "",
        skipped: bool = False,
        data: Optional[Dict[str, Any]] = None,
        execution_time: float = 0.0,
    ):
        self.success = success
        self.message = message
        self.skipped = skipped
        self.data = data or {}
        self.execution_time = execution_time

    @classmethod
    def ok(cls, msg: str = "", data: Optional[Dict[str, Any]] = None, exec_time: float = 0.0) -> TaskResult:
        """نجاح تنفيذ المهمة."""
        return cls(success=True, message=msg, skipped=False, data=data, execution_time=exec_time)

    @classmethod
    def skip(cls, msg: str = "", exec_time: float = 0.0) -> TaskResult:
        """تخطي المهمة لعدم تحقق الشروط أو عدم الجاهزية (بدون خطأ)."""
        return cls(success=True, message=msg, skipped=True, execution_time=exec_time)

    @classmethod
    def fail(cls, msg: str = "", exec_time: float = 0.0) -> TaskResult:
        """فشل تنفيذ المهمة مع تسجيل السبب."""
        return cls(success=False, message=msg, skipped=False, execution_time=exec_time)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "success": self.success,
            "message": self.message,
            "skipped": self.skipped,
            "data": self.data,
            "execution_time": round(self.execution_time, 3),
        }

    def __repr__(self) -> str:
        status = "SKIPPED" if self.skipped else ("OK" if self.success else "FAILED")
        return f"<TaskResult [{status}]: {self.message}>"


# ═════════════════════════════════════════════════════════════════════════
# جداول حزم وصناديق الموارد الرسمية للعبة (عادية وآمنة مرتبة تنازلياً)
# ═════════════════════════════════════════════════════════════════════════

RESOURCE_KEY_MAP: Dict[str | int, str] = {
    # 1. القمح (Food)
    "food": "food", "wheat": "food", "قمح": "food", "القمح": "food", "1002": "food", 1002: "food",
    # 2. الخشب (Wood)
    "wood": "wood", "خشب": "wood", "الخشب": "wood", "1003": "wood", 1003: "wood",
    # 3. الحديد (Iron)
    "iron": "iron", "حديد": "iron", "الحديد": "iron", "1004": "iron", 1004: "iron",
    # 4. الفضة (Silver)
    "silver": "silver", "فضة": "silver", "الفضة": "silver", "mithril": "silver", "1005": "silver", 1005: "silver",
    # 5. البلور (Crystal)
    "crystal": "crystal", "بلور": "crystal", "البلور": "crystal", "1027": "crystal", 1027: "crystal",
}

RESOURCE_CATALOG: Dict[str, Dict[str, Any]] = {
    "food": {
        "name_ar": "القمح",
        "res_id": "1002",
        "unlock_level": 1,
        # صناديق القمح العادية (1003xx) مرتبة تنازلياً من الأكبر للأصغر
        "normal_boxes": [
            (100309, 15_000_000),
            (100308, 5_000_000),
            (100307, 1_500_000),
            (100306, 500_000),
            (100305, 150_000),
            (100304, 50_000),
            (100303, 30_000),
            (100302, 10_000),
            (100301, 1_000),
        ],
        # باقات وصناديق القمح الآمنة (1101xx) مرتبة تنازلياً
        "safe_boxes": [
            (110117, 300_000_000),
            (110113, 150_000_000),
            (110103, 50_000_000),
            (110116, 50_000_000),
            (110112, 15_000_000),
            (110106, 5_000_000),
            (110111, 1_500_000),
            (110110, 500_000),
            (110109, 150_000),
            (110115, 150_000),
            (110102, 50_000),
            (110108, 30_000),
            (110101, 10_000),
            (110107, 1_000),
            (110114, 1_000),
        ],
    },
    "wood": {
        "name_ar": "الخشب",
        "res_id": "1003",
        "unlock_level": 1,
        # صناديق الخشب العادية (1002xx) مرتبة تنازلياً
        "normal_boxes": [
            (100209, 15_000_000),
            (100208, 5_000_000),
            (100207, 1_500_000),
            (100206, 500_000),
            (100205, 150_000),
            (100204, 50_000),
            (100203, 30_000),
            (100202, 10_000),
            (100201, 1_000),
        ],
        # باقات وصناديق الخشب الآمنة (1100xx) مرتبة تنازلياً
        "safe_boxes": [
            (110017, 300_000_000),
            (110013, 150_000_000),
            (110003, 50_000_000),
            (110016, 50_000_000),
            (110012, 15_000_000),
            (110006, 5_000_000),
            (110011, 1_500_000),
            (110010, 500_000),
            (110009, 150_000),
            (110015, 150_000),
            (110002, 50_000),
            (110008, 30_000),
            (110001, 10_000),
            (110007, 1_000),
            (110014, 1_000),
        ],
    },
    "iron": {
        "name_ar": "الحديد",
        "res_id": "1004",
        "unlock_level": 10,
        # صناديق الحديد العادية (1005xx) مرتبة تنازلياً
        "normal_boxes": [
            (100509, 2_500_000),
            (100508, 800_000),
            (100507, 250_000),
            (100506, 80_000),
            (100505, 25_000),
            (100504, 8_000),
            (100503, 5_000),
            (100502, 1_600),
            (100501, 150),
        ],
        # باقات وصناديق الحديد الآمنة (1102xx) مرتبة تنازلياً
        "safe_boxes": [
            (110217, 50_000_000),
            (110211, 25_000_000),
            (110203, 8_000_000),
            (110216, 8_000_000),
            (110210, 2_500_000),
            (110206, 800_000),
            (110205, 250_000),
            (110209, 80_000),
            (110215, 80_000),
            (110208, 25_000),
            (110214, 25_000),
            (110202, 8_000),
            (110201, 1_600),
            (110207, 150),
            (110213, 150),
        ],
    },
    "silver": {
        "name_ar": "الفضة",
        "res_id": "1005",
        "unlock_level": 15,
        # صناديق الفضة العادية (1006xx) مرتبة تنازلياً
        "normal_boxes": [
            (100609, 625_000),
            (100608, 200_000),
            (100607, 62_500),
            (100606, 20_000),
            (100605, 6_250),
            (100604, 2_000),
            (100603, 400),
            (100602, 160),
            (100601, 80),
            (100600, 40),
        ],
        # باقات وصناديق الفضة الآمنة (1103xx) مرتبة تنازلياً
        "safe_boxes": [
            (110317, 12_500_000),
            (110311, 6_250_000),
            (110303, 2_000_000),
            (110315, 2_000_000),
            (110310, 625_000),
            (110306, 200_000),
            (110305, 62_500),
            (110309, 20_000),
            (110314, 20_000),
            (110308, 6_250),
            (110313, 6_250),
            (110302, 2_000),
            (110301, 400),
            (110307, 40),
            (110312, 40),
        ],
    },
    "crystal": {
        "name_ar": "البلور",
        "res_id": "1027",
        "unlock_level": 60,
        # صناديق البلور العادية (1027xx) مرتبة تنازلياً
        "normal_boxes": [
            (102706, 50_000),
            (102705, 15_000),
            (102704, 5_000),
            (102703, 1_500),
            (102702, 500),
            (102701, 100),
        ],
        # باقات وصناديق البلور الآمنة (1106xx) مرتبة تنازلياً
        "safe_boxes": [
            (110608, 3_000_000),
            (110607, 1_500_000),
            (110606, 50_000),
            (110605, 15_000),
            (110603, 15_000),
            (110604, 5_000),
            (110602, 500),
            (110601, 100),
        ],
    },
}


class BaseTask(ABC):
    """
    الكلاس الأساسي التجريدي لجميع مهام البوت (Revenge of Sultans Tasks).
    """
    name: str = "base_task"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        self.conn = conn
        self._log_func = log_func
        self.config = config or {}

    def log(self, message: str):
        """تسجيل الملاحظات والسجلات موجهة لنظام البوت."""
        if self._log_func:
            try:
                self._log_func(f"[{self.name}] {message}")
                return
            except Exception:
                pass
        print(f"[{self.name}] {message}", flush=True)

    # ═════════════════════════════════════════════════════════════════════════
    # 1. دوال الوصول السريع للذاكرة الحية (0-Network Direct Read)
    # ═════════════════════════════════════════════════════════════════════════

    @property
    def init_data(self) -> Dict[str, Any]:
        """الوصول المباشر لكامل متحكمات الذاكرة الحية."""
        if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
            return self.conn.init_data
        return {}

    def get_ctrl(self, name: str) -> Dict[str, Any]:
        """
        جلب بيانات متحكم معين بأمان من الذاكرة الحية بدون رفع استثناءات.
        """
        if not self.conn:
            return {}
        if hasattr(self.conn, "get_ctrl"):
            c = self.conn.get_ctrl(name)
            if isinstance(c, dict):
                return c
        return self.init_data.get(name, {}) if isinstance(self.init_data.get(name), dict) else {}

    @property
    def uid(self) -> str:
        """المعرف الفريد للاعب (UID) من بيانات الاعتماد الرسمية أو الذاكرة الحية lordInfoCtrl."""
        if self.conn and hasattr(self.conn, "creds") and self.conn.creds:
            if getattr(self.conn.creds, "uid", None):
                return str(self.conn.creds.uid).strip()
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return str(base.get("uid", "") or "").strip()

    @property
    def kingdom_id(self) -> int:
        """رقم المملكة / السيرفر الحالي للحساب."""
        if self.conn and hasattr(self.conn, "creds") and self.conn.creds:
            if getattr(self.conn.creds, "kingdom_id", None):
                try:
                    return int(self.conn.creds.kingdom_id)
                except (ValueError, TypeError):
                    pass
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return int(base.get("lastKid", 0))

    @property
    def stamina(self) -> int:
        """كمية طاقة اللورد / الصحة (Stamina / Health) المتاحة حالياً."""
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return int(base.get("health", 0))

    @property
    def health(self) -> int:
        """الاسم البديل للطاقة (Alias for stamina)."""
        return self.stamina

    @property
    def gold(self) -> int:
        """كمية الذهب المتاحة في القلعة."""
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return int(base.get("gold", 0))

    @property
    def lord_level(self) -> int:
        """مستوى الأمير."""
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return int(base.get("level", 0))

    @property
    def castle_level(self) -> int:
        """مستوى القلعة الرئيسي."""
        city = self.get_ctrl("cityCtrl")
        if isinstance(city, dict):
            if "level" in city:
                return int(city["level"])
            buildings = city.get("buildings", [])
            if isinstance(buildings, list):
                for b in buildings:
                    if isinstance(b, dict) and str(b.get("buildingId", "")).startswith("4000"):
                        return int(b.get("level", 1))
        return self.lord_level

    @property
    def resources(self) -> Dict[str, Any]:
        """قاموس كميات الموارد الأساسية في المخازن."""
        city = self.get_ctrl("cityCtrl")
        if isinstance(city, dict):
            return city.get("resList") or city.get("reslist") or {}
        return {}

    @property
    def shield_remaining_seconds(self) -> int:
        """الوقت المتبقي لدرع الحماية بالثواني."""
        lord = self.get_ctrl("lordInfoCtrl")
        base = lord.get("base", {}) if isinstance(lord, dict) else {}
        return int(base.get("shieldTime", 0))

    @property
    def available_marches(self) -> int:
        """عدد طوابير الجيوش الشاغرة الجاهزة للمسير."""
        queue_ctrl = self.get_ctrl("queueCtrl")
        queues = queue_ctrl.get("queues", []) if isinstance(queue_ctrl, dict) else []
        active_marches = sum(1 for q in queues if isinstance(q, dict) and q.get("type") == 1)
        # الحد الافتراضي الأدنى لطوابير الجيوش هو 1 على الأقل أو حسب مبنى قاعة الحرب
        max_marches = max(2, int(self.config.get("max_marches", 2)))
        return max(0, max_marches - active_marches)

    # ═════════════════════════════════════════════════════════════════════════
    # 2. الاستعلام الشبكي الآمن (Safe Query with Human Jitter)
    # ═════════════════════════════════════════════════════════════════════════

    async def safe_query(
        self,
        cmd: str,
        subcmd: str,
        data: Optional[Dict[str, Any]] = None,
        min_delay: float = 0.3,
        max_delay: float = 0.7,
    ) -> Optional[Dict[str, Any]]:
        """
        إرسال استعلام للبوابة مع تطبيق تأخير بشري ديناميكي عشوائي (Human Jitter)
        لمنع إثقال السيرفر وتفادي أنظمة الحماية الآلية.
        """
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚠️ محاولة إرسال استعلام والاتصال مقطوع!")
            return None

        # إضافة فاصل بشري عشوائي خفيف قبل الطلب
        if min_delay > 0:
            jitter = random.uniform(min_delay, max_delay)
            await asyncio.sleep(jitter)

        try:
            return await self.conn.query(cmd, subcmd, data or {})
        except Exception as e:
            if "ConcurrentLogin" in type(e).__name__:
                raise
            self.log(f"❌ خطأ أثناء إرسال الاستعلام ({cmd}/{subcmd}): {e}")
            return None

    # ═════════════════════════════════════════════════════════════════════════
    # 3. دورة حياة التنفيذ (Execution Lifecycle)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي سريع (Pre-flight Check) لتحديد هل المهمة قابلة للتشغيل:
        - هل المهمة مفعلة في الإعدادات؟
        - هل الحساب متصل والذاكرة جاهزة؟
        - هل شروط المهمة الخاصة متوفرة؟
        يُعاد (True, "") أو (False, "سبب التخطي").
        """
        if not self.config.get("enabled", True):
            return False, "المهمة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        return True, ""

    @abstractmethod
    async def run(self) -> TaskResult:
        """
        الدالة الأساسية التي تحتوي على كود المهمة الخاص.
        يجب على كل كلاس مشتق تنفيذها وإرجاع TaskResult.
        """
        pass

    async def safe_execute(self) -> TaskResult:
        """
        الغلاف الخارجي الآمن لتنفيذ المهمة:
        - يمنع انهيار البوت عند حدوث أي خطأ غير متوقع.
        - يقيس زمن التنفيذ ويسجل النتائج بدقة.
        """
        # 1. الفحص القبلي
        try:
            can_execute, reason = await self.can_run()
            if not can_execute:
                return TaskResult.skip(reason)
        except Exception as e:
            msg = f"خطأ أثناء فحص شروط المهمة: {e}"
            self.log(f"⚠️ {msg}")
            return TaskResult.fail(msg)

        # 2. تشغيل المهمة واحتساب الزمن
        t0 = time.time()
        try:
            result = await self.run()
            result.execution_time = time.time() - t0
            return result
        except Exception as e:
            if "ConcurrentLogin" in type(e).__name__:
                raise
            exec_t = time.time() - t0
            err_msg = f"استثناء غير متوقع أثناء تنفيذ المهمة: {e}"
            self.log(f"❌ {err_msg}")
            return TaskResult.fail(err_msg, exec_time=exec_t)

    # ═════════════════════════════════════════════════════════════════════════
    # 4. التوفير الذكي للموارد (Auto Resource Provisioning)
    # ═════════════════════════════════════════════════════════════════════════

    async def ensure_resources(
        self,
        requirements: Dict[str | int, int],
        multiplier: int = 3,
        force_open: bool = False,
    ) -> Dict[str, Any]:
        """
        توفير الموارد المطلوبة للمهام بأمان مع تطبيق الأولويات المتسلسلة:
          - فحص الذاكرة الحية أولاً (0-Network Pre-flight):
            إذا كان الرصيد الحالي >= (المطلوب * multiplier)، لا يتم إرسال أي استعلام شبكي.
          - عند وجود عجز (أو تفعيل force_open):
            الأولوية 1: استخدام صناديق الموارد العادية من الحقيبة (الأكبر قيمة أولاً).
            الأولوية 2: استخدام باقات وصناديق الموارد الآمنة إذا نفدت العادية ولم يُغطَّ العجز.
          - تحديث الذاكرة الحية محلياً فور كل استهلاك لمنع تكرار الفتح.
        """
        results: Dict[str, Any] = {}
        all_satisfied = True

        if not isinstance(requirements, dict) or not requirements:
            return {"success": True, "results": {}, "message": "لا توجد متطلبات موارد محددة."}

        # جلب كائنات الذاكرة الحية
        city = self.get_ctrl("cityCtrl")
        res_list = city.get("resList") or city.get("reslist") if isinstance(city, dict) else {}
        if not isinstance(res_list, dict):
            res_list = {}
            if isinstance(city, dict):
                city["resList"] = res_list

        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            backpack = {}
            if self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                self.conn.init_data["backpackCtrl"] = backpack

        for raw_key, req_amount in requirements.items():
            try:
                req_val = int(req_amount)
            except (ValueError, TypeError):
                continue

            if req_val <= 0:
                continue

            # مطابقة المورد مع تجريد "ال" التعريف تلقائياً
            k_raw = str(raw_key).strip()
            k_clean = k_raw[2:] if k_raw.startswith("ال") and len(k_raw) > 2 else k_raw
            norm_key = (
                RESOURCE_KEY_MAP.get(raw_key)
                or RESOURCE_KEY_MAP.get(k_raw.lower())
                or RESOURCE_KEY_MAP.get(k_clean.lower())
                or RESOURCE_KEY_MAP.get(k_clean)
            )
            if not norm_key or norm_key not in RESOURCE_CATALOG:
                self.log(f"⚠️ [ensure_resources] نوع المورد غير معروف: {raw_key}")
                all_satisfied = False
                results[str(raw_key)] = {
                    "satisfied": False,
                    "error": f"نوع مورد غير معروف: {raw_key}",
                }
                continue

            meta = RESOURCE_CATALOG[norm_key]
            res_name = meta["name_ar"]
            res_id = meta["res_id"]

            # 1. التحقق من فك قفل المورد بحسب مستوى القلعة (لحماية الحساب من الحظر)
            unlock_lv = meta.get("unlock_level", 1)
            c_lv = self.castle_level
            if c_lv < unlock_lv:
                msg = (
                    f"⚠️ [ensure_resources] مورد {res_name} غير مفتوح في هذه القلعة "
                    f"(يتطلب قلعة مستوى {unlock_lv} على الأقل، والمستوى الحالي هو Lv.{c_lv}) "
                    f"— تم التوقف بأمان لحماية الحساب من الحظر وهدر الصناديق."
                )
                self.log(msg)
                all_satisfied = False
                results[str(raw_key)] = {
                    "resource": norm_key,
                    "name": res_name,
                    "satisfied": False,
                    "error": f"المورد غير مفتوح في القلعة (يتطلب قلعة Lv.{unlock_lv}، الحالي: Lv.{c_lv})",
                }
                continue

            current_balance = int(float(res_list.get(res_id, 0)))
            target_to_provide = req_val * max(1, int(multiplier))
            deficit = target_to_provide

            res_report: Dict[str, Any] = {
                "resource": norm_key,
                "name": res_name,
                "res_id": res_id,
                "requested": req_val,
                "target_to_provide": target_to_provide,
                "initial_balance": current_balance,
                "provided": 0,
                "deficit_remaining": deficit,
                "satisfied": False,
            }

            self.log(
                f"📦 [ensure_resources] جاري توفير {target_to_provide:,} من {res_name} "
                f"({multiplier}x أضعاف المطلوب {req_val:,}) بفتح الصناديق..."
            )

            total_opened = 0

            # دالة مساعدة لاستهلاك قائمة صناديق معينة
            async def _consume_boxes(boxes: list[tuple[int, int]], is_safe: bool) -> int:
                nonlocal deficit, total_opened
                opened_here = 0
                box_kind = "آمنة" if is_safe else "عادية"

                for box_id, box_val in boxes:
                    if deficit <= 0:
                        break

                    box_entry = backpack.get(str(box_id)) or backpack.get(int(box_id))
                    if not isinstance(box_entry, dict):
                        continue

                    available_count = int(box_entry.get("count", 0))
                    if available_count <= 0:
                        continue

                    needed_count = math.ceil(deficit / box_val)
                    use_count = min(available_count, needed_count)
                    if use_count <= 0:
                        continue

                    # إرسال طلب استهلاك رسمي للسيرفر (CMD 1004 / SubCMD 2)
                    payload = {"itemID": box_id, "count": use_count}
                    resp = await self.safe_query("1004", "2", payload)

                    # التحقق من نجاح الطلب
                    if resp is not None:
                        # تحديث كمية الصناديق في الحقيبة محلياً
                        rem_boxes = available_count - use_count
                        if rem_boxes > 0:
                            box_entry["count"] = rem_boxes
                        else:
                            backpack.pop(str(box_id), None)
                            backpack.pop(int(box_id), None)

                        # تحديث رصيد المورد في المدينة محلياً
                        gained = use_count * box_val
                        total_opened += gained
                        opened_here += gained
                        new_res_val = int(float(res_list.get(res_id, 0))) + gained
                        res_list[res_id] = str(new_res_val)
                        if isinstance(city, dict):
                            city["reslist"] = res_list

                        deficit = max(0, deficit - gained)
                        self.log(
                            f"✅ [ensure_resources] تم استهلاك {use_count}x صندوق {res_name} ({box_kind}) "
                            f"[ID: {box_id} | +{gained:,}]. العجز المتبقي: {deficit:,}."
                        )

                return opened_here

            # 2. الأولوية الأولى: صناديق الموارد العادية
            await _consume_boxes(meta["normal_boxes"], is_safe=False)

            # 3. الأولوية الثانية: باقات وصناديق الموارد الآمنة (إذا بقي عجز)
            if deficit > 0:
                self.log(f"🛡️ [ensure_resources] الاستعانة بالصناديق الآمنة لتغطية العجز المتبقي ({deficit:,}) من {res_name}...")
                await _consume_boxes(meta["safe_boxes"], is_safe=True)

            # 4. تحديث التقرير النهائي للمورد
            res_report["provided"] = total_opened
            res_report["final_balance"] = int(float(res_list.get(res_id, 0)))
            res_report["deficit_remaining"] = deficit
            res_report["satisfied"] = (deficit == 0)

            if deficit > 0:
                all_satisfied = False
                self.log(
                    f"⚠️ [ensure_resources] لم يتم استيفاء كامل عجز {res_name}؛ "
                    f"المتبقي: {deficit:,} بعد نفاد الصناديق المتاحة بالحقيبة."
                )
                self.log(
                    f"🛑 [ensure_resources] التوقف عن فتح بقية الموارد لوجود عجز في {res_name} منعاً لهدر الصناديق."
                )
                results[norm_key] = res_report
                break
            else:
                self.log(f"🎉 [ensure_resources] تم توفير كامل المطلوب من {res_name} بنجاح (+{total_opened:,}).")

            results[norm_key] = res_report

        return {
            "success": all_satisfied,
            "results": results,
            "all_satisfied": all_satisfied,
        }


