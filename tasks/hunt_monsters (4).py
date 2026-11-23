# -*- coding: utf-8 -*-
"""
مهمة صيد الوحوش العادية والسحابية (HuntMonstersTask) — تعمل عبر MarchManagerTask وترث دواله بالكامل.

تدعم وضعين للتشغيل (يُحددان عبر config["mode"] أو --mode في الطرفية):
  1. mode="daily_tasks" : إنجاز مهمة الهجوم على الوحوش في النشاط اليومي، بحيث يرسل البوت
     العدد المتبقي فقط لإكمال المهمة اليومية (مع خصم فيالق الوحوش النشطة بالخارج حالياً،
     والانتظار دقيقتين إذا كانت الفيالق الشاغرة أقل من العدد المتبقي لإكمال الباقي).
  2. mode="hunt"        : هجوم لا نهائي ذكي على الوحوش العادية (1..40) أو السحابية (41..50)،
     ينتظر دقيقتين (120ث) عند نفاد الفيالق أو نقص الجنود *فقط* إذا كان هناك فيلق وحوش نشط
     بالخارج، ويخرج فوراً في أي من الحالات التالية:
       - انتهاء مهلة مدير المسيرات الكلية (self.max_duration_seconds = 20 دقيقة افتراضياً).
       - انخفاض طاقة اللورد عن 10 (lordInfoCtrl["base"]["health"] // 100 < 10).
       - عدم العثور على وحش بالنوع والمستوى المحدد.
       - عجز القلعة عن القتل المؤكد (عتبة 1.5x) بسبب ضيق سعة الفيلق أو إغلاق المستوى.
       - نقص الجنود أو نفاد الفيالق مع عدم وجود أي فيلق وحوش نشط بالخارج.

أمثلة الاختبار المباشر من الطرفية:
  python tasks/hunt_monsters.py --email beetoo3@hotmail.com --mode daily_tasks --monster-type normal --level 11 --dry-run
  python tasks/hunt_monsters.py --email beetoo3@hotmail.com --mode daily_tasks --monster-type normal --level 11
  python tasks/hunt_monsters.py --email beetoo3@hotmail.com --mode hunt --monster-type normal --level 11
"""
from __future__ import annotations

import argparse
import asyncio
import inspect
import json
import os
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from tasks.base_task import ConnectionCircuitBreakerError, TaskResult
from tasks.march_manager import MarchManagerTask

# ---------------------------------------------------------------------------
# ثوابت بروتوكول الهجوم على الوحوش الرسمية (worldMapFunction.lua, mapDef.lua)
# ---------------------------------------------------------------------------
MONSTER_ATTACK_MOVE_LINE_TYPE = 1   # gMapMoveLineType.moveLineTypeAttackLord (worldMapFunction.lua:294)
MONSTER_ATTACK_MATRIX_TYPE = 1      # gMapMoveLineMatrixType.moveLineMatrixTypeTroop (mapDef.lua:411)
SERVER_QUEUE_TYPE_KILL_NPC = 1      # gMapMoveLineServerType.moveLineTypeKillNpc (mapDef.lua:322)

MAP_TYPE_NORMAL_NPC = 6             # gMapObjTypeDef.mapObjTypeNpc (mapDef.lua:10)
MAP_TYPE_NEBULA_NPC = 56            # gMapObjTypeDef.nebulaNpc (mapDef.lua:56)

DEFAULT_COMBAT_MIN_WIN_RATIO = 1.5  # عتبة القتل المؤكد الرسمية (المؤشر الأخضر في اللعبة)
MIN_LORD_ENERGY = 10                # الخروج الفوري إذا كانت طاقة اللورد أقل من 10
DEFAULT_WAIT_INTERVAL_SEC = 120.0   # انتظار دقيقتين عند انشغال فيالق الوحوش
MIN_REMAINING_TIME_FOR_WAIT_SEC = 15.0

DAILY_MONSTER_TASK_KEYS: Tuple[str, ...] = (
    "kill_monster",
    "attack_monster",
    "hunt_monster",
    "kill_monsters",
    "monster",
    "kill_npc",
)


def _format_hhmmss(seconds: int) -> str:
    secs = max(0, int(seconds))
    h, rem = divmod(secs, 3600)
    m, s = divmod(rem, 60)
    return f"{h:02d}:{m:02d}:{s:02d}"


class HuntMonstersTask(MarchManagerTask):
    """مهمة صيد الوحوش المستقلة (العادية والسحابية) وترث من MarchManagerTask."""

    name: str = "hunt_monsters"
    alias: str = "hunt"

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
        self.name = "hunt_monsters"

    # ------------------------------------------------------------------
    # أدوات مساعدة داخلية (0-Network)
    # ------------------------------------------------------------------

    @staticmethod
    def _safe_int(val: Any, default: int = 0) -> int:
        try:
            return int(float(val))
        except Exception:
            return default

    def _get_mode(self) -> str:
        raw = str(self.config.get("mode", "hunt")).strip().lower()
        if raw in ("daily", "daily_tasks", "daily_quest", "يومي", "النشاط_اليومي"):
            return "daily_tasks"
        return "hunt"

    def _get_monster_type(self) -> str:
        raw = str(self.config.get("monster_type", "normal")).strip().lower()
        if raw in ("nebula", "nebula_monster", "cloud", "سحابي", "سحابية"):
            return "nebula"
        return "normal"

    def _get_target_type_key(self, monster_type: str) -> str:
        return "nebula_monster" if monster_type == "nebula" else "monster"

    def get_lord_energy(self) -> Optional[int]:
        """قراءة طاقة اللورد الفعلية من الذاكرة (health مخزنة مضروبة في 100)."""
        snap = self._get_live_snapshot()
        lord_ctrl = snap.get("lordInfoCtrl")
        if not isinstance(lord_ctrl, dict):
            return None
        base = lord_ctrl.get("base")
        if not isinstance(base, dict) or "health" not in base:
            return None
        return self._safe_int(base.get("health"), 0) // 100

    def _count_active_monster_marches(self) -> int:
        """عدّ فيالق الهجوم على الوحوش النشطة حالياً بالخارج (queueType == 1)."""
        count = 0
        for q, _ in self._iter_my_active_queues():
            q_type = self._safe_int(
                q.get("queueType") or q.get("type") or q.get("orgQueueType"),
                -1,
            )
            if q_type == SERVER_QUEUE_TYPE_KILL_NPC:
                count += 1
                continue
            to_info = q.get("to") if isinstance(q.get("to"), dict) else {}
            to_id = str(to_info.get("id") or q.get("toId") or "")
            if to_id:
                parts = to_id.split("-")
                if len(parts) >= 3 and parts[2] in (str(MAP_TYPE_NORMAL_NPC), str(MAP_TYPE_NEBULA_NPC)):
                    count += 1
        return count

    def _has_active_monster_march(self) -> bool:
        return self._count_active_monster_marches() > 0

    def _get_daily_monster_remaining(self) -> Tuple[bool, int, str]:
        try:
            daily_status = self.get_daily_march_tasks_status()
        except Exception:
            daily_status = {}

        if not isinstance(daily_status, dict) or not daily_status:
            return False, 1, "تعذر قراءة تقدم مهمة الوحوش اليومية — سيتم التعامل مع هدف واحد."

        matched_info: Optional[Dict[str, Any]] = None
        for key in DAILY_MONSTER_TASK_KEYS:
            if isinstance(daily_status.get(key), dict):
                matched_info = daily_status[key]
                break
        if matched_info is None:
            for k, v in daily_status.items():
                if isinstance(v, dict) and ("monster" in str(k).lower() or "npc" in str(k).lower()):
                    matched_info = v
                    break

        if not matched_info:
            return False, 1, "مهمة الوحوش غير مدرجة في جدول النشاط اليومي."

        done = bool(matched_info.get("done") or matched_info.get("completed"))
        if done:
            return True, 0, "مهمة قتل الوحوش اليومية منجزة بالفعل."

        if "remaining" in matched_info:
            rem = max(0, self._safe_int(matched_info.get("remaining"), 0))
        else:
            target = self._safe_int(matched_info.get("target") or matched_info.get("max") or 1, 1)
            current = self._safe_int(matched_info.get("current") or matched_info.get("progress") or 0, 0)
            rem = max(0, target - current)

        if rem <= 0:
            return True, 0, "مهمة قتل الوحوش اليومية منجزة بالفعل."
        return False, rem, f"المتبقي لإنجاز مهمة الوحوش اليومية: {rem}"

    @staticmethod
    def _extract_err_code(resp: Any) -> str:
        if not isinstance(resp, dict):
            return "NO_RESPONSE"
        err = resp.get("err")
        if err is None or str(err) in ("0", "", "None", "Err_None"):
            return "0"
        return str(err)

    @classmethod
    def _extract_target_coords(cls, target: Dict[str, Any]) -> Tuple[int, int, float]:
        """استخراج (x, y, distance) بمرونة من أي هيكل قاموس تُرجعه search_best_monster."""
        if not isinstance(target, dict):
            return -1, -1, 0.0

        dist = float(target.get("distance") or target.get("dist") or 0.0)

        for kx, ky in (("x", "y"), ("target_x", "target_y"), ("tx", "ty"), ("posx", "posy")):
            if target.get(kx) is not None and target.get(ky) is not None:
                return cls._safe_int(target[kx], -1), cls._safe_int(target[ky], -1), dist

        for nested_key in ("pos", "result", "best", "target", "coords"):
            sub = target.get(nested_key)
            if isinstance(sub, dict):
                if sub.get("x") is not None and sub.get("y") is not None:
                    sub_dist = float(sub.get("distance") or dist)
                    return cls._safe_int(sub["x"], -1), cls._safe_int(sub["y"], -1), sub_dist
            elif isinstance(sub, (list, tuple)) and len(sub) >= 2:
                return cls._safe_int(sub[0], -1), cls._safe_int(sub[1], -1), dist

        for id_key in ("target_id", "instance_id", "instanceID", "id"):
            raw_id = str(target.get(id_key) or "").strip()
            if "," in raw_id:
                parts = raw_id.split(",")
                if len(parts) >= 2:
                    return cls._safe_int(parts[0], -1), cls._safe_int(parts[1], -1), dist
            elif raw_id.count("-") >= 2:
                parts = raw_id.split("-")
                return cls._safe_int(parts[0], 0) - 1, cls._safe_int(parts[1], 0) - 1, dist

        return -1, -1, dist

    @classmethod
    def _build_monster_instance_id(cls, target: Dict[str, Any], monster_type: str, level: int) -> str:
        existing = str(target.get("instance_id") or target.get("instanceID") or target.get("id") or "").strip()
        if existing and "-" in existing:
            return existing
        tx, ty, _ = cls._extract_target_coords(target)
        map_type = MAP_TYPE_NEBULA_NPC if monster_type == "nebula" else MAP_TYPE_NORMAL_NPC
        npc_id = int(target.get("npc_id") or target.get("npcId") or (3000 + int(level)))
        return f"{tx + 1}-{ty + 1}-{map_type}-0-{npc_id}"

    async def _safe_release_target(
        self,
        target: Dict[str, Any],
        target_type_key: str,
    ) -> None:
        tx, ty, _ = self._extract_target_coords(target)
        tid = target.get("target_id") or f"{tx},{ty}"
        kid = target.get("kingdom_id")
        try:
            sig = inspect.signature(self.release_target)
            kwargs: Dict[str, Any] = {}
            if "kingdom_id" in sig.parameters and kid is not None:
                kwargs["kingdom_id"] = kid
            if "target_type" in sig.parameters:
                kwargs["target_type"] = target_type_key
            res = self.release_target(tid, **kwargs)
            if inspect.isawaitable(res):
                await res
        except Exception:
            pass

    async def _safe_confirm_target(
        self,
        target: Dict[str, Any],
        target_type_key: str,
    ) -> None:
        tx, ty, _ = self._extract_target_coords(target)
        tid = target.get("target_id") or f"{tx},{ty}"
        kid = target.get("kingdom_id")
        try:
            sig = inspect.signature(self.confirm_target)
            kwargs: Dict[str, Any] = {}
            if "kingdom_id" in sig.parameters and kid is not None:
                kwargs["kingdom_id"] = kid
            if "target_type" in sig.parameters:
                kwargs["target_type"] = target_type_key
            res = self.confirm_target(tid, **kwargs)
            if inspect.isawaitable(res):
                await res
        except Exception:
            pass

    async def _call_search_best_monster(
        self,
        monster_type: str,
        level: int,
    ) -> Optional[Dict[str, Any]]:
        fn: Any = self.search_best_monster
        try:
            params = inspect.signature(fn).parameters
        except Exception:
            params = {}

        kwargs: Dict[str, Any] = {}
        if "monster_type" in params:
            kwargs["monster_type"] = monster_type
        elif "kind" in params:
            kwargs["kind"] = monster_type

        if "level" in params:
            kwargs["level"] = level
        elif "target_level" in params:
            kwargs["target_level"] = level
        elif "max_level" in params:
            kwargs["max_level"] = level
            if "min_level" in params:
                kwargs["min_level"] = level

        if "max_distance" in params and "max_distance" in self.config:
            kwargs["max_distance"] = float(self.config["max_distance"])

        return await fn(**kwargs)

    # ------------------------------------------------------------------
    # التحقق المسبق (0-Network)
    # ------------------------------------------------------------------

    async def can_run(self) -> Tuple[bool, str]:
        if not self.is_active:
            return False, "مهمة صيد الوحوش معطلة في الإعدادات."

        if not hasattr(self, "build_combat_army_formation"):
            return False, "الدالة build_combat_army_formation غير موجودة في MarchManagerTask؛ أضفها أولاً إلى march_manager.py."

        min_energy = self._safe_int(self.config.get("min_energy", MIN_LORD_ENERGY), MIN_LORD_ENERGY)
        energy = self.get_lord_energy()
        if energy is not None and energy < min_energy:
            return False, f"طاقة اللورد الحالية ({energy}) أقل من الحد الأدنى المطلوب ({min_energy})."

        mode = self._get_mode()
        if mode == "daily_tasks":
            is_done, rem, reason = self._get_daily_monster_remaining()
            if is_done or rem <= 0:
                return False, reason

        has_slot = self.has_available_march(require_soldiers=False)
        has_monster_out = self._has_active_monster_march()
        if not has_slot and not has_monster_out:
            return False, "لا يوجد فيلق شاغر حالياً، وكل الفيالق بالخارج ليست لصيد الوحوش."

        if not self.get_available_soldiers() and not has_monster_out:
            return False, "لا يوجد جنود متاحون في القلعة ولا يوجد فيلق وحوش بالخارج."

        return True, "جاهز لتنفيذ مهمة صيد الوحوش."

    # ------------------------------------------------------------------
    # إرسال مسيرة الهجوم الرسمية (CMD 1007/2)
    # ------------------------------------------------------------------

    async def dispatch_monster_march(
        self,
        target: Dict[str, Any],
        formation: Dict[str, Any],
        monster_type: str,
        level: int,
    ) -> Dict[str, Any]:
        tx, ty, _ = self._extract_target_coords(target)
        if tx < 0 or ty < 0:
            return {"ok": False, "err": "INVALID_TARGET", "reason": "إحداثيات الوحش غير صالحة."}

        _, _, kingdom_id = self._get_castle_coords_and_kingdom()
        instance_id = self._build_monster_instance_id(target, monster_type, level)
        target_type_key = self._get_target_type_key(monster_type)

        payload = {
            "moveLineType": MONSTER_ATTACK_MOVE_LINE_TYPE,
            "matrixType": MONSTER_ATTACK_MATRIX_TYPE,
            "data": {
                "to": {
                    "x": tx,
                    "y": ty,
                    "id": instance_id,
                },
                "army": formation["army"],
                "heroInfo": formation["hero_ids"],
                "armsInfo": [],
                "divineBeastInfo": [],
                "mapId": int(kingdom_id),
                "isDuel": False,
                "isForbidSpeed": False,
                "data": {},
            },
        }

        resp = await self.send_and_wait("1007", "2", payload, timeout=15.0)
        err = self._extract_err_code(resp)
        if err != "0":
            await self._safe_release_target(target, target_type_key)
            return {
                "ok": False,
                "err": err,
                "reason": f"رفض السيرفر إرسال مسيرة الهجوم على الوحش (err={err}).",
                "raw": resp,
            }

        await self._safe_confirm_target(target, target_type_key)

        return {
            "ok": True,
            "err": "0",
            "target": {"x": tx, "y": ty, "id": instance_id, "level": level, "type": monster_type},
            "total_soldiers": formation["total_soldiers"],
            "hero_ids": formation["hero_ids"],
            "win_ratio": formation.get("win_ratio"),
        }

    # ------------------------------------------------------------------
    # حلقة الانتظار الذكي (دقيقتين مع احترام مهلة الـ 20 دقيقة)
    # ------------------------------------------------------------------

    async def _wait_for_monster_march_return(
        self,
        deadline: float,
        wait_interval: float,
        wait_reason: str,
    ) -> Tuple[bool, str]:
        if not self._has_active_monster_march():
            return (
                False,
                f"{wait_reason} ولا يوجد أي فيلق وحوش نشط بالخارج (الفيالق الأخرى جمع/أطلال/حراسة كنز) — إيقاف المهمة.",
            )

        remaining = deadline - time.monotonic()
        if remaining < MIN_REMAINING_TIME_FOR_WAIT_SEC:
            return False, "انتهت مهلة مهمة مدير المسيرات (20 دقيقة) — إيقاف المهمة."

        sleep_sec = min(wait_interval, remaining)
        active_monsters = self._count_active_monster_marches()
        self.log(
            f"⏳ [صيد الوحوش] {wait_reason} — يوجد {active_monsters} فيلق وحوش بالخارج؛ "
            f"الانتظار {int(sleep_sec)}ث قبل إعادة الفحص (المتبقي من المهلة: {_format_hhmmss(int(remaining))})."
        )
        await asyncio.sleep(sleep_sec)

        if time.monotonic() >= deadline:
            return False, "انتهت مهلة مهمة مدير المسيرات (20 دقيقة) — إيقاف المهمة."
        return True, ""

    # ------------------------------------------------------------------
    # محرك التنفيذ الرئيسي للوضعين (daily_tasks & hunt)
    # ------------------------------------------------------------------

    async def run(self) -> TaskResult:
        mode = self._get_mode()
        monster_type = self._get_monster_type()
        target_type_key = self._get_target_type_key(monster_type)
        default_lv = 41 if monster_type == "nebula" else 15
        req_level = self._safe_int(self.config.get("monster_level", default_lv), default_lv)

        min_win_ratio = float(self.config.get("min_win_ratio", DEFAULT_COMBAT_MIN_WIN_RATIO))
        strategy = str(self.config.get("strategy", "max_power")).strip().lower()
        combat_buff_factor = float(self.config.get("combat_buff_factor", 1.0))
        auto_downgrade = bool(self.config.get("auto_downgrade", False))
        min_energy = self._safe_int(self.config.get("min_energy", MIN_LORD_ENERGY), MIN_LORD_ENERGY)
        wait_interval = float(self.config.get("wait_interval_sec", DEFAULT_WAIT_INTERVAL_SEC))
        dry_run = bool(self.config.get("dry_run", False))

        max_dur = float(self.config.get("max_duration_sec", self.max_duration_seconds))
        deadline = time.monotonic() + max(60.0, max_dur)

        daily_needed: Optional[int] = None
        if mode == "daily_tasks":
            is_done, rem, status_msg = self._get_daily_monster_remaining()
            if is_done or rem <= 0:
                self.log(f"⏭️ [صيد الوحوش - يومي] {status_msg}")
                return TaskResult(success=False, skipped=True, message=status_msg)
            in_flight = self._count_active_monster_marches()
            daily_needed = max(0, rem - in_flight)
            if daily_needed <= 0:
                msg = f"يوجد بالفعل {in_flight} فيلق وحوش نشط بالخارج يكفي لإكمال المتبقي ({rem}) من المهمة اليومية."
                self.log(f"⏭️ [صيد الوحوش - يومي] {msg}")
                return TaskResult(success=False, skipped=True, message=msg)

        type_label = "الوحوش السحابية" if monster_type == "nebula" else "الوحوش العادية"
        mode_label = f"النشاط اليومي (المطلوب إرسال: {daily_needed})" if mode == "daily_tasks" else "الهجوم اللانهائي"
        energy_now = self.get_lord_energy()
        self.log(
            f"⚔️ [صيد الوحوش] الوضع: {mode_label} | النوع: {type_label} | المستوى: {req_level} | "
            f"العتبة: {min_win_ratio:.2f}× | طاقة اللورد: {energy_now if energy_now is not None else 'غير معروفة'} | "
            f"الفيالق الشاغرة: {self.get_available_marches_count()}"
        )

        sent_marches: List[Dict[str, Any]] = []
        stop_reason = ""
        current_level = req_level
        consecutive_dispatch_errors = 0

        while True:
            if time.monotonic() >= deadline:
                stop_reason = "انتهت مهلة مهمة مدير المسيرات (20 دقيقة)."
                break

            if daily_needed is not None and len(sent_marches) >= daily_needed:
                stop_reason = f"تم إرسال العدد المطلوب ({daily_needed}) لإنجاز مهمة الوحوش اليومية."
                break

            energy_now = self.get_lord_energy()
            if energy_now is not None and energy_now < min_energy:
                stop_reason = f"انخفضت طاقة اللورد ({energy_now}) عن الحد الأدنى ({min_energy}) — إيقاف الصيد."
                break

            if not dry_run and not self.has_available_march(require_soldiers=False):
                should_cont, reason = await self._wait_for_monster_march_return(
                    deadline=deadline,
                    wait_interval=wait_interval,
                    wait_reason="نفدت الفيالق الشاغرة",
                )
                if not should_cont:
                    stop_reason = reason
                    break
                continue

            formation = self.build_combat_army_formation(
                target_type=target_type_key,
                level=current_level,
                strategy=strategy,
                min_win_ratio=min_win_ratio,
                combat_buff_factor=combat_buff_factor,
            )

            if not formation.get("ok") or not formation.get("can_kill"):
                err_code = str(formation.get("error_code", "UNKNOWN"))
                rec_lv = self._safe_int(formation.get("recommended_max_level"), 0)

                if auto_downgrade and rec_lv > 0 and rec_lv < current_level:
                    self.log(
                        f"📉 [صيد الوحوش] لا يمكن قتل مستوى {current_level} بشكل مؤكد — "
                        f"نزول تلقائي إلى المستوى الموصى به: {rec_lv}."
                    )
                    current_level = rec_lv
                    continue

                if err_code in ("NO_AVAILABLE_SOLDIERS", "INSUFFICIENT_SOLDIERS"):
                    if not dry_run and self._has_active_monster_march():
                        should_cont, reason = await self._wait_for_monster_march_return(
                            deadline=deadline,
                            wait_interval=wait_interval,
                            wait_reason="الجنود المتاحون في القلعة غير كافيين حالياً للقتل المؤكد",
                        )
                        if not should_cont:
                            stop_reason = reason
                            break
                        continue
                    stop_reason = (
                        f"{formation.get('reason', 'لا يوجد جنود كافون للقتل المؤكد.')} "
                        f"(أعلى مستوى مؤكد حالياً: {rec_lv} | لا يوجد فيلق وحوش بالخارج)."
                    )
                    break

                stop_reason = (
                    f"{formation.get('reason', 'تعذر قتل الهدف بشكل مؤكد.')} "
                    f"(أعلى مستوى موصى به: {rec_lv})."
                )
                break

            target = await self._call_search_best_monster(monster_type=monster_type, level=current_level)
            if not target:
                stop_reason = f"لم يتم العثور على وحش ({type_label}) مستوى {current_level} على الخريطة — إيقاف الصيد."
                break

            tx, ty, dist = self._extract_target_coords(target)
            found_lv = self._safe_int(target.get("level"), current_level)

            if found_lv != current_level:
                formation = self.build_combat_army_formation(
                    target_type=target_type_key,
                    level=found_lv,
                    strategy=strategy,
                    min_win_ratio=min_win_ratio,
                    combat_buff_factor=combat_buff_factor,
                )
                if not formation.get("ok") or not formation.get("can_kill"):
                    await self._safe_release_target(target, target_type_key)
                    stop_reason = formation.get(
                        "reason",
                        f"الوحش المكتشف مستوى {found_lv} لا يمكن قتله بشكل مؤكد.",
                    )
                    break

            if dry_run:
                dry_msg = (
                    f"[DRY-RUN محاكاة فقط — لم يتم إرسال أي هجوم فعلي] "
                    f"الهدف: {type_label} مستوى {found_lv} في ({tx}, {ty}) (المسافة: {dist:.1f}) | "
                    f"جنود: {formation['total_soldiers']:,} | أبطال: {formation['hero_ids']} | "
                    f"نسبة القوة: {formation['win_ratio']:.2f}× ({formation.get('tier')})"
                )
                self.log(f"🧪 {dry_msg}")
                return TaskResult(
                    success=True,
                    message=dry_msg,
                    data={
                        "dry_run": True,
                        "mode": mode,
                        "monster_type": monster_type,
                        "target": {"x": tx, "y": ty, "level": found_lv, "distance": dist},
                        "total_soldiers": formation["total_soldiers"],
                        "hero_ids": formation["hero_ids"],
                        "win_ratio": formation["win_ratio"],
                    },
                )

            await asyncio.sleep(random.uniform(0.35, 0.85))
            self.log(
                f"🚀 [صيد الوحوش] إرسال {formation['total_soldiers']:,} جندي "
                f"(أبطال: {formation['hero_ids']}) نحو {type_label} مستوى {found_lv} في ({tx}, {ty}) | "
                f"نسبة القوة: {formation['win_ratio']:.2f}×"
            )
            dispatch_res = await self.dispatch_monster_march(
                target=target,
                formation=formation,
                monster_type=monster_type,
                level=found_lv,
            )

            if not dispatch_res.get("ok"):
                consecutive_dispatch_errors += 1
                self.log(f"⚠️ [صيد الوحوش] {dispatch_res.get('reason')}")
                if consecutive_dispatch_errors >= 3:
                    stop_reason = f"توقف بعد 3 إخفاقات إرسال متتالية ({dispatch_res.get('reason')})."
                    break
                await asyncio.sleep(random.uniform(1.0, 2.0))
                continue

            consecutive_dispatch_errors = 0
            sent_marches.append(dispatch_res)
            self.log(f"✅ [صيد الوحوش] انطلق الفيلق #{len(sent_marches)} نحو ({tx}, {ty}).")

            await asyncio.sleep(random.uniform(0.6, 1.3))

        if sent_marches:
            msg = f"تم إرسال {len(sent_marches)} فيلق لصيد {type_label}. ({stop_reason})"
            self.log(f"🏁 [صيد الوحوش] {msg}")
            return TaskResult(
                success=True,
                message=msg,
                data={
                    "mode": mode,
                    "monster_type": monster_type,
                    "sent_count": len(sent_marches),
                    "marches": sent_marches,
                    "stop_reason": stop_reason,
                },
            )

        self.log(f"⏭️ [صيد الوحوش] {stop_reason}")
        return TaskResult(
            success=False,
            skipped=True,
            message=stop_reason or "لم يتم إرسال أي فيلق صيد.",
            data={
                "mode": mode,
                "monster_type": monster_type,
                "sent_count": 0,
                "stop_reason": stop_reason,
            },
        )


# ===========================================================================
# مشغّل الطرفية للاختبار المباشر (مطابق 100% لـ gather_resources.py)
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
            "mode": args.mode,
            "monster_type": args.monster_type,
            "monster_level": args.level,
            "min_win_ratio": args.win_ratio,
            "strategy": args.strategy,
            "combat_buff_factor": args.buff_factor,
            "auto_downgrade": args.auto_downgrade,
            "min_energy": args.min_energy,
            "wait_interval_sec": args.wait_sec,
            "max_duration_sec": args.max_minutes * 60.0,
            "dry_run": args.dry_run,
        }
        task = HuntMonstersTask(conn, config=cfg)
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

    parser = argparse.ArgumentParser(description="اختبار مهمة صيد الوحوش العادية والسحابية (HuntMonstersTask) مباشرة.")
    parser.add_argument("--email", required=True, help="إيميل الحساب")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري إذا كانت في session_cache)")
    parser.add_argument("--mode", default="hunt", choices=["hunt", "daily_tasks"], help="وضع الصيد: hunt (لا نهائي) أو daily_tasks (النشاط اليومي)")
    parser.add_argument("--monster-type", default="normal", choices=["normal", "nebula"], help="نوع الوحش: normal (1..40) أو nebula (41..50)")
    parser.add_argument("--level", type=int, default=15, help="مستوى الوحش المستهدف (افتراضي 15 للوحوش العادية، 41 للسحابية)")
    parser.add_argument("--win-ratio", type=float, default=DEFAULT_COMBAT_MIN_WIN_RATIO, help="عتبة القتل المؤكد (افتراضي 1.5)")
    parser.add_argument("--strategy", default="max_power", choices=["max_power", "exact_threshold", "strict_overkill"], help="استراتيجية تشكيل الجيش")
    parser.add_argument("--buff-factor", type=float, default=1.0, help="معامل بوف القلعة القتالي (افتراضي 1.0)")
    parser.add_argument("--auto-downgrade", action="store_true", help="النزول تلقائياً لأعلى مستوى موصى به إذا عجز الفيلق عن المستوى المطلوب")
    parser.add_argument("--min-energy", type=int, default=MIN_LORD_ENERGY, help="الحد الأدنى لطاقة اللورد قبل التوقف (افتراضي 10)")
    parser.add_argument("--wait-sec", type=float, default=DEFAULT_WAIT_INTERVAL_SEC, help="مدة الانتظار بالثواني عند انشغال فيالق الوحوش (افتراضي 120)")
    parser.add_argument("--max-minutes", type=float, default=20.0, help="المهلة القصوى بالدقائق (افتراضي 20)")
    parser.add_argument("--dry-run", action="store_true", help="محاكاة التشكيل والبحث بدون إرسال الفيلق فعلياً")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()