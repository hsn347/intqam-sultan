# -*- coding: utf-8 -*-
"""
مهمة إرسال فيلق حراسة الكنز الخاص (EscortTreasureTask) — تعمل عبر MarchManagerTask وترث دواله بالكامل.

تتبع سورس كود اللعبة في game_file حرفياً:
  - فحص مسبق (0-Network) لعدم وجود مسيرة حراسة كنز خاص نشطة حالياً (type=22 / moveLineType=11)
    مع استبعاد مسيرات مساعدة التحالف (type=23 / moveLineType=13) (kingdomMapCtrl.lua:1195).
  - فحص مستوى القلعة (>= ESCORT_CITYLEVEL_MIN، افتراضياً 12) والحد اليومي (escortCount < ESCORT_DAY_MAX)
    وفتح فعالية حراسة الكنز (9001017) وتوفر فيلق شاغر وجنود.
  - جلب أقرب مبنى حراسة كنز من الذاكرة الحية (escortCtrl.closestBuild) أو عبر CMD 1078/2
    (REQ_ESCORT_GET_CLOSEST_BUILD | escortCtrl.lua:40-46, worldMapComButton.lua:51-62).
  - جلب بيانات العربة عبر CMD 1075/1 (REQ_ESCORT_CART_DATA) وتنفيذ التحديث المجاني فقط
    عبر CMD 1075/2 (REQ_ESCORT_CART_REFRESH) عندما تكون nextRefreshGold == 0 ومستوى العربة < 5،
    دون صرف أي ذهب مطلقاً (WorldEscortBeginViewPanel.lua:104, 181-208).
  - تشكيل الفيلق بنفس خوارزمية اللعبة الرسمية في WorldDispatchArmyViewPanel.lua:573-584, 1360-1384:
    أعلى مستوى جندي (Tier) أولاً ثم أصغر armyID حتى ملء سعة الفيلق القصوى، مع أقوى الأبطال المتاحين.
  - إرسال فيلق واحد فقط عبر CMD 1007/2 بـ moveLineType=11 (moveLineTypeEscort) و matrixType=7
    (moveLineMatrixTypeEscort | mapDef.lua:391, 417 & worldMapFunction.lua:335-337).

أمثلة الاختبار المباشر من الطرفية:
  python tasks/escort_treasure.py --email beetoo3@hotmail.com --dry-run
  python tasks/escort_treasure.py --email beetoo3@hotmail.com
  python tasks/escort_treasure.py --email beetoo3@hotmail.com --no-free-refresh
"""
from __future__ import annotations

import argparse
import asyncio
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
# ثوابت بروتوكول حراسة الكنز الرسمية (mapDef.lua, cmdDef.lua, escortDef.lua)
# ---------------------------------------------------------------------------
ESCORT_MOVE_LINE_TYPE = 11          # gMapMoveLineType.moveLineTypeEscort (mapDef.lua:391)
ESCORT_MATRIX_TYPE = 7              # gMapMoveLineMatrixType.moveLineMatrixTypeEscort (mapDef.lua:417)
ESCORT_SERVER_QUEUE_TYPE = 22       # gMapMoveLineServerType.moveLineTypeEscort (mapDef.lua:343)
ESCORT_MAP_OBJ_TYPE = 16            # gMapObjTypeDef.mapObjTypeEscort (mapDef.lua:19, 122)
ESCORT_ACTIVITY_ID = 9001017        # gActivityTimeActivityID.ESCORT (activityDef.lua:233)

CMD_ESCORT_CART_MODULE = "1075"     # gCmd.CMD_ESCORT_CART_MODULE (cmdDef.lua:1306)
REQ_ESCORT_CART_DATA = "1"          # gCmd.REQ_ESCORT_CART_DATA (cmdDef.lua:1307)
REQ_ESCORT_CART_REFRESH = "2"       # gCmd.REQ_ESCORT_CART_REFRESH (cmdDef.lua:1308)

CMD_ESCORT_MODULE = "1078"          # gCmd.CMD_ESCORT_MODULE (cmdDef.lua:1317)
REQ_ESCORT_GET_CLOSEST_BUILD = "2"  # gCmd.REQ_ESCORT_GET_CLOSEST_BUILD (cmdDef.lua:1319)

DEFAULT_MIN_CASTLE_LEVEL = 12       # ESCORT_CITYLEVEL_MIN (escortDef.lua:2)
DEFAULT_ESCORT_DAY_MAX = 2          # ESCORT_DAY_MAX (escortDef.lua:3)
MAX_CART_LEVEL = 5                  # أعلى مستوى عربة في WorldEscortBeginViewPanel.lua
MAX_FREE_REFRESH_ATTEMPTS = 5       # سقف أمان صارم لمنع أي حلقة لا نهائية عند تحديث العربة


class EscortTreasureTask(MarchManagerTask):
    """
    مهمة إرسال فيلق واحد فقط لحراسة الكنز الخاص (مع فحص مسبق وتحديث مجاني للعربة).
    """

    name: str = "escort_treasure"
    alias: str = "escort"

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
        self.name = "escort_treasure"

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

    @staticmethod
    def _extract_payload_dict(resp: Any) -> Dict[str, Any]:
        """استخراج قاموس البيانات الفعلي من رد السيرفر بغض النظر عن اسم المفتاح الحاضن."""
        if not isinstance(resp, dict):
            return {}
        for key in ("data", "rspdata", "result", "retData"):
            val = resp.get(key)
            if isinstance(val, dict):
                return val
        return resp

    def _has_active_own_escort_march(self) -> bool:
        """
        فحص مزدوج (0-Network) للتأكد من عدم وجود مسيرة حراسة كنز خاصة نشطة حالياً
        (type=22 / moveLineType=11 فقط، دون الخلط مع مساعدة حليف type=23 / moveLineType=13).
        """
        try:
            if self.has_treasure_escort_march(include_assist=False):
                return True
        except Exception:
            pass
        if hasattr(self, "is_caravan_escort_march_active"):
            try:
                if self.is_caravan_escort_march_active(force_sync=False):
                    return True
            except Exception:
                pass
        return False

    def _get_escort_ctrl_state(self) -> Dict[str, Any]:
        """قراءة حالة escortCtrl من الذاكرة الحية بأمان (0-Network)."""
        snap = self._get_live_snapshot()
        raw = snap.get("escortCtrl")
        if not isinstance(raw, dict):
            raw = {}

        # دعم كل من البنية المسطحة والبنية المتداخلة تحت dataMgr أو data
        src = raw
        for nested_key in ("dataMgr", "data", "stat"):
            nested = raw.get(nested_key)
            if isinstance(nested, dict) and any(
                k in nested for k in ("escortCount", "ESCORT_DAY_MAX", "closestBuild", "ESCORT_CITYLEVEL_MIN")
            ):
                src = nested
                break

        escort_count = None
        if "escortCount" in src and src.get("escortCount") is not None:
            escort_count = self._safe_int(src.get("escortCount"), 0)

        escort_day_max = self._safe_int(
            src.get("ESCORT_DAY_MAX", DEFAULT_ESCORT_DAY_MAX),
            DEFAULT_ESCORT_DAY_MAX,
        )
        min_castle_lv = self._safe_int(
            src.get("ESCORT_CITYLEVEL_MIN", DEFAULT_MIN_CASTLE_LEVEL),
            DEFAULT_MIN_CASTLE_LEVEL,
        )
        closest_build = src.get("closestBuild") if isinstance(src.get("closestBuild"), dict) else None

        return {
            "escort_count": escort_count,
            "escort_day_max": max(1, escort_day_max),
            "min_castle_level": max(1, min_castle_lv),
            "closest_build": closest_build,
        }

    def _is_escort_activity_open(self) -> Tuple[bool, str]:
        """
        فحص فتح فعالية حراسة الكنز (9001017) من activityShowCtrl في الذاكرة الحية.
        إذا لم تتوفر بيانات activityShowCtrl نسمح بالمتابعة ونترك السيرفر يحسم الأمر بدلاً من التخطي الخاطئ.
        """
        snap = self._get_live_snapshot()
        act_ctrl = snap.get("activityShowCtrl")
        if not isinstance(act_ctrl, dict) or not act_ctrl:
            return True, "بيانات activityShowCtrl غير محملة؛ سيتم التحقق عبر السيرفر."

        # البحث في القوائم الشائعة داخل activityShowCtrl
        act_id_str = str(ESCORT_ACTIVITY_ID)
        containers: List[Any] = [act_ctrl]
        for key in ("activities", "activityList", "openList", "list", "data", "activityMap"):
            val = act_ctrl.get(key)
            if isinstance(val, (dict, list)):
                containers.append(val)

        found_entry: Optional[Dict[str, Any]] = None
        for box in containers:
            if isinstance(box, dict):
                if act_id_str in box and isinstance(box[act_id_str], dict):
                    found_entry = box[act_id_str]
                    break
                if ESCORT_ACTIVITY_ID in box and isinstance(box[ESCORT_ACTIVITY_ID], dict):
                    found_entry = box[ESCORT_ACTIVITY_ID]
                    break
            elif isinstance(box, list):
                for item in box:
                    if isinstance(item, dict):
                        iid = item.get("activityId") or item.get("activityID") or item.get("id")
                        if self._safe_int(iid, 0) == ESCORT_ACTIVITY_ID:
                            found_entry = item
                            break
                if found_entry is not None:
                    break

        if found_entry is None:
            return True, "لم تُرصد حالة صريحة لفعالية حراسة الكنز محلياً؛ سيتم التحقق عبر السيرفر."

        now_ts = time.time()
        end_time = self._safe_int(found_entry.get("endTime") or found_entry.get("end_time"), 0)
        start_time = self._safe_int(found_entry.get("startTime") or found_entry.get("start_time"), 0)
        if end_time > 0 and now_ts >= end_time:
            return False, "فعالية حراسة الكنز غير مفتوحة حالياً (انتهى وقت الفعالية)."
        if start_time > 0 and now_ts < start_time:
            return False, "فعالية حراسة الكنز لم تبدأ بعد."
        if found_entry.get("isOpen") is False or found_entry.get("open") is False:
            return False, "فعالية حراسة الكنز مغلقة حالياً."

        return True, "فعالية حراسة الكنز مفتوحة."

    # ------------------------------------------------------------------
    # الفحص المسبق (0-Network)
    # ------------------------------------------------------------------

    async def can_run(self) -> Tuple[bool, str]:
        if not self.is_active:
            return False, "مهمة حراسة الكنز معطلة في الإعدادات."

        # 1) فحص صارم لعدم وجود فيلق حراسة كنز خاص نشط حالياً
        if self._has_active_own_escort_march():
            return False, "يوجد بالفعل فيلق حراسة كنز خاص نشط حالياً — لا يمكن إرسال فيلق آخر."

        state = self._get_escort_ctrl_state()

        # 2) فحص مستوى القلعة (>= 12 افتراضياً)
        castle_lv = self._safe_int(getattr(self, "castle_level", 0), 0)
        if castle_lv > 0 and castle_lv < state["min_castle_level"]:
            return (
                False,
                f"مستوى القلعة الحالي ({castle_lv}) أقل من الحد الأدنى المطلوب لحراسة الكنز ({state['min_castle_level']}).",
            )

        # 3) فحص فتح الفعالية
        is_open, act_reason = self._is_escort_activity_open()
        if not is_open:
            return False, act_reason

        # 4) فحص الحد اليومي لحراسة الكنز
        escort_count = state["escort_count"]
        escort_day_max = state["escort_day_max"]
        if escort_count is not None and escort_count >= escort_day_max:
            return False, f"تم استنفاد الحد اليومي لحراسة الكنز ({escort_count}/{escort_day_max})."

        # 5) فحص توفر فيلق شاغر وجنود متاحين
        if not self.has_available_march(require_soldiers=True):
            return False, "لا يوجد فيلق شاغر أو جنود متاحون لإرسال قافلة حراسة الكنز."

        return True, "جاهز لتنفيذ مهمة حراسة الكنز الخاص."

    # ------------------------------------------------------------------
    # تشكيل الفيلق بنفس خوارزمية اللعبة الرسمية (WorldDispatchArmyViewPanel.lua)
    # ------------------------------------------------------------------

    def build_game_default_escort_formation(self) -> Dict[str, Any]:
        """
        تشكيل فيلق حراسة الكنز بنفس منطق الاختيار السريع في اللعبة:
          - WorldDispatchArmyViewPanel.lua:573-584: ترتيب الجنود المتاحين (بدون فخاخ الحصن)
            تنازلياً حسب مستوى الجندي (level)، ثم تصاعدياً حسب armyID، وملء السعة القصوى.
          - WorldDispatchArmyViewPanel.lua:1368-1384: اختيار أقوى الأبطال المتاحين (NORMAL/DEFEND)
            حتى الحد الأقصى (get_max_battle_hero_num، افتراضياً 5).
        """
        soldiers_now = self.get_available_soldiers()
        if not soldiers_now:
            return {
                "ok": False,
                "reason": "لا يوجد جنود متاحون في القلعة لتشكيل فيلق حراسة الكنز.",
            }

        # 1) اختيار الأبطال المتاحين (مطابق لـ HERO_STATE_NORMAL / HERO_STATE_DEFEND)
        heroes_now = self.get_available_heroes(exclude_defend=False)
        max_heroes = 5
        if hasattr(self, "get_max_battle_hero_num"):
            try:
                max_heroes = max(1, int(self.get_max_battle_hero_num()))
            except Exception:
                max_heroes = 5

        sorted_heroes = sorted(
            heroes_now,
            key=lambda h: (
                self._safe_int(h.get("quality"), 0),
                self._safe_int(h.get("level"), 0),
                self._safe_int(h.get("hero_id") or h.get("heroID") or h.get("id"), 0),
            ),
            reverse=True,
        )
        selected_hero_ids: List[int] = []
        for h in sorted_heroes[:max_heroes]:
            hid = self._safe_int(h.get("hero_id") or h.get("heroID") or h.get("id"), 0)
            if hid > 0 and hid not in selected_hero_ids:
                selected_hero_ids.append(hid)

        # 2) حساب السعة القصوى الحية للفيلق حصرياً عبر tasks/march_capacity.py
        from tasks.march_capacity import get_march_capacity, get_march_capacity_no_heroes

        live_mem = self._get_live_snapshot()
        max_cap = self._safe_int(
            get_march_capacity(
                live_mem,
                hero_ids=selected_hero_ids or None,
                only_normal_state=False,
            ),
            0,
        )
        if max_cap <= 0:
            max_cap = self._safe_int(get_march_capacity_no_heroes(live_mem), 0)

        # 3) ترتيب الجنود مطابقاً لـ WorldDispatchArmyViewPanel.lua:580-583
        #    (أعلى مستوى level أولاً، ثم أصغر army_id عند التساوي)
        normalized_soldiers: List[Dict[str, int]] = []
        for s in soldiers_now:
            sid = self._safe_int(s.get("army_id") or s.get("id"), 0)
            cnt = self._safe_int(s.get("count"), 0)
            lv = self._safe_int(s.get("level"), 1)
            if sid > 0 and cnt > 0:
                normalized_soldiers.append({"army_id": sid, "level": lv, "count": cnt})

        if not normalized_soldiers:
            return {
                "ok": False,
                "reason": "لا يوجد جنود صالحون للإرسال في القلعة حالياً.",
            }

        normalized_soldiers.sort(key=lambda item: (-item["level"], item["army_id"]))

        remaining = max_cap
        army_payload: List[Dict[str, int]] = []
        total_soldiers = 0
        for s in normalized_soldiers:
            if remaining <= 0:
                break
            take = min(s["count"], remaining)
            if take <= 0:
                continue
            army_payload.append({"id": s["army_id"], "num": take})
            total_soldiers += take
            remaining -= take

        if not army_payload or total_soldiers <= 0:
            return {
                "ok": False,
                "reason": "تعذر تعبئة أي جندي داخل سعة فيلق حراسة الكنز.",
            }

        hero_payload = [{"heroID": hid} for hid in selected_hero_ids]
        return {
            "ok": True,
            "army_payload": army_payload,
            "hero_payload": hero_payload,
            "hero_ids": selected_hero_ids,
            "total_soldiers": total_soldiers,
            "max_capacity": max_cap,
        }

    # ------------------------------------------------------------------
    # جلب أقرب مبنى حراسة كنز (ذاكرة حية أولاً، ثم CMD 1078/2)
    # ------------------------------------------------------------------

    @classmethod
    def _parse_closest_build(cls, raw_build: Any) -> Optional[Dict[str, Any]]:
        if not isinstance(raw_build, dict):
            return None
        tx = cls._safe_int(raw_build.get("x", raw_build.get("posX")), -1)
        ty = cls._safe_int(raw_build.get("y", raw_build.get("posY")), -1)
        map_obj_id = str(
            raw_build.get("mapObjId")
            or raw_build.get("instanceID")
            or raw_build.get("instance_id")
            or raw_build.get("id")
            or ""
        ).strip()
        if tx < 0 or ty < 0 or not map_obj_id:
            return None
        return {"x": tx, "y": ty, "mapObjId": map_obj_id}

    async def _resolve_closest_escort_build(self) -> Tuple[Optional[Dict[str, Any]], str]:
        state = self._get_escort_ctrl_state()
        cached = self._parse_closest_build(state.get("closest_build"))
        if cached:
            return cached, "memory"

        self.log("🧭 [حراسة الكنز] جلب إحداثيات أقرب مبنى حراسة كنز من السيرفر (1078/2)...")
        resp = await self.safe_query(
            CMD_ESCORT_MODULE,
            REQ_ESCORT_GET_CLOSEST_BUILD,
            {},
            min_delay=0.3,
            max_delay=0.7,
        )
        err = self._extract_err_code(resp)
        if err != "0":
            return None, f"فشل جلب أقرب مبنى حراسة كنز من السيرفر (err={err})."

        body = self._extract_payload_dict(resp)
        raw_build = body.get("closestBuild") if isinstance(body.get("closestBuild"), dict) else body
        parsed = self._parse_closest_build(raw_build)
        if not parsed:
            return None, "رد السيرفر (1078/2) لا يحتوي على إحداثيات أو mapObjId صالحة لمبنى حراسة الكنز."
        return parsed, "server"

    # ------------------------------------------------------------------
    # تجهيز العربة والتحديث المجاني فقط (CMD 1075/1 و 1075/2)
    # ------------------------------------------------------------------

    async def _prepare_cart_with_free_refresh(
        self,
        allow_free_refresh: bool,
        dry_run: bool,
    ) -> Dict[str, Any]:
        """
        جلب بيانات العربة عبر CMD 1075/1، وتنفيذ التحديث المجاني عبر CMD 1075/2
        فقط عندما يكون nextRefreshGold == 0 ومستوى العربة < 5 (بدون أي صرف ذهب).
        """
        resp = await self.safe_query(
            CMD_ESCORT_CART_MODULE,
            REQ_ESCORT_CART_DATA,
            {},
            min_delay=0.3,
            max_delay=0.6,
        )
        err = self._extract_err_code(resp)
        if err != "0":
            return {
                "ok": False,
                "err": err,
                "reason": f"فشل جلب بيانات عربة الكنز (1075/1, err={err}).",
            }

        body = self._extract_payload_dict(resp)
        curr_lv = self._safe_int(body.get("currCartLv"), 1)
        # إذا لم يذكر السيرفر nextRefreshGold نفترض -1 (غير مجاني) لضمان عدم صرف ذهب أبداً
        next_gold = self._safe_int(body.get("nextRefreshGold"), -1) if "nextRefreshGold" in body else -1
        refreshes_done = 0

        self.log(
            f"🛒 [حراسة الكنز] العربة الحالية: مستوى {curr_lv}/{MAX_CART_LEVEL} | "
            f"تكلفة التحديث التالي: {'مجاني (0 ذهب)' if next_gold == 0 else f'{next_gold} ذهب'}"
        )

        if allow_free_refresh and not dry_run:
            while curr_lv < MAX_CART_LEVEL and next_gold == 0 and refreshes_done < MAX_FREE_REFRESH_ATTEMPTS:
                self.log(f"🔄 [حراسة الكنز] تنفيذ تحديث مجاني للعربة (1075/2) — المحاولة #{refreshes_done + 1}...")
                ref_resp = await self.safe_query(
                    CMD_ESCORT_CART_MODULE,
                    REQ_ESCORT_CART_REFRESH,
                    {},
                    min_delay=0.4,
                    max_delay=0.8,
                )
                ref_err = self._extract_err_code(ref_resp)
                if ref_err != "0":
                    self.log(f"⚠️ [حراسة الكنز] تعذر التحديث المجاني للعربة (err={ref_err}) — المتابعة بالعربة الحالية.")
                    break

                ref_body = self._extract_payload_dict(ref_resp)
                new_lv = self._safe_int(ref_body.get("currCartLv"), curr_lv)
                new_gold = self._safe_int(ref_body.get("nextRefreshGold"), -1) if "nextRefreshGold" in ref_body else -1
                refreshes_done += 1
                self.log(
                    f"✨ [حراسة الكنز] بعد التحديث المجاني #{refreshes_done}: مستوى العربة {new_lv}/{MAX_CART_LEVEL} | "
                    f"تكلفة التحديث التالي: {'مجاني (0 ذهب)' if new_gold == 0 else f'{new_gold} ذهب'}"
                )
                curr_lv = new_lv
                next_gold = new_gold

        return {
            "ok": True,
            "curr_cart_lv": curr_lv,
            "next_refresh_gold": next_gold,
            "free_refreshes_done": refreshes_done,
        }

    # ------------------------------------------------------------------
    # التنفيذ الرئيسي (فيلق واحد فقط لحراسة الكنز الخاص)
    # ------------------------------------------------------------------

    async def run(self) -> TaskResult:
        dry_run = bool(self.config.get("dry_run", False))
        allow_free_refresh = bool(self.config.get("free_refresh", True))

        # 1) فحص مسبق صارم (0-Network)
        ok_pre, pre_reason = await self.can_run()
        if not ok_pre:
            self.log(f"⏭️ [حراسة الكنز] {pre_reason}")
            sig = "CONTINUE"
            if not self.is_connected or getattr(self.conn, "is_other_device", False) or getattr(self.conn, "is_sealed", False):
                sig = "ABORT_DISCONNECTED"
            elif not self.has_available_march(require_soldiers=True):
                blk_sig, _ = self.evaluate_march_block_signal(require_soldiers=True)
                if blk_sig in ("ABORT_MARCHES_FULL", "ABORT_SOLDIER_SHORTAGE", "ABORT_DISCONNECTED"):
                    sig = blk_sig
            return TaskResult(success=False, skipped=True, message=pre_reason, data={"manager_signal": sig})

        state = self._get_escort_ctrl_state()
        escort_count = state["escort_count"]
        escort_day_max = state["escort_day_max"]
        self.log(
            f"💰 [حراسة الكنز] بدء المهمة (فيلق واحد خاص فقط) | "
            f"المحاولات اليومية: {escort_count if escort_count is not None else '?'} / {escort_day_max} | "
            f"الفيالق الشاغرة: {self.get_available_marches_count()}"
        )

        # 2) تشكيل الفيلق محلياً (0-Network) قبل أي استعلام شبكي لضمان وجود قوات صالحة
        formation = self.build_game_default_escort_formation()
        if not formation.get("ok"):
            msg = str(formation.get("reason") or "تعذر تشكيل فيلق حراسة الكنز.")
            self.log(f"⏭️ [حراسة الكنز] {msg}")
            blk_sig, _ = self.evaluate_march_block_signal(require_soldiers=True, soldier_shortage=True)
            sig = blk_sig if blk_sig in ("ABORT_MARCHES_FULL", "ABORT_SOLDIER_SHORTAGE", "ABORT_DISCONNECTED") else "CONTINUE"
            return TaskResult(success=False, skipped=True, message=msg, data={"manager_signal": sig})

        # 3) جلب أقرب مبنى حراسة كنز (ذاكرة حية أولاً ثم 1078/2)
        closest_build, build_src = await self._resolve_closest_escort_build()
        if not closest_build:
            self.log(f"⚠️ [حراسة الكنز] {build_src}")
            return TaskResult(success=False, skipped=True, message=build_src)

        tx = closest_build["x"]
        ty = closest_build["y"]
        map_obj_id = closest_build["mapObjId"]
        self.log(
            f"📍 [حراسة الكنز] أقرب مبنى كنز ({build_src}): ({tx}, {ty}) | mapObjId={map_obj_id}"
        )

        # 4) جلب بيانات العربة وتنفيذ التحديث المجاني (1075/1 -> 1075/2 فقط عند 0 ذهب)
        cart_info = await self._prepare_cart_with_free_refresh(
            allow_free_refresh=allow_free_refresh,
            dry_run=dry_run,
        )
        if not cart_info.get("ok"):
            # لا ننهار؛ إذا رفض السيرفر 1075/1 (مثلاً انتهت الفعالية أو الحد اليومي) نتوقف بأمان
            msg = str(cart_info.get("reason") or "تعذر قراءة بيانات عربة حراسة الكنز.")
            self.log(f"⚠️ [حراسة الكنز] {msg}")
            return TaskResult(success=False, skipped=True, message=msg)

        # 5) إعادة فحص لحظية قبل الإرسال مباشرة لمنع أي سباق (Race Condition) مع إشعارات السيرفر
        if self._has_active_own_escort_march():
            msg = "تم رصد فيلق حراسة كنز خاص نشط قبل الإرسال مباشرة — تم الإلغاء لتجنب الازدواج."
            self.log(f"⏭️ [حراسة الكنز] {msg}")
            return TaskResult(success=False, skipped=True, message=msg)

        if dry_run:
            msg = (
                f"[DRY-RUN] جاهز لإرسال فيلق حراسة الكنز الخاص إلى ({tx}, {ty}) "
                f"| العربة: مستوى {cart_info['curr_cart_lv']}/{MAX_CART_LEVEL} "
                f"| جنود: {formation['total_soldiers']:,}/{formation['max_capacity']:,} "
                f"| أبطال: {formation['hero_ids']}"
            )
            self.log(f"🧪 [حراسة الكنز] {msg}")
            return TaskResult(
                success=True,
                message=msg,
                data={
                    "dry_run": True,
                    "target": closest_build,
                    "cart": cart_info,
                    "total_soldiers": formation["total_soldiers"],
                    "hero_ids": formation["hero_ids"],
                },
            )

        # 6) الإرسال الرسمي عبر CMD 1007/2 (فيلق واحد فقط)
        _, _, kingdom_id = self._get_castle_coords_and_kingdom()
        payload = {
            "moveLineType": ESCORT_MOVE_LINE_TYPE,
            "matrixType": ESCORT_MATRIX_TYPE,
            "data": {
                "to": {
                    "x": tx,
                    "y": ty,
                    "id": map_obj_id,
                },
                "army": formation["army_payload"],
                "heroInfo": formation["hero_payload"],
                "armsInfo": [],
                "divineBeastInfo": [],
                "mapId": int(kingdom_id),
                "isDuel": False,
                "isForbidSpeed": False,
                "data": {},
            },
        }

        await asyncio.sleep(random.uniform(0.35, 0.75))
        self.log(
            f"🚀 [حراسة الكنز] إرسال {formation['total_soldiers']:,} جندي "
            f"(أبطال: {formation['hero_ids']}) لحراسة الكنز الخاص (عربة مستوى {cart_info['curr_cart_lv']}) "
            f"عند ({tx}, {ty})..."
        )
        resp = await self.safe_query("1007", "2", payload, min_delay=0.5, max_delay=1.1)
        err = self._extract_err_code(resp)
        if err != "0":
            msg = f"رفض السيرفر إرسال فيلق حراسة الكنز الخاص (err={err})."
            self.log(f"⚠️ [حراسة الكنز] {msg}")
            return TaskResult(
                success=False,
                message=msg,
                data={"err": err, "target": closest_build, "cart": cart_info, "raw": resp},
            )

        msg = (
            f"تم إرسال فيلق حراسة الكنز الخاص بنجاح (عربة مستوى {cart_info['curr_cart_lv']}) "
            f"نحو ({tx}, {ty}) بـ {formation['total_soldiers']:,} جندي."
        )
        self.log(f"✅ [حراسة الكنز] {msg}")
        return TaskResult(
            success=True,
            message=msg,
            data={
                "target": closest_build,
                "cart": cart_info,
                "total_soldiers": formation["total_soldiers"],
                "hero_ids": formation["hero_ids"],
                "max_capacity": formation["max_capacity"],
            },
        )


# ===========================================================================
# مشغّل الطرفية للاختبار المباشر (مطابق لـ hunt_monsters.py و gather_resources.py)
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
            "free_refresh": not args.no_free_refresh,
            "dry_run": args.dry_run,
        }
        task = EscortTreasureTask(conn, config=cfg)
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

    parser = argparse.ArgumentParser(description="مهمة إرسال فيلق حراسة الكنز الخاص (EscortTreasureTask).")
    parser.add_argument("--email", required=True, help="إيميل الحساب")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري إذا كانت في session_cache)")
    parser.add_argument("--no-free-refresh", action="store_true", help="تعطيل التحديث المجاني للعربة قبل الإرسال")
    parser.add_argument("--dry-run", action="store_true", help="محاكاة الفحوصات والتشكيل بدون تحديث العربة أو إرسال الفيلق")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()