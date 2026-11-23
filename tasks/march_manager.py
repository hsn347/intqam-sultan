# -*- coding: utf-8 -*-
"""
python tasks/march_manager.py --email beetoo2@hotmail.com --formation 3


python tasks/march_manager.py --email beetoo1@hotmail.com --treasure-escort


python tasks/march_manager.py --email beetoo3@hotmail.com --relics-explore

python tasks/march_manager.py --email beetoo1@hotmail.com --search-resource wood --res-level 6



python tasks/march_manager.py --email beetoo3@hotmail.com --search-monster --monster-type nebula --monster-level 20



python tasks/gather_resources.py --email LUCIFER@g4.coom --mode daily_tasks --level 6




python tasks/escort_treasure.py --email beetoo3@hotmail.com




python tasks/explore_ruins.py --email beetoo2@hotmail.com --formation 1 --duration 1h

K:150,X:393,Y:425

python tasks/resource_help.py --email beetoo2@hotmail.com --x 393 --y 425 --resources food,wood,iron



python tasks/gather_speed_buff.py --email beetoo3@hotmail.com


"""
from __future__ import annotations

import argparse
import math
import asyncio
import json
import random
import logging
import os
import sys
import time
from typing import Any, Callable, Dict, Iterator, List, Optional, Set, Tuple, Type , Union

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from tasks.base_task import (
    BaseTask,
    ConnectionCircuitBreakerError,
    TaskResult,
)

log = logging.getLogger("march_manager")

# ═════════════════════════════════════════════════════════════════════════════
# الثوابت الرسمية (المستخرجة من ملفات كود اللعبة الأصلي)
# ═════════════════════════════════════════════════════════════════════════════

# ── إعدادات المدة الزمنية ──
DEFAULT_MAX_DURATION_MINUTES = 20
DEFAULT_MAX_DURATION_SECONDS = DEFAULT_MAX_DURATION_MINUTES * 60

# ── حالات طابور المسيرة النشط خارج القلعة ──
ACTIVE_MARCH_QUEUE_STATUSES: Tuple[int, ...] = (0, 1, 2, 3, 4, 7)

# ── حالات البطل الرسمية (src/app/constdef/heroDef.lua -> gHeroState) ──
HERO_STATE_NORMAL = 1      # داخل القلعة ومتاح للإرسال
HERO_STATE_DEAD = 2        # ميت (بانتظار الإحياء)
HERO_STATE_CAPTURED = 3    # مأسور في سجن قلعة أخرى
HERO_STATE_BATTLE = 4      # في مسيرة / معركة خارج القلعة
HERO_STATE_DEFEND = 5      # معيّن للدفاع داخل القلعة (قابل للإرسال وفق WorldDispatchArmyViewPanel.lua:1380)
HERO_STATE_ESCAPE = 6      # هارب / عائد من الأسر
HERO_STATE_GARRISON = 7    # حامية / تعزيز خارج القلعة

# الحالات التي تسمح اللعبة بإرسال البطل فيها (WorldDispatchArmyViewPanel.lua:1380 & heroCtrl.lua:828)
DISPATCHABLE_HERO_STATES: Tuple[int, ...] = (HERO_STATE_NORMAL, HERO_STATE_DEFEND)

# ── تصنيف الجنود وعناصر حصن الحرب (armyDef.lua & armyltCtrl.lua) ──
# حصن الحرب (BUILDID.FORTRESS = 120) يضم الفخاخ 801-825 (الخانة المئوية = 8) ويُستثنى دائماً
FORTRESS_TRAP_PREFIX = 8
SOLDIER_BRANCH_NAMES: Dict[int, str] = {
    4: "مشاة",
    5: "فرسان",
    6: "رماة",
    7: "عربات",
    9: "نخبة",
}
DISPATCHABLE_SOLDIER_RANGES: Tuple[Tuple[int, int], ...] = (
    (401, 414),  # مشاة (barrackID=118)
    (501, 514),  # فرسان (barrackID=116)
    (601, 614),  # رماة (barrackID=117)
    (701, 714),  # عربات (barrackID=119)
    (906, 910),  # جنود النخبة (barrackID=302)
)

# ── سعة نقل مساعدة الموارد (BUILDID.MARKET = 112 | build112.lua & alliance_science 33002) ──
BUILD_ID_MARKET = 112
ALLIANCE_SCI_TRADING_WEIGHT_ID = 33002
MARKET_CAPACITY_BY_LEVEL: Dict[int, int] = {
    1: 20000, 2: 40000, 3: 60000, 4: 80000, 5: 100000,
    6: 120000, 7: 140000, 8: 160000, 9: 180000, 10: 200000,
    11: 220000, 12: 240000, 13: 270000, 14: 290000, 15: 320000,
    16: 340000, 17: 370000, 18: 390000, 19: 420000, 20: 440000,
    21: 470000, 22: 490000, 23: 520000, 24: 540000, 25: 570000,
    26: 590000, 27: 620000, 28: 640000, 29: 670000, 30: 690000,
}
ALLIANCE_TRADING_WEIGHT_BY_LV: Dict[int, float] = {
    0: 0.0, 1: 0.01, 2: 0.02, 3: 0.03, 4: 0.04, 5: 0.05,
    6: 0.06, 7: 0.07, 8: 0.08, 9: 0.09, 10: 0.10,
}

# ── أنواع مسيرات حراسة الكنز الرسمية (src/app/constdef/mapDef.lua -> gMapMoveLineServerType) ──
MOVE_LINE_TYPE_ESCORT = 22         # إرسال الكنز تحت الحراسة (مسيرة حراسة الكنز الخاصة بك)
MOVE_LINE_TYPE_ESCORT_ASSIST = 23  # مساعدة حراسة الكنز لعضو التحالف

MOVE_LINE_TYPE_RELICS_EXPLORE = 5        # استكشاف الأطلال (نوع السيرفر)
MOVE_LINE_CLIENT_RELICS_EXPLORE = 4      # استكشاف الأطلال (نوع العميل)



MOVE_LINE_TYPE_KILL_NPC = 1              # الهجوم على الوحوش (نوع السيرفر)

# ── مهام النشاط اليومي الخاصة بالمسيرات (daily_reward_point_config.lua) ──
# الصيغة: مفتاح القاموس -> (task_type في eventInfo, الحد المطلوب limitTime, نوع المورد في الخريطة أو None للوحوش)
DAILY_MARCH_TASKS_SPEC: Dict[str, Tuple[int, int, Optional[int]]] = {
    "attack_monsters": (5, 5, None),  # أهجم على الوحوش
    "gather_food":     (1, 5, 2),     # جمع القمح
    "gather_wood":     (2, 5, 3),     # جمع الخشب
    "gather_iron":     (3, 5, 4),     # جمع الحديد
    "gather_silver":   (4, 5, 5),     # جمع الفضة
}

DAILY_GATHER_MIN_CASTLE_LEVEL: Dict[str, int] = {
    "gather_food": 1,
    "gather_wood": 1,
    "gather_iron": 10,
    "gather_silver": 15,
}

# ── إشارات التحكم الموحدة بين المهام الفرعية ومدير المسيرات (Manager Signal Contract) ──
MANAGER_SIGNAL_CONTINUE = "CONTINUE"
MANAGER_SIGNAL_WAIT_MONSTER = "WAIT_MONSTER_MARCH"
MANAGER_SIGNAL_ABORT_MARCHES_FULL = "ABORT_MARCHES_FULL"
MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE = "ABORT_SOLDIER_SHORTAGE"
MANAGER_SIGNAL_ABORT_TIME_EXPIRED = "ABORT_TIME_EXPIRED"
MANAGER_SIGNAL_ABORT_DISCONNECTED = "ABORT_DISCONNECTED"
DEFAULT_WAIT_INTERVAL_SEC = 120.0

# ── البحث عن الموارد وسعات البلاطات الرسمية (findMonsterCtrl.lua & resource.lua) ──
CMD_WORLD_SEARCH = "2083"
SUBCMD_SEARCH_RESOURCE = "2"
CMD_KINGDOM_MAP = "1006"
SUBCMD_MAP_OBJ_INFO = "15"

RESOURCE_SEARCH_ALIASES: Dict[str, Tuple[int, str]] = {
    "1": (1, "gold"),    "1001": (1, "gold"),    "gold": (1, "gold"),       "ذهب": (1, "gold"),
    "2": (2, "food"),    "1002": (2, "food"),    "food": (2, "food"),       "قمح": (2, "food"), "طعام": (2, "food"),
    "3": (3, "wood"),    "1003": (3, "wood"),    "wood": (3, "wood"),       "خشب": (3, "wood"),
    "4": (4, "iron"),    "1004": (4, "iron"),    "iron": (4, "iron"),       "حديد": (4, "iron"),
    "5": (5, "silver"),  "1005": (5, "silver"),  "silver": (5, "silver"),   "mithril": (5, "silver"), "فضة": (5, "silver"),
    "6": (6, "crystal"), "1006": (6, "crystal"), "crystal": (6, "crystal"), "كريستال": (6, "crystal"), "بلور": (6, "crystal"),
}

# السعة القصوى الرسمية لكل بلاطة مورد حسب (resType, level) من resource.lua (outputNum)
WORLD_RESOURCE_MAX_CAPACITY: Dict[int, Dict[int, int]] = {
    1: {1: 12, 2: 22, 3: 35, 4: 55, 5: 75, 6: 105, 7: 135, 8: 170, 9: 205, 10: 250},
    2: {1: 20000, 2: 38000, 3: 75000, 4: 130000, 5: 200000, 6: 300000, 7: 400000, 8: 530000, 9: 670000, 10: 830000},
    3: {1: 20000, 2: 38000, 3: 75000, 4: 130000, 5: 200000, 6: 300000, 7: 400000, 8: 530000, 9: 670000, 10: 830000},
    4: {1: 3300, 2: 6300, 3: 12500, 4: 21600, 5: 33300, 6: 50000, 7: 66600, 8: 88300, 9: 111600, 10: 138300},
    5: {1: 800, 2: 1550, 3: 3100, 4: 5400, 5: 8300, 6: 12500, 7: 16650, 8: 22050, 9: 27900, 10: 34550},
    6: {1: 200, 2: 390, 3: 780, 4: 1350, 5: 2080, 6: 3120, 7: 4160, 8: 5520, 9: 6970, 10: 8640},
}


# ── أوزان الموارد الرسمية للجمع (WorldDispatchArmyViewPanel.lua:1074-1081) ──
RESOURCE_UNIT_WEIGHT: Dict[str, int] = {
    "gold": 1000,
    "food": 1,
    "wood": 1,
    "iron": 6,
    "silver": 24,
    "crystal": 96,
}

# ── الحمولة الأساسية الرسمية لكل جندي (armyinfo.lua -> freeWeight) ──
ARMY_BASE_FREE_WEIGHT: Dict[int, int] = {
    # مشاة (401-414)
    401: 8, 402: 8, 403: 9, 404: 9, 405: 10, 406: 10, 407: 11, 408: 11,
    409: 12, 410: 12, 411: 13, 412: 15, 413: 17, 414: 17,
    # فرسان (501-514)
    501: 6, 502: 6, 503: 7, 504: 7, 505: 8, 506: 8, 507: 9, 508: 9,
    509: 10, 510: 10, 511: 12, 512: 14, 513: 16, 514: 16,
    # رماة (601-614)
    601: 8, 602: 8, 603: 8, 604: 8, 605: 10, 606: 10, 607: 10, 608: 11,
    609: 11, 610: 12, 611: 12, 612: 14, 613: 15, 614: 15,
    # عربات (701-714) — عربات النقل الزوجية/الخاصة أعلى حمولة في اللعبة
    701: 16, 702: 22, 703: 17, 704: 24, 705: 18, 706: 26, 707: 19, 708: 20,
    709: 28, 710: 21, 711: 32, 712: 22, 713: 24, 714: 24,
    # جنود النخبة (906-910)
    906: 15, 907: 15, 908: 15, 909: 15, 910: 15,
}

# ── أبطال مهارات الجمع والحمولة الرسميون (hero_skill_conf.lua) ──
# الصيغة: resource_key -> قائمة (hero_id, required_skill_type)
GATHER_HERO_SPECIALISTS: Dict[str, List[Tuple[int, int]]] = {
    "gold":    [(1712, 171202)],
    "food":    [(1709, 170902), (1717, 171703)],
    "wood":    [(1707, 170703), (1717, 171702)],
    "iron":    [(1717, 171704)],
    "silver":  [(1714, 171402)],
    "crystal": [(1724, 172404)],
}
LOAD_HERO_SPECIALISTS: List[Tuple[int, int]] = [(1706, 170603)]



# ── سرعة الجمع الأساسية الرسمية (وحدة / ساعة) من resource.lua -> outputSpeed ──
RESOURCE_BASE_GATHER_SPEED_PER_HOUR: Dict[str, float] = {
    "gold": 3.0,
    "food": 55200.0,
    "wood": 55200.0,
    "iron": 9200.0,
    "silver": 2300.0,
    "crystal": 46.0,
}
# معرفات تأثيرات سرعة الجمع في buffCtrl (buffDef.lua)
GATHER_SPEED_BUFF_BY_RES: Dict[str, int] = {
    "gold": 226,
    "food": 73,
    "wood": 74,
    "iron": 75,
    "silver": 76,
    "crystal": 480,
}


# القوة القتالية الرسمية للوحوش (fc) من config_server/npc.lua (العادية 1..40، السحابية 41..50)
NPC_COMBAT_FC_BY_LEVEL: Dict[int, int] = {
    1: 30, 2: 250, 3: 740, 4: 1694, 5: 2765,
    6: 4130, 7: 7285, 8: 10076, 9: 13354, 10: 23084,
    11: 28974, 12: 35641, 13: 54822, 14: 65422, 15: 77161,
    16: 114488, 17: 132416, 18: 151984, 19: 204318, 20: 231400,
    21: 260549, 22: 364382, 23: 406216, 24: 450909, 25: 498569,
    26: 625366, 27: 686595, 28: 751478, 29: 820064, 30: 1105534,
    31: 1406856, 32: 1559454, 33: 1763550, 34: 2018664, 35: 2040892,
    36: 2669595, 37: 3053265, 38: 3448095, 39: 3924165, 40: 4476450,
    # الوحوش السحابية (npcId 3041..3050)
    41: 4966650, 42: 5215050, 43: 5475600, 44: 5749650, 45: 6037200,
    46: 7044000, 47: 7396500, 48: 7767000, 49: 8155500, 50: 8563500,
}

# القوة القتالية الأساسية للجندي الواحد (armyinfo.lua -> power) حسب المستوى T1..T14
SOLDIER_POWER_BY_TIER: Dict[int, float] = {
    1: 1.0, 2: 1.4, 3: 1.9, 4: 2.5, 5: 3.2,
    6: 4.0, 7: 4.9, 8: 5.9, 9: 7.0, 10: 8.2,
    11: 10.5, 12: 12.0, 13: 13.5, 14: 15.0,
}

# قوة الوحدات الخاصة 8xx (801..805 / 811..815 / 821..825) من armyinfo.lua
SPECIAL_8XX_POWER_BY_SUB: Dict[int, float] = {
    1: 1.0, 2: 2.5, 3: 4.0, 4: 5.5, 5: 7.5,
}

DEFAULT_COMBAT_MIN_WIN_RATIO: float = 1.5





class MarchManagerTask(BaseTask):

    name: str = "march_manager"
    alias: str = "march_manager"

    # السجل المركزي للمهام الفرعية المسجلة للمدير
    _registered_subtasks: List[Type[BaseTask]] = []

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        if isinstance(log_func, dict) and config is None:
            config = log_func
            log_func = None
        super().__init__(conn, log_func, config)
        self.name = "march_manager"

    # ═════════════════════════════════════════════════════════════════════════
    # 1. الخصائص الأساسية والإعدادات (Properties & Config)
    # ═════════════════════════════════════════════════════════════════════════

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة وقاعدة البيانات."""
        return bool(self.config.get("enabled", False))

    @property
    def max_duration_minutes(self) -> int:
        """الحد الأقصى المسموح به لعمل المدير بالدقائق (افتراضياً 20 دقيقة)."""
        raw = self.config.get("max_duration_minutes", DEFAULT_MAX_DURATION_MINUTES)
        return max(1, self._safe_int(raw, DEFAULT_MAX_DURATION_MINUTES))

    @property
    def max_duration_seconds(self) -> float:
        """الحد الأقصى المسموح به لعمل المدير بالثواني."""
        return float(self.max_duration_minutes * 60.0)

    # ═════════════════════════════════════════════════════════════════════════
    # 2. إدارة وتسجيل المهام الفرعية (Sub-tasks Registry)
    # ═════════════════════════════════════════════════════════════════════════

    @classmethod
    def register_subtask(cls, subtask_cls: Type[BaseTask]) -> None:
        """تسجيل مهمة فرعية جديدة ليديرها مدير المسيرات."""
        if subtask_cls not in cls._registered_subtasks:
            cls._registered_subtasks.append(subtask_cls)

    @classmethod
    def unregister_subtask(cls, subtask_identifier: Any) -> None:
        """إلغاء تسجيل مهمة فرعية عبر صنفها أو اسمها."""
        cls._registered_subtasks = [
            t for t in cls._registered_subtasks
            if t != subtask_identifier and getattr(t, "name", "") != subtask_identifier
        ]

    @classmethod
    def get_registered_subtasks(cls) -> List[Type[BaseTask]]:
        """إرجاع نسخة من قائمة أصناف المهام الفرعية المسجلة حالياً."""
        return list(cls._registered_subtasks)

    @classmethod
    def clear_subtasks(cls) -> None:
        """تفريغ كافة المهام الفرعية المسجلة (لأغراض الاختبار والتصفير)."""
        cls._registered_subtasks.clear()

    # ═════════════════════════════════════════════════════════════════════════
    # 3. أدوات قراءة الذاكرة الحية المشتركة (Live Memory Helpers - 0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    def _get_live_snapshot(self) -> Dict[str, Any]:
        """قراءة لقطة متزامنة وآمنة للذاكرة الحية بدون أي طلب شبكي."""
        mem_engine = getattr(self.conn, "memory_engine", None)
        if mem_engine is not None and hasattr(mem_engine, "get_snapshot"):
            snap = mem_engine.get_snapshot()
            if isinstance(snap, dict):
                return snap
        return self.init_data if isinstance(self.init_data, dict) else {}

    def _iter_my_active_queues(self) -> Iterator[Tuple[Dict[str, Any], int]]:
        """تصفية وإرجاع طوابير المسيرات النشطة التابعة لهذه القلعة فقط من local_queues."""
        queues = self._read_live_local_queues(self.conn)
        my_uid = str(getattr(self, "uid", "") or "").strip()

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
            if status not in ACTIVE_MARCH_QUEUE_STATUSES:
                continue

            yield q, status

    # ═════════════════════════════════════════════════════════════════════════
    # 4. حالة الفيالق وطوابير المسيرات النشطة (March Slots & ETA - 0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    def get_active_marches_eta(self) -> Dict[str, Any]:
        """
        تحليل طوابير ومسيرات القلعة النشطة بالخارج من الذاكرة الحية (0-Network):
        - الثواني المتبقية لعودة كل فيلق نشط.
        - أقرب عودة (earliest_return_seconds) وأبعد عودة (latest_return_seconds).
        - إحداثيات الهدف ونوع المسيرة.
        """
        now_ts = time.time()
        active_list: List[Dict[str, Any]] = []
        earliest_return: Optional[float] = None
        latest_return: Optional[float] = None

        for q, status in self._iter_my_active_queues():
            finish_time = self._safe_float(
                q.get("finishTime") or q.get("endTime") or q.get("finish_time") or 0.0
            )
            if finish_time > 1e11:
                finish_time /= 1000.0

            remaining_sec = max(0.0, finish_time - now_ts) if finish_time > 0 else 0.0
            if finish_time > 0:
                if earliest_return is None or remaining_sec < earliest_return:
                    earliest_return = remaining_sec
                if latest_return is None or remaining_sec > latest_return:
                    latest_return = remaining_sec

            to_pos = q.get("to") if isinstance(q.get("to"), dict) else {}
            target_x = self._safe_int(to_pos.get("x") or q.get("target_x"), 0)
            target_y = self._safe_int(to_pos.get("y") or q.get("target_y"), 0)

            active_list.append({
                "qid": str(q.get("id") or q.get("queueId") or ""),
                "status": status,
                "type": self._safe_int(q.get("type"), 0),
                "target": {"x": target_x, "y": target_y},
                "finish_time": finish_time,
                "remaining_seconds": round(remaining_sec, 1),
            })

        return {
            "active_count": len(active_list),
            "earliest_return_seconds": round(earliest_return, 1) if earliest_return is not None else 0.0,
            "latest_return_seconds": round(latest_return, 1) if latest_return is not None else 0.0,
            "marches": active_list,
        }

    def get_march_status_summary(self) -> Dict[str, Any]:
        """ملخص شامل لحالة الفيالق المتاحة والنشطة وأزمنة العودة (0-Network)."""
        max_cap = self.get_max_marches_capacity()
        active_count = self.get_active_marches_count()
        avail_count = self.get_available_marches_count()
        eta_data = self.get_active_marches_eta()

        return {
            "max_capacity": max_cap,
            "active_marches": active_count,
            "available_slots": avail_count,
            "earliest_return_seconds": eta_data.get("earliest_return_seconds", 0.0),
            "latest_return_seconds": eta_data.get("latest_return_seconds", 0.0),
            "marches_detail": eta_data.get("marches", []),
        }

    def has_treasure_escort_march(self, include_assist: bool = False) -> bool:
        """
        التحقق من وجود مسيرة حراسة الكنز نشطة حالياً للقلعة من الذاكرة الحية فقط (0-Network)،
        مطابق لـ kingdomMapCtrl:hasEscortQueue() (kingdomMapCtrl.lua:1194 & mapDef.lua:343).

        Args:
            include_assist: إذا كانت True تشمل أيضاً مسيرة مساعدة حراسة كنز عضو التحالف (type=23).

        Returns:
            True إذا وُجدت مسيرة حراسة كنز نشطة، وإلا False.
        """
        target_server_types = (
            (MOVE_LINE_TYPE_ESCORT, MOVE_LINE_TYPE_ESCORT_ASSIST)
            if include_assist
            else (MOVE_LINE_TYPE_ESCORT,)
        )
        target_client_types = (11, 13) if include_assist else (11,)

        for q, _status in self._iter_my_active_queues():
            q_type = self._safe_int(q.get("type") or q.get("queueType"), 0)
            m_type = self._safe_int(q.get("moveLineType"), 0)
            if q_type in target_server_types or m_type in target_client_types:
                return True
        return False
    
    def has_relics_explore_march(self) -> bool:
        """
        التحقق من وجود مسيرة استكشاف أطلال نشطة حالياً للقلعة من الذاكرة الحية فقط (0-Network)،
        مطابق لـ kingdomMapCtrl.lua:1156 و mapDef.lua:326,384.
        """
        for q, _status in self._iter_my_active_queues():
            q_type = self._safe_int(q.get("type") or q.get("queueType"), 0)
            m_type = self._safe_int(q.get("moveLineType"), 0)
            if q_type == MOVE_LINE_TYPE_RELICS_EXPLORE or m_type == MOVE_LINE_CLIENT_RELICS_EXPLORE:
                return True
        return False

    def has_active_monster_march(self) -> bool:
        """التحقق من وجود فيلق واحد على الأقل يهاجم وحوشاً حالياً بالخارج (0-Network)."""
        for q, _st in self._iter_my_active_queues():
            q_type = self._safe_int(q.get("type") or q.get("queueType"), 0)
            m_type = self._safe_int(q.get("moveLineType"), 0)
            if q_type == MOVE_LINE_TYPE_KILL_NPC or m_type == MOVE_LINE_TYPE_KILL_NPC:
                return True
        return False

    def evaluate_march_block_signal(
        self,
        require_soldiers: bool = True,
        soldier_shortage: bool = False,
    ) -> Tuple[str, str]:
        """
        تقييم سبب تعذّر الإرسال وفق قاعدة المدير الحتمية (0-Network):
          - انقطاع الاتصال / جهاز آخر / حظر -> ABORT_DISCONNECTED
          - الفيالق ممتلئة (0 شاغرة):
              * يوجد فيلق وحوش بالخارج -> WAIT_MONSTER_MARCH
              * لا يوجد فيلق وحوش بالخارج -> ABORT_MARCHES_FULL
          - نقص جنود:
              * يوجد فيلق وحوش بالخارج -> WAIT_MONSTER_MARCH
              * يوجد فيلق+ غير وحوش بالخارج -> ABORT_SOLDIER_SHORTAGE
              * 0 فيالق بالخارج (القلعة فارغة أصلاً) -> CONTINUE (للسماح لمساعدة الموارد)
          - وإلا -> OK
        """
        if (
            not self.is_connected
            or getattr(self.conn, "is_other_device", False)
            or getattr(self.conn, "is_sealed", False)
        ):
            return MANAGER_SIGNAL_ABORT_DISCONNECTED, "انقطع الاتصال ببوابة اللعبة."

        avail_slots = self.get_available_marches_count()
        active_marches = self.get_active_marches_count()
        has_monster = self.has_active_monster_march()

        if avail_slots <= 0:
            if has_monster:
                return MANAGER_SIGNAL_WAIT_MONSTER, "الفيالق ممتلئة ويوجد فيلق وحوش نشط بالخارج."
            return MANAGER_SIGNAL_ABORT_MARCHES_FULL, "جميع الفيالق ممتلئة بالخارج ولا يوجد فيلق وحوش نشط."

        if require_soldiers and (soldier_shortage or not self.get_available_soldiers()):
            if has_monster:
                return MANAGER_SIGNAL_WAIT_MONSTER, "نقص جنود ويوجد فيلق وحوش نشط بالخارج."
            if active_marches >= 1:
                return MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE, "نقص جنود مع وجود فيالق غير وحوش بالخارج."
            return MANAGER_SIGNAL_CONTINUE, "لا يوجد جنود متاحون داخل القلعة (0 فيالق بالخارج)."

        return "OK", ""

    async def sleep_interruptible(self, seconds: float, deadline: Optional[float] = None) -> bool:
        """
        انتظار آمن مجزأ كل ثانية ينكسر فوراً عند انقطاع الاتصال أو انتهاء المهلة الكلية.
        يعيد True إذا اكتمل الانتظار والاتصال سليم والمهلة لم تنتهِ، وإلا False.
        """
        target_end = time.monotonic() + max(0.0, float(seconds))
        if deadline is not None:
            target_end = min(target_end, deadline)

        while True:
            if (
                not self.is_connected
                or getattr(self.conn, "is_other_device", False)
                or getattr(self.conn, "is_sealed", False)
            ):
                return False
            now = time.monotonic()
            if deadline is not None and now >= deadline:
                return False
            rem = target_end - now
            if rem <= 0.0:
                return True
            await asyncio.sleep(min(1.0, rem))

    def get_daily_march_tasks_status(self) -> Dict[str, Dict[str, Any]]:
        """
        فحص حالة وتوفر وإنجاز مهام النشاط اليومي الخمس (الوحوش، القمح، الخشب، الحديد، الفضة)
        من الذاكرة الحية فقط (0-Network) مطابق لـ everydayTaskCtrl:
          - available: False إذا لم تكن القلعة تملك متحكم النشاط اليومي أو المورد مقفل لمستوى القلعة
                       أو غير موجود ضمن قائمة مهام القلعة اليومية.
          - completed: True إذا كانت المهمة منجزة (progress >= 5)، وإلا False.
          - has_active_march: True إذا كانت هناك مسيرة نشطة حالياً لنفس المهمة.
        """
        snapshot = self._get_live_snapshot()
        et_ctrl = snapshot.get("everydayTaskCtrl")
        has_et_ctrl = isinstance(et_ctrl, dict) and bool(et_ctrl)
        event_info = et_ctrl.get("eventInfo") if isinstance(et_ctrl, dict) else None
        if not isinstance(event_info, dict):
            event_info = {}

        # إذا احتوى everydayTaskCtrl على قائمة مهام صريحة، نتحقق منها لمعرفة المهام المتوفرة لهذه القلعة
        explicit_task_types: Optional[Set[int]] = None
        if isinstance(et_ctrl, dict):
            for list_key in ("taskInfo", "tasks", "taskList"):
                raw_tasks = et_ctrl.get(list_key)
                if isinstance(raw_tasks, (list, dict)) and raw_tasks:
                    found_types: Set[int] = set()
                    iterable = raw_tasks.values() if isinstance(raw_tasks, dict) else raw_tasks
                    for item in iterable:
                        if isinstance(item, dict):
                            t_id = self._safe_int(
                                item.get("type") or item.get("taskType") or item.get("eventType"), 0
                            )
                            if t_id > 0:
                                found_types.add(t_id)
                    if found_types:
                        explicit_task_types = found_types
                        break

        castle_lv = self._safe_int(getattr(self, "castle_level", 1), 1)
        active_gather_res: Optional[Set[int]] = None
        has_monster_march: Optional[bool] = None

        result: Dict[str, Dict[str, Any]] = {}
        for task_key, (task_type, target_limit, res_sub_type) in DAILY_MARCH_TASKS_SPEC.items():
            req_lv = DAILY_GATHER_MIN_CASTLE_LEVEL.get(task_key, 1)
            available = has_et_ctrl and (castle_lv >= req_lv)
            if available and explicit_task_types is not None:
                available = task_type in explicit_task_types

            progress = self._safe_int(event_info.get(str(task_type), event_info.get(task_type, 0)), 0)
            completed = progress >= target_limit

            has_active_march = False
            if available and not completed:
                if res_sub_type is None:
                    if has_monster_march is None:
                        has_monster_march = self.has_active_monster_march()
                    has_active_march = has_monster_march
                else:
                    if active_gather_res is None:
                        active_gather_res = self.get_active_gather_resource_types(force_sync=False)
                    has_active_march = res_sub_type in active_gather_res

            result[task_key] = {
                "available": available,
                "completed": completed,
                "has_active_march": has_active_march,
                "progress": min(progress, target_limit),
                "target": target_limit,
            }

        return result

    def has_available_march(self, require_soldiers: bool = False) -> bool:
        """
        التحقق من وجود فيلق شاغر واحد على الأقل قابل للإرسال (0-Network).
        - require_soldiers=False: يتحقق فقط من وجود خانة فيلق شاغرة.
        - require_soldiers=True : يتحقق من وجود خانة فيلق شاغرة + وجود جنود متاحين في القلعة.
        """
        if self.get_available_marches_count() <= 0:
            return False
        if require_soldiers and not self.get_available_soldiers():
            return False
        return True
    
    # ═════════════════════════════════════════════════════════════════════════
    # 5. الأبطال المتاحون للإرسال (Available Heroes - 0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    def _extract_hero_ids_from_queue_entry(self, entry: Any) -> Set[int]:
        """استخراج معرفات الأبطال (الرئيسي + المساعد slaveHeroID) من حقل heroInfo داخل طابور مسيرة."""
        ids: Set[int] = set()
        if isinstance(entry, (int, str)):
            hid = self._safe_int(entry, 0)
            if hid > 0:
                ids.add(hid)
        elif isinstance(entry, dict):
            for field in ("heroID", "heroId", "id", "slaveHeroID", "slaveHeroId", "lieutenantHeroID"):
                val = entry.get(field)
                if val is not None:
                    hid = self._safe_int(val, 0)
                    if hid > 0:
                        ids.add(hid)
        elif isinstance(entry, list):
            for sub in entry:
                ids.update(self._extract_hero_ids_from_queue_entry(sub))
        return ids

    def get_busy_hero_ids_from_queues(self) -> Set[int]:
        """
        استخراج معرفات الأبطال المنطلقين حالياً في مسيرات نشطة من local_queues (0-Network)
        وفق kingdomQueueObjCell:getFromHero() (حقل q['from']['heroInfo']).
        """
        busy_ids: Set[int] = set()
        for q, _status in self._iter_my_active_queues():
            from_obj = q.get("from")
            if isinstance(from_obj, dict):
                for key in ("heroInfo", "heros", "heroes", "heroList"):
                    if from_obj.get(key):
                        busy_ids.update(self._extract_hero_ids_from_queue_entry(from_obj[key]))

            for key in ("heroInfo", "heros", "heroes", "heroList"):
                if q.get(key):
                    busy_ids.update(self._extract_hero_ids_from_queue_entry(q[key]))

        return busy_ids

    def get_available_heroes(self, exclude_defend: bool = False) -> List[Dict[str, Any]]:
        """
        جلب كافة الأبطال المتاحين للإرسال حالياً من الذاكرة الحية (0-Network)
        مطابق 100% لكود اللعبة الأصلي (heroCtrl.lua:828-847 & WorldDispatchArmyViewPanel.lua:1380):
          - المصدر: heroSysCtrl.heroList (محدّث لحظياً عبر NOTIFY_HERO_SYS / 406 في core/live_memory.py).
          - التوفر: الحالات NORMAL (1) أو DEFEND (5)، أو NORMAL فقط بدون defendList عند exclude_defend=True.
          - التقاطع: يستبعد تلقائياً أي بطل ظاهر في طوابير local_queues النشطة.
          - الترتيب: تنازلياً حسب الجودة ثم المستوى ثم الخبرة ثم تصاعدياً حسب heroID.
        """
        snapshot = self._get_live_snapshot()
        hero_sys = snapshot.get("heroSysCtrl")
        if not isinstance(hero_sys, dict):
            return []

        raw_hero_list = hero_sys.get("heroList")
        if not raw_hero_list:
            return []

        defend_ids: Set[int] = set()
        raw_defend = hero_sys.get("defendList")
        if isinstance(raw_defend, dict):
            for k, v in raw_defend.items():
                hid = self._safe_int(v.get("heroID") if isinstance(v, dict) else k, 0)
                if hid > 0:
                    defend_ids.add(hid)
        elif isinstance(raw_defend, list):
            for v in raw_defend:
                hid = self._safe_int(v.get("heroID") if isinstance(v, dict) else v, 0)
                if hid > 0:
                    defend_ids.add(hid)

        busy_in_queues = self.get_busy_hero_ids_from_queues()
        allowed_states = (HERO_STATE_NORMAL,) if exclude_defend else DISPATCHABLE_HERO_STATES
        hero_entries = (
            raw_hero_list.values()
            if isinstance(raw_hero_list, dict)
            else (raw_hero_list if isinstance(raw_hero_list, list) else [])
        )

        available: List[Dict[str, Any]] = []
        seen_ids: Set[int] = set()

        for h_info in hero_entries:
            if not isinstance(h_info, dict):
                continue

            hero_id = self._safe_int(h_info.get("heroID") or h_info.get("id"), 0)
            if hero_id <= 0 or hero_id in seen_ids:
                continue

            state = self._safe_int(h_info.get("state"), 0)
            if state not in allowed_states:
                continue

            is_defending = (state == HERO_STATE_DEFEND) or (hero_id in defend_ids)
            if exclude_defend and is_defending:
                continue

            if hero_id in busy_in_queues:
                continue

            seen_ids.add(hero_id)
            available.append({
                "hero_id": hero_id,
                "state": state,
                "level": self._safe_int(h_info.get("level"), 1),
                "quality": self._safe_int(h_info.get("quality"), 1),
                "level_exp": self._safe_int(h_info.get("level_exp"), 0),
                "is_awake": bool(h_info.get("isAwake", False)),
                "is_defending": is_defending,
                "raw": h_info,
            })

        available.sort(
            key=lambda h: (-h["quality"], -h["level"], -h["level_exp"], h["hero_id"])
        )
        return available

    def get_available_hero_ids(self, exclude_defend: bool = False) -> List[int]:
        """دالة مختصرة ترجع قائمة معرفات الأبطال المتاحين للإرسال فقط (مرتبة حسب منطق اللعبة)."""
        return [h["hero_id"] for h in self.get_available_heroes(exclude_defend=exclude_defend)]

    # ═════════════════════════════════════════════════════════════════════════
    # 6. الجنود المتاحون بدون عناصر حصن الحرب (Available Soldiers - 0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    @staticmethod
    def is_dispatchable_soldier_id(army_id: Any) -> bool:
        """
        مطابق لـ armyltCtrl.isArmyID(armyid) (armyltCtrl.lua:385):
        يقبل الجنود القابلين للإرسال فقط (401-414، 501-514، 601-614، 701-714، 906-910 ونسخ النجوم/الدرع)
        ويستثني عناصر حصن الحرب والفخاخ (BUILDID.FORTRESS = 120: النطاق 801-825).
        """
        try:
            aid = int(army_id)
        except (TypeError, ValueError):
            return False
        if aid <= 0 or (20_000_000 <= aid < 100_000_000):
            return False

        base_id = aid % 1000
        if (base_id // 100) == FORTRESS_TRAP_PREFIX:
            return False

        for lo, hi in DISPATCHABLE_SOLDIER_RANGES:
            if lo <= base_id <= hi:
                return True
        return False

    @staticmethod
    def _parse_soldier_meta(army_id: int) -> Tuple[int, int, float, bool]:
        """مطابق لـ serviceFunctions.getArmyLvNType و getArmyViewLev (serviceFunctions.lua:498-524)."""
        base_id = army_id % 1000
        branch_code = base_id // 100
        raw_lv = base_id % 100
        is_enhanced = (army_id // 100_000_000) > 0
        view_lv = float(raw_lv) + (0.5 if is_enhanced else 0.0)
        return base_id, branch_code, view_lv, is_enhanced

    def get_available_soldiers(self, min_level: int = 0) -> List[Dict[str, Any]]:
        """
        جلب كافة الجنود المتاحين حالياً داخل القلعة بدون عناصر حصن الحرب من الذاكرة الحية فقط (0-Network)،
        مطابق 100% لـ armyCtrl:getArmyList() و WorldDispatchArmyViewPanel:_initDispatchArmyListFromCtrl():
          - المصدر: armyCtrl.totalArmy (محدّث لحظياً عبر NOTIFY_ARMY / 15 في core/live_memory.py).
          - الاستثناء: يستثني تماماً فخاخ حصن الحرب (801-825) والجرحى والجنود المنطلقين بالخارج.
          - الترتيب: تنازلياً حسب المستوى (view_level) ثم تصاعدياً حسب base_id.
        """
        snapshot = self._get_live_snapshot()
        army_ctrl = snapshot.get("armyCtrl")
        if not isinstance(army_ctrl, dict):
            return []

        total_army = army_ctrl.get("totalArmy")
        if not isinstance(total_army, dict):
            return []

        soldiers: List[Dict[str, Any]] = []
        for raw_id, raw_count in total_army.items():
            if not self.is_dispatchable_soldier_id(raw_id):
                continue

            count = self._safe_int(raw_count, 0)
            if count <= 0:
                continue

            aid = int(raw_id)
            base_id, branch_code, view_lv, is_enhanced = self._parse_soldier_meta(aid)
            if min_level > 0 and view_lv < float(min_level):
                continue

            soldiers.append({
                "army_id": aid,
                "base_id": base_id,
                "count": count,
                "level": int(view_lv),
                "view_level": view_lv,
                "branch_code": branch_code,
                "branch_name": SOLDIER_BRANCH_NAMES.get(branch_code, "جندي"),
                "is_enhanced": is_enhanced,
            })

        soldiers.sort(key=lambda s: (-s["view_level"], s["base_id"], s["army_id"]))
        return soldiers

    def get_available_soldiers_map(self, min_level: int = 0) -> Dict[int, int]:
        """دالة مختصرة ترجع قاموس {army_id: count} للجنود المتاحين بالقلعة بدون عناصر حصن الحرب."""
        return {s["army_id"]: s["count"] for s in self.get_available_soldiers(min_level=min_level)}

    def get_resource_help_transport_capacity(self) -> int:
        """
        حساب سعة النقل القصوى لمساعدة الموارد من الذاكرة الحية فقط (0-Network)
        مطابق لـ buildLogic.getMarketWeight() (buildLogic.lua:2024-2038).
        يرجع رقماً صحيحاً فقط (int).
        """
        snapshot = self._get_live_snapshot()

        # 1. استخراج مستوى مبنى السوق (bid=112) من cityCtrl.blist
        city_ctrl = snapshot.get("cityCtrl")
        blist = city_ctrl.get("blist") if isinstance(city_ctrl, dict) else None
        market_lv = 0
        if isinstance(blist, list):
            for entry in blist:
                if not isinstance(entry, dict):
                    continue
                binfo = entry.get("binfo") if isinstance(entry.get("binfo"), dict) else entry
                if self._safe_int(binfo.get("bid"), 0) == BUILD_ID_MARKET:
                    market_lv = max(market_lv, self._safe_int(binfo.get("lv"), 0))

        base = MARKET_CAPACITY_BY_LEVEL.get(market_lv, 0)
        if base <= 0:
            return 0

        # 2. استخراج نسبة علم التحالف TRADING_WEIGHT (id=33002) إن وُجد تحالف
        alliance_add = 0.0
        alliance_ctrl = snapshot.get("allianceCtrl")
        if isinstance(alliance_ctrl, dict):
            sci_wrap = alliance_ctrl.get("sciencelist")
            scilist = sci_wrap.get("scilist") if isinstance(sci_wrap, dict) else None
            if isinstance(scilist, dict):
                for group_items in scilist.values():
                    items = group_items if isinstance(group_items, list) else (
                        list(group_items.values()) if isinstance(group_items, dict) else []
                    )
                    for sci in items:
                        if isinstance(sci, dict) and self._safe_int(sci.get("id"), 0) == ALLIANCE_SCI_TRADING_WEIGHT_ID:
                            sci_lv = self._safe_int(sci.get("lv"), 0)
                            alliance_add += ALLIANCE_TRADING_WEIGHT_BY_LV.get(sci_lv, 0.0)
                            break

        return base + math.floor(base * alliance_add)

    def get_saved_formation(self, formation_index: int = 1) -> Dict[str, Any]:
        """
        جلب التشكيلة المحددة والمحفوظة من قِبل اللاعب داخل اللعبة من الذاكرة الحية فقط (0-Network)،
        مطابق 100% لـ armyCtrl.lua (compileArmy / compileHero / compileArms / compileDivineBeast).

        Args:
            formation_index: رقم التشكيلة (الافتراضي 1).

        Returns:
            قاموس يحتوي على:
            formation_index, name, is_configured, soldiers ({army_id: count}),
            total_soldiers, hero_ids, lieutenant_map ({main_id: slave_id}),
            arms_ids, divine_beast_ids.
        """
        idx = max(1, self._safe_int(formation_index, 1))
        key = str(idx)
        snapshot = self._get_live_snapshot()
        army_ctrl = snapshot.get("armyCtrl")
        if not isinstance(army_ctrl, dict):
            return {
                "formation_index": idx,
                "name": f"التشكيلة {idx}",
                "is_configured": False,
                "soldiers": {},
                "total_soldiers": 0,
                "hero_ids": [],
                "lieutenant_map": {},
                "arms_ids": [],
                "divine_beast_ids": [],
            }

        compile_army = army_ctrl.get("compileArmy") if isinstance(army_ctrl.get("compileArmy"), dict) else {}
        compile_hero = army_ctrl.get("compileHero") if isinstance(army_ctrl.get("compileHero"), dict) else {}
        compile_arms = army_ctrl.get("compileArms") if isinstance(army_ctrl.get("compileArms"), dict) else {}
        compile_beast = army_ctrl.get("compileDivineBeast") if isinstance(army_ctrl.get("compileDivineBeast"), dict) else {}

        # اسم التشكيلة (armyCtrl:getArmyCompileName -> compileArmy["n" .. compiletype])
        raw_name = compile_army.get(f"n{key}")
        name = str(raw_name).strip() if raw_name else f"التشكيلة {idx}"

        # 1. الجنود المحفوظون في التشكيلة
        soldiers: Dict[int, int] = {}
        raw_soldiers = compile_army.get(key)
        if isinstance(raw_soldiers, dict):
            for raw_aid, raw_cnt in raw_soldiers.items():
                if not self.is_dispatchable_soldier_id(raw_aid):
                    continue
                cnt = self._safe_int(raw_cnt, 0)
                if cnt > 0:
                    soldiers[int(raw_aid)] = cnt

        # 2. الأبطال والأبطال المساعدون (heroCtrl:getHeroAndLieutenant)
        hero_ids: List[int] = []
        lieutenant_map: Dict[int, int] = {}
        raw_heroes = compile_hero.get(key)
        hero_items = raw_heroes if isinstance(raw_heroes, list) else (
            list(raw_heroes.values()) if isinstance(raw_heroes, dict) else []
        )
        for item in hero_items:
            if isinstance(item, dict):
                hid = self._safe_int(item.get("heroID") or item.get("heroId") or item.get("id"), 0)
                if hid > 0 and hid not in hero_ids:
                    hero_ids.append(hid)
                slave_id = self._safe_int(item.get("slaveHeroID") or item.get("slaveHeroId"), 0)
                if hid > 0 and slave_id > 0:
                    lieutenant_map[hid] = slave_id
            else:
                hid = self._safe_int(item, 0)
                if hid > 0 and hid not in hero_ids:
                    hero_ids.append(hid)

        # 3. الأسلحة الإلهية والوحوش الإلهية
        def _parse_id_list(raw_val: Any) -> List[int]:
            out: List[int] = []
            seq = raw_val if isinstance(raw_val, list) else (
                list(raw_val.values()) if isinstance(raw_val, dict) else []
            )
            for v in seq:
                vid = self._safe_int(v.get("id") if isinstance(v, dict) else v, 0)
                if vid > 0 and vid not in out:
                    out.append(vid)
            return out

        arms_ids = _parse_id_list(compile_arms.get(key))
        divine_beast_ids = _parse_id_list(compile_beast.get(key))

        total_soldiers = sum(soldiers.values())
        if total_soldiers <= 1:
            return {
                "formation_index": idx,
                "name": name,
                "is_configured": False,
                "soldiers": {},
                "total_soldiers": 0,
                "hero_ids": [],
                "lieutenant_map": {},
                "arms_ids": [],
                "divine_beast_ids": [],
            }

        return {
            "formation_index": idx,
            "name": name,
            "is_configured": True,
            "soldiers": soldiers,
            "total_soldiers": total_soldiers,
            "hero_ids": hero_ids,
            "lieutenant_map": lieutenant_map,
            "arms_ids": arms_ids,
            "divine_beast_ids": divine_beast_ids,
        }

    def _get_castle_coords_and_kingdom(self) -> Tuple[int, int, int]:
        """استخراج إحداثيات القلعة الحالية (مطابق لـ cityCtrl:getCurCityPos) ورقم المملكة من BaseTask.kingdom_id."""
        cx, cy = 0, 0

        # 1. المصدر الرسمي الأول: cityCtrl.cinfo.pos (الإحداثيات الحالية الفعلية للقلعة على الخريطة)
        city_ctrl = self.get_ctrl("cityCtrl")
        if isinstance(city_ctrl, dict):
            cinfo = city_ctrl.get("cinfo")
            if isinstance(cinfo, dict):
                pos = cinfo.get("pos")
                if isinstance(pos, dict):
                    cx = self._safe_int(pos.get("x"), 0)
                    cy = self._safe_int(pos.get("y"), 0)

        # 2. احتياطي فقط في حال عدم توفر cityCtrl.cinfo.pos
        if cx <= 0 and cy <= 0:
            lord_ctrl = self.get_ctrl("lordInfoCtrl")
            base = lord_ctrl.get("base", {}) if isinstance(lord_ctrl, dict) else {}
            source_pos = base.get("sourcePos", {}) if isinstance(base.get("sourcePos"), dict) else {}
            cx = self._safe_int(source_pos.get("x", base.get("x", 0)), 0)
            cy = self._safe_int(source_pos.get("y", base.get("y", 0)), 0)

        # استدعاء رقم المملكة من الخاصية الرسمية الموروثة من base_task.py
        kid = self.kingdom_id
        return cx, cy, kid

    def _is_coord_targeted_by_any_march(self, tx: int, ty: int) -> bool:
        """التحقق من وجود أي مسيرة نشطة (لقلعتنا أو لغيرنا) متجهة إلى (tx, ty) من الذاكرة الحية."""
        all_queues: List[Any] = list(self._read_live_local_queues(self.conn) or [])
        if hasattr(self, "_read_live_other_queues"):
            all_queues.extend(self._read_live_other_queues(self.conn) or [])

        for q in all_queues:
            if not isinstance(q, dict):
                continue
            st = self._safe_int(q.get("status"), -1)
            if st not in ACTIVE_MARCH_QUEUE_STATUSES:
                continue
            to_pos = q.get("to") if isinstance(q.get("to"), dict) else {}
            qx = self._safe_int(to_pos.get("x") or q.get("target_x"), -1)
            qy = self._safe_int(to_pos.get("y") or q.get("target_y"), -1)
            if qx == tx and qy == ty:
                return True
        return False

    async def search_best_resource(
        self,
        resource_type: Union[str, int],
        level: int,
        max_distance: float = 120.0,
        min_level: int = 2,
        max_attempts_per_level: int = 3,
        min_remaining_ratio: float = 0.50,
        retry_delay_range: Tuple[float, float] = (1.8, 3.8),
        reserve_found: bool = True,
    ) -> Dict[str, Any]:
        """
        البحث الرسمي عن أفضل مورد متاح على الخريطة عبر CMD 2083/2 + فحص CMD 1006/15:
        - يبحث عن مورد واحد في كل طلب رسمي (research=True لأول محاولة في كل مستوى، ثم False).
        - يتحقق من المسافة (<= max_distance) مقارنة بموقع القلعة الفعلي (cityCtrl.cinfo.pos).
        - يبني معرف الكائن الرسمي "{x+1}-{y+1}-5-{resType}-{resObjId}" لفحص البلاطة عبر 1006/15.
        - يتحقق أن المورد غير مشغول بأي أمير، وأن موارده المتبقية >= 50% من سعته الرسمية.
        - إذا كان مشغولاً أو أقل من 50%، يُضاف للاستبعاد ويعاد البحث بنفس المستوى حتى 3 محاولات بحد أقصى.
        - عند عدم العثور ينزل مستوى واحداً تلقائياً حتى المستوى 2، مع زمن انتظار بشري عشوائي بين المحاولات الفاشلة.
        """
        # خريطة أنواع الموارد الرسمية (worldMapMonsterSearch.lua: 1=gold, 2=food, 3=wood, 4=iron, 5=silver, 6=crystal)
        res_aliases: Dict[str, Tuple[int, str]] = {
            "1": (1, "gold"), "gold": (1, "gold"), "ذهب": (1, "gold"), "1001": (1, "gold"),
            "2": (2, "food"), "food": (2, "food"), "wheat": (2, "food"), "قمح": (2, "food"), "طعام": (2, "food"), "1002": (2, "food"),
            "3": (3, "wood"), "wood": (3, "wood"), "خشب": (3, "wood"), "1003": (3, "wood"),
            "4": (4, "iron"), "iron": (4, "iron"), "حديد": (4, "iron"), "1004": (4, "iron"),
            "5": (5, "silver"), "silver": (5, "silver"), "mithril": (5, "silver"), "فضة": (5, "silver"), "1005": (5, "silver"),
            "6": (6, "crystal"), "crystal": (6, "crystal"), "بلور": (6, "crystal"), "كريستال": (6, "crystal"), "1006": (6, "crystal"),
        }

        # الجدول الرسمي من resource.lua: (معرف الكائن objId, السعة القصوى outputNum)
        res_table: Dict[int, Dict[int, Tuple[int, int]]] = {
            1: {1: (3201, 12), 2: (3202, 22), 3: (3203, 35), 4: (3204, 55), 5: (3205, 75), 6: (3206, 105), 7: (3207, 135), 8: (3208, 170), 9: (3209, 205), 10: (3210, 250)},
            2: {1: (3301, 20000), 2: (3302, 38000), 3: (3303, 75000), 4: (3304, 130000), 5: (3305, 200000), 6: (3306, 300000), 7: (3307, 400000), 8: (3308, 530000), 9: (3309, 670000), 10: (3310, 830000)},
            3: {1: (3401, 20000), 2: (3402, 38000), 3: (3403, 75000), 4: (3404, 130000), 5: (3405, 200000), 6: (3406, 300000), 7: (3407, 400000), 8: (3408, 530000), 9: (3409, 670000), 10: (3410, 830000)},
            4: {1: (3501, 3300), 2: (3502, 6300), 3: (3503, 12500), 4: (3504, 21600), 5: (3505, 33300), 6: (3506, 50000), 7: (3507, 66600), 8: (3508, 88300), 9: (3509, 111600), 10: (3510, 138300)},
            5: {1: (3601, 800), 2: (3602, 1550), 3: (3603, 3100), 4: (3604, 5400), 5: (3605, 8300), 6: (3606, 12500), 7: (3607, 16650), 8: (3608, 22050), 9: (3609, 27900), 10: (3610, 34550)},
            6: {1: (1301, 200), 2: (1302, 390), 3: (1303, 780), 4: (1304, 1350), 5: (1305, 2080), 6: (1306, 3120), 7: (1307, 4160), 8: (1308, 5520), 9: (1309, 6970), 10: (1310, 8640)},
        }

        raw_key = str(resource_type).strip().lower()
        if raw_key not in res_aliases:
            return {
                "success": False,
                "code": "INVALID_RESOURCE_TYPE",
                "message": f"نوع المورد غير معروف: {resource_type}",
                "target": None,
                "resource": None,
                "attempts_used": 0,
            }

        res_code, res_key = res_aliases[raw_key]
        start_level = max(1, min(10, self._safe_int(level, 6)))
        min_lv = max(1, min(start_level, self._safe_int(min_level, 2)))
        max_dist = max(1.0, float(max_distance))
        max_tries = max(1, self._safe_int(max_attempts_per_level, 3))
        delay_lo, delay_hi = retry_delay_range

        async def _human_sleep() -> None:
            if delay_hi > 0:
                await asyncio.sleep(random.uniform(max(0.2, delay_lo), max(delay_lo, delay_hi)))

        cx, cy, kid = self._get_castle_coords_and_kingdom()
        self.log(f"📍 [بحث الموارد] موقع القلعة الفعلي: ({cx}, {cy}) | المملكة: {kid}")

        if cx <= 0 and cy <= 0:
            return {
                "success": False,
                "code": "CASTLE_COORDS_MISSING",
                "message": "تعذر قراءة إحداثيات القلعة من الذاكرة الحية (cityCtrl.cinfo.pos).",
                "target": None,
                "resource": None,
                "attempts_used": 0,
            }

        # جلب خريطة الاستبعاد المعزولة لهذا النوع فقط ومفلترة بالمسافة
        exclude_map = await self.get_exclude_map(
            kingdom_id=kid,
            x=cx,
            y=cy,
            max_distance=max_dist,
            target_type=res_key,
        )

        seen_coords: Set[Tuple[int, int]] = set()
        total_attempts = 0

        for lv in range(start_level, min_lv - 1, -1):
            res_obj_id, max_cap = res_table.get(res_code, {}).get(lv, (0, 0))

            for attempt in range(1, max_tries + 1):
                total_attempts += 1
                is_new_search = (attempt == 1)

                payload = {
                    "restype": res_code,
                    "level": lv,
                    "posx": cx,
                    "posy": cy,
                    "research": is_new_search,
                }

                resp = await self.safe_query("2083", "2", payload, min_delay=0.3, max_delay=0.7)
                if not isinstance(resp, dict) or not self._is_resp_ok(resp):
                    await _human_sleep()
                    break

                # استخراج الإحداثيات من رد 2083/2 (المسار الرسمي في findMonsterCtrl:searchResourcesRsp هو result)
                inner: Dict[str, Any] = {}
                for key in ("result", "rspdata", "data", "retData"):
                    val = resp.get(key)
                    if isinstance(val, dict) and any(k in val for k in ("x", "y", "posX", "posY", "pos")):
                        inner = val
                        break
                if not inner:
                    inner = resp

                pos_obj = inner.get("pos") if isinstance(inner.get("pos"), dict) else {}
                tx = self._safe_int(inner.get("x", inner.get("posX", pos_obj.get("x", 0))), 0)
                ty = self._safe_int(inner.get("y", inner.get("posY", pos_obj.get("y", 0))), 0)

                if tx <= 0 and ty <= 0:
                    self.log(f"⚠️ [بحث الموارد] لم تُعثر إحداثيات في رد 2083/2 (مستوى {lv}): {resp}")
                    await _human_sleep()
                    break

                dist = math.hypot(tx - cx, ty - cy)
                if dist > max_dist:
                    self.log(
                        f"⏭️ [بحث الموارد] مستوى {lv}: أقرب مورد ({tx}, {ty}) يبعد {dist:.1f} > {max_dist:g}، الانتقال للمستوى التالي."
                    )
                    await _human_sleep()
                    break

                target_id = f"{res_key}_{tx}_{ty}"
                alt_tid = f"{tx}_{ty}"

                if (tx, ty) in seen_coords or target_id in exclude_map or alt_tid in exclude_map:
                    self.log(f"⏭️ [بحث الموارد] تخطي المورد ({tx}, {ty}) مستوى {lv} لأنه مستبعد/مكرر (محاولة {attempt}/{max_tries}).")
                    await _human_sleep()
                    continue

                seen_coords.add((tx, ty))

                # بناء معرف الكائن الرسمي لـ 1006/15: "{x+1}-{y+1}-5-{resType}-{resObjId}" (mapObjUtil.lua:1155)
                instance_id = f"{tx + 1}-{ty + 1}-5-{res_code}-{res_obj_id}"
                info_payload: Dict[str, Any] = {
                    "x": tx,
                    "y": ty,
                    "id": instance_id,
                    "kingdomId": kid,
                }
                info_resp = await self.safe_query("1006", "15", info_payload, min_delay=0.3, max_delay=0.7)

                occupied = False
                remaining: Optional[int] = None

                if isinstance(info_resp, dict) and self._is_resp_ok(info_resp):
                    ret_data: Dict[str, Any] = {}
                    for k in ("retData", "result", "rspdata", "data"):
                        v = info_resp.get(k)
                        if isinstance(v, dict):
                            ret_data = v
                            break
                    if not ret_data:
                        ret_data = info_resp

                    res_block = ret_data.get("resource") if isinstance(ret_data.get("resource"), dict) else {}

                    # التحقق من وجود أمير يجمع في المورد أو يشغله (في ret_data أو داخل resource)
                    owner_uid = str(
                        res_block.get("playerID")
                        or res_block.get("uid")
                        or res_block.get("ownerId")
                        or res_block.get("occupyUid")
                        or ret_data.get("playerID")
                        or ret_data.get("uid")
                        or ret_data.get("ownerId")
                        or ret_data.get("occupyUid")
                        or ""
                    ).strip()
                    if (owner_uid and owner_uid != "0") or bool(res_block.get("playerInfo")) or bool(res_block.get("queueId")):
                        occupied = True

                    # التحقق من الكمية المتبقية في المورد (المسار الرسمي: retData.resource.currentSourceNum)
                    for src_dict in (res_block, ret_data):
                        for num_key in ("currentSourceNum", "resNum", "leftNum", "curNum", "sourceNum", "num"):
                            if num_key in src_dict and src_dict[num_key] is not None:
                                val = self._safe_int(src_dict[num_key], -1)
                                if val >= 0:
                                    remaining = val
                                    break
                        if remaining is not None:
                            break

                if occupied:
                    self.log(f"🚫 [بحث الموارد] المورد ({tx}, {ty}) مستوى {lv} مشغول بأمير آخر — استبعاده وإعادة البحث.")
                    await self.confirm_target(target_id, kingdom_id=kid, target_type=res_key)
                    exclude_map[target_id] = True
                    await _human_sleep()
                    continue

                ratio = 1.0
                if remaining is not None and max_cap > 0:
                    ratio = remaining / float(max_cap)
                    if ratio < min_remaining_ratio:
                        self.log(
                            f"📉 [بحث الموارد] المورد ({tx}, {ty}) مستوى {lv} يحتوي {remaining:,}/{max_cap:,} "
                            f"({ratio * 100:.1f}% < {min_remaining_ratio * 100:.0f}%) — استبعاده وإعادة البحث."
                        )
                        await self.confirm_target(target_id, kingdom_id=kid, target_type=res_key)
                        exclude_map[target_id] = True
                        await _human_sleep()
                        continue

                # حجز المورد مؤقتاً في الذاكرة لمنع تصادم القلاع الشقيقة
                if reserve_found:
                    reserved = await self.reserve_target(target_id, kingdom_id=kid, target_type=res_key)
                    if not reserved:
                        self.log(f"🔒 [بحث الموارد] المورد ({tx}, {ty}) تم حجزه للتو من قلعة شقيقة — إعادة البحث.")
                        exclude_map[target_id] = True
                        await _human_sleep()
                        continue

                rem_str = f"{remaining:,}/{max_cap:,} ({ratio * 100:.1f}%)" if remaining is not None else "غير محدد"
                self.log(
                    f"✅ [بحث الموارد] تم اختيار {res_key} مستوى {lv} في ({tx}, {ty}) | "
                    f"المسافة: {dist:.1f} | المتبقي: {rem_str}"
                )
                target_info = {
                    "resource_type": res_key,
                    "resource_key": res_key,
                    "resource_code": res_code,
                    "level": lv,
                    "x": tx,
                    "y": ty,
                    "target_id": target_id,
                    "instance_id": instance_id,
                    "obj_id": res_obj_id,
                    "distance": round(dist, 2),
                    "remaining": remaining,
                    "max_capacity": max_cap,
                    "fill_ratio": round(ratio, 4),
                    "remaining_ratio": round(ratio, 4),
                    "remaining_pct": round(ratio * 100, 1),
                    "remaining_percent": round(ratio * 100, 1),
                    "verified": remaining is not None,
                    "occupied": False,
                    "kingdom_id": kid,
                    "castle_pos": {"x": cx, "y": cy},
                }
                return {
                    "success": True,
                    "code": "OK",
                    "message": f"تم العثور على مورد {res_key} مستوى {lv} في ({tx}, {ty}) على مسافة {dist:.1f}.",
                    "target": target_info,
                    "resource": target_info,
                    "attempts_used": total_attempts,
                }

        return {
            "success": False,
            "code": "NO_RESOURCE_FOUND",
            "message": f"لم يتم العثور على مورد ({res_key}) متاح من المستوى {start_level} حتى المستوى {min_lv} ضمن مسافة {max_dist:g}.",
            "target": None,
            "resource": None,
            "attempts_used": total_attempts,
        }
    
    def get_max_can_kill_monster_level(self) -> int:
        """
        أقصى مستوى وحش مسموح للقلعة بمهاجمته حالياً (0-Network).
        مطابقة حرفية لدالة kingdomMapCell:getMaxCanKillLevel() في سورس اللعبة (السطر 932).
        """
        km = self.get_ctrl("kingdomMapCtrl")
        if not isinstance(km, dict):
            return 40
        max_npc_lv = self._safe_int(km.get("maxNpcLevel"), 0)
        max_map_npc_lv = self._safe_int(km.get("maxMapNpcLevel"), 40)
        if max_npc_lv <= 0:
            return max_map_npc_lv if max_map_npc_lv > 0 else 40
        ret = min(max_npc_lv + 1, 40)
        if max_map_npc_lv > 0 and ret > max_map_npc_lv:
            ret = max_map_npc_lv
        return max(1, ret)

    async def search_best_monster(
        self,
        level: int,
        monster_type: str = "normal",
        max_distance: float = 120.0,
        min_level: int = 1,
        max_attempts_per_level: int = 3,
        max_failed_attempts: int = 3,
        retry_delay_range: Tuple[float, float] = (1.8, 3.8),
        reserve_found: bool = True,
        respect_unlock_cap: bool = True,
    ) -> Dict[str, Any]:
        """
        البحث الرسمي الموحّد عن الوحوش (العادية أو وحوش معركة السحاب):
        - monster_type="normal" (أو "monster" / "عادي" / "وحوش"):
            يرسل CMD 2083/1 (REQ_SEARCH_MONSTER) ويسجّل الاستبعاد في حوض "monster".
        - monster_type="nebula" (أو "cloud" / "سحاب" / "معركة_السحاب"):
            يرسل CMD 2083/9 (REQ_SEARCH_MAP_TPYE) بـ mapType=56 ويسجّل الاستبعاد في حوض "nebula_monster".
        """
        type_aliases: Dict[str, Tuple[str, str, str]] = {
            "normal": ("normal", "monster", "الوحوش العادية"),
            "monster": ("normal", "monster", "الوحوش العادية"),
            "npc": ("normal", "monster", "الوحوش العادية"),
            "عادي": ("normal", "monster", "الوحوش العادية"),
            "وحوش": ("normal", "monster", "الوحوش العادية"),
            "الوحوش": ("normal", "monster", "الوحوش العادية"),
            "1": ("normal", "monster", "الوحوش العادية"),
            "nebula": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "cloud": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "nebula_monster": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "سحاب": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "السحاب": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "معركة السحاب": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "معركة_السحاب": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
            "56": ("nebula", "nebula_monster", "وحوش معركة السحاب"),
        }

        raw_type = str(monster_type or "normal").strip().lower()
        if raw_type not in type_aliases:
            return {
                "success": False,
                "code": "INVALID_MONSTER_TYPE",
                "message": f"نوع الوحش غير معروف: '{monster_type}'. القيم المدعومة: normal (وحوش عادية) أو nebula (وحوش معركة السحاب).",
                "target": None,
                "monster": None,
                "attempts_used": 0,
            }

        m_mode, exclude_type, ar_label = type_aliases[raw_type]
        if m_mode == "nebula":
            # وحوش معركة السحاب مستوياتها الرسمية 41..50 فقط (nebula_area_tower.lua: npcId 3041..3050)
            max_can_kill = 50
            req_level = max(41, min(50, self._safe_int(level, 41)))
            start_level = req_level
            min_lv = max(41, min(start_level, self._safe_int(min_level, 41)))
        else:
            max_can_kill = self.get_max_can_kill_monster_level()
            req_level = max(1, min(40, self._safe_int(level, 10)))
            start_level = min(req_level, max_can_kill) if respect_unlock_cap else req_level
            min_lv = max(1, min(start_level, self._safe_int(min_level, 1)))
        max_dist = max(1.0, float(max_distance))
        max_tries = max(1, self._safe_int(max_attempts_per_level, 3))
        max_fails = max(1, self._safe_int(max_failed_attempts, 3))
        delay_lo, delay_hi = retry_delay_range
        failed_attempts = 0

        async def _on_failure() -> bool:
            """تسجيل محاولة فاشلة وإرجاع True إذا بلغنا الحد الأقصى (3) للتوقف فوراً بدون انتظار زائد."""
            nonlocal failed_attempts
            failed_attempts += 1
            if failed_attempts >= max_fails:
                self.log(f"🛑 [بحث {ar_label}] تم بلوغ الحد الأقصى للمحاولات الفاشلة المتتالية ({failed_attempts}/{max_fails}) — إيقاف البحث.")
                return True
            if delay_hi > 0:
                await asyncio.sleep(random.uniform(max(0.2, delay_lo), max(delay_lo, delay_hi)))
            return False

        cx, cy, kid = self._get_castle_coords_and_kingdom()
        cap_txt = f" (المتاح للقتل حتى: {max_can_kill})" if m_mode == "normal" else ""
        self.log(
            f"📍 [بحث {ar_label}] موقع القلعة الفعلي: ({cx}, {cy}) | المملكة: {kid} | "
            f"المستوى المطلوب: {req_level}{cap_txt}"
        )

        if cx <= 0 and cy <= 0:
            return {
                "success": False,
                "code": "CASTLE_COORDS_MISSING",
                "message": "تعذر قراءة إحداثيات القلعة من الذاكرة الحية (cityCtrl.cinfo.pos).",
                "target": None,
                "monster": None,
                "attempts_used": 0,
            }

        # جلب خريطة الاستبعاد المعزولة لهذا النوع تحديداً ومفلترة بالمسافة
        exclude_map = await self.get_exclude_map(
            kingdom_id=kid,
            x=cx,
            y=cy,
            max_distance=max_dist,
            target_type=exclude_type,
        )

        seen_coords: Set[Tuple[int, int]] = set()
        total_attempts = 0

        for lv in range(start_level, min_lv - 1, -1):
            if failed_attempts >= max_fails:
                break

            for attempt in range(1, max_tries + 1):
                if failed_attempts >= max_fails:
                    break

                total_attempts += 1
                is_new_search = (attempt == 1)

                if m_mode == "nebula":
                    # وحوش معركة السحاب: CMD 2083/9 (REQ_SEARCH_MAP_TPYE) بـ mapType=56 (nebulaNpc)
                    subcmd = "9"
                    payload: Dict[str, Any] = {
                        "mapType": 56,
                        "minlv": lv,
                        "maxlv": lv,
                        "research": is_new_search,
                    }
                else:
                    # الوحوش العادية: CMD 2083/1 (REQ_SEARCH_MONSTER)
                    subcmd = "1"
                    payload = {
                        "minLv": lv,
                        "maxLv": lv,
                        "posx": cx,
                        "posy": cy,
                        "research": is_new_search,
                    }

                resp = await self.safe_query("2083", subcmd, payload, min_delay=0.3, max_delay=0.7)
                if not isinstance(resp, dict) or not self._is_resp_ok(resp):
                    await _on_failure()
                    break

                # استخراج الإحداثيات من رد 2083/1 أو 2083/9 (المسار الرسمي هو result)
                inner: Dict[str, Any] = {}
                for key in ("result", "rspdata", "data", "retData"):
                    val = resp.get(key)
                    if isinstance(val, dict) and any(k in val for k in ("x", "y", "posX", "posY", "pos")):
                        inner = val
                        break
                if not inner:
                    inner = resp

                pos_obj = inner.get("pos") if isinstance(inner.get("pos"), dict) else {}
                tx = self._safe_int(inner.get("x", inner.get("posX", pos_obj.get("x", 0))), 0)
                ty = self._safe_int(inner.get("y", inner.get("posY", pos_obj.get("y", 0))), 0)

                if tx <= 0 and ty <= 0:
                    self.log(f"⚠️ [بحث {ar_label}] لم يُعثر على هدف مستوى {lv} في رد 2083/{subcmd}: {resp}")
                    await _on_failure()
                    break

                dist = math.hypot(tx - cx, ty - cy)
                if dist > max_dist:
                    self.log(
                        f"⏭️ [بحث {ar_label}] مستوى {lv}: أقرب هدف ({tx}, {ty}) يبعد {dist:.1f} > {max_dist:g}، الانتقال للمستوى التالي."
                    )
                    await _on_failure()
                    break

                target_id = f"{exclude_type}_{tx}_{ty}"
                alt_tid = f"{tx}_{ty}"

                if (
                    (tx, ty) in seen_coords
                    or target_id in exclude_map
                    or alt_tid in exclude_map
                    or self._is_coord_targeted_by_any_march(tx, ty)
                ):
                    self.log(f"⏭️ [بحث {ar_label}] تخطي ({tx}, {ty}) مستوى {lv} لأنه مستبعد/مشغول (محاولة فاشلة {failed_attempts + 1}/{max_fails}).")
                    if await _on_failure():
                        break
                    continue

                seen_coords.add((tx, ty))

                if reserve_found:
                    reserved = await self.reserve_target(target_id, kingdom_id=kid, target_type=exclude_type)
                    if not reserved:
                        self.log(f"🔒 [بحث {ar_label}] ({tx}, {ty}) محجوز لقلعة شقيقة — إعادة البحث.")
                        exclude_map[target_id] = True
                        if await _on_failure():
                            break
                        continue

                self.log(f"✅ [بحث {ar_label}] تم اختيار هدف مستوى {lv} في ({tx}, {ty}) | المسافة: {dist:.1f}")
                target_info = {
                    "target_type": exclude_type,
                    "monster_type": m_mode,
                    "monster_label": ar_label,
                    "level": lv,
                    "x": tx,
                    "y": ty,
                    "target_id": target_id,
                    "distance": round(dist, 2),
                    "kingdom_id": kid,
                    "castle_pos": {"x": cx, "y": cy},
                    "max_can_kill_level": max_can_kill,
                }
                return {
                    "success": True,
                    "code": "OK",
                    "message": f"تم العثور على ({ar_label}) مستوى {lv} في ({tx}, {ty}) على مسافة {dist:.1f}.",
                    "target": target_info,
                    "monster": target_info,
                    "attempts_used": total_attempts,
                }

        return {
            "success": False,
            "code": "NO_MONSTER_FOUND",
            "message": f"لم يتم العثور على ({ar_label}) متاح من المستوى {start_level} حتى المستوى {min_lv} ضمن مسافة {max_dist:g}.",
            "target": None,
            "monster": None,
            "attempts_used": total_attempts,
        }
    
    async def search_best_ruins(
        self,
        max_distance: float = 120.0,
        max_scans: int = 3,
        scan_step: int = 75,
        lod: int = 3,
        scan_delay_range: Tuple[float, float] = (1.0, 2.0),
        skip_coords: Optional[Set[Tuple[int, int]]] = None,
    ) -> Dict[str, Any]:
        """
        البحث الرسمي عن أقرب أطلال (Relics) متاحة بدون أمير داخلها أو يسير إليها
        عبر مسح الخريطة الرسمي CMD 1006/1000 (REQ_KINGDOM_MAP_SYNC) + تحقق CMD 1006/15:
        - يمسح حول موقع القلعة الفعلي (cityCtrl.cinfo.pos) بمسار حلزوني (30×30 لكل طلب).
        - يستخرج كل الأطلال (type=7) من kingdomMapCtrl المحدّث عبر NOTIFY_MAP_SYNC (201).
        - يستبعد أي أطلال يتجه إليه فيلق أو فيه أمير حالياً (من الذاكرة الحية + 1006/15).
        - لا يسجّل الأطلال في exclude_manager (التزاماً باستثناء الأطلال من الاستبعاد).
        """
        max_dist = max(1.0, float(max_distance))
        scans_limit = max(1, self._safe_int(max_scans, 9))
        step = max(15, self._safe_int(scan_step, 30))
        delay_lo, delay_hi = scan_delay_range

        cx, cy, kid = self._get_castle_coords_and_kingdom()
        self.log(f"📍 [بحث الأطلال] موقع القلعة الفعلي: ({cx}, {cy}) | المملكة: {kid} | أقصى مسافة: {max_dist:g}")

        if cx <= 0 and cy <= 0:
            return {
                "success": False,
                "code": "CASTLE_COORDS_MISSING",
                "message": "تعذر قراءة إحداثيات القلعة من الذاكرة الحية (cityCtrl.cinfo.pos).",
                "target": None,
                "ruins": None,
                "attempts_used": 0,
            }

        def _extract_relics_and_busy_from_map() -> Tuple[List[Dict[str, Any]], Set[Tuple[int, int]], Set[str]]:
            """استخراج جميع الأطلال (mapType=7) والطوابير المتجهة إليها من kingdomMapCtrl."""
            km = self.get_ctrl("kingdomMapCtrl")
            relics_by_xy: Dict[Tuple[int, int], Dict[str, Any]] = {}
            busy_coords: Set[Tuple[int, int]] = set()
            busy_ids: Set[str] = set()

            def _walk(obj: Any, depth: int = 0) -> None:
                if depth > 10 or obj is None:
                    return
                if isinstance(obj, list):
                    for item in obj:
                        _walk(item, depth + 1)
                    return
                if not isinstance(obj, dict):
                    return

                # 1. فحص هل الكائن طابور مسيرة على الخريطة (يحتوي from/to)
                to_obj = obj.get("to")
                if isinstance(to_obj, dict) and ("x" in to_obj or "id" in to_obj):
                    st = self._safe_int(obj.get("status"), 1)
                    if st in ACTIVE_MARCH_QUEUE_STATUSES or "status" not in obj:
                        qx = self._safe_int(to_obj.get("x"), -1)
                        qy = self._safe_int(to_obj.get("y"), -1)
                        if qx >= 0 and qy >= 0:
                            busy_coords.add((qx, qy))
                            if qx > 0 and qy > 0:
                                busy_coords.add((qx - 1, qy - 1))
                        tid_s = str(to_obj.get("id") or "").strip()
                        if tid_s:
                            busy_ids.add(tid_s)

                # 2. فحص هل الكائن أطلال (type=7 أو id بصيغة "sx-sy-7-sub-objId")
                obj_id_str = str(obj.get("id") or "").strip()
                parts = obj_id_str.split("-") if "-" in obj_id_str else []
                is_relic_by_id = len(parts) >= 5 and parts[2] == "7"
                obj_type = self._safe_int(obj.get("type", obj.get("mapType", 0)), 0)

                if is_relic_by_id or obj_type == 7:
                    if is_relic_by_id:
                        sx = self._safe_int(parts[0], 0)
                        sy = self._safe_int(parts[1], 0)
                        tx, ty = max(0, sx - 1), max(0, sy - 1)
                        inst_id = obj_id_str
                    else:
                        tx = self._safe_int(obj.get("x"), 0)
                        ty = self._safe_int(obj.get("y"), 0)
                        inst_id = obj_id_str if "-" in obj_id_str else f"{tx + 1}-{ty + 1}-7-0-3701"

                    if tx > 0 or ty > 0:
                        owner_uid = str(
                            obj.get("playerID")
                            or obj.get("uid")
                            or obj.get("ownerId")
                            or obj.get("occupyUid")
                            or obj.get("exploreUid")
                            or ""
                        ).strip()
                        is_occ = (owner_uid not in ("", "0")) or bool(obj.get("queueId")) or bool(obj.get("queueID"))
                        prev = relics_by_xy.get((tx, ty))
                        if prev is None or is_occ:
                            relics_by_xy[(tx, ty)] = {
                                "x": tx,
                                "y": ty,
                                "instance_id": inst_id,
                                "occupied_hint": is_occ,
                            }

                for k, v in obj.items():
                    if isinstance(k, str) and "-" in k:
                        kparts = k.split("-")
                        if len(kparts) >= 5 and kparts[2] == "7":
                            sx = self._safe_int(kparts[0], 0)
                            sy = self._safe_int(kparts[1], 0)
                            tx, ty = max(0, sx - 1), max(0, sy - 1)
                            if (tx > 0 or ty > 0) and (tx, ty) not in relics_by_xy:
                                is_occ = False
                                if isinstance(v, dict):
                                    ou = str(v.get("playerID") or v.get("uid") or v.get("ownerId") or "").strip()
                                    is_occ = (ou not in ("", "0")) or bool(v.get("queueId"))
                                relics_by_xy[(tx, ty)] = {
                                    "x": tx,
                                    "y": ty,
                                    "instance_id": k,
                                    "occupied_hint": is_occ,
                                }
                    if isinstance(v, (dict, list)):
                        _walk(v, depth + 1)

            _walk(km)
            return list(relics_by_xy.values()), busy_coords, busy_ids

        # بناء نقاط المسح الحلزونية حول القلعة ضمن نطاق max_dist
        scan_points: List[Tuple[int, int]] = [(cx, cy)]
        max_ring = max(1, int(math.ceil(max_dist / float(step))))
        for ring in range(1, max_ring + 1):
            for dx in range(-ring, ring + 1):
                for dy in range(-ring, ring + 1):
                    if max(abs(dx), abs(dy)) != ring:
                        continue
                    px = max(1, min(1199, cx + dx * step))
                    py = max(1, min(1199, cy + dy * step))
                    if math.hypot(px - cx, py - cy) <= max_dist + step:
                        scan_points.append((px, py))
        scan_points = scan_points[:scans_limit]

        checked_coords: Set[Tuple[int, int]] = set(skip_coords) if skip_coords else set()
        total_scans = 0

        for idx, (sx, sy) in enumerate(scan_points, 1):
            total_scans += 1
            sync_payload = {
                "centerKid": kid,
                "centerX": sx,
                "centerY": sy,
                "lod": lod,
            }
            await self.safe_query("1006", "1000", sync_payload, min_delay=0.3, max_delay=0.6)
            # انتظار قصير لوصول حزم NOTIFY_MAP_SYNC (201) ودمجها في kingdomMapCtrl
            await asyncio.sleep(0.75)

            relics, busy_coords, busy_ids = _extract_relics_and_busy_from_map()
            candidates: List[Tuple[float, Dict[str, Any]]] = []
            for r in relics:
                tx, ty = r["x"], r["y"]
                if (tx, ty) in checked_coords:
                    continue
                dist = math.hypot(tx - cx, ty - cy)
                if dist > max_dist:
                    continue
                if (
                    r.get("occupied_hint")
                    or (tx, ty) in busy_coords
                    or r["instance_id"] in busy_ids
                    or self._is_coord_targeted_by_any_march(tx, ty)
                ):
                    checked_coords.add((tx, ty))
                    continue
                candidates.append((dist, r))

            candidates.sort(key=lambda item: item[0])

            for dist, r in candidates:
                tx, ty = r["x"], r["y"]
                inst_id = r["instance_id"]
                checked_coords.add((tx, ty))

                # تحقق نهائي عبر CMD 1006/15 للتأكد من عدم وجود أمير يستكشف الأطلال حالياً
                info_resp = await self.safe_query(
                    "1006",
                    "15",
                    {"x": tx, "y": ty, "id": inst_id, "kingdomId": kid},
                    min_delay=0.3,
                    max_delay=0.6,
                )

                occupied = False
                verified = False
                if isinstance(info_resp, dict) and self._is_resp_ok(info_resp):
                    verified = True
                    ret_data: Dict[str, Any] = {}
                    for k in ("retData", "result", "rspdata", "data"):
                        v = info_resp.get(k)
                        if isinstance(v, dict):
                            ret_data = v
                            break
                    if not ret_data:
                        ret_data = info_resp

                    sub_blocks = [ret_data]
                    for sub_k in ("relic", "relics", "remains", "explore", "owner", "playerInfo"):
                        sv = ret_data.get(sub_k)
                        if isinstance(sv, dict):
                            sub_blocks.append(sv)

                    for blk in sub_blocks:
                        owner_uid = str(
                            blk.get("playerID")
                            or blk.get("uid")
                            or blk.get("ownerId")
                            or blk.get("occupyUid")
                            or blk.get("exploreUid")
                            or ""
                        ).strip()
                        if (
                            (owner_uid and owner_uid != "0")
                            or bool(blk.get("queueId"))
                            or bool(blk.get("queueID"))
                            or bool(blk.get("playerName"))
                            or bool(blk.get("nickName"))
                        ):
                            occupied = True
                            break

                if occupied:
                    self.log(f"🚫 [بحث الأطلال] الأطلال ({tx}, {ty}) مشغول بأمير آخر — الانتقال للأقرب التالي.")
                    continue

                target_id = f"ruins_{tx}_{ty}"
                self.log(f"✅ [بحث الأطلال] تم اختيار أطلال متاحة في ({tx}, {ty}) | المسافة: {dist:.1f}")
                target_info = {
                    "target_type": "ruins",
                    "x": tx,
                    "y": ty,
                    "target_id": target_id,
                    "instance_id": inst_id,
                    "distance": round(dist, 2),
                    "verified": verified,
                    "occupied": False,
                    "kingdom_id": kid,
                    "castle_pos": {"x": cx, "y": cy},
                    "info_resp": info_resp if isinstance(info_resp, dict) else None,
                }
                return {
                    "success": True,
                    "code": "OK",
                    "message": f"تم العثور على أطلال متاحة في ({tx}, {ty}) على مسافة {dist:.1f}.",
                    "target": target_info,
                    "ruins": target_info,
                    "attempts_used": total_scans,
                }

            if idx < len(scan_points) and delay_hi > 0:
                await asyncio.sleep(random.uniform(max(0.3, delay_lo), max(delay_lo, delay_hi)))

        return {
            "success": False,
            "code": "NO_RUINS_FOUND",
            "message": f"لم يتم العثور على أطلال متاحة ضمن مسافة {max_dist:g} بعد {total_scans} مسحات للخريطة.",
            "target": None,
            "ruins": None,
            "attempts_used": total_scans,
        }

    def _get_active_soldier_load_multiplier(self) -> float:
        """
        حساب مضاعف حمولة الجنود النشط من الذاكرة الحية (0-Network) كحد أدنى آمن:
        مطابق جزئياً لـ kingdomMapCtrl:getArmyWeightPlus() (buffCtrl Effect 117).
        """
        bonus = 0.0
        snap = self._get_live_snapshot()
        buff_ctrl = snap.get("buffCtrl")
        if isinstance(buff_ctrl, dict):
            now_ts = time.time()
            raw_buffs = buff_ctrl.get("buffList") or buff_ctrl.get("buffs") or buff_ctrl
            entries = raw_buffs.values() if isinstance(raw_buffs, dict) else (raw_buffs if isinstance(raw_buffs, list) else [])
            for b in entries:
                if not isinstance(b, dict):
                    continue
                eff = self._safe_int(b.get("effect") or b.get("buffType") or b.get("type"), 0)
                if eff != 117:  # SOLDIER_LOAD_BOOST
                    continue
                end_t = self._safe_float(b.get("endTime") or b.get("expireTime") or 0.0)
                if end_t > 1e11:
                    end_t /= 1000.0
                if end_t > 0 and end_t < now_ts:
                    continue
                val = self._safe_float(b.get("value") or b.get("buffValue") or 0.0)
                if val > 0:
                    bonus += val / 1000.0
        return max(1.0, 1.0 + bonus)

    def build_gather_army_formation(
        self,
        resource_type: Union[str, int],
        resource_amount: int,
        available_soldiers: Optional[Union[List[Dict[str, Any]], Dict[int, int]]] = None,
        available_heroes: Optional[Union[List[Dict[str, Any]], List[int]]] = None,
        max_march_capacity: Optional[int] = None,
        safety_margin: float = 0.03,
        max_heroes: Optional[int] = None,
        use_load_buff: bool = True,
    ) -> Dict[str, Any]:
        """
        تشكيل فيلق الجمع الأمثل (جنود + أبطال) لمورد محدد بحيث ينهي كامل كميته بهامش أمان بسيط:
        - resource_type      : نوع المورد (gold/food/wood/iron/silver/crystal أو 1..6 أو 1001..1006 أو بالعربي).
        - resource_amount    : الكمية المتبقية في المورد (مثال: 300000 خشب أو 50000 حديد).
        - available_soldiers : الجنود المتاحون بدون حصن الحرب (قائمة من get_available_soldiers أو قاموس {id: count}).
        - available_heroes   : الأبطال المتاحون (قائمة من get_available_heroes أو قائمة أرقام hero_id).
        - max_march_capacity : السعة القصوى للفيلق (عدد الجنود الأقصى المسموح بإرساله).
        - safety_margin      : هامش الأمان الإضافي فوق كمية المورد (الافتراضي 0.03 = +3%).
        - max_heroes         : أقصى عدد أبطال للفيلق (افتراضياً يُقرأ تلقائياً من get_max_battle_hero_num()).
        """
        raw_key = str(resource_type).strip().lower()
        if raw_key not in RESOURCE_SEARCH_ALIASES:
            return {
                "success": False,
                "code": "INVALID_RESOURCE_TYPE",
                "message": f"نوع المورد غير معروف: {resource_type}",
                "soldiers": {},
                "army_payload": [],
                "hero_ids": [],
                "hero_payload": [],
            }

        res_code, res_key = RESOURCE_SEARCH_ALIASES[raw_key]
        amount = max(0, self._safe_int(resource_amount, 0))
        if amount <= 0:
            return {
                "success": False,
                "code": "INVALID_RESOURCE_AMOUNT",
                "message": f"كمية المورد غير صالحة: {resource_amount}",
                "soldiers": {},
                "army_payload": [],
                "hero_ids": [],
                "hero_payload": [],
            }

        # 1. توحيد قائمة الجنود المتاحين واستبعاد أي فخاخ حصن حرب دفاعياً
        if available_soldiers is None:
            raw_soldiers_list = self.get_available_soldiers()
        elif isinstance(available_soldiers, dict):
            raw_soldiers_list = [
                {"army_id": int(aid), "count": self._safe_int(cnt, 0)}
                for aid, cnt in available_soldiers.items()
            ]
        else:
            raw_soldiers_list = list(available_soldiers)

        soldier_pool: List[Dict[str, Any]] = []
        for s in raw_soldiers_list:
            if not isinstance(s, dict):
                continue
            aid = self._safe_int(s.get("army_id") or s.get("id"), 0)
            cnt = self._safe_int(s.get("count") or s.get("num"), 0)
            if cnt <= 0 or not self.is_dispatchable_soldier_id(aid):
                continue
            base_id, branch_code, view_lv, is_enhanced = self._parse_soldier_meta(aid)
            base_weight = ARMY_BASE_FREE_WEIGHT.get(base_id, 8)
            soldier_pool.append({
                "army_id": aid,
                "base_id": base_id,
                "branch_code": branch_code,
                "view_level": view_lv,
                "is_enhanced": is_enhanced,
                "count": cnt,
                "free_weight": base_weight,
            })

        if not soldier_pool:
            return {
                "success": False,
                "code": "NO_SOLDIERS_AVAILABLE",
                "message": "لا يوجد جنود متاحون في القلعة لتشكيل فيلق الجمع.",
                "soldiers": {},
                "army_payload": [],
                "hero_ids": [],
                "hero_payload": [],
            }

        # 2. تحديد السعة القصوى للفيلق حصرياً عبر tasks/march_capacity.py
        if max_march_capacity is None:
            from tasks.march_capacity import get_march_capacity_no_heroes
            cap = self._safe_int(get_march_capacity_no_heroes(self._get_live_snapshot()), 0)
        else:
            cap = self._safe_int(max_march_capacity, 0)

        if cap <= 0:
            return {
                "success": False,
                "code": "INVALID_MARCH_CAPACITY",
                "message": f"سعة الفيلق القصوى غير صالحة: {max_march_capacity}",
                "soldiers": {},
                "army_payload": [],
                "hero_ids": [],
                "hero_payload": [],
            }

        # 3. توحيد قائمة الأبطال المتاحين واختيار أبطال الجمع/الحمولة المناسبين
        if available_heroes is None:
            raw_heroes_list = self.get_available_heroes()
        else:
            raw_heroes_list = list(available_heroes)

        hero_slots = (
            max(0, min(2, self._safe_int(max_heroes, 1)))
            if max_heroes is not None
            else (self.get_max_battle_hero_num() if hasattr(self, "get_max_battle_hero_num") else 1)
        )

        # تجهيز بيانات الأبطال للفرز الذكي
        spec_for_res = dict(GATHER_HERO_SPECIALISTS.get(res_key, []))
        load_specs = dict(LOAD_HERO_SPECIALISTS)

        def _is_hero_skill_active(h_dict: Dict[str, Any], skill_type: int) -> bool:
            raw = h_dict.get("raw") if isinstance(h_dict.get("raw"), dict) else h_dict
            slist = raw.get("skillList")
            if not isinstance(slist, dict):
                return True  # عند تمرير قائمة IDs فقط بدون raw نعتمد على معرف البطل
            entry = slist.get(str(skill_type)) or slist.get(skill_type)
            if isinstance(entry, dict):
                return bool(entry.get("isActive", False))
            return False

        scored_gather_heroes: List[Tuple[int, int, int, int]] = []
        fallback_heroes: List[Tuple[int, int, int]] = []

        for h in raw_heroes_list:
            if isinstance(h, dict):
                hid = self._safe_int(h.get("hero_id") or h.get("heroID") or h.get("id"), 0)
                h_lv = self._safe_int(h.get("level"), 1)
                h_q = self._safe_int(h.get("quality"), 1)
                h_dict = h
            else:
                hid = self._safe_int(h, 0)
                h_lv, h_q, h_dict = 1, 1, {}

            if hid <= 0:
                continue

            score = 0
            if hid in spec_for_res and _is_hero_skill_active(h_dict, spec_for_res[hid]):
                score += 1000  # بطل متخصص في جمع هذا المورد تحديداً
            if hid in load_specs and _is_hero_skill_active(h_dict, load_specs[hid]):
                score += 600   # بطل زيادة حمولة الجنود

            if score > 0:
                scored_gather_heroes.append((score, h_q, h_lv, hid))
            else:
                fallback_heroes.append((h_q, h_lv, hid))

        scored_gather_heroes.sort(key=lambda x: (-x[0], -x[1], -x[2], x[3]))
        selected_hero_ids: List[int] = [x[3] for x in scored_gather_heroes[:hero_slots]]

        # 4. حساب الوزن المطلوب بدقة مع هامش الأمان
        unit_weight = RESOURCE_UNIT_WEIGHT.get(res_key, 1)
        margin = max(0.0, float(safety_margin))
        raw_required_weight = amount * unit_weight
        target_weight = math.ceil(raw_required_weight * (1.0 + margin))
        load_mult = self._get_active_soldier_load_multiplier() if use_load_buff else 1.0

        # 5. ترتيب الجنود للجمع الاحترافي:
        #    (1) الأعلى حمولة (freeWeight) أولاً -> يضع عربات النقل (711, 709, 706, 704, 702...) في المقدمة
        #    (2) تفضيل العربات (branch=7) عند تساوي الحمولة لإبقاء جنود القتال بالقلعة
        #    (3) تفضيل الرتبة الأقل وغير المطوّرة بالنجوم عند تساوي الحمولة لحماية الجنود النادرين
        soldier_pool.sort(
            key=lambda s: (
                -s["free_weight"],
                0 if s["branch_code"] == 7 else 1,
                1 if s["is_enhanced"] else 0,
                s["view_level"],
                s["base_id"],
            )
        )

        # 6. توزيع الجنود حتى تغطية target_weight أو بلوغ max_march_capacity
        chosen_soldiers: Dict[int, int] = {}
        remaining_weight = float(target_weight)
        remaining_slots = cap
        total_soldiers = 0
        total_load = 0.0

        for s in soldier_pool:
            if remaining_weight <= 0 or remaining_slots <= 0:
                break
            per_troop_load = s["free_weight"] * load_mult
            if per_troop_load <= 0:
                continue
            needed = math.ceil(remaining_weight / per_troop_load)
            take = min(s["count"], needed, remaining_slots)
            if take <= 0:
                continue
            chosen_soldiers[s["army_id"]] = chosen_soldiers.get(s["army_id"], 0) + take
            gained_load = take * per_troop_load
            total_soldiers += take
            total_load += gained_load
            remaining_weight -= gained_load
            remaining_slots -= take

        carryable_resource = int(math.floor(total_load / float(unit_weight)))
        can_clear_all = carryable_resource >= amount
        coverage_pct = min(100.0, round((carryable_resource / float(amount)) * 100.0, 2)) if amount > 0 else 100.0

        # إذا لم نتمكن من إنهاء المورد ولدينا خانات أبطال شاغرة، أضف أبطالاً احتياطيين للمساعدة
        if not can_clear_all and len(selected_hero_ids) < hero_slots and fallback_heroes:
            fallback_heroes.sort(key=lambda x: (-x[0], -x[1], x[2]))
            for _q, _lv, hid in fallback_heroes:
                if len(selected_hero_ids) >= hero_slots:
                    break
                if hid not in selected_hero_ids:
                    selected_hero_ids.append(hid)

        army_payload = [{"id": aid, "num": cnt} for aid, cnt in chosen_soldiers.items()]
        hero_payload = [{"heroID": hid} for hid in selected_hero_ids]

        return {
            "success": True,
            "code": "OK" if can_clear_all else "PARTIAL_LOAD",
            "message": (
                f"تم تشكيل فيلق جمع لـ {res_key} ({amount:,}): {total_soldiers:,}/{cap:,} جندي "
                f"(حمولة {carryable_resource:,} = {coverage_pct:.1f}%)"
            ),
            "resource_type": res_key,
            "resource_code": res_code,
            "resource_amount": amount,
            "unit_weight": unit_weight,
            "required_weight": raw_required_weight,
            "target_weight_with_margin": target_weight,
            "safety_margin": margin,
            "load_multiplier": round(load_mult, 4),
            "max_march_capacity": cap,
            "total_soldiers": total_soldiers,
            "total_load": int(math.floor(total_load)),
            "carryable_resource": carryable_resource,
            "can_clear_all": can_clear_all,
            "coverage_percent": coverage_pct,
            "soldiers": chosen_soldiers,
            "army_payload": army_payload,
            "hero_ids": selected_hero_ids,
            "hero_payload": hero_payload,
        }


    @staticmethod
    def _get_soldier_combat_power(army_id: int, level: int = 1) -> float:
        """حساب القوة القتالية الأساسية للجندي الواحد وفق armyinfo.lua."""
        if 800 <= army_id < 900:
            sub = army_id % 10
            return SPECIAL_8XX_POWER_BY_SUB.get(sub, 1.0)
        tier = max(1, min(14, int(level or 1)))
        if tier <= 1 and 400 <= army_id < 800:
            tier = max(1, min(14, army_id % 100))
        return SOLDIER_POWER_BY_TIER.get(tier, 1.0)

    @staticmethod
    def get_target_combat_fc(
        target_type: str = "monster",
        level: int = 1,
        custom_fc: Optional[int] = None,
    ) -> int:
        """إرجاع القوة القتالية الرسمية (fc) للهدف (وحش عادي، سحابي، أو زعيم بقوة مخصصة)."""
        if custom_fc is not None and int(custom_fc) > 0:
            return int(custom_fc)
        return int(NPC_COMBAT_FC_BY_LEVEL.get(int(level), 0))

    def _compute_recommended_max_level(
        self,
        effective_power: float,
        target_type: str,
        min_win_ratio: float,
        max_unlocked_level: Optional[int] = None,
    ) -> int:
        """حساب أعلى مستوى وحش تستطيع القلعة قتله بشكل مؤكد بالقوة المتاحة حالياً."""
        t = (target_type or "monster").strip().lower()
        if t in ("nebula", "nebula_monster", "cloud"):
            lv_range = range(41, 51)
        else:
            upper = min(40, int(max_unlocked_level)) if max_unlocked_level else 40
            lv_range = range(1, max(1, upper) + 1)

        best_lv = 0
        for lv in lv_range:
            fc = NPC_COMBAT_FC_BY_LEVEL.get(lv, 0)
            if fc > 0 and (effective_power / fc) >= min_win_ratio:
                best_lv = lv
        return best_lv

    def build_combat_army_formation(
        self,
        target_type: str = "monster",
        level: int = 1,
        strategy: str = "max_power",
        min_win_ratio: float = DEFAULT_COMBAT_MIN_WIN_RATIO,
        combat_buff_factor: float = 1.0,
        custom_fc: Optional[int] = None,
        exclude_defend_heroes: bool = False,
        max_win_ratio: Optional[float] = 3.0,
    ) -> Dict[str, Any]:
        """
        تشكيل الفيلق القتالي المناسب (أبطال + جنود) لقتل هدف محدد بشكل مؤكد (0-Network).
        يعيد ok=False و can_kill=False مع السبب الدقيق وأعلى مستوى موصى به عند عدم القدرة على القتل.

        المعاملات:
          - target_type: 'monster' (1..40)، 'nebula_monster' (41..50)، أو 'boss' (مع custom_fc).
          - level: مستوى الوحش المستهدف.
          - strategy: 'max_power' (ملء السعة لتقليل الجرحى)، 'exact_threshold' (اقتصادي)، 'strict_overkill' (> 2.0x).
          - min_win_ratio: عتبة الفوز المؤكد الافتراضية 1.5 (تتوافق مع المؤشر الأخضر في اللعبة).
          - combat_buff_factor: معامل بوف القلعة القتالي (افتراضي 1.0 = مطابق تماماً لمؤشر اللعبة الخام).
        """
        t_norm = (target_type or "monster").strip().lower()
        req_level = int(level)
        req_ratio = 2.01 if strategy == "strict_overkill" else max(0.1, float(min_win_ratio))
        buff_mul = max(0.1, float(combat_buff_factor))

        # 1) التحقق من فتح مستوى الوحش العادي في القلعة
        max_unlocked: Optional[int] = None
        if t_norm in ("monster", "normal", "normal_monster"):
            if hasattr(self, "get_max_can_kill_monster_level"):
                try:
                    max_unlocked = int(self.get_max_can_kill_monster_level())
                except Exception:
                    max_unlocked = None
            if max_unlocked is not None and req_level > max_unlocked:
                return {
                    "ok": False,
                    "can_kill": False,
                    "error_code": "TARGET_LEVEL_LOCKED",
                    "reason": f"مستوى الوحش المطلوب ({req_level}) غير مفتوح بعد؛ أعلى مستوى مفتوح هو {max_unlocked}.",
                    "requested_level": req_level,
                    "max_unlocked_level": max_unlocked,
                    "recommended_max_level": max_unlocked,
                }

        # 2) استخراج القوة الرسمية للهدف (npc.fc)
        npc_fc = self.get_target_combat_fc(t_norm, req_level, custom_fc=custom_fc)
        if npc_fc <= 0:
            return {
                "ok": False,
                "can_kill": False,
                "error_code": "UNKNOWN_TARGET_POWER",
                "reason": f"لا توجد قوة مسجلة (fc) للهدف من نوع '{t_norm}' مستوى {req_level}.",
                "requested_level": req_level,
            }

        # 3) التحقق من وجود جنود متاحين
        soldiers_now = self.get_available_soldiers()
        if not soldiers_now:
            return {
                "ok": False,
                "can_kill": False,
                "error_code": "NO_AVAILABLE_SOLDIERS",
                "reason": "لا يوجد جنود متاحون في القلعة حالياً.",
                "npc_fc": npc_fc,
                "recommended_max_level": 0,
            }

        # 4) اختيار أقوى الأبطال المتاحين أولاً (حتى 5 أبطال حسب get_max_battle_hero_num)
        heroes_now = self.get_available_heroes(exclude_defend=exclude_defend_heroes)
        max_heroes = 5
        if hasattr(self, "get_max_battle_hero_num"):
            try:
                max_heroes = max(1, int(self.get_max_battle_hero_num()))
            except Exception:
                max_heroes = 5

        sorted_heroes = sorted(
            heroes_now,
            key=lambda h: (
                int(h.get("quality") or 0),
                int(h.get("level") or 0),
                int(h.get("hero_id") or h.get("heroID") or h.get("id") or 0),
            ),
            reverse=True,
        )
        selected_heroes: List[int] = []
        for h in sorted_heroes[:max_heroes]:
            hid = int(h.get("hero_id") or h.get("heroID") or h.get("id") or 0)
            if hid > 0:
                selected_heroes.append(hid)

        # 5) حساب السعة القصوى الحية للفيلق حصرياً عبر tasks/march_capacity.py
        from tasks.march_capacity import get_march_capacity, get_march_capacity_no_heroes

        live_mem = self._get_live_snapshot()
        max_cap = int(
            get_march_capacity(
                live_mem,
                hero_ids=selected_heroes or None,
                only_normal_state=exclude_defend_heroes,
            )
            or 0
        )
        if max_cap <= 0:
            max_cap = int(get_march_capacity_no_heroes(live_mem) or 0)

        # 6) ترتيب الجنود المتاحين تنازلياً حسب القوة القتالية للجندي الواحد
        enriched_soldiers: List[Dict[str, Any]] = []
        for s in soldiers_now:
            sid = int(s.get("army_id") or s.get("id") or 0)
            cnt = int(s.get("count") or 0)
            lv = int(s.get("level") or 1)
            if sid <= 0 or cnt <= 0:
                continue
            unit_pwr = self._get_soldier_combat_power(sid, lv)
            enriched_soldiers.append({
                "army_id": sid,
                "level": lv,
                "count": cnt,
                "unit_power": unit_pwr,
            })

        enriched_soldiers.sort(
            key=lambda x: (x["unit_power"], x["level"], x["count"]),
            reverse=True,
        )

        # 7) تقييم القوة القصوى الممكنة ضمن سعة الفيلق (مع احترام السقف الأعلى max_win_ratio)
        required_power = npc_fc * req_ratio
        cap_ratio = float(max_win_ratio) if (max_win_ratio is not None and float(max_win_ratio) > 0) else None
        if cap_ratio is not None and cap_ratio < req_ratio:
            cap_ratio = req_ratio
        max_allowed_power = (npc_fc * cap_ratio) if cap_ratio is not None else None
        total_castle_raw_power = sum(x["count"] * x["unit_power"] for x in enriched_soldiers)

        remaining_cap = max_cap
        army_dict: Dict[str, int] = {}
        raw_power = 0.0
        total_sent = 0

        for s in enriched_soldiers:
            if remaining_cap <= 0:
                break
            unit_pwr = s["unit_power"]
            max_take = min(s["count"], remaining_cap)
            if max_take <= 0:
                continue

            if strategy == "exact_threshold":
                eff_so_far = raw_power * buff_mul
                if eff_so_far >= required_power:
                    break
                needed_eff = required_power - eff_so_far
                needed_units = int(math.ceil(needed_eff / max(1e-6, unit_pwr * buff_mul)))
                take = min(max_take, max(1, needed_units))
            elif max_allowed_power is not None:
                eff_so_far = raw_power * buff_mul
                if eff_so_far >= max_allowed_power:
                    break
                room_eff = max_allowed_power - eff_so_far
                allowed_units = int(math.floor(room_eff / max(1e-6, unit_pwr * buff_mul)))
                if allowed_units <= 0:
                    if eff_so_far >= required_power:
                        break
                    allowed_units = 1
                take = min(max_take, allowed_units)
            else:
                take = max_take

            army_dict[str(s["army_id"])] = take
            raw_power += take * unit_pwr
            total_sent += take
            remaining_cap -= take

        effective_power = raw_power * buff_mul
        win_ratio = effective_power / float(npc_fc)

        # 8) شرط الرفض الصريح إذا لم تتحقق عتبة القتل المؤكد
        if win_ratio < req_ratio or total_sent <= 0:
            rec_max_lv = self._compute_recommended_max_level(
                effective_power=effective_power,
                target_type=t_norm,
                min_win_ratio=req_ratio,
                max_unlocked_level=max_unlocked,
            )
            if (total_castle_raw_power * buff_mul) >= required_power:
                err_code = "INSUFFICIENT_CAPACITY"
                reason = (
                    f"لا يمكن قتل الهدف (مستوى {req_level}) بشكل مؤكد بسبب ضيق سعة الفيلق ({max_cap:,}): "
                    f"النسبة المحققة {win_ratio:.2f}× أقل من المطلوب {req_ratio:.2f}×."
                )
            else:
                err_code = "INSUFFICIENT_SOLDIERS"
                reason = (
                    f"لا يمكن قتل الهدف (مستوى {req_level}) بشكل مؤكد بسبب نقص الجنود المتاحين: "
                    f"القوة المحققة {effective_power:,.0f} من أصل {required_power:,.0f} مطلوبة "
                    f"(النسبة {win_ratio:.2f}× < {req_ratio:.2f}×)."
                )
            return {
                "ok": False,
                "can_kill": False,
                "error_code": err_code,
                "reason": reason,
                "target_type": t_norm,
                "requested_level": req_level,
                "npc_fc": npc_fc,
                "required_power": round(required_power, 1),
                "achieved_power": round(effective_power, 1),
                "win_ratio": round(win_ratio, 3),
                "min_win_ratio": req_ratio,
                "max_capacity": max_cap,
                "recommended_max_level": rec_max_lv,
            }

        tier_label = "overkill" if win_ratio > 2.0 else "safe"
        return {
            "ok": True,
            "can_kill": True,
            "error_code": "OK",
            "tier": tier_label,
            "target_type": t_norm,
            "level": req_level,
            "army": army_dict,
            "hero_ids": selected_heroes,
            "total_soldiers": total_sent,
            "max_capacity": max_cap,
            "raw_army_power": round(raw_power, 1),
            "effective_power": round(effective_power, 1),
            "npc_fc": npc_fc,
            "win_ratio": round(win_ratio, 3),
            "min_win_ratio": req_ratio,
        }


    @staticmethod
    def _format_duration_hms(seconds: float) -> str:
        """تحويل الثواني إلى صيغة مقروءة HH:MM:SS."""
        sec = max(0, int(round(seconds)))
        h, rem = divmod(sec, 3600)
        m, s = divmod(rem, 60)
        return f"{h:02d}:{m:02d}:{s:02d}"

    def _get_active_gather_speed_multiplier(self, res_key: str) -> float:
        """حساب مضاعف سرعة الجمع النشط من الذاكرة الحية (buffCtrl: Effect 17 + الخاص بالمورد)."""
        bonus = 0.0
        target_effs = {17}  # GATHER_SPEED_BOOST (عام)
        if res_key in GATHER_SPEED_BUFF_BY_RES:
            target_effs.add(GATHER_SPEED_BUFF_BY_RES[res_key])

        snap = self._get_live_snapshot()
        buff_ctrl = snap.get("buffCtrl")
        if isinstance(buff_ctrl, dict):
            now_ts = time.time()
            raw_buffs = buff_ctrl.get("buffList") or buff_ctrl.get("buffs") or buff_ctrl
            entries = raw_buffs.values() if isinstance(raw_buffs, dict) else (raw_buffs if isinstance(raw_buffs, list) else [])
            for b in entries:
                if not isinstance(b, dict):
                    continue
                eff = self._safe_int(b.get("effect") or b.get("buffType") or b.get("type"), 0)
                if eff not in target_effs:
                    continue
                end_t = self._safe_float(b.get("endTime") or b.get("expireTime") or 0.0)
                if end_t > 1e11:
                    end_t /= 1000.0
                if end_t > 0 and end_t < now_ts:
                    continue
                val = self._safe_float(b.get("value") or b.get("buffValue") or 0.0)
                if val > 0:
                    bonus += val / 1000.0
        return max(1.0, 1.0 + bonus)

    def estimate_march_duration(
        self,
        march_type: str,
        dispatch_response: Optional[Dict[str, Any]] = None,
        target_x: Optional[int] = None,
        target_y: Optional[int] = None,
        distance: Optional[float] = None,
        resource_type: Optional[Union[str, int]] = None,
        resource_amount: int = 0,
        work_seconds: float = 0.0,
    ) -> Dict[str, Any]:
        """
        حساب الوقت الكلي الفعلي للمسيرة (ذهاب + عمل/جمع + إياب) لجميع أنواع المسيرات (0-Network):
        - gather / resource              : ذهاب + وقت الجمع (resource.lua + buffCtrl) + إياب
        - monster / nebula / boss        : ذهاب + 0 + إياب (القتال فوري عند الوصول)
        - ruins / relics                 : ذهاب + work_seconds (مدة الاستكشاف) + إياب
        - escort / escort_assist         : ذهاب فقط (قافلة حراسة الكنز باتجاه واحد)
        - help / resource_help / attack  : ذهاب + 0 + إياب
        """
        now_ts = time.time()
        m_type = str(march_type or "gather").strip().lower()

        def _extract_go_from_dict(d: Any) -> float:
            if not isinstance(d, dict):
                return 0.0
            for container in (d, d.get("queue"), d.get("data"), d.get("result"), d.get("rspdata")):
                if not isinstance(container, dict):
                    continue
                for dur_key in ("moveTime", "needTime", "marchTime", "goTime"):
                    dv = self._safe_float(container.get(dur_key), 0.0)
                    if dv > 0:
                        return dv / 1000.0 if dv > 1e6 else dv
                st = self._safe_float(container.get("startTime") or container.get("beginTime") or 0.0)
                ft = self._safe_float(container.get("finishTime") or container.get("endTime") or 0.0)
                if st > 1e11:
                    st /= 1000.0
                if ft > 1e11:
                    ft /= 1000.0
                if ft > st > 0:
                    return ft - st
                if ft > now_ts:
                    return ft - now_ts
            return 0.0

        # 1. استخراج وقت الذهاب الحقيقي من رد السيرفر أولاً، ثم من local_queues، ثم تقدير بالمسافة
        go_sec = _extract_go_from_dict(dispatch_response)
        source = "server_response" if go_sec > 0 else ""

        if go_sec <= 0 and target_x is not None and target_y is not None:
            tx_i, ty_i = int(target_x), int(target_y)
            valid_xy = {(tx_i, ty_i), (tx_i + 1, ty_i + 1), (tx_i - 1, ty_i - 1)}
            for q, _st in self._iter_my_active_queues():
                to_obj = q.get("to") if isinstance(q.get("to"), dict) else {}
                qx = self._safe_int(to_obj.get("x") or q.get("target_x"), -1)
                qy = self._safe_int(to_obj.get("y") or q.get("target_y"), -1)
                if (qx, qy) in valid_xy:
                    go_sec = _extract_go_from_dict(q)
                    if go_sec > 0:
                        source = "local_queues"
                        break

        if go_sec <= 0:
            dist = float(distance) if distance is not None else 0.0
            if dist <= 0 and target_x is not None and target_y is not None:
                cx, cy, _kid = self._get_castle_coords_and_kingdom()
                if cx > 0 or cy > 0:
                    dist = math.hypot(int(target_x) - cx, int(target_y) - cy)
            # تقدير احتياطي عند المحاكاة (dry-run): ~3 ثوانٍ/مربع للجمع والأطلال و~1.8 للوحوش والكنز
            sec_per_tile = 3.0 if m_type in ("gather", "resource", "ruins", "relics") else 1.8
            go_sec = max(0.0, dist * sec_per_tile)
            source = "distance_estimate"

        # 2. حساب وقت العمل/البقاء في الهدف + وقت الإياب حسب نوع المسيرة
        stay_sec = max(0.0, float(work_seconds))
        return_sec = go_sec

        if m_type in ("gather", "resource"):
            if stay_sec <= 0 and resource_type is not None and resource_amount > 0:
                raw_k = str(resource_type).strip().lower()
                res_key = RESOURCE_SEARCH_ALIASES[raw_k][1] if raw_k in RESOURCE_SEARCH_ALIASES else raw_k
                base_per_hour = RESOURCE_BASE_GATHER_SPEED_PER_HOUR.get(res_key, 55200.0)
                speed_mult = self._get_active_gather_speed_multiplier(res_key)
                if base_per_hour > 0:
                    stay_sec = (float(resource_amount) / (base_per_hour * speed_mult)) * 3600.0
        elif m_type in ("monster", "nebula", "nebula_monster", "boss", "help", "resource_help", "attack"):
            stay_sec = 0.0
            return_sec = go_sec
        elif m_type in ("ruins", "relics"):
            return_sec = go_sec
        elif m_type in ("escort", "escort_assist"):
            stay_sec = 0.0
            return_sec = 0.0  # قافلة حراسة الكنز باتجاه واحد

        total_sec = go_sec + stay_sec + return_sec
        return {
            "march_type": m_type,
            "go_seconds": round(go_sec, 1),
            "work_seconds": round(stay_sec, 1),
            "return_seconds": round(return_sec, 1),
            "total_seconds": round(total_sec, 1),
            "total_formatted": self._format_duration_hms(total_sec),
            "expected_return_at": round(now_ts + total_sec, 1),
            "source": source,
        }

    async def dispatch_gather_march(
        self,
        target: Dict[str, Any],
        formation: Dict[str, Any],
    ) -> Dict[str, Any]:
        """
        إرسال فيلق جمع الموارد الفعلي عبر CMD 1007/2 (ADD_KINGDOM_QUEUE):
        - مطابق لـ worldMapFunction.lua:206-260 (moveLineType=3, matrixType=3).
        - يدير دورة حياة الاستبعاد تلقائياً:
            * نجاح الإرسال أو اختفاء/احتلال البلاطة -> confirm_target
            * خطأ محلي من القلعة (نقص جنود/سعة/طوابير) -> release_target لتحرير الهدف فوراً
        """
        tx = self._safe_int(target.get("x"), 0)
        ty = self._safe_int(target.get("y"), 0)
        kid = self._safe_int(target.get("kingdom_id"), self.kingdom_id)
        target_id = str(target.get("target_id") or "").strip()
        instance_id = str(target.get("instance_id") or "").strip()
        res_key = str(target.get("resource_key") or target.get("resource_type") or "").strip()

        army_payload = formation.get("army_payload") or []
        hero_payload = formation.get("hero_payload") or []

        if not army_payload or (tx <= 0 and ty <= 0):
            if target_id:
                await self.release_target(target_id, kingdom_id=kid, target_type=res_key)
            return {
                "success": False,
                "retryable": False,
                "code": "INVALID_DISPATCH_PARAMS",
                "message": "بيانات الهدف أو الجيش غير مكتملة لإرسال فيلق الجمع.",
            }

        march_payload: Dict[str, Any] = {
            "moveLineType": 3,  # gMapMoveLineType.moveLineTypecapture
            "matrixType": 3,    # gMapMoveLineMatrixType.moveLineMatrixTypeCollection
            "data": {
                "to": {
                    "x": tx,
                    "y": ty,
                    "id": instance_id,
                },
                "army": army_payload,
                "heroInfo": hero_payload,
                "armsInfo": [],
                "divineBeastInfo": [],
                "mapId": kid,
                "isDuel": False,
                "isForbidSpeed": False,
                "data": {},
            },
        }

        self.log(
            f"🚀 [إرسال جمع] إرسال {formation.get('total_soldiers', 0):,} جندي "
            f"(أبطال: {formation.get('hero_ids', [])}) نحو {res_key} مستوى {target.get('level')} "
            f"في ({tx}, {ty}) | تغطية: {formation.get('coverage_percent', 0)}%"
        )

        resp = await self.safe_query("1007", "2", march_payload, min_delay=0.5, max_delay=1.1)
        if isinstance(resp, dict) and self._is_resp_ok(resp):
            if target_id:
                await self.confirm_target(target_id, kingdom_id=kid, target_type=res_key)

            # انتظار قصير لوصول طابور المسيرة الحقيقي من NOTIFY_LOCAL_QUEUE_SYNC (202)
            valid_xy = {(tx, ty), (tx + 1, ty + 1), (tx - 1, ty - 1)}
            wait_end = time.monotonic() + 1.5
            while time.monotonic() < wait_end:
                found_q = False
                for q, _st in self._iter_my_active_queues():
                    to_obj = q.get("to") if isinstance(q.get("to"), dict) else {}
                    qx = self._safe_int(to_obj.get("x") or q.get("target_x"), -1)
                    qy = self._safe_int(to_obj.get("y") or q.get("target_y"), -1)
                    if (qx, qy) in valid_xy:
                        found_q = True
                        break
                if found_q:
                    break
                await asyncio.sleep(0.1)

            # حساب الوقت الكلي (ذهاب + جمع + إياب)
            actual_gather_amount = min(
                self._safe_int(formation.get("resource_amount"), 0),
                self._safe_int(formation.get("carryable_resource"), 0),
            )
            timing = self.estimate_march_duration(
                march_type="gather",
                dispatch_response=resp,
                target_x=tx,
                target_y=ty,
                distance=target.get("distance"),
                resource_type=res_key,
                resource_amount=actual_gather_amount,
            )
            self.log(
                f"✅ [إرسال جمع] انطلق الفيلق نحو ({tx}, {ty}) | "
                f"الزمن الكلي المتوقع: {timing['total_formatted']} [{timing['source']}] "
                f"(ذهاب: {timing['go_seconds']:.0f}ث | جمع: {timing['work_seconds']:.0f}ث | إياب: {timing['return_seconds']:.0f}ث)"
            )
            return {
                "success": True,
                "retryable": False,
                "code": "OK",
                "message": f"تم إرسال فيلق الجمع بنجاح نحو ({tx}, {ty}).",
                "timing": timing,
                "response": resp,
            }

        err_code = str(resp.get("err", resp.get("code", "TIMEOUT")) if isinstance(resp, dict) else "NO_RESPONSE").strip()
        # أخطاء القلعة المحلية (نفاد فيالق/جنود/سعة) -> تحرير الحجز والتوقف
        # أخطاء الهدف (اختفاء/احتلال البلاطة) -> تثبيت الاستبعاد وإعادة المحاولة
        castle_side_errors = {"NO_RESPONSE", "TIMEOUT", "20003", "20004"}
        is_castle_error = err_code in castle_side_errors

        if target_id:
            if is_castle_error:
                await self.release_target(target_id, kingdom_id=kid, target_type=res_key)
            else:
                await self.confirm_target(target_id, kingdom_id=kid, target_type=res_key)

        self.log(f"❌ [إرسال جمع] فشل الإرسال نحو ({tx}, {ty}) | كود الخطأ: {err_code} | الرد: {resp}")
        return {
            "success": False,
            "retryable": not is_castle_error,
            "code": err_code,
            "message": f"فشل إرسال فيلق الجمع (كود السيرفر: {err_code}).",
            "response": resp,
        }

    # ═════════════════════════════════════════════════════════════════════════
    # 7. الفحص القبلي ومحرك التنفيذ (Pre-flight & Execution Engine)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        """الفحص القبلي السريع للجاهزية (0-Network Pre-flight)."""
        if not self.is_active:
            return False, "مدير المسيرات معطل في الإعدادات وفق رغبة المستخدم."

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بخادم اللعبة."

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة."

        return True, ""

    def _load_effective_manager_config(self) -> Dict[str, Any]:
        """
        تجميع إعدادات مدير المسيرات من self.config (القادمة من قاعدة البيانات عبر CastleBot)،
        مع قراءة محلية احتياطية من SQLite فقط إذا كان التشغيل مستقلاً ولم تُمرر الإعدادات الفرعية.
        (0-Network بالكامل).
        """
        cfg: Dict[str, Any] = dict(self.config) if isinstance(self.config, dict) else {}
        priority_keys = (
            "treasure_escort",
            "daily_hunt",
            "daily_gather",
            "explore_ruins",
            "resource_help",
            "hunt_monsters",
            "gather_resources",
            "gather_speed_buff",
        )
        if any(k in cfg for k in priority_keys):
            return cfg

        # احتياطي محلي عند التشغيل المباشر من الطرفية: جلب إعدادات march_manager من SQLite إن وجدت
        email = getattr(getattr(self.conn, "account", None), "email", "") or ""
        if email:
            try:
                import core.database as db
                db_cfg = db.get_castle_config_only(email)
                if isinstance(db_cfg, dict):
                    mm_db = db_cfg.get("march_manager")
                    if not isinstance(mm_db, dict) and isinstance(db_cfg.get("tasks"), dict):
                        mm_db = db_cfg["tasks"].get("march_manager")
                    if isinstance(mm_db, dict):
                        merged = dict(mm_db)
                        merged.update(cfg)
                        return merged
            except Exception:
                pass
        return cfg

    def _get_subtask_db_config(self, mgr_cfg: Dict[str, Any], primary_key: str, aliases: Tuple[str, ...] = ()) -> Dict[str, Any]:
        """استخراج إعدادات أولوية محددة من إعدادات قاعدة البيانات بدون تعديل الأصل."""
        for k in (primary_key,) + aliases:
            val = mgr_cfg.get(k)
            if isinstance(val, dict):
                return dict(val)
        return {}

    def _is_priority_eligible_for_castle(self, priority_key: str, sub_cfg: Dict[str, Any]) -> Tuple[bool, str]:
        """
        فحص أهلية القلعة لتنفيذ الأولوية من الذاكرة الحية فقط (0-Network) قبل إنشاء المهمة:
          - بعض القلاع لا تملك مهام نشاط يومي للوحوش أو الجمع، أو لم تفتح المورد أو السوق أو التحالف.
        """
        if priority_key == "treasure_escort":
            if self.has_treasure_escort_march():
                return False, "يوجد بالفعل فيلق حراسة كنز نشط بالخارج."
            return True, ""

        if priority_key == "daily_hunt":
            daily = self.get_daily_march_tasks_status()
            info = daily.get("attack_monsters")
            if not isinstance(info, dict) or not info.get("available", False):
                return False, "لا توجد مهمة هجوم وحوش في النشاط اليومي لهذه القلعة."
            if info.get("completed"):
                return False, "مهمة الهجوم على الوحوش اليومية منجزة بالفعل."
            return True, ""

        if priority_key == "daily_gather":
            daily = self.get_daily_march_tasks_status()
            has_pending = any(
                isinstance(daily.get(k), dict)
                and daily[k].get("available", False)
                and not daily[k].get("completed", False)
                and not daily[k].get("has_active_march", False)
                for k in ("gather_food", "gather_wood", "gather_iron", "gather_silver")
            )
            if not has_pending:
                return False, "لا توجد مهام جمع يومية متاحة أو غير منجزة لهذه القلعة."
            return True, ""

        if priority_key == "explore_ruins":
            if self.has_relics_explore_march():
                return False, "يوجد بالفعل فيلق استكشاف أطلال نشط بالخارج."
            return True, ""

        if priority_key == "resource_help":
            tx = self._safe_int(sub_cfg.get("target_x", sub_cfg.get("x", -1)), -1)
            ty = self._safe_int(sub_cfg.get("target_y", sub_cfg.get("y", -1)), -1)
            if tx < 0 or ty < 0:
                return False, "إحداثيات القلعة المستلمة لمساعدة الموارد غير مضبوطة في الإعدادات."
            if self.get_resource_help_transport_capacity() <= 0:
                return False, "مبنى السوق غير متوفر أو سعة النقل تساوي 0 لهذه القلعة."
            return True, ""

        if priority_key == "hunt_monsters":
            return True, ""

        if priority_key == "gather_resources":
            raw_res = str(sub_cfg.get("resource_type", sub_cfg.get("resource", "wood")) or "wood").strip().lower()
            if raw_res not in RESOURCE_SEARCH_ALIASES:
                return False, f"نوع المورد المحدد غير معروف: {raw_res}"
            _code, res_key = RESOURCE_SEARCH_ALIASES[raw_res]
            min_lv = {"food": 1, "wood": 1, "gold": 10, "iron": 10, "silver": 15, "crystal": 30}.get(res_key, 1)
            c_lv = self._safe_int(getattr(self, "castle_level", 1), 1)
            if c_lv < min_lv:
                return False, f"المورد ({res_key}) غير مفتوح لمستوى القلعة الحالي ({c_lv} < {min_lv})."
            return True, ""

        return True, ""

    async def _maybe_activate_gather_speed_buff(self, mgr_cfg: Dict[str, Any]) -> None:
        """
        تفعيل مكافأة سرعة الجمع (صغيرة -> كبيرة -> سوبر) مرة واحدة فقط قبل أول مهمة جمع مؤهلة
        إذا كانت مفعّلة في قاعدة البيانات (0-Network إذا كان الباف نشطاً، وطلب 1004/2 واحد فقط عند الحاجة).
        """
        buff_cfg = self._get_subtask_db_config(mgr_cfg, "gather_speed_buff", ("gather_buff",))
        if not buff_cfg.get("enabled", False):
            return
        try:
            from tasks.gather_speed_buff import GatherSpeedBuffTask
            buff_task = GatherSpeedBuffTask(self.conn, self.log, buff_cfg)
            res = await buff_task.safe_execute()
            if res.success:
                self.log(f"✅ [MarchManager -> gather_speed_buff] {res.message}")
            elif res.skipped:
                self.log(f"⏭️ [MarchManager -> gather_speed_buff] {res.message}")
            else:
                self.log(f"⚠️ [MarchManager -> gather_speed_buff] {res.message}")
        except ConnectionCircuitBreakerError:
            raise
        except Exception as e:
            if "ConcurrentLogin" in type(e).__name__:
                raise
            self.log(f"⚠️ [MarchManager -> gather_speed_buff] تعذر تفعيل مكافأة سرعة الجمع: {e}")

    def _build_official_priority_pipeline(self) -> List[Dict[str, Any]]:
        """
        جدول الأولويات السبع الرسمي بالترتيب الصارم المعتمد:
          1. حراسة الكنز (treasure_escort)
          2. الهجوم على الوحوش العاديين - مود النشاط اليومي (daily_hunt)      [يرث وقت 20 د]
          3. جمع الموارد - مود النشاط اليومي (daily_gather)                  [يرث وقت 20 د]
          4. استكشاف الأطلال (explore_ruins)
          5. مساعدة الموارد (resource_help)                                   [يرث وقت 20 د | 0 جنود]
          6. الهجوم على الوحوش - المود العادي: عادي أو سحاب (hunt_monsters)   [يرث وقت 20 د]
          7. جمع الموارد - المود العادي (gather_resources)
        """
        from tasks.escort_treasure import EscortTreasureTask
        from tasks.hunt_monsters import HuntMonstersTask
        from tasks.gather_resources import GatherResourcesTask
        from tasks.explore_ruins import ExploreRuinsTask
        from tasks.resource_help import ResourceHelpTask

        return [
            {
                "key": "treasure_escort",
                "aliases": ("escort_treasure",),
                "label": "حراسة الكنز",
                "cls": EscortTreasureTask,
                "forced_mode": None,
                "inherits_time_budget": False,
                "requires_soldiers": True,
                "is_gather": False,
            },
            {
                "key": "daily_hunt",
                "aliases": ("daily_monsters", "hunt_daily"),
                "label": "الوحوش (النشاط اليومي)",
                "cls": HuntMonstersTask,
                "forced_mode": "daily_tasks",
                "inherits_time_budget": True,
                "requires_soldiers": True,
                "is_gather": False,
            },
            {
                "key": "daily_gather",
                "aliases": ("gather_daily",),
                "label": "جمع الموارد (النشاط اليومي)",
                "cls": GatherResourcesTask,
                "forced_mode": "daily_tasks",
                "inherits_time_budget": True,
                "requires_soldiers": True,
                "is_gather": True,
            },
            {
                "key": "explore_ruins",
                "aliases": ("ruins",),
                "label": "استكشاف الأطلال",
                "cls": ExploreRuinsTask,
                "forced_mode": None,
                "inherits_time_budget": False,
                "requires_soldiers": True,
                "is_gather": False,
            },
            {
                "key": "resource_help",
                "aliases": ("market_help",),
                "label": "مساعدة الموارد",
                "cls": ResourceHelpTask,
                "forced_mode": None,
                "inherits_time_budget": True,
                "requires_soldiers": False,
                "is_gather": False,
            },
            {
                "key": "hunt_monsters",
                "aliases": ("hunt", "monsters"),
                "label": "الوحوش (المود العادي)",
                "cls": HuntMonstersTask,
                "forced_mode": "hunt",
                "inherits_time_budget": True,
                "requires_soldiers": True,
                "is_gather": False,
            },
            {
                "key": "gather_resources",
                "aliases": ("gather",),
                "label": "جمع الموارد (العادي)",
                "cls": GatherResourcesTask,
                "forced_mode": "resource",
                "inherits_time_budget": False,
                "requires_soldiers": True,
                "is_gather": True,
            },
        ]

    async def run(self) -> TaskResult:
        """
        المنسّق المركزي لمدير المسيرات والفيالق (MarchManagerTask):
          1. يقرأ إعدادات القلعة من قاعدة البيانات ويفحص تفعيل وأهلية كل أولوية (0-Network).
          2. يدير الميزانية الزمنية التراكمية (20 دقيقة افتراضياً) ويمرر remaining_sec للمهام المستحقة.
          3. يتلقى إشارات الخروج الموحدة (manager_signal) ليقرر فوراً بين المواصلة أو الخروج الكلي،
             مع السماح للأولوية 5 (مساعدة الموارد) بالعمل عند نقص الجنود طالما يوجد فيلق شاغر.
          4. يفعّل مكافأة سرعة الجمع تلقائياً قبل أول مهمة جمع مؤهلة إذا كانت مفعّلة في قاعدة البيانات.
        """
        start_time = time.monotonic()
        max_duration = self.max_duration_seconds
        max_minutes = self.max_duration_minutes
        deadline = start_time + max_duration
        mgr_cfg = self._load_effective_manager_config()
        wait_interval_sec = max(
            10.0, self._safe_float(mgr_cfg.get("wait_interval_sec", DEFAULT_WAIT_INTERVAL_SEC), DEFAULT_WAIT_INTERVAL_SEC)
        )

        summary = self.get_march_status_summary()
        max_cap = summary["max_capacity"]
        active = summary["active_marches"]
        avail = summary["available_slots"]

        self.log(
            f"⚔️ [MarchManager] بدء دورة مدير المسيرات والفيالق "
            f"(الميزانية الكلية: {max_minutes} دقيقة | سعة الفيالق: {max_cap} | "
            f"نشطة بالخارج: {active} | شاغرة حالياً: {avail})."
        )

        pipeline = self._build_official_priority_pipeline()
        executed_subtasks = 0
        successful_subtasks = 0
        gather_buff_checked = False
        soldier_shortage_pending = False
        abort_reason = ""
        final_signal = MANAGER_SIGNAL_CONTINUE
        reports: List[Dict[str, Any]] = []

        # معرفة ما إذا كانت الأولوية 5 (مساعدة الموارد) مفعّلة في قاعدة البيانات لاستثناء نقص الجنود
        res_help_cfg_preview = self._get_subtask_db_config(mgr_cfg, "resource_help", ("market_help",))
        res_help_enabled = bool(res_help_cfg_preview.get("enabled", False))
        res_help_done = False

        for step in pipeline:
            p_key = step["key"]
            p_label = step["label"]

            # فحص قاطع الاتصال قبل كل أولوية
            if (
                not self.is_connected
                or getattr(self.conn, "is_other_device", False)
                or getattr(self.conn, "is_sealed", False)
            ):
                abort_reason = "انقطع الاتصال ببوابة اللعبة — إيقاف دورة مدير المسيرات فوراً."
                final_signal = MANAGER_SIGNAL_ABORT_DISCONNECTED
                self.log(f"⚡ [MarchManager] {abort_reason}")
                break

            # فحص الميزانية الزمنية المتبقية من الـ 20 دقيقة
            remaining_sec = deadline - time.monotonic()
            if remaining_sec <= 2.0:
                abort_reason = f"استُنفدت الميزانية الزمنية الكلية ({max_minutes} دقيقة) — الخروج فوراً."
                final_signal = MANAGER_SIGNAL_ABORT_TIME_EXPIRED
                self.log(f"⏳ [MarchManager] {abort_reason}")
                break

            # إذا رُصد نقص جنود سابقاً مع فيالق غير وحوش بالخارج: نسمح فقط لـ resource_help بالعمل ثم نخرج فوراً
            if soldier_shortage_pending:
                if step["requires_soldiers"]:
                    continue
                if self.get_available_marches_count() <= 0:
                    abort_reason = "نقص جنود وامتلاء الفيالق — إيقاف دورة مدير المسيرات فوراً."
                    final_signal = MANAGER_SIGNAL_ABORT_MARCHES_FULL
                    self.log(f"🛑 [MarchManager] {abort_reason}")
                    break

            # 1) التحقق من التفعيل في قاعدة البيانات وجلب بيانات المهمة
            sub_cfg = self._get_subtask_db_config(mgr_cfg, p_key, step["aliases"])
            if not sub_cfg.get("enabled", False):
                continue

            # 2) فحص الأهلية الخاصة بالقلعة من الذاكرة الحية (0-Network)
            eligible, elig_reason = self._is_priority_eligible_for_castle(p_key, sub_cfg)
            if not eligible:
                self.log(f"⏭️ [MarchManager -> {p_label}] غير مؤهلة حالياً: {elig_reason}")
                reports.append({"priority": p_key, "status": "ineligible", "message": elig_reason})
                if p_key == "resource_help":
                    res_help_done = True
                    if soldier_shortage_pending:
                        abort_reason = "نقص جنود مع فيالق غير وحوش بالخارج (وتم تخطي مساعدة الموارد لعدم أهليتها) — خروج فوري."
                        final_signal = MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE
                        break
                continue

            # 3) تفعيل مكافأة سرعة الجمع تلقائياً (مرة واحدة فقط) قبل أول مهمة جمع مؤهلة
            if step["is_gather"] and not gather_buff_checked:
                gather_buff_checked = True
                await self._maybe_activate_gather_speed_buff(mgr_cfg)
                remaining_sec = deadline - time.monotonic()
                if remaining_sec <= 2.0:
                    abort_reason = f"استُنفدت الميزانية الزمنية الكلية ({max_minutes} دقيقة) — الخروج فوراً."
                    final_signal = MANAGER_SIGNAL_ABORT_TIME_EXPIRED
                    break

            # 4) حقن الوضع والوقت المتبقي الدقيق في إعدادات المهمة الفرعية
            if step["forced_mode"] is not None:
                sub_cfg["mode"] = step["forced_mode"]
            if p_key == "daily_hunt":
                # الوحوش اليومية دائماً من النوع العادي + ضبط تلقائي للمستوى عند الحاجة
                sub_cfg["monster_type"] = "normal"
                sub_cfg.setdefault("auto_downgrade", True)
            elif p_key == "hunt_monsters":
                # المود العادي يدعم الوحوش العادية أو السحابية + التشكيلة المختارة + ضبط تلقائي للمستوى
                sub_cfg.setdefault("monster_type", "normal")
                sub_cfg.setdefault("auto_downgrade", True)
                if not sub_cfg.get("formation_id") and mgr_cfg.get("formation_id"):
                    sub_cfg["formation_id"] = self._safe_int(mgr_cfg.get("formation_id"), 0)

            if step["inherits_time_budget"]:
                sub_cfg["max_duration_sec"] = max(0.0, remaining_sec)
                sub_cfg["wait_interval_sec"] = wait_interval_sec

            # 5) تشغيل المهمة الفرعية واستلام تقريرها المعياري
            sub_instance = None
            try:
                rem_fmt = self._format_duration_hms(remaining_sec)
                self.log(
                    f"▶️ [MarchManager] تشغيل الأولوية [{p_label}] "
                    f"(المتبقي من الـ {max_minutes}د: {rem_fmt} | الفيالق الشاغرة: {self.get_available_marches_count()})..."
                )
                sub_instance = step["cls"](self.conn, self.log, sub_cfg)
                res = await sub_instance.safe_execute()
                executed_subtasks += 1
                if p_key == "resource_help":
                    res_help_done = True

                res_data = res.data if isinstance(res.data, dict) else {}
                sig = str(res_data.get("manager_signal") or MANAGER_SIGNAL_CONTINUE)

                if res.skipped:
                    self.log(f"⏭️ [MarchManager -> {p_label}] {res.message}")
                elif res.success:
                    successful_subtasks += 1
                    self.log(f"✅ [MarchManager -> {p_label}] {res.message}")
                else:
                    self.log(f"⚠️ [MarchManager -> {p_label}] {res.message}")

                reports.append({
                    "priority": p_key,
                    "success": res.success,
                    "skipped": res.skipped,
                    "signal": sig,
                    "message": res.message,
                })

                # 6) تطبيق قرار المدير بناءً على إشارة الخروج الموحدة (manager_signal)
                if sig == MANAGER_SIGNAL_ABORT_DISCONNECTED:
                    abort_reason = f"انقطاع الاتصال أثناء [{p_label}] — إيقاف الدورة فوراً."
                    final_signal = MANAGER_SIGNAL_ABORT_DISCONNECTED
                    self.log(f"⚡ [MarchManager] {abort_reason}")
                    break

                if sig == MANAGER_SIGNAL_ABORT_TIME_EXPIRED:
                    abort_reason = f"انتهت ميزانية الـ {max_minutes} دقيقة أثناء [{p_label}] — الخروج فوراً."
                    final_signal = MANAGER_SIGNAL_ABORT_TIME_EXPIRED
                    self.log(f"⏳ [MarchManager] {abort_reason}")
                    break

                if sig == MANAGER_SIGNAL_ABORT_MARCHES_FULL:
                    abort_reason = f"الفيالق ممتلئة بالكامل بلا فيالق وحوش بالخارج (من [{p_label}]) — الخروج فوراً من المدير."
                    final_signal = MANAGER_SIGNAL_ABORT_MARCHES_FULL
                    self.log(f"🛑 [MarchManager] {abort_reason}")
                    break

                if sig == MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE:
                    can_allow_res_help = (
                        res_help_enabled
                        and not res_help_done
                        and self.get_available_marches_count() > 0
                    )
                    if can_allow_res_help:
                        soldier_shortage_pending = True
                        self.log(
                            f"⚠️ [MarchManager] رصد نقص جنود في [{p_label}] مع فيالق غير وحوش بالخارج — "
                            f"السماح للأولوية 5 (مساعدة الموارد - 0 جنود) بالعمل أولاً ثم الخروج فوراً."
                        )
                        continue
                    abort_reason = f"نقص جنود مع وجود فيالق غير وحوش بالخارج (من [{p_label}]) — الخروج فوراً من المدير."
                    final_signal = MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE
                    self.log(f"🛑 [MarchManager] {abort_reason}")
                    break

                # إذا كنا في وضع استثناء مساعدة الموارد وانتهت مساعدة الموارد -> نخرج فوراً
                if soldier_shortage_pending and p_key == "resource_help":
                    abort_reason = "اكتملت مساعدة الموارد (استثناء 0 جنود) بعد رصد نقص جنود — الخروج فوراً من المدير."
                    final_signal = MANAGER_SIGNAL_ABORT_SOLDIER_SHORTAGE
                    self.log(f"🛑 [MarchManager] {abort_reason}")
                    break

            except ConnectionCircuitBreakerError:
                self.log(f"⚡ [MarchManager] قاطع الاتصال: انقطاع الاتصال أثناء [{p_label}] — إيقاف الدورة فوراً.")
                raise
            except Exception as e:
                if "ConcurrentLogin" in type(e).__name__:
                    raise
                self.log(f"❌ [MarchManager] خطأ غير متوقع في الأولوية [{p_label}]: {e}")
                reports.append({"priority": p_key, "status": "error", "message": str(e)})
            finally:
                sub_instance = None

        duration_spent = time.monotonic() - start_time
        reason_suffix = f" | سبب التوقف: {abort_reason}" if abort_reason else ""
        final_msg = (
            f"اكتملت دورة مدير المسيرات "
            f"(نُفّذ: {executed_subtasks} | نجح: {successful_subtasks} | "
            f"الزمن: {duration_spent:.1f}ث / {max_minutes}د{reason_suffix})."
        )
        result_payload = {
            "executed_subtasks": executed_subtasks,
            "successful_subtasks": successful_subtasks,
            "duration_spent_sec": round(duration_spent, 2),
            "max_duration_minutes": max_minutes,
            "final_signal": final_signal,
            "abort_reason": abort_reason,
            "reports": reports,
        }
        if final_signal == MANAGER_SIGNAL_ABORT_DISCONNECTED:
            self.log(f"⚡ [MarchManager] {final_msg}")
            return TaskResult(
                success=False,
                skipped=False,
                message=final_msg,
                data=result_payload,
                execution_time=round(duration_spent, 2),
            )

        self.log(f"🏁 [MarchManager] {final_msg}")
        return TaskResult.ok(
            final_msg,
            data=result_payload,
            exec_time=round(duration_spent, 2),
        )


# ═════════════════════════════════════════════════════════════════════════════
# 8. واجهة الاختبار المباشر من التيرمنال (CLI Test Runner)
# ═════════════════════════════════════════════════════════════════════════════

def _print_cli_report(
    mgr: MarchManagerTask,
    label: str,
    show_status: bool,
    show_heroes: bool,
    show_soldiers: bool,
    show_transport: bool,
    show_escort: bool,
    show_relics: bool,
    show_daily_tasks: bool,
    exclude_defend: bool,
    as_json: bool,
    formation_index: int = 0,
) -> None:
    payload: Dict[str, Any] = {"castle": label}
    if show_status:
        try:
            payload["march_status"] = mgr.get_march_status_summary()
        except Exception:
            payload["march_status"] = mgr.get_active_marches_eta()
    if show_heroes:
        heroes = mgr.get_available_heroes(exclude_defend=exclude_defend)
        payload["available_heroes_count"] = len(heroes)
        payload["available_heroes"] = [
            {k: v for k, v in h.items() if k != "raw"} for h in heroes
        ]
        payload["busy_in_queues"] = sorted(mgr.get_busy_hero_ids_from_queues())
    if show_soldiers:
        soldiers = mgr.get_available_soldiers()
        payload["available_soldiers_total"] = sum(s["count"] for s in soldiers)
        payload["available_soldiers"] = soldiers
    if show_transport:
        payload["resource_help_transport_capacity"] = mgr.get_resource_help_transport_capacity()
    if formation_index > 0:
        payload["saved_formation"] = mgr.get_saved_formation(formation_index)

    if show_escort:
        payload["has_treasure_escort"] = mgr.has_treasure_escort_march()
        payload["has_treasure_escort_with_assist"] = mgr.has_treasure_escort_march(include_assist=True)

    if show_relics:
        payload["has_relics_explore"] = mgr.has_relics_explore_march()
    
    if show_daily_tasks:
        payload["daily_march_tasks"] = mgr.get_daily_march_tasks_status()

    if as_json:
        print(json.dumps(payload, ensure_ascii=False, indent=2))
        return

    print("\n" + "=" * 66)
    print(f"  ⚔️  تقرير مدير المسيرات ({label})")
    print("=" * 66)

    if show_status and "march_status" in payload:
        st = payload["march_status"]
        if "max_capacity" in st:
            print(
                f"  • الفيالق : متاح {st['available_slots']} / {st['max_capacity']} "
                f"(نشط بالخارج: {st['active_marches']})"
            )
        else:
            print(f"  • المسيرات النشطة بالخارج : {st.get('active_count', 0)}")
        if st.get("earliest_return_seconds", 0) > 0:
            print(
                f"  • أقرب عودة : {st['earliest_return_seconds']} ثانية | "
                f"أبعد عودة : {st['latest_return_seconds']} ثانية"
            )

    if show_heroes:
        heroes = payload["available_heroes"]
        busy = payload["busy_in_queues"]
        mode_txt = "بدون أبطال الدفاع" if exclude_defend else "شامل أبطال الدفاع"
        print("-" * 66)
        print(f"  🦸 الأبطال المتاحون للإرسال ({len(heroes)} بطل | {mode_txt}):")
        if busy:
            print(f"  • أبطال مشغولون في مسيرات نشطة (local_queues): {busy}")
        if not heroes:
            print("    (لا يوجد أبطال متاحون حالياً)")
        else:
            for idx, h in enumerate(heroes, 1):
                def_tag = " [دفاع]" if h["is_defending"] else ""
                awk_tag = " [موقظ]" if h["is_awake"] else ""
                print(
                    f"    {idx:>2}. ID={h['hero_id']} | جودة={h['quality']} | "
                    f"مستوى={h['level']:>3} | حالة={h['state']}{def_tag}{awk_tag}"
                )

    if show_soldiers:
        soldiers = payload["available_soldiers"]
        total_cnt = payload["available_soldiers_total"]
        print("-" * 66)
        print(f"  🪖 الجنود المتاحون في القلعة بدون حصن الحرب (الإجمالي: {total_cnt:,}):")
        if not soldiers:
            print("    (لا يوجد جنود متاحون حالياً داخل القلعة)")
        else:
            for s in soldiers:
                enh_tag = " ★" if s["is_enhanced"] else ""
                print(
                    f"    • ID={s['army_id']:<10} | {s['branch_name']:<6} | "
                    f"مستوى={s['view_level']:>4g}{enh_tag} | العدد={s['count']:>10,}"
                )
    if show_transport:
        print("-" * 66)
        print(f"  🚚 سعة نقل مساعدة الموارد : {payload['resource_help_transport_capacity']:,}")

    if formation_index > 0 and "saved_formation" in payload:
        fm = payload["saved_formation"]
        print("-" * 66)
        print(f"  📋 {fm['name']} (#{fm['formation_index']}):")
        if not fm["is_configured"]:
            print("    (التشكيلة فارغة أو غير محفوظة في اللعبة)")
        else:
            print(f"    • الأبطال : {fm['hero_ids']}" + (f" | المساعدون: {fm['lieutenant_map']}" if fm["lieutenant_map"] else ""))
            print(f"    • إجمالي الجنود : {fm['total_soldiers']:,} -> {fm['soldiers']}")
            if fm["arms_ids"]:
                print(f"    • الأسلحة/الرونات : {fm['arms_ids']}")
            if fm["divine_beast_ids"]:
                print(f"    • الوحوش الإلهية : {fm['divine_beast_ids']}")

    if show_escort:
        has_own = payload["has_treasure_escort"]
        has_any = payload["has_treasure_escort_with_assist"]
        print("-" * 66)
        print(f"  💰 مسيرة حراسة الكنز (الخاصة بك) : {has_own}")
        print(f"  🤝 شاملة مساعدة حراسة التحالف    : {has_any}")

    if show_relics:
        print("-" * 66)
        print(f"  🏛️  مسيرة استكشاف الأطلال : {payload['has_relics_explore']}")
    if show_daily_tasks:
        dt = payload["daily_march_tasks"]
        labels = {
            "attack_monsters": "أهجم على الوحوش",
            "gather_food":     "جمع القمح",
            "gather_wood":     "جمع الخشب",
            "gather_iron":     "جمع الحديد",
            "gather_silver":   "جمع الفضة",
        }
        print("-" * 66)
        print("  📅 مهام النشاط اليومي للمسيرات:")
        for key, ar_name in labels.items():
            info = dt[key]
            if info["completed"]:
                st_txt = f"✅ منجزة ({info['progress']}/{info['target']})"
            else:
                march_txt = "🚀 توجد مسيرة نشطة" if info["has_active_march"] else "⏸️ لا توجد مسيرة"
                st_txt = f"❌ غير منجزة ({info['progress']}/{info['target']}) | {march_txt}"
            print(f"    • {ar_name:<16} : {st_txt}")

    print("=" * 66 + "\n")


async def _run_cli_live(args: argparse.Namespace) -> int:
    from core.game_client import (
        AccountSession,
        GameConnection,
        SessionCache,
        async_login,
        get_account_device_profile,
        sdk_login,
    )

    email = args.email.strip()
    password = args.password.strip() if args.password else None

    user_id, session_id, matched_email = SessionCache.get_account(email)
    if not user_id or not session_id:
        if not password:
            try:
                import core.database as db
                c_data = db.get_castle_by_id(email)
                if c_data and c_data.get("password"):
                    password = c_data["password"]
            except Exception:
                pass

        if password:
            print(f"[*] توثيق الحساب {email} عبر خادم SDK...")
            prof = get_account_device_profile(email)
            auth_res = sdk_login(email, password, device_id=prof["deviceId"])
            if not auth_res.get("success"):
                print(f"[-] فشلت المصادقة: {auth_res.get('error_msg')} (كود: {auth_res.get('error_code')})")
                return 1
            user_id = auth_res["userId"]
            session_id = auth_res["sessionId"]
            matched_email = email
            SessionCache.set_account(
                email, user_id, session_id,
                device_id=prof["deviceId"], model=prof["model"], os_version=prof["osVersion"],
            )
        else:
            print(f"[-] الحساب '{email}' غير موجود في session_cache.json؛ مرّر كلمة المرور عبر -p/--password.")
            return 1

    account = AccountSession(
        email=matched_email or email,
        user_id=str(user_id),
        session_id=str(session_id),
        password=password,
    )

    print(f"[*] الاتصال بخادم تسجيل الدخول للحساب: {account.email}...")
    creds = await async_login(account)
    if not creds:
        print("[-] فشلت المصادقة مع خادم تسجيل الدخول.")
        return 1

    conn = GameConnection(account, creds)
    try:
        ok = await conn.connect()
        if not ok:
            print("[-] فشل الاتصال ببوابة اللعبة.")
            return 1

        print("[*] انتظار تحميل الذاكرة الحية للقلعة (CMD 1000/1)...")
        deadline = time.monotonic() + 20.0
        ready = False
        while time.monotonic() < deadline:
            if getattr(conn, "is_other_device", False):
                print("[-] تم طرد الجلسة بسبب دخول متزامن من جهاز آخر (kick).")
                return 1
            if getattr(conn, "is_sealed", False):
                print("[-] الحساب محظور/مغلق (seal).")
                return 1
            if not getattr(conn, "_alive", True):
                print("[-] انقطع الاتصال بالبوابة قبل اكتمال تحميل الذاكرة الحية.")
                return 1

            is_ready, _missing = conn.memory_engine.is_memory_ready()
            if is_ready:
                ready = True
                break

            snap = conn.init_data if isinstance(getattr(conn, "init_data", None), dict) else {}
            if isinstance(snap.get("heroSysCtrl"), dict) and snap["heroSysCtrl"].get("heroList") and len(snap) >= 5:
                ready = True
                break
            await asyncio.sleep(0.15)

        if not ready:
            print("[-] انتهى وقت انتظار تحميل الذاكرة الحية (20s).")
            return 1

        # انتظار اكتمال مزامنة طوابير المسيرات النشطة من _init_flow (حتى 5 ثوانٍ)
        sync_deadline = time.monotonic() + 5.0
        while time.monotonic() < sync_deadline:
            if getattr(conn.memory_engine, "local_queues_synced", False):
                break
            await asyncio.sleep(0.15)
        await asyncio.sleep(0.2)

        mgr = MarchManagerTask(conn)
        lord_name = (
            ((conn.init_data.get("lordInfoCtrl") or {}).get("base") or {}).get("nickName")
            or account.email
        )
        
        if args.search_resource:
            print(
                f"[*] جاري البحث عن مورد '{args.search_resource}' "
                f"(مستوى {args.res_level} | أقصى مسافة {args.max_dist})..."
            )
            search_res = await mgr.search_best_resource(
                resource_type=args.search_resource,
                level=args.res_level,
                max_distance=args.max_dist,
            )
            if args.json:
                print(json.dumps(search_res, ensure_ascii=False, indent=2))
            else:
                print("\n" + "=" * 66)
                if search_res.get("success"):
                    t = search_res["target"]
                    rem_txt = (
                        f"{t['remaining']:,} / {t['max_capacity']:,} ({t['fill_ratio'] * 100:.0f}%)"
                        if t.get("remaining") is not None
                        else "غير محدد"
                    )
                    print(f"  ✅ تم العثور على مورد مناسب ({t['resource_key']} مستوى {t['level']}):")
                    print(f"    • الإحداثيات : ({t['x']}, {t['y']}) | المسافة: {t['distance']}")
                    print(f"    • المتبقي    : {rem_txt}")
                    print(f"    • المعرّف    : {t['target_id']}")
                else:
                    print(f"  ❌ {search_res.get('code', 'ERROR')}: {search_res.get('message', '')}")
                print("=" * 66 + "\n")
            return 0 if search_res.get("success") else 1

        if getattr(args, "search_monster", False):
            print(
                f"[*] جاري البحث عن وحش "
                f"(مستوى {args.monster_level} | أقصى مسافة {args.max_dist})..."
            )
            m_res = await mgr.search_best_monster(
                level=args.monster_level,
                monster_type=args.monster_type,
                max_distance=args.max_dist,
            )
            if args.json:
                print(json.dumps(m_res, ensure_ascii=False, indent=2))
            else:
                print("\n" + "=" * 66)
                if m_res.get("success"):
                    t = m_res["target"]
                    print(f"  ✅ تم العثور على وحش مناسب (مستوى {t['level']}):")
                    print(f"    • الإحداثيات : ({t['x']}, {t['y']}) | المسافة: {t['distance']}")
                    print(f"    • المعرّف    : {t['target_id']} | أقصى مستوى مفتوح: {t['max_can_kill_level']}")
                else:
                    print(f"  ❌ {m_res.get('code', 'ERROR')}: {m_res.get('message', '')}")
                print("=" * 66 + "\n")
            return 0 if m_res.get("success") else 1
        
        if getattr(args, "search_ruins", False):
            print(f"[*] جاري البحث عن أطلال متاحة (أقصى مسافة {args.max_dist})...")
            r_res = await mgr.search_best_ruins(max_distance=args.max_dist)
            if args.json:
                print(json.dumps(r_res, ensure_ascii=False, indent=2))
            else:
                print("\n" + "=" * 66)
                if r_res.get("success"):
                    t = r_res["target"]
                    print(f"  ✅ تم العثور على أطلال متاحة:")
                    print(f"    • الإحداثيات : ({t['x']}, {t['y']}) | المسافة: {t['distance']}")
                    print(f"    • المعرّف    : {t['target_id']} | instance_id: {t['instance_id']}")
                else:
                    print(f"  ❌ {r_res.get('code', 'ERROR')}: {r_res.get('message', '')}")
                print("=" * 66 + "\n")
            return 0 if r_res.get("success") else 1

            
        any_explicit = (
            args.available_heroes
            or args.available_soldiers
            or args.status
            or args.transport_capacity
            or args.treasure_escort
            or args.relics_explore
            or args.daily_tasks
            or (args.formation > 0)
        )
        _print_cli_report(
            mgr,
            label=f"{lord_name} | {account.email}",
            show_status=args.status or (not any_explicit),
            show_heroes=args.available_heroes or (not any_explicit),
            show_soldiers=args.available_soldiers or (not any_explicit),
            show_transport=args.transport_capacity or (not any_explicit),
            show_escort=args.treasure_escort or (not any_explicit),
            show_relics=args.relics_explore or (not any_explicit),
            show_daily_tasks=args.daily_tasks or (not any_explicit),
            exclude_defend=args.exclude_defend,
            as_json=args.json,
            formation_index=args.formation,
        )
        return 0
    finally:
        await conn.close()


def _main() -> None:
    if sys.platform == "win32":
        try:
            sys.stdout.reconfigure(encoding="utf-8", errors="replace")
            sys.stderr.reconfigure(encoding="utf-8", errors="replace")
        except Exception:
            pass
        asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())

    parser = argparse.ArgumentParser(
        description="اختبار دوال مدير المسيرات (الفيالق، الأبطال المتاحين، الجنود المتاحين) مباشرة من التيرمنال."
    )
    parser.add_argument("--email", type=str, default="", help="إيميل الحساب للاتصال الفعلي بالقلعة")
    parser.add_argument("--password", "-p", type=str, default="", help="كلمة المرور (اختياري)")
    parser.add_argument("--file", "-f", type=str, default="", help="مسار ملف JSON محلي للذاكرة الحية")
    parser.add_argument("--status", action="store_true", help="عرض ملخص حالة الفيالق والمسيرات النشطة")
    parser.add_argument("--available-heroes", action="store_true", help="عرض الأبطال المتاحين للإرسال")
    parser.add_argument("--exclude-defend", action="store_true", help="استبعاد أبطال الدفاع من قائمة الأبطال")
    parser.add_argument("--available-soldiers", action="store_true", help="عرض الجنود المتاحين بدون حصن الحرب")
    parser.add_argument("--transport-capacity", action="store_true", help="عرض سعة نقل مساعدة الموارد")
    parser.add_argument("--formation", type=int, default=0, help="عرض التشكيلة المحفوظة رقم N (مثال: --formation 1)")
    parser.add_argument("--treasure-escort", action="store_true", help="فحص وجود مسيرة حراسة الكنز نشطة (True/False)")
    parser.add_argument("--relics-explore", action="store_true", help="فحص وجود مسيرة استكشاف أطلال نشطة (True/False)")
    parser.add_argument("--daily-tasks", action="store_true", help="فحص حالة مهام النشاط اليومي الخمس ومسيراتها النشطة")
    parser.add_argument("--search-resource", type=str, default="", help="البحث عن مورد (مثال: food / wood / iron / silver / gold أو 2)")
    parser.add_argument("--res-level", type=int, default=6, help="مستوى المورد المطلوب للبحث (الافتراضي 6)")
    parser.add_argument("--search-monster", action="store_true", help="البحث عن أقرب وحش متاح")
    parser.add_argument("--monster-level", type=int, default=15, help="مستوى الوحش المطلوب (افتراضي: 15)")
    parser.add_argument("--monster-type", type=str, default="normal", help="نوع الوحش: normal (وحوش عادية) أو nebula (وحوش معركة السحاب)")
    parser.add_argument("--search-ruins", action="store_true", help="البحث عن أقرب أطلال متاحة بدون أمير فيها")
    parser.add_argument("--max-dist", type=float, default=120.0, help="أقصى مسافة للبحث عن المورد (الافتراضي 120)")
    parser.add_argument("--json", action="store_true", help="طباعة النتيجة بصيغة JSON")
    args = parser.parse_args()

    if args.email:
        sys.exit(asyncio.run(_run_cli_live(args)))
    elif args.file:
        with open(args.file, "r", encoding="utf-8") as fh:
            mem_data = json.load(fh)

        class _LocalConn:
            is_connected = True

            def __init__(self, data: Dict[str, Any]):
                self.init_data = data
                self.memory_engine = None
                self.uid = str(((data.get("lordInfoCtrl") or {}).get("base") or {}).get("uid") or "")

        mgr = MarchManagerTask(_LocalConn(mem_data))
        any_explicit = (
            args.available_heroes
            or args.available_soldiers
            or args.status
            or args.transport_capacity
            or args.treasure_escort
            or args.relics_explore
            or args.daily_tasks
            or (args.formation > 0)
        )
        _print_cli_report(
            mgr,
            label=os.path.basename(args.file),
            show_status=args.status or (not any_explicit),
            show_heroes=args.available_heroes or (not any_explicit),
            show_soldiers=args.available_soldiers or (not any_explicit),
            show_transport=args.transport_capacity or (not any_explicit),
            show_escort=args.treasure_escort or (not any_explicit),
            show_relics=args.relics_explore or (not any_explicit),
            show_daily_tasks=args.daily_tasks or (not any_explicit),
            exclude_defend=args.exclude_defend,
            as_json=args.json,
            formation_index=args.formation,
        )
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    _main()