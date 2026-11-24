# -*- coding: utf-8 -*-
"""
python tools/test_base_task.py --email beetoo2@hotmail.com --fn get_lord_skill_status



python tools/test_base_task.py --email beetoo3@hotmail.com --fn get_lord_skill_status --skill  "الطاقة الوافرة"


python tools/test_base_task.py --email beetoo2@hotmail.com --fn use_lord_skill --skill  "الإكسير الفتاك"


python tools/test_base_task.py --email beetoo3@hotmail.com command_hall



python tools/test_base_task.py --email beetoo2 --fn get_material_workshop_status


python tools/test_base_task.py --email beetoo1 --fn get_resource_buildings_boost_status




python tools/test_base_task.py --email beetoo1 --fn get_leadership_technology_additions




python tools/test_base_task.py --email beetoo2 --fn get_max_attack_march_capacity 

"""

from __future__ import annotations

import asyncio
from abc import ABC, abstractmethod
import json
import math
import os
import random
import re
import sys
import time
from typing import Any, Callable, Dict, FrozenSet, List, Optional, Set, Tuple, Union

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass


class ConnectionCircuitBreakerError(Exception):
    """
    استثناء قاطع الاتصال (Connection Circuit Breaker Exception):
    يتم إطلاقه فور رصد انقطاع الاتصال بالسيرفر أو موت المقبس لمنع تكرار
    الاستعلامات الفاشلة على مقبس ميت وحماية حساب القلعة.
    """
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
COMMAND_HALL_HIGH_LV_EXP = 4800  # newcommandhalllv.lua Index 21: lv = {21, 999}, needExp = 4800
COMMAND_HALL_OPEN_LV = 3         # constant.lua: COMMANDHALL_OPEN_LV = 3
COMMAND_HALL_MAX_LEVEL = 99999   # commandHallRead.getCommandLvMax() -> 99999
COMMAND_HALL_DAILY_QUEST_TARGET = 3  # أكمل 3 مهام من مهام قاعة القيادة (daily_reward_point_config.lua: ID=4100033, type=33, quest=3)

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
        "queue_type": 1233,
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
        "queue_type": 1234,
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
        "queue_type": 1235,
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
        "queue_type": 1237,
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
        "queue_type": 1236,
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
# ثوابت وتصنيفات الأبطال الرسمية (Official Game Hero Standards)
# مطابقة 100% لسورس كود العميل الأصلي (heroDef.lua / heroCtrl.lua / heroltCtrl.lua)
# ═════════════════════════════════════════════════════════════════════════

# أنواع الأبطال الرسمية (gHeroType في heroDef.lua)
G_HERO_TYPE_ANCILLARY = 1  # مساعد / تنمية / دعم (Ancillary / Support)
G_HERO_TYPE_CHARIOTS = 2   # عربات (Chariots / Siege)
G_HERO_TYPE_CAVALRY = 3    # فرسان (Cavalry)
G_HERO_TYPE_ARCHER = 4     # رماة (Archer)
G_HERO_TYPE_INFANTRY = 5   # مشاة (Infantry)

G_HERO_TYPE: Dict[str, int] = {
    "ANCILLARY": 1,
    "CHARIOTS": 2,
    "CAVALRY": 3,
    "ARCHER": 4,
    "INFANTRY": 5,
}

# حالات الأبطال الرسمية (gHeroState في heroDef.lua)
G_HERO_STATE_NORMAL = 1    # شاغر / متفرغ داخل القلعة (Normal / Available / Idle)
G_HERO_STATE_DEAD = 2      # ميت (Dead)
G_HERO_STATE_CAPTURED = 3  # مأسور في سجن العدو (Captured)
G_HERO_STATE_BATTLE = 4    # زحف / مسيرة نشطة (Battle / Marching)
G_HERO_STATE_DEFEND = 5    # حامية السور (Defending Castle Wall)
G_HERO_STATE_ESCAPE = 6    # هارب (Escape)
G_HERO_STATE_GARRISON = 7  # مرابط في الحصن العسكري (Garrison)

G_HERO_STATE: Dict[str, int] = {
    "NORMAL": 1,
    "DEAD": 2,
    "CAPTURED": 3,
    "BATTLE": 4,
    "DEFEND": 5,
    "ESCAPE": 6,
    "GARRISON": 7,
}

# مجموعات أبطال القتال وأبطال التطوير بحسب سورس كود اللعبة
COMBAT_HERO_TYPES: Set[int] = {
    G_HERO_TYPE_CHARIOTS,
    G_HERO_TYPE_CAVALRY,
    G_HERO_TYPE_ARCHER,
    G_HERO_TYPE_INFANTRY,
}  # {2, 3, 4, 5}

DEVELOPMENT_HERO_TYPES: Set[int] = {G_HERO_TYPE_ANCILLARY}  # {1}
GATHERING_SPECIALIST_HERO_IDS: Set[int] = {1711, 1724, 1733}  # أبطال الجمع التخصصيين (الانيق، الضرغام، صخر)

# خريطة الكلمات المفتاحية الذكية للأنواع
HERO_TYPE_FILTER_MAP: Dict[str, Set[int]] = {
    "all": {1, 2, 3, 4, 5},
    "any": {1, 2, 3, 4, 5},
    "الكل": {1, 2, 3, 4, 5},
    "جميع": {1, 2, 3, 4, 5},
    "combat": {2, 3, 4, 5},
    "war": {2, 3, 4, 5},
    "battle": {2, 3, 4, 5},
    "قتال": {2, 3, 4, 5},
    "حرب": {2, 3, 4, 5},
    "عسكري": {2, 3, 4, 5},
    "infantry": {5},
    "مشاة": {5},
    "مشاه": {5},
    "cavalry": {3},
    "فرسان": {3},
    "خيل": {3},
    "archer": {4},
    "archers": {4},
    "bowmen": {4},
    "رماة": {4},
    "رماه": {4},
    "chariots": {2},
    "chariot": {2},
    "siege": {2},
    "عربات": {2},
    "عربة": {2},
    "ancillary": {1},
    "support": {1},
    "development": {1},
    "assist": {1},
    "تطوير": {1},
    "دعم": {1},
    "مساعد": {1},
    "جمع": {1},
}

# كتالوج الأبطال الرسمي المستخرج بدقة من سورس كود اللعبة ومحلي اللغات (57 بطلاً)
OFFICIAL_HERO_CATALOG: Dict[int, Dict[str, Any]] = {
    1700: {"id": 1700, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1700", "name_ar": "امير الصحراء", "rarity": 1},
    1701: {"id": 1701, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1701", "name_ar": "قاهرة الاعداء", "rarity": 1},
    1702: {"id": 1702, "type": 2, "type_en": "chariots", "type_ar": "عربات", "name": "heroname_1702", "name_ar": "أمير الشرق", "rarity": 1},
    1703: {"id": 1703, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1703", "name_ar": "الفاتح", "rarity": 1},
    1704: {"id": 1704, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1704", "name_ar": "امير الظلام", "rarity": 2},
    1705: {"id": 1705, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1705", "name_ar": "البارق", "rarity": 2},
    1706: {"id": 1706, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1706", "name_ar": "صقر المملكه", "rarity": 2},
    1707: {"id": 1707, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1707", "name_ar": "المرعب", "rarity": 2},
    1708: {"id": 1708, "type": 2, "type_en": "chariots", "type_ar": "عربات", "name": "heroname_1708", "name_ar": "اميرة الحرب", "rarity": 2},
    1709: {"id": 1709, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1709", "name_ar": "الاسطورة", "rarity": 2},
    1710: {"id": 1710, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1710", "name_ar": "أمير الحرب", "rarity": 3},
    1711: {"id": 1711, "type": 1, "type_en": "ancillary", "type_ar": "مساعد", "name": "heroname_1711", "name_ar": "الانيق", "rarity": 3},
    1712: {"id": 1712, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1712", "name_ar": "الغضنفر", "rarity": 3},
    1713: {"id": 1713, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1713", "name_ar": "السفاح", "rarity": 4},
    1714: {"id": 1714, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1714", "name_ar": "الزعيم", "rarity": 3},
    1716: {"id": 1716, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1716", "name_ar": "أميرة الرماة", "rarity": 4},
    1717: {"id": 1717, "type": 1, "type_en": "ancillary", "type_ar": "مساعد", "name": "heroname_1717", "name_ar": "المزيونة", "rarity": 2},
    1718: {"id": 1718, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1718", "name_ar": "المفترس", "rarity": 2},
    1719: {"id": 1719, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1719", "name_ar": "المستبدة", "rarity": 4},
    1720: {"id": 1720, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1720", "name_ar": "الكاسر", "rarity": 4},
    1721: {"id": 1721, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1721", "name_ar": "صائد الفرسان", "rarity": 4},
    1722: {"id": 1722, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1722", "name_ar": "الهمام", "rarity": 4},
    1723: {"id": 1723, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1723", "name_ar": "الأمير القناص", "rarity": 4},
    1724: {"id": 1724, "type": 1, "type_en": "ancillary", "type_ar": "مساعد", "name": "heroname_1724", "name_ar": "الضرغام", "rarity": 3},
    1725: {"id": 1725, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1725", "name_ar": "اليمامة", "rarity": 3},
    1726: {"id": 1726, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1726", "name_ar": "جسار", "rarity": 4},
    1727: {"id": 1727, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1727", "name_ar": "المُهاب", "rarity": 4},
    1728: {"id": 1728, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1728", "name_ar": "الصارم المقدام", "rarity": 3},
    1729: {"id": 1729, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1729", "name_ar": "الباسلة", "rarity": 4},
    1730: {"id": 1730, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1730", "name_ar": "جساس", "rarity": 4},
    1731: {"id": 1731, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1731", "name_ar": "الحازم البتار", "rarity": 4},
    1732: {"id": 1732, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1732", "name_ar": "الإمبراطور", "rarity": 4},
    1733: {"id": 1733, "type": 1, "type_en": "ancillary", "type_ar": "مساعد", "name": "heroname_1733", "name_ar": "صخر", "rarity": 2},
    1734: {"id": 1734, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1734", "name_ar": "العنيد", "rarity": 4},
    1735: {"id": 1735, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1735", "name_ar": "العنقاء", "rarity": 4},
    1736: {"id": 1736, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1736", "name_ar": "العاصوف", "rarity": 4},
    1737: {"id": 1737, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1737", "name_ar": "الصنديد", "rarity": 4},
    1738: {"id": 1738, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1738", "name_ar": "الشنفرى", "rarity": 4},
    1739: {"id": 1739, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1739", "name_ar": "الباشق", "rarity": 4},
    1740: {"id": 1740, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1740", "name_ar": "الجليلة", "rarity": 4},
    1741: {"id": 1741, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1741", "name_ar": "فارس الهيجاء", "rarity": 4},
    1742: {"id": 1742, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1742", "name_ar": "الملاك الساهرة", "rarity": 4},
    1743: {"id": 1743, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1743", "name_ar": "أميرة وحيد القرن", "rarity": 4},
    1744: {"id": 1744, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1744", "name_ar": "المدمّر", "rarity": 4},
    1745: {"id": 1745, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1745", "name_ar": "أُسيد", "rarity": 4},
    1746: {"id": 1746, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1746", "name_ar": "الماجدة", "rarity": 4},
    1747: {"id": 1747, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1747", "name_ar": "هدير اللهب", "rarity": 5},
    1748: {"id": 1748, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1748", "name_ar": "السهم الصاعق", "rarity": 5},
    1749: {"id": 1749, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1749", "name_ar": "سلطان عاصفة الصحراء", "rarity": 5},
    1750: {"id": 1750, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1750", "name_ar": "قُصي", "rarity": 5},
    1751: {"id": 1751, "type": 3, "type_en": "cavalry", "type_ar": "فرسان", "name": "heroname_1751", "name_ar": "زُهير", "rarity": 4},
    1752: {"id": 1752, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1752", "name_ar": "سليل الصوارم", "rarity": 5},
    1753: {"id": 1753, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1753", "name_ar": "شاهين", "rarity": 5},
    1754: {"id": 1754, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1754", "name_ar": "وقاص", "rarity": 5},
    1755: {"id": 1755, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1755", "name_ar": "ملكة الغابة", "rarity": 5},
    1756: {"id": 1756, "type": 5, "type_en": "infantry", "type_ar": "مشاة", "name": "heroname_1756", "name_ar": "صياد الصحراء", "rarity": 5},
    1757: {"id": 1757, "type": 4, "type_en": "archer", "type_ar": "رماة", "name": "heroname_1757", "name_ar": "العاصف الرعدي", "rarity": 5},
}


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
    "207": "crystal", 207: "crystal", "217": "crystal", 217: "crystal", "218": "crystal", 218: "crystal", "503201": "crystal", 503201: "crystal",

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
        "building_id": 207,
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
    207: {
        "bid": 207,
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

# ربط المعرفات الاحتياطية لمنجم البلور بنفس التعريف دون تكرار
for _legacy_crystal_bid in (217, 218):
    RESOURCE_BUILDING_METADATA[_legacy_crystal_bid] = {
        **RESOURCE_BUILDING_METADATA[207],
        "bid": _legacy_crystal_bid,
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

# ═════════════════════════════════════════════════════════════════════════
# ثوابت سورس كود اللعبة للوحدات وفخاخ حصن الحرب (buildDef.lua / armyinfo.lua)
# ═════════════════════════════════════════════════════════════════════════
BUILDID_FORTRESS = 120  # معرف مبنى حصن الحرب طبقاً لسورس اللعبة (buildDef.lua - BUILDID.FORTRESS)

# معرفات فخاخ وعناصر حصن الحرب الرسمية (15 فخاً برتب مختلفة من armyinfo.lua حيث barrackID == 120)
FORTRESS_TRAP_IDS: FrozenSet[int] = frozenset({
    801, 802, 803, 804, 805,
    811, 812, 813, 814, 815,
    821, 822, 823, 824, 825,
})

# ═════════════════════════════════════════════════════════════════════════
# ثوابت وجداول حساب سعة المسيرة القصوى (Single March Troop Limit)
# مطابقة تامة لسورس اللعبة (buildLogic.lua, build121.lua, technology.lua)
# ═════════════════════════════════════════════════════════════════════════

DRILL_GROUNDS_BUILDING_ID = 121
DEFAULT_EXP_ARMY_COUNT = 1000

# سعة مبنى ميدان العرض الأساسية لكل مستوى (Drill Grounds Lv.1 - Lv.130)
# مأخوذة بدقة 100% من كود العميل build121.lua
DRILL_GROUNDS_CAPACITY: Dict[int, int] = {
    1: 3000, 2: 5000, 3: 7100, 4: 9300, 5: 11600,
    6: 14000, 7: 16500, 8: 19100, 9: 21800, 10: 24600,
    11: 27500, 12: 30500, 13: 33600, 14: 36800, 15: 40100,
    16: 43500, 17: 47000, 18: 50600, 19: 54300, 20: 58100,
    21: 62000, 22: 66000, 23: 70100, 24: 74300, 25: 78600,
    26: 83000, 27: 87500, 28: 92100, 29: 96800, 30: 101600,
    31: 101600, 32: 101600, 33: 101600, 34: 101600, 35: 101600,
    36: 101600, 37: 101600, 38: 101600, 39: 101600, 40: 106500,
    41: 106500, 42: 106500, 43: 106500, 44: 106500, 45: 106500,
    46: 106500, 47: 106500, 48: 106500, 49: 106500, 50: 112000,
    51: 112000, 52: 112000, 53: 112000, 54: 112000, 55: 112000,
    56: 112000, 57: 112000, 58: 112000, 59: 112000, 60: 120000,
    61: 120000, 62: 120000, 63: 120000, 64: 120000, 65: 120000,
    66: 120000, 67: 120000, 68: 120000, 69: 120000, 70: 128000,
    71: 128000, 72: 128000, 73: 128000, 74: 128000, 75: 128000,
    76: 128000, 77: 128000, 78: 128000, 79: 128000, 80: 136000,
    81: 136000, 82: 136000, 83: 136000, 84: 136000, 85: 136000,
    86: 136000, 87: 136000, 88: 136000, 89: 136000, 90: 146000,
    91: 146000, 92: 146000, 93: 146000, 94: 146000, 95: 146000,
    96: 146000, 97: 146000, 98: 146000, 99: 146000, 100: 158000,
    101: 158000, 102: 158000, 103: 158000, 104: 158000, 105: 158000,
    106: 158000, 107: 158000, 108: 158000, 109: 158000, 110: 172000,
    111: 172000, 112: 172000, 113: 172000, 114: 172000, 115: 172000,
    116: 172000, 117: 172000, 118: 172000, 119: 172000, 120: 188000,
    121: 188000, 122: 188000, 123: 188000, 124: 188000, 125: 188000,
    126: 188000, 127: 188000, 128: 188000, 129: 188000, 130: 208000,
}

# سعة إضافية لنجوم قصر المجد لميدان العرض (Star Lv.1 - Lv.70)
# مأخوذة بدقة 100% من كود العميل buildstar121.lua
DRILL_GROUNDS_STAR_CAPACITY: Dict[int, int] = {
    1: 1500, 2: 3000, 3: 4500, 4: 6000, 5: 7500,
    6: 9000, 7: 13500, 8: 15000, 9: 16500, 10: 18000,
    11: 19500, 12: 21000, 13: 22500, 14: 24000, 15: 25500,
    16: 27000, 17: 31500, 18: 33000, 19: 34500, 20: 36000,
    21: 37500, 22: 39000, 23: 40500, 24: 42000, 25: 43500,
    26: 45000, 27: 46500, 28: 48000, 29: 49500, 30: 51000,
    31: 55500, 32: 57000, 33: 58500, 34: 60000, 35: 61500,
    36: 63000, 37: 64500, 38: 66000, 39: 67500, 40: 69000,
    41: 70500, 42: 72000, 43: 73500, 44: 75000, 45: 76500,
    46: 78000, 47: 79500, 48: 81000, 49: 85500, 50: 87000,
    51: 88500, 52: 90000, 53: 91500, 54: 93000, 55: 94500,
    56: 96000, 57: 97500, 58: 99000, 59: 100500, 60: 102000,
    61: 103500, 62: 105000, 63: 106500, 64: 108000, 65: 109500,
    66: 111000, 67: 112500, 68: 114000, 69: 115500, 70: 120000,
}

# أبحاث القيادة بمعهد الأبحاث الكاملة (Technology Type 43 / SINGLE_TROOP_STRENGTH - من technology.lua)
LEADERSHIP_TECH_ADDITIONS: Dict[int, Dict[int, int]] = {
    24016: {1: 2000, 2: 4000, 3: 6000},
    24032: {1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500},
    24048: {1: 3000, 2: 6000, 3: 9000, 4: 12000, 5: 15000, 6: 18000, 7: 21000},
    25030: {1: 1000},
    110027: {1: 2000, 2: 4000, 3: 6000, 4: 8000, 5: 10000},
    170012: {1: 750, 2: 1500, 3: 2250, 4: 3000, 5: 3750, 6: 4500, 7: 5250, 8: 6000, 9: 6750, 10: 7500},
    170013: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170054: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170055: {1: 1000, 2: 2000, 3: 3000, 4: 4000, 5: 5000, 6: 6000, 7: 7000, 8: 8000, 9: 9000, 10: 10000},
    170092: {1: 300, 2: 600, 3: 900, 4: 1200, 5: 1500, 6: 1950, 7: 2400, 8: 2850, 9: 3300, 10: 3750, 11: 4350, 12: 4950, 13: 5550, 14: 6150, 15: 6750, 16: 7500, 17: 8250, 18: 9000, 19: 9750, 20: 10500, 21: 11400, 22: 12300, 23: 13200, 24: 14100, 25: 15000},
    170104: {1: 400, 2: 800, 3: 1200, 4: 1600, 5: 2000, 6: 2500, 7: 3000, 8: 3500, 9: 4000, 10: 4500, 11: 5100, 12: 5700, 13: 6300, 14: 6900, 15: 7500, 16: 8200, 17: 8900, 18: 9600, 19: 10300, 20: 11000, 21: 11800, 22: 12600, 23: 13400, 24: 14200, 25: 15000, 26: 16000, 27: 17000, 28: 18000, 29: 19000, 30: 20000},
    170140: {1: 300, 2: 600, 3: 900, 4: 1200, 5: 1500, 6: 1875, 7: 2250, 8: 2625, 9: 3000, 10: 3375, 11: 3825, 12: 4275, 13: 4725, 14: 5175, 15: 5625, 16: 6150, 17: 6675, 18: 7200, 19: 7725, 20: 8250, 21: 8850, 22: 9450, 23: 10050, 24: 10650, 25: 11250, 26: 12000, 27: 12750, 28: 13500, 29: 14250, 30: 15000},
    170148: {1: 480, 2: 960, 3: 1440, 4: 1920, 5: 2400, 6: 3000, 7: 3600, 8: 4200, 9: 4800, 10: 5400, 11: 6120, 12: 6840, 13: 7560, 14: 8280, 15: 9000, 16: 9840, 17: 10680, 18: 11520, 19: 12360, 20: 13200, 21: 14160, 22: 15120, 23: 16080, 24: 17040, 25: 18000, 26: 19200, 27: 20400, 28: 21600, 29: 22800, 30: 24000, 31: 25200, 32: 26400, 33: 27600, 34: 28800, 35: 30000},
    304071: {1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000, 11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000},
    404071: {1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000, 11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000},
    414071: {1: 2500, 2: 5000, 3: 7500, 4: 10000, 5: 12500, 6: 15000, 7: 17500, 8: 20000, 9: 22500, 10: 25000, 11: 27500, 12: 30000, 13: 32500, 14: 35000, 15: 37500, 16: 40000, 17: 42500, 18: 45000, 19: 47500, 20: 50000},
}

# أبحاث مجموعات الحروب المئوية لسعة المسيرة (Buff Types 73, 77, 95 مقاسة بالألف - من technology.lua)
TECH_GROUP_MARCH_PERCENT: Dict[int, Dict[str, Any]] = {
    24319: {"buff_type": 77, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
    24320: {"buff_type": 73, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
    24324: {"buff_type": 95, "levels": {1: 20, 2: 40, 3: 60, 4: 80, 5: 100}},
}

# جدول سعة المسيرة الإضافية للأبطال حسب الندرة والمستوى (hero_level_config.lua: rarity 1..5, level 1..120)
HERO_RARE_LEVEL_MARCH_ADD: Dict[int, Dict[int, int]] = {
    1: {
        1: 500, 2: 550, 3: 600, 4: 650, 5: 700, 6: 750, 7: 800, 8: 850, 9: 900, 10: 950,
        11: 1000, 12: 1060, 13: 1120, 14: 1180, 15: 1240, 16: 1300, 17: 1360, 18: 1420, 19: 1480, 20: 1540,
        21: 1600, 22: 1670, 23: 1730, 24: 1800, 25: 1860, 26: 1930, 27: 1990, 28: 2060, 29: 2120, 30: 2190,
        31: 2250, 32: 2330, 33: 2400, 34: 2480, 35: 2550, 36: 2630, 37: 2700, 38: 2780, 39: 2850, 40: 2930,
        41: 3000, 42: 3100, 43: 3200, 44: 3300, 45: 3400, 46: 3500, 47: 3600, 48: 3700, 49: 3800, 50: 3900,
        51: 4000, 52: 4110, 53: 4220, 54: 4330, 55: 4440, 56: 4550, 57: 4660, 58: 4770, 59: 4880, 60: 5000,
        61: 5000, 62: 5000, 63: 5000, 64: 5000, 65: 5000, 66: 5000, 67: 5000, 68: 5000, 69: 5000, 70: 5000,
        71: 5000, 72: 5000, 73: 5000, 74: 5000, 75: 5000, 76: 5000, 77: 5000, 78: 5000, 79: 5000, 80: 5000,
        81: 5000, 82: 5000, 83: 5000, 84: 5000, 85: 5000, 86: 5000, 87: 5000, 88: 5000, 89: 5000, 90: 5000,
        91: 5000, 92: 5000, 93: 5000, 94: 5000, 95: 5000, 96: 5000, 97: 5000, 98: 5000, 99: 5000, 100: 5000,
        101: 5000, 102: 5000, 103: 5000, 104: 5000, 105: 5000, 106: 5000, 107: 5000, 108: 5000, 109: 5000, 110: 5000,
        111: 5000, 112: 5000, 113: 5000, 114: 5000, 115: 5000, 116: 5000, 117: 5000, 118: 5000, 119: 5000, 120: 5000,
    },
    2: {
        1: 600, 2: 660, 3: 720, 4: 780, 5: 840, 6: 900, 7: 960, 8: 1020, 9: 1080, 10: 1140,
        11: 1200, 12: 1272, 13: 1344, 14: 1416, 15: 1488, 16: 1560, 17: 1632, 18: 1704, 19: 1776, 20: 1848,
        21: 1920, 22: 1998, 23: 2076, 24: 2154, 25: 2232, 26: 2310, 27: 2388, 28: 2466, 29: 2544, 30: 2622,
        31: 2700, 32: 2790, 33: 2880, 34: 2970, 35: 3060, 36: 3150, 37: 3240, 38: 3330, 39: 3420, 40: 3510,
        41: 3600, 42: 3720, 43: 3840, 44: 3960, 45: 4080, 46: 4200, 47: 4320, 48: 4440, 49: 4560, 50: 4680,
        51: 4800, 52: 4932, 53: 5064, 54: 5196, 55: 5328, 56: 5460, 57: 5592, 58: 5724, 59: 5856, 60: 6000,
        61: 6000, 62: 6000, 63: 6000, 64: 6000, 65: 6000, 66: 6000, 67: 6000, 68: 6000, 69: 6000, 70: 6000,
        71: 6000, 72: 6000, 73: 6000, 74: 6000, 75: 6000, 76: 6000, 77: 6000, 78: 6000, 79: 6000, 80: 6000,
        81: 6000, 82: 6000, 83: 6000, 84: 6000, 85: 6000, 86: 6000, 87: 6000, 88: 6000, 89: 6000, 90: 6000,
        91: 6000, 92: 6000, 93: 6000, 94: 6000, 95: 6000, 96: 6000, 97: 6000, 98: 6000, 99: 6000, 100: 6000,
        101: 6000, 102: 6000, 103: 6000, 104: 6000, 105: 6000, 106: 6000, 107: 6000, 108: 6000, 109: 6000, 110: 6000,
        111: 6000, 112: 6000, 113: 6000, 114: 6000, 115: 6000, 116: 6000, 117: 6000, 118: 6000, 119: 6000, 120: 6000,
    },
    3: {
        1: 700, 2: 770, 3: 840, 4: 910, 5: 980, 6: 1050, 7: 1120, 8: 1190, 9: 1260, 10: 1330,
        11: 1400, 12: 1484, 13: 1568, 14: 1652, 15: 1736, 16: 1820, 17: 1904, 18: 1988, 19: 2072, 20: 2156,
        21: 2240, 22: 2331, 23: 2422, 24: 2513, 25: 2604, 26: 2695, 27: 2786, 28: 2877, 29: 2968, 30: 3059,
        31: 3150, 32: 3255, 33: 3360, 34: 3465, 35: 3570, 36: 3675, 37: 3780, 38: 3885, 39: 3990, 40: 4095,
        41: 4200, 42: 4340, 43: 4480, 44: 4620, 45: 4760, 46: 4900, 47: 5040, 48: 5180, 49: 5320, 50: 5460,
        51: 5600, 52: 5754, 53: 5908, 54: 6062, 55: 6216, 56: 6370, 57: 6524, 58: 6678, 59: 6832, 60: 7000,
        61: 7000, 62: 7000, 63: 7000, 64: 7000, 65: 7000, 66: 7000, 67: 7000, 68: 7000, 69: 7000, 70: 7000,
        71: 7000, 72: 7000, 73: 7000, 74: 7000, 75: 7000, 76: 7000, 77: 7000, 78: 7000, 79: 7000, 80: 7000,
        81: 7000, 82: 7000, 83: 7000, 84: 7000, 85: 7000, 86: 7000, 87: 7000, 88: 7000, 89: 7000, 90: 7000,
        91: 7000, 92: 7000, 93: 7000, 94: 7000, 95: 7000, 96: 7000, 97: 7000, 98: 7000, 99: 7000, 100: 7000,
        101: 7000, 102: 7000, 103: 7000, 104: 7000, 105: 7000, 106: 7000, 107: 7000, 108: 7000, 109: 7000, 110: 7000,
        111: 7000, 112: 7000, 113: 7000, 114: 7000, 115: 7000, 116: 7000, 117: 7000, 118: 7000, 119: 7000, 120: 7000,
    },
    4: {
        1: 700, 2: 770, 3: 840, 4: 910, 5: 980, 6: 1050, 7: 1120, 8: 1190, 9: 1260, 10: 1330,
        11: 1400, 12: 1484, 13: 1568, 14: 1652, 15: 1736, 16: 1820, 17: 1904, 18: 1988, 19: 2072, 20: 2156,
        21: 2240, 22: 2331, 23: 2422, 24: 2513, 25: 2604, 26: 2695, 27: 2786, 28: 2877, 29: 2968, 30: 3059,
        31: 3150, 32: 3255, 33: 3360, 34: 3465, 35: 3570, 36: 3675, 37: 3780, 38: 3885, 39: 3990, 40: 4095,
        41: 4200, 42: 4340, 43: 4480, 44: 4620, 45: 4760, 46: 4900, 47: 5040, 48: 5180, 49: 5320, 50: 5460,
        51: 5600, 52: 5754, 53: 5908, 54: 6062, 55: 6216, 56: 6370, 57: 6524, 58: 6678, 59: 6832, 60: 7000,
        61: 7000, 62: 7000, 63: 7000, 64: 7000, 65: 7000, 66: 7000, 67: 7000, 68: 7000, 69: 7000, 70: 7000,
        71: 7000, 72: 7000, 73: 7000, 74: 7000, 75: 7000, 76: 7000, 77: 7000, 78: 7000, 79: 7000, 80: 7000,
        81: 7000, 82: 7000, 83: 7000, 84: 7000, 85: 7000, 86: 7000, 87: 7000, 88: 7000, 89: 7000, 90: 7000,
        91: 7000, 92: 7000, 93: 7000, 94: 7000, 95: 7000, 96: 7000, 97: 7000, 98: 7000, 99: 7000, 100: 7000,
        101: 7000, 102: 7000, 103: 7000, 104: 7000, 105: 7000, 106: 7000, 107: 7000, 108: 7000, 109: 7000, 110: 7000,
        111: 7000, 112: 7000, 113: 7000, 114: 7000, 115: 7000, 116: 7000, 117: 7000, 118: 7000, 119: 7000, 120: 7000,
    },
    5: {
        1: 750, 2: 825, 3: 900, 4: 975, 5: 1050, 6: 1125, 7: 1200, 8: 1275, 9: 1350, 10: 1425,
        11: 1500, 12: 1590, 13: 1680, 14: 1770, 15: 1860, 16: 1950, 17: 2040, 18: 2130, 19: 2220, 20: 2310,
        21: 2400, 22: 2498, 23: 2596, 24: 2694, 25: 2792, 26: 2890, 27: 2988, 28: 3086, 29: 3184, 30: 3282,
        31: 3380, 32: 3492, 33: 3604, 34: 3716, 35: 3828, 36: 3940, 37: 4052, 38: 4164, 39: 4276, 40: 4388,
        41: 4500, 42: 4650, 43: 4800, 44: 4950, 45: 5100, 46: 5250, 47: 5400, 48: 5550, 49: 5700, 50: 5850,
        51: 6000, 52: 6165, 53: 6330, 54: 6495, 55: 6660, 56: 6825, 57: 6990, 58: 7155, 59: 7320, 60: 7500,
        61: 7500, 62: 7500, 63: 7500, 64: 7500, 65: 7500, 66: 7500, 67: 7500, 68: 7500, 69: 7500, 70: 7500,
        71: 7500, 72: 7500, 73: 7500, 74: 7500, 75: 7500, 76: 7500, 77: 7500, 78: 7500, 79: 7500, 80: 7500,
        81: 7500, 82: 7500, 83: 7500, 84: 7500, 85: 7500, 86: 7500, 87: 7500, 88: 7500, 89: 7500, 90: 7500,
        91: 7500, 92: 7500, 93: 7500, 94: 7500, 95: 7500, 96: 7500, 97: 7500, 98: 7500, 99: 7500, 100: 7500,
        101: 7500, 102: 7500, 103: 7500, 104: 7500, 105: 7500, 106: 7500, 107: 7500, 108: 7500, 109: 7500, 110: 7500,
        111: 7500, 112: 7500, 113: 7500, 114: 7500, 115: 7500, 116: 7500, 117: 7500, 118: 7500, 119: 7500, 120: 7500,
    },
}

# خصائص رونات العتاد الإلهي التي تمنح زيادة سعة المسيرة (rune_property_config.lua: Attribute[1]=96)
RUNE_MARCH_PROPERTY_BASE: Dict[int, int] = {11103: 60, 11203: 100, 11303: 150, 11403: 200, 11503: 300, 12203: 130, 12303: 195, 12403: 260, 12503: 390, 21103: 60, 21203: 100, 21303: 150, 21403: 200, 21503: 300, 31103: 60, 31203: 100, 31303: 150, 31403: 200, 31503: 300, 41102: 60, 41202: 100, 41302: 150, 41402: 200, 41502: 300}

# بافات المسيرة الرسمية المعروفة (Buff ID -> (EffectType, EffectValue))
KNOWN_MARCH_BUFFS: Dict[int, Tuple[int, int]] = {
    4006: (19, 100),   # +10%
    5010: (19, 250),   # +25%
    4506: (19, 100),   # +10%
    5044: (19, 350),   # +35%
    4569: (19, 100),   # +10%
    4570: (19, 150),   # +15%
    5055: (19, 500),   # +50%
    5056: (19, 500),   # +50%
    5091: (19, 200),   # +20%
    5120: (19, 250),   # +25%
    5302: (19, 200),   # +20%
    5305: (19, 150),   # +15%
    5333: (19, 80),    # +8%
    5496: (19, 150),   # +15%
    5499: (19, 80),    # +8%
    5797: (96, 20000), # +20,000 جندي
    5921: (96, 5000000), # +5,000,000 جندي (باف المسيرة الضخم Mega March)
    # بافات الحشود MASS_MARCH_LIMIT_BOOST (736) و MASS_MARCH_VALUE_LIMIT_BOOST (737)
    5076: (736, 100),  # +10% لسعة الحشد
    5077: (736, 200),  # +20% لسعة الحشد
}

# مهارات معركة الأبطال التي تزيد سعة الفيلق بحسب جودة ولون البطل Quality 1..6
# مستخرجة بدقة 100% من سورس اللعبة الرسمي hero_skill_conf.lua (activeType=2 و buffType=96)
HERO_MARCH_SKILLS_BY_QUALITY: Dict[int, Dict[int, int]] = {
    171601: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172001: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172101: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172201: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172301: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172601: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    172701: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173004: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173104: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173204: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173401: {1: 1500, 2: 3000, 3: 6000, 4: 9000, 5: 15000},
    173501: {1: 1000, 2: 2000, 3: 4000, 4: 7000, 5: 12000},
    173601: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173701: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173801: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    173901: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174001: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174101: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174201: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174301: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174401: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174501: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174601: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    174701: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    174801: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    174901: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175001: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175101: {1: 1250, 2: 2500, 3: 5000, 4: 8750, 5: 15000},
    175201: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175301: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175401: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175501: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175601: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
    175701: {1: 1440, 2: 2700, 3: 5220, 4: 9000, 5: 14400, 6: 18000},
}

# قيم افتراضية لمهارات معركة الأبطال بحسب أعلى جودة (للتوافق القديم)
HERO_MARCH_SKILLS_VAL: Dict[int, int] = {
    k: max(v.values()) for k, v in HERO_MARCH_SKILLS_BY_QUALITY.items()
}

def get_hero_battle_skill_march_add(skill_type: int, quality: int = 1) -> int:
    """استخراج الزيادة الرسمية لمهارة المعركة بحسب جودة البطل من hero_skill_conf.lua."""
    q_dict = HERO_MARCH_SKILLS_BY_QUALITY.get(skill_type)
    if not q_dict:
        return HERO_MARCH_SKILLS_VAL.get(skill_type, 0)
    if quality in q_dict:
        return q_dict[quality]
    max_q = max(q_dict.keys())
    min_q = min(q_dict.keys())
    if quality >= max_q:
        return q_dict[max_q]
    if quality <= min_q:
        return q_dict[min_q]
    return q_dict.get(min_q, 1000)

# ── بافات ميداليات الإنجازات الرسمية لسعة المسيرة (Achievement Medal Properties) ──
# مأخوذة بدقة 100% من سورس اللعبة:
#   - achievementctrl.buffVsAchieve[gBuffEffect.MARCH_LIMIT_BOOST] = gAchieveProperty.MARCH_LIMIT_BOOST (14)
#   - Medal 9003017 ("توحيد القوة" - قتل الأعداء بالحشد / Achievement Type 17)
ACHIEVEMENT_MARCH_MEDAL_ID: int = 9003017

# جدول مستويات إنجاز توحيد القوة (Achievement ID -> Permille / بالآلاف)
ACHIEVEMENT_MARCH_TIERS: Dict[int, int] = {
    5317002: 10,  # المستوى 2: 10 بالآلاف (+1%)
    5317003: 10,  # المستوى 3: 10 بالآلاف (+1%)
    5317004: 20,  # المستوى 4: 20 بالآلاف (+2%)
    5317005: 30,  # المستوى 5: 30 بالآلاف (+3%)
    5317006: 40,  # المستوى 6: 40 بالآلاف (+4%)
    5317007: 50,  # المستوى 7: 50 بالآلاف (+5%)
    5317008: 60,  # المستوى 8: 60 بالآلاف (+6%)
    5317009: 70,  # المستوى 9: 70 بالآلاف (+7%)
    5317010: 80,  # المستوى 10: 80 بالآلاف (+8%)
    5317011: 90,  # المستوى 11: 90 بالآلاف (+9%)
    5317012: 100, # المستوى 12: 100 بالآلاف (+10%)
    5317013: 110, # المستوى 13: 110 بالآلاف (+11%)
    5317014: 120, # المستوى 14: 120 بالآلاف (+12%)
    5317015: 140, # المستوى 15: 140 بالآلاف (+14%)
}

# عتبات قتل الأعداء الرسمية لاشتقاق مستوى إنجاز الحشد (توحيد القوة - Medal 9003017)
# مأخوذة بدقة 100% من achievement_info.lua (Achievement Type 17)
ACHIEVEMENT_KILL_THRESHOLDS: List[Tuple[int, int]] = [
    (200000000, 140), # المستوى 15: 200M قتلى -> +14%
    (100000000, 120), # المستوى 14: 100M قتلى -> +12%
    (50000000, 110),  # المستوى 13: 50M قتلى -> +11%
    (30000000, 100),  # المستوى 12: 30M قتلى -> +10%
    (10000000, 90),   # المستوى 11: 10M قتلى -> +9%
    (7000000, 80),    # المستوى 10: 7M قتلى -> +8%
    (5000000, 70),    # المستوى 9: 5M قتلى -> +7%
    (3000000, 60),    # المستوى 8: 3M قتلى -> +6%
    (1000000, 50),    # المستوى 7: 1M قتلى -> +5%
    (500000, 40),     # المستوى 6: 500k قتلى -> +4%
    (300000, 30),     # المستوى 5: 300k قتلى -> +3%
    (100000, 20),     # المستوى 4: 100k قتلى -> +2%
    (50000, 10),      # المستوى 3: 50k قتلى -> +1%
]

# ── بافات ميزة كبار الشخصيات الرسمية لسعة المسيرة (VIP / SVIP March Limit Buff) ──
# مأخوذة بدقة 100% من جدول vipbuff.lua وسورس كود اللعبة (Privilege 7219 - "زيادة الحد الأقصى لعدد جنود المسيرة لفيلق واحد")
# القيمة مقاسة بالألف (Permille / value / 10 = %)
VIP_MARCH_LIMIT_TABLE: Dict[int, int] = {
    14: 100,  # VIP 14: +10.0% (100 بالألف)
    15: 150,  # VIP 15 (SVIP 1): +15.0% (150 بالألف)
    16: 150,  # VIP 16 (SVIP 2): +15.0% (150 بالألف)
    17: 150,  # VIP 17 (SVIP 3): +15.0% (150 بالألف)
    18: 150,  # VIP 18 (SVIP 4): +15.0% (150 بالألف)
    19: 150,  # VIP 19 (SVIP 5): +15.0% (150 بالألف)
    20: 200,  # VIP 20 (SVIP 6): +20.0% (200 بالألف)
    21: 200,  # VIP 21 (SVIP 7): +20.0% (200 بالألف)
    22: 200,  # VIP 22 (SVIP 8): +20.0% (200 بالألف)
    23: 200,  # VIP 23 (SVIP 9): +20.0% (200 بالألف)
    24: 200,  # VIP 24 (SVIP 10): +20.0% (200 بالألف)
    25: 250,  # VIP 25 (SVIP 11): +25.0% (250 بالألف)
    26: 250,  # VIP 26 (SVIP 12): +25.0% (250 بالألف)
    27: 250,  # VIP 27 (SVIP 13): +25.0% (250 بالألف)
}

# ── بافات امتلاك مظاهر وأزياء الأبطال السلبية لسعة المسيرة (Hero Dress Passive March Buffs) ──
# مأخوذة بدقة 100% من سورس كود اللعبة (hero_dress_server.lua و heroltCtrl:getOwnBuff)
# تضيف جنوداً إضافيين (Flat Troops) بمجرد امتلاك المظهر حتى لو لم يخرج البطل في المسيرة.
# Effect Type = 96 (gBuffEffect.MARCH_VALUE_LIMIT_BOOST)
HERO_DRESS_MARCH_FLAT_BUFFS: Dict[int, int] = {
    171602: 2000,  # بطل 1716 - مظهر 2
    171902: 1500,  # بطل 1719 - مظهر 2
    172302: 1500,  # بطل 1723 - مظهر 2
    173402: 1500,  # بطل 1734 - مظهر 2
    173602: 1500,  # بطل 1736 - مظهر 2
    173802: 2000,  # بطل 1738 - مظهر 2
    173902: 2000,  # بطل 1739 - مظهر 2
    174002: 2000,  # بطل 1740 - مظهر 2
    174102: 2000,  # بطل 1741 - مظهر 2
    174202: 2000,  # بطل 1742 - مظهر 2
    174302: 2000,  # بطل 1743 - مظهر 2
    174402: 2000,  # بطل 1744 - مظهر 2
    174502: 2000,  # بطل 1745 - مظهر 2
    174602: 2000,  # بطل 1746 - مظهر 2
    174702: 2500,  # بطل 1747 - مظهر 2
    174802: 2500,  # بطل 1748 - مظهر 2
    174902: 2500,  # بطل 1749 - مظهر 2
    175002: 2500,  # بطل 1750 - مظهر 2
    175102: 2000,  # بطل 1751 - مظهر 2
    175202: 2500,  # بطل 1752 - مظهر 2
    175302: 2500,  # بطل 1753 - مظهر 2
    175402: 2500,  # بطل 1754 - مظهر 2
    175502: 2500,  # بطل 1755 - مظهر 2
    175602: 2500,  # بطل 1756 - مظهر 2
    175702: 2500,  # بطل 1757 - مظهر 2
}

# ── جداول المصادر الدائمة الإضافية لـ buffCtrl (Effect 96) و attributeSystem (Attr 5) ──
# مستخرجة بدقة 100% من سورس اللعبة الرسمي (march_capacity_extra_sources.json)
WAR_GEM_MARCH_BOOST: Dict[int, int] = {
    12060101: 500, 12060102: 750, 12060103: 1250, 12060104: 1750, 12060105: 2500,
    12060106: 3750, 12060107: 5000, 12060108: 6750, 12060109: 8750, 12060110: 12500,
}

HERO_BIOGRAPHY_MARCH_BOOST: Dict[int, int] = {
    30102: 500, 30202: 1200,
    50102: 500, 50202: 1200,
    80102: 500, 80202: 1200,
}

HERO_MASTERY_MARCH_BOOST: Dict[int, int] = {
    17190701: 1200, 17190702: 1350, 17190703: 1575, 17190704: 1950, 17190705: 2475,
    17190706: 3150, 17190707: 3975, 17190708: 4875, 17190709: 5850, 17190710: 7200,
}

DIVINE_BEAST_DISPATCH_SKILL_BOOST: Dict[int, int] = {
    100201: 4000, 100202: 8000, 100203: 14000, 100204: 20000,
}

CASTLE_DRESS_MARCH_BOOST: Dict[int, int] = {
    344: 1000,  # King March Queue Skin
    375: 5000,  # King Star Battle Headframe
    388: 1500,  # Special Castle Skin 388
    422: 1500,  # Special Castle Skin 422
    550: 1500,  # Special Castle Skin 550
    551: 1500,  # Special Castle Skin 551
    553: 1000,  # Special March Skin 553
}

MIRACULOUS_WEAPON_RESONANCE_7_POWER = 2615000
MIRACULOUS_WEAPON_RESONANCE_7_BOOST = 24000

_MARCH_DATA_CACHE: Optional[Dict[str, Any]] = None

def _load_march_data_tables() -> Dict[str, Any]:
    """تحميل جداول سعة المسيرة الشاملة والمطابقة لسورس اللعبة مع تخزينها بالذاكرة."""
    global _MARCH_DATA_CACHE
    if _MARCH_DATA_CACHE is not None:
        return _MARCH_DATA_CACHE

    base_dir = os.path.dirname(os.path.abspath(__file__))
    possible_paths = [
        os.path.join(base_dir, "..", "tools", "march_data_tables.json"),
        os.path.join(base_dir, "march_data_tables.json"),
        os.path.join("tools", "march_data_tables.json"),
    ]
    for p in possible_paths:
        if os.path.exists(p):
            try:
                with open(p, "r", encoding="utf-8") as f:
                    _MARCH_DATA_CACHE = json.load(f)
                    return _MARCH_DATA_CACHE
            except Exception:
                pass

    _MARCH_DATA_CACHE = {
        "drill_levels": {str(k): v for k, v in DRILL_GROUNDS_CAPACITY.items()},
        "drill_stars": {str(k): v for k, v in DRILL_GROUNDS_STAR_CAPACITY.items()},
        "heroes": {str(k): {"rarity": v.get("rarity", 1), "name": v.get("name")} for k, v in OFFICIAL_HERO_CATALOG.items()},
        "rare_levels": {str(r): {str(lv): v for lv, v in lvs.items()} for r, lvs in HERO_RARE_LEVEL_MARCH_ADD.items()},
        "hero_battle_march_skills": {str(k): v for k, v in HERO_MARCH_SKILLS_VAL.items()},
        "achievement_march_tiers": {str(k): v for k, v in ACHIEVEMENT_MARCH_TIERS.items()},
        "kill_thresholds": list(ACHIEVEMENT_KILL_THRESHOLDS),
        "techs": {},
    }
    return _MARCH_DATA_CACHE


# ═════════════════════════════════════════════════════════════════════════
# ثوابت وجداول حساب سعة نقل مساعدة الموارد والضرائب بالسوق (Market Resource Transport)
# مطابقة تامة وتفصيلية لسورس كود اللعبة:
#   - buildLogic.lua:2024-2055 (buildLogic.getMarketWeight & buildLogic.getMarketRate)
#   - build112.lua (Market Lv.1 - Lv.30 Base Capacities & Tax Rates)
#   - alliance_science_lv.lua (Science ID 33002: TRADING_WEIGHT - sciType 18)
#   - marketViewPanel.lua:39-48 & marketResSingle.lua:67 (Resource Weights & Unlock Levels)
# ═════════════════════════════════════════════════════════════════════════

MARKET_BUILDING_ID = 112  # BUILDID.MARKET في buildDef.lua

# سعة السوق الأساسية لكل مستوى (Market Lv.1 - Lv.30) من build112.lua (حقل capacity)
MARKET_BASE_CAPACITY: Dict[int, int] = {
    1: 20000, 2: 40000, 3: 60000, 4: 80000, 5: 100000,
    6: 120000, 7: 140000, 8: 160000, 9: 180000, 10: 200000,
    11: 220000, 12: 240000, 13: 270000, 14: 290000, 15: 320000,
    16: 340000, 17: 370000, 18: 390000, 19: 420000, 20: 440000,
    21: 470000, 22: 490000, 23: 520000, 24: 540000, 25: 570000,
    26: 590000, 27: 620000, 28: 640000, 29: 670000, 30: 690000,
}

# نسبة الضريبة الأساسية بالسوق لكل مستوى مقسومة على 1000 (taxRate / 1000) من build112.lua
# Lv.1 = 450 (45%) -> Lv.30 = 100 (10%)
MARKET_BASE_TAX_RATE: Dict[int, float] = {
    1: 0.45, 2: 0.44, 3: 0.43, 4: 0.42, 5: 0.41,
    6: 0.40, 7: 0.39, 8: 0.38, 9: 0.37, 10: 0.36,
    11: 0.35, 12: 0.34, 13: 0.33, 14: 0.32, 15: 0.31,
    16: 0.30, 17: 0.29, 18: 0.28, 19: 0.27, 20: 0.26,
    21: 0.25, 22: 0.24, 23: 0.23, 24: 0.22, 25: 0.21,
    26: 0.19, 27: 0.17, 28: 0.15, 29: 0.13, 30: 0.10,
}

# أوزان الموارد ومستويات فك القفل طبقاً لسورس كود العميل (marketViewPanel.lua:39-48)
# المعادلة الرسمية: resCount * perWeight <= market_overWeight
MARKET_RESOURCE_WEIGHTS: Dict[int, Dict[str, Any]] = {
    1002: {
        "res_id": 1002,
        "key": "food",
        "name_ar": "طعام",
        "name_en": "Food",
        "weight": 1,
        "unlock_level": 1,
    },
    1003: {
        "res_id": 1003,
        "key": "wood",
        "name_ar": "خشب",
        "name_en": "Wood",
        "weight": 1,
        "unlock_level": 1,
    },
    1004: {
        "res_id": 1004,
        "key": "iron",
        "name_ar": "حديد",
        "name_en": "Iron",
        "weight": 6,
        "unlock_level": 10,
    },
    1005: {
        "res_id": 1005,
        "key": "mithril",
        "name_ar": "فضة",
        "name_en": "Mithril",
        "weight": 24,
        "unlock_level": 15,
    },
    1006: {
        "res_id": 1006,
        "key": "crystal",
        "name_ar": "بلور",
        "name_en": "Crystal",
        "weight": 96,
        "unlock_level": 30,
    },
}

# تطبيع أسماء ومعرفات الموارد (Resource Aliases Mapping)
MARKET_RESOURCE_ALIASES: Dict[Union[str, int], int] = {
    1002: 1002, "1002": 1002, "food": 1002, "wheat": 1002, "grain": 1002, "طعام": 1002, "قمح": 1002, 1: 1002, "1": 1002,
    1003: 1003, "1003": 1003, "wood": 1003, "timber": 1003, "خشب": 1003, 2: 1003, "2": 1003,
    1004: 1004, "1004": 1004, "iron": 1004, "حديد": 1004, 3: 1004, "3": 1004,
    1005: 1005, "1005": 1005, "mithril": 1005, "silver": 1005, "فضة": 1005, "ميثريل": 1005, 4: 1005, "4": 1005,
    1006: 1006, "1006": 1006, "crystal": 1006, "بلور": 1006, "كريستال": 1006, 5: 1006, "5": 1006,
}

# معرف ومكافآت علوم التحالف لزيادة حمولة التبادل (Alliance Science 33002: TRADING_WEIGHT)
# من alliance_science_lv.lua (sciType = 18)
ALLIANCE_SCIENCE_TRADING_WEIGHT_ID = 33002
ALLIANCE_SCIENCE_TRADING_WEIGHT_BONUS: Dict[int, float] = {
    0: 0.00,
    1: 0.01,
    2: 0.02,
    3: 0.03,
    4: 0.04,
    5: 0.05,
    6: 0.06,
    7: 0.07,
    8: 0.08,
    9: 0.09,
    10: 0.10,
}


class BaseTask(ABC):
    """
    الكلاس الأساسي التجريدي لجميع مهام البوت ومستودع دوال منطق اللعبة الأصلي (Revenge of Sultans Base Task).

    ══════════════════════════════════════════════════════════════════════════════
    القواعد الصارمة لبناء وتطوير الدوال في هذا الملف (BaseTask Function Rules):
    ══════════════════════════════════════════════════════════════════════════════
    1. الاعتماد الأساسي والأولي على الذاكرة الحية (Live Memory First):
       - يجب أن تعتمد كل دالة بشكل رئيسي وأولي على كائنات الذاكرة الحية (conn.init_data / get_ctrl).
       - قراءة الذاكرة فورية ومحلية بدون استهلاك للشبكة (0-Network Direct Read).

    2. الاستعلام الاحتياطي المشروط والتنبيه الصارخ (Fallback Query & Alert Emojis):
       - إذا كانت المعلومة موجودة بشكل مؤكد في الذاكرة الحية: يُمنع كتابة استعلام احتياطي عبر الشبكة.
       - إذا لم تكن المعلومة متوفرة في الذاكرة الحية أو محتمل فقدانها: يُكتب استعلام شبكي احتياطي
         (safe_query)، بشرط إلزامي: وضع طباعة تحذيرية قبل الطلب بإيموجيات تنبيهية صارخة:
         self.log("🚨⚠️🚨 [BaseTask: <function_name>] Data missing from live memory! Falling back to network query...")

    3. التسكين الوظيفي الصارم في أقسام الملف (Strict Section Categorization):
       - يجب وضع كل دالة حصراً في القسم المخصص لوظيفتها بين الفواصل الرسمية للملف، ويُمنع التسكين العشوائي.

    4. البساطة والوضوح والكفاءة (KISS & Pure Functionality):
       - يجب أن تكون الدالة بسيطة ومفهومة وخالية من أي تعقيد وتؤدي الغرض بدقة مطابقة لسورس كود اللعبة.
    ══════════════════════════════════════════════════════════════════════════════
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
            if "level" in city and city["level"]:
                return int(city["level"])
            blist = city.get("blist", [])
            if isinstance(blist, list):
                for b in blist:
                    binfo = b.get("binfo", b) if isinstance(b, dict) else {}
                    if isinstance(binfo, dict) and str(binfo.get("bid")) in ("101", "100", "4000"):
                        return int(binfo.get("lv", 1))
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
            elif isinstance(vip_obj, (list, tuple)) and len(vip_obj) >= 1:
                try:
                    return int(vip_obj[0] or 0)
                except (ValueError, TypeError):
                    pass
        return 0

    @property
    def vip_end_time(self) -> float:
        """
        الوقت الدقيق لانتهاء الـ VIP (Unix timestamp بالثواني) من مراجع الذاكرة الحية (0-Network).
        يقرأ من lordInfoCtrl.vip أولاً، ثم طابور 1219 في queueCtrl، ثم vipCtrl كبديل.
        """
        end_times: List[float] = []

        # 1. lordInfoCtrl.vip.vipEndTime
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            vip_obj = lord.get("vip", {})
            if isinstance(vip_obj, dict):
                raw_end = vip_obj.get("vipEndTime")
                v = self._safe_float(raw_end)
                if v > 1e11:  # معالجة الميلي ثانية إن وُجدت
                    v /= 1000.0
                if v > 0:
                    end_times.append(v)
            elif isinstance(vip_obj, (list, tuple)) and len(vip_obj) >= 2:
                # إذا كانت الخلية الثانية رقماً تمثل وقت انتهاء
                if isinstance(vip_obj[1], (int, float)) and not isinstance(vip_obj[1], bool):
                    v = self._safe_float(vip_obj[1])
                    if v > 1e11:
                        v /= 1000.0
                    if v > 0:
                        end_times.append(v)

        # 2. queueCtrl (طابور 1219 - gQueueTypeDef.vip_time)
        queue_ctrl = self.get_ctrl("queueCtrl")
        raw_queues: List[Dict[str, Any]] = []
        if isinstance(queue_ctrl, dict):
            for qk, qv in queue_ctrl.items():
                if isinstance(qv, dict):
                    q_item = dict(qv)
                    if "qtype" not in q_item:
                        q_item["qtype"] = qk
                    raw_queues.append(q_item)
                elif isinstance(qv, list) and qk in ("queues", "list"):
                    raw_queues.extend([q for q in qv if isinstance(q, dict)])
        elif isinstance(queue_ctrl, list):
            raw_queues.extend([q for q in queue_ctrl if isinstance(q, dict)])

        for q in raw_queues:
            qtype = str(q.get("qtype") or q.get("queueType") or q.get("type") or "")
            if qtype == "1219":
                ot = self._safe_float(q.get("ottime") or q.get("finishTime") or q.get("endTime"))
                tot = self._safe_float(q.get("totaltime") or q.get("time"))
                st = self._safe_float(q.get("starttime") or q.get("beginTime"))
                if ot == 0 and tot > 0 and st > 0:
                    ot = st + tot
                if ot > 1e11:
                    ot /= 1000.0
                if ot > 0:
                    end_times.append(ot)

        # 3. vipCtrl كبديل احتياطي
        vip_ctrl = self.get_ctrl("vipCtrl")
        if isinstance(vip_ctrl, dict):
            raw_end = vip_ctrl.get("vipEndTime", vip_ctrl.get("endTime"))
            v = self._safe_float(raw_end)
            if v > 1e11:
                v /= 1000.0
            if v > 0:
                end_times.append(v)

        return max(end_times) if end_times else 0.0

    @property
    def is_vip_active(self) -> bool:
        """
        التحقق الصارم من سريان مفعول الـ VIP للقلعة حالياً من الذاكرة الحية (0-Network).
        مطابق للعبة الرسمية (serviceFunctions.lua / VIP_LEVEL_AND_ACTIVE):
        تعتبر ميزة VIP نشطة فقط إذا كان مستوى VIP أكبر من 0 ووقت الانتهاء أكبر من الوقت الحالي.
        """
        if self.vip_level <= 0:
            return False

        # إذا كان lordInfoCtrl.vip بصيغة دالة getVip() الرسمية [level, isActive]
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict):
            vip_obj = lord.get("vip", {})
            if isinstance(vip_obj, (list, tuple)) and len(vip_obj) >= 2:
                if isinstance(vip_obj[1], bool) and not vip_obj[1]:
                    # التأكد من عدم وجود طابور 1219 نشط قبل الجزم بعدم التفعيل
                    return self.vip_end_time > time.time()

        return self.vip_end_time > time.time()

    @property
    def vip_remaining_seconds(self) -> int:
        """الثواني المتبقية حتى انتهاء باف الـ VIP، أو 0 إذا كان منتهياً أو غير مفعل."""
        if not self.is_vip_active:
            return 0
        rem = self.vip_end_time - time.time()
        return max(0, int(rem))

    def get_vip_info(self) -> Dict[str, Any]:
        """
        استخراج معلومات VIP الكاملة والدقيقة من مراجع الذاكرة الحية (0-Network Pre-flight):
        يطابق تماماً منطق العميل الرسمي في lordInfoCtrl:getVip() و serviceFunctions.checkCondtion.
        """
        return {
            "level": self.vip_level,
            "is_active": self.is_vip_active,
            "end_time": self.vip_end_time,
            "remaining_seconds": self.vip_remaining_seconds,
        }

    def can_switch_lord_skill_set(self, set_id: Any) -> Tuple[bool, str]:
        """
        التحقق الصارم من إمكانية التبديل إلى طقم مواهب محدد وفق القواعد الرسمية للعبة (0-Network Pre-flight):
        - التحقق من وجود وصلاحية الطقم في lordSkillCtrl بالذاكرة الحية.
        - الطقم 1: متاح دائماً لكافة القلاع بدون أي شروط.
        - الطقم 2: يتطلب مستوى VIP 9 على الأقل + سريان باف VIP حالياً (VIP_LEVEL_AND_ACTIVE).
        - الطقم 3: يتطلب مستوى VIP 13 على الأقل + سريان باف VIP حالياً (VIP_LEVEL_AND_ACTIVE).
        - الأطقم 4، 5، 6: تتطلب تفعيل امتيازات كبار الشخصيات الحصرية (Exalted Privilege).
        
        :param set_id: رقم الطقم المستهدف (مثل 1، 2، 3...).
        :return: (متاح/ممنوع، رسالة توضيحية دقيقة).
        """
        target_set = str(set_id).strip() if set_id is not None else ""
        if not target_set:
            return False, "رقم طقم المواهب غير محدد."

        if target_set not in ("1", "2", "3", "4", "5", "6"):
            return False, f"طقم مواهب غير معروف أو غير مدعوم باللعبة: {target_set}"

        # 0-Network: التحقق من وجود الطقم في lordSkillCtrl بالذاكرة الحية إن وُجدت بيانات الأطقم
        lord_skills = self.get_ctrl("lordSkillCtrl")
        if isinstance(lord_skills, dict):
            set_list_data = (
                lord_skills.get("setListData")
                or lord_skills.get("sets")
                or lord_skills.get("skillSets")
                or lord_skills.get("setList")
            )
            if isinstance(set_list_data, dict) and set_list_data:
                valid_ids = {str(k) for k in set_list_data.keys()}
                if target_set not in valid_ids:
                    return False, f"طقم المواهب {target_set} غير مسجل في بيانات القلعة (lordSkillCtrl)."
            elif isinstance(set_list_data, list) and set_list_data:
                valid_ids = {
                    str(item.get("setID") or item.get("id") or "")
                    for item in set_list_data
                    if isinstance(item, dict)
                }
                if valid_ids and target_set not in valid_ids:
                    return False, f"طقم المواهب {target_set} غير مسجل في بيانات القلعة (lordSkillCtrl)."

        if target_set == "1":
            return True, "طقم المواهب 1 متاح دائماً بدون شروط."

        v_lv = self.vip_level
        is_active = self.is_vip_active
        rem_sec = self.vip_remaining_seconds

        if target_set == "2":
            if v_lv < 9:
                return False, f"يتطلب طقم المواهب 2 مستوى VIP 9 على الأقل (المستوى الحالي: VIP {v_lv})."
            if not is_active:
                return False, f"يتطلب طقم المواهب 2 تفعيل VIP نشط (المستوى الحالي: VIP {v_lv} ولكنه منتهي الصلاحية)."
            rem_h = round(rem_sec / 3600, 1)
            return True, f"طقم المواهب 2 متاح (VIP {v_lv} نشط ومتبقي {rem_h} ساعة)."

        if target_set == "3":
            if v_lv < 13:
                return False, f"يتطلب طقم المواهب 3 مستوى VIP 13 على الأقل (المستوى الحالي: VIP {v_lv})."
            if not is_active:
                return False, f"يتطلب طقم المواهب 3 تفعيل VIP نشط (المستوى الحالي: VIP {v_lv} ولكنه منتهي الصلاحية)."
            rem_h = round(rem_sec / 3600, 1)
            return True, f"طقم المواهب 3 متاح (VIP {v_lv} نشط ومتبقي {rem_h} ساعة)."

        if target_set in ("4", "5", "6"):
            req_rank = int(target_set) - 3
            exalted_ctrl = self.get_ctrl("exaltedPrivilegeCtrl")
            if isinstance(exalted_ctrl, dict):
                privs = exalted_ctrl.get("privileges", {}) or exalted_ctrl.get("privilegeList", {})
                priv_10_val = 0
                if isinstance(privs, dict):
                    priv_10_val = self._safe_int(privs.get("10", privs.get(10, 0)))
                elif isinstance(privs, list):
                    for p in privs:
                        if isinstance(p, dict) and str(p.get("id") or p.get("type")) == "10":
                            priv_10_val = self._safe_int(p.get("value", p.get("level", 0)))
                            break
                if priv_10_val >= req_rank:
                    return True, f"طقم المواهب {target_set} متاح عبر امتيازات VIP الحصرية (مستوى {priv_10_val})."
            return False, f"يتطلب طقم المواهب {target_set} امتيازات كبار الشخصيات الحصرية (Exalted Privilege {req_rank})."

        return False, f"طقم مواهب غير معروف أو غير مدعوم باللعبة: {target_set}"

    # اسم بديل متوافق لفك القفل
    is_lord_skill_set_unlocked = can_switch_lord_skill_set

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

        active_set_id = str(lord_skills.get("activeSetID") or lord_skills.get("curSet") or lord_skills.get("currentSetID") or "1")
        set_list_data = (
            lord_skills.get("setListData")
            or lord_skills.get("sets")
            or lord_skills.get("skillSets")
            or lord_skills.get("setList")
            or {}
        )
        if isinstance(set_list_data, list):
            normalized_sets: Dict[str, Any] = {}
            for item in set_list_data:
                if isinstance(item, dict):
                    sid_k = str(item.get("setID") or item.get("id") or len(normalized_sets) + 1)
                    normalized_sets[sid_k] = item
            set_list_data = normalized_sets
        elif not isinstance(set_list_data, dict):
            set_list_data = {}

        cd_data = lord_skills.get("CDData") or lord_skills.get("cdData") or {}
        if not isinstance(cd_data, dict):
            cd_data = {}

        point_total = int(lord_skills.get("pointTotal") or lord_skills.get("point_total") or 0)
        now_ts = int(time.time())

        # 2. فحص الأطقم التي تحتوي على المهارة ومستواها
        str_id = str(resolved_id)
        sets_found: List[Dict[str, Any]] = []
        skill_level_in_active_set = 0
        max_level_found = 0

        # فحص بديل احتياطي إذا كان set_list_data فارغاً (lordInfoCtrl.skill.skillBasic)
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

                # دعم هياكل القوائم المتعددة (list, skills, skillList)
                s_list = s_info.get("list") or s_info.get("skills") or s_info.get("skillList") or {}
                # إذا كان الطقم مصفراً بالكامل ولا يحتوي على نقاط مستخدمة، فهو فارغ
                used_points = int(s_info.get("usedPoint") or s_info.get("usedPoints") or 0)
                has_explicit_used = ("usedPoint" in s_info or "usedPoints" in s_info)
                if has_explicit_used and used_points <= 0:
                    continue
                if not s_list and used_points <= 0:
                    continue
                if isinstance(s_list, list):
                    norm_slist: Dict[str, Any] = {}
                    for el in s_list:
                        if isinstance(el, dict):
                            el_id = str(el.get("skillID") or el.get("id") or "")
                            el_lv = el.get("level") or el.get("skillCurLv") or el.get("lv") or 1
                            if el_id:
                                norm_slist[el_id] = el_lv
                        elif isinstance(el, (list, tuple)) and len(el) >= 2:
                            norm_slist[str(el[0])] = el[1]
                    s_list = norm_slist
                elif not isinstance(s_list, dict):
                    continue

                # استخراج مستوى المهارة
                lvl = 0
                val = s_list.get(str_id)
                if val is None and resolved_id in s_list:
                    val = s_list.get(resolved_id)
                if val is None:
                    # فحص المعرف السباعي المطابق كبادئة (مثل 1200801)
                    for k_entry, v_entry in s_list.items():
                        k_str = str(k_entry)
                        if k_str == str_id or (len(k_str) >= 7 and k_str[:5] == str_id):
                            val = v_entry
                            break

                if val is not None:
                    if isinstance(val, (int, float)):
                        lvl = int(val)
                    elif isinstance(val, str):
                        try:
                            lvl = int(val.strip() or 0)
                        except (ValueError, TypeError):
                            lvl = 0
                    elif isinstance(val, (list, tuple)) and len(val) > 1:
                        lvl = int(val[1] or 0)
                    elif isinstance(val, (list, tuple)) and len(val) == 1:
                        lvl = int(val[0] or 0)
                    elif isinstance(val, dict):
                        lvl = int(val.get("level") or val.get("skillCurLv") or val.get("lv") or 0)

                # شرط صارم: المهارة تعتبر مرشحة فقط إذا كانت متعلمة فعلياً بنقاط > 0 في هذا الطقم
                if lvl > 0:
                    is_curr = (s_id == active_set_id)
                    if is_curr:
                        skill_level_in_active_set = lvl
                    if lvl > max_level_found:
                        max_level_found = lvl

                    is_set_unlocked, lock_reason = self.can_switch_lord_skill_set(s_id)
                    sets_found.append({
                        "set_id": s_id,
                        "level": lvl,
                        "title": s_info.get("title", ""),
                        "is_active_set": is_curr,
                        "is_unlocked": is_set_unlocked,
                        "locked_reason": "" if is_set_unlocked else lock_reason,
                        "used_points": used_points,
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
                    "is_unlocked": True,
                    "locked_reason": "",
                    "used_points": lvl,
                    "power": 0,
                })

        # ترتيب الأطقم: الطقم النشط أولاً، ثم حسب رقم الطقم
        sets_found.sort(key=lambda s: (0 if s["is_active_set"] else 1, s["set_id"]))

        # الأطقم المفتوحة والمؤهلة بنقاط فعلية
        unlocked_candidate_sets = [
            sf for sf in sets_found
            if sf.get("is_unlocked", False) and sf.get("level", 0) > 0
        ]

        is_in_active_set = (skill_level_in_active_set > 0)
        is_learned = (len(sets_found) > 0)
        is_available = is_in_active_set or bool(unlocked_candidate_sets)

        # 3. فحص حالة التبريد (CDData)
        in_cd = False
        cd_remain = 0
        cd_entry = cd_data.get(str_id) or cd_data.get(resolved_id)
        if cd_entry:
            cd_begin_time = 0
            cd_duration = 0
            if isinstance(cd_entry, dict):
                cd_begin_time = self._safe_int(cd_entry.get("beginTime"))
                cd_duration = self._safe_int(cd_entry.get("CD"))
            elif isinstance(cd_entry, (list, tuple)) and len(cd_entry) >= 2:
                cd_begin_time = self._safe_int(cd_entry[0])
                cd_duration = self._safe_int(cd_entry[1])

            if cd_duration > 0 and cd_begin_time > 0:
                elapsed = now_ts - cd_begin_time
                if elapsed < cd_duration:
                    in_cd = True
                    cd_remain = max(0, cd_duration - elapsed)

        # 4. فحص سريان مفعول المهارة حالياً (Active Buff / Queue)
        is_buff_active = False
        buff_remaining = 0
        is_untimed_buff = False

        # أ. فحص بافات القلعة (buffCtrl و newBuffCtrl) المحدثة بالذاكرة الحية (0-Network)
        if target_buff_id is not None:
            str_bid = str(target_buff_id)
            raw_buffs: List[Dict[str, Any]] = []
            for ctrl_name in ("buffCtrl", "newBuffCtrl"):
                ctrl_val = self.get_ctrl(ctrl_name)
                if isinstance(ctrl_val, list):
                    raw_buffs.extend([b for b in ctrl_val if isinstance(b, dict)])
                elif isinstance(ctrl_val, dict):
                    if "buffList" in ctrl_val and isinstance(ctrl_val["buffList"], list):
                        raw_buffs.extend([b for b in ctrl_val["buffList"] if isinstance(b, dict)])
                    for bk, bv in ctrl_val.items():
                        if isinstance(bv, dict) and bk != "buffList":
                            raw_buffs.append(bv)
                        elif isinstance(bv, list) and bk == "list":
                            raw_buffs.extend([b for b in bv if isinstance(b, dict)])

            for b in raw_buffs:
                b_id = str(b.get("id") or b.get("buffId") or b.get("buffID") or "")
                # فحص تطابق رقم الباف المستهدف
                if b_id == str_bid:
                    begin_t = self._safe_int(b.get("beginTime") or b.get("startTime") or b.get("createtime"))
                    dur = self._safe_int(b.get("time") or b.get("duration") or b.get("totaltime"))
                    end_t = self._safe_int(b.get("endTime") or b.get("finishTime") or b.get("ottime"))

                    # البافات دائمة المفعول أو التي تنتهي بحدث مثل خوض معركة (time=0 مثل مهارة الإنقاذ 4501، التسلل 5130، الاستحواذ 5425)
                    if dur == 0 and end_t == 0:
                        is_buff_active = True
                        is_untimed_buff = True
                        buff_remaining = 0
                        break

                    # البافات محددة المدة بوقت انتهاء صريح (Unix Timestamp)
                    if end_t > 0:
                        if end_t > now_ts:
                            is_buff_active = True
                            buff_remaining = max(buff_remaining, end_t - now_ts)
                            break
                    # البافات محددة المدة عبر زمن البدء والمدة بالثواني
                    elif dur > 0 and begin_t > 0:
                        calc_end = begin_t + dur
                        if calc_end > now_ts:
                            is_buff_active = True
                            buff_remaining = max(buff_remaining, calc_end - now_ts)
                            break

        # ب. فحص طوابير المهارات النشطة (queueCtrl)
        if not is_buff_active and target_queue_type is not None:
            str_qtype = str(target_queue_type)
            raw_queues: List[Dict[str, Any]] = []
            queue_ctrl = self.get_ctrl("queueCtrl")
            if isinstance(queue_ctrl, dict):
                for qk, qv in queue_ctrl.items():
                    if isinstance(qv, dict):
                        q_item = dict(qv)
                        if "qtype" not in q_item:
                            q_item["qtype"] = qk
                        raw_queues.append(q_item)
                    elif isinstance(qv, list) and qk in ("queues", "list"):
                        raw_queues.extend([q for q in qv if isinstance(q, dict)])
            elif isinstance(queue_ctrl, list):
                raw_queues.extend([q for q in queue_ctrl if isinstance(q, dict)])

            for q in raw_queues:
                qtype = str(q.get("qtype") or q.get("queueType") or q.get("type") or q.get("queuetype") or q.get("id") or "")
                if qtype == str_qtype:
                    st = self._safe_int(q.get("starttime") or q.get("beginTime"))
                    tot = self._safe_int(q.get("totaltime") or q.get("time"))
                    ot = self._safe_int(q.get("ottime") or q.get("finishTime") or q.get("endTime"))

                    if ot == 0 and tot > 0 and st > 0:
                        ot = st + tot

                    if ot > now_ts:
                        is_buff_active = True
                        buff_remaining = max(buff_remaining, ot - now_ts)
                        break
                    elif ot == 0:
                        # طابور دائم أو سارٍ حتى حدوث واقعة (مثل طابور 1214 لمهارة الإنقاذ)
                        is_buff_active = True
                        is_untimed_buff = True
                        buff_remaining = 0
                        break

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

        # 6. إمكانية التبديل لطقم يحتوي على المهارة (0-Network Can Switch To Set)
        can_switch_to_set = False
        target_switch_set_id: Optional[str] = None
        switch_blocked_reason: str = ""

        if not is_in_active_set and unlocked_candidate_sets:
            # فلترة الأطقم المفتوحة وغير النشطة حالياً
            switchable_sets = [sf for sf in unlocked_candidate_sets if not sf["is_active_set"]]
            if switchable_sets:
                # اختيار الطقم ذو المستوى الأعلى للمهارة أولاً ثم رقم الطقم
                switchable_sets.sort(key=lambda sf: (-sf["level"], sf["set_id"]))
                chosen_candidate = switchable_sets[0]["set_id"]
                # لا يتم التبديل إذا كانت المهارة في فترة تبريد أو تأثيرها سارٍ حالياً
                if not in_cd and not is_buff_active:
                    can_switch_to_set = True
                    target_switch_set_id = chosen_candidate
        elif not is_in_active_set and sets_found:
            for sf in sets_found:
                if not sf.get("is_unlocked") and sf.get("locked_reason"):
                    switch_blocked_reason = sf["locked_reason"]
                    break

        return {
            "success": True,
            "skill_id": resolved_id,
            "skill_name": skill_name_ar,
            "skill_name_en": skill_name_en,
            "skill_type": skill_type,
            "is_active_skill": is_cataloged_active,
            "is_available": is_available,
            "is_learned": is_learned,
            "is_learned_in_any_set": (len(sets_found) > 0),
            "is_in_active_set": is_in_active_set,
            "active_set_id": active_set_id,
            "current_level": skill_level_in_active_set,
            "max_level_learned": max_level_found,
            "sets_found": sets_found,
            "sets_count": len(sets_found),
            "unlocked_sets_count": len(unlocked_candidate_sets),
            "is_active": is_active_now,
            "is_buff_active": is_buff_active,
            "is_untimed_buff": is_untimed_buff,
            "buff_remaining_seconds": buff_remaining,
            "in_cooldown": in_cd,
            "cd_remaining_seconds": cd_remain,
            "base_cd_seconds": base_cd,
            "can_activate": can_activate,
            "can_switch_to_set": can_switch_to_set,
            "target_switch_set_id": target_switch_set_id,
            "switch_blocked_reason": switch_blocked_reason,
            "point_total": point_total,
            "description": meta.get("description", ""),
        }

    # اسم بديل متوافق مع كافة المحركات والمهام
    get_lord_active_skill_status = get_lord_skill_status


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
        التبديل إلى طقم مواهب/مهارات محدد مع فحص مسبق صارم (0-Network Pre-flight)
        وتحديث فوري للذاكرة الحية (In-Memory State Sync).
        
        :param set_id: رقم الطقم المستهدف (مثل 1 أو 2).
        :return: (نجاح/فشل، رسالة توضيحية).
        """
        target_set = str(set_id).strip() if set_id is not None else ""
        if not target_set:
            return False, "رقم طقم المواهب غير محدد."

        lord_skills = self.get_ctrl("lordSkillCtrl")
        if isinstance(lord_skills, dict):
            curr_set = str(lord_skills.get("activeSetID", "1"))
            if curr_set == target_set:
                return True, f"الطقم {target_set} مفعل بالفعل كطقم نشط حالياً."

        # 0-Network Pre-flight: التحقق من فك قفل الطقم وصلاحية التبديل قبل ملامسة السيرفر
        can_switch, reason = self.can_switch_lord_skill_set(target_set)
        if not can_switch:
            self.log(f"⚠️ [مهارات اللورد] تم إلغاء طلب التبديل إلى الطقم {target_set} لعدم استيفاء الشروط: {reason}")
            return False, f"تعذر التبديل إلى الطقم {target_set}: {reason}"

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
            return False, f"فشل تبديل طقم المهارات من السيرفر (كود الخطأ: {err_code})."

        # تحديث فوري للذاكرة الحية المحلية
        if hasattr(self, "conn") and isinstance(self.conn.init_data, dict):
            lord_skills_live = self.conn.init_data.setdefault("lordSkillCtrl", {})
            if isinstance(lord_skills_live, dict):
                set_val = int(target_set) if target_set.isdigit() else target_set
                lord_skills_live["activeSetID"] = set_val
                if "curSet" in lord_skills_live:
                    lord_skills_live["curSet"] = str(target_set)
                if "currentSetID" in lord_skills_live:
                    lord_skills_live["currentSetID"] = set_val

        self.log(f"✅ [مهارات اللورد] تم التبديل بنجاح إلى طقم المهارات {target_set}.")
        return True, f"تم التبديل بنجاح إلى طقم المهارات {target_set}."

    def _mark_skill_buff_active_in_memory(
        self,
        skill_id: int,
        target_buff_id: Optional[int] = None,
        target_queue_type: Optional[int] = None,
    ) -> None:
        """
        مزامنة فورية لحالة الباف أو الطابور النشط في الذاكرة الحية (0-Network In-Memory Buff Sync):
        تضمن معرفة البوت بأن المهارة سارية فور نجاح تفعيلها أو عند استلام كود 3012 (Skill is already active).
        """
        now_ts = int(time.time())
        meta = LORD_ACTIVE_SKILLS_CATALOG.get(skill_id, {})
        buff_id = target_buff_id or meta.get("buff_id")
        queue_type = target_queue_type or meta.get("queue_type")

        if hasattr(self, "conn") and isinstance(self.conn.init_data, dict):
            # 1. حقن/تحديث باف القلعة في buffCtrl
            if buff_id is not None:
                buff_ctrl = self.conn.init_data.setdefault("buffCtrl", [])
                is_untimed = buff_id in (4501, 5130, 5425)
                buff_obj = {
                    "id": buff_id,
                    "buffId": buff_id,
                    "beginTime": now_ts,
                    "time": 0 if is_untimed else 3600,
                    "endTime": 0 if is_untimed else (now_ts + 3600),
                }
                if isinstance(buff_ctrl, list):
                    found = False
                    for b in buff_ctrl:
                        if isinstance(b, dict) and str(b.get("id") or b.get("buffId")) == str(buff_id):
                            b.update(buff_obj)
                            found = True
                            break
                    if not found:
                        buff_ctrl.append(buff_obj)
                elif isinstance(buff_ctrl, dict):
                    if "buffList" in buff_ctrl and isinstance(buff_ctrl["buffList"], list):
                        found = False
                        for b in buff_ctrl["buffList"]:
                            if isinstance(b, dict) and str(b.get("id") or b.get("buffId")) == str(buff_id):
                                b.update(buff_obj)
                                found = True
                                break
                        if not found:
                            buff_ctrl["buffList"].append(buff_obj)
                    else:
                        buff_ctrl[str(buff_id)] = buff_obj

            # 2. حقن/تحديث طابور المهارة في queueCtrl
            if queue_type is not None:
                queue_ctrl = self.conn.init_data.setdefault("queueCtrl", {})
                is_untimed_q = (queue_type == 1214)
                q_obj = {
                    "qtype": str(queue_type),
                    "starttime": now_ts,
                    "totaltime": 0 if is_untimed_q else 3600,
                    "ottime": 0 if is_untimed_q else (now_ts + 3600),
                }
                if isinstance(queue_ctrl, dict):
                    queue_ctrl[str(queue_type)] = q_obj
                elif isinstance(queue_ctrl, list):
                    found = False
                    for q in queue_ctrl:
                        if isinstance(q, dict) and str(q.get("qtype") or q.get("queueType")) == str(queue_type):
                            q.update(q_obj)
                            found = True
                            break
                    if not found:
                        queue_ctrl.append(q_obj)

    def _sync_skill_cd_in_memory(self, skill_id: int, resp: Dict[str, Any], status: Dict[str, Any]) -> None:
        """مزامنة فورية لحالة التبريد في كائن الذاكرة الحية (0-Network In-Memory State Sync)."""
        now_ts = int(time.time())
        base_cd = status.get("base_cd_seconds", 14400)
        rsp_data = resp.get("data", {}) if isinstance(resp.get("data"), dict) else {}
        cd_val = self._safe_int(rsp_data.get("CD", base_cd), default=base_cd)
        begin_t = self._safe_int(rsp_data.get("beginTime", now_ts), default=now_ts)

        # المهارات التي لا تبدأ فترة تبريدها إلا بعد استهلاك/إغلاق الباف (مثل مهارة الإنقاذ 11028 والاستحواذ 13040)
        if skill_id in (11028, 13040) and "CD" not in rsp_data:
            return

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
            locked_sets = [sf for sf in status.get("sets_found", []) if not sf.get("is_unlocked")]
            if locked_sets:
                reason = locked_sets[0].get("locked_reason") or status.get("switch_blocked_reason") or "شروط فتح الطقم غير مكتملة"
                return False, f"المهارة '{skill_name}' ({resolved_id}) غير متاحة للقلعة حالياً ({reason})."
            return False, f"المهارة '{skill_name}' ({resolved_id}) غير متوفرة أو غير مفتوحة بنقاط للقلعة في أي طقم مواهب متاح."

        if status.get("is_active"):
            buff_rem = status.get("buff_remaining_seconds", 0)
            is_untimed = status.get("is_untimed_buff", False)
            desc = "تأثير مستمر حتى المعركة القادمة" if (is_untimed or buff_rem == 0) else f"متبقي {buff_rem} ثانية"
            return False, f"المهارة '{skill_name}' مفعّلة وسارية بالفعل حالياً ({desc})."

        if status.get("in_cooldown"):
            return False, f"المهارة '{skill_name}' في فترة تبريد (متبقي {status.get('cd_remaining_seconds')} ثانية)."

        target_buff_id = status.get("target_buff_id") or LORD_ACTIVE_SKILLS_CATALOG.get(resolved_id, {}).get("buff_id")
        target_queue_type = status.get("target_queue_type") or LORD_ACTIVE_SKILLS_CATALOG.get(resolved_id, {}).get("queue_type")
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
                if str(err_code) == "3012":
                    self._mark_skill_buff_active_in_memory(resolved_id, target_buff_id, target_queue_type)
                    self.log(f"ℹ️ [مهارات اللورد] المهارة '{skill_name}' مفعلة وسارية المفعول بالفعل على القلعة (تمت مزامنة الباف محلياً).")
                    return True, f"المهارة '{skill_name}' مفعلة وسارية المفعول بالفعل."
                return False, f"فشل تفعيل المهارة '{skill_name}' من السيرفر (كود الخطأ: {err_code})."

            self._sync_skill_cd_in_memory(resolved_id, resp, status)
            self._mark_skill_buff_active_in_memory(resolved_id, target_buff_id, target_queue_type)
            self.log(f"✅ [مهارات اللورد] تم تفعيل المهارة '{skill_name}' بنجاح.")
            return True, f"تم تفعيل المهارة '{skill_name}' بنجاح."

        # الحالة 2: المهارة موجودة في طقم آخر غير النشط
        if not status.get("can_switch_to_set") or not target_set_id:
            reason = status.get("switch_blocked_reason") or "شروط VIP غير مكتملة"
            sets_found = status.get("sets_found", [])
            cand_str = str(sets_found[0]["set_id"]) if sets_found else (target_set_id or "?")
            return False, f"المهارة '{skill_name}' موجودة في طقم آخر ({cand_str}) وغير متاحة للتبديل حالياً ({reason})."

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
                if str(err_code) == "3012":
                    self._mark_skill_buff_active_in_memory(resolved_id, target_buff_id, target_queue_type)
                    self.log(f"ℹ️ [مهارات اللورد] المهارة '{skill_name}' مفعلة وسارية المفعول بالفعل على القلعة (تمت مزامنة الباف محلياً).")
                    success = True
                    result_msg = f"المهارة '{skill_name}' مفعلة وسارية المفعول بالفعل."
                else:
                    success = False
                    result_msg = f"فشل تفعيل المهارة '{skill_name}' من السيرفر (كود الخطأ: {err_code})."
            else:
                success = True
                self._sync_skill_cd_in_memory(resolved_id, resp, status)
                self._mark_skill_buff_active_in_memory(resolved_id, target_buff_id, target_queue_type)
                result_msg = f"تم تفعيل المهارة '{skill_name}' بنجاح."
                self.log(f"✅ [مهارات اللورد] تم تفعيل المهارة '{skill_name}' بنجاح في الطقم {target_set_id}.")

        finally:
            # 3. العودة الإلزامية والحتمية إلى الطقم الأصلي السابق (Zero-Stranded Protocol)
            if auto_revert and target_set_id != original_set_id:
                try:
                    await _safe_delay()
                    self.log(f"🔄 [مهارات اللورد] جاري إعادة القلعة إلى طقمها الأصلي السابق {original_set_id}...")
                    rev_ok, rev_msg = await self.switch_lord_skill_set(original_set_id)
                    if not rev_ok:
                        self.log(f"⚠️ [مهارات اللورد] تحذير: تعذر استعادة الطقم السابق {original_set_id}: {rev_msg}")
                        if success:
                            result_msg += f" (ملاحظة: تعذر العودة للطقم الأصلي: {rev_msg})"
                    else:
                        self.log(f"🛡️ [مهارات اللورد] تمت استعادة الطقم الأصلي {original_set_id} بنجاح.")
                except Exception as rev_err:
                    self.log(f"❌ [مهارات اللورد] خطأ غير متوقع أثناء استعادة الطقم الأصلي {original_set_id}: {rev_err}")

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

    # اسم بديل متوافق مع كافة المحركات والمهام
    get_lord_active_skill_status = get_lord_skill_status

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
        حساب عدد الفيالق والمسيرات النشطة حالياً خارج القلعة مطابقاً حرفياً لـ localUserQueueMgr:getFromUserQueueNum (0-Network):
        - يستبعد الحالة 3 (moveLineStatusTypeFinished = منتهي في mapDef.lua:430).
        - يستبعد الطابور الأصلي (orgQueueId) عند وجود طابور عودة له (queueType=10) لمنع العدّ المزدوج.
        - يستبعد طابور عودة البطل المنفرد (queueType=10 و isHeroReturn=True) مطابقاً لـ kingdomMapCtrl:isHasQueue().
        - يعزل التكرار بمعرّف الطابور الفريد (qid) وبمعرّف القلعة (uid).
        """
        conn = getattr(self, "conn", None)
        if conn is None:
            return 0

        if force_sync and getattr(conn, "is_connected", False) and hasattr(conn, "query"):
            try:
                loop = asyncio.get_running_loop()
                loop.create_task(conn.query("1007", "1000", {}))
            except RuntimeError:
                pass

        queues = self._read_live_local_queues(conn)
        my_uid = str(getattr(self, "uid", "") or "").strip()
        # الحالة 3 هي moveLineStatusTypeFinished (منتهي) وتُستبعد تماماً
        active_statuses = (0, 1, 2, 4, 7)

        # المرحلة 1: جمع معرفات الطوابير الأصلية التي صدر لها طابور عودة (alreadyReturnQueueMap في localUserQueueMgr.lua:219)
        already_returned_org_ids: Set[str] = set()
        for q in queues:
            if not isinstance(q, dict):
                continue
            q_uid = q.get("uid")
            if my_uid and q_uid not in (None, "", 0, "0") and str(q_uid).strip() != my_uid:
                continue
            q_type = self._safe_int(q.get("queueType") if q.get("queueType") is not None else q.get("type"), 0)
            if q_type == 10:  # gMapMoveLineServerType.moveLineTypeReturn
                org_id = str(q.get("orgQueueId") or q.get("orgId") or "").strip()
                if org_id:
                    already_returned_org_ids.add(org_id)

        # المرحلة 2: عدّ الفيالق النشطة الفعلية فقط
        seen_ids: Set[str] = set()
        active = 0

        for q in queues:
            if not isinstance(q, dict):
                continue

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

            q_type = self._safe_int(q.get("queueType") if q.get("queueType") is not None else q.get("type"), 0)
            # استثناء عودة البطل المنفرد (kingdomQueueObjCell:isHeroReturnFun -> queueType == 10 and isHeroReturn)
            if q_type == 10 and bool(q.get("isHeroReturn")):
                continue

            qid = str(q.get("id") or q.get("queueId") or "").strip()
            if qid:
                if qid in already_returned_org_ids or qid in seen_ids:
                    continue
                seen_ids.add(qid)
            active += 1

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

        # 2. ميزة VIP (VIP 4..9 -> +1, VIP 10+ -> +2) تشترط سريان باف VIP حالياً
        if self.is_vip_active:
            vip_lv = self.vip_level
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

    def is_caravan_escort_march_active(self, force_sync: bool = False) -> bool:
        """
        فحص هل يوجد فيلق مخصص لحراسة قافلة الكنز/الغنيمة الخاصة بالقلعة نشط حالياً (0-Network):
        ══════════════════════════════════════════════════════════════════════════════
        المعادلة والمنطق المعتمد في سورس كود اللعبة (kingdomMapCtrl.lua & mapDef.lua):
        - مطابقة دالة kingdomMapCtrl:hasEscortQueue() الرسمية في العميل.
        - قراءة فورية من الذاكرة الحية (0-Network) عبر _read_live_local_queues.
        - فلترة صارمة لمعرّف القلعة (uid) لضمان احتساب مسيرات هذا الحساب حصراً وتجاهل اللاعبين الآخرين.
        - فلترة الحالات النشطة فقط:
          (0=حشد بتجمع, 1=سير على الخريطة, 2=حراسة/تمركز, 3=عودة للقلعة, 4=انتظار, 7=انطلاق).
        - مطابقة نوع المسار والهدف:
          1. نوع المسار السيرفري: moveLineTypeEscort = 22 (gMapMoveLineServerType.moveLineTypeEscort).
          2. نوع المسار في العميل: moveLineTypeEscort = 11 (gMapMoveLineType.moveLineTypeEscort).
          3. نوع خريطة القافلة: mapType = 16 (gMapObjTypeDef.mapTypeEscort) في الهدف (to) أو نقطة الانطلاق (from).
          4. استبعاد مسيرة مساعدة حليف بالتحالف: (moveLineTypeEscortAssist = 23 / moveLineTypeEscortHelp = 13)
             لحصر الفحص بمسيرة حراسة قافلة اللاعب الخاصة فقط وفق متطلبات الأمان.
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

        # أنواع مسيرات مساعدة حليف (يتم استبعادها لحصر الفحص بقافلة القلعة الخاصة فقط)
        assist_types = {23, 13, "23", "13"}
        # أنواع مسيرات حراسة القافلة الخاصة الرسمية (سيرفر: 22، عميل: 11)
        escort_types = {22, 11, "22", "11"}

        for q in queues:
            if not isinstance(q, dict):
                continue

            # فلترة صاحب المسيرة لضمان الانتماء لقلعة هذا الحساب حصراً
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

            ml_type = q.get("moveLineType") or q.get("move_line_type")
            q_type = q.get("queueType") or q.get("type")

            # استبعاد مسيرات مساعدة قوافل الحلفاء
            if ml_type in assist_types or q_type in assist_types:
                continue

            # 1. فحص نوع المسار الصريح لحراسة قافلة الغنيمة (22 أو 11)
            if ml_type in escort_types or q_type in escort_types:
                return True

            # 2. فحص الهدف (to) أو نقطة الانطلاق (from) لكيان القافلة (mapType = 16)
            for loc_key in ("to", "from"):
                info = q.get(loc_key, {})
                if isinstance(info, dict):
                    m_type = info.get("mapType") or info.get("objType")
                    if m_type in (16, "16"):
                        return True
                    raw_id = str(info.get("id") or "")
                    parts = raw_id.split("-")
                    if len(parts) >= 3 and parts[2] == "16":
                        return True

            # 3. فحص حمولة وبيانات عربة القافلة في كائن المسيرة (cartLv / cartId)
            data_obj = q.get("data")
            if isinstance(data_obj, dict):
                if data_obj.get("cartLv") is not None or data_obj.get("cartId") is not None:
                    return True
            elif q.get("cartLv") is not None or q.get("cartId") is not None:
                return True

        return False

    @property
    def is_caravan_escort_active(self) -> bool:
        """
        خاصية فحص فوري وسريع (0-Network Direct Read) هل يوجد فيلق لحراسة قافلة الكنز/الغنيمة نشط حالياً.
        """
        return self.is_caravan_escort_march_active(force_sync=False)

    # مسميات بديلة للتوافق الكامل
    has_active_ruins_march = is_ruins_march_active
    has_caravan_escort_march = is_caravan_escort_march_active
    _get_active_gather_types = get_active_gather_resource_types

    # ═════════════════════════════════════════════════════════════════════════
    # دوال إدارة استبعاد الأهداف المركزية (Centralized Exclude Manager)
    # ═════════════════════════════════════════════════════════════════════════

    @property
    def exclude_manager(self):
        """مدير الاستبعاد المركزي للأهداف (Singleton)."""
        from tasks.exclude_manager import get_manager
        return get_manager()

    async def reserve_target(
        self,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
        ttl: float | None = None,
    ) -> bool:
        """حجز هدف مؤقتاً في الذاكرة RAM لمنع التصادم مع القلاع الشقيقة."""
        kid = kingdom_id if kingdom_id is not None else self.kingdom_id
        return await self.exclude_manager.reserve(
            uid=self.uid,
            target_id=target_id,
            kingdom_id=kid,
            target_type=target_type,
            ttl=ttl,
        )

    async def confirm_target(
        self,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
    ):
        """تثبيت استبعاد الهدف في قاعدة بيانات SQLite WAL بعد نجاح الإرسال أو الانشغال."""
        kid = kingdom_id if kingdom_id is not None else self.kingdom_id
        await self.exclude_manager.confirm(
            uid=self.uid,
            target_id=target_id,
            kingdom_id=kid,
            target_type=target_type,
        )

    async def release_target(
        self,
        target_id: Any,
        kingdom_id: Any = None,
        target_type: str | None = None,
    ):
        """تحرير حجز الهدف عند فشل الإرسال لإعادة إتاحته فوراً."""
        kid = kingdom_id if kingdom_id is not None else self.kingdom_id
        await self.exclude_manager.release(
            uid=self.uid,
            target_id=target_id,
            kingdom_id=kid,
            target_type=target_type,
        )

    async def get_exclude_map(
        self,
        kingdom_id: Any = None,
        x: Optional[int] = None,
        y: Optional[int] = None,
        max_distance: float = 150.0,
        target_type: Optional[Any] = None,
    ) -> Dict[str, bool]:
        """جلب خريطة الأهداف المستبعدة لمملكة القلعة."""
        kid = kingdom_id if kingdom_id is not None else self.kingdom_id
        return await self.exclude_manager.get_exclude_map(
            uid=self.uid,
            kingdom_id=kid,
            x=x,
            y=y,
            max_distance=max_distance,
            target_type=target_type,
        )

    # ═════════════════════════════════════════════════════════════════════════
    # دوال جلب وفحص القوات والجنود الشاغرين في القلعة (0-Network Direct Read)
    # مطابقة تامة وترجمة حرفية لسورس اللعبة (armyCtrl.lua / armyltCtrl.lua / serviceFunctions.lua)
    # ═════════════════════════════════════════════════════════════════════════

    # معرف مبنى حصن الحرب طبقاً لسورس كود اللعبة (buildDef.lua - BUILDID.FORTRESS)
    BUILDID_FORTRESS = 120

    # معرفات فخاخ وعناصر حصن الحرب الرسمية (15 فخاً برتب مختلفة من armyinfo.lua حيث barrackID == 120)
    FORTRESS_TRAP_IDS: FrozenSet[int] = frozenset({
        801, 802, 803, 804, 805,
        811, 812, 813, 814, 815,
        821, 822, 823, 824, 825,
    })

    @staticmethod
    def is_trap_id(army_id: Union[int, str]) -> bool:
        """
        الترجمة الحرفية لدالة سورس اللعبة serviceFunctions.isTrapID(armyid):
        فحص ما إذا كان المعرف ينتمي لفخاخ أو عناصر حصن الحرب (800 < armyid <= 899).
        """
        try:
            aid = int(army_id)
            return (800 < aid <= 899) or (aid in BaseTask.FORTRESS_TRAP_IDS)
        except (ValueError, TypeError):
            return False

    @classmethod
    def is_army_id(cls, army_id: Union[int, str]) -> bool:
        """
        الترجمة الحرفية لدالة سورس اللعبة armyltCtrl.isArmyID(armyid):
        التحقق من أن الوحدة هي وحدة عسكرية مقاتلة وليست من فخاخ/عناصر حصن الحرب
        (armyltCtrl.armyAttr(armyid, ARMY_ATTR.BARRACK_ID) ~= BUILDID.FORTRESS).
        """
        try:
            aid = int(army_id)
            if aid <= 0:
                return False
            # استبعاد عناصر حصن الحرب (BUILDID.FORTRESS = 120 / Trap IDs 801-899)
            if cls.is_trap_id(aid):
                return False
            return True
        except (ValueError, TypeError):
            return False

    def get_trap_list(self) -> Dict[int, int]:
        """
        الترجمة الحرفية لدالة سورس اللعبة armyCtrl:getTrapList():
        جلب كافة فخاخ وعناصر حصن الحرب الموجودة بالقلعة حالياً من الذاكرة الحية (0-Network):
        local traplist = {}
        for k, v in pairs(self.armyInfo.totalArmy) do
            if serviceFunctions.isTrapID(k) and tonumber(v) > 0 then
                traplist[k] = tonumber(v)
            end
        end
        return traplist
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            army_ctrl = self.get_ctrl("army")
            if not army_ctrl or not isinstance(army_ctrl, dict):
                army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}

        raw_army = (
            army_ctrl.get("totalArmy")
            or army_ctrl.get("freeArmy")
            or army_ctrl.get("armys")
            or (army_ctrl.get("armyInfo", {}).get("totalArmy") if isinstance(army_ctrl.get("armyInfo"), dict) else None)
            or {}
        )

        traplist: Dict[int, int] = {}
        if isinstance(raw_army, dict):
            for k, v in raw_army.items():
                if self.is_trap_id(k):
                    try:
                        cnt = int(v)
                        if cnt > 0:
                            traplist[int(k)] = cnt
                    except (ValueError, TypeError):
                        continue
        elif isinstance(raw_army, list):
            for entry in raw_army:
                if not isinstance(entry, dict):
                    continue
                uid = entry.get("id") or entry.get("armyid") or entry.get("armyID")
                cnt = entry.get("num") or entry.get("count") or entry.get("armycount")
                if self.is_trap_id(uid):
                    try:
                        c = int(cnt)
                        if c > 0:
                            traplist[int(uid)] = traplist.get(int(uid), 0) + c
                    except (ValueError, TypeError):
                        continue
        return traplist

    def get_trap_total_count(self) -> int:
        """
        الترجمة الحرفية لدالة سورس اللعبة armyCtrl:getTrapTotalCount():
        إجمالي عدد فخاخ وعناصر حصن الحرب الموجودة في القلعة حالياً.
        """
        return sum(self.get_trap_list().values())

    def get_army_list(
        self,
        war_type: Optional[int] = None,
        deduct_fighting: bool = True,
    ) -> Dict[int, int]:
        """
        الترجمة الحرفية والمطابقة التامة لدالة سورس اللعبة armyCtrl:getArmyList(warType):
        جلب الجنود المتاحين والشاغرين في القلعة الممكن إرسالهم بدون عناصر حصن الحرب (0-Network Direct Read).

        كود السورس الأصلي (armyCtrl.lua):
        function armyCtrl:getArmyList(warType)
            local armylist = {}
            local totalArmy = self:getTotalArmyList(warType)
            for k, v in pairs(totalArmy) do
                if armyltCtrl.isArmyID(k) and tonumber(v) > 0 then
                    armylist[k] = tonumber(v)
                end
            end
            return armylist
        end

        المنطق المطبق:
        1. قراءة totalArmy للنوع العسكري المحدد (أو الحرب الافتراضية normal).
        2. الفلترة الصارمة عبر armyltCtrl.isArmyID(k): استبعاد كافة عناصر وفخاخ حصن الحرب (BUILDID.FORTRESS = 120 / 801-899).
        3. التأكد من أن القوة > 0 (tonumber(v) > 0).
        4. حماية إضافية من البان وأخطاء السيرفر (Zero-Risk): خصم جنود معارك الدفاع الحالية (fightingArmy) إن وُجدت
           لمنع إرسال جنود منخرطين حالياً في قتال دفاعي داخل القلعة.

        Returns:
            Dict[int, int]: قاموس {army_id: count} للجنود الشاغرين المتاحين للإرسال فوراً.
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            army_ctrl = self.get_ctrl("army")
            if not army_ctrl or not isinstance(army_ctrl, dict):
                army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}

        # 1. استخراج totalArmy بحسب نوع الحرب (مطابقة getTotalArmyList)
        raw_army = (
            army_ctrl.get("totalArmy")
            or army_ctrl.get("freeArmy")
            or army_ctrl.get("armys")
            or (army_ctrl.get("armyInfo", {}).get("totalArmy") if isinstance(army_ctrl.get("armyInfo"), dict) else None)
            or {}
        )

        fighting_army = (army_ctrl.get("fightingArmy") or {}) if deduct_fighting else {}
        armylist: Dict[int, int] = {}

        if isinstance(raw_army, dict):
            for k, v in raw_army.items():
                if not self.is_army_id(k):
                    continue
                try:
                    uid = int(k)
                    cnt = int(v)
                except (ValueError, TypeError):
                    continue

                if cnt <= 0:
                    continue

                # خصم قوات معارك الدفاع الحالية إن وُجدت
                fight_cnt = 0
                if deduct_fighting and isinstance(fighting_army, dict):
                    raw_fight = fighting_army.get(str(uid)) if str(uid) in fighting_army else fighting_army.get(uid)
                    if raw_fight is not None:
                        try:
                            fight_cnt = int(raw_fight)
                        except (ValueError, TypeError):
                            fight_cnt = 0

                avail = max(0, cnt - fight_cnt)
                if avail > 0:
                    armylist[uid] = avail

        elif isinstance(raw_army, list):
            for entry in raw_army:
                if not isinstance(entry, dict):
                    continue
                raw_id = entry.get("id") or entry.get("armyid") or entry.get("armyID")
                raw_count = entry.get("num") or entry.get("count") or entry.get("armycount")
                if not self.is_army_id(raw_id):
                    continue
                try:
                    uid = int(raw_id)
                    cnt = int(raw_count)
                except (ValueError, TypeError):
                    continue

                if cnt <= 0:
                    continue

                fight_cnt = 0
                if deduct_fighting and isinstance(fighting_army, dict):
                    raw_fight = fighting_army.get(str(uid)) if str(uid) in fighting_army else fighting_army.get(uid)
                    if raw_fight is not None:
                        try:
                            fight_cnt = int(raw_fight)
                        except (ValueError, TypeError):
                            fight_cnt = 0

                avail = max(0, cnt - fight_cnt)
                if avail > 0:
                    armylist[uid] = armylist.get(uid, 0) + avail

        return armylist

    def get_inner_city_normal_army(self, war_type: Optional[int] = None) -> int:
        """
        الترجمة الحرفية لدالة سورس اللعبة armyCtrl:getInnerCityNormalArmy(warType):
        إجمالي عدد الجنود العاديين الشاغرين المتاحين داخل القلعة (مجموع get_army_list):
        function armyCtrl:getInnerCityNormalArmy(warType)
            local ret = 0
            local armyList = self:getArmyList(warType)
            for k, v in pairs(armyList) do
                ret = ret + v
            end
            return ret
        end
        """
        return sum(self.get_army_list(war_type=war_type, deduct_fighting=True).values())

    get_inner_city_army = get_inner_city_normal_army
    get_army_total_count = get_inner_city_normal_army

    def get_available_troops(
        self,
        exclude_fortress: bool = True,
        as_list: bool = False,
        reverse: bool = False,
        war_type: Optional[int] = None,
    ) -> Dict[int, int] | List[Dict[str, int]]:
        """
        جلب القوات والجنود المتاحين والشاغرين حالياً داخل القلعة من الذاكرة الحية (0-Network):
        - إذا كان exclude_fortress=True (الافتراضي): يعتمد مباشرة على الترجمة الحرفية لدالة سورس اللعبة
          armyCtrl:getArmyList(warType) وفلترة armyltCtrl.isArmyID(k) باستبعاد حصن الحرب (120 / 801-899).
        - استبعاد أي جنود منخرطين حالياً في معارك القلعة من كائن fightingArmy إن وُجد.
        - ترتيب القوات تصاعدياً بحسب المعرف/الرتبة (reverse=False: الأضعف أولاً لتفادي استنزاف النخب)،
          أو تنازلياً (reverse=True: الأقوى رتبة أولاً للحشود والمسيرات القتالية).
        - صيغة الإرجاع:
          * قاموس {unit_id: count} إذا كان as_list=False (الافتراضي).
          * قائمة كائنات [{"id": unit_id, "num": count}, ...] إذا كان as_list=True لتناسب حزم السيرفر فوراً.
        """
        if exclude_fortress:
            troops_map = self.get_army_list(war_type=war_type, deduct_fighting=True)
        else:
            troops_map = self.get_army_list(war_type=war_type, deduct_fighting=True)
            traps = self.get_trap_list()
            for k, v in traps.items():
                troops_map[k] = troops_map.get(k, 0) + v

        # فرز الوحدات (تصاعدي الأضعف أولاً افتراضياً لتفادي استنزاف النخب)
        sorted_items = sorted(troops_map.items(), key=lambda x: x[0], reverse=reverse)

        # تحويل لصيغة الإرجاع المطلوبة
        if as_list:
            return [{"id": k, "num": v} for k, v in sorted_items]
        return dict(sorted_items)

    def get_available_troops_count(self, exclude_fortress: bool = True) -> int:
        """إجمالي تعداد الجنود المتاحين والشاغرين في القلعة حالياً (0-Network)."""
        if exclude_fortress:
            return self.get_inner_city_normal_army()
        return sum(self.get_available_troops(exclude_fortress=False, as_list=False).values())

    @property
    def available_troops(self) -> Dict[int, int]:
        """قاموس القوات الشاغرة المتاحة حالياً في القلعة مع استبعاد وحدات حصن الحرب (0-Network)."""
        return self.get_army_list(deduct_fighting=True)

    @property
    def available_troops_count(self) -> int:
        """إجمالي عدد القوات الشاغرة المتاحة في القلعة حالياً مع استبعاد وحدات حصن الحرب."""
        return self.get_inner_city_normal_army()

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

    # ═════════════════════════════════════════════════════════════════════════
    # دوال إدارة واسترجاع تشكيلات الجيش المحفوظة (Army Preset Formations Engine)
    # مطابقة تامة لسورس كود اللعبة (armyCtrl.lua: compileArmy, compileHero, compileArms, compileDivineBeast)
    # خاضعة للمعيار الصارم للدوال (القاعدة 14 في الدستور)
    # ═════════════════════════════════════════════════════════════════════════

    def _parse_army_formation(
        self,
        formation_id: Union[int, str],
        army_ctrl: Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        التحليل الداخلي الموحد لبيانات تشكيلة الجيش من الذاكرة الحية (0-Network Direct Read).
        مطابقة تامة لبيانات العميل وسورس اللعبة:
        - compileArmy: الجنود المحددين لكل تشكيلة وأسماء التشكيلات (n1, n2, ...)
        - compileHero: الأبطال المخصصين للتشكيلة
        - compileArms: السلاح الخارق / العتاد
        - compileDivineBeast: الوحش الروحي / التنين

        Returns:
            Dict[str, Any]:
                - success (bool): نجاح جلب التشكيلة
                - reason (str): سبب الفشل إذا كانت success=False
                - formation_id (int): رقم التشكيلة
                - name (str): اسم التشكيلة المخصص إن وجد أو رقمها
                - total_preset_soldiers (int): إجمالي الجنود المحددين بالتشكيلة
                - total_available_soldiers (int): إجمالي الجنود المتوفرين بالقلعة من هذه التشكيلة
                - can_march_full (bool): هل تتوفر كافة القوات بالكامل لإرسال المسيرة كاملة؟
                - soldiers (dict): تفصيل كل نوع جندي مع الرصيد المتاح والكفاية
                - heroes (list): قائمة الأبطال المخصصين مع أسمائهم ورتبهم
                - arms (list): معرفات الأسلحة الخارقة المخصصة
                - divine_beast (dict): بيانات الوحش الروحي المخصص
                - raw_troops (dict): القاموس الخام للجنود {army_id: count}
        """
        if not isinstance(army_ctrl, dict):
            return {
                "success": False,
                "reason": "بيانات الجيوش (armyCtrl) غير متوفرة في الذاكرة الحية.",
            }

        compile_army = army_ctrl.get("compileArmy") or {}
        if not isinstance(compile_army, dict):
            return {
                "success": False,
                "reason": "لا توجد تشكيلات جيش معرّفة بحساب القلعة (compileArmy مفقود).",
            }

        fid_str: Optional[str] = None
        fid_int: Optional[int] = None

        try:
            fid_int = int(formation_id)
            fid_str = str(fid_int)
        except (ValueError, TypeError):
            # محاولة التعرف على التشكيلة بالاسم المخصص (مثل "جندي" أو "فرسان")
            if isinstance(formation_id, str):
                target_name = formation_id.strip()
                for k, v in compile_army.items():
                    if k.startswith("n") and str(v).strip() == target_name:
                        matched = k[1:]
                        if matched.isdigit():
                            fid_str = matched
                            fid_int = int(matched)
                            break

        if fid_str is None or fid_int is None:
            return {
                "success": False,
                "reason": f"رقم أو اسم التشكيلة غير صالح: {formation_id}",
            }

        # 1. التحقق من وجود التشكيلة في كائن compileArmy
        raw_formation_troops = compile_army.get(fid_str)
        if not raw_formation_troops or not isinstance(raw_formation_troops, dict):
            return {
                "success": False,
                "reason": f"التشكيلة رقم {fid_int} غير موجودة أو فارغة.",
            }

        # 2. استخراج اسم التشكيلة إن وجد (مثل n1, n2)
        name_key = f"n{fid_str}"
        formation_name = str(compile_army.get(name_key) or fid_str)

        # 3. جلب القوات المتاحة حالياً بالقلعة لفحص التوافر الفعلي (0-Network)
        available_in_castle = self.get_available_troops(exclude_fortress=True, as_list=False)
        if not isinstance(available_in_castle, dict):
            available_in_castle = {}

        # 4. تحليل تفصيلي للجنود وتدقيق كفايتهم
        soldiers_detail: Dict[int, Dict[str, Any]] = {}
        total_preset = 0
        total_available = 0
        can_march_full = True

        for uid_raw, count_raw in raw_formation_troops.items():
            try:
                uid = int(uid_raw)
                cnt = int(count_raw)
            except (ValueError, TypeError):
                continue

            if cnt <= 0:
                continue

            total_preset += cnt
            avail_cnt = int(available_in_castle.get(uid, 0))
            is_suff = avail_cnt >= cnt
            if not is_suff:
                can_march_full = False

            total_available += min(avail_cnt, cnt)

            soldiers_detail[uid] = {
                "army_id": uid,
                "preset_count": cnt,
                "available_count": avail_cnt,
                "is_sufficient": is_suff,
                "missing_count": max(0, cnt - avail_cnt),
            }

        if total_preset <= 0:
            return {
                "success": False,
                "reason": f"التشكيلة رقم {fid_int} لا تحتوي على أي جنود نشطين.",
            }

        # 5. استخراج الأبطال المخصصين للتشكيلة من compileHero
        compile_hero = army_ctrl.get("compileHero") or {}
        raw_heroes = compile_hero.get(fid_str) if isinstance(compile_hero, dict) else None
        heroes_list: List[Dict[str, Any]] = []

        if isinstance(raw_heroes, list):
            for h in raw_heroes:
                hid = None
                if isinstance(h, dict):
                    hid = h.get("heroID") or h.get("id") or h.get("heroid")
                elif isinstance(h, (int, str)):
                    hid = h
                if hid is not None:
                    try:
                        hid_int = int(hid)
                        meta = OFFICIAL_HERO_CATALOG.get(hid_int, {})
                        heroes_list.append({
                            "id": hid_int,
                            "name_ar": meta.get("name_ar", f"بطل {hid_int}"),
                            "type_ar": meta.get("type_ar", "غير محدد"),
                            "rarity": meta.get("rarity", 1),
                        })
                    except (ValueError, TypeError):
                        pass

        # 6. استخراج السلاح الخارق من compileArms
        compile_arms = army_ctrl.get("compileArms") or {}
        raw_arms = compile_arms.get(fid_str) if isinstance(compile_arms, dict) else None
        arms_list: List[int] = []
        if isinstance(raw_arms, list):
            for a in raw_arms:
                try:
                    arms_list.append(int(a))
                except (ValueError, TypeError):
                    pass
        elif isinstance(raw_arms, (int, str)):
            try:
                arms_list.append(int(raw_arms))
            except (ValueError, TypeError):
                pass

        # 7. استخراج الوحش الروحي / التنين من compileDivineBeast
        compile_beast = army_ctrl.get("compileDivineBeast") or {}
        raw_beast = compile_beast.get(fid_str) if isinstance(compile_beast, dict) else None
        beast_info = raw_beast if isinstance(raw_beast, (dict, list)) else {}

        return {
            "success": True,
            "formation_id": fid_int,
            "name": formation_name,
            "total_preset_soldiers": total_preset,
            "total_available_soldiers": total_available,
            "can_march_full": can_march_full,
            "soldiers": soldiers_detail,
            "heroes": heroes_list,
            "arms": arms_list,
            "divine_beast": beast_info,
            "raw_troops": {str(k): int(v) for k, v in raw_formation_troops.items() if self._safe_int(v) > 0},
        }

    def get_army_formation_sync(self, formation_id: Union[int, str]) -> Dict[str, Any]:
        """
        جلب تشكيلة الجيش المحددة فورياً وبشكل متزامن من الذاكرة الحية حصراً (0-Network Direct Read).
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}
        return self._parse_army_formation(formation_id, army_ctrl)

    async def get_army_formation(self, formation_id: Union[int, str]) -> Dict[str, Any]:
        """
        جلب تشكيلة الجيش التي صممها المستخدم باللعبة مع التحقق من الذاكرة الحية والاستعلام الاحتياطي.
        تخضع بالكامل للمعيار الصارم للقاعدة 14 في الدستور (BaseTask Architectural Standard):
        1. الاعتماد الأساسي والأولي على الذاكرة الحية (0-Network Direct Read).
        2. في حال غياب armyCtrl أو compileArmy من الذاكرة:
           طباعة تحذيرية صارخة بإيموجيات تنبيهية واضحة ثم استعلام شبكي احتياطي (CMD 1005, subcmd 1).
        3. إرجاع حزمة بيانات شاملة مع فحص التوافر الفعلي للجنود بالقلعة.
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}

        # التحقق من وجود armyCtrl و compileArmy في الذاكرة الحية
        if not army_ctrl or "compileArmy" not in army_ctrl:
            self.log(
                f"🚨⚠️🚨 [BaseTask:get_army_formation] 'armyCtrl' or 'compileArmy' is MISSING from live memory! "
                f"Falling back to network query (CMD 1005, subcmd 1)..."
            )
            resp = await self.safe_query(cmd="1005", subcmd="1", data={})
            if resp and isinstance(resp, dict):
                data = resp.get("data") or resp
                if isinstance(data, dict):
                    if hasattr(self, "conn") and self.conn and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                        target_ctrl = self.conn.init_data.setdefault("armyCtrl", {})
                        if isinstance(target_ctrl, dict):
                            target_ctrl.update(data)
                        army_ctrl = target_ctrl

        return self._parse_army_formation(formation_id, army_ctrl)

    def get_all_army_formations(self) -> Dict[int, Dict[str, Any]]:
        """
        جلب كافة تشكيلات الجيش المعرفة والجاهزة في حساب القلعة من الذاكرة الحية (0-Network Direct Read).
        Returns:
            Dict[int, Dict[str, Any]]: قاموس بمفتاح رقم التشكيلة وبياناتها الشاملة.
        """
        army_ctrl = self.get_ctrl("armyCtrl")
        if not army_ctrl or not isinstance(army_ctrl, dict):
            army_ctrl = self.init_data.get("armyCtrl", {}) if isinstance(self.init_data.get("armyCtrl"), dict) else {}

        compile_army = army_ctrl.get("compileArmy") or {}
        formations: Dict[int, Dict[str, Any]] = {}

        if isinstance(compile_army, dict):
            for k in compile_army.keys():
                if k.isdigit():
                    res = self._parse_army_formation(k, army_ctrl)
                    if res.get("success"):
                        formations[int(k)] = res

        return formations

    @property
    def is_connected(self) -> bool:
        """فحص سريع لوجود اتصال حي ونشط بالبوابة (0-Network Pre-flight)."""
        return bool(self.conn and getattr(self.conn, "is_connected", False))

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

    async def sync_achievements(self, timeout: float = 3.0) -> bool:
        """
        مزامنة بيانات الإنجازات الرسمية (CMD 1055, SUBCMD 2) وتحديث الذاكرة الحية.
        مطابقة تامة لـ achievementctrl:sendRefresh() في العميل الرسمي للعبة.
        """
        if not self.conn or not getattr(self.conn, "is_connected", False) or not hasattr(self.conn, "query"):
            return False
        try:
            resp = await self.conn.query("1055", "2", {}, timeout=timeout)
            if resp and isinstance(resp, dict):
                res_data = resp.get("result") or resp.get("data")
                if res_data and hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                    self.conn.init_data["achievementctrl"] = res_data
            return True
        except Exception as e:
            self.log(f"⚠️ استعلام مزامنة الإنجازات 1055/2 لم يكتمل: {e}")
            return False

    async def ensure_achievements_synced(self, timeout: float = 3.0) -> bool:
        """
        ضمان شحن بيانات الإنجازات والميداليات (achievementctrl) في الذاكرة الحية.
        - إذا كانت مشحونة مسبقاً: 0-Network (قراءة فورية بدون ملامسة السيرفر).
        - إذا لم تكن مشحونة: استعلام آمن واحد فقط (CMD 1055/2) وتحديث الذاكرة.
        """
        ctrl = self.get_ctrl("achievementctrl")
        if isinstance(ctrl, dict) and ctrl.get("list"):
            return True
        return await self.sync_achievements(timeout=timeout)

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
        action: Optional[str] = None,
    ) -> Optional[Dict[str, Any]]:
        """
        إرسال استعلام للبوابة مع تطبيق تأخير بشري ديناميكي عشوائي (Human Jitter)
        لمنع إثقال السيرفر وتفادي أنظمة الحماية الآلية، مع تفعيل قاطع الاتصال
        (Connection Circuit Breaker) فور رصد انقطاع الاتصال بالسيرفر.
        """
        if not self.conn or not getattr(self.conn, "is_connected", False):
            self.log("⚡ [قاطع الاتصال] تم اعتراض الاستعلام: الاتصال مقطوع بالبوابة (Connection lost / Dead socket)!")
            raise ConnectionCircuitBreakerError("الاتصال مقطوع بالبوابة (Connection lost / Dead socket)")

        # إضافة فاصل بشري عشوائي خفيف قبل الطلب
        if min_delay > 0:
            jitter = random.uniform(min_delay, max_delay)
            await asyncio.sleep(jitter)

        try:
            res = await self.conn.query(cmd, subcmd, data or {}, action=action)
            if not getattr(self.conn, "is_connected", False):
                self.log(f"⚡ [قاطع الاتصال] انقطع الاتصال بالسيرفر أثناء الاستعلام ({cmd}/{subcmd}) — تفعيل قاطع الاتصال فوراً.")
                raise ConnectionCircuitBreakerError(f"انقطع الاتصال بالخادم أثناء الاستعلام ({cmd}/{subcmd})")
            return res
        except Exception as e:
            if "ConcurrentLogin" in type(e).__name__:
                raise
            if "ConnectionCircuitBreaker" in type(e).__name__:
                raise
            if self.conn and getattr(self.conn, "is_other_device", False):
                from core.game_client import ConcurrentLoginError
                raise ConcurrentLoginError("تم رصد طرد من السيرفر بسبب دخول متزامن من جهاز آخر (KICK)")
            if isinstance(e, (ConnectionResetError, ConnectionAbortedError, BrokenPipeError)):
                self.log(f"⚡ [قاطع الاتصال] تم رصد انقطاع شبكي صريح ({type(e).__name__}) أثناء ({cmd}/{subcmd})!")
                raise ConnectionCircuitBreakerError(f"انقطاع شبكي أثناء الاستعلام: {e}")
            if isinstance(e, (asyncio.TimeoutError, TimeoutError)) and (not self.conn or not getattr(self.conn, "is_connected", False)):
                self.log(f"⚡ [قاطع الاتصال] انتهت مهلة الاستعلام والاتصال مقطوع أثناء ({cmd}/{subcmd})!")
                raise ConnectionCircuitBreakerError(f"انقطاع شبكي أثناء الاستعلام: {e}")
            self.log(f"❌ خطأ أثناء إرسال الاستعلام ({cmd}/{subcmd}): {e}")
            return None

    # ═════════════════════════════════════════════════════════════════════════
    # 3. دورة حياة التنفيذ (Execution Lifecycle)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي سريع (Pre-flight Check) لتحديد هل المهمة قابلة للتشغيل:
        - هل المهمة مفعلة في الإعدادات؟
        - هل الحساب متصل والذاكرة جاهزة؟ (فحص قاطع الاتصال)
        - هل شروط المهمة الخاصة متوفرة؟
        يُعاد (True, "") أو (False, "سبب التخطي").
        """
        if not self.config.get("enabled", True):
            return False, "المهمة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بالبوابة"

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
        - يمرر استثناء قاطع الاتصال وتزامن الجلسات لمدير البوت فوراً.
        - يقيس زمن التنفيذ ويسجل النتائج بدقة.
        """
        # 1. الفحص القبلي
        try:
            can_execute, reason = await self.can_run()
            if not can_execute:
                return TaskResult.skip(reason)
        except ConnectionCircuitBreakerError:
            raise
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
        except ConnectionCircuitBreakerError:
            raise
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

    @staticmethod
    def _safe_float(v: Any, default: float = 0.0) -> float:
        """تحويل آمن إلى عدد عشري مع معالجة السلاسل النصية والقيم غير الصالحة دون استثناءات."""
        if v is None or isinstance(v, bool):
            return default
        try:
            if isinstance(v, str):
                s = v.strip()
                return float(s) if s else default
            return float(v)
        except (ValueError, TypeError, OverflowError):
            return default

    # ═════════════════════════════════════════════════════════════════════════
    # 5. استكشاف وجلب مهام قاعة القيادة (Command Hall Inspection)
    # ═════════════════════════════════════════════════════════════════════════

    def _get_command_hall_ctrl(self) -> Optional[Dict[str, Any]]:
        """
        قراءة بيانات قاعة القيادة من الذاكرة الحية أولاً (0-Network Check)
        مع توحيد المرجع بين المفتاحين الرسميين commandHall و commandHallCtrl.
        """
        hall = self.get_ctrl("commandHall")
        ctrl = self.get_ctrl("commandHallCtrl")
        chosen = hall if isinstance(hall, dict) and hall else (ctrl if isinstance(ctrl, dict) and ctrl else None)
        if chosen is None:
            if isinstance(hall, dict):
                chosen = hall
            elif isinstance(ctrl, dict):
                chosen = ctrl

        init_data = getattr(self.conn, "init_data", None)
        if isinstance(chosen, dict) and isinstance(init_data, dict):
            init_data["commandHall"] = chosen
            init_data["commandHallCtrl"] = chosen
        return chosen

    def is_command_hall_unlocked(self) -> Tuple[bool, str]:
        """
        فحص فتح قاعة القيادة وفق ثابت اللعبة الرسمي (constant.lua -> COMMANDHALL_OPEN_LV = 3) (0-Network).
        إذا كانت بيانات قاعة القيادة مشحونة فعلاً في الذاكرة الحية تُعتبر القاعة مفتوحة مباشرة.
        """
        hall_data = self._get_command_hall_ctrl()
        has_hall = isinstance(hall_data, dict) and bool(
            hall_data.get("commandLv") or hall_data.get("commonTaskData") or hall_data.get("armyGroupTaskData")
        )
        if has_hall:
            return True, ""
        c_lv = int(self.castle_level or 0)
        if c_lv < COMMAND_HALL_OPEN_LV:
            return (
                False,
                f"قاعة القيادة غير متوفرة لهذه القلعة (مستوى القلعة Lv.{c_lv} أقل من المستوى المطلوب Lv.{COMMAND_HALL_OPEN_LV}).",
            )
        return True, ""

    @staticmethod
    def get_command_hall_need_exp(command_lv: int) -> int:
        """
        حساب نقاط الخبرة المطلوبة للترقية من commandLv الحالي (0-Network):
        مطابق لـ newcommandhalllv.lua و commandHallRead.getCommandLvNeedExp():
          - المستويات 1..20: من جدول COMMAND_HALL_EXP_BY_LV.
          - المستويات 21..999+: القيمة الرسمية الثابتة 4800 (Index 21: lv={21, 999}, needExp=4800).
        """
        try:
            lv = int(command_lv or 0)
        except (TypeError, ValueError):
            lv = 0
        if lv <= 0 or lv >= COMMAND_HALL_MAX_LEVEL:
            return 0
        return COMMAND_HALL_EXP_BY_LV.get(lv, COMMAND_HALL_HIGH_LV_EXP)

    def _sync_command_hall_init_data(self, new_init: Any) -> Optional[Dict[str, Any]]:
        """
        مزامنة initData لقاعة القيادة مطابقاً لـ commandHallCtrl:setInitData في العميل الرسمي:
        - عند وصول لقطة كاملة من السيرفر (تحتوي commandLv وحقول المهام)، يُستبدل المحتوى بالكامل
          لمسح أي مهام محذوفة أو منتهية (مثل armyPioneerTaskData) وعدم إبقائها كبيانات شبحية.
        - عند وصول تحديث جزئي، تُحدّث الحقول المرسلة فقط في الكائن المشترك.
        - يحافظ على تطابق المرجع بين commandHall و commandHallCtrl دائماً.
        """
        if not isinstance(new_init, dict):
            return None

        init_store = getattr(self.conn, "init_data", None)
        is_full_snapshot = (
            "commandLv" in new_init
            and any(k in new_init for k in ("commonTaskData", "taskList", "armyGroupTaskData", "nextRefreshTime"))
        )

        if not isinstance(init_store, dict):
            return dict(new_init)

        existing = init_store.get("commandHall")
        if not isinstance(existing, dict):
            existing = init_store.get("commandHallCtrl")

        if isinstance(existing, dict):
            if is_full_snapshot:
                existing.clear()
            existing.update(new_init)
            target = existing
        else:
            target = dict(new_init)

        init_store["commandHall"] = target
        init_store["commandHallCtrl"] = target
        return target

    def _mark_command_hall_task_claimed(self, task_index: int, task_type: int = 0) -> None:
        """تحديث حالة المهمة المسلمة محلياً (statue = 0) عند عدم إرجاع initData في الرد (0-Network)."""
        idx = self._safe_int(task_index, 0)
        if idx <= 0:
            return
        hall = self._get_command_hall_ctrl()
        if not isinstance(hall, dict):
            return

        for task_arr_key in ("commonTaskData", "taskList", "finishTaskData"):
            arr = hall.get(task_arr_key)
            items = arr.values() if isinstance(arr, dict) else (arr if isinstance(arr, list) else [])
            for itm in items:
                if isinstance(itm, dict) and self._safe_int(itm.get("index"), 0) == idx:
                    itm["statue"] = 0

        if task_type in (0, 2):
            ap = hall.get("armyPioneerTaskData")
            if isinstance(ap, dict) and self._safe_int(ap.get("index"), 0) == idx:
                ap["statue"] = 0

        if task_type in (0, 1):
            ag = hall.get("armyGroupTaskData")
            if isinstance(ag, dict) and self._safe_int(ag.get("index"), 0) == idx:
                ag["statue"] = 0

    def get_command_hall_daily_status(self) -> Tuple[bool, int, int]:
        """
        مصدر الحقيقة الموحد لحالة مهمة قاعة القيادة بالنشاط اليومي (4100033 | type=33 | quest=3 | limitTime=1):
        1. إذا سجّل السيرفر اكتمال المهمة اليومية في everydayTaskCtrl.eventInfo (قيمة >= 1 عبر 1000/1 أو NOTIFY 55)،
           يُعد الهدف منجزاً بالكامل (3/3).
        2. وإلا يقرأ عدد المهام الفرعية المسلَّمة بنجاح (2274/8) في الجلسة الحالية مقارنةً بالهدف الرسمي (3).
        يعيد: (is_completed, progress_count, target_count)
        """
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo")
            if isinstance(event_info, dict):
                for k in ("33", "4100033", 33, 4100033):
                    if k in event_info and self._safe_int(event_info.get(k), 0) >= 1:
                        return True, COMMAND_HALL_DAILY_QUEST_TARGET, COMMAND_HALL_DAILY_QUEST_TARGET

        local_subtasks = self._safe_int(getattr(self.conn, "_command_hall_daily_subtasks", 0), 0)
        if local_subtasks >= COMMAND_HALL_DAILY_QUEST_TARGET:
            return True, min(local_subtasks, COMMAND_HALL_DAILY_QUEST_TARGET), COMMAND_HALL_DAILY_QUEST_TARGET
        return False, max(0, local_subtasks), COMMAND_HALL_DAILY_QUEST_TARGET

    def _record_command_hall_subtask_completion(self, count: int = 1) -> int:
        """
        تسجيل إنجاز مهمة فرعية في قاعة القيادة بعد نجاح الاستلام الفعلي (2274/8) فقط:
        لا يُرفع عداد النشاط اليومي (33) محلياً إلى 1 إلا بعد بلوغ 3 مهام مكتملة (quest=3)،
        حتى لا تتوقف الدورة مبكراً بعد 1/3 ولا تُضاف 10 نقاط وهمية إلى DailyQuestTask.
        """
        if self.conn is None:
            return 0
        cur = self._safe_int(getattr(self.conn, "_command_hall_daily_subtasks", 0), 0) + max(0, int(count))
        setattr(self.conn, "_command_hall_daily_subtasks", cur)

        if cur >= COMMAND_HALL_DAILY_QUEST_TARGET:
            everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
            if isinstance(everyday_ctrl, dict):
                event_info = everyday_ctrl.setdefault("eventInfo", {})
                if isinstance(event_info, dict):
                    already_done = any(
                        k in event_info and self._safe_int(event_info.get(k), 0) >= 1
                        for k in ("33", "4100033", 33, 4100033)
                    )
                    if not already_done:
                        self.record_daily_quest_event(33, 1)
        return cur

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
        unlocked, lock_err = self.is_command_hall_unlocked()
        if not unlocked:
            return {
                "success": False,
                "error": lock_err,
                "castle_level": self.castle_level,
                "tasks": [],
            }

        # 1. فحص الذاكرة الحية (0-Network)
        hall_data = self._get_command_hall_ctrl()
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
                    hall_data = self._sync_command_hall_init_data(init_data) or init_data

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
        need_exp = self.get_command_hall_need_exp(cmd_lv)
        can_upgrade = (cmd_lv < COMMAND_HALL_MAX_LEVEL) and (need_exp > 0) and (cmd_exp >= need_exp)

        # فحص إنجاز النشاط اليومي (مهمة 33 في everydayTaskCtrl — 3 مهام قاعة قيادة)
        daily_quest_completed, daily_progress, _ = self.get_command_hall_daily_status()

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

            default_consume = 0 if raw_type == 1 else self.get_command_hall_task_spec(task_id)["consume"]
            stamina_cost = (
                self._safe_int(item.get("consume"), default_consume)
                if item.get("consume") is not None
                else default_consume
            )

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

    # جدول المهام القتالية الرسمي الكامل (144 مهمة) من newcommandhalltask.lua
    # الصيغة: task_id -> (recommendArmy, recommendHero, consume_stamina)
    COMMAND_HALL_COMBAT_SPECS: Dict[int, Tuple[int, int, int]] = {
        2001: (100, 0, 5), 2002: (150, 0, 5), 2003: (500, 7000, 5), 2004: (840, 14000, 5),
        2005: (1500, 30000, 5), 2006: (2500, 40000, 5), 2007: (2615, 50000, 5), 2008: (2805, 70000, 5),
        2009: (3555, 80000, 5), 2010: (5375, 100000, 5), 2011: (6975, 125200, 5), 2012: (8575, 130200, 5),
        2013: (10175, 135200, 5), 2014: (11775, 140200, 5), 2015: (13375, 145200, 5), 2016: (14975, 150200, 5),
        2017: (16575, 155200, 5), 2018: (17815, 160200, 5), 2019: (19815, 165200, 5), 2020: (21815, 170200, 5),
        2021: (23815, 175200, 5), 2022: (25815, 180200, 5), 2023: (27815, 185200, 5), 2024: (29815, 190200, 5),
        2025: (31815, 195200, 5), 2026: (33815, 200200, 5), 2027: (33890, 205200, 5), 2028: (36340, 210200, 5),
        2029: (38790, 215200, 5), 2030: (41240, 220200, 5), 2031: (43690, 225200, 5), 2032: (46140, 230200, 5),
        2033: (48590, 235200, 5), 2034: (51040, 240200, 5), 2035: (53490, 245200, 5), 2036: (54800, 250200, 5),
        2037: (60700, 255200, 5), 2038: (66600, 260200, 5), 2039: (72500, 265200, 5), 2040: (78400, 270200, 5),
        2041: (84300, 275200, 5), 2042: (90200, 280200, 5), 2043: (96100, 285200, 5), 2044: (102000, 290200, 5),
        2045: (107900, 295200, 5), 2046: (110900, 300200, 5), 2047: (117900, 305200, 5), 2048: (124900, 310200, 5),
        2049: (131900, 315200, 5), 2050: (142650, 320200, 5), 5001: (240, 0, 5), 5002: (240, 0, 5),
        5003: (240, 0, 5), 5004: (240, 0, 5), 5005: (240, 0, 5), 5006: (870, 30000, 5),
        5007: (870, 30000, 5), 5008: (870, 30000, 5), 5009: (870, 30000, 5), 5010: (870, 30000, 5),
        5011: (2000, 65360, 5), 5012: (2000, 65360, 5), 5013: (2000, 65360, 5), 5014: (2000, 65360, 5),
        5015: (2000, 65360, 5), 5016: (3500, 85000, 5), 5017: (3500, 85000, 5), 5018: (3500, 85000, 5),
        5019: (3500, 85000, 5), 5020: (3500, 85000, 5), 5021: (5630, 120200, 5), 5022: (5630, 120200, 5),
        5023: (5630, 120200, 5), 5024: (5630, 120200, 5), 5025: (5630, 120200, 5), 5026: (10430, 135200, 5),
        5027: (10430, 135200, 5), 5028: (10430, 135200, 5), 5029: (10430, 135200, 5), 5030: (10430, 135200, 5),
        5031: (13630, 145200, 5), 5032: (13630, 145200, 5), 5033: (13630, 145200, 5), 5034: (13630, 145200, 5),
        5035: (13630, 145200, 5), 5036: (16830, 155200, 5), 5037: (16830, 155200, 5), 5038: (16830, 155200, 5),
        5039: (16830, 155200, 5), 5040: (16830, 155200, 5), 5041: (21690, 170200, 5), 5042: (21690, 170200, 5),
        5043: (21690, 170200, 5), 5044: (21690, 170200, 5), 5045: (21690, 170200, 5), 5046: (31690, 195200, 5),
        5047: (31690, 195200, 5), 5048: (31690, 195200, 5), 5049: (31690, 195200, 5), 5050: (31690, 195200, 5),
        5051: (36340, 210200, 5), 5052: (36340, 210200, 5), 5053: (36340, 210200, 5), 5054: (36340, 210200, 5),
        5055: (36340, 210200, 5), 5056: (41240, 220200, 5), 5057: (41240, 220200, 5), 5058: (41240, 220200, 5),
        5059: (41240, 220200, 5), 5060: (41240, 220200, 5), 5061: (48590, 235200, 5), 5062: (48590, 235200, 5),
        5063: (48590, 235200, 5), 5064: (48590, 235200, 5), 5065: (48590, 235200, 5), 5066: (53490, 245200, 5),
        5067: (53490, 245200, 5), 5068: (53490, 245200, 5), 5069: (53490, 245200, 5), 5070: (53490, 245200, 5),
        5071: (78400, 270200, 5), 5072: (78400, 270200, 5), 5073: (78400, 270200, 5), 5074: (78400, 270200, 5),
        5075: (78400, 270200, 5), 5076: (96100, 285200, 5), 5077: (96100, 285200, 5), 5078: (96100, 285200, 5),
        5079: (96100, 285200, 5), 5080: (96100, 285200, 5), 5081: (107900, 295200, 5), 5082: (107900, 295200, 5),
        5083: (107900, 295200, 5), 5084: (107900, 295200, 5), 5085: (107900, 295200, 5), 5086: (110900, 300200, 5),
        5087: (110900, 300200, 5), 5088: (110900, 300200, 5), 5089: (110900, 300200, 5), 5090: (110900, 300200, 5),
        5091: (240, 0, 5), 5092: (240, 0, 5), 5093: (240, 0, 5), 5094: (240, 0, 5),
    }

    def get_command_hall_task_spec(self, task_id: int) -> Dict[str, int]:
        """استخراج القوة الموصى بها وتكلفة الطاقة من الجدول الرسمي الكامل (0-Network)."""
        tid = self._safe_int(task_id, 0)
        spec = self.COMMAND_HALL_COMBAT_SPECS.get(tid)
        if spec:
            return {"recommendArmy": spec[0], "recommendHero": spec[1], "consume": spec[2]}
        # احتياطي في حال أضافت اللعبة مستويات أعلى مستقبلاً
        if 1000 <= tid < 2000:
            return {"recommendArmy": 0, "recommendHero": 0, "consume": 0}
        if 2000 <= tid < 3000:
            return {"recommendArmy": 142650, "recommendHero": 320200, "consume": 5}
        if 5000 <= tid < 6000:
            return {"recommendArmy": 110900, "recommendHero": 300200, "consume": 5}
        if 3000 <= tid < 5000 or 6000 <= tid < 7000:
            return {"recommendArmy": 0, "recommendHero": 0, "consume": 5}
        return {"recommendArmy": 5630, "recommendHero": 120200, "consume": 5}

    def prepare_command_hall_combat_formation(
        self,
        task_id: int = 0,
        min_win_ratio: float = 1.20,
        max_win_ratio: float = 3.5,
    ) -> Dict[str, Any]:
        """
        تشكيل فيلق معارك قاعة القيادة عبر محرك MarchManagerTask الموحّد وحاسبة tasks/march_capacity.py (0-Network):
        - يستخدم أي جنود متاحين (أقوياء أو ضعفاء) مرتّبين تنازلياً بالقوة حتى تحقيق القتل المؤكد ضمن سعة الفيلق الحقيقية.
        - يشمل أبطال السور (exclude_defend_heroes=False) ويستبعد الأبطال المشغولين في local_queues تلقائياً.
        - يعيد ok=False و can_kill=False عند استحالة قتل الهدف لمنع إرسال مسيرات خاسرة.
        """
        from tasks.march_manager import MarchManagerTask

        spec = self.get_command_hall_task_spec(task_id)
        recommend_army = max(1, int(spec["recommendArmy"]))
        mgr = MarchManagerTask(self.conn, self.log)

        form = mgr.build_combat_army_formation(
            target_type="boss",
            level=1,
            strategy="max_power",
            min_win_ratio=min_win_ratio,
            custom_fc=recommend_army,
            exclude_defend_heroes=False,
            max_win_ratio=max_win_ratio,
        )
        if not form.get("ok") or not form.get("can_kill"):
            return {
                "ok": False,
                "can_kill": False,
                "error_code": form.get("error_code", "CANNOT_KILL"),
                "reason": form.get("reason", "تشكيلة القلعة غير كافية لقتل هدف قاعة القيادة."),
                "spec": spec,
                "formation": form,
                "army_payload": [],
                "hero_payload": [],
                "total_soldiers": 0,
            }

        army_dict = form.get("army") or {}
        army_payload = [{"id": int(aid), "num": int(cnt)} for aid, cnt in army_dict.items() if int(cnt) > 0]
        hero_ids = form.get("hero_ids") or []
        hero_payload = [{"heroID": int(hid)} for hid in hero_ids if int(hid) > 0]

        return {
            "ok": True,
            "can_kill": True,
            "error_code": "OK",
            "reason": "",
            "spec": spec,
            "formation": form,
            "army_payload": army_payload,
            "hero_payload": hero_payload,
            "hero_ids": hero_ids,
            "total_soldiers": int(form.get("total_soldiers", 0)),
            "max_capacity": int(form.get("max_capacity", 0)),
            "win_ratio": float(form.get("win_ratio", 0.0)),
        }

    def prepare_combat_troops(
        self,
        task_id: int = 0,
        target_power: Optional[int] = None,
        safety_multiplier: float = 1.20,
        min_troops: int = 100,
    ) -> List[Dict[str, int]]:
        """غلاف متوافق للخلف يستدعي محرك التشكيل الموحّد في MarchManagerTask + march_capacity.py."""
        res = self.prepare_command_hall_combat_formation(
            task_id=task_id,
            min_win_ratio=max(1.0, float(safety_multiplier)),
        )
        return res["army_payload"] if res.get("ok") else []

    def prepare_combat_hero(self, task_id: int = 0) -> List[Dict[str, int]]:
        """غلاف متوافق للخلف يجلب أقوى الأبطال المتاحين (بمن فيهم أبطال السور) عبر MarchManagerTask."""
        from tasks.march_manager import MarchManagerTask

        mgr = MarchManagerTask(self.conn, self.log)
        max_slots = self.get_max_battle_hero_num()
        heroes = mgr.get_available_heroes(exclude_defend=False)
        return [{"heroID": int(h["hero_id"])} for h in heroes[:max_slots]]

    async def execute_command_hall_battle_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 7.0,
        wait_for_return: bool = True,
    ) -> Dict[str, Any]:
        """
        إنجاز مهمة معركة فريق الغزاة (نوع 5) أو طليعة الغزاة (نوع 2) بفيلق واحد فقط بالتسلسل:
        1. الفحص القبلي للجاهزية (0-Network) والتأكد من عدم وجود مسير قاعة قيادة نشط بالخارج.
        2. تشكيل الفيلق عبر MarchManagerTask.build_combat_army_formation() + tasks/march_capacity.py
           (بأي جنود متاحين أقوياء أو ضعفاء طالما يحققون القتل المؤكد، ومنع الإرسال الخاسر).
        3. مزامنة موقع الهدف (CMD 2274/9) ثم إرسال المسير (CMD 1007/2) برقم المملكة الفعلي.
        4. الانتظار الديناميكي عبر الذاكرة الحية (NOTIFY_COMMAND_HALL / local_queues) حتى حسم المعركة.
        5. استلام الجائزة (CMD 2274/8) عند النجاح الفعلي فقط (بدون نجاح وهمي عند 716005).
        6. انتظار عودة الفيلق فعلياً إلى القلعة وتحديث الجنود والأبطال قبل السماح بالهجوم التالي.
        """
        from tasks.march_manager import MarchManagerTask

        if not isinstance(task, dict):
            return {"success": False, "reason": "كائن المهمة غير صالح أو مفقود."}

        task_id = self._safe_int(task.get("task_id") or task.get("taskID") or task.get("Index"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 0)
        if task_type == 0 and task_id > 0:
            task_type = task_id // 1000

        if task_type not in (2, 5):
            return {
                "success": False,
                "reason": f"هذه الدالة مخصصة لمهام المعارك والمسير (نوع 5 أو 2) وليست للنوع {task_type}.",
            }

        if task_index <= 0:
            return {"success": False, "reason": "معرف مؤشر المهمة (index) غير صالح."}

        pos = task.get("pos") or {}
        if not isinstance(pos, dict) or not pos.get("x") or not pos.get("y"):
            obj = task.get("obj") or (task.get("raw", {}).get("obj") if isinstance(task.get("raw"), dict) else {})
            if isinstance(obj, dict) and obj.get("x") and obj.get("y"):
                pos = {"x": self._safe_int(obj.get("x")), "y": self._safe_int(obj.get("y"))}

        target_x = self._safe_int(pos.get("x"))
        target_y = self._safe_int(pos.get("y"))
        if target_x <= 0 or target_y <= 0:
            return {"success": False, "reason": "إحداثيات هدف المعركة غير متوفرة على الخريطة."}

        mgr = MarchManagerTask(self.conn, self.log)
        spec = self.get_command_hall_task_spec(task_id)
        stamina_cost = self._safe_int(task.get("stamina_cost"), spec["consume"])
        if stamina_cost <= 0:
            stamina_cost = spec["consume"]
        task_title = "طليعة الغزاة" if task_type == 2 else "فريق الغزاة"

        # دالة مساعدة: فحص وجود مسير قاعة قيادة نشط في local_queues (0-Network)
        def _find_ch_queue(valid_coords: Optional[Set[Tuple[int, int]]] = None) -> Optional[Tuple[Dict[str, Any], int]]:
            for q, st in mgr._iter_my_active_queues():
                ml_type = self._safe_int(q.get("moveLineType"), 0)
                q_type = self._safe_int(q.get("type") or q.get("queueType"), 0)
                to_obj = q.get("to") if isinstance(q.get("to"), dict) else {}
                qx = self._safe_int(to_obj.get("x") or q.get("target_x"), -1)
                qy = self._safe_int(to_obj.get("y") or q.get("target_y"), -1)
                if valid_coords and (qx, qy) in valid_coords:
                    return q, st
                if ml_type == 15 or q_type == 15:
                    return q, st
            return None

        # دالة مساعدة: قراءة حالة المهمة الحية من الذاكرة (محدّثة بـ NOTIFY_COMMAND_HALL 608)
        def _get_live_task_statue() -> int:
            for ctrl_key in ("commandHallCtrl", "commandHall"):
                hall = self.get_ctrl(ctrl_key)
                if not isinstance(hall, dict):
                    continue
                pioneer = hall.get("armyPioneerTaskData")
                if isinstance(pioneer, dict) and self._safe_int(pioneer.get("index"), 0) == task_index:
                    return self._safe_int(pioneer.get("statue"), 0)
                for arr_key in ("commonTaskData", "taskList"):
                    arr = hall.get(arr_key)
                    items = arr.values() if isinstance(arr, dict) else (arr if isinstance(arr, list) else [])
                    for itm in items:
                        if isinstance(itm, dict) and self._safe_int(itm.get("index"), 0) == task_index:
                            return self._safe_int(itm.get("statue"), 0)
            return -1

        # 1. تطبيق قاعدة "فيلق واحد فقط": إذا كان هناك مسير قاعة قيادة نشط ننتظر عودته أولاً
        if _find_ch_queue() is not None:
            self.log(f"⏳ [قاعة القيادة] يوجد فيلق قاعة قيادة نشط حالياً — انتظار عودته قبل إرسال {task_title} #{task_index}...")
            pre_deadline = time.monotonic() + 60.0
            while time.monotonic() < pre_deadline:
                if _find_ch_queue() is None:
                    await mgr.sleep_interruptible(0.6)
                    break
                if not await mgr.sleep_interruptible(0.5, deadline=pre_deadline):
                    return {"success": False, "disconnected": not self.is_connected, "reason": "انقطع الاتصال أو انتهت مهلة انتظار عودة الفيلق السابق."}

        avail_marches = self.get_available_marches_count()
        if avail_marches <= 0:
            return {
                "success": False,
                "reason": "لا توجد طوابير مسير شاغرة حالياً (كافة الفيالق نشطة بالخارج).",
            }

        if self.stamina < stamina_cost:
            return {
                "success": False,
                "reason": f"طاقة اللورد غير كافية ({self.stamina} متوفر | المطلوب: {stamina_cost}).",
            }

        # 2. تشكيل الفيلق القتالي عبر MarchManagerTask + march_capacity.py (أي جنود متاحين يكفون للقتل)
        form_res = self.prepare_command_hall_combat_formation(
            task_id=task_id,
            min_win_ratio=1.20,
            max_win_ratio=3.5,
        )
        if not form_res.get("ok") or not form_res.get("can_kill"):
            reason_msg = form_res.get("reason") or "تشكيلة القلعة الحالية غير كافية لقتل الهدف بشكل مؤكد."
            self.log(f"⏭️ [قاعة القيادة] تخطي {task_title} #{task_index} (ID: {task_id}): {reason_msg}")
            return {
                "success": False,
                "skipped_unbeatable": True,
                "error_code": form_res.get("error_code", "CANNOT_KILL"),
                "reason": reason_msg,
            }

        selected_troops = form_res["army_payload"]
        selected_heroes = form_res["hero_payload"]
        hero_ids_str = ", ".join(str(h["heroID"]) for h in selected_heroes)
        hero_log_str = f" مع الأبطال ({hero_ids_str})" if selected_heroes else " (بدون أبطال)"
        total_troops_num = form_res["total_soldiers"]
        win_ratio = form_res["win_ratio"]
        max_cap = form_res["max_capacity"]

        # 3. مزامنة موقع الـ NPC على الخريطة (CMD 2274/9)
        fresh_server_x = target_x
        fresh_server_y = target_y
        ref_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_REFRESH_POS,
            {"x": target_x, "y": target_y},
            min_delay=0.3,
            max_delay=0.6,
        )
        if isinstance(ref_resp, dict):
            rspdata = ref_resp.get("rspdata")
            if isinstance(rspdata, dict) and rspdata.get("x") and rspdata.get("y"):
                fresh_server_x = self._safe_int(rspdata.get("x"))
                fresh_server_y = self._safe_int(rspdata.get("y"))

        tile_x = fresh_server_x - 1
        tile_y = fresh_server_y - 1
        valid_coords = {(tile_x, tile_y), (fresh_server_x, fresh_server_y)}
        kid = int(self.kingdom_id)

        self.log(
            f"⚔️ [قاعة القيادة] إرسال فيلق معركة لمهمة {task_title} #{task_index} (ID: {task_id}) "
            f"نحو ({tile_x}, {tile_y}) [المملكة: {kid}] — جنود: {total_troops_num:,}/{max_cap:,} "
            f"(قوة: {win_ratio:.2f}×){hero_log_str}..."
        )

        # 4. بناء حزمة إرسال المسير الرسمية (CMD 1007/2) برقم المملكة الفعلي
        march_payload = {
            "moveLineType": 15,  # moveLineTypeCommandHallNpc
            "matrixType": 1,     # moveLineMatrixTypeTroop
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
                "mapId": kid,
                "isDuel": False,
                "isKillLeaderNpc": False,
                "killNormalNpcLv": 0,
                "isForbidSpeed": False,
                "isSecondaryLock": False,
            },
        }

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

        # انتظار قصير لظهور الطابور في local_queues ثم تقدير زمن الذهاب الحقيقي
        await mgr.sleep_interruptible(0.8)
        timing = mgr.estimate_march_duration(
            march_type="attack",
            dispatch_response=march_resp,
            target_x=tile_x,
            target_y=tile_y,
        )
        go_sec = max(float(wait_seconds), float(timing.get("go_seconds", 0.0)))
        settle_timeout = max(20.0, go_sec + 15.0)
        settle_deadline = time.monotonic() + settle_timeout

        self.log(
            f"🏹 [قاعة القيادة] انطلق الفيلق نحو ({tile_x}, {tile_y}) — "
            f"متابعة الحسم حياً (زمن الذهاب المقدر: {go_sec:.0f}ث | مهلة قصوى: {settle_timeout:.0f}ث)..."
        )

        # 5. الانتظار الديناميكي لحسم المعركة عبر الذاكرة الحية (NOTIFY_COMMAND_HALL + local_queues)
        saw_queue = _find_ch_queue(valid_coords) is not None
        min_hit_time = time.monotonic() + min(4.0, go_sec * 0.5)

        while time.monotonic() < settle_deadline:
            live_statue = _get_live_task_statue()
            if live_statue == 3:
                break

            q_match = _find_ch_queue(valid_coords)
            if q_match is not None:
                saw_queue = True
                _q, q_st = q_match
                # الحالة 2 تعني أن الفيلق بدأ طريق العودة بعد الاشتباك
                if q_st == 2 and time.monotonic() >= min_hit_time:
                    await mgr.sleep_interruptible(1.0)
                    break
            elif saw_queue and time.monotonic() >= min_hit_time:
                # اختفى الطابور (عاد للقلعة فعلياً)
                await mgr.sleep_interruptible(0.8)
                break

            if not await mgr.sleep_interruptible(0.5, deadline=settle_deadline):
                if not self.is_connected or getattr(self.conn, "is_other_device", False) or getattr(self.conn, "is_sealed", False):
                    return {
                        "success": False,
                        "disconnected": True,
                        "reason": "انقطع الاتصال ببوابة اللعبة أثناء انتظار حسم المعركة.",
                    }
                break

        # 6. استلام الجائزة عبر CMD 2274/8 (بدون تسجيل نجاح وهمي عند 716005)
        rewards: List[Any] = []
        claim_resp = None
        claim_success = False
        live_statue = _get_live_task_statue()

        # نطلب التسليم إذا أصبحت المهمة 3 أو لم تصل إشارة حالة بعد
        claim_payload = {"commitType": task_type, "index": task_index}
        self.log(f"🎁 [قاعة القيادة] استلام جوائز معركة {task_title} #{task_index}...")
        claim_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            claim_payload,
            min_delay=0.5,
            max_delay=1.0,
        )
        if isinstance(claim_resp, dict) and str(claim_resp.get("err", claim_resp.get("code", "0"))).strip() in ("0", "Err_None"):
            claim_success = True
        else:
            # إعادة محاولة واحدة فقط بعد مهلة قصيرة في حال تأخر الحسم بثوانٍ
            err_first = str(claim_resp.get("err", "") if isinstance(claim_resp, dict) else "").strip()
            if err_first == "716005" and _find_ch_queue(valid_coords) is not None:
                await mgr.sleep_interruptible(3.0)
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
            rspdata = claim_resp.get("rspdata") if isinstance(claim_resp, dict) else None
            if isinstance(rspdata, dict) and "reward" in rspdata:
                rewards = rspdata.get("reward") or []
            elif isinstance(claim_resp, dict) and "reward" in claim_resp:
                rewards = claim_resp.get("reward") or []

            # تحديث الذاكرة الحية (كلا المفتاحين commandHall و commandHallCtrl)
            init_data = rspdata.get("initData") if isinstance(rspdata, dict) else None
            if isinstance(init_data, dict):
                self._sync_command_hall_init_data(init_data)
            else:
                self._mark_command_hall_task_claimed(task_index, task_type)

            self._record_command_hall_subtask_completion(1)
            self.log(f"✅ [قاعة القيادة] تم حسم المعركة واستلام جوائز {task_title} #{task_index} بنجاح!")
        else:
            claim_err = claim_resp.get("err") if isinstance(claim_resp, dict) else "no_response"
            self.log(
                f"❌ [قاعة القيادة] لم تكتمل المعركة لمهمة {task_title} #{task_index} "
                f"(كود التسليم: {claim_err} | الحالة الحية: {live_statue})."
            )

        # 7. قاعدة "فيلق واحد فقط": انتظار عودة الفيلق فعلياً إلى القلعة قبل السماح بالهجوم التالي
        if wait_for_return and _find_ch_queue(valid_coords) is not None:
            return_timeout = max(25.0, go_sec * 1.5 + 15.0)
            return_deadline = time.monotonic() + return_timeout
            self.log(f"🔄 [قاعة القيادة] انتظار عودة الفيلق إلى القلعة قبل الهجوم التالي (مهلة قصوى: {return_timeout:.0f}ث)...")
            while time.monotonic() < return_deadline:
                if _find_ch_queue(valid_coords) is None:
                    # مهلة قصيرة لوصول إشعار عودة الجنود والأبطال (NOTIFY_ARMY / NOTIFY_HERO_SYS)
                    await mgr.sleep_interruptible(0.8)
                    self.log(f"🏰 [قاعة القيادة] عاد الفيلق إلى القلعة وأصبح جاهزاً للهجوم التالي.")
                    break
                if not await mgr.sleep_interruptible(0.5, deadline=return_deadline):
                    break

        return {
            "success": claim_success,
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
            "reason": "" if claim_success else f"فشل تسليم أو حسم المعركة (كود السيرفر: {claim_resp.get('err') if isinstance(claim_resp, dict) else 'no_response'}).",
            "message": f"تم إنجاز معركة {task_title} #{task_index} واستلام الجوائز بنجاح." if claim_success else f"فشلت معركة {task_title} #{task_index} ولم تُستلم الجائزة.",
        }

    async def _execute_command_hall_instant_task(
        self,
        task: Dict[str, Any],
        expected_type: int,
        title_ar: str,
        icon: str,
        err_label: str,
        success_msg: str,
        wait_seconds: float,
        sim_jitter: Optional[Tuple[float, float]] = None,
        min_safety_stamina: int = 10,
        strict_type: bool = False,
    ) -> Dict[str, Any]:
        """
        منفّذ موحّد للمهام الفورية بقاعة القيادة (القناص 6، إنقاذ القرويين 4، المعلومات العسكرية 3):
        - فحص 0-Network المسبق للصلاحية والنوع وحد أمان الطاقة (consume = 5 وفق newcommandhalltask.lua).
        - التخطي الآمن لطلب الإنهاء (2274/5) عند اكتمال المهمة مسبقاً (statue == 3) بدون خصم طاقة إضافي.
        - تثبيت الإنجاز واستلام الجوائز عبر (2274/8) وتحديث الذاكرة الحية بالكامل.
        """
        if not isinstance(task, dict):
            return {"success": False, "reason": "كائن المهمة غير صالح أو مفقود."}

        task_id = self._safe_int(task.get("task_id") or task.get("taskID") or task.get("Index") or task.get("id"), 0)
        task_index = self._safe_int(task.get("index"), 0)
        task_type = self._safe_int(task.get("type"), 0)
        if task_type == 0 and task_id > 0:
            task_type = task_id // 1000
        if task_type == 0 and not strict_type:
            task_type = expected_type

        if task_type != expected_type:
            if strict_type:
                return {
                    "success": False,
                    "reason": f"هذه الدالة مخصصة حصراً لمهام {title_ar} (نوع {expected_type}) وليست للنوع {task_type}.",
                }
            self.log(f"⚠️ [قاعة القيادة] تحذير: نوع المهمة (#{task_index}) هو {task_type} وليس {expected_type} ({title_ar}).")

        if task_index <= 0:
            return {
                "success": False,
                "reason": f"رقم فهرس المهمة غير صالح (index={task_index})" if not strict_type else "معرف مؤشر المهمة (index) غير صالح.",
                "task_id": task_id,
                "index": task_index,
            }

        statue = self._safe_int(task.get("statue"), 2)
        quality_name = task.get("quality_name_ar") or str(task.get("quality", ""))
        stamina_cost = self._safe_int(task.get("stamina_cost"), 5)
        if stamina_cost <= 0:
            stamina_cost = 5
        safe_margin = max(0, int(min_safety_stamina))

        current_stamina = self.stamina
        min_needed = stamina_cost + safe_margin
        if statue != 3 and current_stamina < min_needed:
            self.log(
                f"🛑 [قاعة القيادة] طاقة اللورد غير كافية لمهمة {title_ar} #{task_index} "
                f"({current_stamina} متوفر | المطلوب {min_needed} تشمل {safe_margin} حد أمان)."
            )
            return {
                "success": False,
                "reason": f"طاقة اللورد غير كافية ({current_stamina} < {min_needed})",
                "task_id": task_id,
                "index": task_index,
                "stamina_spent": 0,
            }

        self.log(
            f"{icon} [قاعة القيادة] بدء مهمة {title_ar} #{task_index} "
            f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
        )

        all_rewards: List[Dict[str, Any]] = []
        finish_resp: Optional[Dict[str, Any]] = None
        final_rspdata: Dict[str, Any] = {}

        if statue != 3:
            if sim_jitter is not None:
                sim_wait = max(0.5, float(wait_seconds) + random.uniform(sim_jitter[0], sim_jitter[1]))
            else:
                sim_wait = max(1.0, float(wait_seconds))
            await asyncio.sleep(sim_wait)

            finish_resp = await self.safe_query(
                CMD_COMMAND_HALL_MODULE,
                REQ_COMMAND_HALL_FINISH_TASK,
                {"index": task_index},
                min_delay=0.4,
                max_delay=0.8,
            )

            if not isinstance(finish_resp, dict) or str(finish_resp.get("err", finish_resp.get("code", "0"))).strip() not in ("0", "Err_None"):
                err_msg = finish_resp.get("err") if isinstance(finish_resp, dict) else "لم يرد استجابة من السيرفر"
                self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز {title_ar} #{task_index} (الخطأ: {err_msg}).")
                return {
                    "success": False,
                    "reason": f"فشل طلب إنهاء {err_label}: {err_msg}",
                    "response": finish_resp,
                    "task_id": task_id,
                    "index": task_index,
                    "stamina_spent": 0,
                }

            rspdata = finish_resp.get("rspdata") if isinstance(finish_resp, dict) else {}
            if isinstance(rspdata, dict):
                final_rspdata = rspdata
                if "reward" in rspdata:
                    all_rewards.extend(rspdata.get("reward") or [])
            elif isinstance(finish_resp, dict) and "reward" in finish_resp:
                all_rewards.extend(finish_resp.get("reward") or [])

        await asyncio.sleep(random.uniform(0.6, 1.2))
        commit_resp = await self.safe_query(
            CMD_COMMAND_HALL_MODULE,
            REQ_COMMAND_HALL_COMMIT_TASK,
            {"commitType": expected_type, "index": task_index},
            min_delay=0.4,
            max_delay=0.8,
        )

        commit_ok = isinstance(commit_resp, dict) and str(commit_resp.get("err", commit_resp.get("code", "0"))).strip() in ("0", "Err_None")
        if not commit_ok:
            if isinstance(final_rspdata, dict) and isinstance(final_rspdata.get("initData"), dict):
                self._sync_command_hall_init_data(final_rspdata["initData"])
            err_msg = commit_resp.get("err") if isinstance(commit_resp, dict) else "no_response"
            self.log(f"⚠️ [قاعة القيادة] فشل تسليم {err_label} #{task_index} (كود: {err_msg}).")
            return {
                "success": False,
                "task_id": task_id,
                "index": task_index,
                "task_type": expected_type,
                "stamina_spent": 0,
                "reason": f"فشل تسليم المهمة (2274/8): {err_msg}",
                "finish_response": finish_resp,
                "commit_response": commit_resp,
            }

        c_rspdata = commit_resp.get("rspdata") if isinstance(commit_resp, dict) else None
        if isinstance(c_rspdata, dict):
            final_rspdata = c_rspdata
            c_rewards = c_rspdata.get("reward") or []
            if c_rewards:
                all_rewards.extend(c_rewards)

        actual_stamina_spent = stamina_cost if statue != 3 else 0
        if actual_stamina_spent > 0:
            lord = self.get_ctrl("lordInfoCtrl")
            if isinstance(lord, dict) and isinstance(lord.get("base"), dict) and "health" in lord["base"]:
                lord["base"]["health"] = max(0, self._safe_int(lord["base"]["health"]) - actual_stamina_spent)

        init_data = final_rspdata.get("initData") if isinstance(final_rspdata, dict) else None
        if isinstance(init_data, dict):
            self._sync_command_hall_init_data(init_data)
        else:
            self._mark_command_hall_task_claimed(task_index, expected_type)

        self._record_command_hall_subtask_completion(1)
        self.log(
            f"✅ [قاعة القيادة] تم إنجاز مهمة {title_ar} #{task_index} واستلام {len(all_rewards)} جوائز بنجاح!"
        )

        return {
            "success": True,
            "task_id": task_id,
            "index": task_index,
            "task_type": expected_type,
            "stamina_spent": actual_stamina_spent,
            "rewards": all_rewards,
            "rewards_count": len(all_rewards),
            "message": success_msg,
            "finish_response": finish_resp,
            "commit_response": commit_resp,
        }

    async def execute_command_hall_snipe_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 2.5,
        min_safety_stamina: int = 10,
    ) -> Dict[str, Any]:
        """
        إنجاز مهمة القناص الصامت (SNIPE_HUNTER_TASK - النوع 6) بقاعة القيادة:
        - consume = 5 (وفق newcommandhalltask.lua: 6001..6093 و CommandHallTaskPanel.lua).
        - فحص 0-Network المسبق لطاقة اللورد وحد الأمان.
        - إنهاء (2274/5) ثم استلام الجوائز والتثبيت (2274/8) ومزامنة الذاكرة الحية.
        """
        idx = self._safe_int(task.get("index"), 0) if isinstance(task, dict) else 0
        return await self._execute_command_hall_instant_task(
            task=task,
            expected_type=6,
            title_ar="القناص الصامت",
            icon="🎯",
            err_label="مهمة القناص",
            success_msg=f"تم إنجاز مهمة القناص الصامت #{idx} واستلام الجوائز بنجاح.",
            wait_seconds=wait_seconds,
            sim_jitter=None,
            min_safety_stamina=min_safety_stamina,
            strict_type=True,
        )

    async def execute_command_hall_rescue_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 2.2,
        min_safety_stamina: int = 10,
    ) -> Dict[str, Any]:
        """
        تنفيذ مهمة إنقاذ القرويين (RESCUE_TASK - النوع 4) من مهام قاعة القيادة (consume = 5).
        """
        idx = self._safe_int(task.get("index"), 0) if isinstance(task, dict) else 0
        return await self._execute_command_hall_instant_task(
            task=task,
            expected_type=4,
            title_ar="إنقاذ القرويين",
            icon="🤝",
            err_label="مهمة الإنقاذ",
            success_msg=f"تم إنجاز مهمة إنقاذ القرويين #{idx} بنجاح واستلام الجوائز.",
            wait_seconds=wait_seconds,
            sim_jitter=(-0.2, 0.3),
            min_safety_stamina=min_safety_stamina,
            strict_type=False,
        )

    async def execute_command_hall_dialogue_task(
        self,
        task: Dict[str, Any],
        wait_seconds: float = 1.5,
        min_safety_stamina: int = 10,
    ) -> Dict[str, Any]:
        """
        تنفيذ مهمة المعلومات العسكرية (DIALOGUE_TASK - النوع 3) من مهام قاعة القيادة (consume = 5).
        """
        idx = self._safe_int(task.get("index"), 0) if isinstance(task, dict) else 0
        return await self._execute_command_hall_instant_task(
            task=task,
            expected_type=3,
            title_ar="المعلومات العسكرية",
            icon="📜",
            err_label="مهمة المعلومات العسكرية",
            success_msg=f"تم إنجاز مهمة المعلومات العسكرية #{idx} بنجاح واستلام الجوائز.",
            wait_seconds=wait_seconds,
            sim_jitter=(-0.3, 0.3),
            min_safety_stamina=min_safety_stamina,
            strict_type=False,
        )

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
        hall_data = self._get_command_hall_ctrl()
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
            self._sync_command_hall_init_data(new_init)
        else:
            self._mark_command_hall_task_claimed(task_index, 1)

        new_legion_id = new_init.get("armyGroupID") if isinstance(new_init, dict) else "محدث"
        new_tasks_count = len(new_init.get("commonTaskData", [])) if isinstance(new_init, dict) else 0

        self._record_command_hall_subtask_completion(1)
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
        hall_data = self._get_command_hall_ctrl()
        if not isinstance(hall_data, dict):
            return {"success": False, "reason": "بيانات قاعة القيادة غير متوفرة في الذاكرة الحية."}

        initial_lv = self._safe_int(hall_data.get("commandLv"), 1)
        cur_lv = initial_lv
        upgrades_done = 0
        all_rewards: List[Dict[str, Any]] = []

        for _ in range(max(1, max_upgrades)):
            cur_exp = self._safe_int(hall_data.get("commandExp"), 0)
            need_exp = self.get_command_hall_need_exp(cur_lv)

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
                hall_data = self._sync_command_hall_init_data(new_init) or new_init
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
            if isinstance(extra, str):
                s_extra = extra.strip()
                if s_extra.startswith("{"):
                    try:
                        extra = json.loads(s_extra)
                    except Exception:
                        extra = None
                else:
                    m = re.search(r'bid_(\d+)_iid_(\d+)', s_extra)
                    if m:
                        b_bid = int(m.group(1))
                        b_iid = int(m.group(2))
            if isinstance(extra, dict):
                b_bid = extra.get("bid")
                b_iid = extra.get("iid")

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
            # السيرفر يُرسل البيانات داخل binfo أحياناً وأحياناً مباشرة في الكائن
            binfo = b_entry.get("binfo") or {}
            if not isinstance(binfo, dict):
                binfo = {}

            # الأولوية لـ binfo ثم المستوى الخارجي لـ b_entry
            def _get_b(field: str, default=0):
                v = binfo.get(field)
                if v is None:
                    v = b_entry.get(field)
                return v if v is not None else default

            bid = int(_get_b("bid") or 0)
            if bid not in RESOURCE_BUILDING_METADATA:
                continue

            meta = RESOURCE_BUILDING_METADATA[bid]
            r_type = meta["resource"]
            if filter_res is not None and r_type != filter_res:
                continue

            iid = int(_get_b("iid") or 0)
            lv = int(_get_b("lv") or _get_b("level") or 0)
            star_lv = int(_get_b("starLv") or 0)
            idx = int(_get_b("index") or 0)
            cur_res = float(_get_b("curres") or 0.0)
            state = int(_get_b("state") or 0)

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

    # ═════════════════════════════════════════════════════════════════════════
    # محرك حساب سعة المسيرة القصوى للفيلق الواحد (Single March Troop Limit)
    # مطابقة 100% لكود سورس اللعبة الأصلي (buildLogic.lua & WorldDispatchArmyViewPanel.lua)
    # ═════════════════════════════════════════════════════════════════════════

    def get_max_battle_hero_num(self) -> int:
        """
        حساب عدد خانات الأبطال المفتوحة للقتال والمسيرات بحسب مستوى القلعة (0-Network Direct Read).
        مطابق 100% لكود سورس اللعبة: heroCtrl:getMaxBattleHeroNum() و constantRead (HIRED_HEROES_%d_LV).
        
        مستويات فك قفل الخانات الخمس (1..5):
          - الخانة 1: قلعة مستوى 1
          - الخانة 2: قلعة مستوى 5
          - الخانة 3: قلعة مستوى 10
          - الخانة 4: قلعة مستوى 15
          - الخانة 5: قلعة مستوى 18 (الحد الأقصى للنظام = 5 خانات)
        """
        castle_lv = int(self.castle_level or 1)
        slot_thresholds = (1, 5, 10, 15, 18)
        return sum(1 for req in slot_thresholds if castle_lv >= req)

    def get_best_march_heroes(
        self,
        num_heroes: Optional[int] = None,
        need_available: bool = False,
    ) -> List[Dict[str, Any]]:
        """
        استخراج وترتيب أفضل أبطال القلعة لقيادة الفيالق والمسيرات بأعلى سعة ممكنة (0-Network Direct Read).
        مطابقة تامة لمنطق الترتيب الرسمي للعبة:
          - heroCtrl:sortDispatchHerosID(heros, states, isCompareLie)
          - heroltCtrl:getHerosMarchCapacity(heros)
          - WorldDispatchArmyViewPanel:quickChoose_hero() -> nodeHero:autoFillHeros()
        
        معايير الترتيب التنازلي الرسمي (heroCtrl:sortDispatchHerosID):
          1. حالة البطل (متاح داخل القلعة State=1 أولاً -> lData.V > rData.V).
          2. امتلاك البطل لمساعد/زي مرافق (own_lieutenant -> lData.ownL).
          3. إجمالي الزيادة في سعة المسيرة (سعة المستوى + مهارات المعركة النشطة Effect 96 -> lData.MarchNum > rData.MarchNum).
          4. مستوى البطل (level -> lData.data.level > rData.data.level).
          5. ندرة البطل المتأصلة (Rarity 1..5 من heroltCtrl.herosInfo -> lData.Rarity > rData.Rarity).
          6. ترقية البطل (quality 1..5 -> lData.data.quality > rData.data.quality).
          7. معرف البطل الأصغر (heroID -> lData.data.heroID < rData.data.heroID).
        
        :param num_heroes: عدد الأبطال المطلوب استخراجهم. إذا ترك None، يؤخذ السقف المتاح للقلعة (get_max_battle_hero_num).
        :param need_available: إذا كان True، يُشترط أن يكون البطل متاحاً وشاغراً داخل القلعة (State=1).
        :return: قائمة قواميس الأبطال الأفضل مرتبة تنازلياً.
        """
        tables = _load_march_data_tables()
        rare_levels = tables.get("rare_levels", {})
        hero_configs = tables.get("heroes", {})

        hero_sys = self.get_ctrl("heroSysCtrl") or {}
        hero_list = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
        if not hero_list:
            return []

        candidates: List[Dict[str, Any]] = []
        for hid_str, h_data in hero_list.items():
            if not isinstance(h_data, dict):
                continue
            hid = int(hid_str) if str(hid_str).isdigit() else 0
            state = int(h_data.get("state", 1) or 1)
            is_normal = (state == 1)
            if need_available and not is_normal:
                continue

            lv = int(h_data.get("level", 1) or 1)
            cfg = hero_configs.get(str(hid), hero_configs.get(hid, {}))
            meta = OFFICIAL_HERO_CATALOG.get(hid, {})
            quality = int(h_data.get("quality") or 0)

            # الرتبة الفعالة للبطل بسعة المسيرة: جودة البطل/نجومه (quality 1..5) أو ندرته المتأصلة
            rarity = int(cfg.get("rarity") or meta.get("rarity") or h_data.get("rarity") or 1)
            effective_tier = quality if quality > 0 else rarity
            name = meta.get("name_ar") or meta.get("name") or cfg.get("name", f"Hero_{hid}")

            # فحص امتلاك مساعد أو زي (heroCtrl:isOwnLieutenantByHeroID)
            dress = h_data.get("dress", {})
            cur_dress = self._safe_int(dress.get("seting") if isinstance(dress, dict) else 0)
            own_l = bool(cur_dress > 0 and cur_dress % 100 > 1)

            str_tier = str(effective_tier)
            str_hlv = str(lv)
            r_lvs = rare_levels.get(str_tier, rare_levels.get(effective_tier, {}))
            base_march = int(r_lvs.get(str_hlv, r_lvs.get(lv, 0)))

            skill_add = 0
            skills = h_data.get("skillList", {})
            if isinstance(skills, dict):
                for _, s_info in skills.items():
                    if isinstance(s_info, dict) and s_info.get("isActive"):
                        st = int(s_info.get("skillType", 0) or 0)
                        if st in HERO_MARCH_SKILLS_BY_QUALITY:
                            skill_add += get_hero_battle_skill_march_add(st, quality)
                        elif st in HERO_MARCH_SKILLS_VAL:
                            skill_add += HERO_MARCH_SKILLS_VAL[st]

            total_h = base_march + skill_add
            candidates.append({
                "hero_id": hid,
                "name": name,
                "level": lv,
                "quality": quality,
                "rarity": rarity,
                "effective_tier": effective_tier,
                "state": state,
                "is_normal": is_normal,
                "own_l": own_l,
                "level_march_add": base_march,
                "skill_march_add": skill_add,
                "total_hero_add": total_h,
            })

        # الترتيب التنازلي الرسمي للعبة (heroCtrl:sortDispatchHerosID)
        if need_available:
            candidates.sort(
                key=lambda h: (
                    1 if h["is_normal"] else 0,
                    1 if h["own_l"] else 0,
                    h["total_hero_add"],
                    h["level"],
                    h["effective_tier"],
                    h["quality"],
                    -h["hero_id"],
                ),
                reverse=True,
            )
        else:
            candidates.sort(
                key=lambda h: (
                    h["total_hero_add"],
                    h["level"],
                    h["effective_tier"],
                    1 if h["own_l"] else 0,
                    h["quality"],
                    -h["hero_id"],
                ),
                reverse=True,
            )

        limit = num_heroes if num_heroes is not None else self.get_max_battle_hero_num()
        return candidates[:max(0, limit)]

    # ═════════════════════════════════════════════════════════════════════════
    # دوال جلب بيانات حساب سعة المسيرة القصوى (March Capacity Data Getters)
    # ═════════════════════════════════════════════════════════════════════════

    def get_drill_grounds_base_capacity(self) -> Dict[str, Any]:
        """
        1. دالة جلب بيانات ساحة التدريب الأساسية (Base) من الذاكرة الحية (cityCtrl).
        ══════════════════════════════════════════════════════════════════════════
        المعادلة في سورس كود اللعبة (buildLogic.lua):
            base = buildLogic.getBuildBaseValue(BUILDID.DRILL_GROUDS, "capacity", bcell)
            BUILDID.DRILL_GROUDS = 121 (ساحة التدريب / Drill Grounds)

        تستخرج من الذاكرة الحية (conn.init_data['cityCtrl']['blist']):
            - lv: المستوى العادي للمبنى (1 إلى 130) -> يطابق مع جدول build121.lua
            - starLv: مستوى نجوم الكرامة للمبنى (1 إلى 70) -> يطابق مع جدول buildstar121.lua

        Returns:
            Dict[str, Any]:
                - bid (int): معرّف المبنى (121)
                - name (str): اسم المبنى ("ساحة التدريب")
                - lv (int): مستوى المبنى العادي
                - star_lv (int): مستوى نجوم الكرامة
                - base_capacity (int): السعة الأساسية للمستوى العادي
                - star_capacity (int): السعة الإضافية لنجوم الكرامة
                - total_base_capacity (int): السعة الإجمالية الأساسية Base
                - found (bool): هل تم العثور على المبنى في الذاكرة الحية
        """
        b121_lv = 0
        b121_star = 0
        found = False

        city_ctrl = self.get_ctrl("cityCtrl") or {}
        blist = city_ctrl.get("blist", []) if isinstance(city_ctrl, dict) else []

        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                # قد يكون كائن المبنى مغلفاً داخل binfo أو مباشراً في b
                binfo = b.get("binfo") if isinstance(b.get("binfo"), dict) else b
                if str(binfo.get("bid")) == str(DRILL_GROUNDS_BUILDING_ID):
                    b121_lv = self._safe_int(binfo.get("lv", 0))
                    b121_star = self._safe_int(binfo.get("starLv", 0))
                    found = True
                    break

        # استخراج السعة من الجداول الثابتة المطابقة لسورس كود اللعبة (build121.lua & buildstar121.lua)
        base_building_cap = int(DRILL_GROUNDS_CAPACITY.get(b121_lv, 0))
        star_building_cap = int(DRILL_GROUNDS_STAR_CAPACITY.get(b121_star, 0))
        total_base_capacity = base_building_cap + star_building_cap

        return {
            "bid": DRILL_GROUNDS_BUILDING_ID,
            "name": "ساحة التدريب",
            "lv": b121_lv,
            "star_lv": b121_star,
            "base_capacity": base_building_cap,
            "star_capacity": star_building_cap,
            "total_base_capacity": total_base_capacity,
            "found": found,
        }

    def get_leadership_technology_additions(self) -> Dict[str, Any]:
        """
        2. دالة جلب إضافات أبحاث القيادة العسكرية (Tech Add) من الذاكرة الحية (technologyCtrl).
        ══════════════════════════════════════════════════════════════════════════════════════
        المعادلة في سورس كود اللعبة (buildLogic.lua):
            tech_add = technologyCtrl:getTechnologyPower(gTechnologyType.SINGLE_TROOP_STRENGTH)
            gTechnologyType.SINGLE_TROOP_STRENGTH = 43

            techGroupAdd = CONQUEST_WAR (73) + PYRAMID (77) + LEGEND (95)

        تستخرج من الذاكرة الحية (conn.init_data['technologyCtrl']):
            - معرفات الأبحاث المنجزة ومستوياتها (tid, level)
            - مطابقة الأبحاث مع جداول اللعبة (march_data_tables.json / LEADERSHIP_TECH_ADDITIONS)
            - استخراج الزيادة العددية المباشرة للجنود (Buff Type 43)
            - استخراج مضاعفات علوم الفعاليات الخاصة (Buff Types 73, 77, 95)

        Returns:
            Dict[str, Any]:
                - total_tech_add (int): إجمالي الجنود المضافين مباشرة (Flat Troops)
                - researched_count (int): عدد أبحاث القيادة المنجزة
                - details (List[Dict[str, Any]]): تفاصيل كل بحث قيادة منجز
                - tech_group_multiplier (float): نسبة الزيادة المئوية لعلوم الحروب الخاصة
                - tech_group_details (List[Dict[str, Any]]): تفاصيل أبحاث الحروب الخاصة
        """
        tech_ctrl = self.get_ctrl("technologyCtrl") or {}
        tech_add = 0
        tech_group_multiplier = 0.0
        tech_details: List[Dict[str, Any]] = []
        tech_group_details: List[Dict[str, Any]] = []

        tables = _load_march_data_tables()
        tech_tables = tables.get("techs", {})

        if isinstance(tech_ctrl, dict):
            for tid_key, tdata in tech_ctrl.items():
                if isinstance(tdata, (list, tuple)) and len(tdata) >= 2:
                    tid = self._safe_int(tdata[0])
                    tlv = self._safe_int(tdata[1])
                elif isinstance(tdata, (int, str)):
                    tid = self._safe_int(tid_key)
                    tlv = self._safe_int(tdata)
                else:
                    continue

                if tid <= 0 or tlv <= 0:
                    continue

                t_info = tech_tables.get(str(tid), {})
                lv_info = t_info.get(str(tlv))

                if lv_info and isinstance(lv_info, dict):
                    bt = lv_info.get("buff_type")
                    pw = lv_info.get("power", 0)
                    bnt = lv_info.get("buff_num_type", 1)
                    if bt == 43:
                        cardinal = 1 if bnt == 2 else 1000
                        val = int(pw / cardinal)
                        tech_add += val
                        tech_details.append({"tech_id": tid, "level": tlv, "buff_type": bt, "power": val})
                    elif bt in (73, 77, 95):
                        val_pct = pw / 1000.0
                        tech_group_multiplier += val_pct
                        tech_group_details.append({"tech_id": tid, "level": tlv, "buff_type": bt, "multiplier": val_pct})
                elif lv_info and isinstance(lv_info, (list, tuple)) and len(lv_info) >= 3:
                    pw, bt, bnt = lv_info[0], lv_info[1], lv_info[2]
                    if bt == 43:
                        cardinal = 1 if bnt == 2 else 1000
                        val = int(pw / cardinal)
                        tech_add += val
                        tech_details.append({"tech_id": tid, "level": tlv, "buff_type": bt, "power": val})
                    elif bt in (73, 77, 95):
                        val_pct = pw / 1000.0
                        tech_group_multiplier += val_pct
                        tech_group_details.append({"tech_id": tid, "level": tlv, "buff_type": bt, "multiplier": val_pct})
                elif tid in LEADERSHIP_TECH_ADDITIONS:
                    val = LEADERSHIP_TECH_ADDITIONS[tid].get(tlv, 0)
                    if val > 0:
                        tech_add += val
                        tech_details.append({"tech_id": tid, "level": tlv, "buff_type": 43, "power": val})
                elif tid in TECH_GROUP_MARCH_PERCENT:
                    tg_info = TECH_GROUP_MARCH_PERCENT[tid]
                    pw = tg_info["levels"].get(tlv, 0)
                    if pw > 0:
                        val_pct = pw / 1000.0
                        tech_group_multiplier += val_pct
                        tech_group_details.append({
                            "tech_id": tid,
                            "level": tlv,
                            "buff_type": tg_info["buff_type"],
                            "multiplier": val_pct,
                        })

        return {
            "total_tech_add": tech_add,
            "researched_count": len(tech_details),
            "details": tech_details,
            "tech_group_multiplier": tech_group_multiplier,
            "tech_group_details": tech_group_details,
        }

    def get_active_march_buffs(
        self,
        is_mass: bool = False,
        move_line_type: Optional[int] = None,
    ) -> Dict[str, Any]:
        """
        3. دالة جلب بافات المسيرة النشطة (الرقمية والمئوية) من الذاكرة الحية (buffCtrl).
        ══════════════════════════════════════════════════════════════════════════════
        المعادلة في سورس كود اللعبة (buildLogic.lua):
            buff_value_add = buffCtrl:getBuffEffect(gBuffEffect.MARCH_VALUE_LIMIT_BOOST) or 0
            buff_percent_add = (buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST) or 0) / 1000

            وفي حالة مسيرات الحشد (Mass March):
            meteriteMagicAdd = buffCtrl:getBuffEffect(gBuffEffect.MASS_MARCH_VALUE_LIMIT_BOOST) or 0
            meteriteMagicAddPercent = (buffCtrl:getBuffEffect(gBuffEffect.MASS_MARCH_LIMIT_BOOST) or 0) / 1000

        تستخرج من الذاكرة الحية (conn.init_data['buffCtrl']):
            - فحص البافات السارية زمنيًا (beginTime + time > now_timestamp)
            - فحص تأثيرات المسيرة الرقمية (EffectType 96) والنسبية (EffectType 19)
            - فحص تأثيرات مسيرات الحشد (EffectType 737 و EffectType 736) إن طُلبت

        Returns:
            Dict[str, Any]:
                - buff_flat_val (int): مجموع الزيادات العددية المباشرة للجنود (Flat Troops)
                - buff_percent_permille (int): مجموع النسب المئوية مقاسة بالألف (Permille)
                - buff_percent_add (float): النسبة المئوية العشرية (Permille / 1000.0)
                - is_mass_march (bool): هل تم فحص بافات الحشد
                - active_buff_count (int): عدد بافات المسيرة النشطة
                - details (List[Dict[str, Any]]): تفاصيل البافات النشطة (معرفها، نوعها، قيمتها، وقتها المتبقي)
        """
        now_ts = int(time.time())
        buff_flat_val = 0
        buff_percent_permille = 0
        active_buff_details: List[Dict[str, Any]] = []

        # فحص خطوط الحشد (Mass March Lines)
        is_mass_march = is_mass or (
            move_line_type in (7, 8, 9, 13, 14, 21, 29, 30, 36, 38, 48, 53, 56)
        )

        buff_ctrl = self.get_ctrl("buffCtrl") or []
        if isinstance(buff_ctrl, list):
            for bi in buff_ctrl:
                if not isinstance(bi, dict):
                    continue
                bt_start = self._safe_int(bi.get("beginTime", 0))
                dur = self._safe_int(bi.get("time", 0))
                if dur > 0 and (bt_start + dur) < now_ts:
                    continue

                remaining_sec = max(0, (bt_start + dur) - now_ts) if dur > 0 else -1
                bid = self._safe_int(bi.get("id") or bi.get("buffID"))
                et = self._safe_int(bi.get("effectType"))
                val = self._safe_int(bi.get("val") or bi.get("effect") or 0)

                if et == 0 and bid in KNOWN_MARCH_BUFFS:
                    et, val = KNOWN_MARCH_BUFFS[bid]

                if et == 19:  # MARCH_LIMIT_BOOST (%)
                    buff_percent_permille += val
                    active_buff_details.append({
                        "buff_id": bid,
                        "effect_type": 19,
                        "effect_name": "MARCH_LIMIT_BOOST (%)",
                        "value_permille": val,
                        "percent": val / 10.0,
                        "remaining_sec": remaining_sec,
                    })
                elif et == 96:  # MARCH_VALUE_LIMIT_BOOST (flat)
                    buff_flat_val += val
                    active_buff_details.append({
                        "buff_id": bid,
                        "effect_type": 96,
                        "effect_name": "MARCH_VALUE_LIMIT_BOOST (flat)",
                        "flat_troops": val,
                        "remaining_sec": remaining_sec,
                    })
                elif is_mass_march and et == 736:  # MASS_MARCH_LIMIT_BOOST (%)
                    buff_percent_permille += val
                    active_buff_details.append({
                        "buff_id": bid,
                        "effect_type": 736,
                        "effect_name": "MASS_MARCH_LIMIT_BOOST (%)",
                        "value_permille": val,
                        "percent": val / 10.0,
                        "is_mass": True,
                        "remaining_sec": remaining_sec,
                    })
                elif is_mass_march and et == 737:  # MASS_MARCH_VALUE_LIMIT_BOOST (flat)
                    buff_flat_val += val
                    active_buff_details.append({
                        "buff_id": bid,
                        "effect_type": 737,
                        "effect_name": "MASS_MARCH_VALUE_LIMIT_BOOST (flat)",
                        "flat_troops": val,
                        "is_mass": True,
                        "remaining_sec": remaining_sec,
                    })

        return {
            "buff_flat_val": buff_flat_val,
            "buff_percent_permille": buff_percent_permille,
            "buff_percent_add": buff_percent_permille / 1000.0,
            "is_mass_march": is_mass_march,
            "active_buff_count": len(active_buff_details),
            "details": active_buff_details,
        }

    def _parse_achievement_march_buff(self, achieve_ctrl: Dict[str, Any]) -> Dict[str, Any]:
        """استخراج بيانات باف وسام القائد 9003017 من كائن الإنجازات."""
        medal_17 = None
        tier_permille = 0
        max_done = 0
        star = 0
        source = "none"

        if isinstance(achieve_ctrl, dict):
            alist = achieve_ctrl.get("list", {})
            if isinstance(alist, dict):
                medal_17 = alist.get("17") or alist.get(17)

        if isinstance(medal_17, dict):
            max_done = self._safe_int(medal_17.get("maxDoneID", 0))
            star = self._safe_int(medal_17.get("star", 0))
            tier_permille = ACHIEVEMENT_MARCH_TIERS.get(max_done, 0)
            source = "achievementctrl"
        elif achieve_ctrl and "list" in achieve_ctrl:
            source = "achievementctrl_unlocked_zero"
            tier_permille = 0
            max_done = 0
            star = 0
        else:
            source = "not_synced"
            tier_permille = 0
            max_done = 0
            star = 0

        return {
            "value_permille": tier_permille,
            "percent": tier_permille / 10.0,
            "multiplier": tier_permille / 1000.0,
            "medal_id": ACHIEVEMENT_MARCH_MEDAL_ID,
            "medal_name": "توحيد القوة",
            "max_done_id": max_done,
            "star": star,
            "source": source,
            "kill_count": 0,
        }

    async def get_achievement_march_buff(self, sync_if_missing: bool = True) -> Dict[str, Any]:
        """
        4. دالة جلب باف ميدالية الإنجازات المئوي (وسام القائد 9003017 لسعة المسيرة):
        ══════════════════════════════════════════════════════════════════════
        المعادلة في سورس كود اللعبة (buildLogic.lua):
            local achieveadd = buffCtrl:getBuffEffect(gBuffEffect.MARCH_LIMIT_BOOST, gBuffSource.ACHIEVEMENT) or 0
            achieveadd = achieveadd / 1000

        آلية العمل (0-Network أولاً + استعلام احتياطي عند الحاجة فقط):
            1. التحقق أولاً من وجود البيانات في الذاكرة الحية (conn.init_data['achievementctrl']).
               إذا كانت موجودة، تقرأ فوراً بـ 0 استهلاك شبكي.
            2. كإجراء احتياطي: إذا لم تكن البيانات مشحونة في الذاكرة الحية و sync_if_missing=True،
               تقوم بإرسال الاستعلام الرسمي (CMD 1055, SUBCMD 2) لمرة واحدة فقط وحفظها بالذاكرة،
               بحيث لا يتم ملامسة الشبكة في أي استدعاءات تالية.

        Returns:
            Dict[str, Any]:
                - value_permille (int): نسبة الباف مقاسة بالألف (Permille)
                - percent (float): نسبة الزيادة المئوية (%، مثل: 1.0)
                - multiplier (float): المعامل العشري المباشر (value_permille / 1000.0)
                - medal_id (int): معرّف الميدالية (9003017)
                - medal_name (str): اسم الميدالية ("توحيد القوة")
                - max_done_id (int): معرّف المستوى المنجز (5317003)
                - star (int): نجوم الميدالية (3)
                - source (str): مصدر القراءة ("achievementctrl" أو "not_synced")
        """
        achieve_ctrl = self.get_ctrl("achievementctrl") or {}
        has_data = isinstance(achieve_ctrl, dict) and bool(achieve_ctrl.get("list"))

        # كإجراء احتياطي فقط: إذا لم تكن البيانات موجودة في الذاكرة الحية، نقوم بمزامنتها لمرة واحدة
        if not has_data and sync_if_missing:
            await self.sync_achievements(timeout=3.0)
            achieve_ctrl = self.get_ctrl("achievementctrl") or {}

        return self._parse_achievement_march_buff(achieve_ctrl)

    def get_achievement_march_buff_sync(self) -> Dict[str, Any]:
        """
        قراءة متزامنة فورية (0-Network Direct Read) لباف وسام القائد من الذاكرة الحية حصراً دون أي استعلام شبكي.
        """
        achieve_ctrl = self.get_ctrl("achievementctrl") or {}
        return self._parse_achievement_march_buff(achieve_ctrl)

    def get_vip_march_buff(self) -> Dict[str, Any]:
        """
        5. دالة جلب باف الـ VIP / SVIP المئوي لسعة المسيرة من الذاكرة الحية (0-Network).
        ══════════════════════════════════════════════════════════════════════════════
        المعادلة في سورس كود اللعبة:
            امتياز VIP رقم 7219 (زيادة الحد الأقصى لعدد جنود المسيرة لفيلق واحد - vipbuff.lua):
            - لا يُمنح أي باف لسعة المسيرة لمستويات VIP من 1 إلى 13 (0%).
            - VIP 14: زيادة 10.0% (100 بالألف).
            - SVIP 1 إلى 5 (المستويات 15-19): زيادة 15.0% (150 بالألف).
            - SVIP 6 إلى 10 (المستويات 20-24): زيادة 20.0% (200 بالألف).
            - SVIP 11 فما فوق (المستويات 25-27): زيادة 25.0% (250 بالألف).
            - شرط التفعيل الحتمي: سريان مفعول الـ VIP اللحظي (is_vip_active).

        Returns:
            Dict[str, Any]:
                - value_permille (int): نسبة الزيادة بالألف (Permille)
                - percent (float): نسبة الزيادة المئوية (%، مثل: 15.0)
                - multiplier (float): المعامل العشري المباشر (value_permille / 1000.0)
                - vip_level (int): مستوى الـ VIP للقلعة
                - is_vip_active (bool): هل ميزة VIP نشطة وسارية حالياً؟
                - vip_end_time (float): وقت انتهاء صلاحية الـ VIP (Unix timestamp)
                - privilege_id (int): معرّف الامتياز الرسمي (7219)
        """
        v_level = int(self.vip_level)
        v_active = bool(self.is_vip_active)
        v_end = float(self.vip_end_time)

        permille = 0
        if v_active and v_level >= 14:
            permille = VIP_MARCH_LIMIT_TABLE.get(v_level, 0)
            if permille == 0 and v_level > 27:
                permille = 250  # سقف الـ SVIP الأقصى

        return {
            "value_permille": permille,
            "percent": permille / 10.0,
            "multiplier": permille / 1000.0,
            "vip_level": v_level,
            "is_vip_active": v_active,
            "vip_end_time": v_end,
            "privilege_id": 7219,
        }

    def get_hero_dress_passive_march_buff(self) -> Dict[str, Any]:
        """
        6. دالة جلب باف امتلاك مظاهر الأبطال السلبية لسعة المسيرة من الذاكرة الحية (0-Network).
        ══════════════════════════════════════════════════════════════════════════════
        المعادلة وسورس كود العميل الأصلي للعبة:
            - heroCtrl:getAllActiveBuff() و heroltCtrl:getOwnBuff() (heroCtrl.lua):
            - يمنح مظهر البطل المملوك زيادة مباشرة ومطلقة في سعة جنود المسيرة (Flat Troops - Effect 96).
            - شروط تفعيل الباف حسب كود اللعبة:
                1. البطل مملوك وموجود في قائمة heroSysCtrl.heroList
                2. البطل ليس ميتاً (state != 2 / HERO_STATE_DEAD)
                3. البطل ليس مأسوراً (state != 3 / HERO_STATE_CAPTURED)
                4. المظهر مفعّل ومملوك في dress.list للبطل

        Returns:
            Dict[str, Any]:
                - total_dress_add (int): إجمالي الجنود الإضافيين من كافة المظاهر المملوكة
                - active_dress_count (int): عدد المظاهر المفعلة التي تمنح زيادة لسعة المسيرة
                - details (List[Dict[str, Any]]): تفاصيل المظاهر والأبطال الحاصلين على الزيادة
        """
        hero_ctrl = self.get_ctrl("heroSysCtrl") or {}
        hero_list = hero_ctrl.get("heroList", {}) if isinstance(hero_ctrl, dict) else {}

        total_add = 0
        details: List[Dict[str, Any]] = []

        if isinstance(hero_list, dict):
            for hero_key, hero_info in hero_list.items():
                if not isinstance(hero_info, dict):
                    continue

                state = self._safe_int(hero_info.get("state"), G_HERO_STATE_NORMAL)
                # استبعاد الأبطال الأموات (2) أو المأسورين (3) مطابقاً لـ heroCtrl:getAllActiveBuff
                if state in (G_HERO_STATE_DEAD, G_HERO_STATE_CAPTURED):
                    continue

                hero_id = self._safe_int(hero_info.get("heroID"), self._safe_int(hero_key, 0))
                dress_obj = hero_info.get("dress")
                if not isinstance(dress_obj, dict):
                    continue

                dress_list = dress_obj.get("list")
                if not dress_list:
                    continue

                # dress_list قد تكون dict مثل {"171602": {...}} أو list
                dress_items = dress_list.keys() if isinstance(dress_list, dict) else dress_list

                for d_item in dress_items:
                    dress_id = self._safe_int(d_item, 0)
                    if dress_id in HERO_DRESS_MARCH_FLAT_BUFFS:
                        troop_val = HERO_DRESS_MARCH_FLAT_BUFFS[dress_id]
                        total_add += troop_val
                        details.append({
                            "hero_id": hero_id,
                            "dress_id": dress_id,
                            "troop_add": troop_val,
                        })

        return {
            "total_dress_add": total_add,
            "active_dress_count": len(details),
            "details": details,
        }

    def get_extra_permanent_march_buffs(self) -> Dict[str, Any]:
        """
        استخراج بافات سعة المسيرة من المصادر الدائمة الإضافية من الذاكرة الحية (0-Network Direct Read):
        ════════════════════════════════════════════════════════════════════════════════════════════════
        مطابق تماماً لمصادر Effect 96 ونظام السمات attributeSystem.query(5) في سورس اللعبة الأصلي:
          1. أحجار الحرب (warGemCtrl / equipment - Effect 96: +500 إلى +12,500)
          2. مستوى المملكة (lordInfoCtrl / kingdomLevel - Effect 96: >=18 -> +3000, >=36 -> +6000)
          3. برج السديم (nebulaActivityCtrl - Effect 96: +20,000 لكل مستوى مفتوح)
          4. سيرة الأبطال (heroBiographyCtrl.activeSkillList - Effect 96: 30102, 30202, 50102, 50202, 80102, 80202)
          5. العتاد العسكري (equipmentCtrl - خاصية 78 في extra properties)
          6. مواهب الحيوانات الأليفة (petCtrl - مهارات 1802XXXXXX)
          7. مهارات إتقان الأبطال السلبية (heroSysCtrl.heroList - 17190701..17190710: +1200..+7200)
          8. رنين السلاح الإعجازي (miraculousWeaponCtrl - المستوى 7 >= 2,615,000 -> +24,000)
          9. مظاهر القلعة والأطر ومسيرات الجيش (dressCtrl - attributeSystem Attr 5 / subType 344, 375, 388, 422, 550, 551, 553)
        """
        import time

        init_data = getattr(self.conn, "init_data", {}) if self.conn else {}
        if not isinstance(init_data, dict):
            init_data = {}

        # 1. أحجار الحرب (warGemCtrl - Effect 96)
        war_gem_add = 0
        wargem_ctrl = self.get_ctrl("warGemCtrl") or init_data.get("warGemCtrl")
        if isinstance(wargem_ctrl, dict):
            bp = wargem_ctrl.get("buffPlusCache") or {}
            if isinstance(bp, dict):
                war_gem_add += self._safe_int(bp.get(96) or bp.get("96"), 0)
            gdata = wargem_ctrl.get("gemData") if isinstance(wargem_ctrl.get("gemData"), dict) else wargem_ctrl
            panels = gdata.get("panel")
            act_id = max(1, self._safe_int(gdata.get("actPanelId"), 1))
            if war_gem_add == 0 and isinstance(panels, list) and len(panels) >= act_id:
                active_panel = panels[act_id - 1]
                if isinstance(active_panel, dict):
                    for slots in active_panel.values():
                        if isinstance(slots, list):
                            for gid in slots:
                                war_gem_add += WAR_GEM_MARCH_BOOST.get(self._safe_int(gid, 0), 0)

        # 2. مستوى المملكة (playerKingdomLevelCtrl / lordInfoCtrl / kingdomLevel - Effect 96)
        kingdom_lv_add = 0
        pkl = self.get_ctrl("playerKingdomLevelCtrl") or init_data.get("playerKingdomLevelCtrl")
        if isinstance(pkl, dict) and pkl.get("isUnlock", True):
            klv = self._safe_int(pkl.get("level"), 0)
        else:
            lord_info = self.get_ctrl("lordInfoCtrl") or init_data.get("lordInfoCtrl") or {}
            klv = self._safe_int(
                init_data.get("kingdom_level")
                or (lord_info.get("base", {}) if isinstance(lord_info, dict) else {}).get("kingdomLevel")
                or (lord_info.get("base", {}) if isinstance(lord_info, dict) else {}).get("klv")
                or init_data.get("kingdomLevel")
                or 0
            )
        if klv >= 98:
            kingdom_lv_add = 15000
        elif klv >= 88:
            kingdom_lv_add = 14000
        elif klv >= 78:
            kingdom_lv_add = 13000
        elif klv >= 68:
            kingdom_lv_add = 12000
        elif klv >= 58:
            kingdom_lv_add = 11000
        elif klv >= 50:
            kingdom_lv_add = 10000
        elif klv >= 36:
            kingdom_lv_add = 6000
        elif klv >= 18:
            kingdom_lv_add = 3000

        # 3. برج السديم (nebulaTowerCtrl / nebulaActivityCtrl - Effect 96)
        nebula_tower_add = 0
        nt = self.get_ctrl("nebulaTowerCtrl") or init_data.get("nebulaTowerCtrl")
        if isinstance(nt, dict) and not nt.get("isLock", False):
            nt_lv = self._safe_int(nt.get("level") or nt.get("curFloor"), 0)
            if nt_lv >= 63:
                nebula_tower_add = 60000
            elif nt_lv >= 32:
                nebula_tower_add = 40000
            elif nt_lv >= 1:
                nebula_tower_add = 20000
        else:
            nebula_ctrl = self.get_ctrl("nebulaActivityCtrl") or init_data.get("nebulaActivityCtrl")
            if isinstance(nebula_ctrl, dict):
                cur_floor = self._safe_int(nebula_ctrl.get("curPassFloor") or nebula_ctrl.get("curFloor"), 0)
                if cur_floor > 0:
                    unlocked_privileges = max(1, cur_floor // 5)
                    nebula_tower_add = unlocked_privileges * 20000

        # 4. سيرة الأبطال (heroBiographyCtrl - Effect 96)
        hero_bio_add = 0
        hbio_ctrl = self.get_ctrl("heroBiographyCtrl") or init_data.get("heroBiographyCtrl")
        if isinstance(hbio_ctrl, dict):
            active_skills = hbio_ctrl.get("activeSkillList") or {}
            if isinstance(active_skills, dict):
                for sk_id_str in active_skills.keys():
                    sk_id = self._safe_int(sk_id_str, 0)
                    if sk_id in HERO_BIOGRAPHY_MARCH_BOOST:
                        hero_bio_add += HERO_BIOGRAPHY_MARCH_BOOST[sk_id]

        # 5. العتاد العسكري (equipmentCtrl - خاصية 78 في extra)
        equipment_add = 0
        eq_ctrl = self.get_ctrl("equipmentCtrl") or init_data.get("equipmentCtrl")
        if isinstance(eq_ctrl, dict):
            eq_arr = eq_ctrl.get("equipment_array") or []
            if isinstance(eq_arr, list):
                for eq in eq_arr:
                    if not isinstance(eq, dict) or self._safe_int(eq.get("wear"), 0) != 1:
                        continue
                    extras = eq.get("extra") or []
                    if isinstance(extras, list):
                        for prop in extras:
                            if isinstance(prop, (list, tuple)) and len(prop) >= 2:
                                if self._safe_int(prop[0], 0) == 78:
                                    equipment_add += self._safe_int(prop[1], 0)
                            elif isinstance(prop, dict):
                                if self._safe_int(prop.get("type") or prop.get("propertyType"), 0) == 78:
                                    equipment_add += self._safe_int(prop.get("val") or prop.get("value"), 0)

        # 6. مواهب الحيوانات الأليفة (petCtrl - Attr 18 / skillID 1802XXXXXX)
        pet_add = 0
        pet_ctrl = self.get_ctrl("petCtrl") or init_data.get("petCtrl")
        if isinstance(pet_ctrl, dict):
            pet_talents = pet_ctrl.get("petTalentData") or {}
            if isinstance(pet_talents, dict):
                for t_info in pet_talents.values():
                    if isinstance(t_info, dict) and t_info.get("active", True):
                        if self._safe_int(t_info.get("attrType"), 0) == 18:
                            pet_add += self._safe_int(t_info.get("value"), 0)
            pet_list = pet_ctrl.get("petList") or {}
            if isinstance(pet_list, dict):
                for p_info in pet_list.values():
                    if not isinstance(p_info, dict):
                        continue
                    for sk_key in ("talentSkills", "skillList", "skills"):
                        sks = p_info.get(sk_key)
                        if isinstance(sks, (list, dict)):
                            vals = sks.values() if isinstance(sks, dict) else sks
                            for sk in vals:
                                sk_id = self._safe_int(sk.get("id") or sk.get("skillID") if isinstance(sk, dict) else sk, 0)
                                if 1802000000 <= sk_id <= 1802999999:
                                    pet_add += sk_id % 1000000

        # 7. مهارات إتقان الأبطال السلبية (heroSysCtrl - 17190701..17190710)
        hero_mastery_add = 0
        hero_sys = self.get_ctrl("heroSysCtrl") or init_data.get("heroSysCtrl") or {}
        hlist = hero_sys.get("heroList") if isinstance(hero_sys, dict) else {}
        if isinstance(hlist, dict):
            for h in hlist.values():
                if not isinstance(h, dict):
                    continue
                if self._safe_int(h.get("state"), G_HERO_STATE_NORMAL) in (G_HERO_STATE_DEAD, G_HERO_STATE_CAPTURED):
                    continue
                for m_key in ("masterySkill", "advancedSkill"):
                    ms = h.get(m_key)
                    if isinstance(ms, dict):
                        if "skillID" in ms:
                            hero_mastery_add += HERO_MASTERY_MARCH_BOOST.get(self._safe_int(ms.get("skillID"), 0), 0)
                        for k_ms, v_ms in ms.items():
                            sid = self._safe_int(v_ms.get("skillID") if isinstance(v_ms, dict) else k_ms, 0)
                            hero_mastery_add += HERO_MASTERY_MARCH_BOOST.get(sid, 0)

        # 8. السلاح الإعجازي (miraculousWeaponCtrl)
        miraculous_add = 0
        mw_ctrl = self.get_ctrl("miraculousWeaponCtrl") or init_data.get("miraculousWeaponCtrl")
        if isinstance(mw_ctrl, dict):
            uinfo = mw_ctrl.get("userInfo") or {}
            if isinstance(uinfo, dict):
                rbuffs = uinfo.get("resonanceBuff") or {}
                rb_iter = rbuffs.values() if isinstance(rbuffs, dict) else (rbuffs if isinstance(rbuffs, list) else [])
                for rb in rb_iter:
                    if isinstance(rb, dict) and self._safe_int(rb.get("buffType"), 0) == 96:
                        miraculous_add += self._safe_int(rb.get("value"), 0)
                if miraculous_add == 0 and self._safe_int(uinfo.get("maxWeaponPower"), 0) >= MIRACULOUS_WEAPON_RESONANCE_7_POWER:
                    miraculous_add += MIRACULOUS_WEAPON_RESONANCE_7_BOOST

        # 9. مظاهر القلعة والأطر (dressCtrl -> attributeSystem Attr 5 / attrID 3)
        castle_dress_add = 0
        dress_ctrl = self.get_ctrl("dressCtrl") or init_data.get("dressCtrl")
        if isinstance(dress_ctrl, dict):
            dlist = dress_ctrl.get("list") or {}
            if isinstance(dlist, dict):
                for d_key, d_val in dlist.items():
                    if isinstance(d_val, dict):
                        stop_t = self._safe_int(d_val.get("stopTime"), 0)
                        if stop_t > 0 and stop_t < int(time.time()):
                            continue
                        sub_t = self._safe_int(d_val.get("subType") or d_val.get("dressID") or d_key, 0)
                    else:
                        sub_t = self._safe_int(d_key, 0)
                    if sub_t in CASTLE_DRESS_MARCH_BOOST:
                        castle_dress_add += CASTLE_DRESS_MARCH_BOOST[sub_t]

        buff_96_extra = (
            war_gem_add
            + kingdom_lv_add
            + nebula_tower_add
            + hero_bio_add
            + equipment_add
            + pet_add
            + hero_mastery_add
            + miraculous_add
        )
        total_extra = buff_96_extra + castle_dress_add

        return {
            "total_extra_flat": total_extra,
            "buff_96_extra_flat": buff_96_extra,
            "attr_system_add": castle_dress_add,
            "sources": {
                "war_gems": war_gem_add,
                "kingdom_level": kingdom_lv_add,
                "nebula_tower": nebula_tower_add,
                "hero_biography": hero_bio_add,
                "equipment": equipment_add,
                "pets": pet_add,
                "hero_mastery": hero_mastery_add,
                "miraculous_weapon": miraculous_add,
                "castle_dress_attr5": castle_dress_add,
            },
        }

    def get_castle_march_capacity_without_heroes(self, move_line_type: Optional[int] = None) -> Dict[str, Any]:
        """
        المعادلة الرياضية الشاملة والنهائية لحساب سعة المسيرة القصوى بدون أبطال (0-Network Pure Math).
        ════════════════════════════════════════════════════════════════════════════════════════════
        مطابقة بنسبة 100% لسورس كود اللعبة الرسمي:
            buildLogic.getExpArmyCount(moveLineType) في buildLogic.lua
            WorldDispatchArmyViewPanel:updateCountLabel() في WorldDispatchArmyViewPanel.lua

        أجزاء المعادلة:
            1. base: سعة مبنى ساحة العرض الأساسية (مستوى + نجوم) عبر get_drill_grounds_base_capacity().
            2. total_add (الزيادات المطلقة الثابتة - Flat Additions):
               - default: الثابت الرياضي الافتراضي للعبة = 1000 جندي (gConstValue.DEFAULT_EXP_ARMY_COUNT).
               - tech_add: إجمالي إضافات أبحاث القيادة (Buff Type 43) عبر get_leadership_technology_additions().
               - buff_value_add: بافات المسيرة الثابتة النشطة (Effect 96) عبر get_active_march_buffs().
               - hero_dress_add: بافات امتلاك مظاهر الأبطال السلبية (Effect 96) عبر get_hero_dress_passive_march_buff().
               - extra_perm_flat: بافات المصادر الدائمة الإضافية ونظام السمات (Attribute 5 / Effect 96).
            3. buff_percent_add (نسب الزيادة المئوية - Percent Additions):
               - achieveadd: نسبة وسام القائد "توحيد القوة" (وسام 9003017) عبر get_achievement_march_buff_sync().
               - vip_percent: نسبة امتياز الـ VIP / SVIP (Privilege 7219) عبر get_vip_march_buff().
               - item_percent: باف المسيرة المئوي المؤقت بالحقيبة/القلعة (Effect 19 - مثل 20% أو 50%).
               - techGroupAdd: نسب مجموعات العلوم العسكرية (73, 77, 95).
            4. الحساب الرياضي الدقيق (Math Floor مطابق لكود العميل):
               - total_flat = default + tech_add + buff_value_add + hero_dress_add + extra_perm_flat
               - effective_base = base + total_flat
               - unchangesize = floor(effective_base * (1 + achieveadd + vip_percent + techGroupAdd))
               - buff_add = floor(effective_base * (item_percent + vip_percent + achieveadd + techGroupAdd))
               - max_capacity = effective_base + floor(effective_base * (item_percent + vip_percent + achieveadd + techGroupAdd))

        Args:
            move_line_type: نوع خط السير (اختياري، لحساب بافات الحشد إن وُجدت).

        Returns:
            Dict[str, Any]: تفصيل شامل لكافة مكونات المعادلة والسعة القصوى الإجمالية.
        """
        import math

        # 1. سعة ساحة العرض الأساسية (Drill Grounds)
        drill_data = self.get_drill_grounds_base_capacity()
        base_capacity = drill_data.get("total_base_capacity", drill_data.get("base_capacity", 0))

        # 2. الثابت الافتراضي للعبة (1000 جندي)
        default_val = 1000

        # 3. إضافات أبحاث القيادة ومجموعات العلوم (Technology)
        tech_data = self.get_leadership_technology_additions()
        tech_flat = tech_data.get("total_tech_add", 0)
        tech_group_multiplier = tech_data.get("tech_group_multiplier", 0.0)

        # 4. بافات المسيرة المؤقتة (Active March Buffs - Items)
        is_mass = move_line_type in (3, 4) if move_line_type is not None else False
        buff_data = self.get_active_march_buffs(is_mass=is_mass, move_line_type=move_line_type)
        buff_flat = buff_data.get("buff_flat_val", 0)
        item_percent_multiplier = buff_data.get("buff_percent_add", 0.0)

        # 5. بافات مظاهر الأبطال السلبية (Hero Dress Passive)
        dress_data = self.get_hero_dress_passive_march_buff()
        dress_flat = dress_data.get("total_dress_add", 0)

        # 6. بافات المصادر الدائمة الإضافية ونظام السمات (Attribute 5 / Effect 96)
        extra_perm = self.get_extra_permanent_march_buffs()
        extra_perm_flat = extra_perm.get("total_extra_flat", 0)

        # 7. باف وسام القائد (Leader's Medal - Achievement)
        achieve_data = self.get_achievement_march_buff_sync()
        achieve_multiplier = achieve_data.get("multiplier", 0.0)

        # 8. باف الـ VIP / SVIP (VIP Privilege 7219)
        vip_data = self.get_vip_march_buff()
        vip_multiplier = vip_data.get("multiplier", 0.0)

        # ── الحساب الرياضي الدقيق طبقاً لـ buildLogic.lua ──
        total_flat_add = default_val + tech_flat + buff_flat + dress_flat + extra_perm_flat
        effective_base = base_capacity + total_flat_add

        # النسب المئوية الدائمة غير المتغيرة (Permanent Multipliers)
        permanent_multiplier = achieve_multiplier + vip_multiplier + tech_group_multiplier

        # إجمالي كافة النسب المئوية (Total Percent Multiplier)
        total_percent_multiplier = permanent_multiplier + item_percent_multiplier

        # حساب الإضافة المئوية بالجنود (Floor)
        percent_troop_add = math.floor(effective_base * total_percent_multiplier)
        total_capacity = effective_base + percent_troop_add

        # السعة الدائمة غير المتغيرة بدون بافات مؤقتة (unchangesize)
        unchangesize = math.floor(effective_base * (1.0 + permanent_multiplier))

        # باف الحشد الإضافي المئوي إن وجد
        is_green = total_capacity > unchangesize

        return {
            "total_capacity": total_capacity,
            "unchangesize": unchangesize,
            "is_buffed": is_green,
            "breakdown": {
                "base_drill_grounds": base_capacity,
                "drill_grounds_level": drill_data.get("lv", 0),
                "drill_grounds_star": drill_data.get("star_lv", 0),
                "default_game_constant": default_val,
                "tech_flat_add": tech_flat,
                "buff_flat_add": buff_flat,
                "hero_dress_flat_add": dress_flat,
                "extra_perm_flat": extra_perm_flat,
                "extra_permanent_sources": extra_perm.get("sources", {}),
                "total_flat_add": total_flat_add,
                "effective_base": effective_base,
                "achievement_percent": achieve_data.get("percent", 0.0),
                "achievement_multiplier": achieve_multiplier,
                "vip_percent": vip_data.get("percent", 0.0),
                "vip_multiplier": vip_multiplier,
                "item_buff_percent": buff_data.get("buff_percent_permille", 0) / 10.0,
                "item_buff_multiplier": item_percent_multiplier,
                "tech_group_percent": tech_group_multiplier * 100.0,
                "tech_group_multiplier": tech_group_multiplier,
                "total_percent_multiplier": total_percent_multiplier,
                "percent_troop_add": percent_troop_add,
            },
        }

    async def get_castle_march_capacity_without_heroes_live(
        self,
        move_line_type: Optional[int] = None,
        sync_if_missing: bool = True,
    ) -> Dict[str, Any]:
        """
        نسخة غير متزامنة (Async) تضمن شحن وسام القائد في الذاكرة الحية قبل الحساب كإجراء احتياطي.
        """
        achieve_ctrl = self.get_ctrl("achievementctrl") or {}
        has_data = isinstance(achieve_ctrl, dict) and bool(achieve_ctrl.get("list"))
        if not has_data and sync_if_missing:
            await self.sync_achievements(timeout=3.0)

        return self.get_castle_march_capacity_without_heroes(move_line_type=move_line_type)

    def get_heroes_march_capacity(
        self,
        hero_ids: Optional[List[int]] = None,
        num_heroes: Optional[int] = None,
        need_available: bool = True,
        include_defend: bool = False,
        hero_type: Union[str, int, List[int], Set[int], Tuple[int, ...]] = "all",
    ) -> Dict[str, Any]:
        """
        حساب الزيادة الإجمالية في سعة الفيلق الممنوحة من الأبطال المرسلين خارج القلعة (0-Network Direct Read).
        ══════════════════════════════════════════════════════════════════════════════════════════════════
        مطابق 100% لسورس كود اللعبة:
            - heroltCtrl:getHerosMarchCapacity(heros, needNormal) (heroltCtrl.lua)
            - WorldDispatchArmyViewPanel:updateHeroEx() (WorldDispatchArmyViewPanel.lua)
            - hero_level_config.lua (march_add حسب ندرة البطل ومستواه)
            - hero_skill_conf.lua (مهارات المعركة النشطة Effect 96 = +480 جندي)

        ملاحظة مهمة حول عدم الازدواجية (مطابق لكود العميل):
            - بافات مظاهر الأبطال السلبية (Dress Passive Buffs) تُحسب مسبقاً ضمن
              get_castle_march_capacity_without_heroes()، لذا لا تُضاف هنا مرة أخرى
              (وهو ما يفعله WorldDispatchArmyViewPanel عبر طرح hero_dressAdd).

        Args:
            hero_ids: قائمة معرّفات أبطال محددة لحساب سعتهم. إذا كانت None، يتم اختيار أفضل الأبطال تلقائياً.
            num_heroes: عدد خانات الأبطال (افتراضياً: get_max_battle_hero_num حسب مستوى القلعة 1..5).
            need_available: إذا كان True، يُشترط أن يكون البطل شاغراً داخل القلعة (State=1).
            include_defend: إذا كان True مع need_available، يُسمح أيضاً بحماة السور (State=5).
            hero_type: فلتر نوع الأبطال عند الانتقاء التلقائي ("all" أو "combat" أو "infantry"...).

        Returns:
            Dict[str, Any]: إجمالي سعة الأبطال وتفاصيل كل بطل مختار.
        """
        tables = _load_march_data_tables()
        rare_levels = tables.get("rare_levels") or HERO_RARE_LEVEL_MARCH_ADD
        hero_configs = tables.get("heroes", {})

        hero_sys = self.get_ctrl("heroSysCtrl") or {}
        hero_list = hero_sys.get("heroList", {}) if isinstance(hero_sys, dict) else {}
        max_slots = int(num_heroes) if num_heroes is not None else self.get_max_battle_hero_num()

        if not isinstance(hero_list, dict) or not hero_list or max_slots <= 0:
            return {
                "total_heroes_add": 0,
                "hero_count": 0,
                "max_hero_slots": max(0, max_slots),
                "heroes": [],
            }

        allowed_states = {G_HERO_STATE_NORMAL}
        if include_defend:
            allowed_states.add(G_HERO_STATE_DEFEND)

        # تجهيز فلتر نوع البطل عند الانتقاء التلقائي
        allowed_types: Optional[Set[int]] = None
        if hero_ids is None and hero_type != "all":
            if isinstance(hero_type, str):
                allowed_types = HERO_TYPE_FILTER_MAP.get(hero_type.strip().lower())
            elif isinstance(hero_type, int):
                allowed_types = {hero_type}
            elif isinstance(hero_type, (list, set, tuple)):
                allowed_types = {int(x) for x in hero_type}

        def _eval_hero(hid: int, h_data: Dict[str, Any]) -> Dict[str, Any]:
            state = self._safe_int(h_data.get("state"), G_HERO_STATE_NORMAL)
            lv = max(1, self._safe_int(h_data.get("level"), 1))
            quality = self._safe_int(h_data.get("quality"), 0)

            cfg = hero_configs.get(str(hid), hero_configs.get(hid, {}))
            meta = OFFICIAL_HERO_CATALOG.get(hid, {})
            # وفق heroltCtrl:getHerosMarchCapacity: تُستخدم الندرة المتأصلة (herosInfo[v].rarity)
            rarity = self._safe_int(
                meta.get("rarity") or cfg.get("rarity") or h_data.get("rarity") or quality or 1,
                1,
            )
            name = meta.get("name_ar") or meta.get("name") or cfg.get("name") or f"Hero_{hid}"

            r_lvs = (
                rare_levels.get(str(rarity))
                or rare_levels.get(rarity)
                or HERO_RARE_LEVEL_MARCH_ADD.get(rarity)
                or {}
            )
            clamped_lv = min(lv, 120)
            level_march_add = self._safe_int(
                r_lvs.get(str(clamped_lv), r_lvs.get(clamped_lv, 0)),
                0,
            )

            skill_march_add = 0
            skills = h_data.get("skillList", {})
            if isinstance(skills, dict):
                for _, s_info in skills.items():
                    if isinstance(s_info, dict) and s_info.get("isActive"):
                        st = self._safe_int(s_info.get("skillType"), 0)
                        if st in HERO_MARCH_SKILLS_BY_QUALITY:
                            skill_march_add += get_hero_battle_skill_march_add(st, quality)
                        elif st in HERO_MARCH_SKILLS_VAL:
                            skill_march_add += HERO_MARCH_SKILLS_VAL[st]

            dress = h_data.get("dress", {})
            cur_dress = self._safe_int(dress.get("seting") if isinstance(dress, dict) else 0)
            own_l = bool(cur_dress > 0 and cur_dress % 100 > 1)

            return {
                "hero_id": hid,
                "name": name,
                "level": lv,
                "rarity": rarity,
                "quality": quality,
                "state": state,
                "is_available": state in allowed_states,
                "own_l": own_l,
                "level_march_add": level_march_add,
                "skill_march_add": skill_march_add,
                "total_hero_add": level_march_add + skill_march_add,
            }

        selected: List[Dict[str, Any]] = []
        if hero_ids is not None:
            seen: Set[int] = set()
            for raw_hid in hero_ids:
                hid = self._safe_int(raw_hid, 0)
                if hid <= 0 or hid in seen:
                    continue
                seen.add(hid)
                h_data = hero_list.get(str(hid)) or hero_list.get(hid)
                if not isinstance(h_data, dict):
                    continue
                entry = _eval_hero(hid, h_data)
                if need_available and not entry["is_available"]:
                    continue
                selected.append(entry)
                if len(selected) >= max_slots:
                    break
        else:
            candidates: List[Dict[str, Any]] = []
            for hid_key, h_data in hero_list.items():
                if not isinstance(h_data, dict):
                    continue
                hid = self._safe_int(h_data.get("heroID"), self._safe_int(hid_key, 0))
                if hid <= 0:
                    continue
                if allowed_types is not None:
                    h_type = self._safe_int(OFFICIAL_HERO_CATALOG.get(hid, {}).get("type"), 0)
                    if h_type not in allowed_types:
                        continue
                entry = _eval_hero(hid, h_data)
                if need_available and not entry["is_available"]:
                    continue
                candidates.append(entry)

            candidates.sort(
                key=lambda h: (
                    (1 if h["is_available"] else 0) if need_available else 0,
                    h["total_hero_add"],
                    1 if h["own_l"] else 0,
                    h["level"],
                    h["rarity"],
                    h["quality"],
                    -h["hero_id"],
                ),
                reverse=True,
            )
            selected = candidates[:max_slots]

        total_heroes_add = sum(h["total_hero_add"] for h in selected)
        return {
            "total_heroes_add": total_heroes_add,
            "hero_count": len(selected),
            "max_hero_slots": max_slots,
            "heroes": selected,
        }

    def get_god_arms_rune_march_buff(self, arm_ids: Optional[List[int]] = None) -> Dict[str, Any]:
        """
        قراءة زيادة سعة المسيرة من رونات العتاد الإلهي المجهزة من الذاكرة الحية (0-Network Direct Read).
        مطابق لـ WorldDispatchArmyViewPanel:updateHeroEx() -> godArmsRuneCtrl:getRuneBuff(v) [Effect 96].
        إذا لم يكن متحكم godArmsRuneCtrl مشحوناً في الذاكرة الحية، يُرجع 0 بأمان دون أي استعلام شبكي.
        """
        rune_ctrl = self.get_ctrl("godArmsRuneCtrl")
        if not isinstance(rune_ctrl, dict) or not rune_ctrl:
            return {"total_rune_add": 0, "matched_runes": 0, "found": False, "details": []}

        rune_list = rune_ctrl.get("runeList") or {}
        wear_list = rune_ctrl.get("newGodArmsRuneList") or rune_ctrl.get("godArmsRuneList") or {}
        arm_id_set = {self._safe_int(a, 0) for a in arm_ids} if arm_ids is not None else None

        # تجميع معرفات الرونات المجهزة على الأسلحة المطلوبة
        equipped_uids: Set[str] = set()
        if isinstance(wear_list, dict):
            for arm_key, arm_slots in wear_list.items():
                aid = self._safe_int(arm_key, 0)
                if arm_id_set is not None and aid not in arm_id_set:
                    continue
                if isinstance(arm_slots, dict):
                    for uid in arm_slots.values():
                        if uid:
                            equipped_uids.add(str(uid))
                elif isinstance(arm_slots, list):
                    for slot in arm_slots:
                        if isinstance(slot, dict) and slot.get("uid"):
                            equipped_uids.add(str(slot["uid"]))
                        elif slot:
                            equipped_uids.add(str(slot))

        total_add = 0
        details: List[Dict[str, Any]] = []
        iterable_runes = rune_list.values() if isinstance(rune_list, dict) else (rune_list if isinstance(rune_list, list) else [])

        for r_item in iterable_runes:
            if not isinstance(r_item, dict):
                continue
            uid = str(r_item.get("uid") or "")
            if equipped_uids and uid and uid not in equipped_uids:
                continue
            if not equipped_uids and not r_item.get("godArmsID") and not r_item.get("isWear"):
                continue

            props = r_item.get("property") or r_item.get("properties") or []
            if isinstance(props, dict):
                props = list(props.values())
            for prop in props:
                if not isinstance(prop, dict):
                    continue
                eff_type = self._safe_int(prop.get("effectType") or prop.get("buffType"), 0)
                prop_id = self._safe_int(prop.get("id") or prop.get("propertyID"), 0)
                val = self._safe_int(prop.get("val") or prop.get("value") or prop.get("num"), 0)

                if eff_type == 96 and val > 0:
                    total_add += val
                    details.append({"uid": uid, "property_id": prop_id, "value": val})
                elif eff_type == 0 and prop_id in RUNE_MARCH_PROPERTY_BASE:
                    add_v = val if val > 0 else RUNE_MARCH_PROPERTY_BASE[prop_id]
                    total_add += add_v
                    details.append({"uid": uid, "property_id": prop_id, "value": add_v})

        return {
            "total_rune_add": total_add,
            "matched_runes": len(details),
            "found": True,
            "details": details,
        }

    def get_divine_beast_march_buff(
        self,
        divine_beast_ids: Optional[List[int]] = None,
        need_in_city: bool = True,
    ) -> Dict[str, Any]:
        """
        قراءة زيادة سعة المسيرة من الوحوش الإلهية المرافقة من الذاكرة الحية (0-Network Direct Read).
        مطابق لـ WorldDispatchArmyViewPanel:updateHeroEx() -> divineBeastCtrl:getDispatchAddCount(..., 96).
        إذا لم يكن متحكم divineBeastCtrl مشحوناً في الذاكرة الحية، يُرجع 0 بأمان دون أي استعلام شبكي.
        """
        beast_ctrl = self.get_ctrl("divineBeastCtrl")
        if not isinstance(beast_ctrl, dict) or not beast_ctrl:
            return {"total_beast_add": 0, "matched_beasts": 0, "found": False, "details": []}

        dispatch_buffs = beast_ctrl.get("dispatchBuffDatas") or {}
        beasts = beast_ctrl.get("beast") or {}
        id_filter = {str(self._safe_int(b, 0)) for b in divine_beast_ids} if divine_beast_ids is not None else None

        total_add = 0
        details: List[Dict[str, Any]] = []

        if isinstance(dispatch_buffs, dict):
            for bid_key, b_buffs in dispatch_buffs.items():
                bid_str = str(bid_key)
                if id_filter is not None and bid_str not in id_filter:
                    continue
                if need_in_city and isinstance(beasts, dict):
                    b_info = beasts.get(bid_str) or beasts.get(self._safe_int(bid_str, 0))
                    if isinstance(b_info, dict):
                        # استبعاد الوحش الموجود في هجوم خارج القلعة (ATTACK/ATTACK_DEFEND) أو في العلاج
                        b_state = self._safe_int(b_info.get("state"), 0)
                        if b_state in (2, 3, 4):
                            continue
                if isinstance(b_buffs, dict):
                    val = self._safe_int(b_buffs.get(96) or b_buffs.get("96"), 0)
                    if val > 0:
                        total_add += val
                        details.append({"beast_id": self._safe_int(bid_str, 0), "value": val})

        # دعم حساب مهارة الإرسال 1002 مباشرة للوحش 1900 عند عدم شحن dispatchBuffDatas بالسيرفر
        if total_add == 0 and isinstance(beasts, dict):
            for bid_key, b_info in beasts.items():
                bid_str = str(bid_key)
                if id_filter is not None and bid_str not in id_filter:
                    continue
                if not isinstance(b_info, dict):
                    continue
                b_state = self._safe_int(b_info.get("state"), 0)
                if need_in_city and b_state in (2, 3, 4):
                    continue
                if bid_str == "1900":
                    star_lv = self._safe_int(b_info.get("starLv") or b_info.get("star"), 0)
                    if star_lv >= 4:
                        b_val = 20000
                    elif star_lv == 3:
                        b_val = 14000
                    elif star_lv >= 2:
                        b_val = 8000
                    elif star_lv >= 0 and (b_info.get("skills") or b_info.get("skillList")):
                        b_val = 4000
                    else:
                        b_val = 0
                    if b_val > 0:
                        total_add += b_val
                        details.append({"beast_id": 1900, "skill_id": 1002, "value": b_val})

        # فحص شارات الوحش الإلهي (divineBeastMarkCtrl:getDispatchAddCount / 10)
        mark_ctrl = self.get_ctrl("divineBeastMarkCtrl")
        if isinstance(mark_ctrl, dict):
            db_dispatch = mark_ctrl.get("dispatchBuffDatas")
            if isinstance(db_dispatch, dict):
                for bid_k, b_data in db_dispatch.items():
                    if id_filter is not None and str(bid_k) not in id_filter:
                        continue
                    if isinstance(b_data, dict):
                        m_val = self._safe_int(b_data.get(96) or b_data.get("96"), 0) // 10
                        if m_val > 0:
                            total_add += m_val
                            details.append({"mark_beast_id": self._safe_int(bid_k, 0), "value": m_val})

        return {
            "total_beast_add": total_add,
            "matched_beasts": len(details),
            "found": True,
            "details": details,
        }

    def get_castle_available_troops(self) -> Dict[str, Any]:
        """
        استخراج عدد القوات المتوفرة بالقلعة والمصابة بالمستشفى (0-Network Direct Read).
        armyCtrl.totalArmy: القوات الحرة الجاهزة للقتال والمسيرات.
        armyCtrl.woundedArmy: القوات المصابة في المستشفى.
        """
        army_ctrl = self.get_ctrl("armyCtrl") or {}
        total_army = army_ctrl.get("totalArmy", {}) if isinstance(army_ctrl, dict) else {}
        wounded_army = army_ctrl.get("woundedArmy", {}) if isinstance(army_ctrl, dict) else {}

        free_count = 0
        free_details: Dict[str, int] = {}
        if isinstance(total_army, dict):
            for aid, adata in total_army.items():
                cnt = self._safe_int(adata if not isinstance(adata, dict) else adata.get("free", adata.get("count", 0)))
                if cnt > 0:
                    free_count += cnt
                    free_details[str(aid)] = cnt

        wounded_count = 0
        wounded_details: Dict[str, int] = {}
        if isinstance(wounded_army, dict):
            for aid, adata in wounded_army.items():
                cnt = self._safe_int(adata if not isinstance(adata, dict) else adata.get("count", 0))
                if cnt > 0:
                    wounded_count += cnt
                    wounded_details[str(aid)] = cnt

        return {
            "free_troops_total": free_count,
            "free_troops_breakdown": free_details,
            "wounded_troops_total": wounded_count,
            "wounded_troops_breakdown": wounded_details,
        }

    def get_max_attack_march_capacity(
        self,
        hero_ids: Optional[List[int]] = None,
        move_line_type: Optional[int] = None,
        need_available_heroes: bool = True,
        include_defend_heroes: bool = False,
        hero_type: Union[str, int, List[int], Set[int], Tuple[int, ...]] = "all",
        arm_ids: Optional[List[int]] = None,
        divine_beast_ids: Optional[List[int]] = None,
        allow_max_count: Optional[int] = None,
        use_learned_cap: bool = False,
    ) -> Dict[str, Any]:
        """
        الدالة الشاملة لحساب السعة القصوى للفايلق للهجوم خارج القلعة من الذاكرة الحية (0-Network Direct Read).
        ══════════════════════════════════════════════════════════════════════════════════════════════════
        مطابقة بنسبة 100% لسورس كود اللعبة الرسمي:
            - buildLogic.getExpArmyCount(moveLineType) (buildLogic.lua)
            - WorldDispatchArmyViewPanel:updateCountLabel() & updateHeroEx() (WorldDispatchArmyViewPanel.lua)
            - heroltCtrl:getHerosMarchCapacity(heroInfo, true) (heroltCtrl.lua)

        المعادلة الرسمية الكاملة في اللعبة عند إرسال فيلق هجوم خارج القلعة:
            total_capacity =
                castle_capacity_without_heroes      # ساحة التدريب + 1000 + أبحاث القيادة + البافات + المظاهر + VIP + الوسام
              + heroes_capacity_add                 # زيادة الأبطال المختارين (مستوى/ندرة + مهارات معركة 96 بدون ازدواجية المظاهر)
              + arm_rune_capacity_add               # رونات العتاد الإلهي (Effect 96) إن وُجدت بالذاكرة الحية
              + divine_beast_capacity_add           # الوحوش الإلهية المرافقة (Effect 96) إن وُجدت بالذاكرة الحية

        Args:
            hero_ids: قائمة معرّفات أبطال محددة للفيلق (اختياري). إذا تُركت None يتم انتقاء أفضل الأبطال المتاحين تلقائياً.
            move_line_type: نوع خط المسيرة (اختياري؛ يُفعّل بافات الحشد 736/737 لخطوط الحشد).
            need_available_heroes: إذا كان True (الافتراضي)، تُحسب السعة بالأبطال المتاحين حالياً داخل القلعة (State=1).
            include_defend_heroes: السماح باحتساب حماة السور (State=5) ضمن الأبطال المتاحين.
            hero_type: فلترة فئة الأبطال عند الانتقاء التلقائي ("all" أو "combat"...).
            arm_ids: قائمة معرّفات العتاد الإلهي المرافق للفيلق (اختياري).
            divine_beast_ids: قائمة معرّفات الوحوش الإلهية المرافقة للفيلق (اختياري).
            allow_max_count: سقف خاص يفرضه نوع هدف معيّن إن وُجد (مثل بعض الفعاليات).
            use_learned_cap: إذا كان True، يتم تقييد السعة النهائية بسقف الأمان المتعلم في الجلسة (learned_march_capacity).

        Returns:
            Dict[str, Any]:
                - total_capacity (int): السعة القصوى النهائية للفيلق للهجوم خارج القلعة
                - theoretical_max_capacity (int): السعة القصوى النظرية لو كانت كل أبطالك متاحة داخل القلعة
                - unchangesize_with_heroes (int): السعة الدائمة مع الأبطال بدون البافات المؤقتة
                - castle_capacity_without_heroes (int): سعة القلعة الأساسية بدون أبطال
                - heroes_capacity_add (int): إجمالي زيادة الأبطال المختارين
                - arm_rune_capacity_add (int): زيادة رونات العتاد الإلهي
                - divine_beast_capacity_add (int): زيادة الوحوش الإلهية
                - max_hero_slots (int): عدد خانات الأبطال المفتوحة للقلعة (1..5)
                - selected_heroes (List[Dict]): تفاصيل الأبطال المختارين ومساهمة كل بطل
                - is_buffed (bool): هل يوجد باف مسيرة مؤقت نشط
                - virtual_buff_override (Optional[int]): قيمة virtualBuff.marchMaxCount إن كانت مفعلة
                - learned_march_capacity (Optional[int]): سقف الأمان المتعلم في الجلسة إن وُجد
                - breakdown (Dict): التفصيل الكامل لكافة مكونات المعادلة
        """
        # 1. سعة القلعة الأساسية بدون أبطال (buildLogic.getExpArmyCount)
        castle_data = self.get_castle_march_capacity_without_heroes(move_line_type=move_line_type)
        castle_total = int(castle_data.get("total_capacity", 0))
        castle_unchanged = int(castle_data.get("unchangesize", castle_total))
        is_buffed = bool(castle_data.get("is_buffed", False))

        # دعم virtualBuff.marchMaxCount إن وُجد في buffCtrl (مطابق لـ buildLogic.lua:2063)
        virtual_override: Optional[int] = None
        buff_ctrl_raw = self.get_ctrl("buffCtrl")
        if isinstance(buff_ctrl_raw, dict):
            vb = buff_ctrl_raw.get("virtualBuff")
            if isinstance(vb, dict) and vb.get("marchMaxCount") is not None:
                virtual_override = self._safe_int(vb.get("marchMaxCount"), 0)
                if virtual_override > 0:
                    castle_total = virtual_override

        # 2. زيادة الأبطال المرسلين للفيلق (WorldDispatchArmyViewPanel:updateHeroEx)
        heroes_data = self.get_heroes_march_capacity(
            hero_ids=hero_ids,
            need_available=need_available_heroes,
            include_defend=include_defend_heroes,
            hero_type=hero_type,
        )
        heroes_add = int(heroes_data.get("total_heroes_add", 0))

        # السعة النظرية القصوى لو كانت جميع الأبطال داخل القلعة (للمقارنة والتخطيط)
        if hero_ids is None and need_available_heroes:
            all_heroes_data = self.get_heroes_march_capacity(
                hero_ids=None,
                need_available=False,
                include_defend=True,
                hero_type=hero_type,
            )
            theoretical_heroes_add = int(all_heroes_data.get("total_heroes_add", 0))
        else:
            theoretical_heroes_add = heroes_add

        # 3. زيادة رونات العتاد الإلهي (godArmsRuneCtrl)
        rune_data = self.get_god_arms_rune_march_buff(arm_ids=arm_ids)
        rune_add = int(rune_data.get("total_rune_add", 0))

        # 4. زيادة الوحوش الإلهية المرافقة (divineBeastCtrl)
        beast_data = self.get_divine_beast_march_buff(
            divine_beast_ids=divine_beast_ids,
            need_in_city=need_available_heroes,
        )
        beast_add = int(beast_data.get("total_beast_add", 0))

        # 5. التجميع النهائي المطابق لـ WorldDispatchArmyViewPanel:updateCountLabel()
        total_capacity = castle_total + heroes_add + rune_add + beast_add
        unchangesize_with_heroes = castle_unchanged + heroes_add + rune_add + beast_add
        theoretical_max_capacity = castle_total + theoretical_heroes_add + rune_add + beast_add

        if allow_max_count is not None and allow_max_count > 0:
            total_capacity = min(total_capacity, int(allow_max_count))
            theoretical_max_capacity = min(theoretical_max_capacity, int(allow_max_count))

        learned_cap = getattr(self.conn, "learned_march_capacity", None) if self.conn else None
        if isinstance(learned_cap, (int, float)) and learned_cap > 0:
            learned_cap = int(learned_cap)
            if use_learned_cap:
                total_capacity = min(total_capacity, learned_cap)
        else:
            learned_cap = None

        breakdown = dict(castle_data.get("breakdown", {}))
        breakdown.update({
            "castle_capacity_without_heroes": castle_total,
            "heroes_capacity_add": heroes_add,
            "theoretical_heroes_capacity_add": theoretical_heroes_add,
            "arm_rune_capacity_add": rune_add,
            "arm_rune_ctrl_loaded": bool(rune_data.get("found", False)),
            "divine_beast_capacity_add": beast_add,
            "divine_beast_ctrl_loaded": bool(beast_data.get("found", False)),
            "virtual_buff_override": virtual_override,
            "allow_max_count": allow_max_count,
            "learned_march_capacity": learned_cap,
        })

        # 5. جاهزية القوات الحقيقية بالقلعة والمشفى (0-Network Direct Read)
        troops_info = self.get_castle_available_troops()
        free_troops = troops_info["free_troops_total"]
        max_sendable_troops = min(total_capacity, free_troops)

        return {
            "total_capacity": total_capacity,
            "theoretical_max_capacity": theoretical_max_capacity,
            "unchangesize_with_heroes": unchangesize_with_heroes,
            "castle_capacity_without_heroes": castle_total,
            "heroes_capacity_add": heroes_add,
            "arm_rune_capacity_add": rune_add,
            "divine_beast_capacity_add": beast_add,
            "max_hero_slots": int(heroes_data.get("max_hero_slots", 0)),
            "selected_heroes": heroes_data.get("heroes", []),
            "is_buffed": is_buffed,
            "virtual_buff_override": virtual_override,
            "learned_march_capacity": learned_cap,
            "free_troops_total": free_troops,
            "wounded_troops_total": troops_info["wounded_troops_total"],
            "max_sendable_troops_now": max_sendable_troops,
            "troops_info": troops_info,
            "breakdown": breakdown,
        }

    async def get_max_attack_march_capacity_live(
        self,
        hero_ids: Optional[List[int]] = None,
        move_line_type: Optional[int] = None,
        need_available_heroes: bool = True,
        include_defend_heroes: bool = False,
        hero_type: Union[str, int, List[int], Set[int], Tuple[int, ...]] = "all",
        arm_ids: Optional[List[int]] = None,
        divine_beast_ids: Optional[List[int]] = None,
        allow_max_count: Optional[int] = None,
        use_learned_cap: bool = False,
        sync_if_missing: bool = True,
    ) -> Dict[str, Any]:
        """
        نسخة غير متزامنة (Async) لحساب السعة القصوى للفايلق للهجوم خارج القلعة.
        تعتمد أولاً على الذاكرة الحية (0-Network)، وفي حال عدم شحن وسام القائد (achievementctrl)
        تقوم بمزامنته لمرة واحدة فقط كإجراء احتياطي مع تنبيه واضح.
        """
        achieve_ctrl = self.get_ctrl("achievementctrl") or {}
        has_data = isinstance(achieve_ctrl, dict) and bool(achieve_ctrl.get("list"))
        if not has_data and sync_if_missing:
            self.log(
                "🚨⚠️🚨 [BaseTask: get_max_attack_march_capacity_live] "
                "Data missing from live memory (achievementctrl)! Falling back to network query..."
            )
            await self.sync_achievements(timeout=3.0)

        return self.get_max_attack_march_capacity(
            hero_ids=hero_ids,
            move_line_type=move_line_type,
            need_available_heroes=need_available_heroes,
            include_defend_heroes=include_defend_heroes,
            hero_type=hero_type,
            arm_ids=arm_ids,
            divine_beast_ids=divine_beast_ids,
            allow_max_count=allow_max_count,
            use_learned_cap=use_learned_cap,
        )

    def get_max_march_capacity(
        self,
        hero_ids: Optional[List[int]] = None,
        move_line_type: Optional[int] = None,
        need_available_heroes: bool = True,
        include_defend_heroes: bool = False,
        hero_type: Union[str, int, List[int], Set[int], Tuple[int, ...]] = "all",
        arm_ids: Optional[List[int]] = None,
        divine_beast_ids: Optional[List[int]] = None,
        allow_max_count: Optional[int] = None,
        use_learned_cap: bool = False,
    ) -> Dict[str, Any]:
        """
        اسم بديل للتوافق البرمجي المباشر مع get_max_attack_march_capacity.
        """
        return self.get_max_attack_march_capacity(
            hero_ids=hero_ids,
            move_line_type=move_line_type,
            need_available_heroes=need_available_heroes,
            include_defend_heroes=include_defend_heroes,
            hero_type=hero_type,
            arm_ids=arm_ids,
            divine_beast_ids=divine_beast_ids,
            allow_max_count=allow_max_count,
            use_learned_cap=use_learned_cap,
        )

    def record_learned_march_capacity(self, max_troops: int) -> None:
        """
        تسجيل سقف السعة المتعلم أثناء الجلسة (مطابق لبوت العثمانية E:\\osmanli\\tasks\\march_capacity.py)
        بحيث يتم حماية جميع المهام والمسيرات اللاحقة لنفس الحساب فوراً.
        """
        if not self.conn or max_troops <= 0:
            return
        current_learned = getattr(self.conn, "learned_march_capacity", None)
        if current_learned is None or not isinstance(current_learned, (int, float)) or current_learned <= 0 or max_troops < current_learned:
            setattr(self.conn, "learned_march_capacity", int(max_troops))
            self.log(f"🛡️ [صمام الأمان] تم تثبيت سقف أمان المسيرات للجلسة: {max_troops:,} جندي لمنع أي تجاوز.")

    # ═════════════════════════════════════════════════════════════════════════
    # 19. محرك جلب الأبطال المتاحين والشاغرين في القلعة (Available Castle Heroes Engine)
    # مطابقة 100% لسورس كود العميل الأصلي للعبة:
    #   - heroCtrl:getHeroInCastle() (عند تفعيل include_defend=True).
    #   - heroCtrl:getHeroInCastleNotDefend() (الوضع الافتراضي include_defend=False).
    #   - heroltCtrl.filterHeroClass(classType, heroID) (فلترة الفئات العسكرية والأصناف).
    #   - heroCtrl:sortDispatchHerosID(heros, states, isCompareLie) (خوارزمية الفرز الرسمية).
    # ═════════════════════════════════════════════════════════════════════════

    def get_available_heroes(
        self,
        hero_type: Union[str, int, List[int], Set[int], Tuple[int, ...]] = "all",
        include_defend: bool = False,
        detailed: bool = False,
        sort: bool = True,
        limit: Optional[int] = None,
    ) -> Union[List[int], List[Dict[str, Any]]]:
        """
        جلب الأبطال المتاحين والشاغرين في القلعة مع فلترة دقيقة بحسب النوع (0-Network Direct Read).
        
        مطابقة تامة 100% لسورس كود العميل الأصلي للعبة:
          - heroCtrl:getHeroInCastle() (عند تفعيل include_defend=True).
          - heroCtrl:getHeroInCastleNotDefend() (الوضع الافتراضي include_defend=False).
          - heroltCtrl.filterHeroClass(classType, heroID) (فلترة الفئات العسكرية والأصناف).
          - heroCtrl:sortDispatchHerosID(heros, states, isCompareLie) (خوارزمية الفرز الرسمية للعبة).
        
        :param hero_type: نوع أو فئة الأبطال المطلوب إرجاعهم:
            - 'all' / 'الكل' / None: جميع الأبطال المتاحين (أنواع 1, 2, 3, 4, 5).
            - 'combat' / 'war' / 'قتال' / 'حرب': أبطال القتال والعسكر فقط (عربات 2, فرسان 3, رماة 4, مشاة 5)
              مع استبعاد أبطال الجمع والتطوير التخصصيين (1711, 1724, 1733).
            - 'infantry' / 'مشاة' / 5: مشاة فقط.
            - 'cavalry' / 'فرسان' / 3: فرسان فقط.
            - 'archer' / 'رماة' / 4: رماة فقط.
            - 'chariots' / 'عربات' / 2: عربات فقط.
            - 'ancillary' / 'support' / 'development' / 'مساعد' / 'تطوير' / 'دعم' / 1: أبطال المساعدة والتنمية فقط.
            - أو رقم صريح (1..5) أو قائمة/مجموعة أرقام معرفات أو أنواع.
        :param include_defend: استبعاد حماة السور افتراضياً (False) مطابقة لـ getHeroInCastleNotDefend،
            أو تضمينهم إذا كانت القيمة (True) مطابقة لـ getHeroInCastle.
        :param detailed: إرجاع قائمة بمعرفات الأبطال فقط List[int] إذا كان False،
            أو إرجاع قائمة كائنات مفصلة List[Dict[str, Any]] بكافة خصائص البطل إذا كان True.
        :param sort: تطبيق خوارزمية الفرز الرسمية للعبة (heroCtrl:sortDispatchHerosID) تنازلياً حسب القوة.
        :param limit: الحد الأقصى لعدد الأبطال المطلوب إرجاعهم (اختياري).
        :return: قائمة بمعرفات الأبطال List[int] أو قائمة تفصيلية List[Dict[str, Any]].
        """
        hero_ctrl = self.get_ctrl("heroSysCtrl") or self.get_ctrl("heroCtrl")
        if not isinstance(hero_ctrl, dict):
            return []

        hero_list_raw = hero_ctrl.get("heroList")
        if not isinstance(hero_list_raw, dict):
            return []

        # 1. استخراج حماة السور الفعليين (defendList) لمطابقة heroCtrl:isHeroInDefend
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

        # 2. فحص المسيرات والطوابير النشطة الحية لاستبعاد أي بطل منخرط بها
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

        # 3. تحليل وتحديد مجموعة الأنواع المستهدفة (Target Types)
        target_types: Set[int] = set()
        is_combat_filter = False

        if hero_type is None:
            target_types = {1, 2, 3, 4, 5}
        elif isinstance(hero_type, str):
            clean_type = hero_type.lower().strip()
            if clean_type.startswith("ال") and len(clean_type) > 2:
                clean_no_al = clean_type[2:]
            else:
                clean_no_al = clean_type

            if clean_type in HERO_TYPE_FILTER_MAP:
                target_types = set(HERO_TYPE_FILTER_MAP[clean_type])
            elif clean_no_al in HERO_TYPE_FILTER_MAP:
                target_types = set(HERO_TYPE_FILTER_MAP[clean_no_al])
            elif clean_type.isdigit():
                target_types = {int(clean_type)}
            else:
                target_types = {1, 2, 3, 4, 5}

            if clean_type in ("combat", "war", "battle", "قتال", "حرب", "عسكري") or clean_no_al in ("قتال", "حرب", "عسكري"):
                is_combat_filter = True
        elif isinstance(hero_type, int):
            target_types = {hero_type}
            if hero_type in COMBAT_HERO_TYPES:
                is_combat_filter = True
        elif isinstance(hero_type, (list, tuple, set)):
            for item in hero_type:
                if isinstance(item, int):
                    target_types.add(item)
                elif isinstance(item, str) and item.isdigit():
                    target_types.add(int(item))
                elif isinstance(item, str):
                    s_item = item.lower().strip()
                    if s_item in HERO_TYPE_FILTER_MAP:
                        target_types.update(HERO_TYPE_FILTER_MAP[s_item])

        if not target_types:
            target_types = {1, 2, 3, 4, 5}

        # 4. جداول بيانات المسيرات وقدرات الأبطال لحساب القوة والفرز
        tables = _load_march_data_tables()
        hero_configs = tables.get("heroes", {})
        rare_levels = tables.get("rare_levels", {})

        candidates: List[Dict[str, Any]] = []

        for k, v in hero_list_raw.items():
            if not isinstance(v, dict):
                continue

            hid = self._safe_int(v.get("heroID", k))
            if hid <= 0:
                continue

            meta = OFFICIAL_HERO_CATALOG.get(hid, {})
            # تحديد نوع البطل (سورس كود heroDef / hero_view_info)
            htype = meta.get("type") or self._safe_int(v.get("heroType", v.get("type", 0)))
            if htype not in target_types:
                continue

            # في حالة فلترة أبطال القتال، يتم استبعاد أبطال الجمع والتنمية التخصصيين
            if is_combat_filter and hid in GATHERING_SPECIALIST_HERO_IDS:
                continue

            # فحص طابور البطل الفردي
            q = v.get("queue")
            has_queue = bool(q and isinstance(q, dict) and len(q) > 0)
            if has_queue or hid in active_queue_heroes:
                continue

            # فحص حالة البطل (gHeroState)
            state = self._safe_int(v.get("state"), G_HERO_STATE_NORMAL)
            is_defending = (hid in defend_ids) or (state == G_HERO_STATE_DEFEND)

            # التحقق من توفر وشغور البطل داخل القلعة (heroCtrl:getHeroInCastle / getHeroInCastleNotDefend)
            if state == G_HERO_STATE_NORMAL:
                if is_defending and not include_defend:
                    continue
            elif state == G_HERO_STATE_DEFEND:
                if not include_defend:
                    continue
            else:
                # الحالات الأخرى غير شاغرة: ميت (2)، مأسور (3)، زحف (4)، هارب (6)، مرابط (7)
                continue

            level = self._safe_int(v.get("level"), 1)
            quality = self._safe_int(v.get("quality"), 1)
            rarity = meta.get("rarity") or self._safe_int(v.get("rarity"), 1)
            is_awake = bool(v.get("isAwake", False))

            dress = v.get("dress", {})
            cur_dress = self._safe_int(dress.get("seting") if isinstance(dress, dict) else 0)
            own_lieutenant = bool(cur_dress > 0 and cur_dress % 100 > 1)

            # حساب سعة المسيرة المضافة من البطل (طريقة heroCtrl:getHeroTotalMarchAddNum & heroltCtrl:getHerosMarchCapacity)
            # الرتبة الفعالة للبطل في السعة: جودة البطل (نجومه) إذا كانت متوفرة، أو ندرته المتأصلة
            effective_tier = quality if quality > 0 else rarity
            r_lvs = rare_levels.get(str(effective_tier), rare_levels.get(effective_tier, {}))
            base_hero_march = int(r_lvs.get(str(level), r_lvs.get(level, 0)))

            skill_add = 0
            skill_list = v.get("skillList", {})
            if isinstance(skill_list, dict):
                for _, s_info in skill_list.items():
                    if isinstance(s_info, dict) and s_info.get("isActive"):
                        st = self._safe_int(s_info.get("skillType", 0))
                        if st in HERO_MARCH_SKILLS_BY_QUALITY:
                            skill_add += get_hero_battle_skill_march_add(st, quality)
                        elif st in HERO_MARCH_SKILLS_VAL:
                            skill_add += HERO_MARCH_SKILLS_VAL[st]

            total_march_num = base_hero_march + skill_add

            name_code = meta.get("name", f"heroname_{hid}")
            name_ar = meta.get("name_ar", name_code)
            type_en = meta.get("type_en", "unknown")
            type_ar = meta.get("type_ar", "غير معروف")

            candidates.append({
                "heroID": hid,
                "hero_id": hid,
                "name": name_code,
                "name_ar": name_ar,
                "heroType": htype,
                "type_name_en": type_en,
                "type_name_ar": type_ar,
                "level": level,
                "quality": quality,
                "rarity": rarity,
                "state": state,
                "is_awake": is_awake,
                "own_l": own_lieutenant,
                "is_defending": is_defending,
                "march_num": total_march_num,
                "base_march_add": base_hero_march,
                "skill_march_add": skill_add,
                "dress": cur_dress,
                "raw_data": v,
            })

        # 5. تطبيق خوارزمية الفرز الرسمية للعبة (heroCtrl:sortDispatchHerosID)
        if sort:
            candidates.sort(
                key=lambda x: (
                    1 if x["own_l"] else 0,
                    x["march_num"],
                    x["level"],
                    x["rarity"],
                    x["quality"],
                    -x["heroID"],
                ),
                reverse=True,
            )

        # 6. تطبيق الحد الأقصى إن وجد
        if limit is not None and limit > 0:
            candidates = candidates[:limit]

        # 7. صياغة النتيجة المرجعة
        if detailed:
            return candidates
        return [c["heroID"] for c in candidates]

    # ═════════════════════════════════════════════════════════════════════════
    # 20. محرك حساب سعة نقل مساعدة الموارد والضرائب بالسوق (Market Resource Transport Engine)
    # مطابقة تامة 100% لسورس كود اللعبة الرسمي:
    #   - buildLogic.lua:2024-2055 (buildLogic.getMarketWeight & buildLogic.getMarketRate)
    #   - build112.lua (Market Lv.1 - Lv.30 capacities & tax rates)
    #   - allianceScience.lua:179-202 & alliance_science_lv.lua (Science ID 33002: TRADING_WEIGHT)
    #   - marketViewPanel.lua:39-48, 127, 177-185 (Resource Weights & Unlock Levels)
    #   - marketResSingle.lua:60-71 (getFinalWeight, getFinalCount = finalWeight / perWeight)
    # ═════════════════════════════════════════════════════════════════════════

    def get_market_transport_capacity(
        self,
        resource_type: Optional[Union[str, int]] = None,
        target_castle_level: Optional[int] = None,
        breakdown: bool = False,
    ) -> Union[int, Dict[str, Any]]:
        """
        حساب سعة نقل مساعدة الموارد الممكنة في النقل الواحد عبر مبنى السوق (0-Network Direct Read).
        مطابقة مثالية وترجمة حرفية لمنطق وحسابات سورس كود اللعبة:
          1. سعة السوق الأساسية (buildLogic.getMarketWeight / build112.lua:capacity):
             - يتم استخراج مستوى مبنى السوق (BID 112) من الذاكرة الحية `cityCtrl.blist`.
             - إذا كان السوق غير مبني أو مستواه 0، تكون السعة الأساسية 0.
          2. زيادة علوم التحالف (allianceScience:getScienceAddValue(gAScienceType.TRADING_WEIGHT)):
             - فحص علم التحالف 33002 ("زيادة حمولة القوات في التبادل" من sciType 18).
             - إضافة النسبة: add = math.floor(base * alliance_add).
             - total_capacity = base + add.
          3. نسبة الضريبة الرسمية (buildLogic.getMarketRate / build112.lua:taxRate):
             - تتراوح من 45% (مستوى 1) نزولاً إلى 10% (مستوى 30).
          4. أوزان الموارد ومستويات فك القفل (marketViewPanel.lua:39-48 & marketResSingle.lua:67):
             - طعام (1002): الوزن = 1، فك القفل = قلعة مستوى 1.
             - خشب (1003): الوزن = 1، فك القفل = قلعة مستوى 1.
             - حديد (1004): الوزن = 6، فك القفل = قلعة مستوى 10.
             - فضة (1005): الوزن = 24، فك القفل = قلعة مستوى 15.
             - بلور (1006): الوزن = 96، فك القفل = قلعة مستوى 30.
             - فحص قفل المورد للقلعة المرسلة والقلعة المستلمة (target_castle_level).
             - أقصى كمية للمورد = total_capacity // weight.
             - الكمية الصافية المستلمة = math.floor(max_count * (1.0 - tax_rate)).

        :param resource_type: نوع المورد (1002, 1003, 1004, 1005, 1006 أو 'food', 'wood', 'iron', 'mithril', 'crystal', إلخ).
                              إذا حدد، يتم حساب السعة العددية القصوى لهذا المورد بناءً على معامل وزنه.
        :param target_castle_level: مستوى قلعة الحليف المستلمة (اختياري). عند تمريره يتم فحص شرط فتح المورد للطرف المستلم.
        :param breakdown: إذا كان True، يتم إرجاع قاموس تفصيلي شامل لكافة تفاصيل السوق، العلم، الضريبة، وجميع الموارد.
        :return: رقم صحيح (السعة القصوى) أو قاموس تفصيلي شامل.
        """
        # ── 1. استخراج مستوى مبنى السوق (BID 112) من cityCtrl ──
        market_lv = 0
        city_ctrl = self.get_ctrl("cityCtrl")
        if isinstance(city_ctrl, dict):
            blist = city_ctrl.get("blist", [])
            if isinstance(blist, list):
                for item in blist:
                    if not isinstance(item, dict):
                        continue
                    binfo = item.get("binfo") if isinstance(item.get("binfo"), dict) else item
                    if str(binfo.get("bid")) == str(MARKET_BUILDING_ID):
                        market_lv = int(binfo.get("lv", 0) or 0)
                        break

        # سعة وضريبة السوق الأساسية من جدول build112
        base_capacity = MARKET_BASE_CAPACITY.get(market_lv, 0)
        base_tax_rate = MARKET_BASE_TAX_RATE.get(market_lv, 0.45 if market_lv == 0 else 0.10)

        # ── 2. حساب بونص علوم التحالف (ID 33002: TRADING_WEIGHT) ──
        sci_trading_weight_lv = 0
        alliance_ctrl = self.get_ctrl("allianceCtrl")
        if isinstance(alliance_ctrl, dict) and alliance_ctrl:
            # التحقق من الانتماء لتحالف نشط (ownalliid)
            aid = int(alliance_ctrl.get("aid", 0) or 0)
            if not aid:
                member_info = alliance_ctrl.get("memberinfo") or alliance_ctrl.get("memberInfo") or {}
                minfo = member_info.get("minfo") or {} if isinstance(member_info, dict) else {}
                aid = int(minfo.get("aid", 0) or 0)

            if aid > 0:
                sciencelist = alliance_ctrl.get("sciencelist") or alliance_ctrl.get("scienceList") or {}
                scilist = sciencelist.get("scilist", {}) if isinstance(sciencelist, dict) else {}

                if isinstance(scilist, dict):
                    for _, group in scilist.items():
                        if isinstance(group, list):
                            for sci_item in group:
                                if isinstance(sci_item, dict) and str(sci_item.get("id")) == str(ALLIANCE_SCIENCE_TRADING_WEIGHT_ID):
                                    sci_trading_weight_lv = int(sci_item.get("lv", 0) or 0)
                                    break
                        elif isinstance(group, dict):
                            if str(group.get("id")) == str(ALLIANCE_SCIENCE_TRADING_WEIGHT_ID):
                                sci_trading_weight_lv = int(group.get("lv", 0) or 0)
                                break
                elif isinstance(scilist, list):
                    for sci_item in scilist:
                        if isinstance(sci_item, dict) and str(sci_item.get("id")) == str(ALLIANCE_SCIENCE_TRADING_WEIGHT_ID):
                            sci_trading_weight_lv = int(sci_item.get("lv", 0) or 0)
                            break

        # معامل زيادة علم التحالف (0.01 لكل مستوى حتى 10)
        alliance_add_multiplier = ALLIANCE_SCIENCE_TRADING_WEIGHT_BONUS.get(
            sci_trading_weight_lv,
            (sci_trading_weight_lv * 0.01) if 0 <= sci_trading_weight_lv <= 10 else 0.0
        )
        alliance_bonus_weight = math.floor(base_capacity * alliance_add_multiplier)
        total_weight_capacity = int(base_capacity + alliance_bonus_weight)

        # نسبة الضريبة النهائية
        final_tax_rate = base_tax_rate

        # ── 3. حساب سعات الموارد الفردية والشروط ──
        sender_castle_lv = int(self.castle_level or 1)
        resources_details: Dict[str, Dict[str, Any]] = {}

        for rid, rmeta in MARKET_RESOURCE_WEIGHTS.items():
            r_key = rmeta["key"]
            r_weight = rmeta["weight"]
            r_unlock = rmeta["unlock_level"]

            sender_locked = (sender_castle_lv < r_unlock)
            target_locked = (target_castle_level is not None) and (int(target_castle_level) < r_unlock)
            is_locked = sender_locked or target_locked

            lock_reasons = []
            if sender_locked:
                lock_reasons.append(f"قلعة الإرسال (مستوى {sender_castle_lv}) لم تصل لمستوى فتح {rmeta['name_ar']} ({r_unlock})")
            if target_locked:
                lock_reasons.append(f"قلعة الاستلام (مستوى {target_castle_level}) لم تصل لمستوى فتح {rmeta['name_ar']} ({r_unlock})")

            if is_locked or total_weight_capacity <= 0:
                max_units = 0
                net_delivered = 0
            else:
                max_units = total_weight_capacity // r_weight
                net_delivered = math.floor(max_units * (1.0 - final_tax_rate))

            resources_details[r_key] = {
                "resource_id": rid,
                "resource_key": r_key,
                "name_ar": rmeta["name_ar"],
                "name_en": rmeta["name_en"],
                "weight_per_unit": r_weight,
                "unlock_level": r_unlock,
                "is_locked": is_locked,
                "lock_reason": " - ".join(lock_reasons) if lock_reasons else None,
                "max_capacity_units": max_units,
                "net_delivered_units": net_delivered,
            }

        # ── 4. معالجة مورد محدد إن وجد ──
        selected_res_info = None
        if resource_type is not None:
            norm_key = str(resource_type).lower().strip()
            lookup_key: Union[str, int] = int(norm_key) if norm_key.isdigit() else norm_key
            if lookup_key not in MARKET_RESOURCE_ALIASES:
                raise ValueError(
                    f"Unknown resource_type: '{resource_type}'. Valid options: {list(MARKET_RESOURCE_ALIASES.keys())}"
                )
            target_rid = MARKET_RESOURCE_ALIASES[lookup_key]
            meta = MARKET_RESOURCE_WEIGHTS[target_rid]
            selected_res_info = resources_details[meta["key"]]

        # إذا كان المطلوب قيمة رقمية مجردة (breakdown=False)
        if not breakdown:
            if selected_res_info is not None:
                return selected_res_info["max_capacity_units"]
            return total_weight_capacity

        # إرجاع تفصيل شامل ومطابق للسورس
        result: Dict[str, Any] = {
            "total_weight_capacity": total_weight_capacity,
            "market_building": {
                "bid": MARKET_BUILDING_ID,
                "name_ar": "السوق",
                "level": market_lv,
                "base_capacity": base_capacity,
                "base_tax_rate": base_tax_rate,
                "tax_percent": round(base_tax_rate * 100, 1),
            },
            "alliance_science": {
                "science_id": ALLIANCE_SCIENCE_TRADING_WEIGHT_ID,
                "name_ar": "زيادة حمولة القوات في التبادل",
                "level": sci_trading_weight_lv,
                "bonus_multiplier": round(alliance_add_multiplier, 4),
                "bonus_percent": round(alliance_add_multiplier * 100, 1),
                "bonus_weight": alliance_bonus_weight,
            },
            "tax": {
                "tax_rate": final_tax_rate,
                "tax_percent": round(final_tax_rate * 100, 1),
            },
            "resources": resources_details,
            "sender_castle_level": sender_castle_lv,
            "target_castle_level": target_castle_level,
        }

        if selected_res_info is not None:
            result["selected_resource"] = selected_res_info

        return result