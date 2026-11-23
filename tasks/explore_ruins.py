# -*- coding: utf-8 -*-
"""
مهمة استكشاف الأطلال (ExploreRuinsTask) — تعمل عبر MarchManagerTask وترث دواله بالكامل.

تتبع سورس كود اللعبة في game_file حرفياً:
  - الفحص المسبق (0-Network) يعتمد حصرياً على الدالة الجاهزة self.has_relics_explore_march()
    في MarchManagerTask (kingdomMapCtrl.lua:1156 & mapDef.lua:326, 384).
  - تعتمد حصرياً على التشكيلة المحفوظة التي يحددها المستخدم (get_saved_formation(formation_index)):
      * إذا كانت جميع جنود التشكيلة متوفرة في القلعة: تُعتمد التشكيلة كما هي حرفياً ولو كانت ضعيفة.
      * إذا كان هناك نقص في أي نوع جندي من التشكيلة: يُؤخذ المتاح منها ويُعوّض النقص
        بجنود متاحين من أقرب درجة كفاءة/مستوى بحيث تقارب القوة الإجمالية قوة التشكيلة الأصلية.
  - حساب سعة المسيرة القصوى يعتمد حصرياً على tasks/march_capacity.py (get_march_capacity /
    get_march_capacity_no_heroes) بدون أي استدعاء لـ base_task.py.
  - مدة الاستكشاف محددة من المستخدم بالقيم الأربع الرسمية (WorldMapRemainsPopPanel.lua:18-21):
      900 (15 دقيقة) | 3600 (1 ساعة) | 14400 (4 ساعات) | 28800 (8 ساعات).
  - الإرسال الرسمي عبر CMD 1007/2 بـ moveLineType=4 (moveLineTypeRelicsExplore)،
    matrixType=1 (moveLineMatrixTypeTroop)، و data.data={"exploreTime": explore_time}
    (worldMapFunction.lua:308-310, WorldMapRemainsPopPanel.lua:67, kingdomMapTest.lua:7-19).

أمثلة الاختبار المباشر من الطرفية:
  python tasks/explore_ruins.py --email beetoo3@hotmail.com --formation 1 --duration 4h --dry-run
  python tasks/explore_ruins.py --email beetoo3@hotmail.com --formation 1 --duration 14400
  python tasks/explore_ruins.py --email beetoo3@hotmail.com --formation 2 --duration 8h
"""
from __future__ import annotations

import argparse
import asyncio
import json
import math
import os
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from tasks.base_task import ConnectionCircuitBreakerError, TaskResult
from tasks.march_capacity import get_march_capacity, get_march_capacity_no_heroes
from tasks.march_manager import MarchManagerTask

# ---------------------------------------------------------------------------
# ثوابت بروتوكول استكشاف الأطلال الرسمية (mapDef.lua, WorldMapRemainsPopPanel.lua)
# ---------------------------------------------------------------------------
RELICS_MOVE_LINE_TYPE = 4       # gMapMoveLineType.moveLineTypeRelicsExplore (mapDef.lua:384)
RELICS_MATRIX_TYPE = 1          # gMapMoveLineMatrixType.moveLineMatrixTypeTroop (mapDef.lua:411)
RELICS_MAP_OBJ_TYPE = 7         # gMapObjTypeDef.mapObjTypeRelics (mapDef.lua:11)

# مدد الاستكشاف الرسمية بالثواني (WorldMapRemainsPopPanel.lua:18-21)
OFFICIAL_EXPLORE_DURATIONS: Tuple[int, ...] = (900, 3600, 14400, 28800)

DURATION_ALIASES: Dict[str, int] = {
    "900": 900, "15m": 900, "15min": 900, "15": 900, "15د": 900,
    "3600": 3600, "1h": 3600, "60m": 3600, "1": 3600, "1س": 3600,
    "14400": 14400, "4h": 14400, "240m": 14400, "4": 14400, "4س": 14400,
    "28800": 28800, "8h": 28800, "480m": 28800, "8": 28800, "8س": 28800,
}

DURATION_LABELS_AR: Dict[int, str] = {
    900: "15 دقيقة",
    3600: "1 ساعة",
    14400: "4 ساعات",
    28800: "8 ساعات",
}

DEFAULT_MAX_DISTANCE = 120.0
DEFAULT_MIN_SUBSTITUTION_POWER_RATIO = 0.85
LEFTIME_SAFETY_BUFFER_SEC = 180  # هامش أمان 3 دقائق قبل اختفاء الأطلال


class ExploreRuinsTask(MarchManagerTask):
    """
    مهمة استكشاف الأطلال باستخدام التشكيلة المحددة من المستخدم فقط مع تعويض النقص بنفس الكفاءة والقوة.
    """

    name: str = "explore_ruins"
    alias: str = "ruins"

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
        self.name = "explore_ruins"

    # ------------------------------------------------------------------
    # أدوات مساعدة داخلية (0-Network)
    # ------------------------------------------------------------------

    @staticmethod
    def _safe_int(val: Any, default: int = 0) -> int:
        try:
            if val is None or isinstance(val, bool):
                return default
            return int(float(val))
        except Exception:
            return default

    @staticmethod
    def _extract_err_code(resp: Any) -> str:
        if not isinstance(resp, dict):
            return "NO_RESPONSE"
        err = resp.get("err")
        if err is None:
            err = resp.get("code")
        if err is None or str(err).strip() in ("0", "", "None", "Err_None"):
            return "0"
        return str(err).strip()

    @classmethod
    def _parse_explore_duration(cls, raw: Any) -> Optional[int]:
        """تحويل مدة الاستكشاف المحددة من المستخدم إلى إحدى القيم الأربع الرسمية بالثواني."""
        if raw is None or isinstance(raw, bool):
            return None
        key = str(raw).strip().lower().replace(" ", "")
        if key in DURATION_ALIASES:
            return DURATION_ALIASES[key]
        iv = cls._safe_int(raw, 0)
        if iv in OFFICIAL_EXPLORE_DURATIONS:
            return iv
        return None

    def _get_formation_index(self) -> int:
        raw = self.config.get("formation_index", self.config.get("formation", 0))
        return self._safe_int(raw, 0)

    def _get_requested_duration(self) -> Optional[int]:
        raw = self.config.get("explore_time", self.config.get("duration"))
        return self._parse_explore_duration(raw)

    def _get_live_capacity_for_heroes(
        self,
        hero_ids: List[int],
        lieutenant_map: Dict[int, int],
    ) -> int:
        """حساب سعة الفيلق القصوى حصرياً عبر tasks/march_capacity.py (0-Network)."""
        live_mem = self._get_live_snapshot()
        cap = self._safe_int(
            get_march_capacity(
                live_mem,
                hero_ids=hero_ids or None,
                lieutenant_map=lieutenant_map or None,
                only_normal_state=False,
            ),
            0,
        )
        if cap <= 0:
            cap = self._safe_int(get_march_capacity_no_heroes(live_mem), 0)
        return max(0, cap)

    # ------------------------------------------------------------------
    # الفحص المسبق (0-Network)
    # ------------------------------------------------------------------

    async def can_run(self) -> Tuple[bool, str]:
        if not self.is_active:
            return False, "مهمة استكشاف الأطلال معطلة في الإعدادات."

        # 1) الفحص الحصري عبر الدالة الجاهزة في MarchManagerTask
        if self.has_relics_explore_march():
            return False, "يوجد بالفعل فيلق استكشاف أطلال نشط حالياً — لا يمكن إرسال فيلق آخر."

        # 2) التحقق من تحديد مدة الاستكشاف من المستخدم بشكل صحيح
        explore_time = self._get_requested_duration()
        if explore_time is None:
            return (
                False,
                "يجب تحديد مدة استكشاف الأطلال الرسمية من المستخدم: 900 (15m) أو 3600 (1h) أو 14400 (4h) أو 28800 (8h).",
            )

        # 3) التحقق من رقم التشكيلة ووجودها في اللعبة
        f_idx = self._get_formation_index()
        if f_idx <= 0:
            return False, "يجب تحديد رقم التشكيلة المحفوظة (formation_index / --formation) لاستكشاف الأطلال."

        saved = self.get_saved_formation(f_idx)
        if not saved.get("is_configured") or not saved.get("soldiers"):
            return False, f"التشكيلة المحفوظة #{f_idx} فارغة أو غير مهيأة داخل اللعبة."

        # 4) التحقق من توفر فيلق شاغر وجنود متاحين
        if not self.has_available_march(require_soldiers=True):
            return False, "لا يوجد فيلق شاغر أو جنود متاحون لإرسال مسيرة استكشاف الأطلال."

        return True, "جاهز لتنفيذ مهمة استكشاف الأطلال."

    # ------------------------------------------------------------------
    # تجهيز التشكيلة المحددة + التعويض الذكي بنفس الكفاءة والقوة عند النقص
    # ------------------------------------------------------------------

    def build_ruins_formation_from_saved(
        self,
        formation_index: int,
        min_substitution_power_ratio: float = DEFAULT_MIN_SUBSTITUTION_POWER_RATIO,
    ) -> Dict[str, Any]:
        """
        بناء فيلق استكشاف الأطلال من التشكيلة المحفوظة المحددة فقط:
          1. إذا توفرت كافة جنود التشكيلة في القلعة: تُعتمد التشكيلة كما هي حرفياً ولو كانت ضعيفة.
          2. إذا كان هناك نقص في جنود التشكيلة: يُؤخذ المتاح منها ثم يُعوّض النقص بجنود متاحين
             من أقرب درجة كفاءة/مستوى (نفس الرتبة أولاً ثم الأقرب، مع تفضيل نفس الفرع)
             بحيث تقارب القوة الإجمالية قوة التشكيلة الأصلية دون تجاوز سعة march_capacity.py.
        """
        saved = self.get_saved_formation(formation_index)
        if not saved.get("is_configured") or not saved.get("soldiers"):
            return {
                "ok": False,
                "code": "FORMATION_NOT_CONFIGURED",
                "reason": f"التشكيلة المحفوظة #{formation_index} فارغة أو غير مهيأة في اللعبة.",
            }

        saved_soldiers: Dict[int, int] = {
            int(aid): int(cnt)
            for aid, cnt in saved["soldiers"].items()
            if int(cnt) > 0
        }
        if not saved_soldiers:
            return {
                "ok": False,
                "code": "FORMATION_EMPTY",
                "reason": f"التشكيلة المحفوظة #{formation_index} لا تحتوي على جنود صالحين.",
            }

        # 1) تصفية الأبطال (الرئيسيين والمساعدين) من التشكيلة بحيث نرسل المتاحين حالياً فقط
        avail_hero_ids_set: Set[int] = set(self.get_available_hero_ids(exclude_defend=False))
        selected_heroes: List[int] = []
        active_lieutenants: Dict[int, int] = {}
        saved_lt_map: Dict[int, int] = saved.get("lieutenant_map") or {}

        for hid in saved.get("hero_ids") or []:
            h_int = self._safe_int(hid, 0)
            if h_int > 0 and h_int in avail_hero_ids_set and h_int not in selected_heroes:
                selected_heroes.append(h_int)
                slave_id = self._safe_int(saved_lt_map.get(h_int), 0)
                if slave_id > 0 and slave_id in avail_hero_ids_set and slave_id != h_int:
                    active_lieutenants[h_int] = slave_id

        # 2) حساب السعة القصوى الحية حصرياً عبر tasks/march_capacity.py
        max_cap = self._get_live_capacity_for_heroes(selected_heroes, active_lieutenants)
        if max_cap <= 0:
            return {
                "ok": False,
                "code": "INVALID_CAPACITY",
                "reason": "تعذر حساب سعة المسيرة القصوى من tasks/march_capacity.py.",
            }

        # 3) قراءة الجنود المتاحين حالياً بالقلعة (بدون فخاخ حصن الحرب)
        avail_soldiers_list = self.get_available_soldiers()
        if not avail_soldiers_list:
            return {
                "ok": False,
                "code": "NO_SOLDIERS_AVAILABLE",
                "reason": "لا يوجد جنود متاحون داخل القلعة حالياً.",
            }

        avail_pool: Dict[int, Dict[str, Any]] = {}
        for s in avail_soldiers_list:
            aid = self._safe_int(s.get("army_id") or s.get("id"), 0)
            cnt = self._safe_int(s.get("count"), 0)
            if aid <= 0 or cnt <= 0:
                continue
            _base_id, branch_code, view_lv, _enh = self._parse_soldier_meta(aid)
            tier = max(1, int(view_lv))
            unit_pwr = self._get_soldier_combat_power(aid, tier)
            avail_pool[aid] = {
                "army_id": aid,
                "count": cnt,
                "remaining": cnt,
                "tier": tier,
                "view_level": view_lv,
                "branch_code": branch_code,
                "unit_power": unit_pwr,
            }

        # 4) حساب القوة المستهدفة للتشكيلة الأصلية وفحص هل كلها متوفرة بالقلعة
        target_power = 0.0
        target_total_soldiers = 0
        chosen: Dict[int, int] = {}
        shortfalls: List[Dict[str, Any]] = []
        used_soldiers = 0
        achieved_power = 0.0

        # ترتيب بنود التشكيلة (الأعلى مستوى أولاً لتأمينها لو ضاقت السعة)
        saved_entries: List[Tuple[int, int, int, int, float]] = []
        for aid, req_cnt in saved_soldiers.items():
            _base_id, branch_code, view_lv, _enh = self._parse_soldier_meta(aid)
            tier = max(1, int(view_lv))
            unit_pwr = self._get_soldier_combat_power(aid, tier)
            saved_entries.append((aid, req_cnt, tier, branch_code, unit_pwr))
            target_power += req_cnt * unit_pwr
            target_total_soldiers += req_cnt

        saved_entries.sort(key=lambda x: (-x[2], x[0]))

        all_exact_available = True
        for aid, req_cnt, tier, branch_code, unit_pwr in saved_entries:
            slot_room = max(0, max_cap - used_soldiers)
            effective_req = min(req_cnt, slot_room)
            have = avail_pool[aid]["remaining"] if aid in avail_pool else 0
            take = min(have, effective_req)

            if take > 0:
                chosen[aid] = chosen.get(aid, 0) + take
                avail_pool[aid]["remaining"] -= take
                used_soldiers += take
                achieved_power += take * unit_pwr

            if take < effective_req:
                all_exact_available = False
                missing_cnt = effective_req - take
                shortfalls.append({
                    "army_id": aid,
                    "missing_count": missing_cnt,
                    "tier": tier,
                    "branch_code": branch_code,
                    "unit_power": unit_pwr,
                    "missing_power": missing_cnt * unit_pwr,
                })

        substitutions: List[Dict[str, Any]] = []

        # 5) حالة وجود نقص فقط: نعوّض النقص بجنود من أقرب درجة كفاءة/مستوى لتقارب قوة التشكيلة
        if not all_exact_available and shortfalls:
            for sf in shortfalls:
                rem_power_needed = float(sf["missing_power"])
                sf_tier = int(sf["tier"])
                sf_branch = int(sf["branch_code"])

                while rem_power_needed > 1e-6 and used_soldiers < max_cap:
                    candidates = [
                        item for item in avail_pool.values()
                        if item["remaining"] > 0 and item["unit_power"] > 0
                    ]
                    if not candidates:
                        break

                    # أقرب درجة كفاءة (|tier - sf_tier|) أولاً، ثم نفس الفرع، ثم الكفاءة الأعلى، ثم الأصغر ID
                    candidates.sort(
                        key=lambda c: (
                            abs(c["tier"] - sf_tier),
                            0 if c["branch_code"] == sf_branch else 1,
                            0 if c["tier"] >= sf_tier else 1,
                            -c["unit_power"],
                            c["army_id"],
                        )
                    )

                    best = candidates[0]
                    slot_room = max_cap - used_soldiers
                    needed_units = int(math.ceil(rem_power_needed / best["unit_power"]))
                    take = min(best["remaining"], slot_room, max(1, needed_units))
                    if take <= 0:
                        break

                    best["remaining"] -= take
                    chosen[best["army_id"]] = chosen.get(best["army_id"], 0) + take
                    gained_pwr = take * best["unit_power"]
                    used_soldiers += take
                    achieved_power += gained_pwr
                    rem_power_needed -= gained_pwr

                    substitutions.append({
                        "for_army_id": sf["army_id"],
                        "for_tier": sf_tier,
                        "sub_army_id": best["army_id"],
                        "sub_tier": best["tier"],
                        "count": take,
                        "power_added": round(gained_pwr, 1),
                    })

        if not chosen or used_soldiers <= 0:
            return {
                "ok": False,
                "code": "NO_SOLDIERS_FOR_FORMATION",
                "reason": "تعذر تشكيل أي جندي لإرسال مسيرة استكشاف الأطلال.",
            }

        power_ratio = (achieved_power / target_power) if target_power > 0 else 1.0

        # لا نرفض التشكيلة أبداً إذا كانت متوفرة بالكامل (حتى لو كانت ضعيفة)؛
        # نفحص عتبة القوة المكافئة فقط في حالة حدوث نقص وتعويض
        if (not all_exact_available) and min_substitution_power_ratio > 0 and power_ratio < min_substitution_power_ratio:
            return {
                "ok": False,
                "code": "INSUFFICIENT_SUBSTITUTION_POWER",
                "reason": (
                    f"تعذر تعويض النقص في التشكيلة #{formation_index} بقوة مقاربة: "
                    f"القوة المحققة {achieved_power:,.0f} من أصل {target_power:,.0f} "
                    f"({power_ratio * 100:.1f}% < الحد الأدنى {min_substitution_power_ratio * 100:.0f}%)."
                ),
                "target_power": round(target_power, 1),
                "achieved_power": round(achieved_power, 1),
                "power_ratio": round(power_ratio, 3),
            }

        army_payload = [{"id": int(aid), "num": int(cnt)} for aid, cnt in chosen.items() if cnt > 0]
        hero_payload: List[Dict[str, int]] = []
        for hid in selected_heroes:
            entry: Dict[str, int] = {"heroID": hid}
            if hid in active_lieutenants:
                entry["slaveHeroID"] = active_lieutenants[hid]
            hero_payload.append(entry)

        # استبعاد أي سلاح أو وحش إلهي منشغل حالياً في مسيرة أخرى (WorldDispatchArmyViewPanel.lua:1386-1391)
        busy_arms: Set[int] = set()
        busy_beasts: Set[int] = set()
        for q, _st in self._iter_my_active_queues():
            for box in (q, q.get("from") if isinstance(q.get("from"), dict) else {}):
                for a in (box.get("armsInfo") or []):
                    aid_v = self._safe_int(a.get("id") if isinstance(a, dict) else a, 0)
                    if aid_v > 0:
                        busy_arms.add(aid_v)
                for b in (box.get("divineBeastInfo") or []):
                    bid_v = self._safe_int(b.get("id") if isinstance(b, dict) else b, 0)
                    if bid_v > 0:
                        busy_beasts.add(bid_v)

        safe_arms_ids = [
            int(a) for a in (saved.get("arms_ids") or [])
            if self._safe_int(a, 0) > 0 and int(a) not in busy_arms
        ]
        safe_beast_ids = [
            int(b) for b in (saved.get("divine_beast_ids") or [])
            if self._safe_int(b, 0) > 0 and int(b) not in busy_beasts
        ]

        return {
            "ok": True,
            "formation_index": formation_index,
            "formation_name": saved.get("name", f"التشكيلة {formation_index}"),
            "used_exact_saved": all_exact_available,
            "army_payload": army_payload,
            "hero_payload": hero_payload,
            "hero_ids": selected_heroes,
            "lieutenant_map": active_lieutenants,
            "arms_ids": safe_arms_ids,
            "divine_beast_ids": safe_beast_ids,
            "total_soldiers": used_soldiers,
            "target_total_soldiers": target_total_soldiers,
            "max_capacity": max_cap,
            "target_power": round(target_power, 1),
            "achieved_power": round(achieved_power, 1),
            "power_ratio": round(power_ratio, 3),
            "substitutions": substitutions,
        }

    # ------------------------------------------------------------------
    # التحقق من عمر الأطلال المتبقي عبر CMD 1006/15 (WorldMapRemainsPopPanel.lua:52-59)
    # ------------------------------------------------------------------

    async def _check_ruins_remaining_lifetime(
        self,
        target: Dict[str, Any],
        explore_time: int,
    ) -> Tuple[bool, Optional[int], str]:
        """
        التحقق عبر CMD 1006/15 من أن عمر الأطلال المتبقي (leftime) يكفي لمدة الاستكشاف المحددة.
        إذا لم يُرجع السيرفر حقل وقت اختفاء صريح، نسمح بالمتابعة دون تعطيل خاطئ.
        """
        tx = self._safe_int(target.get("x"), -1)
        ty = self._safe_int(target.get("y"), -1)
        inst_id = str(target.get("instance_id") or "").strip()
        kid = self._safe_int(target.get("kingdom_id"), self.kingdom_id)
        if tx < 0 or ty < 0 or not inst_id:
            return False, None, "بيانات إحداثيات أو معرف الأطلال غير صالحة."

        # استخدام رد 1006/15 الراجع أصلاً من search_best_ruins لتجنب تكرار الطلب الشبكي
        info_resp = target.get("info_resp")
        if not isinstance(info_resp, dict):
            info_resp = await self.safe_query(
                "1006",
                "15",
                {"x": tx, "y": ty, "id": inst_id, "kingdomId": kid},
                min_delay=0.25,
                max_delay=0.55,
            )
        if not isinstance(info_resp, dict) or self._extract_err_code(info_resp) != "0":
            return True, None, "تعذر قراءة عمر الأطلال من 1006/15؛ سيتم الاعتماد على تحقق السيرفر عند الإرسال."

        ret_data: Dict[str, Any] = {}
        for k in ("retData", "result", "rspdata", "data"):
            v = info_resp.get(k)
            if isinstance(v, dict):
                ret_data = v
                break
        if not ret_data:
            ret_data = info_resp

        blocks = [ret_data]
        for sub_k in ("relic", "relics", "remains", "explore"):
            sv = ret_data.get(sub_k)
            if isinstance(sv, dict):
                blocks.append(sv)

        now_ts = time.time()
        left_sec: Optional[int] = None
        for blk in blocks:
            for key in ("leftime", "leftTime", "remainTime", "disappearLeftTime"):
                if key in blk and blk[key] is not None:
                    val = self._safe_int(blk[key], -1)
                    if val >= 0:
                        left_sec = val
                        break
            if left_sec is not None:
                break
            for end_key in ("disappearTime", "endTime", "expireTime", "removeTime"):
                if end_key in blk and blk[end_key] is not None:
                    ev = self._safe_int(blk[end_key], 0)
                    if ev > 10**11:
                        ev //= 1000
                    if ev > 0:
                        left_sec = max(0, int(ev - now_ts))
                        break
            if left_sec is not None:
                break

        if left_sec is None:
            return True, None, "لم يتضمن رد 1006/15 حقل وقت اختفاء صريح."

        # تقدير وقت الذهاب + مدة الاستكشاف + هامش أمان 3 دقائق
        timing_est = self.estimate_march_duration(
            march_type="ruins",
            target_x=tx,
            target_y=ty,
            distance=target.get("distance"),
            work_seconds=explore_time,
        )
        needed_sec = int(math.ceil(timing_est["go_seconds"])) + explore_time + LEFTIME_SAFETY_BUFFER_SEC
        if left_sec < needed_sec:
            return (
                False,
                left_sec,
                f"العمر المتبقي للأطلال ({self._format_duration_hms(left_sec)}) أقل من المطلوب للاستكشاف "
                f"({self._format_duration_hms(needed_sec)}).",
            )

        return True, left_sec, f"العمر المتبقي للأطلال كافٍ ({self._format_duration_hms(left_sec)})."

    # ------------------------------------------------------------------
    # التنفيذ الرئيسي (فيلق واحد فقط بالتشكيلة المحددة ومدة المستخدم)
    # ------------------------------------------------------------------

    async def run(self) -> TaskResult:
        dry_run = bool(self.config.get("dry_run", False))
        max_distance = max(10.0, float(self.config.get("max_distance", DEFAULT_MAX_DISTANCE)))
        min_sub_ratio = max(
            0.0,
            min(1.0, float(self.config.get("min_power_ratio", DEFAULT_MIN_SUBSTITUTION_POWER_RATIO))),
        )
        max_dispatch_retries = max(1, self._safe_int(self.config.get("max_retries", 2), 2))

        # 1) الفحص المسبق الصارم (يعتمد حصرياً على has_relics_explore_march)
        ok_pre, pre_reason = await self.can_run()
        if not ok_pre:
            self.log(f"⏭️ [استكشاف الأطلال] {pre_reason}")
            return TaskResult(success=False, skipped=True, message=pre_reason)

        formation_index = self._get_formation_index()
        explore_time = self._get_requested_duration()
        assert explore_time is not None
        dur_label = DURATION_LABELS_AR.get(explore_time, f"{explore_time}ث")

        self.log(
            f"🏛️ [استكشاف الأطلال] بدء المهمة | التشكيلة: #{formation_index} | "
            f"المدة المحددة: {dur_label} ({explore_time}ث) | "
            f"الفيالق الشاغرة: {self.get_available_marches_count()}"
        )

        # 2) تجهيز التشكيلة المحددة (0-Network) مع التعويض الذكي فقط عند وجود نقص
        formation = self.build_ruins_formation_from_saved(
            formation_index=formation_index,
            min_substitution_power_ratio=min_sub_ratio,
        )
        if not formation.get("ok"):
            msg = str(formation.get("reason") or "تعذر تجهيز التشكيلة المحددة لاستكشاف الأطلال.")
            self.log(f"⏭️ [استكشاف الأطلال] {msg}")
            return TaskResult(success=False, skipped=True, message=msg, data=formation)

        if formation["used_exact_saved"]:
            self.log(
                f"✅ [استكشاف الأطلال] التشكيلة '{formation['formation_name']}' (#{formation_index}) متوفرة بالكامل — "
                f"اعتمادها كما هي: {formation['total_soldiers']:,}/{formation['max_capacity']:,} جندي | "
                f"أبطال: {formation['hero_ids']} | القوة: {formation['achieved_power']:,.0f}"
            )
        else:
            self.log(
                f"🔁 [استكشاف الأطلال] وجود نقص في التشكيلة #{formation_index} — تم التعويض بجنود مقاربين في الكفاءة: "
                f"{formation['total_soldiers']:,}/{formation['max_capacity']:,} جندي | "
                f"القوة: {formation['achieved_power']:,.0f} / {formation['target_power']:,.0f} "
                f"({formation['power_ratio'] * 100:.1f}%) | بدائل: {len(formation['substitutions'])}"
            )

        # 3) البحث عن أطلال متاحة والتحقق من عمرها المتبقي والإرسال (مع إعادة محاولة محدودة)
        rejected_coords: Set[Tuple[int, int]] = set()
        last_error_msg = "لم يتم العثور على أطلال مناسبة."

        for attempt in range(1, max_dispatch_retries + 1):
            # إعادة فحص لحظية عبر الدالة الجاهزة فقط قبل كل محاولة
            if self.has_relics_explore_march():
                msg = "تم رصد فيلق استكشاف أطلال نشط قبل الإرسال — تم الإلغاء لتجنب الازدواج."
                self.log(f"⏭️ [استكشاف الأطلال] {msg}")
                return TaskResult(success=False, skipped=True, message=msg)

            search_res = await self.search_best_ruins(
                max_distance=max_distance,
                skip_coords=rejected_coords or None,
            )
            if not isinstance(search_res, dict) or not search_res.get("success") or not search_res.get("target"):
                last_error_msg = (
                    search_res.get("message")
                    if isinstance(search_res, dict) and search_res.get("message")
                    else "لم يتم العثور على أطلال متاحة ضمن المسافة المحددة."
                )
                break

            target = search_res["target"]
            tx = self._safe_int(target.get("x"), -1)
            ty = self._safe_int(target.get("y"), -1)
            inst_id = str(target.get("instance_id") or "").strip()
            if tx < 0 or ty < 0 or not inst_id:
                last_error_msg = "بيانات الأطلال الراجعة من البحث غير مكتملة."
                continue

            if (tx, ty) in rejected_coords:
                last_error_msg = f"لم تُرصد أطلال أخرى متاحة غير ({tx}, {ty})."
                break

            # فحص عمر الأطلال المتبقي مقابل مدة الاستكشاف المحددة من المستخدم
            ok_life, left_sec, life_msg = await self._check_ruins_remaining_lifetime(target, explore_time)
            if not ok_life:
                self.log(f"⏳ [استكشاف الأطلال] تخطي ({tx}, {ty}): {life_msg}")
                rejected_coords.add((tx, ty))
                last_error_msg = life_msg
                continue

            if dry_run:
                msg = (
                    f"[DRY-RUN] جاهز لإرسال فيلق استكشاف الأطلال إلى ({tx}, {ty}) "
                    f"| التشكيلة: #{formation_index} ({'كاملة كما هي' if formation['used_exact_saved'] else 'مع تعويض'}) "
                    f"| المدة: {dur_label} ({explore_time}ث) "
                    f"| جنود: {formation['total_soldiers']:,}/{formation['max_capacity']:,} "
                    f"| أبطال: {formation['hero_ids']} "
                    f"| القوة: {formation['achieved_power']:,.0f}/{formation['target_power']:,.0f}"
                )
                self.log(f"🧪 [استكشاف الأطلال] {msg}")
                return TaskResult(
                    success=True,
                    message=msg,
                    data={
                        "dry_run": True,
                        "target": target,
                        "explore_time": explore_time,
                        "left_seconds": left_sec,
                        "formation": formation,
                    },
                )

            # 4) الإرسال الرسمي عبر CMD 1007/2
            _, _, kingdom_id = self._get_castle_coords_and_kingdom()
            payload = {
                "moveLineType": RELICS_MOVE_LINE_TYPE,
                "matrixType": RELICS_MATRIX_TYPE,
                "data": {
                    "to": {
                        "x": tx,
                        "y": ty,
                        "id": inst_id,
                    },
                    "army": formation["army_payload"],
                    "heroInfo": formation["hero_payload"],
                    "armsInfo": formation["arms_ids"],
                    "divineBeastInfo": formation["divine_beast_ids"],
                    "mapId": int(kingdom_id),
                    "isDuel": False,
                    "isForbidSpeed": False,
                    "data": {
                        "exploreTime": explore_time,
                    },
                },
            }

            await asyncio.sleep(random.uniform(0.35, 0.75))
            self.log(
                f"🚀 [استكشاف الأطلال] إرسال {formation['total_soldiers']:,} جندي "
                f"(أبطال: {formation['hero_ids']}) لاستكشاف الأطلال ({tx}, {ty}) لمدة {dur_label}..."
            )
            resp = await self.safe_query("1007", "2", payload, min_delay=0.5, max_delay=1.1)
            err = self._extract_err_code(resp)
            if err == "0":
                timing = self.estimate_march_duration(
                    march_type="ruins",
                    dispatch_response=resp,
                    target_x=tx,
                    target_y=ty,
                    distance=target.get("distance"),
                    work_seconds=explore_time,
                )
                msg = (
                    f"تم إرسال فيلق استكشاف الأطلال بنجاح نحو ({tx}, {ty}) لمدة {dur_label} "
                    f"بـ {formation['total_soldiers']:,} جندي (الزمن الكلي المتوقع: {timing['total_formatted']})."
                )
                self.log(f"✅ [استكشاف الأطلال] {msg}")
                return TaskResult(
                    success=True,
                    message=msg,
                    data={
                        "target": target,
                        "explore_time": explore_time,
                        "formation": formation,
                        "timing": timing,
                    },
                )

            last_error_msg = f"رفض السيرفر إرسال مسيرة استكشاف الأطلال عند ({tx}, {ty}) (err={err})."
            self.log(f"⚠️ [استكشاف الأطلال] {last_error_msg}")
            rejected_coords.add((tx, ty))
            if attempt < max_dispatch_retries:
                await asyncio.sleep(random.uniform(1.2, 2.2))

        self.log(f"⏭️ [استكشاف الأطلال] {last_error_msg}")
        return TaskResult(
            success=False,
            skipped=True,
            message=last_error_msg,
            data={"formation_index": formation_index, "explore_time": explore_time},
        )


# ===========================================================================
# مشغّل الطرفية للاختبار المباشر (مطابق لـ hunt_monsters.py و escort_treasure.py)
# ===========================================================================

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
            prof = get_account_device_profile(email)
            auth_res = sdk_login(email, password, device_id=prof["deviceId"])
            if not auth_res.get("success"):
                print(f"[-] فشلت المصادقة: {auth_res.get('error_msg')}")
                return 1
            user_id = auth_res["userId"]
            session_id = auth_res["sessionId"]
            matched_email = email
            SessionCache.set_account(
                email, user_id, session_id,
                device_id=prof["deviceId"], model=prof["model"], os_version=prof["osVersion"],
            )
        else:
            print(f"[-] الحساب '{email}' غير موجود في session_cache.json؛ مرّر كلمة المرور عبر -p.")
            return 1

    account = AccountSession(
        email=matched_email or email,
        user_id=str(user_id),
        session_id=str(session_id),
        password=password,
    )
    creds = await async_login(account)
    if not creds:
        print("[-] فشلت المصادقة مع خادم تسجيل الدخول.")
        return 1

    conn = GameConnection(account, creds)
    try:
        if not await conn.connect():
            print("[-] فشل الاتصال ببوابة اللعبة.")
            return 1

        deadline = time.monotonic() + 20.0
        while time.monotonic() < deadline:
            if getattr(conn, "is_other_device", False) or getattr(conn, "is_sealed", False):
                return 1
            if conn.memory_engine.is_memory_ready()[0]:
                break
            await asyncio.sleep(0.15)

        sync_deadline = time.monotonic() + 5.0
        while time.monotonic() < sync_deadline:
            if getattr(conn.memory_engine, "local_queues_synced", False):
                break
            await asyncio.sleep(0.15)
        await asyncio.sleep(0.2)

        cfg = {
            "enabled": True,
            "formation_index": args.formation,
            "duration": args.duration,
            "max_distance": args.max_dist,
            "min_power_ratio": args.min_power_ratio,
            "dry_run": args.dry_run,
        }
        task = ExploreRuinsTask(conn, config=cfg)
        result = await task.safe_execute()

        print("\n" + "=" * 66)
        if args.json:
            print(json.dumps(result.to_dict(), ensure_ascii=False, indent=2))
        else:
            icon = "✅" if result.success else ("⏭️" if result.skipped else "❌")
            print(f"  {icon} {result.message}")
        print("=" * 66 + "\n")
        return 0 if (result.success or result.skipped) else 1
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

    parser = argparse.ArgumentParser(description="مهمة استكشاف الأطلال بالتشكيلة المحددة (ExploreRuinsTask).")
    parser.add_argument("--email", required=True, help="إيميل الحساب")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري إذا كانت في session_cache)")
    parser.add_argument("--formation", type=int, required=True, help="رقم التشكيلة المحفوظة في اللعبة (مثال: 1 أو 2 أو 3)")
    parser.add_argument(
        "--duration",
        required=True,
        help="مدة الاستكشاف المحددة من المستخدم: 15m/900 أو 1h/3600 أو 4h/14400 أو 8h/28800",
    )
    parser.add_argument("--max-dist", type=float, default=DEFAULT_MAX_DISTANCE, help="أقصى مسافة للبحث عن الأطلال (افتراضي 120)")
    parser.add_argument(
        "--min-power-ratio",
        type=float,
        default=DEFAULT_MIN_SUBSTITUTION_POWER_RATIO,
        help="الحد الأدنى لنسبة القوة عند تعويض النقص فقط (افتراضي 0.85)",
    )
    parser.add_argument("--dry-run", action="store_true", help="محاكاة الفحص والتشكيل والبحث بدون إرسال الفيلق فعلياً")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()