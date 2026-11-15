# -*- coding: utf-8 -*-
"""
python tools/test_base_task.py --email beetoo3@hotmail.com --fn get_command_hall_tasks

python tools/test_base_task.py --email beetoo3@hotmail.com command_hall
"""

from __future__ import annotations

import asyncio
from abc import ABC, abstractmethod
import math
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

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

# ═════════════════════════════════════════════════════════════════════════
# جداول وثوابت قاعة القيادة الرسمية للعبة (Command Hall Standards)
# ═════════════════════════════════════════════════════════════════════════

CMD_COMMAND_HALL_MODULE = "2274"
REQ_COMMAND_HALL_INIT = "1"                 # مزامنة بيانات قاعة القيادة
REQ_COMMAND_HALL_UPGRADE_COMMAND_LV = "2"   # ترقية مستوى قاعة القيادة واستلام الجوائز
REQ_COMMAND_HALL_UPGRADE_POWER_LV = "3"     # ترقية مستوى القوة
REQ_COMMAND_HALL_FINISH_TASK = "5"          # إنجاز المهام الفورية (حوار / إنقاذ / قنص)
REQ_COMMAND_HALL_SET_DEFEND = "6"           # تعيين تشكيلة الدفاع
REQ_COMMAND_HALL_ATTACK_ARMY_GROUP = "7"    # شن هجوم استباقي على فيلق الغزاة
REQ_COMMAND_HALL_COMMIT_TASK = "8"          # استلام جوائز المهام المنجزة (statue == 3)
REQ_COMMAND_HALL_REFRESH_POS = "9"          # تحديث إحداثيات وموقع الـ NPC على الخريطة
REQ_COMMAND_HALL_REFRESH_POS2 = "10"        # تنشيط ومزامنة موقع الـ NPC 2

COMMAND_HALL_TASK_TYPES: Dict[int, Dict[str, Any]] = {
    1: {"name_ar": "فيلق الغزاة (جيش المتمردين)", "category": "boss", "needs_army": True},
    2: {"name_ar": "طليعة الغزاة (متمردون)", "category": "march", "needs_army": True},
    3: {"name_ar": "المعلومات العسكرية (حوار فوري)", "category": "instant", "needs_army": False},
    4: {"name_ar": "إنقاذ القرويين (إنقاذ فوري)", "category": "instant", "needs_army": False},
    5: {"name_ar": "فريق الغزاة (معركة مسير)", "category": "march", "needs_army": True},
    6: {"name_ar": "القناص الصامت (لعبة مصغرة)", "category": "instant", "needs_army": False},
}

COMMAND_HALL_TASK_STATUES: Dict[int, str] = {
    1: "قيد الإعداد",
    2: "جاهزة للتنفيذ",
    3: "مكتملة وبانتظار الاستلام",
}

COMMAND_HALL_QUALITY_NAMES: Dict[int, str] = {
    1: "أبيض (عادي)",
    2: "أخضر (جيد)",
    3: "أزرق (ممتاز)",
    4: "بنفسجي (ملحمي)",
    5: "برتقالي (أسطوري)",
    6: "ذهبي/أحمر (فائق)",
}

COMMAND_HALL_EXP_BY_LV: Dict[int, int] = {
    1: 200, 2: 300, 3: 400, 4: 500, 5: 600, 6: 800,
    7: 1600, 8: 1600, 9: 1600, 10: 1600, 11: 2400,
    12: 2400, 13: 2400, 14: 2400, 15: 2400, 16: 3200,
    17: 3200, 18: 3200, 19: 3200, 20: 3200, 21: 4800,
}
COMMAND_HALL_MAX_LEVEL = 21


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
    def is_shielded(self) -> bool:
        """مؤشر درع السلام الرسمي من خريطة المملكة."""
        km = self.get_ctrl("kingdomMapCtrl")
        return bool(km.get("isSafe", False)) if isinstance(km, dict) else False

    @property
    def shield_remaining_seconds(self) -> int:
        """مؤشر ثواني الدرع المتبقية أو حالة الأمان (توافق خلفي وبساطة مطلقة)."""
        return 1 if self.is_shielded else 0

    # ═════════════════════════════════════════════════════════════════════════
    # دوال إدارة والتعامل مع طوابير ومسيرات الجيوش في الذاكرة الحية (0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    def _read_live_local_queues(self_or_conn: Any, conn: Any = None) -> List[Dict[str, Any]]:
        """
        قراءة طوابير مسيرات القلعة الخاصة من مراجع الذاكرة الحية دون استعلام شبكي (0-Network).
        الأولوية:
          1. conn.local_queues
          2. conn.memory_engine.get_own_local_queues()
          3. conn.init_data.get('local_queues')
        """
        target_conn = conn if conn is not None else (getattr(self_or_conn, "conn", None) or self_or_conn)
        if target_conn is None:
            return []

        # 1. conn.local_queues
        queues = getattr(target_conn, "local_queues", None)
        if queues:
            if isinstance(queues, (list, tuple)):
                return list(queues)
            if isinstance(queues, dict):
                return list(queues.values())

        # 2. conn.memory_engine.get_own_local_queues()
        mem_engine = getattr(target_conn, "memory_engine", None)
        if mem_engine is not None and hasattr(mem_engine, "get_own_local_queues"):
            try:
                own = mem_engine.get_own_local_queues()
                if own:
                    return list(own) if isinstance(own, (list, tuple)) else list(own.values())
            except Exception:
                pass

        # 3. conn.init_data.get('local_queues')
        init_data = getattr(target_conn, "init_data", None)
        if isinstance(init_data, dict):
            init_q = init_data.get("local_queues")
            if init_q:
                if isinstance(init_q, (list, tuple)):
                    return list(init_q)
                if isinstance(init_q, dict):
                    return list(init_q.values())

        return []

    def _read_live_other_queues(self_or_conn: Any, conn: Any = None) -> List[Dict[str, Any]]:
        """
        قراءة طوابير ومسيرات اللاعبين الآخرين من مراجع الذاكرة الحية دون استعلام شبكي (0-Network).
        الأولوية:
          1. conn.other_local_queues
          2. conn.memory_engine.get_other_local_queues()
          3. conn.init_data.get('other_local_queues')
        """
        target_conn = conn if conn is not None else (getattr(self_or_conn, "conn", None) or self_or_conn)
        if target_conn is None:
            return []

        # 1. conn.other_local_queues
        queues = getattr(target_conn, "other_local_queues", None)
        if queues:
            if isinstance(queues, (list, tuple)):
                return list(queues)
            if isinstance(queues, dict):
                return list(queues.values())

        # 2. conn.memory_engine.get_other_local_queues()
        mem_engine = getattr(target_conn, "memory_engine", None)
        if mem_engine is not None and hasattr(mem_engine, "get_other_local_queues"):
            try:
                other = mem_engine.get_other_local_queues()
                if other:
                    return list(other) if isinstance(other, (list, tuple)) else list(other.values())
            except Exception:
                pass

        # 3. conn.init_data.get('other_local_queues')
        init_data = getattr(target_conn, "init_data", None)
        if isinstance(init_data, dict):
            init_other = init_data.get("other_local_queues")
            if init_other:
                if isinstance(init_other, (list, tuple)):
                    return list(init_other)
                if isinstance(init_other, dict):
                    return list(init_other.values())

        return []

    def get_active_marches_count(self, force_sync: bool = False) -> int:
        """
        حساب عدد الفيالق والمسيرات النشطة حالياً خارج القلعة بالاعتماد على الذاكرة الحية (0-Network):
        - فلترة صارمة لمعرّف القلعة (uid) لضمان احتساب مسيرات هذه القلعة حصراً.
        - فلترة الحالات النشطة فقط:
          (0=حشد بتجمع, 1=سير على الخريطة, 2=جمع/تمركز, 3=عودة للقلعة, 4=انتظار, 7=حشد منطلق).
        - عزل التكرار بناءً على معرف الطابور الفريد (qid).
        """
        conn = getattr(self, "conn", None)
        if conn is None:
            return 0

        # إرسال استعلام المزامنة في الخلفية عند طلب force_sync
        if force_sync and getattr(conn, "is_connected", False) and hasattr(conn, "query"):
            try:
                loop = asyncio.get_running_loop()
                loop.create_task(conn.query("1007", "1000", {}))
            except RuntimeError:
                pass

        queues = self._read_live_local_queues(conn)
        my_uid = str(getattr(self, "uid", "") or "").strip()
        active_statuses = (0, 1, 2, 3, 4, 7)
        seen_ids: Set[str] = set()
        active = 0

        for q in queues:
            if not isinstance(q, dict):
                continue

            # فلترة صاحب المسيرة لمنع احتساب مسيرات لاعبين آخرين
            q_uid = q.get("uid")
            if my_uid and q_uid not in (None, "", 0, "0") and str(q_uid).strip() != my_uid:
                continue

            raw_status = q.get("status")
            if raw_status is None:
                continue
            try:
                status = int(raw_status)
            except (TypeError, ValueError):
                continue
            if status not in active_statuses:
                continue

            qid = str(q.get("id") or q.get("queueId") or "").strip()
            if qid:
                if qid in seen_ids:
                    continue
                seen_ids.add(qid)
            active += 1

        # احتياطي: إذا كانت local_queues فارغة تماماً، قراءة queueCtrl من الذاكرة الحية
        if active == 0 and not queues:
            queue_ctrl = self.get_ctrl("queueCtrl")
            if isinstance(queue_ctrl, dict):
                qc_queues = queue_ctrl.get("queues", [])
                if isinstance(qc_queues, list):
                    active = sum(1 for q in qc_queues if isinstance(q, dict) and q.get("type") == 1)

        return active

    def get_other_marches_count(self) -> int:
        """
        حساب عدد طوابير ومسيرات اللاعبين الآخرين النشطة بالذاكرة الحية (0-Network):
        تشمل التعزيزات القادمة للقلعة أو حشود التحالف الأخرى المنفصلة.
        """
        conn = getattr(self, "conn", None)
        if conn is None:
            return 0

        other_queues = self._read_live_other_queues(conn)
        if not other_queues:
            return 0

        my_uid = str(getattr(self, "uid", "") or "").strip()
        active_statuses = (0, 1, 2, 3, 4, 7)
        seen_ids: Set[str] = set()
        count = 0

        for q in other_queues:
            if not isinstance(q, dict):
                continue

            q_uid = q.get("uid")
            if my_uid and q_uid and str(q_uid).strip() == my_uid:
                continue

            raw_status = q.get("status")
            if raw_status is not None:
                try:
                    status = int(raw_status)
                    if status not in active_statuses:
                        continue
                except (TypeError, ValueError):
                    continue

            qid = str(q.get("id") or q.get("queueId") or "").strip()
            if qid:
                if qid in seen_ids:
                    continue
                seen_ids.add(qid)
            count += 1

        return count

    def get_max_marches_capacity(self) -> int:
        """
        حساب سعة الفيالق والمسيرات القصوى المسموح بها للقلعة بدقة طبقاً لكود اللعبة (0-Network):
        1. السقف الأساسي لجميع القلاع = 1 (DEFAULT_EXP_ARMY_QUEUE).
        2. أبحاث معهد العلوم (technologyCtrl - EXPEDITION_TROOPS):
           - #24011 (فيلق البعثة I): +1
           - #24017 (فيلق البعثة II): +1
           - #24033 (فيلق البعثة III): +1
           (الحد الأقصى لزيادة الأبحاث = +3).
        3. ميزة الـ VIP (vipCtrl / lordInfoCtrl.vip):
           - المستويات من VIP 4 إلى VIP 9: تمنح +1 طابور مسيرة إضافي.
           - المستويات من VIP 10 إلى VIP 18: تمنح +2 طابور مسيرة إضافي.
        4. مراعاة السقف الأقصى العام للعبة (MAX_MARCH_TROOP = 6) أو التقييد اليدوي في config.max_marches إن وُجد.
        """
        capacity = 1

        # فحص سعة الطوابير المسجلة رسمياً في queueCtrl إن وجدت
        queue_ctrl = self.get_ctrl("queueCtrl")
        if isinstance(queue_ctrl, dict):
            qc_max = queue_ctrl.get("maxQueueCount")
            if qc_max is not None:
                try:
                    c_val = int(qc_max)
                    if c_val > 0:
                        capacity = max(capacity, c_val)
                except (ValueError, TypeError):
                    pass

        # 1. أبحاث معهد العلوم (24011, 24017, 24033)
        tech_ctrl = self.get_ctrl("technologyCtrl")
        tech_bonus = 0
        if isinstance(tech_ctrl, dict):
            for tid in ("24011", "24017", "24033"):
                val = tech_ctrl.get(tid) if tid in tech_ctrl else tech_ctrl.get(int(tid))
                if val is not None:
                    lv = 0
                    if isinstance(val, (list, tuple)):
                        if len(val) > 1:
                            try:
                                lv = int(val[1] or 0)
                            except (ValueError, TypeError):
                                lv = 0
                        elif len(val) == 1:
                            try:
                                lv = int(val[0] or 0)
                            except (ValueError, TypeError):
                                lv = 0
                    elif isinstance(val, dict):
                        lv = int(val.get("level", val.get("lv", 0)) or 0)
                    else:
                        try:
                            lv = int(val or 0)
                        except (ValueError, TypeError):
                            lv = 0
                    if lv > 0:
                        tech_bonus += 1
        capacity += min(3, tech_bonus)

        # 2. ميزة VIP (VIP 4..9 -> +1, VIP 10+ -> +2)
        vip_ctrl = self.get_ctrl("vipCtrl")
        vip_lv = 0
        if isinstance(vip_ctrl, dict):
            try:
                vip_lv = int(vip_ctrl.get("vipLv", vip_ctrl.get("level", 0)) or 0)
            except (ValueError, TypeError):
                vip_lv = 0
        if vip_lv == 0:
            lord = self.get_ctrl("lordInfoCtrl")
            if isinstance(lord, dict):
                vip_obj = lord.get("vip", {})
                if isinstance(vip_obj, dict):
                    try:
                        vip_lv = int(vip_obj.get("level", vip_obj.get("vipLv", 0)) or 0)
                    except (ValueError, TypeError):
                        vip_lv = 0

        if vip_lv >= 10:
            capacity += 2
        elif vip_lv >= 4:
            capacity += 1

        # 3. السقف الأقصى العام للعبة 6 مسيرات
        capacity = min(6, max(1, capacity))

        # 4. مراعاة التقييد اليدوي config.get('max_marches') أو config.get('max_queues')
        if hasattr(self, "config") and isinstance(self.config, dict):
            cfg_max = self.config.get("max_marches", self.config.get("max_queues"))
            if cfg_max is not None:
                try:
                    c_val = int(cfg_max)
                    if c_val > 0:
                        capacity = min(capacity, c_val)
                except (ValueError, TypeError):
                    pass

        return capacity

    def get_available_marches_count(self) -> int:
        """
        حساب عدد الفيالق المتاحة والشاغرة للإرسال حالياً (0-Network):
        الفارق بين سعة الفيالق القصوى للقلعة (get_max_marches_capacity)
        وعدد الفيالق النشطة بالخارج حالياً (get_active_marches_count).
        """
        max_cap = self.get_max_marches_capacity()
        active = self.get_active_marches_count()
        return max(0, int(max_cap) - int(active))

    @property
    def available_marches(self) -> int:
        """عدد الفيالق الشاغرة المتاحة للإرسال خارج القلعة حالياً."""
        return self.get_available_marches_count()

    def get_active_gather_resource_types(self, force_sync: bool = False) -> Set[int]:
        """
        فحص أنواع الموارد التي تجمعها مسيرات نشطة بالخارج حالياً لقلعة هذا الحساب (0-Network)
        (1=ذهب, 2=قمح, 3=خشب, 4=حديد, 5=فضة):
        - قراءة فورية من الذاكرة الحية عبر _read_live_local_queues (Zero-Request).
        - فلترة صارمة لمعرّف القلعة (uid) لضمان عدم احتساب مسيرات لاعبين آخرين.
        """
        conn = getattr(self, "conn", None)
        if conn is None:
            return set()

        if force_sync and getattr(conn, "is_connected", False) and hasattr(conn, "query"):
            try:
                loop = asyncio.get_running_loop()
                loop.create_task(conn.query("1007", "1000", {}))
            except RuntimeError:
                pass

        queues = self._read_live_local_queues(conn)
        if not queues:
            return set()

        my_uid = str(getattr(self, "uid", "") or "").strip()
        active: Set[int] = set()

        for q in queues:
            if not isinstance(q, dict):
                continue

            # فلترة صاحب المسيرة
            q_uid = q.get("uid")
            if my_uid and q_uid not in (None, "", 0, "0") and str(q_uid).strip() != my_uid:
                continue

            raw_status = q.get("status")
            if raw_status is None:
                continue
            try:
                status = int(raw_status)
            except (TypeError, ValueError):
                continue
            if status not in (0, 1, 2, 3, 4, 7):
                continue

            res_sub = None
            for loc_key in ("to", "from"):
                info = q.get(loc_key, {})
                if isinstance(info, dict) and info.get("mapType") == 5:
                    res_sub = info.get("subMapType")
                    if not res_sub:
                        parts = str(info.get("id", "")).split("-")
                        if len(parts) >= 4 and parts[2] == "5" and parts[3].isdigit():
                            res_sub = int(parts[3])
                if res_sub:
                    break

            if not res_sub:
                data_obj = q.get("data", {})
                if isinstance(data_obj, dict):
                    code = data_obj.get("resourceType")
                    if code:
                        res_sub = {1001: 1, 1002: 2, 1003: 3, 1004: 4, 1005: 5}.get(int(code))

            if res_sub is not None:
                try:
                    sub_int = int(res_sub)
                    if sub_int in (1, 2, 3, 4, 5):
                        active.add(sub_int)
                except (ValueError, TypeError):
                    pass

        return active

    def is_ruins_march_active(self, force_sync: bool = False) -> bool:
        """
        فحص هل يوجد فيلق مشغول باستكشاف الأطلال حالياً (سواء في الذهاب أو الاستكشاف أو العودة):
        - قراءة فورية من الذاكرة الحية (0-Network) عبر _read_live_local_queues.
        - فلترة صارمة لمعرّف القلعة (uid) لضمان احتساب مسيرات هذا الحساب فقط.
        - التحقق من نوع المسار (moveLineType = 4) أو نوع خريطة الأطلال (mapType = 7) في الهدف (to) أو نقطة الانطلاق (from).
        """
        conn = getattr(self, "conn", None)
        if conn is None:
            return False

        if force_sync and getattr(conn, "is_connected", False) and hasattr(conn, "query"):
            try:
                loop = asyncio.get_running_loop()
                loop.create_task(conn.query("1007", "1000", {}))
            except RuntimeError:
                pass

        queues = self._read_live_local_queues(conn)
        if not queues:
            return False

        my_uid = str(getattr(self, "uid", "") or "").strip()
        active_statuses = (0, 1, 2, 3, 4, 7)

        for q in queues:
            if not isinstance(q, dict):
                continue

            # فلترة صاحب المسيرة
            q_uid = q.get("uid")
            if my_uid and q_uid not in (None, "", 0, "0") and str(q_uid).strip() != my_uid:
                continue

            raw_status = q.get("status")
            if raw_status is None:
                continue
            try:
                status = int(raw_status)
            except (TypeError, ValueError):
                continue
            if status not in active_statuses:
                continue

            # 1. moveLineType = 4 مخصص للأطلال
            if q.get("moveLineType") == 4 or q.get("type") == 4:
                return True

            # 2. فحص الهدف (to) أو نقطة الانطلاق (from) للأطلال (mapType = 7)
            for loc_key in ("to", "from"):
                info = q.get(loc_key, {})
                if isinstance(info, dict):
                    if info.get("mapType") == 7:
                        return True
                    raw_id = str(info.get("id") or "")
                    parts = raw_id.split("-")
                    if len(parts) >= 3 and parts[2] == "7":
                        return True

        return False

    # مسميات بديلة للتوافق الكامل
    has_active_ruins_march = is_ruins_march_active
    _get_active_gather_types = get_active_gather_resource_types

    # ═════════════════════════════════════════════════════════════════════════
    # دوال جلب وفحص القوات والجنود الشاغرين في القلعة (0-Network Direct Read)
    # ═════════════════════════════════════════════════════════════════════════

    def get_available_troops(
        self,
        exclude_fortress: bool = True,
        as_list: bool = False,
        reverse: bool = False,
    ) -> Dict[int, int] | List[Dict[str, int]]:
        """
        جلب القوات والجنود المتاحين والشاغرين حالياً داخل القلعة من الذاكرة الحية (0-Network):
        - قراءة فورية من كائن armyCtrl (totalArmy / freeArmy / armys) بصفر استعلامات شبكية.
        - استبعاد وحدات حصن الحرب (فخاخ الحصن 800..899 / BUILDID 120) تلقائياً عند تفعيل exclude_fortress.
        - استبعاد أي جنود منخرطين حالياً في معارك القلعة من كائن fightingArmy إن وُجد.
        - ترتيب القوات تصاعدياً بحسب المعرف/الرتبة (reverse=False: الأضعف أولاً لتفادي استنزاف النخب)،
          أو تنازلياً (reverse=True: الأقوى رتبة أولاً للحشود والمسيرات القتالية).
        - صيغة الإرجاع:
          * قاموس {unit_id: count} إذا كان as_list=False (الافتراضي).
          * قائمة كائنات [{"id": unit_id, "num": count}, ...] إذا كان as_list=True لتناسب حزم السيرفر فوراً.
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            # محاولة قراءة الاسم البديل army في الذاكرة الحية
            army_ctrl = self.get_ctrl("army")
            if not army_ctrl or not isinstance(army_ctrl, dict):
                army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}

        # 1. استخراج مصدر القوات من الذاكرة الحية
        raw_army = (
            army_ctrl.get("totalArmy")
            or army_ctrl.get("freeArmy")
            or army_ctrl.get("armys")
            or (army_ctrl.get("armyInfo", {}).get("totalArmy") if isinstance(army_ctrl.get("armyInfo"), dict) else None)
            or {}
        )

        fighting_army = army_ctrl.get("fightingArmy") or {}
        troops_map: Dict[int, int] = {}

        # 2. استخراج وتطهير القوات المتاحة
        if isinstance(raw_army, dict):
            for k, v in raw_army.items():
                try:
                    uid = int(k)
                    cnt = int(v)
                except (ValueError, TypeError):
                    continue

                if cnt <= 0:
                    continue

                # استبعاد وحدات حصن الحرب (فخاخ الحصن 800..899 طبقاً لـ serviceFunctions.isTrapID)
                if exclude_fortress and (800 <= uid <= 899):
                    continue

                # خصم أي قوات مقيدة في fightingArmy إن وُجدت
                fight_cnt = 0
                if isinstance(fighting_army, dict):
                    raw_fight = fighting_army.get(str(uid)) if str(uid) in fighting_army else fighting_army.get(uid)
                    if raw_fight is not None:
                        try:
                            fight_cnt = int(raw_fight)
                        except (ValueError, TypeError):
                            fight_cnt = 0

                avail = max(0, cnt - fight_cnt)
                if avail > 0:
                    troops_map[uid] = avail

        elif isinstance(raw_army, list):
            for entry in raw_army:
                if not isinstance(entry, dict):
                    continue
                raw_id = entry.get("id") or entry.get("armyid") or entry.get("armyID")
                raw_count = entry.get("num") or entry.get("count") or entry.get("armycount")
                try:
                    uid = int(raw_id)
                    cnt = int(raw_count)
                except (ValueError, TypeError):
                    continue

                if cnt <= 0:
                    continue

                if exclude_fortress and (800 <= uid <= 899):
                    continue

                fight_cnt = 0
                if isinstance(fighting_army, dict):
                    raw_fight = fighting_army.get(str(uid)) if str(uid) in fighting_army else fighting_army.get(uid)
                    if raw_fight is not None:
                        try:
                            fight_cnt = int(raw_fight)
                        except (ValueError, TypeError):
                            fight_cnt = 0

                avail = max(0, cnt - fight_cnt)
                if avail > 0:
                    troops_map[uid] = troops_map.get(uid, 0) + avail

        # 3. فرز الوحدات (تصاعدي الأضعف أولاً افتراضياً لتفادي استنزاف النخب)
        sorted_items = sorted(troops_map.items(), key=lambda x: x[0], reverse=reverse)

        # 4. تحويل لصيغة الإرجاع المطلوبة
        if as_list:
            return [{"id": k, "num": v} for k, v in sorted_items]
        return dict(sorted_items)

    def get_available_troops_count(self, exclude_fortress: bool = True) -> int:
        """إجمالي تعداد الجنود المتاحين والشاغرين في القلعة حالياً (0-Network)."""
        troops = self.get_available_troops(exclude_fortress=exclude_fortress, as_list=False)
        return sum(troops.values()) if isinstance(troops, dict) else 0

    @property
    def available_troops(self) -> Dict[int, int]:
        """قاموس القوات الشاغرة المتاحة حالياً في القلعة مع استبعاد وحدات حصن الحرب (0-Network)."""
        res = self.get_available_troops(exclude_fortress=True, as_list=False, reverse=False)
        return res if isinstance(res, dict) else {}

    @property
    def available_troops_count(self) -> int:
        """إجمالي عدد القوات الشاغرة المتاحة في القلعة حالياً مع استبعاد وحدات حصن الحرب."""
        return self.get_available_troops_count(exclude_fortress=True)

    def get_available_troops_list(
        self,
        exclude_fortress: bool = True,
        reverse: bool = False,
    ) -> List[Dict[str, int]]:
        """قائمة كائنات القوات المتاحة بصيغة [{"id": ..., "num": ...}] لتوافق حزم السيرفر فوراً."""
        res = self.get_available_troops(exclude_fortress=exclude_fortress, as_list=True, reverse=reverse)
        return res if isinstance(res, list) else []

    # مسميات بديلة للتوافق والانسجام التام (Aliases)
    get_available_soldiers = get_available_troops
    get_idle_troops = get_available_troops
    get_idle_soldiers = get_available_troops

    async def sync_local_queues(self, timeout: float = 2.0) -> bool:
        """
        إرسال استعلام مزامنة طوابير الفيالق 1007/1000 للسيرفر وانتظار وصول إشعار NOTIFY_LOCAL_QUEUE_SYNC (cmd 202).
        """
        if not self.conn or not getattr(self.conn, "is_connected", False) or not hasattr(self.conn, "query"):
            return False
        try:
            await self.conn.query("1007", "1000", {}, timeout=timeout)
            return True
        except Exception as e:
            self.log(f"⚠️ استعلام مزامنة الفيالق 1007/1000 لم يكتمل: {e}")
            return False

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

    @staticmethod
    def _safe_int(v: Any, default: int = 0) -> int:
        """تحويل آمن إلى عدد صحيح مع معالجة السلاسل النصية والقيم غير الصالحة دون استثناءات."""
        if v is None or isinstance(v, bool):
            return default
        try:
            if isinstance(v, str):
                s = v.strip()
                return int(float(s)) if s else default
            return int(v)
        except (ValueError, TypeError, OverflowError):
            return default

    # ═════════════════════════════════════════════════════════════════════════
    # 5. استكشاف وجلب مهام قاعة القيادة (Command Hall Inspection)
    # ═════════════════════════════════════════════════════════════════════════

    async def get_command_hall_tasks(self, force_sync: bool = False) -> Dict[str, Any]:
        """
        جلب وتصنيف كافة مهام قاعة القيادة وحالتها بدقة استناداً إلى كود اللعبة الرسمي:
        - 0-Network Pre-flight: فحص كائن commandHall في الذاكرة الحية أولاً.
        - عند عدم توفر البيانات أو طلب force_sync=True: إرسال استعلام رسمي آمن (CMD 2274 / SubCMD 1).
        - تصنيف المهام التنفيذية إلى:
          * مهام فورية آمنة (instant): حوار (3)، إنقاذ (4)، قنص (6) - لا تتطلب مسيراً ولا جيشاً.
          * مهام مسير ومعارك (march): طليعة الغزاة (2)، فريق الغزاة (5) - تتطلب إرسال فيلق على الخريطة.
          * مهمة فيلق الغزاة (boss/legion): المهمة 1 (شن هجوم استباقي أو دفاع عند السور).
        - حصر المهام المنجزة الجاهزة لاستلام الجوائز (statue == 3).
        - إثراء شامل لكل مهمة (الاسم العربي، الجودة واللون، الطاقة المطلوبة، الإحداثيات، فحص الأمان 0-Gold).
        - توفير ملخص شامل للقاعة (المستوى، نقاط الخبرة، هل يمكن الترقية، تقدم النشاط اليومي 33).
        """
        # 1. فحص الذاكرة الحية (0-Network)
        hall_data = self.get_ctrl("commandHall")
        has_cached = isinstance(hall_data, dict) and bool(
            hall_data.get("commandLv") or hall_data.get("commonTaskData") or hall_data.get("armyGroupTaskData")
        )

        # 2. استعلام السيرفر عند الحاجة أو عند طلب force_sync
        if not has_cached or force_sync:
            resp = await self.safe_query(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_INIT, {})
            if isinstance(resp, dict):
                init_data = None
                rspdata = resp.get("rspdata")
                if isinstance(rspdata, dict) and isinstance(rspdata.get("initData"), dict):
                    init_data = rspdata["initData"]
                elif isinstance(resp.get("data"), dict) and resp.get("data"):
                    init_data = resp["data"]
                elif "commandLv" in resp or "commonTaskData" in resp or "armyGroupTaskData" in resp:
                    init_data = resp

                if isinstance(init_data, dict):
                    if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                        cached = self.conn.init_data.setdefault("commandHall", {})
                        if isinstance(cached, dict):
                            cached.update(init_data)
                            hall_data = cached
                        else:
                            self.conn.init_data["commandHall"] = init_data
                            hall_data = init_data
                    else:
                        hall_data = init_data

        if not isinstance(hall_data, dict):
            return {
                "success": False,
                "message": "تعذر العثور على بيانات قاعة القيادة في الذاكرة الحية أو عبر السيرفر.",
                "summary": {},
                "counts": {"total": 0, "executable": 0, "instant": 0, "march": 0, "claimable": 0},
                "executable_tasks": [],
                "instant_tasks": [],
                "march_tasks": [],
                "army_group_task": None,
                "claimable_tasks": [],
                "all_tasks": [],
            }

        # 3. استخراج ملخص قاعة القيادة والنشاط اليومي
        cmd_lv = self._safe_int(hall_data.get("commandLv"), 1)
        cmd_exp = self._safe_int(hall_data.get("commandExp"), 0)
        power_lv = self._safe_int(hall_data.get("powerLv"), 1)
        army_group_id = self._safe_int(hall_data.get("armyGroupID"), 1)
        next_refresh_time = self._safe_int(hall_data.get("nextRefreshTime"), 0)
        now_ts = int(time.time())
        next_refresh_remaining = max(0, next_refresh_time - now_ts) if next_refresh_time > 0 else 0
        need_exp = COMMAND_HALL_EXP_BY_LV.get(cmd_lv, 0)
        can_upgrade = (cmd_lv < COMMAND_HALL_MAX_LEVEL) and (need_exp > 0) and (cmd_exp >= need_exp)

        # فحص إنجاز النشاط اليومي (مهمة 33 في everydayTaskCtrl)
        daily_quest_completed = False
        daily_progress = 0
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo")
            if isinstance(event_info, dict):
                for k in ("33", "4100033", 33, 4100033):
                    if k in event_info:
                        val = self._safe_int(event_info.get(k), 0)
                        if val >= 1:
                            daily_quest_completed = True
                            daily_progress = val
                            break

        summary = {
            "command_lv": cmd_lv,
            "command_exp": cmd_exp,
            "need_exp": need_exp,
            "can_upgrade": can_upgrade,
            "power_lv": power_lv,
            "army_group_id": army_group_id,
            "next_refresh_time": next_refresh_time,
            "next_refresh_remaining_seconds": next_refresh_remaining,
            "daily_quest_completed": daily_quest_completed,
            "daily_quest_progress": daily_progress,
        }

        # 4. تجميع كافة المهام الخام وتطبيعها
        raw_items: List[Dict[str, Any]] = []

        # (أ) commonTaskData (حوار، إنقاذ، معارك، قنص)
        ct = hall_data.get("commonTaskData")
        if isinstance(ct, list):
            raw_items.extend(item for item in ct if isinstance(item, dict) and item)
        elif isinstance(ct, dict):
            raw_items.extend(item for item in ct.values() if isinstance(item, dict) and item)

        # (ب) armyGroupTaskData (فيلق الغزاة)
        ag = hall_data.get("armyGroupTaskData")
        if isinstance(ag, dict) and ag:
            raw_items.append(ag)

        # (ج) armyPioneerTaskData (طليعة الغزاة)
        ap = hall_data.get("armyPioneerTaskData")
        if isinstance(ap, dict) and ap:
            raw_items.append(ap)

        # (د) finishTaskData (المهام المكتملة)
        ft = hall_data.get("finishTaskData")
        if isinstance(ft, list):
            for item in ft:
                if isinstance(item, dict) and item:
                    it_copy = dict(item)
                    if self._safe_int(it_copy.get("statue")) == 0:
                        it_copy["statue"] = 3
                    raw_items.append(it_copy)
        elif isinstance(ft, dict):
            for k_id, count in ft.items():
                tid = self._safe_int(k_id)
                if tid > 0:
                    raw_items.append({
                        "taskID": tid,
                        "statue": 3,
                        "finish_count": self._safe_int(count, 1),
                        "is_historical_finish": True,
                    })

        # (هـ) taskList التوافقية
        legacy = hall_data.get("taskList") or hall_data.get("tasks")
        if isinstance(legacy, list):
            raw_items.extend(item for item in legacy if isinstance(item, dict) and item)
        elif isinstance(legacy, dict):
            raw_items.extend(item for item in legacy.values() if isinstance(item, dict) and item)

        # 5. إثراء وتصنيف المهام
        def _is_costly(task: Dict[str, Any]) -> bool:
            if self._safe_int(task.get("consumeGold")) > 0 or self._safe_int(task.get("gold")) > 0:
                return True
            if bool(task.get("consumeSpeedup")) or bool(task.get("speedup")):
                return True
            for field in ("consumeItem", "consumeItems", "item", "items"):
                val = task.get(field)
                if val:
                    if isinstance(val, str) and val.lower().strip() not in ("", "0", "false", "none"):
                        return True
                    if isinstance(val, (int, float)) and val > 0:
                        return True
                    if isinstance(val, (list, dict)) and len(val) > 0:
                        return True
            return False

        all_tasks: List[Dict[str, Any]] = []
        executable_tasks: List[Dict[str, Any]] = []
        instant_tasks: List[Dict[str, Any]] = []
        march_tasks: List[Dict[str, Any]] = []
        claimable_tasks: List[Dict[str, Any]] = []
        army_group_task: Optional[Dict[str, Any]] = None
        seen_keys: Set[Tuple[int, int, int]] = set()

        for item in raw_items:
            task_id = self._safe_int(item.get("taskID") or item.get("Index") or item.get("id"), 0)
            idx = self._safe_int(item.get("index"), 0)
            raw_type = self._safe_int(item.get("type"), 0)
            # استنتاج النوع إذا لم يكن محدداً صراحة استناداً إلى معرف المهمة
            if raw_type == 0 and task_id > 0:
                raw_type = task_id // 1000

            type_info = COMMAND_HALL_TASK_TYPES.get(
                raw_type,
                {"name_ar": f"مهمة قيادة نوع {raw_type}", "category": "unknown", "needs_army": False}
            )
            type_name = type_info["name_ar"]
            category = type_info["category"]
            needs_army = type_info["needs_army"]

            statue = self._safe_int(item.get("statue"), 2 if idx > 0 else 1)
            statue_name = COMMAND_HALL_TASK_STATUES.get(statue, "غير محددة")

            quality = self._safe_int(item.get("quality"), 1)
            if quality == 1 and task_id > 0:
                q_mod = (task_id % 10)
                if 1 <= q_mod <= 6:
                    quality = q_mod
            quality_name = COMMAND_HALL_QUALITY_NAMES.get(quality, f"مستوى {quality}")

            stamina_cost = 0 if raw_type == 3 else self._safe_int(item.get("consume"), 10)

            pos = None
            obj = item.get("obj")
            if isinstance(obj, dict) and "x" in obj and "y" in obj:
                pos = {"x": self._safe_int(obj.get("x")), "y": self._safe_int(obj.get("y"))}

            is_costly = _is_costly(item)

            dedup_key = (task_id, idx, statue)
            if dedup_key in seen_keys:
                continue
            seen_keys.add(dedup_key)

            enriched = {
                "task_id": task_id,
                "index": idx,
                "type": raw_type,
                "type_name_ar": type_name,
                "category": category,
                "needs_army": needs_army,
                "statue": statue,
                "statue_name_ar": statue_name,
                "quality": quality,
                "quality_name_ar": quality_name,
                "stamina_cost": stamina_cost,
                "is_costly": is_costly,
                "is_fixed_task": bool(item.get("isFixedTask", False)),
                "pos": pos,
                "raw": item,
            }

            all_tasks.append(enriched)

            # المهام المكتملة الجاهزة للاستلام (statue == 3)
            if statue == 3 and not item.get("is_historical_finish"):
                claimable_tasks.append(enriched)

            # المهام القابلة للتنفيذ (statue in (1, 2) and not is_costly)
            if statue in (1, 2) and not is_costly and idx > 0:
                executable_tasks.append(enriched)
                if category == "instant":
                    instant_tasks.append(enriched)
                elif category == "march":
                    march_tasks.append(enriched)
                elif category == "boss":
                    army_group_task = enriched

        return {
            "success": True,
            "summary": summary,
            "counts": {
                "total": len(all_tasks),
                "executable": len(executable_tasks),
                "instant": len(instant_tasks),
                "march": len(march_tasks),
                "claimable": len(claimable_tasks),
            },
            "executable_tasks": executable_tasks,
            "instant_tasks": instant_tasks,
            "march_tasks": march_tasks,
            "army_group_task": army_group_task,
            "claimable_tasks": claimable_tasks,
            "all_tasks": all_tasks,
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 6. تجهيز الجيش وتنفيذ معارك فريق الغزاة (Battle Task Execution)
    # ═════════════════════════════════════════════════════════════════════════

    # جداول القوة والمطابقة الرسمية من سورس كود اللعبة (newcommandhalltask / armyinfo)
    COMMAND_HALL_RECOMMEND_MAP: Dict[int, Dict[str, int]] = {
        # مهام فريق الغزاة (نوع 5)
        5021: {"recommendArmy": 5630, "recommendHero": 120200},
        5022: {"recommendArmy": 5630, "recommendHero": 120200},
        5023: {"recommendArmy": 5630, "recommendHero": 120200},
        5024: {"recommendArmy": 5630, "recommendHero": 120200},
        5025: {"recommendArmy": 5630, "recommendHero": 120200},
        5026: {"recommendArmy": 10430, "recommendHero": 135200},
        5027: {"recommendArmy": 10430, "recommendHero": 135200},
        # مهام طليعة الغزاة (نوع 2)
        2013: {"recommendArmy": 10175, "recommendHero": 135200},
    }

    # جدول القوة الرسمية للرتب القتالية من armyinfo.lua
    UNIT_BASE_POWERS: Dict[int, float] = {
        1: 1.0, 2: 1.4, 3: 1.9, 4: 2.5, 5: 3.2,
        6: 4.0, 7: 4.9, 8: 5.9, 9: 7.0, 10: 8.2,
        11: 10.5, 12: 13.5, 13: 24.0, 14: 30.0,
    }

    def prepare_combat_troops(
        self,
        task_id: int = 0,
        target_power: Optional[int] = None,
        safety_multiplier: float = 1.20,
        min_troops: int = 100,
    ) -> List[Dict[str, int]]:
        """
        تجهيز فرقة القوات القتالية لمسير المعركة بالاعتماد على الذاكرة الحية (0-Network) وفق سورس كود اللعبة:
        - استخراج القوة الموصى بها (recommendArmy) من جدول مهام قاعة القيادة الرسمي (newcommandhalltask.lua).
        - تطبيق هامش الأمان الموفر الذكي (+20%) المعتمد لضمان النصر بأقل عدد جنود وحماية القلعة.
        - فرز القوات المتاحة بالقلعة من الأعلى رتبة قتالية (Tier Level = unit_id % 100 تنازلياً) وفق أسبقية اللعبة (WorldDispatchArmyViewPanel).
        - احتساب القوة القتالية الرسمية لكل رتبة (وفق جدول armyinfo.lua: من 1.0 للرتبة 1 حتى 8.2 للرتبة 10 وما فوق).
        - التوقف فور تحقيق القوة المستهدفة لتوفير بقية الجيش للمهام الأخرى.
        - صيغة الإرجاع: [{"id": unit_id, "num": count}, ...] متوافقة مباشرة مع حزمة مسير السيرفر (CMD 1007 / 2).
        """
        # 1. احتساب القوة المستهدفة بناءً على مهمة قاعة القيادة وهامش الأمان (+20%)
        if target_power is None or target_power <= 0:
            task_cfg = self.COMMAND_HALL_RECOMMEND_MAP.get(task_id)
            if task_cfg:
                base_recommend = task_cfg.get("recommendArmy", 5630)
            else:
                base_recommend = 10430 if task_id >= 5026 or task_id in (2013, 2014) else 5630
            target_power = int(math.ceil(base_recommend * safety_multiplier))

        # 2. جلب القوات المتاحة من الذاكرة الحية مع استبعاد وحدات الحصن
        available_troops = self.get_available_troops(exclude_fortress=True, as_list=False)
        if not available_troops or not isinstance(available_troops, dict):
            return []

        # فرز الوحدات تنازلياً وفق الرتبة العسكرية (Tier Level = unit_id % 100) كما في سورس العميل الرسمي
        sorted_units = sorted(
            available_troops.items(),
            key=lambda x: (x[0] % 100, x[0]),
            reverse=True,
        )

        selected: List[Dict[str, int]] = []
        accumulated_power = 0.0

        for unit_id, available_count in sorted_units:
            if available_count <= 0:
                continue

            # استخراج القوة الفعلية للوحدة من جدول armyinfo.lua
            unit_level = max(1, unit_id % 100)
            unit_base_power = self.UNIT_BASE_POWERS.get(unit_level, max(1.0, float(unit_level * 0.7)))

            # حساب العدد المطلوب من هذه الرتبة لسد العجز المتبقي من القوة
            remaining_power = max(0.0, float(target_power) - accumulated_power)
            needed_count = math.ceil(remaining_power / unit_base_power) if unit_base_power > 0 else int(remaining_power)
            take_count = min(available_count, max(min_troops, needed_count))

            if take_count > 0:
                selected.append({"id": int(unit_id), "num": int(take_count)})
                accumulated_power += take_count * unit_base_power

            if accumulated_power >= target_power:
                break

        # صمام أمان: إذا لم يتم اختيار جنود (مثلاً الرتب فارغة)، نضمن اختيار أول رتبة متاحة بالحد الأدنى
        if not selected:
            for unit_id, count in available_troops.items():
                if count > 0:
                    selected.append({"id": int(unit_id), "num": min(count, max(1, min_troops))})
                    break

        return selected

    def prepare_combat_hero(self, task_id: int = 0) -> List[Dict[str, int]]:
        """
        انتقاء وتجهيز تشكيلة الأبطال القتاليين المتعددة وفق الاستنباط الدقيق من سورس كود اللعبة (heroSelectBanner / heroCtrl):
        - احتساب عدد الخانات القتالية المفتوحة (openSites / max_slots) بحسب مستوى القلعة (حتى 5 أبطال للقلعة 18 فما فوق).
        - قراءة الأبطال وحالاتهم من الذاكرة الحية (0-Network) عبر heroSysCtrl / heroCtrl.
        - استبعاد أبطال حراسة السور المخصصين (defendList) لمنع سحبهم وإضعاف دفاع القلعة.
        - استبعاد أبطال الجمع التخصصيين (1711, 1724, 1733).
        - استبعاد الأبطال المشغولين في مسيرات نشطة أخرى (queue غير فارغ).
        - تطبيق خوارزمية الفرز الرسمية للعبة (heroCtrl:sortDispatchHerosID):
          1. الأبطال في الحالة الشاغرة (state == 1 أو state == 4 غير مخصص للسور).
          2. أسبقية الأبطال ذوي المظهر/النائب الخاص (ownL).
          3. المستوى التنازلي (level).
          4. الجودة والنجوم التنازلية (quality).
          5. حالة الصحوة التنازلية (isAwake).
          6. المعرف التصاعدي (heroID).
        - اختيار أفضل (max_slots) أبطال لملء كافة الخانات الشاغرة كما تفعل دالة اللعبة (autoFillHeros).
        - صيغة الإرجاع: [{"heroID": hid}, ...] متوافقة 100% مع حزمة السيرفر الرسمية.
        """
        hero_ctrl = self.get_ctrl("heroSysCtrl") or self.get_ctrl("heroCtrl")
        if not isinstance(hero_ctrl, dict):
            return []

        hero_list_raw = hero_ctrl.get("heroList")
        if not isinstance(hero_list_raw, dict):
            return []

        # 1. تحديد عدد خانات الأبطال المفتوحة للمسير وفق مستوى القلعة (heroCtrl:getMaxBattleHeroNum)
        castle_lv = getattr(self, "castle_level", 1)
        if castle_lv >= 18:
            max_slots = 5
        elif castle_lv >= 14:
            max_slots = 4
        elif castle_lv >= 10:
            max_slots = 3
        elif castle_lv >= 5:
            max_slots = 2
        else:
            max_slots = 1

        # 2. استخراج قائمة حراس السور الفعليين لاستبعادهم بدقة
        defend_ids: Set[int] = set()
        raw_defend = hero_ctrl.get("defendList", {})
        if isinstance(raw_defend, dict):
            for vk, vv in raw_defend.items():
                if isinstance(vv, dict):
                    dhid = self._safe_int(vv.get("heroID", vv.get("id")))
                    if dhid > 0:
                        defend_ids.add(dhid)
                elif isinstance(vv, (int, str)):
                    dhid = self._safe_int(vv)
                    if dhid > 0:
                        defend_ids.add(dhid)

        # 3. أبطال الجمع التخصصيين المستبعدين دائماً من القتال
        gathering_hero_ids = {1711, 1724, 1733}

        # فحص المسيرات النشطة لاستخراج أي بطل منخرط حالياً في طابور مسير
        active_queue_heroes: Set[int] = set()
        if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
            for q_item in self.conn.init_data.get("local_queues", []):
                if isinstance(q_item, dict):
                    qid = self._safe_int(q_item.get("heroID", 0))
                    if qid > 0:
                        active_queue_heroes.add(qid)
                    q_heroes = q_item.get("heroInfo")
                    if isinstance(q_heroes, list):
                        for qh in q_heroes:
                            if isinstance(qh, dict):
                                qhid = self._safe_int(qh.get("heroID", 0))
                                if qhid > 0:
                                    active_queue_heroes.add(qhid)

        # 4. فلترة وتجهيز المرشحين (حصراً الأبطال في الحالة 1: HERO_STATE_NORMAL وفق معيار اللعبة الرسمي)
        candidates: List[Dict[str, Any]] = []
        for k, v in hero_list_raw.items():
            if not isinstance(v, dict):
                continue

            hid = self._safe_int(v.get("heroID", k))
            if hid <= 0 or hid in gathering_hero_ids or hid in defend_ids or hid in active_queue_heroes:
                continue

            state = self._safe_int(v.get("state"), 0)
            q = v.get("queue")
            has_queue = bool(q and isinstance(q, dict) and len(q) > 0)
            # الحالة 1 فقط تعني متفرغ وجاهز للمسير (gHeroState.HERO_STATE_NORMAL = 1)
            # الحالة 4 تعني HERO_STATE_BATTLE وحظر السيرفر المباشر بالخطأ 856008
            if state == 1 and not has_queue:
                quality = self._safe_int(v.get("quality"), 1)
                level = self._safe_int(v.get("level"), 1)
                is_awake = bool(v.get("isAwake", False))

                dress = v.get("dress", {})
                cur_dress = self._safe_int(dress.get("seting") if isinstance(dress, dict) else 0)
                own_lieutenant = bool(cur_dress > 0 and cur_dress % 100 > 1)

                candidates.append({
                    "heroID": hid,
                    "level": level,
                    "quality": quality,
                    "is_awake": is_awake,
                    "own_l": own_lieutenant,
                    "dress": cur_dress,
                })

        if not candidates:
            return []

        # 5. الفرز المطابق لخوارزمية اللعبة heroCtrl:sortDispatchHerosID
        candidates.sort(
            key=lambda x: (
                1 if x["own_l"] else 0,
                x["level"],
                x["quality"],
                1 if x["is_awake"] else 0,
                -x["heroID"],
            ),
            reverse=True,
        )

        # 6. اختيار أعلى الأبطال لملء كافة الخانات المتاحة
        selected_heroes: List[Dict[str, int]] = []
        for c in candidates[:max_slots]:
            selected_heroes.append({"heroID": int(c["heroID"])})

        return selected_heroes

    async def execute_command_hall_battle_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 7.0,
    ) -> Dict[str, Any]:
        """
        إنجاز مهمة معركة فريق الغزاة (نوع 5) أو طليعة الغزاة (نوع 2) بالكامل:
        1. الفحص القبلي للجاهزية (0-Network Pre-flight):
           - التحقق من نوع المهمة (5 معركة أو 2 طليعة) ووجود الإحداثيات.
           - التحقق من شاغرية الفيالق (get_available_marches_count() > 0).
           - التحقق من كفاية طاقة اللورد (10 طاقة).
           - التحقق من توفر القوات المقاتلة داخل القلعة.
        2. تجهيز الجيش والبطل:
           - استدعاء prepare_combat_troops() لتحقيق قوة الجيش الموصى بها.
           - استدعاء prepare_combat_hero() لانتقاء أعلى بطل قتالي متفرغ.
        3. مزامنة موقع الـ NPC الرسمي عبر CMD 2274 / SubCMD 9 (REQ_COMMAND_HALL_REFRESH_POS).
        4. إرسال المسير الرسمي نحو هدف الـ NPC على الخريطة (CMD 1007 / SubCMD 2) بإحداثيات خلايا الخريطة (Tile = Server - 1).
        5. الانتظار الإلزامي لحسم المعركة بالسيرفر (~7.0 ثوانٍ وفق زمن المسير الرسمي للعبة).
        6. استلام الجائزة فورياً وتثبيت الإنجاز عبر (CMD 2274 / SubCMD 8 - commitTask).
        7. تحديث الذاكرة الحية (خصم الطاقة، تحديث حالة المهمة والجوائز والخبرة).
        """
        if not isinstance(task, dict):
            return {"success": False, "reason": "كائن المهمة غير صالح أو مفقود."}

        task_id = self._safe_int(task.get("task_id") or task.get("taskID") or task.get("Index"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 0)
        if task_type == 0 and task_id > 0:
            task_type = task_id // 1000

        # التحقق من أن المهمة قتالية (فريق الغزاة 5 أو طليعة الغزاة 2)
        if task_type not in (2, 5):
            return {
                "success": False,
                "reason": f"هذه الدالة مخصصة لمهام المعارك والمسير (نوع 5 أو 2) وليست للنوع {task_type}.",
            }

        if task_index <= 0:
            return {"success": False, "reason": "معرف مؤشر المهمة (index) غير صالح."}

        # فحص إحداثيات الهدف
        pos = task.get("pos") or {}
        if not isinstance(pos, dict) or not pos.get("x") or not pos.get("y"):
            obj = task.get("obj") or (task.get("raw", {}).get("obj") if isinstance(task.get("raw"), dict) else {})
            if isinstance(obj, dict) and obj.get("x") and obj.get("y"):
                pos = {"x": self._safe_int(obj.get("x")), "y": self._safe_int(obj.get("y"))}

        target_x = self._safe_int(pos.get("x"))
        target_y = self._safe_int(pos.get("y"))
        if target_x <= 0 or target_y <= 0:
            return {"success": False, "reason": "إحداثيات هدف المعركة غير متوفرة على الخريطة."}

        # 1. فحص الشواغر والموارد (0-Network)
        avail_marches = self.get_available_marches_count()
        if avail_marches <= 0:
            return {
                "success": False,
                "reason": "لا توجد طوابير مسير شاغرة حالياً (كافة الفيالق نشطة بالخارج).",
            }

        stamina_cost = self._safe_int(task.get("stamina_cost"), 10)
        if self.stamina < stamina_cost:
            return {
                "success": False,
                "reason": f"طاقة اللورد غير كافية ({self.stamina} متوفر | المطلوب: {stamina_cost}).",
            }

        avail_troops = self.get_available_troops_count()
        if avail_troops <= 0:
            return {"success": False, "reason": "لا توجد قوات مقاتلة متاحة داخل القلعة."}

        # 2. تجهيز الجيش والبطل
        selected_troops = self.prepare_combat_troops(task_id=task_id)
        if not selected_troops:
            return {"success": False, "reason": "تعذر تشكيل فرقة القوات المقاتلة."}

        selected_heroes = self.prepare_combat_hero(task_id=task_id)
        hero_ids_str = ", ".join(str(h["heroID"]) for h in selected_heroes)
        hero_log_str = f" مع الأبطال ({hero_ids_str})" if selected_heroes else " (بدون أبطال)"
        total_troops_num = sum(t.get("num", 0) for t in selected_troops)

        # 3. مزامنة وتنشيط موقع الـ NPC على الخريطة لدى السيرفر (CMD 2274 / SubCMD 9)
        fresh_server_x = target_x
        fresh_server_y = target_y
        ref_resp = await self.safe_query(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_REFRESH_POS, {"x": target_x, "y": target_y}, min_delay=0.3, max_delay=0.6)
        if isinstance(ref_resp, dict):
            rspdata = ref_resp.get("rspdata")
            if isinstance(rspdata, dict) and rspdata.get("x") and rspdata.get("y"):
                fresh_server_x = self._safe_int(rspdata.get("x"))
                fresh_server_y = self._safe_int(rspdata.get("y"))

        # تحويل إحداثيات السيرفر إلى إحداثيات خلايا الخريطة للعميل (Tile Pos = Server Pos - 1)
        tile_x = fresh_server_x - 1
        tile_y = fresh_server_y - 1

        task_title = "طليعة الغزاة" if task_type == 2 else "فريق الغزاة"
        self.log(
            f"⚔️ [قاعة القيادة] إرسال فيلق معركة لمهمة {task_title} #{task_index} (ID: {task_id}) "
            f"نحو الهدف ({tile_x}, {tile_y}) [سيرفر: {fresh_server_x}, {fresh_server_y}] — جنود: {total_troops_num:,}{hero_log_str}..."
        )

        # 4. بناء حزمة إرسال المسير الرسمية (CMD 1007 / SubCMD 2)
        march_payload = {
            "to": {"x": tile_x, "y": tile_y},
            "moveLineType": 15,  # moveLineTypeCommandHallNpc
            "matrixType": 1,     # moveLineMatrixTypeTroop
            "taskIndex": task_index,
            "taskType": task_type,
            "commandHallTaskType": task_type,
            "commandHallTaskID": task_id,
            "army": selected_troops,
            "heroInfo": selected_heroes,
            "armsInfo": [],
            "divineBeastInfo": [],
            "data": {
                "to": {"x": tile_x, "y": tile_y},
                "data": {
                    "commandHallTaskType": task_type,
                    "commandHallTaskID": task_id,
                },
                "army": selected_troops,
                "heroInfo": selected_heroes,
                "armsInfo": [],
                "divineBeastInfo": [],
                "mapId": 1,
                "isDuel": False,
                "isKillLeaderNpc": False,
                "killNormalNpcLv": 0,
                "isForbidSpeed": False,
                "isSecondaryLock": False,
            },
        }

        # إرسال طلب المسير
        march_resp = await self.safe_query("1007", "2", march_payload, min_delay=0.6, max_delay=1.2)
        if not isinstance(march_resp, dict) or str(march_resp.get("err", march_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
            err_msg = march_resp.get("err") if isinstance(march_resp, dict) else "لم يرد استجابة من السيرفر"
            self.log(f"⚠️ [قاعة القيادة] تعذر إرسال فيلق المعركة للمهمة #{task_index} (الخطأ: {err_msg}).")
            return {
                "success": False,
                "reason": f"فشل طلب إرسال الفيلق: {err_msg}",
                "march_response": march_resp,
            }

        # خصم طاقة اللورد محلياً في الذاكرة الحية (0-Network)
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            base = lord.get("base")
            if isinstance(base, dict) and "health" in base:
                base["health"] = max(0, self._safe_int(base["health"]) - stamina_cost)

        self.log(f"🏹 [قاعة القيادة] انطلق الفيلق بنجاح إلى الهدف ({tile_x}, {tile_y}) — انتظار حسم المعركة بالسيرفر ({wait_seconds} ثانية)...")

        # 4. الانتظار الإلزامي لحسم المعركة
        await asyncio.sleep(max(1.0, float(wait_seconds)))

        # 5. استلام الجائزة فورياً عبر CMD 2274 / SubCMD 8
        self.log(f"🎁 [قاعة القيادة] استلام جوائز معركة فريق الغزاة #{task_index}...")
        claim_payload = {"commitType": task_type, "index": task_index}
        claim_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            claim_payload,
            min_delay=0.5,
            max_delay=1.0,
        )

        rewards = []
        claim_success = False
        if isinstance(claim_resp, dict) and str(claim_resp.get("err", claim_resp.get("code", "0"))).strip() in ("0", "Err_None"):
            claim_success = True
        else:
            # محاولة احتياطية ثانية بعد ثانية ونصف في حال استغرق السيرفر زمناً إضافياً لحسم المعركة
            await asyncio.sleep(1.5)
            claim_resp = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_COMMIT_TASK,
                claim_payload,
                min_delay=0.4,
                max_delay=0.8,
            )
            if isinstance(claim_resp, dict) and str(claim_resp.get("err", claim_resp.get("code", "0"))).strip() in ("0", "Err_None"):
                claim_success = True

        if claim_success:
            rspdata = claim_resp.get("rspdata")
            if isinstance(rspdata, dict) and "reward" in rspdata:
                rewards = rspdata.get("reward") or []
            elif "reward" in claim_resp:
                rewards = claim_resp.get("reward") or []

            # تحديث الذاكرة الحية (0-Network Cache Sync)
            init_data = rspdata.get("initData") if isinstance(rspdata, dict) else None
            if isinstance(init_data, dict):
                if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                    cached = self.conn.init_data.setdefault("commandHall", {})
                    if isinstance(cached, dict):
                        cached.update(init_data)
            else:
                # وضع علامة اكتمال على المهمة محلياً بالذاكرة
                cached_hall = self.get_ctrl("commandHall")
                if isinstance(cached_hall, dict):
                    for task_arr_key in ("commonTaskData", "taskList"):
                        arr = cached_hall.get(task_arr_key)
                        if isinstance(arr, list):
                            for itm in arr:
                                if isinstance(itm, dict) and self._safe_int(itm.get("index")) == task_index:
                                    itm["statue"] = 0
                        elif isinstance(arr, dict):
                            for itm in arr.values():
                                if isinstance(itm, dict) and self._safe_int(itm.get("index")) == task_index:
                                    itm["statue"] = 0

            self.log(f"✅ [قاعة القيادة] تم حسم المعركة واستلام جوائز {task_title} #{task_index} بنجاح!")
        else:
            claim_err = claim_resp.get("err") if isinstance(claim_resp, dict) else "no_response"
            self.log(f"ℹ️ [قاعة القيادة] حسمت المعركة لمهمة {task_title} #{task_index} بنجاح عبر المسير (رد استلام الجائزة: {claim_err}).")

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "target_pos": {"server": {"x": fresh_server_x, "y": fresh_server_y}, "tile": {"x": tile_x, "y": tile_y}},
            "troops_sent": selected_troops,
            "heroes_sent": selected_heroes,
            "stamina_spent": stamina_cost,
            "march_response": march_resp,
            "claim_response": claim_resp,
            "claim_success": claim_success,
            "rewards": rewards,
            "message": f"تم إنجاز معركة {task_title} #{task_index} واستلام الجوائز بنجاح." if claim_success else f"تم إرسال فيلق المعركة لمهمة {task_title} #{task_index} بنجاح.",
        }


