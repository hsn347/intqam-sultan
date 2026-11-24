# -*- coding: utf-8 -*-
"""
tasks/building.py — مهمة ترقية القلعة الذكية والمتسلسلة وبناء المنشآت في انتقام السلاطين
═════════════════════════════════════════════════════════════════════════════════════════
تقوم هذه المهمة بإدارة وترقية مباني المدينة وترقية القلعة وفق نظام متقدم وذكي:
  1. فحص الذاكرة الحية أولاً (0-Network Pre-flight):
     - قراءة كائنات cityCtrl و queueCtrl من الذاكرة الحية مباشرة.
     - إذا كانت طوابير البناء ممتلئة بأوقات طويلة (> 60 ثانية) والتسريع غير مفعّل،
       تتوقف المهمة فوراً بصفر طلبات شبكية لحماية الخادم ومنع الحظر.
  2. ترقية القلعة وحل شجرة المتطلبات المتداخلة (Recursive Cascade):
     - فحص ما إذا كانت القلعة قيد الترقية بالفعل.
     - فحص المتطلبات المسبقة للقلعة من جدول core/buildings_prereqs.json وشرط مستوى المملكة (kingdomLv).
     - إذا تطلب الأمر ترقية مبنى آخر (مثل الأسوار 102 أو المستودع 105 أو المنشرة 202)،
       يتم حل وترقية المتطلب الأدنى أولاً بأول بشكل متسلسل استدعائي.
  3. تأمين الموارد المباشر عبر BaseTask.ensure_resources:
     - فحص أرصدة الموارد الأربعة + البلور تلقائياً دون تكرار للأكواد.
     - فتح الصناديق العادية ثم الآمنة تدريجياً وبأقل قدر ممكن لتغطية العجز بدقة.
  4. تشييد المباني المفقودة تلقائياً (Auto-Construction):
     - إذا كان أحد متطلبات القلعة أو المباني الداعمة غير مشيّد (المستوى 0)،
       يكتشف البوت الأراضي الشاغرة تلقائياً ويرسل أمر التشييد عبر (1001/2 mode: 0).
  5. تجاوز مانع وسام الحرب بذكاء (War Medal Fallback):
     - إذا كان المانع الوحيد لترقية القلعة هو نقص وسام الحرب (301101)،
       يتم تجاوز القلعة مؤقتاً والانتقال لترقية المباني الداعمة لشغل الطوابير.
  6. موازنة المباني الداعمة والمعسكرات (الأقل مستوى دائماً):
     - ترقية المزارع والمناشر ومناجم الحديد والفضة والمشافي والخيم بالتساوي مع احترام preCond و unlockedBuild.
  7. تسريع البناء بالأدوات المجانية والحقيبة عند تفعيل خيار التسريع:
     - منع الهدر: حظر التسريع إذا كان الوقت المتبقي أقل من دقيقة (< 60 ثانية).
     - تجربة التسريع المجاني الفوري أولاً (VIP 1-15 و SVIP 16-27).
     - استخدام أدوات الحقيبة بنظام الحزم المتناسبة وإغلاق الذيل ببطاقة دقيقة ثم 5 دقائق.
  8. الأمان المطلق وحماية الذهب:
     - حظر قطعي لأي عملية تستخدم الذهب (mode: 0 للترقية، mode: 0 أو 2 للتسريع).
"""

from __future__ import annotations

import asyncio
import json
import os
import random
import sys
import time
from typing import Any, Dict, List, Optional, Set, Tuple, Union

from tasks.base_task import BaseTask, TaskResult

# ════════════════════════════════════════════════════════════════════
#  تعريفات المباني في انتقام السلاطين
# ════════════════════════════════════════════════════════════════════

BUILDING_INFO: Dict[str, Dict[str, Any]] = {
    "101": {"name": "🏰 القلعة (Castle)", "name_ar": "القلعة", "category": "castle", "harvest": False, "max_lv": 130},
    "102": {"name": "🧱 الأسوار (Walls)", "name_ar": "الأسوار", "category": "walls", "harvest": False, "max_lv": 130},
    "103": {"name": "🛡️ البرج الدفاعي (Turret)", "name_ar": "البرج الدفاعي", "category": "defense", "harvest": False, "max_lv": 130},
    "104": {"name": "🔭 برج المراقبة (Watchtower)", "name_ar": "برج المراقبة", "category": "watchtower", "harvest": False, "max_lv": 30},
    "105": {"name": "📦 المستودع (Depot)", "name_ar": "المستودع", "category": "depot", "harvest": False, "max_lv": 130},
    "107": {"name": "💰 التاجر (Merchant)", "name_ar": "التاجر", "category": "merchant", "harvest": False, "max_lv": 1},
    "108": {"name": "⚓ الميناء (Port)", "name_ar": "الميناء", "category": "port", "harvest": False, "max_lv": 1},
    "111": {"name": "🏛️ السفارة (Embassy)", "name_ar": "السفارة", "category": "embassy", "harvest": False, "max_lv": 130},
    "112": {"name": "⚖️ السوق (Market)", "name_ar": "السوق", "category": "market", "harvest": False, "max_lv": 30},
    "113": {"name": "🎓 المعهد / الأكاديمية (College)", "name_ar": "المعهد", "category": "college", "harvest": False, "max_lv": 130},
    "114": {"name": "⛲ نافورة الأمنيات (Wishing Well)", "name_ar": "نافورة الأمنيات", "category": "wishing", "harvest": False, "max_lv": 130},
    "115": {"name": "⚒️ الحداد (Blacksmith)", "name_ar": "الحداد", "category": "blacksmith", "harvest": False, "max_lv": 30},
    "116": {"name": "🐎 معسكر الخيالة (Cavalry Barracks)", "name_ar": "معسكر الخيالة", "category": "camp", "harvest": False, "max_lv": 130},
    "117": {"name": "🏹 معسكر الرماة (Archer Barracks)", "name_ar": "معسكر الرماة", "category": "camp", "harvest": False, "max_lv": 130},
    "118": {"name": "🛡️ معسكر المشاة (Infantry Barracks)", "name_ar": "معسكر المشاة", "category": "camp", "harvest": False, "max_lv": 130},
    "119": {"name": "🚜 معسكر العربات (Chariot Barracks)", "name_ar": "معسكر العربات", "category": "camp", "harvest": False, "max_lv": 130},
    "120": {"name": "🏰 الحصن (Fortress)", "name_ar": "الحصن", "category": "fortress", "harvest": False, "max_lv": 30},
    "121": {"name": "🎯 ساحة التدريب (Drill Grounds)", "name_ar": "ساحة التدريب", "category": "drill", "harvest": False, "max_lv": 130},
    "122": {"name": "⚔️ قاعة الحرب (Hall of War)", "name_ar": "قاعة الحرب", "category": "warhall", "harvest": False, "max_lv": 130},
    "201": {"name": "🌾 مزرعة القمح (Farm)", "name_ar": "مزرعة القمح", "category": "resource", "harvest": True, "max_lv": 130},
    "202": {"name": "🪵 منشرة الخشب (Sawmill)", "name_ar": "منشرة الخشب", "category": "resource", "harvest": True, "max_lv": 130},
    "203": {"name": "⛏️ منجم الحديد (Iron Mine)", "name_ar": "منجم الحديد", "category": "resource", "harvest": True, "max_lv": 130},
    "204": {"name": "🪙 منجم الفضة (Silver Mine)", "name_ar": "منجم الفضة", "category": "resource", "harvest": True, "max_lv": 130},
    "205": {"name": "⛺ الخيمة العسكرية (Military Tent)", "name_ar": "الخيمة العسكرية", "category": "tent", "harvest": False, "max_lv": 130},
    "206": {"name": "🏥 المركز الطبي / المشفى (Hospital)", "name_ar": "المركز الطبي", "category": "hospital", "harvest": False, "max_lv": 130},
    "207": {"name": "💎 منجم البلور (Crystal Mine)", "name_ar": "منجم البلور", "category": "crystal", "harvest": True, "max_lv": 130},
    "301": {"name": "🎖️ هيبة السلطان (Sultan's Glory)", "name_ar": "هيبة السلطان", "category": "honor", "harvest": False, "max_lv": 130},
    "302": {"name": "👑 القصر النخبوي (Elite Palace)", "name_ar": "القصر النخبوي", "category": "elite", "harvest": False, "max_lv": 5},
}

# خريطة أسماء المباني المستعارة
BUILDING_KEY_TO_BID: Dict[str, str] = {
    "farm": "201", "wheat": "201", "tahil": "201", "201": "201", "مزرعة": "201", "مزرعة القمح": "201",
    "sawmill": "202", "wood": "202", "odun": "202", "202": "202", "منشرة": "202", "منشرة الخشب": "202",
    "iron_mine": "203", "iron": "203", "demir": "203", "203": "203", "حديد": "203", "منجم الحديد": "203",
    "quartz_mine": "204", "silver_mine": "204", "silver": "204", "فضة": "204", "منجم الفضة": "204", "204": "204",
    "hospital": "206", "medical_tent": "206", "clinic": "206", "hastane": "206", "206": "206", "مشفى": "206", "المركز الطبي": "206",
    "military_tent": "205", "tent": "205", "cadir": "205", "205": "205", "خيمة": "205", "الخيمة العسكرية": "205",
    "castle": "101", "walls": "102", "wall": "102", "depot": "105", "college": "113",
}

# خريطة ربط المباني بطوابير أنشطتها الداخلية (أبحاث، تدريب، علاج، تصنيع)
BUILDING_INTERNAL_QUEUES: Dict[str, str] = {
    "113": "1212",  # المعهد / الأكاديمية -> أبحاث التكنولوجيا (لا يمكن ترقيته أثناء البحث)
    "116": "1204",  # إسطبل الفرسان -> تدريب الفرسان
    "117": "1205",  # ميدان الرماية -> تدريب الرماة
    "118": "1203",  # معسكر المشاة -> تدريب المشاة
    "119": "1206",  # معسكر العربات -> تدريب العربات
    "120": "1207",  # القلعة الحربية / الحصن -> تصنيع الفخاخ
    "206": "1202",  # المشفى / المركز الطبي -> علاج الجرحى
    "115": "1229",  # الحداد -> صناعة العتاد
}

# ════════════════════════════════════════════════════════════════════
#  محددات مواقع البناء في المدينة (رسمية من سورس اللعبة Lua)
# ════════════════════════════════════════════════════════════════════

FIXED_BUILDING_INDEXES: Dict[str, str] = {
    "101": "1050",  # القلعة
    "102": "1053",  # الأسوار
    "103": "1052",  # البرج الدفاعي الأيسر (والأيمن 1054)
    "104": "1055",  # برج المراقبة
    "108": "1068",  # الميناء
    "207": "1152",  # منجم البلور (الكريستال)
    "301": "1200",  # هيبة السلطان
    "302": "1201",  # القصر النخبوي
    "1151": "1151", # ورشة المواد
}

# مستوى البداية الرسمي عند تشييد مبنى جديد لأول مرة (build301.lua: هيبة السلطان تبدأ من Lv.30)
BUILDING_START_LV: Dict[str, int] = {
    "301": 30,
}

# مستوى القلعة المطلوب لفتح تشييد المباني المساندة (من unlockedBuild في build101.lua)
SUPPORT_BUILDING_UNLOCK_CASTLE_LV: Dict[str, int] = {
    "201": 1,
    "202": 1,
    "203": 10,  # منجم الحديد
    "204": 15,  # منجم الفضة
    "205": 1,
    "206": 1,
}

# الحد الأدنى لمستوى المملكة المطلوب لترقية القلعة Lv.81-130 (من kingdomLv في build101.lua)
CASTLE_KINGDOM_LV_REQ: List[Tuple[int, int]] = [
    (121, 50),
    (111, 40),
    (101, 30),
    (91, 20),
    (81, 10),
]

PREFER_INNER_CITY_INDEXES_STABLES: List[int] = [
    1064, 1063, 1067, 1061, 1062, 1065, 1058, 1059, 1060
]

PREFER_INNER_CITY_INDEXES: List[int] = [
    1067, 1061, 1062, 1064, 1063, 1065, 1058, 1059, 1060
]

PREFER_OUTER_CITY_INDEXES_SPECIAL: Dict[int, List[int]] = {
    201: [1102, 1100, 1101, 1103, 1104],
    202: [1107, 1105, 1106, 1108, 1109],
    205: [1111, 1110, 1112, 1113, 1114],
}

PREFER_OUTER_CITY_INDEXES_GENERAL: List[int] = [
    1107, 1102, 1104, 1106, 1111, 1103, 1101, 1100, 1108, 1109, 1105
]

OPEN_GROUND_AREAS: Dict[int, Tuple[int, int]] = {
    1220: (1115, 1119),
    1221: (1120, 1124),
    1222: (1125, 1129),
    1223: (1130, 1134),
}


def get_can_build_index(
    bid: Union[str, int],
    used_indexes: Set[str],
    open_areas: Optional[List[int]] = None
) -> Optional[str]:
    """تحديد خانة بناء شاغرة ومناسبة طبقاً لخوارزمية اللعبة الرسمية (mainCityFunctions.lua)."""
    try:
        bid_int = int(bid)
    except Exception:
        bid_int = 0
    bid_str = str(bid)

    # 1. مباني المواقع الثابتة
    if bid_str in FIXED_BUILDING_INDEXES:
        if bid_str == "103":
            if "1052" not in used_indexes:
                return "1052"
            elif "1054" not in used_indexes:
                return "1054"
            return None
        fixed_idx = FIXED_BUILDING_INDEXES[bid_str]
        return fixed_idx if fixed_idx not in used_indexes else None

    if bid_int == 301:
        return "1200" if "1200" not in used_indexes else None

    # 2. تحديد نوع المبنى (داخلي أم خارجي)
    is_inner = (bid_int < 200 or bid_int > 30000 or bid_int >= 300)
    candidate_indexes: List[int] = []

    def _add(idx: int):
        if idx not in candidate_indexes:
            candidate_indexes.append(idx)

    if is_inner:
        if bid_int == 116:  # معسكر الخيالة
            for idx in PREFER_INNER_CITY_INDEXES_STABLES:
                _add(idx)
        else:
            for idx in PREFER_INNER_CITY_INDEXES:
                _add(idx)
        _add(1051)
        for idx in range(1056, 1068):
            _add(idx)
    else:
        if bid_int in PREFER_OUTER_CITY_INDEXES_SPECIAL:
            for idx in PREFER_OUTER_CITY_INDEXES_SPECIAL[bid_int]:
                _add(idx)
        for idx in PREFER_OUTER_CITY_INDEXES_GENERAL:
            _add(idx)
        for idx in range(1100, 1115):
            _add(idx)
        if open_areas:
            for area_id in open_areas:
                if area_id in OPEN_GROUND_AREAS:
                    min_idx, max_idx = OPEN_GROUND_AREAS[area_id]
                    for idx in range(min_idx, max_idx + 1):
                        _add(idx)

    for idx in candidate_indexes:
        idx_str = str(idx)
        if idx_str not in used_indexes:
            return idx_str

    return None


# جدول ثواني التسريع المجاني الفوري بحسب رتبة VIP (امتياز 7201 من vipbuff.lua)
VIP_FREE_SPEEDUP_SECONDS: Dict[int, int] = {
    1: 360,     # 6 د
    2: 480,     # 8 د
    3: 600,     # 10 د
    4: 720,     # 12 د
    5: 900,     # 15 د
    6: 1200,    # 20 د
    7: 1800,    # 30 د
    8: 2700,    # 45 د
    9: 3600,    # 60 د (ساعة)
    10: 5400,   # 90 د (ساعة ونصف)
    11: 7200,   # 120 د (ساعتان)
    12: 9000,   # 150 د (ساعتان ونصف)
    13: 10800,  # 180 د (3 ساعات)
    14: 12600,  # 210 د (3.5 ساعات)
    15: 14400,  # 240 د (4 ساعات — وينطبق أيضاً على SVIP 16-27)
}
BASE_FREE_SPEEDUP_SECONDS: int = 300  # 5 دقائق لغير المشتركين في VIP

# أدوات تسريع البناء والتسريع العام مرتبة من الأطول للأقصر
SPEEDUP_ITEMS: List[Tuple[int, int, str]] = [
    # أدوات تسريع البناء المتخصصة (5011xx)
    (501105, 86400, "تسريع بناء 24 ساعة"),
    (501104, 43200, "تسريع بناء 12 ساعة"),
    (501103, 28800, "تسريع بناء 8 ساعات"),
    (501102, 7200,  "تسريع بناء ساعتين"),
    (501107, 3600,  "تسريع بناء ساعة"),
    (501109, 1800,  "تسريع بناء 30 دقيقة"),
    (501108, 900,   "تسريع بناء 15 دقيقة"),
    (501101, 300,   "تسريع بناء 5 دقائق"),
    (501106, 60,    "تسريع بناء دقيقة"),
    # أدوات التسريع العام (5006xx)
    (500605, 86400, "تسريع عام 24 ساعة"),
    (500604, 43200, "تسريع عام 12 ساعة"),
    (500603, 28800, "تسريع عام 8 ساعات"),
    (500602, 3600,  "تسريع عام ساعة"),
    (500608, 1800,  "تسريع عام 30 دقيقة"),
    (500607, 900,   "تسريع عام 15 دقيقة"),
    (500601, 300,   "تسريع عام 5 دقائق"),
    (500606, 60,    "تسريع عام دقيقة"),
]

# كاش حفظ متطلبات المباني المحملة
_BUILDINGS_CONFIG_CACHE: Optional[Dict[str, Dict[str, Any]]] = None


def load_all_building_configs() -> Dict[str, Dict[str, Any]]:
    """تحميل متطلبات وتكاليف كافة المباني من ملف JSON الشامل core/buildings_prereqs.json"""
    global _BUILDINGS_CONFIG_CACHE
    if _BUILDINGS_CONFIG_CACHE is not None:
        return _BUILDINGS_CONFIG_CACHE

    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    target_path = os.path.join(root_dir, "core", "buildings_prereqs.json")

    if os.path.exists(target_path):
        try:
            with open(target_path, "r", encoding="utf-8") as f:
                _BUILDINGS_CONFIG_CACHE = json.load(f)
                return _BUILDINGS_CONFIG_CACHE
        except Exception:
            pass

    _BUILDINGS_CONFIG_CACHE = {}
    return _BUILDINGS_CONFIG_CACHE


def get_building_level_config(bid: Union[str, int], lv: int) -> Dict[str, Any]:
    """جلب إعدادات وتكاليف مستوى معين لمبنى محدد"""
    all_cfg = load_all_building_configs()
    b_data = all_cfg.get(str(bid), {})
    return b_data.get(str(lv), {})


def format_duration(seconds: Optional[Union[float, int]]) -> str:
    """تنسيق المدة بالثواني إلى نص مقروء بالعربية"""
    total_sec = int(max(0, float(seconds or 0)))
    days = total_sec // 86400
    rem = total_sec % 86400
    hours = rem // 3600
    minutes = (rem % 3600) // 60
    secs = rem % 60
    parts = []
    if days > 0:
        parts.append(f"{days} يوم")
    if hours > 0:
        parts.append(f"{hours} س")
    if minutes > 0 or (days == 0 and hours > 0):
        parts.append(f"{minutes} د")
    if secs > 0 and days == 0 and hours == 0:
        parts.append(f"{secs} ث")
    return " و ".join(parts) if parts else "0 ث"


# ════════════════════════════════════════════════════════════════════
#  فئة المهمة (BuildingTask)
# ════════════════════════════════════════════════════════════════════

class BuildingTask(BaseTask):
    """
    مهمة ترقية القلعة الذكية والمتسلسلة ومباني الموارد والمعسكرات في انتقام السلاطين
    مع حل شجرة المتطلبات المتداخلة، وتأمين الموارد المباشر، وتشييد المباني المفقودة،
    وتسريع الطوابير بالأدوات والحقيبة، وحظر استخدام الذهب بشكل قطعي.
    """
    name = "building"
    alias = "upgrade"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Any] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)
        self.max_build_slots: int = 1
        self.active_queues: Dict[str, Dict[str, Any]] = {}
        self.upgraded_prereq_bids: Set[str] = set()

    # ── قراءة واستعلام بيانات المدينة والطوابير ──

    def _get_city_ctrl(self) -> Dict[str, Any]:
        """قراءة متحكم المدينة من الذاكرة الحية (0-Network)"""
        ctrl = self.get_ctrl("cityCtrl")
        return ctrl if isinstance(ctrl, dict) else {}

    def _get_city_buildings(self) -> List[Dict[str, Any]]:
        """جلب قائمة مباني المدينة من الذاكرة الحية مع تصفية القواميس الصالحة حصراً"""
        city = self._get_city_ctrl()
        blist = city.get("blist", [])
        if isinstance(blist, list):
            return [b for b in blist if isinstance(b, dict)]
        return []

    def _get_open_areas(self) -> List[int]:
        """جلب قائمة الأراضي المفتوحة للتوسعة من الذاكرة الحية"""
        city = self._get_city_ctrl()
        areas = city.get("arealist") or city.get("areaList", [])
        if isinstance(areas, list):
            return [int(a) for a in areas if str(a).isdigit()]
        return []

    def is_building_busy_with_activity(self, bid: str) -> Tuple[bool, str]:
        """
        فحص هل المبنى مشغول بنشاط داخلي (أبحاث، تدريب، علاج، تصنيع) من الذاكرة الحية (0-Network).
        اللعبة تمنع ترقية المبنى أثناء انشغاله بخطأ Err_BUILDSTATE_NOT_NORMAL (1005).
        """
        qtype = BUILDING_INTERNAL_QUEUES.get(str(bid))
        if not qtype:
            return False, ""

        qctrl = self.get_ctrl("queueCtrl")
        if not isinstance(qctrl, dict):
            return False, ""

        q_info = qctrl.get(str(qtype))
        if isinstance(q_info, dict):
            st = float(q_info.get("starttime", 0) or 0)
            tt = float(q_info.get("totaltime", 0) or 0)
            now_ts = time.time()
            rem = max(0.0, (st + tt) - now_ts) if st > 0 else float(q_info.get("ottime", 0) or tt)
            if rem > 0:
                act_names = {
                    "1212": "أبحاث علمية جارية في المعهد",
                    "1204": "تدريب فرسان جاري",
                    "1205": "تدريب رماة جاري",
                    "1203": "تدريب مشاة جاري",
                    "1206": "تدريب عربات جاري",
                    "1207": "تصنيع فخاخ جاري",
                    "1202": "علاج جرحى جاري",
                    "1229": "صناعة عتاد جارية",
                }
                act_name = act_names.get(qtype, f"نشاط داخلي (طابور {qtype})")
                return True, f"{act_name} (متبقٍ: {format_duration(rem)})"

        return False, ""

    def _is_vip_active(self) -> Tuple[bool, int]:
        """
        فحص دقيق وصارم لسريان امتيازات VIP بناءً على مستوى VIP وتاريخ الانتهاء vipEndTime:
        يرث مباشرة من BaseTask (0-Network).
        """
        return self.is_vip_active, self.vip_level

    def calculate_free_speedup_seconds(self) -> int:
        """
        حساب ثواني التسريع المجاني الفوري المتاحة ديناميكياً للحساب:
        1. قراءة lordInfoCtrl.vip من الذاكرة الحية (0-Network).
        2. التحقق من سريان VIP بدقة (vipEndTime > 0 و vipEndTime > time.time()).
        3. استخدام جدول الامتياز 7201 الرسمي (من 360ث لـ VIP 1 حتى 14,400ث لـ VIP 15 و SVIP 16-27).
        4. العودة للحد الأساسي (300ث = 5 دقائق) عند انتهاء VIP أو عدم توفره.
        """
        base_free = BASE_FREE_SPEEDUP_SECONDS
        vip_active, vip_lv = self._is_vip_active()

        if vip_active and vip_lv > 0:
            if vip_lv >= 15:
                return VIP_FREE_SPEEDUP_SECONDS[15]
            return VIP_FREE_SPEEDUP_SECONDS.get(vip_lv, base_free)

        return base_free

    def _get_castle_level(self) -> int:
        """جلب مستوى القلعة الحالي من الذاكرة الحية (0-Network)"""
        city = self._get_city_ctrl()
        c_lv = int(city.get("level", 0) or 0)
        if c_lv > 0:
            return c_lv
        blist = self._get_city_buildings()
        for b in blist:
            if not isinstance(b, dict):
                continue
            bi = b.get("binfo", {})
            if isinstance(bi, dict) and str(bi.get("bid", "")) == "101":
                return int(bi.get("lv", 0) or 0)
        return 0

    def get_castle_instance(self) -> Dict[str, Any]:
        """جلب كائن القلعة من الذاكرة الحية"""
        blist = self._get_city_buildings()
        for b in blist:
            if not isinstance(b, dict):
                continue
            bi = b.get("binfo", {})
            if isinstance(bi, dict) and str(bi.get("bid", "")) == "101":
                return bi
        return {}

    async def refresh_active_queues(self, force_query: bool = False) -> Dict[str, Dict[str, Any]]:
        """
        تحديث طوابير البناء النشطة:
        - تفحص الذاكرة الحية أولاً 0-Network (queueCtrl ثم cityCtrl.queue).
        - إذا كان كائن queueCtrl موجوداً في الذاكرة الحية، ترجع الطوابير النشطة فوراً حتى لو كانت فارغة {} دون أي استعلام شبكي.
        - لا ترسل CMD 1003 / 1 إلا إذا طُلب force_query=True صراحة أو كانت الذاكرة غير محملة إطلاقاً.
        """
        active: Dict[str, Dict[str, Any]] = {}
        now_ts = time.time()

        q_ctrl = self.get_ctrl("queueCtrl")
        has_memory = isinstance(q_ctrl, dict)

        if not force_query and has_memory:
            # قراءة طوابير البناء 1200 و 1201 مباشرة من الذاكرة الحية
            for qtype in ["1200", "1201"]:
                q_info = q_ctrl.get(qtype)
                if isinstance(q_info, dict):
                    st = float(q_info.get("starttime", 0) or 0)
                    tt = float(q_info.get("totaltime", 0) or 0)
                    rem = max(0.0, (st + tt) - now_ts) if st > 0 else float(q_info.get("ottime", 0) or tt)
                    inner = q_info.get("data", {}) if isinstance(q_info.get("data"), dict) else q_info
                    bid = str(inner.get("bid", "") or q_info.get("bid", ""))
                    lv = int(inner.get("lv", 0) or q_info.get("lv", 0) or 0)
                    idx = str(inner.get("index", "") or q_info.get("index", ""))
                    if rem > 0 and bid:
                        active[qtype] = {
                            "qtype": qtype,
                            "bid": bid,
                            "lv": lv,
                            "index": idx,
                            "remain_time": rem,
                            "raw": q_info,
                        }
                    else:
                        # تنظيف الطابور المنتهي من الذاكرة الحية
                        q_ctrl.pop(str(qtype), None)

            # 0-Network: نرجع النتيجة فوراً حتى لو كانت active فارغة {}
            self.active_queues = active
            return active

        # استعلام رسمي من السيرفر عند اللزوم فقط (CMD 1003 / SubCMD 1)
        resp = await self.safe_query("1003", "1", {}, min_delay=0.5, max_delay=0.9)
        if resp and isinstance(resp, dict):
            r_data = resp.get("data", {})
            if isinstance(r_data, dict):
                now_ts = time.time()
                for qtype in ["1200", "1201"]:
                    q_info = r_data.get(qtype)
                    if isinstance(q_info, dict):
                        inner = q_info.get("data", {}) if isinstance(q_info.get("data"), dict) else q_info
                        bid = str(inner.get("bid", "") or q_info.get("bid", ""))
                        lv = int(inner.get("lv", 0) or q_info.get("lv", 0) or 0)
                        idx = str(inner.get("index", "") or q_info.get("index", ""))
                        st = float(q_info.get("starttime", 0) or 0)
                        tt = float(q_info.get("totaltime", 0) or 0)
                        rem = max(0.0, (st + tt) - now_ts) if st > 0 else float(q_info.get("ottime", 0) or tt)
                        if rem > 0 and bid:
                            active[qtype] = {
                                "qtype": qtype,
                                "bid": bid,
                                "lv": lv,
                                "index": idx,
                                "remain_time": rem,
                                "raw": q_info,
                            }
                            if isinstance(q_ctrl, dict):
                                q_ctrl[str(qtype)] = q_info
                        else:
                            if isinstance(q_ctrl, dict):
                                q_ctrl.pop(str(qtype), None)
        self.active_queues = active
        return active

    def calculate_max_build_slots(self) -> int:
        """
        تحديد السعة القصوى لطوابير البناء للحساب (1 أو 2 طابور) بدقة من الذاكرة الحية (0-Network):
        1. VIP >= 2 يمنح الطابور الثاني (1201) فقط إذا كان VIP سارياً ومفعلاً (vipEndTime > 0 و vipEndTime > time.time()).
        2. استئجار الطابور 1201 ساري المفعول في cityCtrl.queue["1201"] (starttime + totaltime > time.time()).
        3. وجود طابور 1201 نشط يبني بالفعل في queueCtrl["1201"] (remain_time > 0 و bid محدد).
        4. وجود طابور 1201 نشط يبني بالفعل في self.active_queues["1201"] (remain_time > 0 و bid محدد).
        5. عند انتهاء VIP وعدم توفر استئجار أو بناء نشط في 1201، ترجع 1 بدقة.
        """
        now_ts = time.time()

        # 1. فحص الـ VIP وسريانه من lordInfoCtrl.vip (VIP >= 2 نشط فقط يمنح الطابور الثاني 1201 مجاناً)
        vip_active, vip_lv = self._is_vip_active()
        if vip_active and vip_lv >= 2:
            self.max_build_slots = 2
            return 2

        # 2. فحص استئجار الطابور 1201 في cityCtrl.queue
        city = self._get_city_ctrl()
        q_dict = city.get("queue", {}) if isinstance(city, dict) else {}
        if isinstance(q_dict, dict) and "1201" in q_dict:
            q1201 = q_dict["1201"]
            if isinstance(q1201, dict):
                try:
                    st = float(q1201.get("starttime", 0) or 0)
                    tt = float(q1201.get("totaltime", 0) or 0)
                    if st > 0 and tt > 0 and (st + tt) > now_ts:
                        self.max_build_slots = 2
                        return 2
                except (ValueError, TypeError):
                    pass

        # 3. فحص هل الطابور 1201 يبني بالفعل ونشط حالياً في queueCtrl
        qctrl = self.get_ctrl("queueCtrl")
        if isinstance(qctrl, dict) and "1201" in qctrl:
            q1201_act = qctrl["1201"]
            if isinstance(q1201_act, dict):
                try:
                    st = float(q1201_act.get("starttime", 0) or 0)
                    tt = float(q1201_act.get("totaltime", 0) or 0)
                    rem = max(0.0, (st + tt) - now_ts) if st > 0 else float(q1201_act.get("ottime", 0) or tt)
                    inner = q1201_act.get("data", {}) if isinstance(q1201_act.get("data"), dict) else q1201_act
                    bid = str(inner.get("bid", "") or q1201_act.get("bid", ""))
                    if rem > 0 and bid:
                        self.max_build_slots = 2
                        return 2
                except (ValueError, TypeError):
                    pass

        # 4. فحص هل الطابور 1201 يبني بالفعل في active_queues الحالية
        if hasattr(self, "active_queues") and isinstance(self.active_queues, dict) and "1201" in self.active_queues:
            q1201_mem = self.active_queues["1201"]
            if isinstance(q1201_mem, dict):
                try:
                    rem = float(q1201_mem.get("remain_time", 0) or 0)
                    bid = str(q1201_mem.get("bid", ""))
                    if rem > 0 and bid:
                        self.max_build_slots = 2
                        return 2
                except (ValueError, TypeError):
                    pass

        self.max_build_slots = 1
        return 1

    def sync_in_memory_upgrade(
        self,
        qtype: str,
        bid: str,
        target_lv: int,
        index: str,
        cost_time: int = 3600,
        cost_res: Optional[Dict[str, Any]] = None,
    ):
        """مزامنة فورية للذاكرة الحية محلياً عند بدء الترقية أو التشييد (0-Network Sync)"""
        now_ts = time.time()
        bid_str = str(bid)
        qtype_str = str(qtype)

        # 1. تحديث حالة المبنى في cityCtrl.blist
        city = self._get_city_ctrl()
        blist = city.get("blist", [])
        found = False
        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                bi = b.get("binfo", {})
                if isinstance(bi, dict) and str(bi.get("bid", "")) == bid_str and str(bi.get("index", "")) == str(index):
                    bi["state"] = "2"
                    found = True
                    break
            if not found:
                blist.append({
                    "binfo": {
                        "bid": bid_str,
                        "lv": str(target_lv),
                        "index": str(index),
                        "state": "2",
                        "curres": "0.0",
                        "iid": "0",
                    }
                })

        # 2. إضافة الطابور النشط في queueCtrl
        qctrl = self.get_ctrl("queueCtrl")
        if isinstance(qctrl, dict):
            qctrl[qtype_str] = {
                "qtype": qtype_str,
                "starttime": now_ts,
                "totaltime": cost_time,
                "data": {
                    "bid": bid_str,
                    "lv": str(target_lv),
                    "index": str(index),
                    "iid": "0",
                }
            }

        # 3. تحديث active_queues محلياً
        self.active_queues[qtype_str] = {
            "qtype": qtype_str,
            "bid": bid_str,
            "lv": target_lv,
            "index": str(index),
            "remain_time": float(cost_time),
            "raw": qctrl.get(qtype_str, {}) if isinstance(qctrl, dict) else {},
        }

        # 4. خصم الموارد محلياً من cityCtrl.reslist و cityCtrl.resList معاً (مع منع الخصم المزدوج إن كانا نفس الكائن)
        if cost_res and isinstance(cost_res, dict):
            seen_dict_ids: Set[int] = set()
            for res_key in ("reslist", "resList"):
                res_dict = city.get(res_key)
                if isinstance(res_dict, dict) and id(res_dict) not in seen_dict_ids:
                    seen_dict_ids.add(id(res_dict))
                    for res_id, req_amt in cost_res.items():
                        k = str(res_id)
                        if k in res_dict:
                            curr_v = float(res_dict[k] or 0)
                            res_dict[k] = str(max(0.0, curr_v - float(req_amt or 0)))

    def sync_in_memory_completed_queue(
        self,
        qtype: str,
        bid: str,
        target_lv: Optional[int] = None,
        index: Optional[Union[str, int]] = None,
    ):
        """مزامنة فورية للذاكرة الحية محلياً عند اكتمال الطابور بالتسريع أو الوقت (0-Network Sync)"""
        bid_str = str(bid)
        qtype_str = str(qtype)

        qctrl = self.get_ctrl("queueCtrl")
        target_index = str(index) if index is not None else None
        if not target_index:
            if isinstance(qctrl, dict) and qtype_str in qctrl:
                q_data = qctrl[qtype_str].get("data", {})
                if isinstance(q_data, dict) and q_data.get("index"):
                    target_index = str(q_data.get("index"))
            if not target_index and qtype_str in self.active_queues:
                q_idx = self.active_queues[qtype_str].get("index")
                if q_idx:
                    target_index = str(q_idx)
                else:
                    q_raw = self.active_queues[qtype_str].get("raw", {})
                    if isinstance(q_raw, dict):
                        q_data = q_raw.get("data", {})
                        if isinstance(q_data, dict) and q_data.get("index"):
                            target_index = str(q_data.get("index"))

        # 1. إزالة الطابور من queueCtrl و active_queues
        if isinstance(qctrl, dict):
            qctrl.pop(qtype_str, None)
        self.active_queues.pop(qtype_str, None)

        # 2. تحديث المبنى إلى المستوى الجديد والحالة العادية (state = "0")
        city = self._get_city_ctrl()
        blist = city.get("blist", [])
        if isinstance(blist, list):
            for b in blist:
                if not isinstance(b, dict):
                    continue
                bi = b.get("binfo", {})
                if not isinstance(bi, dict):
                    continue
                if str(bi.get("bid", "")) == bid_str:
                    if target_index:
                        if str(bi.get("index", "")) != target_index:
                            continue
                    else:
                        if str(bi.get("state", "0")) != "2":
                            continue
                    bi["state"] = "0"
                    if target_lv is not None:
                        bi["lv"] = str(target_lv)
                    else:
                        bi["lv"] = str(int(bi.get("lv", 0) or 0) + 1)
                    break

        # 3. إذا كان المبنى هو القلعة، تحديث cityCtrl["level"]
        if bid_str == "101":
            if target_lv is not None:
                city["level"] = int(target_lv)
            else:
                city["level"] = int(city.get("level", 0) or 0) + 1

    def sync_in_memory_consumed_items(self, items_used: List[Dict[str, int]]):
        """خصم أدوات التسريع المستهلكة من backpackCtrl محلياً"""
        bag = self.get_ctrl("backpackCtrl")
        if not isinstance(bag, dict):
            return
        for it in items_used:
            s_id = str(it.get("id", ""))
            cnt = int(it.get("count", 0) or 0)
            if s_id in bag:
                if isinstance(bag[s_id], dict):
                    bag[s_id]["count"] = max(0, int(bag[s_id].get("count", 0)) - cnt)
                else:
                    bag[s_id] = max(0, int(bag[s_id] or 0) - cnt)

    def get_selected_support_bids(self) -> List[str]:
        """جلب قائمة المباني الداعمة المستهدفة من إعدادات المستخدم"""
        cfg = self.config
        tb = cfg.get("target_buildings", {})
        default_bids = ["201", "202", "203", "204", "206", "205"]

        if isinstance(tb, dict) and tb:
            selected = []
            for k, enabled in tb.items():
                if bool(enabled):
                    bid = BUILDING_KEY_TO_BID.get(str(k).lower())
                    if bid and bid not in selected:
                        selected.append(bid)
            return [b for b in default_bids if b in selected]

        return default_bids

    # ── التشييد والترقية والجمع ──

    async def harvest_building_resource(self, bid: int, iid: int) -> bool:
        """جمع المحصول من مبنى الموارد قبل البدء بترقيته (CMD 1001 / SubCMD 8)"""
        try:
            resp = await self.safe_query("1001", "8", {"bid": bid, "iid": iid}, min_delay=0.5, max_delay=0.9)
            return isinstance(resp, dict) and str(resp.get("err", "-1")) == "0"
        except Exception:
            return False

    async def construct_missing_building(self, bid: str) -> Tuple[bool, str]:
        """
        تشييد مبنى مفقود غير موجود إطلاقاً في المدينة:
        1. تحديد خانة البناء الشاغرة المناسبة عبر خوارزمية اللعبة الرسمية get_can_build_index.
        2. تأمين موارد مستوى البداية الرسمي عبر BaseTask.ensure_resources.
        3. إرسال أمر التشييد عبر CMD 1001 / SubCMD 2 (mode: "0").
        """
        bid_str = str(bid)
        b_meta = BUILDING_INFO.get(bid_str, {"name": f"مبنى #{bid_str}"})
        b_name = b_meta["name"]

        blist = self._get_city_buildings()
        used_indexes: Set[str] = {
            str(item.get("binfo", {}).get("index", ""))
            for item in blist
            if isinstance(item, dict) and isinstance(item.get("binfo"), dict) and item.get("binfo", {}).get("index")
        }

        open_areas = self._get_open_areas()
        target_index = get_can_build_index(bid_str, used_indexes, open_areas)

        if not target_index or target_index in used_indexes:
            msg = f"❌ تعذر العثور على قطعة أرض شاغرة في المدينة لبناء {b_name}!"
            self.log(msg)
            return False, msg

        # التحقق من توفر طابور بناء شاغر
        await self.refresh_active_queues()
        if len(self.active_queues) >= self.max_build_slots:
            msg = f"🛑 طوابير البناء ممتلئة ({len(self.active_queues)}/{self.max_build_slots}) — تعذر بناء {b_name}."
            return False, msg

        # تأمين الموارد المطلوبة لمستوى البداية الرسمي (Lv.1 لمعظم المباني و Lv.30 لهيبة السلطان 301)
        start_lv = BUILDING_START_LV.get(bid_str, 1)
        lv1_cfg = get_building_level_config(bid_str, start_lv)
        cost_res = lv1_cfg.get("costRes", {})
        cost_time = int(lv1_cfg.get("costTime", 3600) or 3600)

        # فحص عجز الموارد في الذاكرة الحية أولاً (0-Network Pre-flight)
        city = self._get_city_ctrl()
        reslist = city.get("reslist", {}) or city.get("resList", {}) if isinstance(city, dict) else {}
        missing_res = {
            r_id: int(float(amt) - float(reslist.get(str(r_id), 0) or 0))
            for r_id, amt in cost_res.items()
            if float(reslist.get(str(r_id), 0) or 0) < float(amt)
        }
        if missing_res:
            if bool(self.config.get("auto_open_chests", True)):
                res_result = await self.ensure_resources(missing_res, multiplier=1)
                if not res_result.get("success", False):
                    msg = f"⚠️ نقص موارد لتشييد {b_name} في الموقع [{target_index}] والصناديق غير كافية!"
                    self.log(msg)
                    return False, msg
            else:
                msg = f"⚠️ نقص موارد لتشييد {b_name} في الموقع [{target_index}] (فتح الصناديق معطل)!"
                self.log(msg)
                return False, msg

        # إرسال أمر التشييد بالموارد فقط (mode: "0")
        self.log(f"🏗️ إرسال أمر تشييد {b_name} في الموقع الشاغر [{target_index}]...")
        payload = {"bid": bid_str, "mode": "0", "index": str(target_index)}
        resp = await self.safe_query("1001", "2", payload, min_delay=0.5, max_delay=0.9)

        err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"
        if err == "0":
            msg = f"🎉 تم تشييد مبنى {b_name} بنجاح في الموقع [{target_index}]!"
            self.log(msg)
            self.upgraded_prereq_bids.add(bid_str)
            # تحديث الذاكرة الحية محلياً دون أي طلب شبكي (0-Network Sync)
            allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
            self.sync_in_memory_upgrade(allocated_qtype, bid_str, start_lv, str(target_index), cost_time, cost_res)
            return True, msg
        elif err in ("1001", "1008"):
            return False, f"🛑 طوابير البناء ممتلئة بالسيرفر — تعذر بناء {b_name}."
        elif err == "1020":
            return False, f"❌ الخانة [{target_index}] مشغولة بالسيرفر (كود: 1020)."
        else:
            return False, f"⚠️ فشل أمر تشييد {b_name} (كود خطأ: {err})"

    # ── شجرة المتطلبات العودية ومحرك الأوراق الجاهزة (Recursive Dependency Engine - R1) ──

    def find_ready_prerequisites(self, target_bid: str, target_blv: int) -> List[Dict[str, Any]]:
        """
        تتبع شجرة المتطلبات تكرارياً من الأسفل إلى الأعلى (Bottom-Up Post-Order Traversal)
        لاستخراج المباني الجاهزة فوراً للترقية (الأوراق Ready Leaves)، لدعم إشغال كلا الطابورين بالتوازي (R1).
        - تفحص المتطلبات المسبقة حتى أقصى عمق (8 مستويات).
        - تكتشف المباني المفقودة (Lv.0) كأولوية أولى للتشييد بمستوى البداية الفعلي.
        - تتجاوز المباني التي هي قيد الترقية حالياً لمنع التكرار وتفحص الفروع المستقلة الأخرى.
        - تفحص صمامات الأمان ضد الأنشطة الداخلية (أبحاث، تدريب، علاج، تصنيع).
        - تعيد قائمة الأوراق الجاهزة مرتبة بالأعمق أولاً وبشكل فريد (Unique BIDs).
        """
        ready_candidates: List[Dict[str, Any]] = []
        visited: Set[Tuple[str, int]] = set()

        def _traverse(bid: str, req_lv: int, depth: int):
            if depth > 8 or (bid, req_lv) in visited:
                return
            visited.add((bid, req_lv))

            bid_str = str(bid)
            blist = self._get_city_buildings()
            instances = [
                b.get("binfo", {}) for b in blist
                if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and str(b.get("binfo", {}).get("bid", "")) == bid_str
            ]

            # 1. مبنى مفقود تماماً في المدينة (Lv.0) -> ورقة ذات أولوية قصوى للتشييد بمستوى البداية الفعلي
            if not instances:
                ready_candidates.append({
                    "bid": bid_str,
                    "target_lv": BUILDING_START_LV.get(bid_str, 1),
                    "current_lv": 0,
                    "action": "construct",
                    "instance": {},
                    "depth": depth,
                })
                return

            curr_max_lv = max((int(b.get("lv", 0) or 0) for b in instances), default=0)
            if curr_max_lv >= req_lv:
                return  # المتطلب مستوفى بالفعل

            # 2. فحص هل المبنى قيد الترقية حالياً على أحد الطوابير
            is_upgrading = any(str(b.get("state", "0")) == "2" for b in instances) or any(
                str(q.get("bid")) == bid_str for q in self.active_queues.values()
            )
            if is_upgrading:
                # هذا الفرع يتقدم بنشاط بالفعل، لا يمكن ترقيته أكثر الآن ولكن نتابع فحص بقية الفروع
                return

            # 3. فحص انشغال المبنى بنشاط داخلي (أبحاث، تدريب، علاج، تصنيع) لمنع رفض السيرفر 1005
            is_busy, _ = self.is_building_busy_with_activity(bid_str)
            if is_busy:
                return

            # 4. فحص متطلبات المستوى التالي (curr_max_lv + 1)
            next_lv = curr_max_lv + 1
            cfg = get_building_level_config(bid_str, next_lv)
            pre_cond = cfg.get("preCond", {})
            if bid_str == "101" and not pre_cond:
                pre_cond = {"102": curr_max_lv}
                if next_lv >= 41:
                    pre_cond["301"] = curr_max_lv

            all_children_satisfied = True
            for p_bid, p_lv in pre_cond.items():
                p_bid_str = str(p_bid)
                if p_bid_str == "101":
                    c_lv = int(self._get_castle_level())
                    if c_lv < int(p_lv):
                        all_children_satisfied = False
                    continue

                p_instances = [
                    b.get("binfo", {}) for b in blist
                    if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and str(b.get("binfo", {}).get("bid", "")) == p_bid_str
                ]
                p_curr = max((int(b.get("lv", 0) or 0) for b in p_instances), default=0)
                if p_curr < int(p_lv):
                    all_children_satisfied = False
                    _traverse(p_bid_str, int(p_lv), depth + 1)

            # إذا كانت كافة متطلبات المستوى التالي مستوفاة، فهذا المبنى ورقة جاهزة للترقية
            if all_children_satisfied:
                best_instance = max(instances, key=lambda x: int(x.get("lv", 0) or 0))
                ready_candidates.append({
                    "bid": bid_str,
                    "target_lv": next_lv,
                    "current_lv": curr_max_lv,
                    "action": "upgrade",
                    "instance": best_instance,
                    "depth": depth,
                })

        _traverse(target_bid, target_blv, 0)

        # ترتيب المرشحين: الأعمق أولاً (الأوراق التحتية)، مع ضمان عدم تكرار نفس المبنى
        unique_candidates: List[Dict[str, Any]] = []
        seen_bids: Set[str] = set()
        for cand in sorted(ready_candidates, key=lambda x: x["depth"], reverse=True):
            if cand["bid"] not in seen_bids:
                seen_bids.add(cand["bid"])
                unique_candidates.append(cand)

        return unique_candidates

    def _get_kingdom_level(self) -> int:
        """جلب مستوى المملكة الحالي من الذاكرة الحية (0-Network)"""
        k_ctrl = self.get_ctrl("playerKingdomLevelCtrl")
        if isinstance(k_ctrl, dict):
            try:
                return int(k_ctrl.get("level", 0) or 0)
            except (ValueError, TypeError):
                return 0
        return 0

    @staticmethod
    def _get_required_kingdom_level(target_castle_lv: int) -> int:
        """الحد الأدنى لمستوى المملكة المطلوب لترقية القلعة (build101.lua)"""
        for min_clv, req_klv in CASTLE_KINGDOM_LV_REQ:
            if target_castle_lv >= min_clv:
                return req_klv
        return 0

    def _get_city_max_levels(self) -> Dict[str, int]:
        """خريطة أعلى مستوى قائم لكل مبنى في المدينة (0-Network)"""
        city_max: Dict[str, int] = {}
        for b in self._get_city_buildings():
            bi = b.get("binfo", {})
            if not isinstance(bi, dict):
                continue
            b_id = str(bi.get("bid", ""))
            lv = int(bi.get("lv", 0) or 0)
            if b_id and lv > city_max.get(b_id, 0):
                city_max[b_id] = lv
        return city_max

    def _are_preconds_met(
        self,
        bid: str,
        next_lv: int,
        castle_lv: int,
        city_max_levels: Optional[Dict[str, int]] = None,
    ) -> Tuple[bool, str]:
        """فحص متطلبات preCond الرسمية للمستوى التالي من buildings_prereqs.json (0-Network)"""
        cfg = get_building_level_config(str(bid), int(next_lv))
        pre_cond = cfg.get("preCond", {})
        if not pre_cond:
            return True, ""
        if city_max_levels is None:
            city_max_levels = self._get_city_max_levels()
        for p_bid, p_lv in pre_cond.items():
            p_bid_str = str(p_bid)
            req_p_lv = int(p_lv)
            curr_p_lv = castle_lv if p_bid_str == "101" else city_max_levels.get(p_bid_str, 0)
            if curr_p_lv < req_p_lv:
                p_name = BUILDING_INFO.get(p_bid_str, {}).get("name_ar", f"مبنى #{p_bid_str}")
                return False, f"يتطلب {p_name} Lv.{req_p_lv} (الحالي: Lv.{curr_p_lv})"
        return True, ""

    def is_castle_ready(self, target_clv: int) -> bool:
        """فحص هل القلعة جاهزة للترقية مباشرة (كافة متطلباتها مستوفاة وليست مشغولة)"""
        blist = self._get_city_buildings()
        castle_inst = next((b.get("binfo", {}) for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and str(b.get("binfo", {}).get("bid", "")) == "101"), {})
        if not castle_inst:
            return False
        curr_lv = int(castle_inst.get("lv", 0) or 0)
        if curr_lv >= target_clv:
            return False
        if str(castle_inst.get("state", "0")) == "2" or any(str(q.get("bid")) == "101" for q in self.active_queues.values()):
            return False

        # فحص شرط مستوى المملكة لترقية القلعة Lv.81-130 (0-Network)
        req_klv = self._get_required_kingdom_level(target_clv)
        if req_klv > 0:
            curr_klv = self._get_kingdom_level()
            if curr_klv > 0 and curr_klv < req_klv:
                return False

        # فحص المتطلبات المسبقة
        cfg = get_building_level_config("101", target_clv)
        pre_cond = cfg.get("preCond", {})
        if not pre_cond:
            pre_cond = {"102": curr_lv}
            if target_clv >= 41:
                pre_cond["301"] = curr_lv

        city_max = self._get_city_max_levels()
        for p_bid, p_lv in pre_cond.items():
            if city_max.get(str(p_bid), 0) < int(p_lv):
                return False

        # فحص أدوات وأوسمة الحرب في الحقيبة
        cost_tools = cfg.get("costTools", {})
        cost_wes = cfg.get("costWEs", {})
        bag = self.get_ctrl("backpackCtrl") or {}
        for iid_str, req_cnt in {**cost_wes, **cost_tools}.items():
            if int(req_cnt) > 0:
                item_val = bag.get(str(iid_str), 0)
                curr_cnt = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
                if curr_cnt < int(req_cnt):
                    return False

        return True

    async def execute_building_action(self, cand: Dict[str, Any]) -> Tuple[bool, str, Optional[str]]:
        """
        تنفيذ إجراء بناء أو ترقية لمبنى مرشح:
        - التحقق من شرط مستوى المملكة للقلعة قبل فتح الصناديق (0-Network).
        - التحقق من الموارد وتأمينها عبر BaseTask.ensure_resources مع فحص العجز بالذاكرة الحية (0-Network).
        - التحقق من الأدوات وأوسمة الحرب في الحقيبة (0-Network Pre-flight).
        - جمع المحصول إن كان مبنى موارد ولديه محصول متاح (curres > 0).
        - إرسال الأمر الشبكي الرسمي بـ mode: "0" (Zero-Gold Guarantee).
        - مزامنة الذاكرة الحية محلياً فور النجاح وإرجاع الطابور المخصص بدقة.
        """
        bid_str = str(cand["bid"])
        action = cand.get("action", "upgrade")
        target_lv = BUILDING_START_LV.get(bid_str, 1) if action == "construct" else int(cand["target_lv"])
        b_meta = BUILDING_INFO.get(bid_str, {"name": f"مبنى #{bid_str}"})
        b_name = b_meta["name"]

        # التحقق من توفر طابور بناء
        if len(self.active_queues) >= self.max_build_slots:
            return False, f"طوابير البناء مشغولة ({len(self.active_queues)}/{self.max_build_slots})", None

        # فحص شرط مستوى المملكة قبل فتح أي صناديق موارد (0-Network)
        if bid_str == "101" and action == "upgrade":
            req_klv = self._get_required_kingdom_level(target_lv)
            if req_klv > 0:
                curr_klv = self._get_kingdom_level()
                if curr_klv > 0 and curr_klv < req_klv:
                    reason = f"مستوى المملكة الحالي ({curr_klv}) أقل من المطلوب ({req_klv}) لترقية القلعة إلى Lv.{target_lv}"
                    self.log(f"⚠️ [Building] {reason}")
                    return False, reason, None

        cfg = get_building_level_config(bid_str, target_lv)
        cost_res = cfg.get("costRes", {})
        cost_tools = cfg.get("costTools", {})
        cost_wes = cfg.get("costWEs", {})
        cost_time = int(cfg.get("costTime", 3600) or 3600)

        # 1. فحص الأدوات وأوسمة الحرب في الحقيبة (0-Network Pre-flight)
        bag = self.get_ctrl("backpackCtrl") or {}
        missing_items = []
        for iid_str, req_cnt in {**cost_wes, **cost_tools}.items():
            if int(req_cnt) > 0:
                item_val = bag.get(str(iid_str), 0)
                curr_cnt = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
                if curr_cnt < int(req_cnt):
                    it_title = "وسام الحرب (301101)" if str(iid_str) == "301101" else f"أداة #{iid_str}"
                    missing_items.append(f"{it_title} ({curr_cnt}/{req_cnt})")

        if missing_items:
            reason = f"نقص أدوات/أوسمة لترقية {b_name}: {', '.join(missing_items)}"
            self.log(f"⚠️ [Building] {reason}")
            return False, reason, None

        # 2. تأمين الموارد المطلوبة عبر BaseTask.ensure_resources بعد فحص العجز الفعلي بالذاكرة الحية (0-Network)
        city = self._get_city_ctrl()
        reslist = city.get("reslist", {}) or city.get("resList", {}) if isinstance(city, dict) else {}
        missing_res = {
            r_id: int(float(amt) - float(reslist.get(str(r_id), 0) or 0))
            for r_id, amt in cost_res.items()
            if float(reslist.get(str(r_id), 0) or 0) < float(amt)
        }
        if missing_res:
            if bool(self.config.get("auto_open_chests", True)):
                res_result = await self.ensure_resources(missing_res, multiplier=1)
                if not res_result.get("success", False):
                    res_reason = f"نقص موارد لترقية {b_name} (الصناديق غير كافية)"
                    self.log(f"⚠️ [Building] {res_reason}")
                    return False, res_reason, None
            else:
                res_reason = f"نقص موارد لترقية {b_name} (فتح الصناديق معطل)"
                self.log(f"⚠️ [Building] {res_reason}")
                return False, res_reason, None

        # 3. تنفيذ التشييد لمبنى جديد
        if action == "construct":
            blist = self._get_city_buildings()
            used_indexes: Set[str] = {
                str(item.get("binfo", {}).get("index", ""))
                for item in blist
                if isinstance(item, dict) and isinstance(item.get("binfo"), dict) and item.get("binfo", {}).get("index")
            }
            open_areas = self._get_open_areas()
            target_index = get_can_build_index(bid_str, used_indexes, open_areas)

            if not target_index or target_index in used_indexes:
                return False, f"تعذر العثور على قطعة أرض شاغرة لتشييد {b_name}", None

            self.log(f"🏗️ [Building] إرسال أمر تشييد {b_name} في الموقع الشاغر [{target_index}]...")
            payload = {"bid": bid_str, "mode": "0", "index": str(target_index)}
            resp = await self.safe_query("1001", "2", payload, min_delay=0.5, max_delay=0.9)
            err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"

            if err == "0":
                msg = f"🎉 تم تشييد مبنى {b_name} بنجاح في الموقع [{target_index}]!"
                self.log(msg)
                self.upgraded_prereq_bids.add(bid_str)
                allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
                self.sync_in_memory_upgrade(allocated_qtype, bid_str, target_lv, str(target_index), cost_time, cost_res)
                return True, msg, allocated_qtype
            else:
                return False, f"فشل أمر تشييد {b_name} (خطأ: {err})", None

        # 4. تنفيذ الترقية لمبنى قائم
        instance = cand.get("instance", {})
        if not instance:
            blist = self._get_city_buildings()
            instances = [
                b.get("binfo", {}) for b in blist
                if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and str(b.get("binfo", {}).get("bid", "")) == bid_str
            ]
            if instances:
                instance = max(instances, key=lambda x: int(x.get("lv", 0) or 0))

        idx_to_up = str(instance.get("index", ""))
        if not idx_to_up:
            return False, f"تعذر تحديد موقع مبنى {b_name} في المدينة", None

        # جمع المحصول أولاً إن كان مبنى موارد ولديه محصول متاح (curres > 0)
        if b_meta.get("harvest", False) and float(instance.get("curres", 0) or 0) > 0:
            iid = int(instance.get("iid", 0) or 0)
            await self.harvest_building_resource(int(bid_str), iid)
            await asyncio.sleep(random.uniform(0.5, 0.9))

        self.log(f"🔨 [Building] إرسال أمر ترقية {b_name} إلى المستوى {target_lv} (موقع: {idx_to_up})...")
        payload = {"bid": bid_str, "mode": "0", "index": idx_to_up}
        resp = await self.safe_query("1001", "3", payload, min_delay=0.5, max_delay=0.9)
        err = str(resp.get("err", "-1")) if isinstance(resp, dict) else "-1"

        if err == "0":
            act_msg = f"🔨 بدء ترقية {b_name} إلى المستوى {target_lv} 🎉"
            self.log(act_msg)
            self.upgraded_prereq_bids.add(bid_str)
            allocated_qtype = "1200" if "1200" not in self.active_queues else "1201"
            self.sync_in_memory_upgrade(allocated_qtype, bid_str, target_lv, idx_to_up, cost_time, cost_res)
            return True, act_msg, allocated_qtype
        elif err in ("1001", "1008"):
            return False, f"طوابير البناء ممتلئة بالسيرفر لـ {b_name}", None
        elif err == "1005":
            return False, f"{b_name} مشغول بنشاط داخلي بالسيرفر (كود: 1005)", None
        else:
            return False, f"فشل أمر ترقية {b_name} (كود خطأ: {err})", None

    async def resolve_and_upgrade_chain(
        self,
        target_bid: str,
        target_blv: int,
        visited: Optional[Set[Tuple[str, int]]] = None,
        depth: int = 0
    ) -> Dict[str, Any]:
        """واجهة التوافق لشجرة المتطلبات المتداخلة (Wrapper over find_ready_prerequisites)"""
        candidates = self.find_ready_prerequisites(target_bid, target_blv)
        if not candidates:
            if str(target_bid) == "101" and self.is_castle_ready(target_blv):
                cand = {
                    "bid": "101",
                    "target_lv": target_blv,
                    "current_lv": self._get_castle_level(),
                    "action": "upgrade",
                    "instance": self.get_castle_instance(),
                    "depth": 0,
                }
                res = await self.execute_building_action(cand)
                ok, msg = res[0], res[1]
                return {"ready": ok, "actions": [msg] if msg else [], "reason": "" if ok else msg}
            return {"ready": False, "actions": [], "reason": "لا توجد متطلبات جاهزة حالياً"}

        cand = candidates[0]
        res = await self.execute_building_action(cand)
        ok, msg = res[0], res[1]
        return {"ready": ok, "actions": [msg] if msg else [], "reason": "" if ok else msg}

    async def upgrade_single_instance(self, binfo: Dict[str, Any], castle_lv: int) -> Tuple[bool, List[str], str]:
        """فحص وترقية مبنى داعم فردي (واجهة التوافق)"""
        bid_str = str(binfo.get("bid", ""))
        curr_lv = int(binfo.get("lv", 0) or 0)
        next_lv = curr_lv + 1
        b_meta = BUILDING_INFO.get(bid_str, {"name": f"مبنى #{bid_str}", "max_lv": 130})
        b_name = b_meta["name"]

        if next_lv > b_meta.get("max_lv", 130) or next_lv > castle_lv:
            return False, [], f"{b_name} بلغ الحد الأقصى للمستوى المسموح"

        pre_ok, pre_reason = self._are_preconds_met(bid_str, next_lv, castle_lv)
        if not pre_ok:
            return False, [], f"{b_name} غير مؤهل لـ Lv.{next_lv}: {pre_reason}"

        is_busy, busy_desc = self.is_building_busy_with_activity(bid_str)
        if is_busy:
            return False, [], f"{b_name} مشغول بـ {busy_desc}"

        cand = {
            "bid": bid_str,
            "target_lv": next_lv,
            "current_lv": curr_lv,
            "action": "upgrade",
            "instance": binfo,
        }
        res = await self.execute_building_action(cand)
        ok, msg = res[0], res[1]
        return ok, [msg] if ok else [], msg if not ok else ""

    # ── نظام تسريع طوابير البناء التجميعي (Batched Acceleration Engine - R2) ──

    async def accelerate_queue_to_completion(self, qtype: str) -> Tuple[bool, int, str]:
        """
        تسريع طابور محدد حتى الاكتمال 100% أو استنفاد أدوات التسريع المتاحة في الحقيبة (R2):
        1. التحقق من الطابور ووقت البقاء (> 60 ثانية).
        2. تجربة التسريع المجاني الفوري أولاً (mode: "0") بناءً على ثواني VIP الديناميكية (امتياز 7201).
        3. تجميع أدوات التسريع من الحقيبة بحلّال جشع (أدوات البناء 5011xx أولاً ثم العامة 5006xx).
        4. إغلاق الذيل (Tail Closure) بحبة دقيقة للبقية <= 60ث أو 5 دقائق للبقية <= 300ث.
        5. إرسال طلب واحد مجمّع (CMD 1003 / SubCMD 2 mode "2") لتقليص كافة الأدوات دفعة واحدة.
        6. تجربة التسريع المجاني لالتقاط الذيل المتبقي.
        7. إذا لم تكفِ الأدوات لإتمام 100%: استهلاك المتاح، وترك البناء يكتمل بالوقت المتبقي.
        """
        queues = await self.refresh_active_queues()
        q_info = queues.get(str(qtype))
        if not q_info:
            return False, 0, "الطابور فارغ بالفعل"

        bid = str(q_info.get("bid", ""))
        target_lv = int(q_info.get("lv", 0) or 0)
        q_index = str(q_info.get("index", "") or q_info.get("raw", {}).get("data", {}).get("index", "")) or None
        remain_sec = float(q_info.get("remain_time", 0) or 0)
        b_meta = BUILDING_INFO.get(bid, {})
        b_name = b_meta.get("name", f"مبنى #{bid}")

        if remain_sec <= 0:
            self.sync_in_memory_completed_queue(qtype, bid, target_lv, index=q_index)
            return True, 0, "مكتمل بالفعل"

        if remain_sec < 60:
            self.log(f"⏳ [Building] المتبقي لـ {b_name} هو {int(remain_sec)}ث (< دقيقة) — تخطي التسريع للاكتمال الطبيعي.")
            return False, 0, "الوقت المتبقي أقل من دقيقة"

        free_sec = self.calculate_free_speedup_seconds()

        # الخطوة 1: فحص التسريع المجاني الفوري (mode: "0")
        if remain_sec <= free_sec:
            self.log(f"⚡ [Building] المتبقي لـ {b_name} ({format_duration(remain_sec)}) يقع ضمن التسريع المجاني ({format_duration(free_sec)}) — تطبيق التسريع المجاني...")
            resp_free = await self.safe_query("1003", "2", {
                "qtype": str(qtype),
                "mode": "0",
                "items": [],
                "decreaseTime": "0",
            }, min_delay=0.5, max_delay=0.9)

            if resp_free and str(resp_free.get("err", "-1")) in ("0", "1010"):
                self.log(f"🎉 تم إنهاء ترقية {b_name} بالتسريع المجاني الفوري!")
                self.sync_in_memory_completed_queue(qtype, bid, target_lv, index=q_index)
                return True, int(remain_sec), "تم الإنهاء بالتسريع المجاني الفوري"

        # الخطوة 2: حلّال الحقيبة الجشع لتجميع الأدوات المطلوبة
        bag = self.get_ctrl("backpackCtrl") or {}
        items_to_use: List[Dict[str, int]] = []
        rem = remain_sec
        total_reduction = 0
        target_rem = float(free_sec)

        # استهلاك الأدوات الكبيرة والمتوسطة حتى الوصول لحد التسريع المجاني
        for item_id, item_sec, item_name in SPEEDUP_ITEMS:
            if rem <= target_rem:
                break
            s_id = str(item_id)
            item_val = bag.get(s_id, 0)
            avail_cnt = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
            if avail_cnt <= 0:
                continue

            needed_cnt = int((rem - target_rem) // item_sec)
            if needed_cnt <= 0:
                continue

            use_cnt = min(avail_cnt, needed_cnt)
            items_to_use.append({"id": int(item_id), "count": int(use_cnt)})
            reduction = use_cnt * item_sec
            rem -= reduction
            total_reduction += reduction

        # إغلاق الذيل (Tail Closure): تفضيل بطاقة دقيقة للبقية <= 60ث ثم 5 دقائق للبقية <= 300ث
        over_rem = rem - target_rem
        if 0 < over_rem <= 300:
            tail_candidates = (
                [(501106, 60), (500606, 60), (501101, 300), (500601, 300)]
                if over_rem <= 60
                else [(501101, 300), (500601, 300)]
            )
            for it_id, it_sec in tail_candidates:
                s_id = str(it_id)
                item_val = bag.get(s_id, 0)
                avail = int(item_val.get("count", 0)) if isinstance(item_val, dict) else int(item_val or 0)
                already_used = sum(it["count"] for it in items_to_use if it["id"] == it_id)
                if (avail - already_used) > 0:
                    found_existing = False
                    for it in items_to_use:
                        if it["id"] == it_id:
                            it["count"] += 1
                            found_existing = True
                            break
                    if not found_existing:
                        items_to_use.append({"id": it_id, "count": 1})
                    rem = max(0.0, rem - it_sec)
                    total_reduction += it_sec
                    break

        if not items_to_use:
            self.log(f"⚠️ [Building] لا تتوفر أدوات تسريع في الحقيبة لتقليص {b_name} (المتبقي: {format_duration(remain_sec)})")
            return False, 0, "لا تتوفر أدوات تسريع كافية"

        # الخطوة 3: إرسال الطلب المجمّع الرسمي دفعة واحدة (CMD 1003 / SubCMD 2 mode "2")
        self.log(f"⚡ [Building] إرسال دفعة تسريع مجمعة لـ {b_name} ({len(items_to_use)} أنواع أدوات، تقليص: {format_duration(total_reduction)})...")
        resp_tool = await self.safe_query("1003", "2", {
            "qtype": str(qtype),
            "mode": "2",
            "items": items_to_use,
            "decreaseTime": "0",
        }, min_delay=0.5, max_delay=0.9)

        err_code = str(resp_tool.get("err", "-1")) if isinstance(resp_tool, dict) else "-1"
        if err_code in ("0", "1010"):
            # خصم الأدوات من الذاكرة الحية محلياً
            self.sync_in_memory_consumed_items(items_to_use)

            # الخطوة 4: التقاط الذيل بالتسريع المجاني بعد التقليص إذا بلغ حد التسريع المجاني
            free_ok = False
            if rem <= free_sec and err_code != "1010":
                resp_f2 = await self.safe_query("1003", "2", {
                    "qtype": str(qtype),
                    "mode": "0",
                    "items": [],
                    "decreaseTime": "0",
                }, min_delay=0.5, max_delay=0.9)
                free_ok = resp_f2 and str(resp_f2.get("err", "-1")) in ("0", "1010")

            if err_code == "1010" or (rem <= free_sec and free_ok) or rem <= 0:
                self.log(f"🎉 تم إنهاء ترقية {b_name} بالكامل عبر التسريع المجمع والمجاني!")
                self.sync_in_memory_completed_queue(qtype, bid, target_lv, index=q_index)
                return True, total_reduction, "تم إنهاء الترقية بالتسريع بنجاح"
            else:
                # تقليص جزئي: استهلاك المتاح وترك البناء يكتمل بالوقت المتبقي
                self.log(f"⏳ [Building] استهلاك المتاح من أدوات التسريع لـ {b_name} (المتبقي الجديد: {format_duration(rem)}) والتوقف لعدم كفاية الرصيد.")
                if str(qtype) in self.active_queues:
                    self.active_queues[str(qtype)]["remain_time"] = rem
                return False, total_reduction, "استهلاك المتاح من أدوات التسريع والتوقف لعدم كفاية الرصيد"

        self.log(f"⚠️ [Building] رفض السيرفر طلب التسريع لـ {b_name} (كود خطأ: {err_code})")
        return False, 0, f"فشل أمر التسريع (كود: {err_code})"

    async def speedup_queue(self, qtype: str, allowed_bids: Optional[Set[str]] = None) -> int:
        """واجهة التوافق لتسريع طابور محدد"""
        queues = await self.refresh_active_queues()
        q_info = queues.get(str(qtype))
        if not q_info:
            return 0
        bid = str(q_info.get("bid", ""))
        if allowed_bids is not None and bid not in allowed_bids:
            return 0
        completed, reduced, _ = await self.accelerate_queue_to_completion(qtype)
        return reduced

    # ── مسار المباني الداعمة وحظر التسريع (Supportive Buildings - R3) ──

    def get_eligible_supportive_candidates(self) -> List[Dict[str, Any]]:
        """
        جلب قائمة المباني الداعمة المؤهلة للترقية (مرتبة بالأقل مستوى أولاً، ومستوفية preCond و unlockedBuild):
        - تستبعد النسخة قيد الترقية حالياً بناءً على رقم الخانة index للسماح بترقية نسخة ثانية على 1201.
        - تستبعد المباني المشغولة بأنشطة داخلية.
        - تشمل تشييد المباني المفقودة (Lv.0) المفتوحة فقط بمستوى القلعة بأولوية أولى.
        """
        selected_bids = set(self.get_selected_support_bids())
        blist = self._get_city_buildings()
        castle_lv = self._get_castle_level()
        city_max_levels = self._get_city_max_levels()
        city_bids = set(city_max_levels.keys())

        candidates: List[Dict[str, Any]] = []

        # 1. المباني المفقودة تماماً من المدينة (بشرط أن يكون مستوى القلعة فتحها رسمياً)
        for s_bid in selected_bids:
            if s_bid not in city_bids:
                unlock_clv = SUPPORT_BUILDING_UNLOCK_CASTLE_LV.get(s_bid, 1)
                if castle_lv < unlock_clv:
                    continue
                candidates.append({
                    "bid": s_bid,
                    "target_lv": BUILDING_START_LV.get(s_bid, 1),
                    "current_lv": 0,
                    "action": "construct",
                    "instance": {},
                })

        # 2. المباني القائمة ذات المستوى الأقل (مقارنة برقم الخانة index للسماح بترقية نسختين على 1200 و 1201)
        for item in blist:
            if not isinstance(item, dict):
                continue
            bi = item.get("binfo", {})
            if not isinstance(bi, dict):
                continue
            bid_k = str(bi.get("bid", ""))
            if bid_k in selected_bids:
                st = str(bi.get("state", "0"))
                lv = int(bi.get("lv", 0) or 0)
                next_lv = lv + 1
                idx_k = str(bi.get("index", ""))
                is_upgrading = (st == "2") or any(
                    str(q.get("bid")) == bid_k and (not q.get("index") or str(q.get("index")) == idx_k)
                    for q in self.active_queues.values()
                )
                if is_upgrading:
                    continue
                max_lv = BUILDING_INFO.get(bid_k, {}).get("max_lv", 130)
                if next_lv > max_lv or lv >= castle_lv:
                    continue
                pre_ok, _ = self._are_preconds_met(bid_k, next_lv, castle_lv, city_max_levels)
                if not pre_ok:
                    continue
                is_busy, _ = self.is_building_busy_with_activity(bid_k)
                if is_busy:
                    continue
                candidates.append({
                    "bid": bid_k,
                    "target_lv": next_lv,
                    "current_lv": lv,
                    "action": "upgrade",
                    "instance": bi,
                })

        candidates.sort(key=lambda x: (0 if x["action"] == "construct" else 1, x["current_lv"]))
        return candidates

    async def execute_support_upgrade(self, cand: Dict[str, Any]) -> Tuple[bool, str]:
        """
        تنفيذ ترقية مبنى داعم:
        قاعدة صارمة (R3): يُحظر تماماً تسريع المباني الداعمة في نفس دورة ترقيتها!
        """
        if cand["action"] == "construct":
            return await self.construct_missing_building(cand["bid"])
        else:
            best_instance = cand["instance"]
            ok, acts, reason = await self.upgrade_single_instance(best_instance, self._get_castle_level())
            msg = acts[0] if acts else reason
            return ok, msg

    def get_castle_prerequisite_bids(self, target_castle_lv: int) -> Set[str]:
        """استخراج جميع معرفات المباني التي تمثل متطلباً لترقية القلعة حتى المستوى المستهدف"""
        prereqs: Set[str] = {"101"}
        visited: Set[Tuple[str, int]] = set()

        def _collect(bid: str, lv: int, depth: int = 0):
            if depth > 8 or (bid, lv) in visited:
                return
            visited.add((bid, lv))
            prereqs.add(str(bid))
            cfg = get_building_level_config(str(bid), int(lv))
            pre = cfg.get("preCond", {})
            if str(bid) == "101" and not pre:
                pre = {"102": lv - 1}
                if lv >= 41:
                    pre["301"] = lv - 1
            for p_bid, p_lv in pre.items():
                _collect(str(p_bid), int(p_lv), depth + 1)

        _collect("101", target_castle_lv)
        return prereqs | getattr(self, "upgraded_prereq_bids", set())

    # ════════════════════════════════════════════════════════════════
    #  دورة التنفيذ الرئيسية (Main Run Loop)
    # ════════════════════════════════════════════════════════════════

    async def run(self) -> TaskResult:
        cfg = self.config
        do_castle = bool(cfg.get("upgrade_castle", cfg.get("castle", True)))
        do_buildings = bool(cfg.get("upgrade_support_buildings", cfg.get("buildings", True)))
        do_speedup = bool(cfg.get("speedup_castle", cfg.get("speedup", False)))
        check_only = bool(cfg.get("check_only", False))
        max_target_castle_lv = int(cfg.get("max_castle_level", 130) or 130)

        self.speedup_count = 0
        self.max_speedups_per_run = 5
        speedup_exhausted = False
        actions_taken: List[str] = []

        # ── 1. فحص الذاكرة الحية المسبق (0-Network Pre-flight) ──
        blist = self._get_city_buildings()
        if not blist:
            return TaskResult.fail("تعذر العثور على بيانات مباني المدينة في الذاكرة الحية!")

        castle_lv = self._get_castle_level()
        walls_item = next((b.get("binfo", {}) for b in blist if isinstance(b, dict) and isinstance(b.get("binfo"), dict) and str(b.get("binfo", {}).get("bid", "")) == "102"), {})
        walls_lv = int(walls_item.get("lv", 0) or 0)

        max_slots = self.calculate_max_build_slots()
        active_queues = await self.refresh_active_queues()
        active_count = len(active_queues)
        free_slots = max(0, max_slots - active_count)

        self.log(f"🏰 [Building] القلعة: Lv.{castle_lv} | 🧱 الأسوار: Lv.{walls_lv} | 📊 طوابير البناء: {active_count}/{max_slots} (متاح: {free_slots})")

        # ── 2. تسريع الدخول للدورة (Cycle Entry Acceleration - R2) ──
        # عند دخول البوت إلى المهمة والتسريع مفعل: تسريع أي بناء قيد التطوير حتى الإتمام
        if do_speedup and not check_only and active_queues:
            for qt in list(active_queues.keys()):
                if self.speedup_count >= self.max_speedups_per_run or speedup_exhausted:
                    break
                qi = active_queues.get(qt, {})
                q_rem = float(qi.get("remain_time", 0) or 0)
                if q_rem >= 60:
                    b_bid = str(qi.get("bid", ""))
                    b_meta = BUILDING_INFO.get(b_bid, {})
                    b_name = b_meta.get("name", f"طابور {qt}")
                    self.log(f"⚡ [Building] تسريع استباقي لـ {b_name} على طابور {qt} ({format_duration(q_rem)}) لتفريغ خانة البناء...")
                    completed, red, reason = await self.accelerate_queue_to_completion(qt)
                    if completed:
                        self.speedup_count += 1
                        actions_taken.append(f"⚡ تسريع استباقي: {b_name}")
                        # فاصل زمني بشري عشوائي بين تسريع طوابير الدخول المتعددة
                        await asyncio.sleep(random.uniform(0.5, 0.9))
                    else:
                        speedup_exhausted = True
                        break

            active_queues = await self.refresh_active_queues()
            active_count = len(active_queues)
            free_slots = max(0, max_slots - active_count)

        # ── 3. صمام الخروج بصفر طلبات شبكية (0-Network Exit Guard) ──
        # إذا كانت كافة الطوابير مشغولة ولا يمكن تسريعها، نتوقف فوراً
        if free_slots <= 0 and (not do_speedup or speedup_exhausted or self.speedup_count >= self.max_speedups_per_run):
            min_rem = min((float(qi.get("remain_time", 0) or 0) for qi in active_queues.values()), default=999999.0)
            summary_msg = f"طوابير البناء مشغولة بالكامل ({active_count}/{max_slots}) — المتبقي: {format_duration(min_rem)}"
            self.log(f"🛑 [Building] {summary_msg} (التوقف بصفر طلبات شبكية)")
            return TaskResult.ok(
                summary_msg,
                data={
                    "castle_level": castle_lv,
                    "walls_level": walls_lv,
                    "active_queues": active_count,
                    "free_slots": 0,
                    "actions": actions_taken,
                }
            )

        # ── 4. حلقة ترقية القلعة وشجرة المتطلبات المتداخلة (R1 & R2) ──
        if do_castle and castle_lv < max_target_castle_lv:
            castle_loop_passes = 0
            max_castle_passes = 10

            while castle_loop_passes < max_castle_passes and free_slots > 0:
                castle_loop_passes += 1
                curr_clv = self._get_castle_level()
                if curr_clv >= max_target_castle_lv:
                    break

                target_clv = min(curr_clv + 1, max_target_castle_lv)
                candidates = self.find_ready_prerequisites("101", target_clv)

                if not candidates:
                    # فحص هل القلعة نفسها جاهزة للترقية
                    if self.is_castle_ready(target_clv):
                        candidates = [{
                            "bid": "101",
                            "target_lv": target_clv,
                            "current_lv": curr_clv,
                            "action": "upgrade",
                            "instance": self.get_castle_instance(),
                            "depth": 0,
                        }]
                    else:
                        # شجرة المتطلبات مقفلة (بانتظار بناء حالي، أو مستوى مملكة، أو نقص موارد/أدوات)
                        break

                upgraded_in_pass = 0
                for cand in candidates:
                    if free_slots <= 0:
                        break

                    cand_bid = cand["bid"]
                    cand_name = BUILDING_INFO.get(cand_bid, {}).get("name", f"مبنى #{cand_bid}")

                    if check_only:
                        actions_taken.append(f"🔍 [فحص] جاهز للترقية: {cand_name} (مستوى {cand['current_lv']} ➔ {cand['target_lv']})")
                        free_slots -= 1
                        upgraded_in_pass += 1
                        continue

                    # تنفيذ الترقية
                    ok_up, up_msg, allocated_qtype = await self.execute_building_action(cand)
                    if ok_up:
                        actions_taken.append(up_msg)
                        upgraded_in_pass += 1
                        free_slots -= 1

                        # إذا كان التسريع مفعلاً ولم يستنفد: تسريع الطابور فوراً
                        if do_speedup and not speedup_exhausted and self.speedup_count < self.max_speedups_per_run:
                            # فاصل زمني بشري عشوائي بعد الترقية وقبل إطلاق أمر التسريع
                            await asyncio.sleep(random.uniform(0.5, 0.9))
                            completed, red, r_msg = await self.accelerate_queue_to_completion(allocated_qtype)
                            if completed:
                                self.speedup_count += 1
                                free_slots += 1  # تفرغ الطابور مجدداً لمواصلة المتطلب التالي!
                                actions_taken.append(f"⚡ تسريع: {cand_name}")
                            else:
                                speedup_exhausted = True
                        # فاصل زمني بشري عشوائي بين المرشحين المتتاليين في شجرة المتطلبات
                        await asyncio.sleep(random.uniform(0.5, 0.9))
                    else:
                        actions_taken.append(up_msg)

                if upgraded_in_pass == 0 or free_slots <= 0:
                    break

                await asyncio.sleep(random.uniform(0.5, 0.9))

        # ── 5. حلقة المباني الداعمة والمعسكرات (R3: Fallback & Supportive Buildings) ──
        active_queues = await self.refresh_active_queues()
        free_slots = max(0, max_slots - len(active_queues))

        if do_buildings and free_slots > 0 and not check_only:
            support_cands = self.get_eligible_supportive_candidates()
            for s_cand in support_cands:
                if free_slots <= 0:
                    break
                ok_s, s_msg = await self.execute_support_upgrade(s_cand)
                if ok_s:
                    actions_taken.append(s_msg)
                    free_slots -= 1
                    # قاعدة صارمة (R3): لا يتم تسريع المبنى الداعم في نفس الدورة!
                    # يُترك ليكتمل طبيعياً، ويسرّع في دورات لاحقة عبر تسريع الدخول إن كان مفعلاً.
                    # فاصل زمني بشري عشوائي بين ترقية المباني الداعمة المتعددة
                    await asyncio.sleep(random.uniform(0.5, 0.9))
                else:
                    s_bid = s_cand["bid"]
                    s_name = BUILDING_INFO.get(s_bid, {}).get("name", f"مبنى #{s_bid}")
                    self.log(f"⚠️ تجاوز المبنى الداعم {s_name} ({s_msg})")
                    if "طوابير" in s_msg:
                        self.max_build_slots = len(self.active_queues)
                        break

        # ── 6. إعداد النتيجة النهائية للتقرير ──
        active_queues = await self.refresh_active_queues()
        active_count = len(active_queues)
        free_slots = max(0, max_slots - active_count)
        castle_lv = self._get_castle_level()

        unique_actions = list(dict.fromkeys(actions_taken))
        if not unique_actions:
            if active_count >= max_slots:
                summary_msg = f"طوابير البناء مشغولة بالكامل ({active_count}/{max_slots})"
            else:
                summary_msg = "لا توجد ترقيات جديدة متاحة حالياً"
        else:
            positive_act = next((a for a in unique_actions if any(w in a for w in ["بدء ترقية", "تشييد", "تسريع", "تم إنهاء", "جاهز للترقية"])), None)
            primary_act = positive_act or unique_actions[0]
            if len(unique_actions) > 1:
                summary_msg = f"{primary_act} (+{len(unique_actions) - 1} إجراءات)"
            else:
                summary_msg = primary_act

        self.log(f"🏁 [Building] النتيجة: {summary_msg}")

        has_upgrade = any(
            any(w in act for w in ["بدء ترقية", "تشييد", "تسريع", "جاهز للترقية"])
            for act in unique_actions
        )
        is_blocked_by_res = not has_upgrade and any("نقص موارد" in act for act in unique_actions)
        is_blocked_by_items = not has_upgrade and any("نقص أدوات" in act or "وسام الحرب" in act for act in unique_actions)

        payload_data = {
            "castle_level": castle_lv,
            "walls_level": walls_lv,
            "active_queues": active_count,
            "free_slots": free_slots,
            "speedups_used": self.speedup_count,
            "actions": unique_actions,
        }

        if is_blocked_by_res or is_blocked_by_items:
            return TaskResult.fail(summary_msg)

        return TaskResult.ok(summary_msg, data=payload_data)