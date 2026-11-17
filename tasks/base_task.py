# -*- coding: utf-8 -*-
"""
python tools/test_base_task.py --email beetoo2@hotmail.com --fn get_lord_skill_status



python tools/test_base_task.py --email beetoo3@hotmail.com --fn get_lord_skill_status --skill  "الطاقة الوافرة"


python tools/test_base_task.py --email beetoo2@hotmail.com --fn use_lord_skill --skill  "الإكسير الفتاك"


python tools/test_base_task.py --email beetoo3@hotmail.com command_hall



python tools/test_base_task.py --email beetoo2 --fn get_material_workshop_status


python tools/test_base_task.py --email beetoo1 --fn get_resource_buildings_boost_status

"""

from __future__ import annotations

import asyncio
from abc import ABC, abstractmethod
import math
import random
import re
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple, Union

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

# ═════════════════════════════════════════════════════════════════════════
# ثوابت وجداول مهارات ومواهب الأمير الرسمية للعبة (Lord Skills Standards)
# مستخرجة بدقة من سورس كود العميل الأصلي (lordSkillCtrl, skill.lua, etc.)
# ═════════════════════════════════════════════════════════════════════════

CMD_LORD_MODULE = "1002"
REQ_LORD_SKILL_UPGRADE = "20"    # ترقية مستوى المهارة
REQ_LORD_SKILL_RESET = "21"      # إعادة تعيين مهارات الطقم
REQ_LORD_SKILL_USE = "22"        # استخدام/تفعيل المهارة النشطة
REQ_LORD_SKILL_SWITCH = "23"     # التبديل إلى طقم مهارات آخر
REQ_LORD_SKILL_SET_TITLE = "24"  # تغيير مسمى طقم المهارات

# تصنيفات مهارات ومواهب اللورد
LORD_SKILL_TYPE_BATTLE = 1     # قتالي (Battle)
LORD_SKILL_TYPE_DEVELOP = 2    # تطوير/إنتاج (Develop)
LORD_SKILL_TYPE_AUXILIARY = 3  # مساعد/دعم (Auxiliary)

# كتالوج المهارات النشطة الرسمية الـ 16 في اللعبة
LORD_ACTIVE_SKILLS_CATALOG: Dict[int, Dict[str, Any]] = {
    11011: {
        "id": 11011,
        "name_ar": "العودة الفورية",
        "name_en": "Immediate Return",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": 1213,
        "buff_id": None,
        "base_cd": 28800,  # 8 ساعات
        "is_active_skill": True,
        "description": "استدعاء كافة القوات التابعة للقلعة بالخارج فوراً دون انتظار وقت المسير.",
        "aliases": ["العودة الفورية", "العودة", "عودة_فورية", "immediate_return", "recall", "return", "11011"],
    },
    11028: {
        "id": 11028,
        "name_ar": "الإنقاذ",
        "name_en": "Rescue",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": 1214,
        "buff_id": 4501,
        "base_cd": 28800,  # 8 ساعات
        "is_active_skill": True,
        "description": "تحويل قتلى المعركة القادمة إلى جرحى يدخلون الخيام الطبية.",
        "aliases": ["الإنقاذ", "انقاذ", "اسعاف", "الإسعاف", "rescue", "help", "first_aid", "11028"],
    },
    11029: {
        "id": 11029,
        "name_ar": "زيادة المسيرة",
        "name_en": "General Mobilization",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": None,
        "buff_id": 4506,
        "base_cd": 57600,  # 16 ساعة
        "is_active_skill": True,
        "description": "زيادة سعة استيعاب الفيلق للمسيرة بنسبة 10% لمدة ساعتين.",
        "aliases": ["زيادة المسيرة", "تعبئة عامة", "التعبئة العامة", "تعبئة", "general_mobilization", "mobilization", "march_size", "11029"],
    },
    11042: {
        "id": 11042,
        "name_ar": "حشد سوبر",
        "name_en": "Super Rally",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": 1247,
        "buff_id": 5128,
        "base_cd": 57600,  # 16 ساعة
        "is_active_skill": True,
        "description": "زيادة الحد الأقصى لسعة القوات المحشودة.",
        "aliases": ["حشد سوبر", "حشد_سوبر", "حشد", "mass_support", "mass_num", "super_rally", "11042"],
    },
    11056: {
        "id": 11056,
        "name_ar": "السم القاتل",
        "name_en": "Deadly Poison",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": None,
        "buff_id": 5436,
        "base_cd": 18000,  # 5 ساعات
        "is_active_skill": True,
        "description": "إضعاف هجوم ودفاع قوات العدو.",
        "aliases": ["السم القاتل", "سم_قاتل", "deadly_poison", "poison", "11056"],
    },
    11057: {
        "id": 11057,
        "name_ar": "الإكسير الفتاك",
        "name_en": "Fatal Elixir",
        "type": LORD_SKILL_TYPE_BATTLE,
        "type_name": "battle",
        "queue_type": None,
        "buff_id": 5446,
        "base_cd": 18000,  # 5 ساعات
        "is_active_skill": True,
        "description": "زيادة الضرر والفتك في المعارك القتالية.",
        "aliases": ["الإكسير الفتاك", "اكسير_فتاك", "fatal_elixir", "elixir", "11057"],
    },
    12008: {
        "id": 12008,
        "name_ar": "حصاد وافر",
        "name_en": "Bumper Harvest",
        "type": LORD_SKILL_TYPE_DEVELOP,
        "type_name": "develop",
        "queue_type": 1215,
        "buff_id": None,
        "base_cd": 14400,  # 4 ساعات
        "is_active_skill": True,
        "description": "الحصول الفوري على إنتاج موارد القلعة داخل الأسوار.",
        "aliases": ["حصاد وافر", "حصاد", "الحصاد الوافر", "الحصاد", "bumper_harvest", "harvest", "bumper", "12008"],
    },
    12022: {
        "id": 12022,
        "name_ar": "الجمع السريع",
        "name_en": "Crazy Gather",
        "type": LORD_SKILL_TYPE_DEVELOP,
        "type_name": "develop",
        "queue_type": 1216,
        "buff_id": 4507,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "مضاعفة سرعة جمع الموارد على الخريطة بنسبة 100% لمدة ساعتين.",
        "aliases": ["الجمع السريع", "جمع سريع", "الجمع الجنوني", "crazy_gather", "fast_gather", "12022"],
    },
    12023: {
        "id": 12023,
        "name_ar": "الجمع الآمن",
        "name_en": "Gather Protect",
        "type": LORD_SKILL_TYPE_DEVELOP,
        "type_name": "develop",
        "queue_type": 1217,
        "buff_id": 4504,
        "base_cd": 28800,  # 8 ساعات
        "is_active_skill": True,
        "description": "حماية قوات جمع الموارد من هجمات أو استطلاع الأعداء لمدة ساعتين.",
        "aliases": ["الجمع الآمن", "جمع آمن", "حماية الجمع", "gather_protect", "safe_gather", "12023"],
    },
    12031: {
        "id": 12031,
        "name_ar": "إنتاج سريع",
        "name_en": "Resource Up",
        "type": LORD_SKILL_TYPE_DEVELOP,
        "type_name": "develop",
        "queue_type": 1248,
        "buff_id": 5129,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "مضاعفة إنتاج كافة حقول الموارد بالقلعة لمدة ساعتين.",
        "aliases": ["إنتاج سريع", "انتاج سريع", "مضاعفة الإنتاج", "resource_up", "production_boost", "12031"],
    },
    12042: {
        "id": 12042,
        "name_ar": "تحويل الموارد",
        "name_en": "Resource Conversion",
        "type": LORD_SKILL_TYPE_DEVELOP,
        "type_name": "develop",
        "queue_type": None,
        "buff_id": None,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "تحويل كمية من القمح إلى موارد آمنة ومحمية من النهب.",
        "aliases": ["تحويل الموارد", "تحويل موارد", "تحويل القمح", "resource_conversion", "convert_resource", "12042"],
    },
    13020: {
        "id": 13020,
        "name_ar": "عامل ماهر",
        "name_en": "Master Craft",
        "type": LORD_SKILL_TYPE_AUXILIARY,
        "type_name": "auxiliary",
        "queue_type": 1218,
        "buff_id": None,
        "base_cd": 14400,  # 4 ساعات
        "is_active_skill": True,
        "description": "الحصول فوراً على كمية من الفخاخ الدفاعية من أعلى مستوى متاح.",
        "aliases": ["عامل ماهر", "فخاخ فورية", "الفخاخ", "master_craft", "dap", "traps", "13020"],
    },
    13021: {
        "id": 13021,
        "name_ar": "الطاقة الوافرة",
        "name_en": "Physical Abundant",
        "type": LORD_SKILL_TYPE_AUXILIARY,
        "type_name": "auxiliary",
        "queue_type": None,
        "buff_id": None,
        "base_cd": 14400,  # 4 ساعات
        "is_active_skill": True,
        "description": "استعادة 30 نقطة طاقة إضافية للأمير فوراً.",
        "aliases": ["الطاقة الوافرة", "طاقة وافرة", "استعادة الطاقة", "physical_abundant", "stamina_boost", "13021"],
    },
    13022: {
        "id": 13022,
        "name_ar": "المسيرة السريعة",
        "name_en": "Rapid March",
        "type": LORD_SKILL_TYPE_AUXILIARY,
        "type_name": "auxiliary",
        "queue_type": None,
        "buff_id": 4505,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "مضاعفة سرعة مسيرة القوات في العالم.",
        "aliases": ["المسيرة السريعة", "مسيرة سريعة", "rapid_march", "fast_march", "13022"],
    },
    13032: {
        "id": 13032,
        "name_ar": "تسلل",
        "name_en": "Sneak Into",
        "type": LORD_SKILL_TYPE_AUXILIARY,
        "type_name": "auxiliary",
        "queue_type": 1249,
        "buff_id": 5130,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "إخفاء معلومات القلعة والمسيرات من الاستطلاع لمدة ساعتين.",
        "aliases": ["تسلل", "التسلل", "إخفاء القلعة", "sneak_into", "sneak", "stealth", "13032"],
    },
    13040: {
        "id": 13040,
        "name_ar": "الإستحواذ الهادئ",
        "name_en": "Quiet Acquisition",
        "type": LORD_SKILL_TYPE_AUXILIARY,
        "type_name": "auxiliary",
        "queue_type": None,
        "buff_id": 5425,
        "base_cd": 86400,  # 24 ساعة
        "is_active_skill": True,
        "description": "استهلاك كامل طاقة اللورد في ضربة وحوش واحدة مع مضاعفة الجوائز المقابلة.",
        "aliases": ["الإستحواذ الهادئ", "استحواذ هادئ", "quiet_acquisition", "monster_energy_dump", "13040"],
    },
}

# قاموس التطابق السريع للأسماء والرموز والـ IDs
SKILL_ALIAS_TO_ID: Dict[str, int] = {}
for _sid, _meta in LORD_ACTIVE_SKILLS_CATALOG.items():
    SKILL_ALIAS_TO_ID[str(_sid)] = _sid
    SKILL_ALIAS_TO_ID[_meta["name_ar"].lower().strip()] = _sid
    SKILL_ALIAS_TO_ID[_meta["name_en"].lower().strip()] = _sid
    for _alias in _meta.get("aliases", []):
        SKILL_ALIAS_TO_ID[_alias.lower().strip()] = _sid

# ═════════════════════════════════════════════════════════════════════════
# ثوابت وجداول مهارات الحشد التآزرية للأبطال (Hero Rally Skills Standards)
# مستخرجة بدقة من سورس كود العميل الأصلي (heroComboSkillCtrl, hero_combos_skill.lua)
# تبويب 'مهارات الحشد' (common_text_4870) في نافذة المهارات النشطة (skillNewActiveViewPanel)
# ═════════════════════════════════════════════════════════════════════════

CMD_HERO_COMBO_SKILL_MODULE = "2235"
REQ_HERO_COMBO_SKILL_INIT = "1"  # استدعاء بيانات ومستويات مهارات الحشد
REQ_HERO_COMBO_SKILL_USE = "2"   # تفعيل مهارة الحشد (مع skillGroup)

HERO_RALLY_SKILLS_CATALOG: Dict[int, Dict[str, Any]] = {
    172308: {
        "id": 172308,
        "group_id": 172308,
        "name_ar": "نداء الحشود",
        "name_en": "Rally Call",
        "troop_type": "bowmen",
        "troop_name_ar": "رماة",
        "hero_id": 1723,
        "hero_name_ar": "الأمير القناص",
        "lieutenant_id": 1726,
        "lieutenant_name_ar": "جسار",
        "dress_id": 172302,
        "skill_ids": [17230801, 17230802, 17230803, 17230804, 17230805],
        "effect_seconds": 3600,
        "base_cd": 0,
        "description": "انطلاق حشد الرماة مباشرة فور بلوغ عدد الجنود الحد الأقصى ووصول كافة الفرق المشاركة إلى قلعة الأمير الحاشد.",
        "aliases": ["نداء الحشود", "نداء_الحشود", "نداء الحشد", "حشد الرماة", "حشد_رماة", "رماة_حشد", "rally_call", "bowmen_rally", "archer_rally", "172308"],
    },
    173608: {
        "id": 173608,
        "group_id": 173608,
        "name_ar": "مسيرة صف القوات",
        "name_en": "Troop Line March",
        "troop_type": "infantry",
        "troop_name_ar": "مشاة",
        "hero_id": 1736,
        "hero_name_ar": "العاصوف",
        "lieutenant_id": 1720,
        "lieutenant_name_ar": "الكاسر",
        "dress_id": 173602,
        "skill_ids": [17360801, 17360802, 17360803, 17360804, 17360805],
        "effect_seconds": 3600,
        "base_cd": 0,
        "description": "انطلاق حشد المشاة مباشرة فور بلوغ عدد الجنود الحد الأقصى ووصول كافة الفرق المشاركة إلى قلعة الأمير الحاشد.",
        "aliases": ["مسيرة صف القوات", "مسيرة_صف_القوات", "صف القوات", "حشد المشاة", "حشد_مشاة", "مشاة_حشد", "troop_line_march", "infantry_rally", "173608"],
    },
    174308: {
        "id": 174308,
        "group_id": 174308,
        "name_ar": "الغارة السريعة",
        "name_en": "Rapid Raid",
        "troop_type": "cavalry",
        "troop_name_ar": "فرسان",
        "hero_id": 1743,
        "hero_name_ar": "أميرة وحيد القرن",
        "lieutenant_id": 1721,
        "lieutenant_name_ar": "صائد الفرسان",
        "dress_id": 174302,
        "skill_ids": [17430801, 17430802, 17430803, 17430804, 17430805],
        "effect_seconds": 3600,
        "base_cd": 0,
        "description": "انطلاق حشد الفرسان مباشرة فور بلوغ عدد الجنود الحد الأقصى ووصول كافة الفرق المشاركة إلى قلعة الأمير الحاشد.",
        "aliases": ["الغارة السريعة", "الغارة_السريعة", "غارة سريعة", "حشد الفرسان", "حشد_فرسان", "فرسان_حشد", "rapid_raid", "cavalry_rally", "174308"],
    },
}

HERO_RALLY_SKILL_ALIAS_TO_ID: Dict[str, int] = {}
for _rsid, _rmeta in HERO_RALLY_SKILLS_CATALOG.items():
    HERO_RALLY_SKILL_ALIAS_TO_ID[str(_rsid)] = _rsid
    HERO_RALLY_SKILL_ALIAS_TO_ID[_rmeta["name_ar"].lower().strip()] = _rsid
    HERO_RALLY_SKILL_ALIAS_TO_ID[_rmeta["name_en"].lower().strip()] = _rsid
    for _sub_id in _rmeta.get("skill_ids", []):
        HERO_RALLY_SKILL_ALIAS_TO_ID[str(_sub_id)] = _rsid
    for _ralias in _rmeta.get("aliases", []):
        HERO_RALLY_SKILL_ALIAS_TO_ID[_ralias.lower().strip()] = _rsid


# ═════════════════════════════════════════════════════════════════════════
# معمل المواد (Material Workshop / stuffWorkshopCtrl)
# ═════════════════════════════════════════════════════════════════════════
CMD_STUFF_WORKSHOP_MODULE = "2021"
REQ_STUFF_WORKSHOP_REFRESH = "1"
REQ_STUFF_WORKSHOP_REFINERY = "2"
REQ_STUFF_WORKSHOP_CANCEL = "3"
REQ_STUFF_WORKSHOP_GET = "4"
REQ_STUFF_WORKSHOP_OPEN_POS = "5"
REQ_STUFF_WORKSHOP_SWITCH_QUALITY = "6"
QUEUE_TYPE_STUFF_WORKSHOP = 1238

MATERIAL_BASE_NAMES: Dict[int, str] = {
    2001: "عشب",
    2002: "خشب بنفسجي",
    2003: "برونز",
    2004: "ياقوت",
    2005: "فرو",
    2006: "قرن",
    10: "عشب",
    11: "خشب بنفسجي",
    12: "برونز",
    13: "ياقوت",
    14: "فرو",
    15: "قرن",
}

MATERIAL_QUALITY_NAMES: Dict[int, str] = {
    0: "أبيض (عادي)",
    1: "أبيض (عادي)",
    2: "أخضر",
    3: "أزرق",
}

MATERIAL_WORKSHOP_CATALOG: Dict[int, Dict[str, Any]] = {
    # المستوى 1 (أبيض / عادي) - مدة التكرير 4 ساعات (14400 ثانية)
    200101: {"name": "عشب المستوى 1", "base_id": 2001, "base_name": "عشب", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},
    200201: {"name": "خشب بنفسجي المستوى 1", "base_id": 2002, "base_name": "خشب بنفسجي", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},
    200301: {"name": "برونز المستوى 1", "base_id": 2003, "base_name": "برونز", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},
    200401: {"name": "ياقوت المستوى 1", "base_id": 2004, "base_name": "ياقوت", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},
    200501: {"name": "فرو المستوى 1", "base_id": 2005, "base_name": "فرو", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},
    200601: {"name": "قرن المستوى 1", "base_id": 2006, "base_name": "قرن", "quality": 1, "quality_name": "أبيض (عادي)", "refine_time": 14400},

    # المستوى 2 (أخضر) - مدة التكرير 12 ساعة (43200 ثانية)
    200102: {"name": "عشب المستوى 2", "base_id": 2001, "base_name": "عشب", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},
    200202: {"name": "خشب بنفسجي المستوى 2", "base_id": 2002, "base_name": "خشب بنفسجي", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},
    200302: {"name": "برونز المستوى 2", "base_id": 2003, "base_name": "برونز", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},
    200402: {"name": "ياقوت المستوى 2", "base_id": 2004, "base_name": "ياقوت", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},
    200502: {"name": "فرو المستوى 2", "base_id": 2005, "base_name": "فرو", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},
    200602: {"name": "قرن المستوى 2", "base_id": 2006, "base_name": "قرن", "quality": 2, "quality_name": "أخضر", "refine_time": 43200},

    # المستوى 3 (أزرق) - مدة التكرير 24 ساعة (86400 ثانية)
    200103: {"name": "عشب المستوى 3", "base_id": 2001, "base_name": "عشب", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
    200203: {"name": "خشب بنفسجي المستوى 3", "base_id": 2002, "base_name": "خشب بنفسجي", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
    200303: {"name": "برونز المستوى 3", "base_id": 2003, "base_name": "برونز", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
    200403: {"name": "ياقوت المستوى 3", "base_id": 2004, "base_name": "ياقوت", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
    200503: {"name": "فرو المستوى 3", "base_id": 2005, "base_name": "فرو", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
    200603: {"name": "قرن المستوى 3", "base_id": 2006, "base_name": "قرن", "quality": 3, "quality_name": "أزرق", "refine_time": 86400},
}

# ═════════════════════════════════════════════════════════════════════════
# جداول أدوات تسريع ومضاعفة إنتاج الحقول والمناجم (Resource Boost Tools)
# والتسريعات العامة المعزولة (General Speedups)
# ═════════════════════════════════════════════════════════════════════════

RESOURCE_BOOST_KEY_MAP: Dict[str | int, str] = {
    # 1. القمح / المزرعة (Wheat / Farm) - دعم المزرعة (501501)
    "wheat": "wheat", "food": "wheat", "farm": "wheat", "قمح": "wheat", "مزرعة": "wheat", "مزارع": "wheat",
    "القمح": "wheat", "المزرعة": "wheat", "المزارع": "wheat", "غذاء": "wheat", "طعام": "wheat",
    "201": "wheat", 201: "wheat", "501501": "wheat", 501501: "wheat",

    # 2. الخشب / المنشرة (Wood / Sawmill) - دعم المنشرة (501401)
    "wood": "wood", "sawmill": "wood", "timber": "wood", "خشب": "wood", "منشرة": "wood", "مناشر": "wood",
    "الخشب": "wood", "المنشرة": "wood", "المناشر": "wood",
    "202": "wood", 202: "wood", "501401": "wood", 501401: "wood",

    # 3. الحديد / منجم الحديد (Iron / Iron Mine) - دعم منجم الحديد (501601)
    "iron": "iron", "iron_mine": "iron", "ironmine": "iron", "حديد": "iron", "منجم_حديد": "iron",
    "منجم حديد": "iron", "مناجم حديد": "iron", "الحديد": "iron", "منجم الحديد": "iron",
    "203": "iron", 203: "iron", "501601": "iron", 501601: "iron",

    # 4. الفضة / منجم الفضة (Silver / Steel / Mithril) - دعم منجم الفضة (501701)
    "silver": "silver", "steel": "silver", "mithril": "silver", "silver_mine": "silver",
    "silvermine": "silver", "فضة": "silver", "الفضة": "silver", "منجم_فضة": "silver",
    "منجم فضة": "silver", "مناجم فضة": "silver", "منجم الفضة": "silver", "فولاذ": "silver",
    "204": "silver", 204: "silver", "501701": "silver", 501701: "silver",

    # 5. البلور / الألماس / منجم البلور (Crystal / Diamond) - دعم منجم البلور (503201)
    "crystal": "crystal", "diamond": "crystal", "crystal_mine": "crystal", "crystalmine": "crystal",
    "بلور": "crystal", "البلور": "crystal", "الماس": "crystal", "ألماس": "crystal", "الألماس": "crystal",
    "منجم_بلور": "crystal", "منجم بلور": "crystal", "مناجم بلور": "crystal", "منجم البلور": "crystal",
    "منجم الماس": "crystal", "منجم ألماس": "crystal", "منجم الألماس": "crystal",
    "217": "crystal", 217: "crystal", "218": "crystal", 218: "crystal", "503201": "crystal", 503201: "crystal",

    # 6. التسريعات العامة (General Speedups)
    "general": "general", "speedup": "general", "speedups": "general", "عام": "general", "عامة": "general",
    "تسريع": "general", "تسريعات": "general", "تسريع عام": "general", "تسريعات عامة": "general",
}

RESOURCE_BOOST_CATALOG: Dict[str, Dict[str, Any]] = {
    "wheat": {
        "item_id": 501501,
        "name_ar": "دعم المزرعة",
        "name_en": "Farm Boost",
        "resource": "wheat",
        "building_id": 201,
        "duration_seconds": 86400,  # 24 ساعة = مضاعفة إنتاج مزرعة واحدة لمدة يوم كامل
        "multiplier": 2.0,
    },
    "wood": {
        "item_id": 501401,
        "name_ar": "دعم المنشرة",
        "name_en": "Sawmill Boost",
        "resource": "wood",
        "building_id": 202,
        "duration_seconds": 86400,  # 24 ساعة = مضاعفة إنتاج منشرة واحدة لمدة يوم كامل
        "multiplier": 2.0,
    },
    "iron": {
        "item_id": 501601,
        "name_ar": "دعم منجم الحديد",
        "name_en": "Iron Mine Boost",
        "resource": "iron",
        "building_id": 203,
        "duration_seconds": 86400,  # 24 ساعة = مضاعفة إنتاج منجم حديد واحد لمدة يوم كامل
        "multiplier": 2.0,
    },
    "silver": {
        "item_id": 501701,
        "name_ar": "دعم منجم الفضة",
        "name_en": "Silver Mine Boost",
        "resource": "silver",
        "building_id": 204,
        "duration_seconds": 86400,  # 24 ساعة = مضاعفة إنتاج منجم فضة واحد لمدة يوم كامل
        "multiplier": 2.0,
    },
    "crystal": {
        "item_id": 503201,
        "name_ar": "دعم منجم البلور",
        "name_en": "Crystal Mine Boost",
        "resource": "crystal",
        "building_id": 217,
        "duration_seconds": 86400,  # 24 ساعة = مضاعفة إنتاج منجم بلور لمدة يوم كامل
        "multiplier": 2.0,
    },
}

GENERAL_SPEEDUP_CATALOG: Dict[int, Dict[str, Any]] = {
    500606: {"item_id": 500606, "name_ar": "تسريع دقيقة واحدة", "name_en": "1m Speedup", "seconds": 60},
    500601: {"item_id": 500601, "name_ar": "تسريع 5 دقائق", "name_en": "5m Speedup", "seconds": 300},
    500607: {"item_id": 500607, "name_ar": "تسريع 15 دقيقة", "name_en": "15m Speedup", "seconds": 900},
    500608: {"item_id": 500608, "name_ar": "تسريع 30 دقيقة", "name_en": "30m Speedup", "seconds": 1800},
    500602: {"item_id": 500602, "name_ar": "تسريع ساعة واحدة", "name_en": "1h Speedup", "seconds": 3600},
    500603: {"item_id": 500603, "name_ar": "تسريع 8 ساعات", "name_en": "8h Speedup", "seconds": 28800},
    500604: {"item_id": 500604, "name_ar": "تسريع 12 ساعة", "name_en": "12h Speedup", "seconds": 43200},
    500605: {"item_id": 500605, "name_ar": "تسريع 24 ساعة", "name_en": "24h Speedup", "seconds": 86400},
}

RESOURCE_BUILDING_METADATA: Dict[int, Dict[str, Any]] = {
    201: {
        "bid": 201,
        "resource": "wheat",
        "name_ar": "مزرعة",
        "plural_ar": "مزارع القمح",
        "name_en": "Farm",
        "boost_buff_id": 5020,
        "boost_item_id": 501501,
        "boost_item_name": "دعم المزرعة",
        "effect_type": 33,
    },
    202: {
        "bid": 202,
        "resource": "wood",
        "name_ar": "منشرة",
        "plural_ar": "مناشر الخشب",
        "name_en": "Sawmill",
        "boost_buff_id": 5019,
        "boost_item_id": 501401,
        "boost_item_name": "دعم المنشرة",
        "effect_type": 34,
    },
    203: {
        "bid": 203,
        "resource": "iron",
        "name_ar": "منجم حديد",
        "plural_ar": "مناجم الحديد",
        "name_en": "Iron Mine",
        "boost_buff_id": 5021,
        "boost_item_id": 501601,
        "boost_item_name": "دعم منجم الحديد",
        "effect_type": 35,
    },
    204: {
        "bid": 204,
        "resource": "silver",
        "name_ar": "منجم فضة",
        "plural_ar": "مناجم الفضة",
        "name_en": "Silver Mine",
        "boost_buff_id": 5022,
        "boost_item_id": 501701,
        "boost_item_name": "دعم منجم الفضة",
        "effect_type": 36,
    },
    217: {
        "bid": 217,
        "resource": "crystal",
        "name_ar": "منجم بلور",
        "plural_ar": "مناجم البلور",
        "name_en": "Crystal Mine",
        "boost_buff_id": 5131,
        "boost_item_id": 503201,
        "boost_item_name": "دعم منجم البلور",
        "effect_type": 98,
    },
    218: {
        "bid": 218,
        "resource": "crystal",
        "name_ar": "منجم بلور",
        "plural_ar": "مناجم البلور",
        "name_en": "Crystal Mine",
        "boost_buff_id": 5131,
        "boost_item_id": 503201,
        "boost_item_name": "دعم منجم البلور",
        "effect_type": 98,
    },
}

# ═════════════════════════════════════════════════════════════════════════
# جداول حزم وباقات طاقة اللورد الرسمية للعبة (Stamina Packs Standards)
# مستخرجة بدقة من سورس كود العميل الأصلي (itemdescribe.lua / local_cn / local_arab)
# ═════════════════════════════════════════════════════════════════════════

STAMINA_PACKS_KEY_MAP: Dict[str | int, str] = {
    # 1. باقة 10 طاقة (300401)
    "10": "10", 10: "10", "300401": "10", 300401: "10",
    "10 طاقة": "10", "طاقة 10": "10", "10_stamina": "10", "stamina_10": "10", "10stamina": "10",
    # 2. باقة 50 طاقة (300402)
    "50": "50", 50: "50", "300402": "50", 300402: "50",
    "50 طاقة": "50", "طاقة 50": "50", "50_stamina": "50", "stamina_50": "50", "50stamina": "50",
    # 3. باقة 100 طاقة (300403)
    "100": "100", 100: "100", "300403": "100", 300403: "100",
    "100 طاقة": "100", "طاقة 100": "100", "100_stamina": "100", "stamina_100": "100", "100stamina": "100",
    # 4. إجمالي كافة الحزم (Total)
    "total": "total", "all": "total", "المجموع": "total", "إجمالي": "total", "اجمالي": "total",
    "الكل": "total", "كل": "total", "طاقة": "total", "stamina": "total", "packs": "total",
}

STAMINA_PACKS_CATALOG: Dict[str, Dict[str, Any]] = {
    "10": {
        "item_id": 300401,
        "name": "10 طاقة",
        "name_ar": "10 طاقة",
        "name_en": "10 Stamina",
        "stamina_value": 10,
        "stamina_per_item": 10,
        "icon": "3004.png",
    },
    "50": {
        "item_id": 300402,
        "name": "50 طاقة",
        "name_ar": "50 طاقة",
        "name_en": "50 Stamina",
        "stamina_value": 50,
        "stamina_per_item": 50,
        "icon": "3004.png",
    },
    "100": {
        "item_id": 300403,
        "name": "100 طاقة",
        "name_ar": "100 طاقة",
        "name_en": "100 Stamina",
        "stamina_value": 100,
        "stamina_per_item": 100,
        "icon": "3004.png",
    },
}

STAMINA_PACKS_BY_ID: Dict[int, Dict[str, Any]] = {
    300401: STAMINA_PACKS_CATALOG["10"],
    300402: STAMINA_PACKS_CATALOG["50"],
    300403: STAMINA_PACKS_CATALOG["100"],
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

    def get_ctrl(self, name: str) -> Any:
        """
        جلب بيانات متحكم معين بأمان من الذاكرة الحية بدون رفع استثناءات (يدعم القواميس والمصفوفات).
        """
        if not self.conn:
            return {}
        if hasattr(self.conn, "get_ctrl"):
            c = self.conn.get_ctrl(name)
            if isinstance(c, (dict, list)):
                return c
        val = self.init_data.get(name) if hasattr(self, "init_data") and isinstance(self.init_data, dict) else None
        if isinstance(val, (dict, list)):
            return val
        return {}

    def record_daily_quest_event(self, task_type: int | str, increment: int = 1) -> None:
        """
        تحديث عداد النشاط اليومي في الذاكرة الحية (0-Network) لضمان مزامنة فورية لمتحكم everydayTaskCtrl.
        """
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.setdefault("eventInfo", {})
            if isinstance(event_info, dict):
                k = str(task_type)
                current = self._safe_int(event_info.get(k), 0)
                event_info[k] = current + increment

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

    @property
    def vip_level(self) -> int:
        """
        مستوى الـ VIP الفعلي للقلعة من مراجع الذاكرة الحية (0-Network).
        يقرأ من vipCtrl أولاً ثم من lordInfoCtrl.vip كبديل احتياطي.
        """
        vip_ctrl = self.get_ctrl("vipCtrl")
        if isinstance(vip_ctrl, dict):
            try:
                lv = int(vip_ctrl.get("vipLv", vip_ctrl.get("level", 0)) or 0)
                if lv > 0:
                    return lv
            except (ValueError, TypeError):
                pass
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            vip_obj = lord.get("vip", {})
            if isinstance(vip_obj, dict):
                try:
                    return int(vip_obj.get("level", vip_obj.get("vipLv", 0)) or 0)
                except (ValueError, TypeError):
                    pass
        return 0

    # ═════════════════════════════════════════════════════════════════════════
    # دوال فحص وإدارة مهارات ومواهب الأمير الذكية (0-Network Lord Skills Engine)
    # ═════════════════════════════════════════════════════════════════════════

    def resolve_lord_skill_id(self, skill_input: Any) -> Optional[int]:
        """
        مطابقة وتحويل مدخل المهارة إلى المعرف الرقمي الخماسي الرسمي (Smart Resolver):
        - يقبل أرقام خماسية (مثل 12008) أو سباعية (مثل 1200801 حيث يأخذ أول 5 خانات).
        - يقبل نصوصاً رقمية ('12008', '1101101').
        - يقبل الأسماء العربية والإنجليزية والرموز الشائعة ('حصاد وافر', 'الإنقاذ', 'rescue', 'harvest').
        """
        if skill_input is None:
            return None

        # 1. إذا كان المدخل رقماً صحيحاً
        if isinstance(skill_input, int):
            s = str(skill_input)
            if len(s) >= 5:
                return int(s[:5])
            return skill_input

        # 2. إذا كان المدخل نصاً
        if isinstance(skill_input, str):
            cleaned = skill_input.strip()
            if not cleaned:
                return None

            # فحص إذا كان نصاً رقمياً
            if cleaned.isdigit():
                if len(cleaned) >= 5:
                    return int(cleaned[:5])
                return int(cleaned)

            # فحص التطابق الدقيق مع قاموس الأسماء والرموز
            lowered = cleaned.lower()
            if lowered in SKILL_ALIAS_TO_ID:
                return SKILL_ALIAS_TO_ID[lowered]

            # فحص التطابق الجزئي المرن مع الكلمات المفتاحية
            for alias, sid in SKILL_ALIAS_TO_ID.items():
                if lowered == alias or lowered in alias or alias in lowered:
                    return sid

        return None

    def resolve_hero_rally_skill_id(self, skill_input: Any) -> Optional[int]:
        """
        التحليل الذكي المرن لمعرف مهارة الحشد التآزرية للأبطال (Hero Rally Skill ID Resolver):
        يقبل: رقم المجموعة (172308)، رقم الجودة الثماني (17230801)، الاسم بالعربية، أو الرمز بالإنجليزية.
        """
        if skill_input is None:
            return None

        # 1. إذا كان المدخل رقماً صحيحاً
        if isinstance(skill_input, int):
            if skill_input in HERO_RALLY_SKILLS_CATALOG:
                return skill_input
            s = str(skill_input)
            if len(s) == 8 and int(s[:6]) in HERO_RALLY_SKILLS_CATALOG:
                return int(s[:6])
            if s in HERO_RALLY_SKILL_ALIAS_TO_ID:
                return HERO_RALLY_SKILL_ALIAS_TO_ID[s]
            return None

        # 2. إذا كان المدخل نصاً
        if isinstance(skill_input, str):
            cleaned = skill_input.strip()
            if not cleaned:
                return None
            if cleaned.isdigit():
                if len(cleaned) == 8 and int(cleaned[:6]) in HERO_RALLY_SKILLS_CATALOG:
                    return int(cleaned[:6])
                val_int = int(cleaned)
                if val_int in HERO_RALLY_SKILLS_CATALOG:
                    return val_int
                if cleaned in HERO_RALLY_SKILL_ALIAS_TO_ID:
                    return HERO_RALLY_SKILL_ALIAS_TO_ID[cleaned]
                return None

            lowered = cleaned.lower()
            if lowered in HERO_RALLY_SKILL_ALIAS_TO_ID:
                return HERO_RALLY_SKILL_ALIAS_TO_ID[lowered]

            for alias, sid in HERO_RALLY_SKILL_ALIAS_TO_ID.items():
                if lowered == alias or lowered in alias or alias in lowered:
                    return sid

        return None

    def get_lord_skill_status(self, skill_id: Any = None) -> Dict[str, Any]:
        """
        محرك فحص مهارات ومواهب الأمير المعتمد كلياً على الذاكرة الحية المحدثة (0-Network Pre-flight):
        
        يفحص المهارة ويرجع:
          1. هل هي متوفرة أصلاً للقلعة (متعلمة ومفتوحة بنقاط في أي طقم)؟
          2. هل هي قيد التفعيل حالياً (سريان مفعول باف أو طابور نشط)؟
          3. هل هي في فترة انتظار التبريد (Cooldown) وكم الثواني المتبقية؟
          4. في أي طقم (Preset) موجودة، وما مستواها فيه، وهل موجودة في الطقم النشط حالياً؟
          5. هل هي جاهزة للتفعيل الفوري الآن؟
          6. هل يمكن التبديل لطقم يحتوي عليها إذا لم تكن في الطقم النشط؟

        :param skill_id: معرف المهارة (رقم خماسي أو سباعي أو اسم/رمز باللغة العربية أو الإنجليزية).
                         إذا تم تمرير None، يرجع تقريراً شاملاً بكافة مهارات اللورد النشطة في القلعة.
        :return: قاموس بيانات تفصيلي ذكي وموحد لحالة المهارة أو تقرير شامل إذا كان skill_id فارغاً.
        """
        # إذا لم يتم تمرير معرف مهارة، إرجاع تقرير شامل لجميع المهارات بالقلعة
        if skill_id is None or str(skill_id).strip() == "":
            lord_skills = self.get_ctrl("lordSkillCtrl")
            active_set_id = str(lord_skills.get("activeSetID", "1")) if isinstance(lord_skills, dict) else "1"
            point_total = int(lord_skills.get("pointTotal", 0) or 0) if isinstance(lord_skills, dict) else 0

            active_skills_report: Dict[int, Dict[str, Any]] = {}
            can_activate_list: List[Dict[str, Any]] = []
            available_list: List[Dict[str, Any]] = []
            in_cooldown_list: List[Dict[str, Any]] = []

            for sid in LORD_ACTIVE_SKILLS_CATALOG.keys():
                st = self.get_lord_skill_status(sid)
                active_skills_report[sid] = st
                if st.get("can_activate"):
                    can_activate_list.append(st)
                if st.get("is_available"):
                    available_list.append(st)
                if st.get("in_cooldown"):
                    in_cooldown_list.append(st)

            return {
                "success": True,
                "summary": True,
                "active_set_id": active_set_id,
                "point_total": point_total,
                "total_catalog_active_skills": len(LORD_ACTIVE_SKILLS_CATALOG),
                "available_skills_count": len(available_list),
                "can_activate_count": len(can_activate_list),
                "in_cooldown_count": len(in_cooldown_list),
                "can_activate_skills": [
                    {"id": s["skill_id"], "name": s["skill_name"], "level": s["current_level"]}
                    for s in can_activate_list
                ],
                "available_skills": [
                    {
                        "id": s["skill_id"],
                        "name": s["skill_name"],
                        "in_active_set": s["is_in_active_set"],
                        "level": s["current_level"],
                        "sets": [sf["set_id"] for sf in s.get("sets_found", [])],
                        "can_activate": s["can_activate"],
                        "in_cooldown": s["in_cooldown"],
                    }
                    for s in available_list
                ],
                "cooldown_skills": [
                    {"id": s["skill_id"], "name": s["skill_name"], "cd_remaining_sec": s["cd_remaining_seconds"]}
                    for s in in_cooldown_list
                ],
                "rally_skills_summary": self.get_hero_rally_skill_status(None),
                "skills_details": active_skills_report,
            }

        # فحص إذا كان المعرف يخص إحدى مهارات الحشد التآزرية للأبطال
        rally_id = self.resolve_hero_rally_skill_id(skill_id)
        if rally_id is not None:
            return self.get_hero_rally_skill_status(rally_id)

        resolved_id = self.resolve_lord_skill_id(skill_id)
        if resolved_id is None:
            return {
                "success": False,
                "error": f"معرف المهارة غير معروف أو غير صالح: {skill_id}",
                "skill_id": skill_id,
                "resolved_id": None,
                "skill_name": "غير معروف",
                "skill_name_en": "",
                "is_available": False,
                "is_learned": False,
                "is_in_active_set": False,
                "active_set_id": "1",
                "current_level": 0,
                "sets_found": [],
                "sets_count": 0,
                "is_active": False,
                "is_buff_active": False,
                "buff_remaining_seconds": 0,
                "in_cooldown": False,
                "cd_remaining_seconds": 0,
                "can_activate": False,
                "can_switch_to_set": False,
                "target_switch_set_id": None,
            }

        # جلب البيانات الوصفية للمهارة من الكتالوج الرسمي
        meta = LORD_ACTIVE_SKILLS_CATALOG.get(resolved_id, {})
        is_cataloged_active = meta.get("is_active_skill", False)
        skill_name_ar = meta.get("name_ar", f"مهارة {resolved_id}")
        skill_name_en = meta.get("name_en", "")
        skill_type = meta.get("type_name", "unknown")
        base_cd = meta.get("base_cd", 0)
        target_buff_id = meta.get("buff_id")
        target_queue_type = meta.get("queue_type")

        # 1. قراءة بيانات مهارات اللورد من الذاكرة الحية (lordSkillCtrl)
        lord_skills = self.get_ctrl("lordSkillCtrl")
        if not isinstance(lord_skills, dict):
            lord_skills = {}

        active_set_id = str(lord_skills.get("activeSetID", "1"))
        set_list_data = lord_skills.get("setListData", {})
        if not isinstance(set_list_data, dict):
            set_list_data = {}

        cd_data = lord_skills.get("CDData", {})
        if not isinstance(cd_data, dict):
            cd_data = {}

        point_total = int(lord_skills.get("pointTotal", 0) or 0)
        now_ts = int(time.time())

        # 2. فحص الأطقم التي تحتوي على المهارة ومستواها
        str_id = str(resolved_id)
        sets_found: List[Dict[str, Any]] = []
        skill_level_in_active_set = 0
        max_level_found = 0

        # فحص بديل احتياطي إذا كان setListData فارغاً (lordInfoCtrl.skill.skillBasic)
        fallback_skills: Dict[str, int] = {}
        if not set_list_data:
            lord_info = self.get_ctrl("lordInfoCtrl")
            if isinstance(lord_info, dict):
                sb = lord_info.get("skill", {}).get("skillBasic", {})
                if isinstance(sb, dict):
                    for k, v in sb.items():
                        lvl = v[1] if isinstance(v, list) and len(v) > 1 else v
                        try:
                            fallback_skills[str(k)] = int(lvl or 0)
                        except (ValueError, TypeError):
                            pass

        if set_list_data:
            for s_id_raw, s_info in set_list_data.items():
                s_id = str(s_id_raw)
                if not isinstance(s_info, dict):
                    continue
                s_list = s_info.get("list", {})
                if not isinstance(s_list, dict):
                    continue
                try:
                    lvl = int(s_list.get(str_id, 0) or 0)
                except (ValueError, TypeError):
                    lvl = 0

                if lvl > 0:
                    is_curr = (s_id == active_set_id)
                    if is_curr:
                        skill_level_in_active_set = lvl
                    if lvl > max_level_found:
                        max_level_found = lvl
                    sets_found.append({
                        "set_id": s_id,
                        "level": lvl,
                        "title": s_info.get("title", ""),
                        "is_active_set": is_curr,
                        "used_points": int(s_info.get("usedPoint", 0) or 0),
                        "power": int(s_info.get("power", 0) or 0),
                    })
        elif fallback_skills:
            lvl = int(fallback_skills.get(str_id, 0) or 0)
            if lvl > 0:
                skill_level_in_active_set = lvl
                max_level_found = lvl
                sets_found.append({
                    "set_id": "1",
                    "level": lvl,
                    "title": "",
                    "is_active_set": True,
                    "used_points": 0,
                    "power": 0,
                })

        # ترتيب الأطقم: الطقم النشط أولاً، ثم حسب رقم الطقم
        sets_found.sort(key=lambda s: (0 if s["is_active_set"] else 1, s["set_id"]))

        is_learned = (len(sets_found) > 0)
        is_in_active_set = (skill_level_in_active_set > 0)
        is_available = is_learned

        # 3. فحص حالة التبريد (CDData)
        in_cd = False
        cd_remain = 0
        cd_entry = cd_data.get(str_id) or cd_data.get(resolved_id)
        if cd_entry:
            cd_begin_time = 0
            cd_duration = 0
            if isinstance(cd_entry, dict):
                cd_begin_time = int(cd_entry.get("beginTime", 0) or 0)
                cd_duration = int(cd_entry.get("CD", 0) or 0)
            elif isinstance(cd_entry, (list, tuple)) and len(cd_entry) >= 2:
                cd_begin_time = int(cd_entry[0] or 0)
                cd_duration = int(cd_entry[1] or 0)

            if cd_duration > 0 and cd_begin_time > 0:
                elapsed = now_ts - cd_begin_time
                if elapsed < cd_duration:
                    in_cd = True
                    cd_remain = max(0, cd_duration - elapsed)

        # 4. فحص سريان مفعول المهارة حالياً (Active Buff / Queue)
        is_buff_active = False
        buff_remaining = 0

        # أ. فحص بافات القلعة (buffCtrl و newBuffCtrl)
        if target_buff_id is not None:
            str_bid = str(target_buff_id)
            buff_ctrl = self.get_ctrl("buffCtrl")
            new_buff_ctrl = self.get_ctrl("newBuffCtrl")
            for b_ctrl in (buff_ctrl, new_buff_ctrl):
                if not isinstance(b_ctrl, dict):
                    continue
                b_val = b_ctrl.get(str_bid) or b_ctrl.get(target_buff_id)
                if b_val:
                    is_buff_active = True
                    if isinstance(b_val, dict):
                        end_t = int(b_val.get("endTime") or b_val.get("finishTime") or b_val.get("time") or 0)
                        if end_t > now_ts:
                            buff_remaining = max(buff_remaining, end_t - now_ts)
                    elif isinstance(b_val, (int, float)) and b_val > now_ts:
                        buff_remaining = max(buff_remaining, int(b_val) - now_ts)

        # ب. فحص طوابير المهارات النشطة (queueCtrl)
        if target_queue_type is not None:
            queue_ctrl = self.get_ctrl("queueCtrl")
            if isinstance(queue_ctrl, dict):
                for qk, qv in queue_ctrl.items():
                    if not isinstance(qv, dict):
                        continue
                    qtype = qv.get("queueType") or qv.get("type")
                    if str(qtype) == str(target_queue_type):
                        f_time = int(qv.get("finishTime") or qv.get("endTime") or 0)
                        is_buff_active = True
                        if f_time > now_ts:
                            buff_remaining = max(buff_remaining, f_time - now_ts)

        # ج. تحديد حالة المهارة الكامنة (Passive Skill)
        if not is_cataloged_active:
            # المهارات الكامنة تكون نشطة طالما أنها متعلمة في الطقم المفعل حالياً
            is_active_now = is_in_active_set
        else:
            # المهارات النشطة تكون مفعلة إذا كان الباف أو الطابور قيد السريان
            is_active_now = is_buff_active

        # 5. جاهزية التفعيل الفوري (Can Activate Now)
        # تشترط: مهارة نشطة + متعلمة في الطقم النشط + ليست في تبريد + ليس تأثيرها فعالاً حالياً
        can_activate = (
            is_cataloged_active
            and is_in_active_set
            and not in_cd
            and not is_active_now
        )

        # 6. إمكانية التبديل لطقم يحتوي على المهارة (Can Switch To Set)
        can_switch_to_set = False
        target_switch_set_id: Optional[str] = None
        if not is_in_active_set and sets_found:
            candidate_set = sets_found[0]["set_id"]
            # فحص فك قفل الطقم المطلوب بحسب شروط اللعبة (lordskill_set_config)
            v_lv = self.vip_level
            is_unlocked = False
            if candidate_set == "1":
                is_unlocked = True
            elif candidate_set == "2":
                is_unlocked = (v_lv >= 9) or (candidate_set in set_list_data)
            elif candidate_set == "3":
                is_unlocked = (v_lv >= 13) or (candidate_set in set_list_data)
            else:
                is_unlocked = (candidate_set in set_list_data)

            if is_unlocked:
                can_switch_to_set = True
                target_switch_set_id = candidate_set

        return {
            "success": True,
            "skill_id": resolved_id,
            "skill_name": skill_name_ar,
            "skill_name_en": skill_name_en,
            "skill_type": skill_type,
            "is_active_skill": is_cataloged_active,
            "is_available": is_available,
            "is_learned": is_learned,
            "is_in_active_set": is_in_active_set,
            "active_set_id": active_set_id,
            "current_level": skill_level_in_active_set,
            "max_level_learned": max_level_found,
            "sets_found": sets_found,
            "sets_count": len(sets_found),
            "is_active": is_active_now,
            "is_buff_active": is_buff_active,
            "buff_remaining_seconds": buff_remaining,
            "in_cooldown": in_cd,
            "cd_remaining_seconds": cd_remain,
            "base_cd_seconds": base_cd,
            "can_activate": can_activate,
            "can_switch_to_set": can_switch_to_set,
            "target_switch_set_id": target_switch_set_id,
            "point_total": point_total,
            "description": meta.get("description", ""),
        }


    @staticmethod
    def _is_resp_ok(resp: Optional[Dict[str, Any]]) -> bool:
        """
        فحص نجاح استجابة السيرفر بشكل مرن ودقيق:
        يعتبر الطلب ناجحاً إذا كان err أو code هو 0 أو '0' أو 'Err_None' أو غير موجود.
        """
        if not isinstance(resp, dict):
            return False
        err = resp.get("err")
        if err is None:
            err = resp.get("code")
        if err is None:
            return True
        return str(err).strip() in ("0", "Err_None")

    async def switch_lord_skill_set(self, set_id: Any) -> Tuple[bool, str]:
        """
        التبديل إلى طقم مواهب/مهارات محدد مع تحديث فوري للذاكرة الحية (In-Memory State Sync).
        
        :param set_id: رقم الطقم المستهدف (مثل 1 أو 2).
        :return: (نجاح/فشل، رسالة توضيحية).
        """
        target_set = str(set_id)
        lord_skills = self.get_ctrl("lordSkillCtrl")
        if isinstance(lord_skills, dict):
            curr_set = str(lord_skills.get("activeSetID", "1"))
            if curr_set == target_set:
                return True, f"الطقم {target_set} مفعل بالفعل كطقم نشط حالياً."

        self.log(f"🔄 [مهارات اللورد] إرسال طلب التبديل إلى طقم المهارات {target_set}...")
        resp = await self.safe_query(
            CMD_LORD_MODULE,
            REQ_LORD_SKILL_SWITCH,
            {"setID": int(target_set) if target_set.isdigit() else target_set},
            min_delay=0.4,
            max_delay=0.8,
        )

        if not self._is_resp_ok(resp):
            err_code = resp.get("err", resp.get("code", "no_response")) if isinstance(resp, dict) else "no_response"
            return False, f"فشل تبديل طقم المهارات (كود الخطأ: {err_code})."

        # تحديث فوري للذاكرة الحية المحلية
        if hasattr(self, "conn") and isinstance(self.conn.init_data, dict):
            lord_skills = self.conn.init_data.setdefault("lordSkillCtrl", {})
            if isinstance(lord_skills, dict):
                lord_skills["activeSetID"] = int(target_set) if target_set.isdigit() else target_set

        self.log(f"✅ [مهارات اللورد] تم التبديل بنجاح إلى طقم المهارات {target_set}.")
        return True, f"تم التبديل بنجاح إلى طقم المهارات {target_set}."

    def _sync_skill_cd_in_memory(self, skill_id: int, resp: Dict[str, Any], status: Dict[str, Any]) -> None:
        """مزامنة فورية لحالة التبريد في كائن الذاكرة الحية (0-Network In-Memory State Sync)."""
        now_ts = int(time.time())
        base_cd = status.get("base_cd_seconds", 14400)
        rsp_data = resp.get("data", {}) if isinstance(resp.get("data"), dict) else {}
        cd_val = int(rsp_data.get("CD", base_cd) or base_cd)
        begin_t = int(rsp_data.get("beginTime", now_ts) or now_ts)

        if hasattr(self, "conn") and isinstance(self.conn.init_data, dict):
            lord_skills = self.conn.init_data.setdefault("lordSkillCtrl", {})
            if isinstance(lord_skills, dict):
                cd_data = lord_skills.setdefault("CDData", {})
                if isinstance(cd_data, dict):
                    cd_data[str(skill_id)] = {
                        "beginTime": begin_t,
                        "CD": cd_val,
                    }

    async def use_lord_skill(
        self,
        skill_id: Any,
        auto_revert: bool = True,
        step_delay: Optional[float] = None,
    ) -> Tuple[bool, str]:
        """
        تفعيل واستخدام المهارة النشطة للأمير بأمان، مع دعم التبديل التلقائي المؤقت والرجوع للطقم السابق:
        - إذا كانت المهارة في الطقم النشط: تُفعل مباشرة دون تبديل.
        - إذا كانت في طقم آخر (وكان auto_revert=True):
          1. حفظ رقم الطقم النشط الأصلي.
          2. التبديل إلى الطقم الذي يحتوي على المهارة.
          3. تفعيل المهارة وتحديث فترة التبريد (CDData).
          4. العودة الإلزامية في كتلة (try...finally) إلى الطقم الأصلي السابق.
        
        :param skill_id: معرف المهارة أو اسمها/رمزها.
        :param auto_revert: هل يتم الرجوع تلقائياً إلى الطقم الأصلي السابق بعد انتهاء التفعيل (افتراضياً True).
        :param step_delay: تخصيص الفاصل الزمني البشري بين الخطوات (افتراضياً عشوائي آمن بين 0.5 و 0.9 ثانية).
        :return: (نجاح/فشل، رسالة توضيحية).
        """
        # فحص ما إذا كانت المهارة المطلوبة هي إحدى مهارات الحشد التآزرية للأبطال
        rally_id = self.resolve_hero_rally_skill_id(skill_id)
        if rally_id is not None:
            return await self.use_hero_rally_skill(rally_id, step_delay=step_delay)

        status = self.get_lord_skill_status(skill_id)
        if not status.get("success"):
            return False, status.get("error", "فشل التعرف على المهارة.")

        resolved_id = status["skill_id"]
        skill_name = status["skill_name"]

        if not status.get("is_active_skill"):
            return False, f"المهارة '{skill_name}' ({resolved_id}) هي مهارة كامنة (Passive) وتعمل تلقائياً دون تفعيل يدوي."

        if not status.get("is_available"):
            return False, f"المهارة '{skill_name}' ({resolved_id}) غير متوفرة أو غير مفتوحة بنقاط للقلعة في أي طقم."

        if status.get("is_active"):
            return False, f"المهارة '{skill_name}' مفعّلة وسارية بالفعل حالياً (متبقي {status.get('buff_remaining_seconds')} ثانية)."

        if status.get("in_cooldown"):
            return False, f"المهارة '{skill_name}' في فترة تبريد (متبقي {status.get('cd_remaining_seconds')} ثانية)."

        original_set_id = str(status.get("active_set_id", "1"))
        in_active_set = status.get("is_in_active_set", False)
        target_set_id = str(status.get("target_switch_set_id") or original_set_id)

        # دالة مساعدة للفواصل الزمنية البشرية الآمنة
        async def _safe_delay():
            d = step_delay if (step_delay is not None and step_delay > 0) else random.uniform(0.5, 0.9)
            await asyncio.sleep(d)

        # الحالة 1: المهارة موجودة ومفعلة بالفعل في الطقم النشط حالياً (لا حاجة لأي تبديل)
        if in_active_set:
            self.log(f"⚡ [مهارات اللورد] إرسال طلب تفعيل المهارة النشطة: {skill_name} ({resolved_id})...")
            resp = await self.safe_query(
                CMD_LORD_MODULE,
                REQ_LORD_SKILL_USE,
                {"skillID": resolved_id},
                min_delay=0.4,
                max_delay=0.8,
            )
            if not self._is_resp_ok(resp):
                err_code = resp.get("err", resp.get("code", "no_response")) if isinstance(resp, dict) else "no_response"
                return False, f"فشل تفعيل المهارة '{skill_name}' من السيرفر (كود الخطأ: {err_code})."

            self._sync_skill_cd_in_memory(resolved_id, resp, status)
            self.log(f"✅ [مهارات اللورد] تم تفعيل المهارة '{skill_name}' بنجاح ودخلت فترة التبريد.")
            return True, f"تم تفعيل المهارة '{skill_name}' بنجاح."

        # الحالة 2: المهارة موجودة في طقم آخر غير النشط
        if not status.get("can_switch_to_set") or not target_set_id:
            return False, f"المهارة '{skill_name}' موجودة في طقم آخر ({target_set_id}) وغير متاحة للتبديل حالياً (شروط VIP غير مكتملة)."

        self.log(
            f"🔄 [مهارات اللورد] المهارة '{skill_name}' موجودة في الطقم {target_set_id}. "
            f"جاري التبديل المؤقت من الطقم الأصلي {original_set_id}..."
        )

        # 1. التبديل إلى الطقم الذي يحتوي على المهارة
        switch_ok, switch_msg = await self.switch_lord_skill_set(target_set_id)
        if not switch_ok:
            return False, f"فشل التبديل إلى الطقم {target_set_id}: {switch_msg}"

        success = False
        result_msg = ""

        try:
            # فاصل زمني بشري آمن قبل إرسال طلب التفعيل
            await _safe_delay()

            # 2. إرسال طلب تفعيل المهارة داخل الطقم المؤقت
            self.log(f"⚡ [مهارات اللورد] تفعيل المهارة '{skill_name}' ({resolved_id}) داخل الطقم {target_set_id}...")
            resp = await self.safe_query(
                CMD_LORD_MODULE,
                REQ_LORD_SKILL_USE,
                {"skillID": resolved_id},
                min_delay=0.4,
                max_delay=0.8,
            )

            if not self._is_resp_ok(resp):
                err_code = resp.get("err", resp.get("code", "no_response")) if isinstance(resp, dict) else "no_response"
                success = False
                result_msg = f"فشل تفعيل المهارة '{skill_name}' من السيرفر (كود الخطأ: {err_code})."
            else:
                success = True
                self._sync_skill_cd_in_memory(resolved_id, resp, status)
                result_msg = f"تم تفعيل المهارة '{skill_name}' بنجاح."
                self.log(f"✅ [مهارات اللورد] تم تفعيل المهارة '{skill_name}' بنجاح في الطقم {target_set_id}.")

        finally:
            # 3. العودة الإلزامية والحتمية إلى الطقم الأصلي السابق (Zero-Stranded Protocol)
            if auto_revert and target_set_id != original_set_id:
                await _safe_delay()
                self.log(f"🔄 [مهارات اللورد] جاري إعادة القلعة إلى طقمها الأصلي السابق {original_set_id}...")
                rev_ok, rev_msg = await self.switch_lord_skill_set(original_set_id)
                if not rev_ok:
                    self.log(f"⚠️ [مهارات اللورد] تحذير: تعذر استعادة الطقم السابق {original_set_id}: {rev_msg}")
                    if success:
                        result_msg += f" (ملاحظة: تعذر العودة للطقم الأصلي: {rev_msg})"
                else:
                    self.log(f"🛡️ [مهارات اللورد] تمت استعادة الطقم الأصلي {original_set_id} بنجاح.")

        return success, result_msg

    async def trigger_lord_skill_with_revert(
        self,
        skill_id: Any,
        auto_revert: bool = True,
        step_delay: Optional[float] = None,
    ) -> Tuple[bool, str]:
        """
        دالة صريحة مسماة لتفعيل مهارة معينة مع التبديل التلقائي والرجوع للطقم السابق:
        تقوم بفحص المهارة، التبديل لطقمها إن لزم، تفعيلها، ثم الرجوع الحتمي للطقم الأصلي.
        """
        return await self.use_lord_skill(skill_id, auto_revert=auto_revert, step_delay=step_delay)

    # ═════════════════════════════════════════════════════════════════════════
    # دوال مهارات الحشد التآزرية للأبطال (Hero Rally Skills Engine)
    # تبويب 'مهارات الحشد' (common_text_4870) - الوحدة CMD 2235 (heroComboSkillCtrl)
    # ═════════════════════════════════════════════════════════════════════════

    def get_hero_rally_skill_status(self, skill_id: Any = None) -> Dict[str, Any]:
        """
        محرك فحص مهارات الحشد التآزرية للأبطال المعتمد كلياً على الذاكرة الحية (0-Network Pre-flight):
        يفحص المهارة (نداء الحشود، مسيرة صف القوات، الغارة السريعة) ويرجع تفاصيل توفرها وتبريدها وجاهزيتها.
        """
        # إذا لم يتم تمرير معرف مهارة، إرجاع تقرير شامل لمهارات الحشد الثلاث
        if skill_id is None or str(skill_id).strip() == "":
            rally_report: Dict[int, Dict[str, Any]] = {}
            can_activate_list: List[Dict[str, Any]] = []
            available_list: List[Dict[str, Any]] = []
            active_buff_list: List[Dict[str, Any]] = []

            for rsid in HERO_RALLY_SKILLS_CATALOG.keys():
                rst = self.get_hero_rally_skill_status(rsid)
                rally_report[rsid] = rst
                if rst.get("can_activate"):
                    can_activate_list.append(rst)
                if rst.get("is_available"):
                    available_list.append(rst)
                if rst.get("is_active"):
                    active_buff_list.append(rst)

            return {
                "success": True,
                "summary": True,
                "module": "hero_combo_skill",
                "module_cmd": CMD_HERO_COMBO_SKILL_MODULE,
                "total_rally_skills": len(HERO_RALLY_SKILLS_CATALOG),
                "available_skills_count": len(available_list),
                "can_activate_count": len(can_activate_list),
                "active_buff_count": len(active_buff_list),
                "can_activate_skills": [
                    {"id": s["skill_id"], "name": s["skill_name"], "remaining_uses": s["remaining_uses_today"]}
                    for s in can_activate_list
                ],
                "available_skills": [
                    {"id": s["skill_id"], "name": s["skill_name"], "heroes": f"{s['hero_name']} + {s['lieutenant_name']}", "remaining_uses": s["remaining_uses_today"]}
                    for s in available_list
                ],
                "skills_details": rally_report,
            }

        resolved_id = self.resolve_hero_rally_skill_id(skill_id)
        if resolved_id is None:
            return {
                "success": False,
                "error": f"معرف مهارة الحشد غير معروف أو غير صالح: {skill_id}",
                "skill_id": skill_id,
                "resolved_id": None,
                "skill_name": "غير معروف",
                "is_available": False,
                "can_activate": False,
            }

        meta = HERO_RALLY_SKILLS_CATALOG[resolved_id]
        skill_name_ar = meta["name_ar"]
        skill_name_en = meta["name_en"]
        troop_type = meta["troop_type"]
        troop_name_ar = meta["troop_name_ar"]
        req_hero_id = meta["hero_id"]
        req_hero_name = meta["hero_name_ar"]
        req_lt_id = meta["lieutenant_id"]
        req_lt_name = meta["lieutenant_name_ar"]
        dress_id = meta["dress_id"]
        effect_sec = meta["effect_seconds"]

        # 1. فحص ملكية الأبطال في الذاكرة الحية (0-Network)
        hero_sys = self.get_ctrl("heroSysCtrl")
        hero_list = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
        if not isinstance(hero_list, dict):
            hero_list = {}

        hero_info = hero_list.get(str(req_hero_id)) or hero_list.get(req_hero_id)
        lt_info = hero_list.get(str(req_lt_id)) or hero_list.get(req_lt_id)

        has_primary_hero = bool(hero_info and isinstance(hero_info, dict))
        has_lieutenant = bool(lt_info and isinstance(lt_info, dict))
        is_available = has_primary_hero and has_lieutenant

        # استخراج جودة البطل (تحدد الحد الأقصى للاستخدام اليومي من 1 إلى 5 مرات)
        hero_quality = 1
        if has_primary_hero:
            try:
                hero_quality = max(1, min(5, int(hero_info.get("quality", 1) or 1)))
            except (ValueError, TypeError):
                hero_quality = 1
        daily_max_uses = hero_quality

        # 2. قراءة بيانات استخدام وتبريد مهارة الحشد من الذاكرة الحية (heroComboSkillCtrl)
        now_ts = int(time.time())
        combo_ctrl = self.get_ctrl("heroComboSkillCtrl")
        if not isinstance(combo_ctrl, dict):
            combo_ctrl = self.get_ctrl("heroComboSkill") or {}
        if not isinstance(combo_ctrl, dict):
            combo_ctrl = {}

        skill_group_info = combo_ctrl.get("skillGroupInfo") or combo_ctrl.get("skillData") or combo_ctrl
        if not isinstance(skill_group_info, dict):
            skill_group_info = {}

        group_data = skill_group_info.get(str(resolved_id)) or skill_group_info.get(resolved_id) or {}
        if not isinstance(group_data, dict):
            group_data = {}

        use_num = int(group_data.get("useNum", 0) or 0)
        remaining_uses = max(0, daily_max_uses - use_num) if is_available else 0
        begin_time = int(group_data.get("beginTime", 0) or 0)
        end_time = int(group_data.get("endTime", 0) or 0)
        cd_val = int(group_data.get("cd", 0) or 0)

        # 3. فحص سريان مفعول المهارة حالياً
        is_active = (end_time > now_ts)
        active_remaining_sec = max(0, end_time - now_ts) if is_active else 0

        # 4. فحص حالة التبريد
        in_cd = (cd_val > 0 and (begin_time + cd_val) > now_ts)
        cd_remaining_sec = max(0, (begin_time + cd_val) - now_ts) if in_cd else 0

        # 5. فحص وجود مسيرة حشد نشطة للقلعة (0-Network)
        conn = getattr(self, "conn", None)
        local_queues = self._read_live_local_queues(conn) if conn else []
        has_active_rally_queue = False
        for q in local_queues:
            if not isinstance(q, dict):
                continue
            q_status = q.get("status")
            q_type = q.get("queueType") or q.get("type")
            if q_status in (0, 7) or str(q_type) in ("0", "7"):
                has_active_rally_queue = True
                break

        # 6. جاهزية التفعيل الفوري
        can_activate = (
            is_available
            and remaining_uses > 0
            and not in_cd
            and not is_active
        )

        return {
            "success": True,
            "skill_id": resolved_id,
            "group_id": resolved_id,
            "skill_name": skill_name_ar,
            "skill_name_en": skill_name_en,
            "category": "hero_rally_skill",
            "troop_type": troop_type,
            "troop_name": troop_name_ar,
            "hero_id": req_hero_id,
            "hero_name": req_hero_name,
            "has_hero": has_primary_hero,
            "lieutenant_id": req_lt_id,
            "lieutenant_name": req_lt_name,
            "has_lieutenant": has_lieutenant,
            "dress_id": dress_id,
            "hero_quality": hero_quality,
            "daily_max_uses": daily_max_uses,
            "used_today": use_num,
            "remaining_uses_today": remaining_uses,
            "is_available": is_available,
            "is_active": is_active,
            "buff_remaining_seconds": active_remaining_sec,
            "in_cooldown": in_cd,
            "cd_remaining_seconds": cd_remaining_sec,
            "has_active_rally_queue": has_active_rally_queue,
            "can_activate": can_activate,
            "description": meta.get("description", ""),
        }

    def _sync_hero_rally_skill_in_memory(self, group_id: int, resp: Dict[str, Any], status: Dict[str, Any]) -> None:
        """مزامنة فورية لحالة مهارة الحشد في كائن الذاكرة الحية (0-Network In-Memory State Sync)."""
        now_ts = int(time.time())
        effect_sec = status.get("buff_remaining_seconds", 3600) or 3600

        rsp_data = resp.get("rspdata", {}) if isinstance(resp, dict) else {}
        skill_data_resp = rsp_data.get("skillData", {}) if isinstance(rsp_data, dict) else {}
        s_info = skill_data_resp.get(str(group_id)) or skill_data_resp.get(group_id)

        if hasattr(self, "conn") and isinstance(self.conn.init_data, dict):
            combo_ctrl = self.conn.init_data.setdefault("heroComboSkillCtrl", {})
            if isinstance(combo_ctrl, dict):
                group_map = combo_ctrl.setdefault("skillGroupInfo", {})
                if isinstance(group_map, dict):
                    if isinstance(s_info, dict):
                        group_map[str(group_id)] = s_info
                    else:
                        cur_entry = group_map.setdefault(str(group_id), {})
                        cur_entry["useNum"] = cur_entry.get("useNum", 0) + 1
                        cur_entry["beginTime"] = now_ts
                        cur_entry["endTime"] = now_ts + effect_sec
                        cur_entry["cd"] = 0

    async def use_hero_rally_skill(
        self,
        skill_id: Any,
        step_delay: Optional[float] = None,
    ) -> Tuple[bool, str]:
        """
        تفعيل واستخدام مهارة الحشد التآزرية للأبطال بأمان وموثوقية (0-Network Pre-flight):
        - يفحص توفر الأبطال المطلوبين، مرات الاستخدام المتبقية اليوم، وحالة السريان بالذاكرة الحية أولاً.
        - يرسل طلب التفعيل الرسمي لوحدة الأبطال (CMD 2235 / SubCMD 2 مع skillGroup).
        - يتحقق من الرد بدقة ويحدث كائن الذاكرة الحية محلياً لمنع تكرار الإرسال.

        :param skill_id: معرف مهارة الحشد (رقم المجموعة أو الاسم العربي/الإنجليزي).
        :param step_delay: فاصل بشري عشوائي بين الخطوات.
        :return: (نجاح/فشل، رسالة توضيحية).
        """
        status = self.get_hero_rally_skill_status(skill_id)
        if not status.get("success"):
            return False, status.get("error", "فشل التعرف على مهارة الحشد.")

        group_id = status["group_id"]
        skill_name = status["skill_name"]
        hero_req = f"{status['hero_name']} ومرافقه {status['lieutenant_name']}"

        if not status.get("is_available"):
            missing = []
            if not status.get("has_hero"):
                missing.append(status["hero_name"])
            if not status.get("has_lieutenant"):
                missing.append(status["lieutenant_name"])
            return False, f"مهارة الحشد '{skill_name}' غير متوفرة لعدم امتلاك الأبطال المطلوبين: {', '.join(missing)}."

        if status.get("is_active"):
            return False, f"مهارة الحشد '{skill_name}' مفعلة وسارية بالفعل حالياً (متبقي {status.get('buff_remaining_seconds')} ثانية)."

        if status.get("in_cooldown"):
            return False, f"مهارة الحشد '{skill_name}' في فترة تبريد (متبقي {status.get('cd_remaining_seconds')} ثانية)."

        if status.get("remaining_uses_today", 0) <= 0:
            return False, f"تم استنفاد كامل مرات الاستخدام اليومية لمهارة الحشد '{skill_name}' ({status.get('daily_max_uses')}/{status.get('daily_max_uses')})."

        # فاصل بشري عشوائي خفيف قبل إرسال الطلب
        d = step_delay if (step_delay is not None and step_delay > 0) else random.uniform(0.4, 0.8)
        await asyncio.sleep(d)

        self.log(f"⚡ [مهارات الحشد] إرسال طلب تفعيل مهارة الحشد: {skill_name} (مجموعة: {group_id} - أبطال: {hero_req})...")
        resp = await self.safe_query(
            CMD_HERO_COMBO_SKILL_MODULE,
            REQ_HERO_COMBO_SKILL_USE,
            {"skillGroup": group_id},
            min_delay=0.3,
            max_delay=0.6,
        )

        if not self._is_resp_ok(resp):
            err_code = resp.get("err", resp.get("code", "no_response")) if isinstance(resp, dict) else "no_response"
            return False, f"فشل تفعيل مهارة الحشد '{skill_name}' من السيرفر (كود الخطأ: {err_code})."

        self._sync_hero_rally_skill_in_memory(group_id, resp, status)
        self.log(f"✅ [مهارات الحشد] تم تفعيل مهارة الحشد '{skill_name}' بنجاح وسيبدأ انطلاق الحشد فور اكتماله.")
        return True, f"تم تفعيل مهارة الحشد '{skill_name}' بنجاح."


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
        # 0. فحص استباقي لمستوى القلعة عبر castle_level لمنع أي استعلام شبكي مشبوه (0-Network Check)
        if self.castle_level < 5:
            return {
                "success": False,
                "error": f"قاعة القيادة غير متوفرة لهذه القلعة (مستوى القلعة Lv.{self.castle_level} أقل من المستوى المطلوب Lv.5).",
                "castle_level": self.castle_level,
                "tasks": [],
            }

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

            stamina_cost = 0 if raw_type == 6 else (5 if raw_type in (3, 4) else self._safe_int(item.get("consume"), 10))

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

            self.record_daily_quest_event(33, 1)
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

    async def execute_command_hall_snipe_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 2.5,
    ) -> Dict[str, Any]:
        """
        إنجاز مهمة القناص الصامت (Snipe Hunter Task - نوع 6) بقاعة القيادة:
        1. الفحص القبلي للجاهزية (0-Network Pre-flight):
           - التحقق من نوع المهمة (type == 6) وصحة معرف الفهرس (index > 0).
           - التحقق من أن حالة المهمة قابلة للإنجاز (statue in (1, 2)).
        2. محاكاة السلوك البشري الطبيعي للعبة (Human-like Simulation):
           - في العميل الرسمي، يشاهد اللاعب حركة الكشاف (2 ثانية) ثم يرمي الأسهم في اللعبة المصغرة (~1.0s).
           - الانتظار الآمن (افتراضياً 2.5 ثانية) يضمن التوافق التام مع نمط اللعب البشري وحماية الحساب من أي شذوذ.
        3. إرسال حزمة الإنهاء الرسمية المباشرة للسيرفر:
           - CMD: 2274 (CMD_COMMAND_HALL_MODULE)
           - SubCMD: 5 (REQ_COMMAND_HALL_FINISH_TASK)
           - Payload: {"index": task_index}
        4. استلام الجوائز المباشرة وتحديث الذاكرة الحية (0-Network Cache Sync):
           - دمج بيانات initData المحدثة في ذاكرة قاعة القيادة.
           - تسجيل اكتمال المهمة (statue = 0) في الذاكرة الحية لمنع تكرار استدعائها.
        """
        if not isinstance(task, dict):
            return {"success": False, "reason": "كائن المهمة غير صالح أو مفقود."}

        task_id = self._safe_int(task.get("task_id") or task.get("taskID") or task.get("Index"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 0)
        if task_type == 0 and task_id > 0:
            task_type = task_id // 1000

        # التحقق الصارم من أن المهمة هي مهمة القناص الصامت (نوع 6)
        if task_type != 6:
            return {
                "success": False,
                "reason": f"هذه الدالة مخصصة حصراً لمهام القناص الصامت (نوع 6) وليست للنوع {task_type}.",
            }

        if task_index <= 0:
            return {"success": False, "reason": "معرف مؤشر المهمة (index) غير صالح."}

        quality_name = task.get("quality_name_ar") or str(task.get("quality", ""))
        self.log(
            f"🎯 [قاعة القيادة] بدء مهمة القناص الصامت #{task_index} (ID: {task_id} | جودة: {quality_name})..."
        )

        # محاكاة زمنية بشرية آمنة لحل اللعبة المصغرة
        sim_wait = max(1.0, float(wait_seconds))
        await asyncio.sleep(sim_wait)

        # إرسال طلب الإنهاء الرسمي المباشر للميني جيم (CMD 2274 / SubCMD 5)
        payload = {"index": task_index}
        resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_FINISH_TASK,
            payload,
            min_delay=0.4,
            max_delay=0.8,
        )

        if not isinstance(resp, dict) or str(resp.get("err", resp.get("code", "0"))).strip() not in ("0", "Err_None"):
            err_msg = resp.get("err") if isinstance(resp, dict) else "لم يرد استجابة من السيرفر"
            self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز مهمة القناص الصامت #{task_index} (الخطأ: {err_msg}).")
            return {
                "success": False,
                "reason": f"فشل طلب إنهاء مهمة القناص: {err_msg}",
                "response": resp,
            }

        all_rewards: List[Dict[str, Any]] = []
        rspdata = resp.get("rspdata") if isinstance(resp, dict) else {}
        if isinstance(rspdata, dict) and "reward" in rspdata:
            all_rewards.extend(rspdata.get("reward") or [])
        elif isinstance(resp, dict) and "reward" in resp:
            all_rewards.extend(resp.get("reward") or [])

        # استلام الجوائز وتثبيت الإنجاز النهائي عبر (CMD 2274 / SubCMD 8 - commitTask)
        await asyncio.sleep(random.uniform(0.6, 1.2))
        commit_payload = {"commitType": 6, "index": task_index}
        commit_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            commit_payload,
            min_delay=0.4,
            max_delay=0.8,
        )

        final_rspdata = rspdata
        if isinstance(commit_resp, dict) and str(commit_resp.get("err", commit_resp.get("code", "0"))).strip() in ("0", "Err_None"):
            c_rspdata = commit_resp.get("rspdata")
            if isinstance(c_rspdata, dict):
                final_rspdata = c_rspdata
                c_rewards = c_rspdata.get("reward") or []
                if c_rewards:
                    all_rewards.extend(c_rewards)

        # تحديث الذاكرة الحية الشامل (0-Network Cache Sync)
        init_data = final_rspdata.get("initData") if isinstance(final_rspdata, dict) else None
        if isinstance(init_data, dict):
            if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                cached = self.conn.init_data.setdefault("commandHall", {})
                if isinstance(cached, dict):
                    cached.update(init_data)
        else:
            # وضع علامة اكتمال على المهمة محلياً بالذاكرة كاحتياط
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

        self.record_daily_quest_event(33, 1)
        self.log(
            f"✅ [قاعة القيادة] تم إنجاز مهمة القناص الصامت #{task_index} واستلام {len(all_rewards)} جوائز بنجاح!"
        )

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "task_type": 6,
            "stamina_spent": 0,
            "rewards": all_rewards,
            "rewards_count": len(all_rewards),
            "message": f"تم إنجاز مهمة القناص الصامت #{task_index} واستلام الجوائز بنجاح.",
            "finish_response": resp,
            "commit_response": commit_resp,
        }

    async def execute_command_hall_rescue_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 2.2,
        min_safety_stamina: int = 10,
    ) -> Dict[str, Any]:
        """
        تنفيذ مهمة إنقاذ القرويين (RESCUE_TASK - النوع 4) من مهام قاعة القيادة:
        - الاستناد الصارم لكود اللعبة الرسمي:
          * consume = 5 (تستهلك 5 طاقة من اللورد).
          * checkTaskTypeNeedArmy(4) == False (لا تحتاج جنوداً مقاتلين ولا فيالق مسير).
          * محاكاة مسير كشاف الاستطلاع (COMMANDHALL_COMMON_TASK_MARCH_TIME = 2s).
          * الإنجاز الذري عبر (CMD 2274 / SubCMD 5 - reqFinishTask).
          * استلام الجوائز والتثبيت عبر (CMD 2274 / SubCMD 8 - reqCommitTask).
        - يدعم الفحص القبلي الذكي للطاقة وحد الأمان، والتنفيذ الفوري إن كانت المهمة مكتملة مسبقاً (statue == 3).
        - التحديث الآني المتزامن للذاكرة الحية (0-Network Cache Sync).
        """
        task_id = self._safe_int(task.get("task_id") or task.get("Index") or task.get("id"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 4)
        statue = self._safe_int(task.get("statue"), 2)
        quality_name = task.get("quality_name_ar", str(task.get("quality", "")))
        stamina_cost = 5

        # 1. التحقق القبلي من صحة بيانات المهمة (0-Network Pre-flight)
        if task_index <= 0:
            return {
                "success": False,
                "reason": f"رقم فهرس المهمة غير صالح (index={task_index})",
                "task_id": task_id,
                "index": task_index,
            }

        if task_type != 4:
            self.log(f"⚠️ [قاعة القيادة] تحذير: نوع المهمة (#{task_index}) هو {task_type} وليس 4 (إنقاذ قرويين).")

        # 2. فحص طاقة اللورد مع حد الأمان
        current_stamina = self.stamina
        min_needed = stamina_cost + min_safety_stamina
        if current_stamina < min_needed and statue != 3:
            self.log(
                f"🛑 [قاعة القيادة] طاقة اللورد غير كافية لمهمة إنقاذ القرويين #{task_index} "
                f"({current_stamina} متوفر | المطلوب {min_needed} تشمل {min_safety_stamina} حد أمان)."
            )
            return {
                "success": False,
                "reason": f"طاقة اللورد غير كافية ({current_stamina} < {min_needed})",
                "task_id": task_id,
                "index": task_index,
                "stamina_spent": 0,
            }

        self.log(
            f"🤝 [قاعة القيادة] بدء مهمة إنقاذ القرويين #{task_index} "
            f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
        )

        all_rewards: List[Dict[str, Any]] = []
        finish_resp: Optional[Dict[str, Any]] = None
        final_rspdata: Dict[str, Any] = {}

        # 3. إنجاز مهمة الإنقاذ عبر (CMD 2274 / SubCMD 5) إذا لم تكن مكتملة مسبقاً
        if statue != 3:
            # محاكاة مسير كشاف الاستطلاع الطبيعي وفق معايير اللعبة (COMMANDHALL_COMMON_TASK_MARCH_TIME = 2s)
            sim_wait = max(0.5, wait_seconds + random.uniform(-0.2, 0.3))
            await asyncio.sleep(sim_wait)

            payload = {"index": task_index}
            finish_resp = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_FINISH_TASK,
                payload,
                min_delay=0.4,
                max_delay=0.8,
            )

            if not isinstance(finish_resp, dict) or str(finish_resp.get("err", finish_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
                err_msg = finish_resp.get("err") if isinstance(finish_resp, dict) else "لم يرد استجابة من السيرفر"
                self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز إنقاذ القرويين #{task_index} (الخطأ: {err_msg}).")
                return {
                    "success": False,
                    "reason": f"فشل طلب إنهاء مهمة الإنقاذ: {err_msg}",
                    "response": finish_resp,
                    "task_id": task_id,
                    "index": task_index,
                }

            rspdata = finish_resp.get("rspdata") if isinstance(finish_resp, dict) else {}
            if isinstance(rspdata, dict):
                final_rspdata = rspdata
                if "reward" in rspdata:
                    all_rewards.extend(rspdata.get("reward") or [])
            elif isinstance(finish_resp, dict) and "reward" in finish_resp:
                all_rewards.extend(finish_resp.get("reward") or [])

        # 4. تثبيت الإنجاز واستلام الجوائز النهائية عبر (CMD 2274 / SubCMD 8 - commitTask)
        await asyncio.sleep(random.uniform(0.6, 1.2))
        commit_payload = {"commitType": 4, "index": task_index}
        commit_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            commit_payload,
            min_delay=0.4,
            max_delay=0.8,
        )

        if isinstance(commit_resp, dict) and str(commit_resp.get("err", commit_resp.get("code", "0"))).strip() in ("0", "Err_None"):
            c_rspdata = commit_resp.get("rspdata")
            if isinstance(c_rspdata, dict):
                final_rspdata = c_rspdata
                c_rewards = c_rspdata.get("reward") or []
                if c_rewards:
                    all_rewards.extend(c_rewards)

        # 5. التحديث الآني المتزامن للذاكرة الحية (0-Network Cache Sync)
        init_data = final_rspdata.get("initData") if isinstance(final_rspdata, dict) else None
        if isinstance(init_data, dict):
            if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                cached = self.conn.init_data.setdefault("commandHall", {})
                if isinstance(cached, dict):
                    cached.update(init_data)
        else:
            # تحديث محلي في الذاكرة الحية لمنع إعادة التنفيذ
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

        self.record_daily_quest_event(33, 1)
        self.log(
            f"✅ [قاعة القيادة] تم إنجاز مهمة إنقاذ القرويين #{task_index} واستلام {len(all_rewards)} جوائز بنجاح!"
        )

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "task_type": 4,
            "stamina_spent": stamina_cost,
            "rewards": all_rewards,
            "rewards_count": len(all_rewards),
            "message": f"تم إنجاز مهمة إنقاذ القرويين #{task_index} بنجاح واستلام الجوائز.",
            "finish_response": finish_resp,
            "commit_response": commit_resp,
        }

    async def execute_command_hall_dialogue_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 1.5,
        min_safety_stamina: int = 10,
    ) -> Dict[str, Any]:
        """
        تنفيذ مهمة المعلومات العسكرية (DIALOGUE_TASK - النوع 3) من مهام قاعة القيادة:
        - الاستناد الصارم لكود اللعبة الرسمي:
          * consume = 5 (تستهلك 5 طاقة من اللورد).
          * moveType = 0, moveTime = 0 (حوار فوري داخل القلعة بلا مسير كشاف ولا استهلاك فيالق أو جنود).
          * محاكاة بشرية ذكية لتصفح الحوار التفاعلي (1.2 - 1.8 ثانية) تحاكي CommandHallTalkPanel.
          * الإنجاز الذري عبر (CMD 2274 / SubCMD 5 - reqFinishTask).
          * استلام الجوائز وتثبيت الإنجاز النهائي عبر (CMD 2274 / SubCMD 8 - reqCommitTask).
        - يدعم الفحص القبلي الذكي للطاقة وحد الأمان، والتنفيذ الفوري إن كانت المهمة مكتملة مسبقاً (statue == 3).
        - التحديث الآني المتزامن للذاكرة الحية (0-Network Cache Sync).
        """
        task_id = self._safe_int(task.get("task_id") or task.get("Index") or task.get("id"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 3)
        statue = self._safe_int(task.get("statue"), 2)
        quality_name = task.get("quality_name_ar", str(task.get("quality", "")))
        stamina_cost = 5

        # 1. التحقق القبلي من صحة بيانات المهمة (0-Network Pre-flight)
        if task_index <= 0:
            return {
                "success": False,
                "reason": f"رقم فهرس المهمة غير صالح (index={task_index})",
                "task_id": task_id,
                "index": task_index,
            }

        if task_type != 3:
            self.log(f"⚠️ [قاعة القيادة] تحذير: نوع المهمة (#{task_index}) هو {task_type} وليس 3 (معلومات عسكرية).")

        # 2. فحص طاقة اللورد مع حد الأمان
        current_stamina = self.stamina
        min_needed = stamina_cost + min_safety_stamina
        if current_stamina < min_needed and statue != 3:
            self.log(
                f"🛑 [قاعة القيادة] طاقة اللورد غير كافية لمهمة المعلومات العسكرية #{task_index} "
                f"({current_stamina} متوفر | المطلوب {min_needed} تشمل {min_safety_stamina} حد أمان)."
            )
            return {
                "success": False,
                "reason": f"طاقة اللورد غير كافية ({current_stamina} < {min_needed})",
                "task_id": task_id,
                "index": task_index,
                "stamina_spent": 0,
            }

        self.log(
            f"📜 [قاعة القيادة] بدء مهمة المعلومات العسكرية #{task_index} "
            f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
        )

        all_rewards: List[Dict[str, Any]] = []
        finish_resp: Optional[Dict[str, Any]] = None
        final_rspdata: Dict[str, Any] = {}

        # 3. إنجاز مهمة الحوار عبر (CMD 2274 / SubCMD 5) إذا لم تكن مكتملة مسبقاً
        if statue != 3:
            # محاكاة بشرية ذكية لتصفح الحوار والنقر على التالي
            sim_wait = max(0.5, wait_seconds + random.uniform(-0.3, 0.3))
            await asyncio.sleep(sim_wait)

            payload = {"index": task_index}
            finish_resp = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_FINISH_TASK,
                payload,
                min_delay=0.4,
                max_delay=0.8,
            )

            if not isinstance(finish_resp, dict) or str(finish_resp.get("err", finish_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
                err_msg = finish_resp.get("err") if isinstance(finish_resp, dict) else "لم يرد استجابة من السيرفر"
                self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز المعلومات العسكرية #{task_index} (الخطأ: {err_msg}).")
                return {
                    "success": False,
                    "reason": f"فشل طلب إنهاء مهمة المعلومات العسكرية: {err_msg}",
                    "response": finish_resp,
                    "task_id": task_id,
                    "index": task_index,
                }

            rspdata = finish_resp.get("rspdata") if isinstance(finish_resp, dict) else {}
            if isinstance(rspdata, dict):
                final_rspdata = rspdata
                if "reward" in rspdata:
                    all_rewards.extend(rspdata.get("reward") or [])
            elif isinstance(finish_resp, dict) and "reward" in finish_resp:
                all_rewards.extend(finish_resp.get("reward") or [])

        # 4. تثبيت الإنجاز واستلام الجوائز النهائية عبر (CMD 2274 / SubCMD 8 - commitTask)
        await asyncio.sleep(random.uniform(0.6, 1.2))
        commit_payload = {"commitType": 3, "index": task_index}
        commit_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            commit_payload,
            min_delay=0.4,
            max_delay=0.8,
        )

        if isinstance(commit_resp, dict) and str(commit_resp.get("err", commit_resp.get("code", "0"))).strip() in ("0", "Err_None"):
            c_rspdata = commit_resp.get("rspdata")
            if isinstance(c_rspdata, dict):
                final_rspdata = c_rspdata
                c_rewards = c_rspdata.get("reward") or []
                if c_rewards:
                    all_rewards.extend(c_rewards)

        # 5. التحديث الآني المتزامن للذاكرة الحية (0-Network Cache Sync)
        init_data = final_rspdata.get("initData") if isinstance(final_rspdata, dict) else None
        if isinstance(init_data, dict):
            if hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                cached = self.conn.init_data.setdefault("commandHall", {})
                if isinstance(cached, dict):
                    cached.update(init_data)
        else:
            # تحديث محلي في الذاكرة الحية لمنع إعادة التنفيذ
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

        self.record_daily_quest_event(33, 1)
        self.log(
            f"✅ [قاعة القيادة] تم إنجاز مهمة المعلومات العسكرية #{task_index} واستلام {len(all_rewards)} جوائز بنجاح!"
        )

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "task_type": 3,
            "stamina_spent": stamina_cost,
            "rewards": all_rewards,
            "rewards_count": len(all_rewards),
            "message": f"تم إنجاز مهمة المعلومات العسكرية #{task_index} بنجاح واستلام الجوائز.",
            "finish_response": finish_resp,
            "commit_response": commit_resp,
        }

    async def execute_command_hall_army_group_task(
        self,
        task: Optional[Dict[str, Any]] = None,
        wait_seconds: float = 1.0,
    ) -> Dict[str, Any]:
        """
        تنفيذ مهمة فيلق الغزاة (Rebel Legion / Boss - Type 1) الرسمية:
        1. فحص الذاكرة المسبق (0-Network Pre-flight):
           - قراءة armyGroupTaskData من commandHall.
           - التأكد من عدم وجود مهام طليعة غير مكتملة (armyPioneerTaskCount == 0) لمنع ضياع جوائزها (commandhall_text_15).
           - التحقق من شرط القضاء على الفيلق: نقاط صحة الفيلق وصلت إلى 0 (hurtHp >= rabelHp) أو حالة المهمة 3 (FINISH).
        2. خطوة القضاء على الفيلق (Attack Boss):
           - إرسال REQ_COMMAND_HALL_ATTACK_ARMY_GROUP (CMD 2274, SubCMD 7).
           - تحديث حالة الفيلق محلياً إلى statue: 3 (FINISH).
        3. خطوة تسليم المهمة وتجديد المهام (Commit & Refresh):
           - إرسال REQ_COMMAND_HALL_COMMIT_TASK (CMD 2274, SubCMD 8 مع commitType=1).
           - استلام جوائز الانتصار والقتل الضخمة.
           - دمج حزمة initData الجديدة مباشرة في الذاكرة الحية (لتوليد وتجديد حزمة المهام الجديدة تلقائياً).
        """
        # 1. جلب بيانات المهمة وقاعة القيادة من الذاكرة الحية
        hall_data = self.get_ctrl("commandHall")
        if not isinstance(hall_data, dict):
            return {"success": False, "reason": "بيانات قاعة القيادة غير متوفرة في الذاكرة الحية."}

        ag_data = task if (isinstance(task, dict) and task.get("type") == 1) else hall_data.get("armyGroupTaskData")
        if not isinstance(ag_data, dict) or not ag_data.get("index"):
            return {"success": False, "reason": "لا توجد مهمة فيلق غزاة (Type 1) مسجلة حالياً."}

        task_index = self._safe_int(ag_data.get("index"), 0)
        task_id = self._safe_int(ag_data.get("taskID"), 0)
        rabel_hp = self._safe_int(ag_data.get("rabelHp"), 1000)
        hurt_hp = self._safe_int(ag_data.get("hurtHp"), 0)
        statue = self._safe_int(ag_data.get("statue"), 2)

        # 2. فحص مهام الطليعة المتبقية (قاعدة اللعبة الرسمية لمنع ضياع جوائز الطليعة)
        pioneer_count = self._safe_int(hall_data.get("armyPioneerTaskCount"), 0)
        if pioneer_count > 0:
            self.log(
                f"🛡️ [قاعة القيادة] تأجيل استلام جائزة فيلق الغزاة لحين إكمال {pioneer_count} مهمة طليعة غزاة متبقية لمنع ضياع جوائزها."
            )
            return {
                "success": False,
                "reason": f"توجد {pioneer_count} مهام طليعة غزاة لم تكتمل بعد، تم التأجيل لحمايتها.",
                "pending_pioneers": pioneer_count,
            }

        # 3. فحص شرط اكتمال الضرر (صحة الفيلق صفر)
        is_defeated = (hurt_hp >= rabel_hp) or (statue == 3)
        if not is_defeated:
            rem_hp = max(0, rabel_hp - hurt_hp)
            return {
                "success": False,
                "reason": f"صحة فيلق الغزاة لم تصل إلى 0 بعد (المتبقي: {rem_hp} من أصل {rabel_hp}).",
                "remaining_hp": rem_hp,
            }

        self.log(
            f"👑 [قاعة القيادة] بدء مهمة فيلق الغزاة #{task_index} (ID: {task_id} | ضرر: {hurt_hp}/{rabel_hp} | الحالة: {statue})..."
        )

        attack_resp = None
        # 4. إذا لم يكن الفيلق قد قضي عليه رسمياً بعد (statue != 3)، نرسل أمر القضاء على الفيلق
        if statue != 3:
            self.log(f"⚔️ [قاعة القيادة] إرسال أمر القضاء على فيلق الغزاة (SubCMD=7)...")
            attack_resp = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_ATTACK_ARMY_GROUP,
                {},
                min_delay=0.4,
                max_delay=0.8,
            )
            if not isinstance(attack_resp, dict) or str(attack_resp.get("err", attack_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
                err_msg = attack_resp.get("err") if isinstance(attack_resp, dict) else "فشل الاتصال بالسيرفر"
                self.log(f"⚠️ [قاعة القيادة] تعذر القضاء على فيلق الغزاة #{task_index} (الخطأ: {err_msg}).")
                return {
                    "success": False,
                    "reason": f"فشل أمر القضاء على فيلق الغزاة: {err_msg}",
                    "response": attack_resp,
                }

            # محاكاة فترة تفاعل وعرض مشهد النصر الطبيعي
            await asyncio.sleep(wait_seconds + random.uniform(0.3, 0.7))

        # 5. استلام وتسليم جوائز فيلق الغزاة وتجديد المهام تلقائياً (SubCMD=8, commitType=1)
        self.log(f"🎁 [قاعة القيادة] إرسال طلب استلام جوائز فيلق الغزاة وتجديد المهام (SubCMD=8, commitType=1)...")
        commit_payload = {"commitType": 1, "index": task_index}
        commit_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            commit_payload,
            min_delay=0.5,
            max_delay=1.0,
        )

        if not isinstance(commit_resp, dict) or str(commit_resp.get("err", commit_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
            err_msg = commit_resp.get("err") if isinstance(commit_resp, dict) else "فشل الاتصال بالسيرفر"
            self.log(f"⚠️ [قاعة القيادة] تعذر استلام جوائز فيلق الغزاة #{task_index} (الخطأ: {err_msg}).")
            return {
                "success": False,
                "reason": f"فشل استلام جوائز فيلق الغزاة: {err_msg}",
                "commit_response": commit_resp,
            }

        # 6. استخراج الجوائز ودمج حالة تجديد المهام في الذاكرة الحية فورياً
        rspdata = commit_resp.get("rspdata", {})
        raw_rewards = rspdata.get("reward") or []
        all_rewards = []
        if isinstance(raw_rewards, list):
            for r in raw_rewards:
                if isinstance(r, dict) and r.get("id"):
                    all_rewards.append({"id": self._safe_int(r.get("id")), "count": self._safe_int(r.get("count"), 1)})

        new_init = rspdata.get("initData")
        if isinstance(new_init, dict):
            cached_hall = self.get_ctrl("commandHall")
            if isinstance(cached_hall, dict):
                cached_hall.update(new_init)
            elif hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                self.conn.init_data["commandHall"] = new_init

        new_legion_id = new_init.get("armyGroupID") if isinstance(new_init, dict) else "محدث"
        new_tasks_count = len(new_init.get("commonTaskData", [])) if isinstance(new_init, dict) else 0

        self.record_daily_quest_event(33, 1)
        self.log(
            f"🎉 [قاعة القيادة] تم القضاء على فيلق الغزاة #{task_index} بنجاح! استلام {len(all_rewards)} جوائز "
            f"وتجديد {new_tasks_count} مهمة جديدة للفيلق القادم (المستوى {new_legion_id})!"
        )

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "task_type": 1,
            "rewards": all_rewards,
            "rewards_count": len(all_rewards),
            "new_tasks_count": new_tasks_count,
            "new_army_group_id": new_legion_id,
            "message": f"تم القضاء على فيلق الغزاة #{task_index} بنجاح وتجديد {new_tasks_count} مهمة جديدة.",
            "attack_response": attack_resp,
            "commit_response": commit_resp,
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 12.5 ترقية مستوى قاعة القيادة تلقائياً (Command Hall Level Upgrade)
    # ═════════════════════════════════════════════════════════════════════════

    async def execute_command_hall_upgrade_level(
        self,
        max_upgrades: int = 5,
        wait_seconds: float = 1.0,
    ) -> Dict[str, Any]:
        """
        تنفيذ الترقية التلقائية لمستوى قاعة القيادة (Command Hall Level Upgrade) الرسمية:
        1. فحص الذاكرة الحية المسبق (0-Network Pre-flight):
           - قراءة commandLv و commandExp من commandHall.
           - فحص شرط الترقية: commandExp >= needExp و commandLv < COMMAND_HALL_MAX_LEVEL.
        2. إرسال طلب الترقية الرسمي:
           - REQ_COMMAND_HALL_UPGRADE_COMMAND_LV (CMD 2274, SubCMD 2, payload {}).
        3. دمج البيانات والجوائز الحية فورياً:
           - تحديث initData في الذاكرة الحية (commandLv الجديد والخبرة المتبقية).
           - استلام وتجميع جوائز الترقية المكتسبة.
        4. دعم الترقيات المتتالية (Multi-level upgrade) عند توفر نقاط خبرة كافية لأكثر من مستوى.
        """
        hall_data = self.get_ctrl("commandHall")
        if not isinstance(hall_data, dict):
            return {"success": False, "reason": "بيانات قاعة القيادة غير متوفرة في الذاكرة الحية."}

        initial_lv = self._safe_int(hall_data.get("commandLv"), 1)
        cur_lv = initial_lv
        upgrades_done = 0
        all_rewards: List[Dict[str, Any]] = []

        for _ in range(max(1, max_upgrades)):
            cur_exp = self._safe_int(hall_data.get("commandExp"), 0)
            need_exp = COMMAND_HALL_EXP_BY_LV.get(cur_lv, 0)

            # شرط الترقية
            if cur_lv >= COMMAND_HALL_MAX_LEVEL:
                break
            if need_exp <= 0 or cur_exp < need_exp:
                break

            self.log(
                f"🏛️ [قاعة القيادة] نقاط الخبرة مكتملة للترقية ({cur_exp}/{need_exp}) — "
                f"إرسال طلب ترقية مستوى قاعة القيادة من Lv.{cur_lv} إلى Lv.{cur_lv + 1} (SubCMD=2)..."
            )

            resp = await self.safe_query(CMD_COMMAND_HALL_MODULE, REQ_COMMAND_HALL_UPGRADE_COMMAND_LV, {})
            if not isinstance(resp, dict):
                return {
                    "success": False,
                    "reason": "لم يتم استلام أي استجابة من الخادم لترقية قاعة القيادة.",
                    "upgrades_done": upgrades_done,
                    "initial_lv": initial_lv,
                    "current_lv": cur_lv,
                }

            err = resp.get("err")
            if err not in (0, "0", None) and str(err) != "0":
                err_msg = resp.get("msg") or resp.get("reason") or f"رمز الخطأ: {err}"
                self.log(f"⚠️ [قاعة القيادة] فشل ترقية قاعة القيادة: {err_msg}")
                break

            rspdata = resp.get("rspdata") or {}
            raw_rewards = rspdata.get("reward") or []
            if isinstance(raw_rewards, list):
                for r in raw_rewards:
                    if isinstance(r, dict) and r.get("id"):
                        all_rewards.append({
                            "id": self._safe_int(r.get("id")),
                            "count": self._safe_int(r.get("count"), 1),
                        })

            # دمج initData الجديد فورياً في الذاكرة الحية
            new_init = rspdata.get("initData")
            if isinstance(new_init, dict):
                cached_hall = self.get_ctrl("commandHall")
                if isinstance(cached_hall, dict):
                    cached_hall.update(new_init)
                    hall_data = cached_hall
                elif hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                    self.conn.init_data["commandHall"] = new_init
                    hall_data = new_init
                cur_lv = self._safe_int(hall_data.get("commandLv"), cur_lv + 1)
            else:
                cur_lv += 1
                hall_data["commandLv"] = cur_lv
                hall_data["commandExp"] = max(0, cur_exp - need_exp)

            upgrades_done += 1
            self.log(
                f"🎉 [قاعة القيادة] تمت ترقية قاعة القيادة بنجاح إلى المستوى Lv.{cur_lv}! "
                f"واستلام {len(raw_rewards)} جوائز ترقية."
            )

            if wait_seconds > 0:
                await asyncio.sleep(wait_seconds)

        if upgrades_done > 0:
            return {
                "success": True,
                "upgrades_done": upgrades_done,
                "initial_lv": initial_lv,
                "new_lv": cur_lv,
                "rewards": all_rewards,
                "rewards_count": len(all_rewards),
                "message": f"تمت ترقية قاعة القيادة بنجاح من Lv.{initial_lv} إلى Lv.{cur_lv} ({upgrades_done} مستوى).",
            }

        return {
            "success": False,
            "reason": "نقاط الخبرة الحالية لا تكفي للترقية أو أن القاعة في أقصى مستوى.",
            "upgrades_done": 0,
            "initial_lv": initial_lv,
            "current_lv": cur_lv,
            "rewards": [],
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 13. معمل المواد (Material Workshop / stuffWorkshopCtrl)
    # ═════════════════════════════════════════════════════════════════════════

    @classmethod
    def resolve_material_info(cls, mid: Any) -> Dict[str, Any]:
        """
        استخراج تفاصيل المادة ومستواها واسمها العربي بذكاء.
        يقبل:
          - معرف المادة المباشر (مثل 200101 أو 200302)
          - المعرف الأساسي (مثل 2001 أو 10)
        """
        try:
            m_id = int(str(mid).strip())
        except (ValueError, TypeError):
            return {
                "id": mid,
                "name": str(mid),
                "base_id": 0,
                "base_name": "مادة غير معروفة",
                "quality": 0,
                "quality_name": "غير معروف",
                "refine_time": 0,
            }

        if m_id in MATERIAL_WORKSHOP_CATALOG:
            item = dict(MATERIAL_WORKSHOP_CATALOG[m_id])
            item["id"] = m_id
            return item

        # استنتاج ذكي للمعرفات المركبة (200101 -> base 2001, quality 1)
        if m_id > 100000:
            base_id = m_id // 100
            quality = m_id % 100
            base_name = MATERIAL_BASE_NAMES.get(base_id, f"مادة {base_id}")
            q_name = MATERIAL_QUALITY_NAMES.get(quality, f"مستوى {quality}")
            return {
                "id": m_id,
                "name": f"{base_name} المستوى {quality}",
                "base_id": base_id,
                "base_name": base_name,
                "quality": quality,
                "quality_name": q_name,
                "refine_time": 14400 * (1 if quality == 1 else (3 if quality == 2 else 6)),
            }

        # معرف أساسي بسيط (10..15 أو 2001..2006)
        base_name = MATERIAL_BASE_NAMES.get(m_id, f"مادة {m_id}")
        return {
            "id": m_id,
            "name": base_name,
            "base_id": m_id,
            "base_name": base_name,
            "quality": 1,
            "quality_name": "أبيض (عادي)",
            "refine_time": 14400,
        }

    def get_material_workshop_status(self) -> Dict[str, Any]:
        """
        فحص حالة معمل المواد (stuffWorkshopCtrl) اعتماداً حصرياً على الذاكرة الحية الحالية (0-Network Direct Read).
        يجلب:
          1. المواد التي تعامل حالياً في المعمل (سواء قيد التكرير الفعلي أو في قائمة الانتظار).
          2. السعة الكلية للمعمل المفتوحة للقلعة (كم مادة يمكن إضافتها أصلاً للقلعة).
          3. هل توجد خانة شاغرة لإضافة منتج، وكم عدد الخانات الشاغرة ومواقعها بدقة.
          4. حالة المادة الجاهزة للاستلام (doneID).
          5. طابور التكرير النشط والوقت المتبقي (queueType 1238).
        """
        stuff_data = self.get_ctrl("stuffWorkshopCtrl")
        if not isinstance(stuff_data, dict) or not stuff_data or "list" not in stuff_data:
            return {
                "has_workshop": False,
                "total_slots": 7,
                "total_unlocked_slots": 0,
                "locked_slots_count": 7,
                "locked_slots": [],
                "currently_producing_count": 0,
                "vacant_slots_count": 0,
                "has_vacant_slot": False,
                "vacant_positions": [],
                "materials_in_process": [],
                "done_material_id": 0,
                "has_finished_material": False,
                "finished_material": None,
                "daily_speedup_count": 0,
                "discount": 1.0,
                "active_refining_queue": None,
                "message": "معمل المواد غير موجود في الذاكرة الحية للقلعة.",
            }

        slots_list = stuff_data.get("list") or []
        if not isinstance(slots_list, list):
            slots_list = []

        done_id = self._safe_int(stuff_data.get("doneID", 0))
        daily_speedup = self._safe_int(stuff_data.get("count", 0))
        discount = float(stuff_data.get("discount", 1.0) or 1.0)

        # فحص طابور تكرير المواد النشط (queue 1238)
        now_ts = int(time.time())
        refining_queue_info = None
        queue_ctrl = self.get_ctrl("queueCtrl")
        queues_to_search: List[Dict[str, Any]] = []
        if isinstance(queue_ctrl, dict):
            queues_to_search.extend(queue_ctrl.values())
        elif isinstance(queue_ctrl, list):
            queues_to_search.extend(queue_ctrl)

        # البحث في طوابير السيرفر الحية
        conn = getattr(self, "conn", None)
        if conn:
            live_local_queues = self._read_live_local_queues(conn)
            queues_to_search.extend(live_local_queues)

        for q in queues_to_search:
            if not isinstance(q, dict):
                continue
            q_type = str(q.get("queueType") or q.get("type") or "")
            if q_type == str(QUEUE_TYPE_STUFF_WORKSHOP):
                total_time = self._safe_int(q.get("totaltime") or q.get("ottime") or 0)
                finish_time = self._safe_int(q.get("finishTime") or q.get("endTime") or 0)
                begin_time = self._safe_int(q.get("begintime") or q.get("startTime") or 0)
                if finish_time == 0 and begin_time > 0 and total_time > 0:
                    finish_time = begin_time + total_time
                remaining = max(0, finish_time - now_ts) if finish_time > 0 else 0
                refining_queue_info = {
                    "queue_type": QUEUE_TYPE_STUFF_WORKSHOP,
                    "begin_time": begin_time,
                    "finish_time": finish_time,
                    "total_time": total_time,
                    "remaining_seconds": remaining,
                    "is_active": remaining > 0 or finish_time > 0,
                    "queue_raw": q,
                }
                break

        total_unlocked_slots = 0
        locked_slots: List[Dict[str, Any]] = []
        materials_in_process: List[Dict[str, Any]] = []
        vacant_positions: List[int] = []

        for idx, slot in enumerate(slots_list):
            if not isinstance(slot, dict):
                continue
            pos = idx + 1
            slot_type = self._safe_int(slot.get("type", 0))
            is_unlocked = (slot_type == 0)

            if is_unlocked:
                total_unlocked_slots += 1
                mid = slot.get("mid")
                if mid is not None:
                    mid_int = self._safe_int(mid)
                    mat_info = self.resolve_material_info(mid_int)
                    is_currently_refining = (pos == 1)

                    mat_entry = {
                        "position": pos,
                        "material_id": mid_int,
                        "name": mat_info.get("name"),
                        "base_name": mat_info.get("base_name"),
                        "quality": mat_info.get("quality"),
                        "quality_name": mat_info.get("quality_name"),
                        "status": "refining" if is_currently_refining else "queued",
                        "status_ar": "قيد التكرير الفعلي" if is_currently_refining else "في قائمة الانتظار",
                        "remaining_seconds": refining_queue_info["remaining_seconds"] if (is_currently_refining and refining_queue_info) else None,
                        "finish_time": refining_queue_info["finish_time"] if (is_currently_refining and refining_queue_info) else None,
                        "slot_raw": slot,
                    }
                    materials_in_process.append(mat_entry)
                else:
                    vacant_positions.append(pos)
            else:
                locked_slots.append({
                    "position": pos,
                    "gold_cost": slot.get("gold", 500),
                    "vip_required": slot.get("vip", 0),
                    "slot_raw": slot,
                })

        currently_producing_count = len(materials_in_process)
        vacant_slots_count = len(vacant_positions)
        has_vacant_slot = vacant_slots_count > 0

        # فحص المادة المكتملة الجاهزة للاستلام
        has_finished_material = done_id > 0
        finished_material_info = None
        if has_finished_material:
            done_mat = self.resolve_material_info(done_id)
            finished_material_info = {
                "material_id": done_id,
                "name": done_mat.get("name"),
                "base_name": done_mat.get("base_name"),
                "quality": done_mat.get("quality"),
                "quality_name": done_mat.get("quality_name"),
                "ready_to_collect": True,
            }

        return {
            "has_workshop": True,
            "total_slots": len(slots_list),
            "total_unlocked_slots": total_unlocked_slots,
            "locked_slots_count": len(locked_slots),
            "locked_slots": locked_slots,
            "currently_producing_count": currently_producing_count,
            "vacant_slots_count": vacant_slots_count,
            "has_vacant_slot": has_vacant_slot,
            "vacant_positions": vacant_positions,
            "materials_in_process": materials_in_process,
            "done_material_id": done_id,
            "has_finished_material": has_finished_material,
            "finished_material": finished_material_info,
            "daily_speedup_count": daily_speedup,
            "discount": discount,
            "active_refining_queue": refining_queue_info,
            "message": (
                f"معمل المواد: السعة الكلية {total_unlocked_slots} خانات مفتوحة، "
                f"المواد قيد المعالجة: {currently_producing_count}، "
                f"الخانات الشاغرة: {vacant_slots_count} ({'توجد خانة شاغرة' if has_vacant_slot else 'المعمل ممتلئ'})"
            ),
        }

    async def collect_material_workshop_finished(self, timeout: float = 5.0) -> Dict[str, Any]:
        """
        استلام المواد المكتملة في معمل المواد (REQ_GET_STUFF) مع فحص مسبق 0-Network.
        """
        status = self.get_material_workshop_status()
        if not status.get("has_finished_material"):
            return {
                "success": False,
                "code": "NO_FINISHED_MATERIAL",
                "message": "لا توجد مواد جاهزة للاستلام في معمل المواد حالياً.",
            }

        done_id = status.get("done_material_id", 0)
        self.log(f"🏭 [معمل المواد] جاري استلام المادة المكتملة #{done_id}...")

        resp = await self.safe_query(CMD_STUFF_WORKSHOP_MODULE, REQ_STUFF_WORKSHOP_GET, {})
        if not resp or not self._is_resp_ok(resp):
            return {
                "success": False,
                "code": "COLLECT_FAILED",
                "message": f"فشل استلام المادة المكتملة من السيرفر (كود الخطأ: {resp.get('err') if resp else 'None'}).",
                "response": resp,
            }

        # مزامنة الذاكرة الحية فورياً: تصفير doneID
        stuff_ctrl = self.get_ctrl("stuffWorkshopCtrl")
        if isinstance(stuff_ctrl, dict):
            stuff_ctrl["doneID"] = 0

        self.log(f"✅ [معمل المواد] تم استلام المادة المكتملة #{done_id} بنجاح!")
        return {
            "success": True,
            "code": "SUCCESS",
            "material_id": done_id,
            "items_collected": resp.get("result", []),
            "message": "تم استلام المواد بنجاح.",
            "response": resp,
        }

    async def refine_material_workshop(self, material_id: Any, timeout: float = 5.0) -> Dict[str, Any]:
        """
        بدء تكرير مادة جديدة في معمل المواد مع فحص السعة المتاحة مسبقاً (0-Network Pre-flight).
        """
        mat_info = self.resolve_material_info(material_id)
        mat_id = mat_info.get("id")
        status = self.get_material_workshop_status()

        if not status.get("has_vacant_slot"):
            return {
                "success": False,
                "code": "NO_VACANT_SLOTS",
                "message": f"لا توجد خانات شاغرة في معمل المواد (السعة المفتوحة: {status.get('total_unlocked_slots')}, المشغولة: {status.get('currently_producing_count')}).",
            }

        self.log(f"🏭 [معمل المواد] جاري بدء تكرير '{mat_info.get('name')}' (ID: {mat_id})...")
        resp = await self.safe_query(CMD_STUFF_WORKSHOP_MODULE, REQ_STUFF_WORKSHOP_REFINERY, {"id": mat_id})
        if not resp or not self._is_resp_ok(resp):
            return {
                "success": False,
                "code": "REFINERY_FAILED",
                "message": f"فشل بدء تكرير المادة من السيرفر (كود الخطأ: {resp.get('err') if resp else 'None'}).",
                "response": resp,
            }

        # مزامنة الذاكرة الحية فورياً
        res_data = resp.get("result")
        if isinstance(res_data, dict):
            stuff_ctrl = self.get_ctrl("stuffWorkshopCtrl")
            if isinstance(stuff_ctrl, dict):
                stuff_ctrl.update(res_data)
            elif hasattr(self, "conn") and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                self.conn.init_data["stuffWorkshopCtrl"] = res_data

        self.log(f"✅ [معمل المواد] تم بدء تكرير '{mat_info.get('name')}' بنجاح!")
        return {
            "success": True,
            "code": "SUCCESS",
            "material_id": mat_id,
            "material_name": mat_info.get("name"),
            "message": f"تم بدء تكرير '{mat_info.get('name')}' بنجاح.",
            "response": resp,
        }

    async def cancel_material_workshop_slot(self, pos: int, timeout: float = 5.0) -> Dict[str, Any]:
        """
        إلغاء إنتاج مادة في موقع معين بالمعمل (REQ_CANCEL_REFINERY).
        """
        if pos <= 0:
            return {"success": False, "code": "INVALID_POS", "message": "رقم الخانة غير صالح."}

        status = self.get_material_workshop_status()
        producing_positions = [m["position"] for m in status.get("materials_in_process", [])]
        if pos not in producing_positions:
            return {"success": False, "code": "SLOT_EMPTY", "message": f"الخانة #{pos} لا تحتوي على مادة قيد المعالجة."}

        self.log(f"🏭 [معمل المواد] جاري إلغاء معالجة المادة في الخانة #{pos}...")
        resp = await self.safe_query(CMD_STUFF_WORKSHOP_MODULE, REQ_STUFF_WORKSHOP_CANCEL, {"pos": pos})
        if not resp or not self._is_resp_ok(resp):
            return {
                "success": False,
                "code": "CANCEL_FAILED",
                "message": f"فشل إلغاء معالجة المادة من السيرفر (كود الخطأ: {resp.get('err') if resp else 'None'}).",
                "response": resp,
            }

        res_data = resp.get("result")
        if isinstance(res_data, dict):
            stuff_ctrl = self.get_ctrl("stuffWorkshopCtrl")
            if isinstance(stuff_ctrl, dict):
                stuff_ctrl.update(res_data)

        self.log(f"✅ [معمل المواد] تم إلغاء معالجة المادة في الخانة #{pos} بنجاح!")
        return {
            "success": True,
            "code": "SUCCESS",
            "position": pos,
            "message": f"تم إلغاء معالجة المادة في الخانة #{pos} بنجاح.",
            "response": resp,
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 17. محرك تسريعات إنتاج الموارد والتسريعات العامة (Resource Boost & Speedups Engine)
    # ═════════════════════════════════════════════════════════════════════════

    def get_resource_boost_speedups(self, resource_type: Optional[str | int] = None) -> Union[int, Dict[str, Any]]:
        """
        جلب التسريعات المتوفرة لمضاعفة إنتاج حقول ومناجم القلعة (0-Network Direct Read).
        تعتمد بنسبة 100% على فحص الحقيبة (backpackCtrl / bagCtrl) في الذاكرة الحية المشحونة مسبقاً.

        المعاملات:
        ----------
        resource_type : Optional[str | int]
            - عند تمرير نوع مورد محدد (مثل: "wheat", "farm", "قمح", "مزرعة", "wood", "خشب",
              "iron", "حديد", "silver", "فضة", "crystal", "بلور", "الماس", "general", "عام"):
              تُرجع فوراً إجمالي الثواني المتاحة كرقم صحيح نقي (int).
            - عند عدم تمريره (None):
              تُرجع قاموساً شاملاً يحوي إجمالي الثواني لكل مورد كأرقام صحيحة (int)،
              مع قسم منفصل ومعزول تماماً للتسريعات العامة، بالإضافة إلى تفاصيل البنود.

        القيم المرجعة:
        -------------
        - في حالة تحديد المورد: int (عدد الثواني المتاحة)
        - في الحالة الشاملة (None): Dict[str, Any] يحوي:
            "wheat": int,
            "wood": int,
            "iron": int,
            "silver": int,
            "crystal": int,
            "total_boost_seconds": int,
            "general": int,
            "details": Dict[...]
        """
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            backpack = {}

        def _read_count(item_id: int | str) -> int:
            entry = backpack.get(str(item_id)) or backpack.get(int(item_id))
            if isinstance(entry, dict):
                try:
                    return int(entry.get("count", 0))
                except (ValueError, TypeError):
                    return 0
            elif isinstance(entry, (int, str)):
                try:
                    return int(entry)
                except (ValueError, TypeError):
                    return 0
            return 0

        # 1. حساب تسريعات مضاعفة إنتاج الحقول والمناجم لكل نوع
        boost_seconds: Dict[str, int] = {}
        boost_details: Dict[str, Any] = {}
        total_boost_sec = 0

        for r_key, cfg in RESOURCE_BOOST_CATALOG.items():
            iid = cfg["item_id"]
            cnt = _read_count(iid)
            sec = cnt * cfg["duration_seconds"]
            boost_seconds[r_key] = sec
            total_boost_sec += sec
            boost_details[r_key] = {
                "item_id": iid,
                "name": cfg["name_ar"],
                "name_en": cfg["name_en"],
                "count": cnt,
                "duration_per_item": cfg["duration_seconds"],
                "total_seconds": sec,
                "total_hours": round(sec / 3600.0, 2),
                "total_days": round(sec / 86400.0, 2),
            }

        # 2. حساب التسريعات العامة ومعالجتها في قسم منفصل ومعزول
        general_total_sec = 0
        general_items_detail: List[Dict[str, Any]] = []

        for iid, g_cfg in GENERAL_SPEEDUP_CATALOG.items():
            cnt = _read_count(iid)
            if cnt > 0:
                sec = cnt * g_cfg["seconds"]
                general_total_sec += sec
                general_items_detail.append({
                    "item_id": iid,
                    "name": g_cfg["name_ar"],
                    "name_en": g_cfg["name_en"],
                    "count": cnt,
                    "seconds_per_item": g_cfg["seconds"],
                    "total_seconds": sec,
                    "total_hours": round(sec / 3600.0, 2),
                })

        # 3. إذا تم تمرير مورد محدد، إرجاع الثواني فقط كرقم صحيح (int)
        if resource_type is not None:
            raw_target = str(resource_type).strip()
            # تجريد "ال" التعريف للبحث المرن بالعربية
            target_clean = raw_target[2:] if raw_target.startswith("ال") and len(raw_target) > 2 else raw_target
            matched_key = (
                RESOURCE_BOOST_KEY_MAP.get(raw_target)
                or RESOURCE_BOOST_KEY_MAP.get(raw_target.lower())
                or RESOURCE_BOOST_KEY_MAP.get(target_clean)
                or RESOURCE_BOOST_KEY_MAP.get(target_clean.lower())
            )

            if matched_key == "general":
                return int(general_total_sec)
            elif matched_key in boost_seconds:
                return int(boost_seconds[matched_key])
            elif raw_target.lower() in ("total", "all", "المجموع", "إجمالي", "الكل"):
                return int(total_boost_sec)
            return 0

        # 4. النمط الشامل (قاموس مع قيم int صريحة وقسم عام معزول)
        return {
            "wheat": int(boost_seconds.get("wheat", 0)),
            "wood": int(boost_seconds.get("wood", 0)),
            "iron": int(boost_seconds.get("iron", 0)),
            "silver": int(boost_seconds.get("silver", 0)),
            "crystal": int(boost_seconds.get("crystal", 0)),
            "total_boost_seconds": int(total_boost_sec),
            "general": int(general_total_sec),
            "details": {
                **boost_details,
                "general": {
                    "total_seconds": int(general_total_sec),
                    "total_hours": round(general_total_sec / 3600.0, 2),
                    "items": general_items_detail,
                },
            },
        }

    def get_resource_buildings_boost_status(self, resource_type: Optional[str | int] = None) -> Dict[str, Any]:
        """
        جلب حالة حقول ومناشر ومناجم القلعة المحدثة بالكامل مع تحديد الحقول المدعومة (المفعل فيها تسريع)
        وغير المدعومة وتفاصيل الثواني المتبقية ومؤشر مهارة اللورد العامة (0-Network Direct Read).

        المعاملات:
        ----------
        resource_type : Optional[str | int]
            - عند تمرير نوع مورد محدد (مثل: "wheat", "farm", "قمح", "مزرعة", "wood", "خشب",
              "iron", "حديد", "silver", "فضة", "crystal", "بلور"):
              تُرجع حصراً حقول هذا النوع فقط مع ملخص وإحصائيات دقيقة لها.
            - عند عدم تمريره (None) أو تمرير "all" أو "الكل":
              تُرجع تقريراً شاملاً بكافة الحقول والمناجم لجميع الموارد الخمسة.

        القيم المرجعة:
        -------------
        Dict[str, Any] يحوي:
            - target_resource: نوع المورد المفحوص ("all" أو المورد المحدد).
            - total_fields: إجمالي عدد الحقول المفحوصة.
            - boosted_count: عدد الحقول المدعومة (مفعل فيها تسريع).
            - unboosted_count: عدد الحقول غير المدعومة (جاهزة للتسريع).
            - has_any_boosted: هل يوجد أي حقل مدعوم حالياً؟
            - global_production_skill: مؤشر مهارة اللورد العامة (إنتاج سريع 12031 / باف 5129).
            - summary_by_type: ملخص إحصائي تفصيلي لكل نوع حقل ومورد.
            - fields: قائمة تفصيلية بكافة الحقول مع حالة is_boosted والمستوى والثواني المتبقية.
            - boosted_fields: قائمة بالحقول المدعومة حالياً فقط.
            - unboosted_fields: قائمة بالحقول غير المدعومة الجاهزة للتسريع.
        """
        now_ts = int(time.time())

        # 1. استخراج وقراءة بافات الذاكرة الحية (buffCtrl و newBuffCtrl)
        raw_buffs: List[Dict[str, Any]] = []
        for ctrl_name in ("buffCtrl", "newBuffCtrl"):
            ctrl_val = self.get_ctrl(ctrl_name)
            if isinstance(ctrl_val, list):
                raw_buffs.extend([b for b in ctrl_val if isinstance(b, dict)])
            elif isinstance(ctrl_val, dict):
                raw_buffs.extend([b for b in ctrl_val.values() if isinstance(b, dict)])

        active_buffs: List[Dict[str, Any]] = []
        is_global_skill_active = False
        global_skill_remaining = 0

        for b in raw_buffs:
            b_id = int(b.get("id") or b.get("buffId") or b.get("buffID") or 0)
            item_id = int(b.get("itemId") or b.get("itemID") or 0)
            begin_t = int(b.get("beginTime") or 0)
            dur = int(b.get("time") or b.get("duration") or 0)
            end_t = int(b.get("endTime") or b.get("finishTime") or (begin_t + dur))
            rem = max(0, end_t - now_ts) if end_t > 0 else 0

            # فحص مهارة اللورد العامة (إنتاج سريع 12031 / باف 5129)
            if b_id == 5129:
                if rem > 0 or end_t > now_ts:
                    is_global_skill_active = True
                    global_skill_remaining = max(global_skill_remaining, rem)

            if rem <= 0 and end_t > 0:
                continue

            extra = b.get("extra", {})
            b_bid = None
            b_iid = None
            if isinstance(extra, dict):
                b_bid = extra.get("bid")
                b_iid = extra.get("iid")
            elif isinstance(extra, str):
                m = re.search(r'bid_(\d+)_iid_(\d+)', extra)
                if m:
                    b_bid = int(m.group(1))
                    b_iid = int(m.group(2))

            if b_bid is None and "bid" in b:
                b_bid = b["bid"]
            if b_iid is None and "iid" in b:
                b_iid = b["iid"]

            active_buffs.append({
                "buff_id": b_id,
                "item_id": item_id,
                "begin_time": begin_t,
                "duration": dur,
                "finish_time": end_t,
                "remaining_seconds": rem,
                "bid": int(b_bid) if b_bid is not None else None,
                "iid": int(b_iid) if b_iid is not None else None,
            })

        # فحص إضافي لمهارة اللورد إنتاج سريع عبر get_lord_skill_status
        if not is_global_skill_active:
            try:
                skill_st = self.get_lord_skill_status(12031)
                if isinstance(skill_st, dict) and skill_st.get("is_buff_active"):
                    is_global_skill_active = True
                    global_skill_remaining = int(skill_st.get("buff_remaining_seconds", 0) or 0)
            except Exception:
                pass

        # 2. تحديد الفلتر المطلوب للمورد إن وجد
        filter_res: Optional[str] = None
        if resource_type is not None:
            raw_s = str(resource_type).strip()
            if raw_s.lower() not in ("all", "*", "الكل", "كل", "جميع"):
                clean_s = raw_s[2:] if raw_s.startswith("ال") and len(raw_s) > 2 else raw_s
                filter_res = (
                    RESOURCE_BOOST_KEY_MAP.get(raw_s)
                    or RESOURCE_BOOST_KEY_MAP.get(raw_s.lower())
                    or RESOURCE_BOOST_KEY_MAP.get(clean_s)
                    or RESOURCE_BOOST_KEY_MAP.get(clean_s.lower())
                )

        # 3. قراءة مباني وحقول المدينة (cityCtrl.blist)
        city = self.get_ctrl("cityCtrl")
        blist = city.get("blist", []) if isinstance(city, dict) else []
        if not isinstance(blist, list):
            blist = []

        all_fields: List[Dict[str, Any]] = []

        for b_entry in blist:
            if not isinstance(b_entry, dict):
                continue
            binfo = b_entry.get("binfo", {})
            if not isinstance(binfo, dict):
                continue

            bid = int(binfo.get("bid", 0) or 0)
            if bid not in RESOURCE_BUILDING_METADATA:
                continue

            meta = RESOURCE_BUILDING_METADATA[bid]
            r_type = meta["resource"]
            if filter_res is not None and r_type != filter_res:
                continue

            iid = int(binfo.get("iid", 0) or 0)
            lv = int(binfo.get("lv", 0) or 0)
            star_lv = int(binfo.get("starLv", 0) or 0)
            idx = int(binfo.get("index", 0) or 0)
            cur_res = float(binfo.get("curres", 0) or 0.0)
            state = int(binfo.get("state", 0) or 0)

            # مطابقة الباف الخاص بالحقل
            is_boosted = False
            remaining_sec = 0
            finish_t = 0
            matched_buff_id = 0

            for buff in active_buffs:
                if buff["remaining_seconds"] <= 0:
                    continue
                # فحص مطابقة الباف لهذا النوع من المباني
                is_type_match = (
                    buff["buff_id"] == meta["boost_buff_id"]
                    or buff["item_id"] == meta["boost_item_id"]
                    or buff["bid"] == bid
                )
                if is_type_match:
                    if buff["iid"] is not None:
                        if buff["iid"] == iid:
                            is_boosted = True
                            remaining_sec = max(remaining_sec, buff["remaining_seconds"])
                            finish_t = max(finish_t, buff["finish_time"])
                            matched_buff_id = buff["buff_id"]
                    else:
                        # باف بدون تحديد خانة الحقل (يُطبق على الحقل الأكبر أو كافة حقول النوع)
                        is_boosted = True
                        remaining_sec = max(remaining_sec, buff["remaining_seconds"])
                        finish_t = max(finish_t, buff["finish_time"])
                        matched_buff_id = buff["buff_id"]

            all_fields.append({
                "bid": bid,
                "iid": iid,
                "index": idx,
                "resource": r_type,
                "type_name": meta["name_ar"],
                "level": lv,
                "star_level": star_lv,
                "is_boosted": is_boosted,
                "remaining_seconds": remaining_sec,
                "remaining_hours": round(remaining_sec / 3600.0, 2),
                "finish_time": finish_t,
                "boost_item_name": meta["boost_item_name"],
                "boost_item_id": meta["boost_item_id"],
                "boost_buff_id": matched_buff_id or meta["boost_buff_id"],
                "cur_res": cur_res,
                "state": state,
                "global_skill_active": is_global_skill_active,
                "effective_boosted": (is_boosted or is_global_skill_active),
            })

        # ترتيب الحقول: أولاً بنوع المورد، ثم تنازلياً حسب المستوى، ثم حسب رقم الخانة iid
        all_fields.sort(key=lambda f: (f["bid"], -f["level"], f["iid"]))

        boosted_fields = [f for f in all_fields if f["is_boosted"]]
        unboosted_fields = [f for f in all_fields if not f["is_boosted"]]

        # 4. إعداد الملخص الإحصائي لكل نوع مورد
        summary_by_type: Dict[str, Dict[str, Any]] = {}
        for bid_key, meta in RESOURCE_BUILDING_METADATA.items():
            r_key = meta["resource"]
            if filter_res is not None and r_key != filter_res:
                continue
            if r_key in summary_by_type:
                continue

            matching = [f for f in all_fields if f["resource"] == r_key]
            b_cnt = sum(1 for f in matching if f["is_boosted"])
            u_cnt = len(matching) - b_cnt
            max_lv = max([f["level"] for f in matching], default=0)

            summary_by_type[r_key] = {
                "resource": r_key,
                "name_ar": meta["plural_ar"],
                "bid": meta["bid"],
                "total": len(matching),
                "boosted": b_cnt,
                "unboosted": u_cnt,
                "max_level": max_lv,
                "boost_item_name": meta["boost_item_name"],
                "boost_item_id": meta["boost_item_id"],
            }

        return {
            "resource_type": filter_res or "all",
            "total_fields": len(all_fields),
            "boosted_count": len(boosted_fields),
            "unboosted_count": len(unboosted_fields),
            "has_any_boosted": (len(boosted_fields) > 0),
            "global_production_skill": {
                "is_active": is_global_skill_active,
                "remaining_seconds": global_skill_remaining,
                "remaining_minutes": round(global_skill_remaining / 60.0, 1),
                "skill_id": 12031,
                "buff_id": 5129,
                "name_ar": "إنتاج سريع",
            },
            "summary_by_type": summary_by_type,
            "fields": all_fields,
            "boosted_fields": boosted_fields,
            "unboosted_fields": unboosted_fields,
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 18. محرك حزم وباقات طاقة اللورد (Stamina Packs Engine)
    # ═════════════════════════════════════════════════════════════════════════

    def get_available_stamina_packs(
        self, pack_type: Optional[str | int] = None
    ) -> Union[int, Dict[str, Any]]:
        """
        جلب حزم وباقات طاقة اللورد المتاحة في حقيبة القلعة (0-Network Direct Read).
        تعتمد بنسبة 100% على فحص الحقيبة (backpackCtrl / bagCtrl) في الذاكرة الحية المشحونة مسبقاً.

        المعاملات:
        ----------
        pack_type : Optional[str | int]
            - عند تمرير فئة محددة ("10", "50", "100", 10, 50, 100, "300401", "10 طاقة", إلخ):
              تُرجع إجمالي نقاط الطاقة المتاحة من هذه الفئة كرقم صحيح نقي (int).
            - عند تمرير "total", "all", "المجموع", "إجمالي", "الكل", "طاقة":
              تُرجع إجمالي نقاط الطاقة المتاحة عبر كافة الحزم كرقم صحيح نقي (int).
            - عند عدم تمريره (None):
              تُرجع قاموساً شاملاً يحوي:
                "total_stamina": int (مجموع نقاط الطاقة لكافة الحزم)
                "total_packs": int (مجموع عدد الحزم كقطع)
                "10": int (مجموع نقاط الطاقة من حزم الـ 10)
                "50": int (مجموع نقاط الطاقة من حزم الـ 50)
                "100": int (مجموع نقاط الطاقة من حزم الـ 100)
                "details": Dict مع "10", "50", "100" يحوي (item_id, name, name_en, stamina_per_item, count, total_stamina)
            - إذا كان النوع غير معروف أو غير متوفر: تُرجع 0.
        """
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            backpack = {}

        def _read_count(item_id: int | str) -> int:
            entry = backpack.get(str(item_id)) or backpack.get(int(item_id))
            if isinstance(entry, dict):
                try:
                    return int(entry.get("count", 0))
                except (ValueError, TypeError):
                    return 0
            elif isinstance(entry, (int, str)):
                try:
                    return int(entry)
                except (ValueError, TypeError):
                    return 0
            return 0

        total_stamina = 0
        total_packs = 0
        tier_stamina: Dict[str, int] = {}
        details: Dict[str, Dict[str, Any]] = {}

        for tier in ("10", "50", "100"):
            cfg = STAMINA_PACKS_CATALOG[tier]
            iid = cfg["item_id"]
            cnt = _read_count(iid)
            val = cfg["stamina_value"]
            tier_pts = cnt * val

            tier_stamina[tier] = tier_pts
            total_stamina += tier_pts
            total_packs += cnt

            details[tier] = {
                "item_id": iid,
                "name": cfg["name"],
                "name_en": cfg["name_en"],
                "stamina_per_item": val,
                "count": cnt,
                "total_stamina": tier_pts,
            }

        # إذا تم تمرير pack_type محدد
        if pack_type is not None:
            raw_target = str(pack_type).strip() if not isinstance(pack_type, int) else pack_type
            matched_key = (
                STAMINA_PACKS_KEY_MAP.get(pack_type)
                or STAMINA_PACKS_KEY_MAP.get(raw_target)
                or STAMINA_PACKS_KEY_MAP.get(str(raw_target).lower())
            )
            if not matched_key and isinstance(raw_target, str):
                target_clean = raw_target[2:] if raw_target.startswith("ال") and len(raw_target) > 2 else raw_target
                matched_key = (
                    STAMINA_PACKS_KEY_MAP.get(target_clean)
                    or STAMINA_PACKS_KEY_MAP.get(target_clean.lower())
                )

            if matched_key == "total":
                return int(total_stamina)
            elif matched_key in tier_stamina:
                return int(tier_stamina[matched_key])
            return 0

        # النمط الشامل (pack_type is None)
        return {
            "total_stamina": int(total_stamina),
            "total_packs": int(total_packs),
            "10": int(tier_stamina.get("10", 0)),
            "50": int(tier_stamina.get("50", 0)),
            "100": int(tier_stamina.get("100", 0)),
            "details": details,
        }





