# -*- coding: utf-8 -*-
"""
python tasks/march_manager.py --email beetoo2@hotmail.com --formation 3
"""
from __future__ import annotations

import argparse
import math
import asyncio
import json
import logging
import os
import sys
import time
from typing import Any, Callable, Dict, Iterator, List, Optional, Set, Tuple, Type

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

    async def run(self) -> TaskResult:
        """
        التنفيذ الرئيسي لمدير المسيرات والفيالق:
        1. بدء قياس الزمن الكلي لدورة المدير (سقف أقصى 20 دقيقة أو حسب الإعدادات).
        2. فحص سعة الفيالق والمسيرات الحية (0-Network).
        3. تشغيل المهام الفرعية المسجلة تلو الأخرى مع عزل الأخطاء ومراقبة السقف الزمني.
        4. الخروج الفوري عند اكتمال المهام أو بلوغ الحد الزمني.
        """
        start_time = time.monotonic()
        max_duration = self.max_duration_seconds
        max_minutes = self.max_duration_minutes

        summary = self.get_march_status_summary()
        max_cap = summary["max_capacity"]
        active = summary["active_marches"]
        avail = summary["available_slots"]

        self.log(
            f"⚔️ [MarchManager] بدء دورة مدير المسيرات والفيالق "
            f"(الحد الأقصى للمدة: {max_minutes} دقيقة | سعة الفيالق: {max_cap} | "
            f"نشطة بالخارج: {active} | شاغرة حالياً: {avail})."
        )

        subtasks = self.get_registered_subtasks()
        executed_subtasks = 0
        successful_subtasks = 0

        if not subtasks:
            duration_spent = time.monotonic() - start_time
            msg = (
                f"محرك مدير المسيرات جاهز بكفاءة تامة (بانتظار ربط المهام الفرعية لاحقاً). "
                f"الفيالق: {avail}/{max_cap} متاحة."
            )
            self.log(f"ℹ️ [MarchManager] {msg} (استغرق الفحص: {duration_spent:.2f} ثانية).")
            return TaskResult.ok(msg)

        for subtask_cls in subtasks:
            elapsed = time.monotonic() - start_time
            if elapsed >= max_duration:
                self.log(
                    f"⏳ [MarchManager] بلغت المهمة الحد الأقصى للمدة المحددة "
                    f"({max_minutes} دقيقة) — الخروج فوراً وإنهاء الدورة."
                )
                break

            sub_name = getattr(subtask_cls, "name", subtask_cls.__name__)
            sub_alias = getattr(subtask_cls, "alias", "")
            sub_cfg = (
                self.config.get(sub_name)
                or (self.config.get(sub_alias) if sub_alias else None)
                or {}
            )

            try:
                self.log(f"▶️ [MarchManager] بدء تشغيل المهمة الفرعية: [{sub_name}]...")
                sub_instance = subtask_cls(self.conn, self.log, sub_cfg)
                res = await sub_instance.safe_execute()
                executed_subtasks += 1

                if res.success:
                    successful_subtasks += 1
                    self.log(f"✅ [MarchManager -> {sub_name}] اكتملت بنجاح: {res.message}")
                elif res.skipped:
                    self.log(f"⏭️ [MarchManager -> {sub_name}] تم التخطي: {res.message}")
                else:
                    self.log(f"⚠️ [MarchManager -> {sub_name}] لم تكتمل: {res.message}")

            except ConnectionCircuitBreakerError:
                self.log(f"⚡ [MarchManager] قاطع الاتصال: انقطاع الاتصال أثناء [{sub_name}] — إيقاف الدورة فوراً.")
                raise
            except Exception as e:
                if "ConcurrentLogin" in type(e).__name__:
                    raise
                self.log(f"❌ [MarchManager] خطأ غير متوقع في المهمة الفرعية [{sub_name}]: {e}")
            finally:
                sub_instance = None

        duration_spent = time.monotonic() - start_time
        final_msg = (
            f"اكتملت دورة مدير المسيرات بنجاح "
            f"(تم تنفيذ: {executed_subtasks} مهام فرعية | نجاح: {successful_subtasks} | "
            f"الزمن المستغرق: {duration_spent:.1f} ثانية من أصل {max_minutes} دقيقة)."
        )
        self.log(f"🏁 [MarchManager] {final_msg} — الخروج فوراً.")
        return TaskResult.ok(final_msg)


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
    exclude_defend: bool,
    as_json: bool,
    formation_index: int = 0
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

        await asyncio.sleep(0.5)
        mgr = MarchManagerTask(conn)
        lord_name = (
            ((conn.init_data.get("lordInfoCtrl") or {}).get("base") or {}).get("nickName")
            or account.email
        )
        any_explicit = (
            args.available_heroes
            or args.available_soldiers
            or args.status
            or args.transport_capacity
            or (args.formation > 0)
        )
        _print_cli_report(
            mgr,
            label=f"{lord_name} | {account.email}",
            show_status=args.status or (not any_explicit),
            show_heroes=args.available_heroes or (not any_explicit),
            show_soldiers=args.available_soldiers or (not any_explicit),
            show_transport=args.transport_capacity or (not any_explicit),
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
            or (args.formation > 0)
        )
        _print_cli_report(
            mgr,
            label=os.path.basename(args.file),
            show_status=args.status or (not any_explicit),
            show_heroes=args.available_heroes or (not any_explicit),
            show_soldiers=args.available_soldiers or (not any_explicit),
            show_transport=args.transport_capacity or (not any_explicit),
            exclude_defend=args.exclude_defend,
            as_json=args.json,
            formation_index=args.formation,
        )
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    _main()