# -*- coding: utf-8 -*-
"""
مهمة مساعدة الموارد المستمرة (ResourceHelpTask) — تعمل عبر MarchManagerTask وترث دواله بالكامل.

تتبع سورس كود اللعبة في game_file حرفياً:
  - البروتوكول الرسمي (mapDef.lua:328, 385, 414 & worldMapFunction.lua:302-304 & marketViewPanel.lua:216-252):
      * CMD 1007/2 (ADD_KINGDOM_QUEUE)
      * moveLineType = 5 (moveLineTypeResourceHelp)
      * matrixType   = 4 (moveLineMatrixTypeTrade)
      * data.data    = {"resourceList": [{"id": 1002, "num": ...}, ...]}
      * بدون جنود أو أبطال (army=[], heroInfo=[]) — تحتاج خانة فيلق شاغرة فقط.
  - سعة النقلة الواحدة من السوق عبر الدالة الجاهزة self.get_resource_help_transport_capacity()
    في MarchManagerTask (build112.lua + علم التحالف 33002).
  - الموارد القابلة للنقل هي الموارد غير المحمية فقط: normalRes = totalRes - safeRes
    (cityCtrl.lua:623-632, 782-798).
  - فحص حصة الاستلام اليومية للقلعة المستلمة عبر CMD 1001/10 (REQ_LEFT_CAN_GET_RES | cityCtrl.lua:1157-1186)
    مع معالجة دقيقة لردود السيرفر (بما في ذلك حالة عدم وجود سقف استلام Err_NOT_LESS_3_LV دون تضليل).
  - توزيع سعة الوزن المتاحة في كل قافلة **بالتساوي** على جميع الموارد المحددة من المستخدم،
    مع إعادة توزيع أي فائض وزن تلقائياً بالتساوي على بقية الموارد عند نقص أحدها.
  - الإرسال المستمر بدون حد زمني افتراضياً (max_minutes=0) مع انتظار ذكي مبني على أقرب وقت عودة
    فعلي لقوافل المساعدة حتى نفاد الموارد القابلة للنقل أو حصة الاستلام للهدف.

أمثلة الاختبار المباشر من الطرفية:
  python tasks/resource_help.py --email beetoo3@hotmail.com --x 395 --y 420 --resources food,wood,iron --dry-run
  python tasks/resource_help.py --email beetoo3@hotmail.com --x 395 --y 420 --resources food,wood,iron
  python tasks/resource_help.py --email beetoo3@hotmail.com --x 395 --y 420 --resources wood --keep-reserve 50000
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
from typing import Any, Callable, Dict, List, Optional, Sequence, Tuple, Union

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from tasks.base_task import ConnectionCircuitBreakerError, TaskResult
from tasks.march_manager import BUILD_ID_MARKET, MarchManagerTask

# ---------------------------------------------------------------------------
# ثوابت بروتوكول مساعدة الموارد الرسمية (mapDef.lua, cmdDef.lua, marketViewPanel.lua)
# ---------------------------------------------------------------------------
RESOURCE_HELP_MOVE_LINE_TYPE = 5        # gMapMoveLineType.moveLineTypeResourceHelp (mapDef.lua:385)
RESOURCE_HELP_MATRIX_TYPE = 4           # gMapMoveLineMatrixType.moveLineMatrixTypeTrade (mapDef.lua:414)
RESOURCE_HELP_SERVER_QUEUE_TYPE = 7     # gMapMoveLineServerType.moveLineTypeResourceHelp (mapDef.lua:328)

CMD_CITY_MODULE = "1001"                # gCmd.CMD_CITY_MODULE (cmdDef.lua:6)
REQ_LEFT_CAN_GET_RES = "10"             # gCmd.REQ_LEFT_CAN_GET_RES (cmdDef.lua:16)

CMD_KINGDOM_MAP = "1006"
SUBCMD_MAP_SYNC = "1000"
REQ_GET_CASTLE_MAP_INFO = "25"          # gCmd.REQ_GET_CASTLE_MAP_INFO (cmdDef.lua:130)

# أوزان ومستويات فتح الموارد الرسمية في السوق (marketViewPanel.lua:34-48)
MARKET_RESOURCES_SPEC: Dict[int, Dict[str, Any]] = {
    1002: {"id": 1002, "key": "food",    "name_ar": "قمح",     "weight": 1,  "unlock_level": 1},
    1003: {"id": 1003, "key": "wood",    "name_ar": "خشب",     "weight": 1,  "unlock_level": 1},
    1004: {"id": 1004, "key": "iron",    "name_ar": "حديد",    "weight": 6,  "unlock_level": 10},
    1005: {"id": 1005, "key": "silver",  "name_ar": "فضة",     "weight": 24, "unlock_level": 15},
    1006: {"id": 1006, "key": "crystal", "name_ar": "كريستال", "weight": 96, "unlock_level": 30},
}

MARKET_RESOURCE_INPUT_ALIASES: Dict[str, int] = {
    "1002": 1002, "2": 1002, "food": 1002, "wheat": 1002, "قمح": 1002, "طعام": 1002,
    "1003": 1003, "3": 1003, "wood": 1003, "خشب": 1003,
    "1004": 1004, "4": 1004, "iron": 1004, "حديد": 1004,
    "1005": 1005, "5": 1005, "silver": 1005, "mithril": 1005, "فضة": 1005,
    "1006": 1006, "6": 1006, "crystal": 1006, "بلور": 1006, "كريستال": 1006,
}

# نسبة ضريبة السوق الرسمية حسب المستوى (build112.lua: Lv1=45%..Lv25=21%, Lv26=19%, Lv27=17%, Lv28=15%, Lv29=13%, Lv30=10%)
MARKET_TAX_RATE_BY_LEVEL: Dict[int, float] = {
    0: 0.45,
    **{lv: round((460 - 10 * lv) / 1000.0, 4) for lv in range(1, 26)},
    26: 0.19, 27: 0.17, 28: 0.15, 29: 0.13, 30: 0.10,
}

MAX_SMART_SLEEP_CHUNK_SEC = 60.0  # أقصى مدة نوم في الدورة الواحدة لإبقاء الفحص سريعاً والاتصال نشطاً


class ResourceHelpTask(MarchManagerTask):
    """
    مهمة إرسال مساعدة الموارد المستمرة بالتساوي عبر مبنى السوق حتى نفاد الحصة القابلة للنقل.
    """

    name: str = "resource_help"
    alias: str = "res_help"

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
        self.name = "resource_help"

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
    def _safe_float(val: Any, default: float = 0.0) -> float:
        try:
            if val is None or isinstance(val, bool):
                return default
            return float(val)
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
    def _parse_selected_resources(cls, raw: Any) -> List[int]:
        """تحويل قائمة الموارد المحددة من المستخدم إلى معرفات رسمية فريدة (1002..1006)."""
        tokens: List[str] = []
        if isinstance(raw, str):
            for part in raw.replace("،", ",").replace(";", ",").split(","):
                p = part.strip().lower()
                if p:
                    tokens.append(p)
        elif isinstance(raw, (list, tuple, set)):
            for item in raw:
                p = str(item).strip().lower()
                if p:
                    tokens.append(p)
        elif isinstance(raw, int):
            tokens.append(str(raw))

        result: List[int] = []
        for tok in tokens:
            if tok in ("all", "الكل"):
                for rid in (1002, 1003, 1004, 1005, 1006):
                    if rid not in result:
                        result.append(rid)
                continue
            rid = MARKET_RESOURCE_INPUT_ALIASES.get(tok)
            if rid and rid not in result:
                result.append(rid)
        return result

    def _get_target_coords(self) -> Tuple[int, int]:
        tx = self._safe_int(self.config.get("target_x", self.config.get("x")), -1)
        ty = self._safe_int(self.config.get("target_y", self.config.get("y")), -1)
        return tx, ty

    def _get_my_alliance_id(self) -> int:
        snap = self._get_live_snapshot()
        alliance_ctrl = snap.get("allianceCtrl")
        if not isinstance(alliance_ctrl, dict):
            return 0
        aid = self._safe_int(alliance_ctrl.get("aid") or alliance_ctrl.get("allianceId"), 0)
        if aid <= 0:
            minfo = alliance_ctrl.get("memberinfo") or alliance_ctrl.get("memberInfo") or {}
            if isinstance(minfo, dict):
                inner = minfo.get("minfo") if isinstance(minfo.get("minfo"), dict) else minfo
                aid = self._safe_int(inner.get("aid") or inner.get("allianceId"), 0)
        return max(0, aid)

    def _get_market_level_and_tax(self) -> Tuple[int, float]:
        """قراءة مستوى مبنى السوق (bid=112) ونسبة الضريبة الرسمية (build112.lua)."""
        snap = self._get_live_snapshot()
        city_ctrl = snap.get("cityCtrl")
        blist = city_ctrl.get("blist") if isinstance(city_ctrl, dict) else None
        market_lv = 0
        if isinstance(blist, list):
            for entry in blist:
                if not isinstance(entry, dict):
                    continue
                binfo = entry.get("binfo") if isinstance(entry.get("binfo"), dict) else entry
                if self._safe_int(binfo.get("bid"), 0) == BUILD_ID_MARKET:
                    market_lv = max(market_lv, self._safe_int(binfo.get("lv"), 0))
        tax_rate = MARKET_TAX_RATE_BY_LEVEL.get(market_lv, 0.10 if market_lv > 30 else 0.45)
        return market_lv, tax_rate

    def _get_sender_normal_resources(self, keep_reserve: int = 0) -> Dict[int, Dict[str, int]]:
        """
        قراءة الموارد غير المحمية القابلة للنقل في القلعة المرسلة (0-Network)
        مطابق 100% لـ cityCtrl:getNormalRes(resid) (cityCtrl.lua:623-632, 782-798):
          normal = max(0, floor(resList[rid]) - floor(saferes[rid]) - keep_reserve)
        """
        snap = self._get_live_snapshot()
        city_ctrl = snap.get("cityCtrl")
        if not isinstance(city_ctrl, dict):
            city_ctrl = {}

        res_list = city_ctrl.get("resList") or city_ctrl.get("reslist") or {}
        safe_res_map = city_ctrl.get("saferes") or city_ctrl.get("safeRes") or {}
        if not isinstance(res_list, dict):
            res_list = {}
        if not isinstance(safe_res_map, dict):
            safe_res_map = {}

        reserve = max(0, int(keep_reserve))
        out: Dict[int, Dict[str, int]] = {}
        for rid in MARKET_RESOURCES_SPEC:
            key = str(rid)
            total_val = math.floor(self._safe_float(res_list.get(key, res_list.get(rid, 0)), 0.0))
            safe_val = math.floor(self._safe_float(safe_res_map.get(key, safe_res_map.get(rid, 0)), 0.0))
            normal_val = max(0, total_val - safe_val)
            sendable_val = max(0, normal_val - reserve)
            out[rid] = {
                "total": total_val,
                "safe": safe_val,
                "normal": normal_val,
                "sendable": sendable_val,
            }
        return out

    def _get_active_resource_help_queues(self) -> List[Dict[str, Any]]:
        """إرجاع جميع قوافل مساعدة الموارد النشطة بالخارج (type=7 / moveLineType=5)."""
        active: List[Dict[str, Any]] = []
        for q, _st in self._iter_my_active_queues():
            q_type = self._safe_int(q.get("type") or q.get("queueType"), 0)
            m_type = self._safe_int(q.get("moveLineType"), 0)
            if q_type == RESOURCE_HELP_SERVER_QUEUE_TYPE or m_type == RESOURCE_HELP_MOVE_LINE_TYPE:
                active.append(q)
        return active

    def _get_earliest_resource_help_return_sec(self) -> Optional[float]:
        """حساب أقرب زمن عودة فعلي (بالثواني) لأقرب قافلة مساعدة موارد نشطة من local_queues."""
        queues = self._get_active_resource_help_queues()
        if not queues:
            return None
        now_ts = time.time()
        earliest: Optional[float] = None
        for q in queues:
            ft = self._safe_float(q.get("finishTime") or q.get("endTime") or q.get("finish_time"), 0.0)
            if ft > 1e11:
                ft /= 1000.0
            rem = max(1.0, ft - now_ts) if ft > 0 else 15.0
            if earliest is None or rem < earliest:
                earliest = rem
        return earliest

    # ------------------------------------------------------------------
    # الفحص المسبق (0-Network)
    # ------------------------------------------------------------------

    async def can_run(self) -> Tuple[bool, str]:
        if not self.is_active:
            return False, "مهمة مساعدة الموارد معطلة في الإعدادات."

        selected = self._parse_selected_resources(self.config.get("resources", self.config.get("resource")))
        if not selected:
            return False, "يجب تحديد مورد واحد على الأقل للمساعدة (food/wood/iron/silver/crystal)."

        tx, ty = self._get_target_coords()
        if tx < 0 or ty < 0:
            return False, "يجب تحديد إحداثيات صالحة للقلعة المستلمة (target_x, target_y)."

        cx, cy, _kid = self._get_castle_coords_and_kingdom()
        if cx == tx and cy == ty:
            return False, "لا يمكن إرسال مساعدة موارد إلى إحداثيات قلعتك نفسها."

        if self._get_my_alliance_id() <= 0:
            return False, "القلعة لا تنتمي إلى تحالف حالياً؛ مساعدة الموارد متاحة لأعضاء التحالف فقط."

        transport_cap = self.get_resource_help_transport_capacity()
        if transport_cap <= 0:
            return False, "مبنى السوق غير متوفر أو سعة النقل تساوي 0."

        keep_reserve = self._safe_int(self.config.get("keep_reserve", 0), 0)
        res_state = self._get_sender_normal_resources(keep_reserve=keep_reserve)
        sender_lv = max(1, self._safe_int(getattr(self, "castle_level", 1), 1))
        has_any_sendable = any(
            sender_lv >= MARKET_RESOURCES_SPEC[rid]["unlock_level"]
            and res_state[rid]["sendable"] >= 1
            and MARKET_RESOURCES_SPEC[rid]["weight"] <= transport_cap
            for rid in selected
        )
        if not has_any_sendable:
            return False, "لا توجد موارد غير محمية متاحة للنقل من الموارد المحددة حالياً."

        has_slot = self.has_available_march(require_soldiers=False)
        has_active_help = len(self._get_active_resource_help_queues()) > 0
        if not has_slot and not has_active_help:
            return False, "لا توجد خانة فيلق شاغرة حالياً، ولا توجد قافلة مساعدة موارد نشطة بالخارج."

        return True, "جاهز لتنفيذ مهمة مساعدة الموارد."

    # ------------------------------------------------------------------
    # تحديد القلعة الهدف من الإحداثيات (1006/1000) وفحص حصة الاستلام (1001/10)
    # ------------------------------------------------------------------

    def _find_castle_at_coords_in_map(self, tx: int, ty: int) -> Optional[Dict[str, Any]]:
        """البحث الحرفي الدقيق عن قلعة لاعب (mapObjTypePlayer = 4 | mapDef.lua:8) عند (tx, ty) فقط لمنع الخلط مع الجيران."""
        km = self.get_ctrl("kingdomMapCtrl")
        if not isinstance(km, dict):
            return None

        exact_match: Optional[Dict[str, Any]] = None

        def _record_if_exact(ox: int, oy: int, inst_id: str, obj: Dict[str, Any], parts: List[str]) -> None:
            nonlocal exact_match
            if ox != tx or oy != ty:
                return
            p_info = obj.get("playerInfo") if isinstance(obj.get("playerInfo"), dict) else {}
            uid = str(
                obj.get("uid")
                or obj.get("playerID")
                or obj.get("ownerId")
                or p_info.get("uid")
                or p_info.get("playerID")
                or (parts[4] if len(parts) >= 5 and parts[4] != "0" else "")
                or ""
            ).strip()
            lv = self._safe_int(
                obj.get("level") or obj.get("cityLv") or obj.get("lv") or p_info.get("cityLv") or p_info.get("level"),
                0,
            )
            aid = self._safe_int(
                obj.get("aid") or obj.get("allianceId") or obj.get("leagueId") or p_info.get("aid"),
                0,
            )
            nick = str(
                obj.get("nickName") or obj.get("name") or obj.get("playerName") or p_info.get("nickName") or ""
            ).strip()
            exact_match = {
                "x": ox,
                "y": oy,
                "instance_id": inst_id,
                "uid": uid,
                "level": lv,
                "aid": aid,
                "nick_name": nick,
            }

        def _walk(obj: Any, depth: int = 0) -> None:
            if exact_match is not None or depth > 10 or obj is None:
                return
            if isinstance(obj, list):
                for item in obj:
                    _walk(item, depth + 1)
                return
            if not isinstance(obj, dict):
                return

            obj_id = str(obj.get("id") or obj.get("mapObjId") or "").strip()
            parts = obj_id.split("-") if "-" in obj_id else []
            is_player_by_id = len(parts) >= 5 and parts[2] == "4"
            obj_type = self._safe_int(obj.get("type", obj.get("mapType", 0)), 0)

            if is_player_by_id or obj_type == 4:
                if is_player_by_id:
                    ox = max(0, self._safe_int(parts[0], 0) - 1)
                    oy = max(0, self._safe_int(parts[1], 0) - 1)
                    inst_id = obj_id
                else:
                    ox = self._safe_int(obj.get("x"), -1)
                    oy = self._safe_int(obj.get("y"), -1)
                    uid_tmp = str(obj.get("uid") or obj.get("playerID") or "").strip()
                    inst_id = obj_id if "-" in obj_id else (f"{ox + 1}-{oy + 1}-4-0-{uid_tmp}" if uid_tmp else "")
                if inst_id and ox >= 0 and oy >= 0:
                    _record_if_exact(ox, oy, inst_id, obj, parts)

            for k, v in obj.items():
                if isinstance(k, str) and "-" in k:
                    kp = k.split("-")
                    if len(kp) >= 5 and kp[2] == "4":
                        ox = max(0, self._safe_int(kp[0], 0) - 1)
                        oy = max(0, self._safe_int(kp[1], 0) - 1)
                        _record_if_exact(ox, oy, k, v if isinstance(v, dict) else {}, kp)
                if isinstance(v, (dict, list)):
                    _walk(v, depth + 1)

        _walk(km)
        return exact_match

    async def _resolve_target_castle(self, tx: int, ty: int, kid: int) -> Tuple[Optional[Dict[str, Any]], str]:
        """مزامنة حية للخريطة حول (tx, ty) ثم استخراج بيانات القلعة والتحقق من عدم انتقالها."""
        await self.safe_query(
            CMD_KINGDOM_MAP,
            SUBCMD_MAP_SYNC,
            {"centerKid": kid, "centerX": tx, "centerY": ty, "lod": 1},
            min_delay=0.3,
            max_delay=0.6,
        )

        # انتظار ذكي لوصول NOTIFY_MAP_SYNC (201) حتى 2.5 ثانية بدلاً من نوم ثابت قد لا يكفي
        target: Optional[Dict[str, Any]] = None
        wait_end = time.monotonic() + 2.5
        while time.monotonic() < wait_end:
            target = self._find_castle_at_coords_in_map(tx, ty)
            if target:
                break
            await asyncio.sleep(0.15)

        if not target:
            return None, f"لم يتم العثور على قلعة لاعب عند الإحداثيات ({tx}, {ty}) في المملكة {kid} (ربما انتقلت أو الإحداثيات فارغة)."

        # التحقق الرسمي عبر CMD 1006/25 (REQ_GET_CASTLE_MAP_INFO) لتأكيد الموقع الحالي والمستوى والاسم
        uid_int = self._safe_int(target.get("uid"), 0)
        if uid_int > 0:
            info_resp = await self.safe_query(
                CMD_KINGDOM_MAP,
                REQ_GET_CASTLE_MAP_INFO,
                {"uid": uid_int},
                min_delay=0.25,
                max_delay=0.55,
            )
            if isinstance(info_resp, dict) and self._extract_err_code(info_resp) == "0":
                rd = info_resp.get("retData") or info_resp.get("data") or info_resp.get("result") or {}
                if isinstance(rd, dict):
                    rx = self._safe_int(rd.get("x"), tx)
                    ry = self._safe_int(rd.get("y"), ty)
                    if (rx != tx or ry != ty) and (rx > 0 or ry > 0):
                        return None, f"القلعة عند ({tx}, {ty}) انتقلت فعلياً إلى ({rx}, {ry}) — تم الإيقاف لحماية الموارد."
                    if rd.get("id"):
                        target["instance_id"] = str(rd["id"])
                    if rd.get("level"):
                        target["level"] = self._safe_int(rd["level"], target.get("level", 0))
                    if rd.get("nickName"):
                        target["nick_name"] = str(rd["nickName"])
                    if rd.get("aid"):
                        target["aid"] = self._safe_int(rd["aid"], target.get("aid", 0))

        return target, "ok"
        
    async def _fetch_target_receive_quota(self, target_uid: str) -> Dict[str, Any]:
        """
        فحص حصة الاستلام اليومية المتبقية للقلعة المستلمة عبر CMD 1001/10 (REQ_LEFT_CAN_GET_RES)
        مطابق 100% لـ cityCtrl.lua:1157-1186 و marketViewPanel.lua:100, 159-162, 253-272:
          - err == "0" ووجود leftCanGetRes: حصة يومية فعالة وموثّقة من السيرفر (بالمقدار الصافي بعد الضريبة).
          - err != "0" (مثل Err_NOT_LESS_3_LV): السيرفر لا يفرض سقف استلام يومي على هذه القلعة.
        """
        if not target_uid:
            return {
                "has_limit": False,
                "quotas": {},
                "status_note": "لم يتوفر UID للقلعة المستلمة؛ تعذر فحص حصة الاستلام اليومية.",
            }

        uid_int = self._safe_int(target_uid, 0)
        resp = await self.safe_query(
            CMD_CITY_MODULE,
            REQ_LEFT_CAN_GET_RES,
            {"uid": uid_int if uid_int > 0 else target_uid},
            min_delay=0.25,
            max_delay=0.55,
        )
        err = self._extract_err_code(resp)
        if err == "1022":
            return {
                "has_limit": False,
                "err": err,
                "quotas": {},
                "status_note": "لا يوجد سقف استلام يومي مفروض على هذه القلعة (Err_NOT_LESS_3_LV — حالة طبيعية).",
            }
        if err != "0":
            return {
                "has_limit": False,
                "err": err,
                "quotas": {},
                "status_note": f"تعذر قراءة سقف الاستلام (1001/10: err={err}) — المتابعة حسب موارد القلعة غير المحمية.",
            }

        data_box = resp.get("data") if isinstance(resp, dict) and isinstance(resp.get("data"), dict) else {}
        if not data_box and isinstance(resp, dict):
            data_box = resp.get("rspdata") or resp.get("result") or resp

        raw_left = data_box.get("leftCanGetRes") if isinstance(data_box, dict) else None
        if not isinstance(raw_left, dict) or not raw_left:
            return {
                "has_limit": False,
                "quotas": {},
                "status_note": "رد 1001/10 لم يتضمن جدول leftCanGetRes (لا يوجد سقف استلام نشط).",
            }

        quotas: Dict[int, int] = {}
        for k, v in raw_left.items():
            rid = self._safe_int(k, 0)
            if rid in MARKET_RESOURCES_SPEC:
                quotas[rid] = max(0, math.floor(self._safe_float(v, 0.0)))

        return {
            "has_limit": bool(quotas),
            "quotas": quotas,
            "status_note": "تمت قراءة حصة الاستلام اليومية للقلعة المستلمة بدقة من السيرفر (1001/10).",
        }

    # ------------------------------------------------------------------
    # توزيع سعة القافلة بالتساوي على كل الموارد المحددة (Equal-Weight Water-Filling)
    # ------------------------------------------------------------------

    @staticmethod
    def pack_equal_weight_caravan(
        transport_capacity: int,
        selected_rids: Sequence[int],
        max_gross_units_by_rid: Dict[int, int],
    ) -> Dict[str, Any]:
        """
        توزيع سعة الوزن المتاحة في النقلة الواحدة **بالتساوي** على جميع الموارد المحددة
        التي تملك رصيداً قابلاً للنقل، مع إعادة توزيع أي فائض وزن بالتساوي على بقية الموارد
        إذا كان أحد الموارد أقل من حصته المتساوية.
        """
        cap = max(0, int(transport_capacity))
        if cap <= 0:
            return {"resource_list": [], "allocations": {}, "used_weight": 0, "capacity": 0}

        active: List[int] = [
            rid for rid in selected_rids
            if rid in MARKET_RESOURCES_SPEC
            and max_gross_units_by_rid.get(rid, 0) >= 1
            and MARKET_RESOURCES_SPEC[rid]["weight"] <= cap
        ]
        if not active:
            return {"resource_list": [], "allocations": {}, "used_weight": 0, "capacity": cap}

        allocations: Dict[int, int] = {rid: 0 for rid in active}
        remaining_weight = cap
        pool = list(active)

        # خوارزمية التوزيع المتساوي مع إعادة توزيع الفائض (Water-Filling)
        while pool and remaining_weight > 0:
            equal_share = remaining_weight // len(pool)
            if equal_share <= 0:
                break

            capped_any = False
            next_pool: List[int] = []

            for rid in pool:
                w = MARKET_RESOURCES_SPEC[rid]["weight"]
                max_u = max_gross_units_by_rid.get(rid, 0)
                max_w = max_u * w
                if max_w <= equal_share:
                    allocations[rid] = max_u
                    remaining_weight -= max_w
                    capped_any = True
                else:
                    next_pool.append(rid)

            if capped_any:
                pool = next_pool
                continue

            # لا يوجد مورد محدود بأقل من حصته المتساوية -> كل مورد يأخذ حصته المتساوية بالضبط
            for rid in pool:
                w = MARKET_RESOURCES_SPEC[rid]["weight"]
                units = equal_share // w
                if units > 0:
                    allocations[rid] = units
                    remaining_weight -= units * w
            break

        # استغلال أي بقايا وزن صغيرة جداً (أقل من len(pool) أو ناتجة عن القسمة الصحيحة) بالتساوي
        if remaining_weight > 0:
            made_progress = True
            while made_progress and remaining_weight > 0:
                made_progress = False
                for rid in active:
                    w = MARKET_RESOURCES_SPEC[rid]["weight"]
                    if w <= remaining_weight and allocations[rid] < max_gross_units_by_rid.get(rid, 0):
                        allocations[rid] += 1
                        remaining_weight -= w
                        made_progress = True

        resource_list = [
            {"id": int(rid), "num": int(allocations[rid])}
            for rid in selected_rids
            if allocations.get(rid, 0) > 0
        ]
        used_weight = sum(
            allocations[rid] * MARKET_RESOURCES_SPEC[rid]["weight"]
            for rid in allocations
            if allocations[rid] > 0
        )

        return {
            "resource_list": resource_list,
            "allocations": {rid: cnt for rid, cnt in allocations.items() if cnt > 0},
            "used_weight": used_weight,
            "capacity": cap,
        }

    # ------------------------------------------------------------------
    # التنفيذ الرئيسي (إرسال مستمر بدون حد زمني حتى نفاد الحصة القابلة للنقل)
    # ------------------------------------------------------------------

    async def run(self) -> TaskResult:
        dry_run = bool(self.config.get("dry_run", False))
        keep_reserve = max(0, self._safe_int(self.config.get("keep_reserve", 0), 0))
        respect_target_limit = bool(self.config.get("respect_target_limit", True))
        # افتراضياً بلا حد زمني (0 = مفتوح حتى انتهاء الحصة) كما طلب المستخدم
        max_minutes = max(0.0, self._safe_float(self.config.get("max_minutes", 0.0), 0.0))
        deadline: Optional[float] = (time.monotonic() + max_minutes * 60.0) if max_minutes > 0 else None

        # 1) الفحص المسبق (0-Network)
        ok_pre, pre_reason = await self.can_run()
        if not ok_pre:
            self.log(f"⏭️ [مساعدة الموارد] {pre_reason}")
            return TaskResult(success=False, skipped=True, message=pre_reason)

        selected_rids = self._parse_selected_resources(self.config.get("resources", self.config.get("resource")))
        tx, ty = self._get_target_coords()
        cx, cy, kid = self._get_castle_coords_and_kingdom()
        my_aid = self._get_my_alliance_id()
        my_uid = str(getattr(self, "uid", "") or "").strip()

        market_lv, tax_rate = self._get_market_level_and_tax()
        transport_cap = self.get_resource_help_transport_capacity()
        sender_lv = max(1, self._safe_int(getattr(self, "castle_level", 1), 1))

        res_names_str = " + ".join(MARKET_RESOURCES_SPEC[r]["name_ar"] for r in selected_rids)
        self.log(
            f"🚚 [مساعدة الموارد] بدء المهمة نحو ({tx}, {ty}) | الموارد: [{res_names_str}] (توزيع متساوٍ) | "
            f"السوق Lv.{market_lv} | سعة النقلة: {transport_cap:,} | الضريبة: {tax_rate * 100:.0f}% | "
            f"الفيالق الشاغرة: {self.get_available_marches_count()}"
        )

        # 2) تحديد قلعة الهدف الرسمية والتحقق من التحالف ومستوى القلعة
        target, resolve_msg = await self._resolve_target_castle(tx, ty, kid)
        if not target:
            self.log(f"⚠️ [مساعدة الموارد] {resolve_msg}")
            return TaskResult(success=False, skipped=True, message=resolve_msg)

        target_uid = str(target.get("uid") or "").strip()
        target_aid = self._safe_int(target.get("aid"), 0)
        target_lv = self._safe_int(target.get("level"), 0)
        target_inst_id = str(target.get("instance_id") or "").strip()
        target_nick = str(target.get("nick_name") or target_uid or f"({tx},{ty})")

        if my_uid and target_uid and target_uid == my_uid:
            msg = "القلعة الهدف عند هذه الإحداثيات هي قلعتك نفسها — تم الإلغاء."
            self.log(f"⏭️ [مساعدة الموارد] {msg}")
            return TaskResult(success=False, skipped=True, message=msg)

        if my_aid > 0 and target_aid > 0 and target_aid != my_aid:
            msg = f"القلعة '{target_nick}' عند ({tx}, {ty}) ليست في نفس تحالفك (تحالفك={my_aid}، تحالفها={target_aid})."
            self.log(f"⏭️ [مساعدة الموارد] {msg}")
            return TaskResult(success=False, skipped=True, message=msg)

        # تصفية الموارد المفتوحة للقلعتين (المرسلة والمستلمة)
        unlocked_rids: List[int] = []
        for rid in selected_rids:
            req_lv = MARKET_RESOURCES_SPEC[rid]["unlock_level"]
            if sender_lv < req_lv:
                self.log(
                    f"🔒 [مساعدة الموارد] استبعاد ({MARKET_RESOURCES_SPEC[rid]['name_ar']}): "
                    f"قلعتك مستوى {sender_lv} < {req_lv}."
                )
                continue
            if target_lv > 0 and target_lv < req_lv:
                self.log(
                    f"🔒 [مساعدة الموارد] استبعاد ({MARKET_RESOURCES_SPEC[rid]['name_ar']}): "
                    f"القلعة المستلمة '{target_nick}' مستوى {target_lv} < {req_lv}."
                )
                continue
            unlocked_rids.append(rid)

        if not unlocked_rids:
            msg = "جميع الموارد المحددة مقفلة لمستوى القلعة المرسلة أو المستلمة."
            self.log(f"⏭️ [مساعدة الموارد] {msg}")
            return TaskResult(success=False, skipped=True, message=msg)

        # 3) فحص حصة الاستلام اليومية الدقيقة للقلعة المستلمة عبر CMD 1001/10
        quota_info = await self._fetch_target_receive_quota(target_uid)
        self.log(f"📋 [مساعدة الموارد] {quota_info['status_note']}")
        target_quotas_net: Optional[Dict[int, int]] = (
            dict(quota_info["quotas"]) if (respect_target_limit and quota_info.get("has_limit")) else None
        )
        if target_quotas_net is not None:
            q_parts = [
                f"{MARKET_RESOURCES_SPEC[r]['name_ar']}: {target_quotas_net.get(r, 0):,}"
                for r in unlocked_rids
                if r in target_quotas_net
            ]
            if q_parts:
                self.log(f"📊 [مساعدة الموارد] الحصة الصافية المتبقية لاستلام '{target_nick}': {' | '.join(q_parts)}")

        # 4) الحلقة المستمرة حتى انتهاء الحصة القابلة للنقل
        sent_trips = 0
        total_sent_by_rid: Dict[int, int] = {rid: 0 for rid in unlocked_rids}
        consecutive_errors = 0
        stop_reason = ""
        net_factor = max(0.01, 1.0 - tax_rate)

        while True:
            if deadline is not None and time.monotonic() >= deadline:
                stop_reason = f"انتهت المهلة المحددة ({max_minutes:g} دقيقة)."
                break

            # قراءة الموارد غير المحمية الحية من الذاكرة قبل كل قافلة (0-Network)
            live_res = self._get_sender_normal_resources(keep_reserve=keep_reserve)
            max_gross_by_rid: Dict[int, int] = {}
            exhausted_by_target_quota = True
            exhausted_by_sender_res = True

            for rid in unlocked_rids:
                sender_avail = live_res[rid]["sendable"]
                if sender_avail > 0:
                    exhausted_by_sender_res = False

                allowed_gross = sender_avail
                min_gross_for_1_net = int(math.ceil(1.0 / net_factor))
                if target_quotas_net is not None and rid in target_quotas_net:
                    left_net = target_quotas_net[rid]
                    max_gross_for_target = int(math.floor(left_net / net_factor))
                    if left_net >= 1 and max_gross_for_target >= min_gross_for_1_net:
                        exhausted_by_target_quota = False
                        allowed_gross = min(allowed_gross, max_gross_for_target)
                    else:
                        allowed_gross = 0
                else:
                    exhausted_by_target_quota = False

                max_gross_by_rid[rid] = max(0, allowed_gross)

            # تعبئة القافلة بالتساوي على كل الموارد المتبقية
            live_cap = self.get_resource_help_transport_capacity()
            pack = self.pack_equal_weight_caravan(
                transport_capacity=live_cap,
                selected_rids=unlocked_rids,
                max_gross_units_by_rid=max_gross_by_rid,
            )

            if not pack["resource_list"]:
                if target_quotas_net is not None and exhausted_by_target_quota and not exhausted_by_sender_res:
                    stop_reason = f"انتهت حصة الاستلام اليومية للقلعة المستلمة '{target_nick}' لجميع الموارد المحددة."
                else:
                    stop_reason = "انتهت جميع الموارد غير المحمية القابلة للنقل في القلعة."
                break

            # فحص توفر فيلق شاغر (لا تحتاج جنوداً)
            if not dry_run and not self.has_available_march(require_soldiers=False):
                active_help = self._get_active_resource_help_queues()
                if not active_help:
                    stop_reason = "نفدت الفيالق الشاغرة ولا توجد قافلة مساعدة موارد نشطة بالخارج — إيقاف المهمة."
                    break

                sleep_sec = 60.0  # انتظار ثابت: دقيقة كاملة
                if deadline is not None:
                    rem_dl = deadline - time.monotonic()
                    if rem_dl <= 2.0:
                        stop_reason = f"انتهت المهلة المحددة ({max_minutes:g} دقيقة)."
                        break
                    sleep_sec = min(sleep_sec, rem_dl)

                self.log(
                    f"⏳ [مساعدة الموارد] الفيالق ممتلئة ({len(active_help)} قافلة مساعدة بالخارج) — "
                    f"انتظار ثابت {int(sleep_sec)}ث قبل إعادة الفحص..."
                )
                await asyncio.sleep(sleep_sec)
                continue

            load_summary = " + ".join(
                f"{MARKET_RESOURCES_SPEC[item['id']]['name_ar']}: {item['num']:,}"
                for item in pack["resource_list"]
            )

            if dry_run:
                msg = (
                    f"[DRY-RUN] جاهز لإرسال قافلة متساوية الوزن إلى '{target_nick}' ({tx}, {ty}) | "
                    f"الحمولة ({pack['used_weight']:,}/{pack['capacity']:,}): {load_summary}"
                )
                self.log(f"🧪 [مساعدة الموارد] {msg}")
                return TaskResult(
                    success=True,
                    message=msg,
                    data={
                        "dry_run": True,
                        "target": target,
                        "tax_rate": tax_rate,
                        "quota_info": quota_info,
                        "sample_caravan": pack,
                    },
                )

            # الإرسال الرسمي عبر CMD 1007/2 (مطابق لـ marketViewPanel.lua:245-250 و worldMapFunction.lua:206-222)
            # في Lua تكون army/heroInfo/armsInfo/divineBeastInfo قيمتها nil فتُحذف تماماً ولا تُرسل كـ []
            payload = {
                "moveLineType": RESOURCE_HELP_MOVE_LINE_TYPE,
                "matrixType": RESOURCE_HELP_MATRIX_TYPE,
                "data": {
                    "to": {
                        "x": target["x"],
                        "y": target["y"],
                        "id": target_inst_id,
                    },
                    "mapId": int(kid),
                    "isDuel": False,
                    "isForbidSpeed": False,
                    "data": {
                        "resourceList": pack["resource_list"],
                    },
                },
            }

            prev_totals = {item["id"]: live_res[item["id"]]["total"] for item in pack["resource_list"]}
            prev_help_cnt = len(self._get_active_resource_help_queues())

            await asyncio.sleep(random.uniform(0.3, 0.7))
            self.log(
                f"🚀 [مساعدة الموارد] قافلة #{sent_trips + 1} نحو '{target_nick}' ({tx}, {ty}) | "
                f"{load_summary} (وزن: {pack['used_weight']:,}/{pack['capacity']:,})"
            )
            resp = await self.safe_query("1007", "2", payload, min_delay=0.45, max_delay=0.95)
            err = self._extract_err_code(resp)
            if err != "0":
                consecutive_errors += 1
                self.log(f"⚠️ [مساعدة الموارد] رفض السيرفر إرسال القافلة (err={err}) [خطأ {consecutive_errors}/3].")
                if consecutive_errors >= 3:
                    stop_reason = f"توقف بعد 3 إخفاقات إرسال متتالية (آخر كود خطأ: {err})."
                    break
                # إعادة قراءة حصة الهدف فقط إذا كان عليها سقف فعلي (نتجنب تكرار 1001/10 عند err=1022)
                if respect_target_limit and target_uid and quota_info.get("err") != "1022":
                    refreshed_q = await self._fetch_target_receive_quota(target_uid)
                    if refreshed_q.get("has_limit"):
                        target_quotas_net = dict(refreshed_q["quotas"])
                await asyncio.sleep(random.uniform(1.0, 2.0))
                continue

            consecutive_errors = 0
            sent_trips += 1
            for item in pack["resource_list"]:
                rid = item["id"]
                gross = item["num"]
                total_sent_by_rid[rid] = total_sent_by_rid.get(rid, 0) + gross
                if target_quotas_net is not None and rid in target_quotas_net:
                    net_delivered = max(1, int(math.floor(gross * net_factor))) if gross > 0 else 0
                    target_quotas_net[rid] = max(0, target_quotas_net[rid] - net_delivered)

            # انتظار ذكي حتى ينعكس خصم الموارد أو ظهور الطابور في الذاكرة الحية (بحد أقصى 2ث)
            sync_end = time.monotonic() + 2.0
            while time.monotonic() < sync_end:
                cur_res = self._get_sender_normal_resources(keep_reserve=keep_reserve)
                res_updated = any(cur_res[rid]["total"] < prev_val for rid, prev_val in prev_totals.items())
                q_updated = len(self._get_active_resource_help_queues()) > prev_help_cnt
                if res_updated or q_updated:
                    break
                await asyncio.sleep(0.1)
            await asyncio.sleep(random.uniform(0.2, 0.45))

        totals_str = " | ".join(
            f"{MARKET_RESOURCES_SPEC[r]['name_ar']}: {cnt:,}"
            for r, cnt in total_sent_by_rid.items()
            if cnt > 0
        )
        if sent_trips > 0:
            msg = (
                f"تم إرسال {sent_trips} قافلة مساعدة موارد إلى '{target_nick}' ({tx}, {ty}) "
                f"[{totals_str}]. ({stop_reason})"
            )
            self.log(f"🏁 [مساعدة الموارد] {msg}")
            return TaskResult(
                success=True,
                message=msg,
                data={
                    "target": target,
                    "trips_sent": sent_trips,
                    "total_sent_by_rid": total_sent_by_rid,
                    "stop_reason": stop_reason,
                },
            )

        self.log(f"⏭️ [مساعدة الموارد] {stop_reason}")
        return TaskResult(
            success=False,
            skipped=True,
            message=stop_reason or "لم يتم إرسال أي قافلة مساعدة موارد.",
            data={"target": target, "trips_sent": 0, "stop_reason": stop_reason},
        )


# ===========================================================================
# مشغّل الطرفية للاختبار المباشر
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
            "target_x": args.x,
            "target_y": args.y,
            "resources": args.resources,
            "keep_reserve": args.keep_reserve,
            "respect_target_limit": not args.ignore_target_limit,
            "max_minutes": args.max_minutes,
            "dry_run": args.dry_run,
        }
        task = ResourceHelpTask(conn, config=cfg)
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

    parser = argparse.ArgumentParser(description="مهمة مساعدة الموارد المستمرة بالتساوي (ResourceHelpTask).")
    parser.add_argument("--email", required=True, help="إيميل الحساب المُرسل")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري إذا كانت في session_cache)")
    parser.add_argument("--x", type=int, required=True, help="إحداثي X للقلعة المستلمة")
    parser.add_argument("--y", type=int, required=True, help="إحداثي Y للقلعة المستلمة")
    parser.add_argument(
        "--resources",
        required=True,
        help="المورد أو الموارد مفصولة بفاصلة (مثال: food,wood,iron أو wood أو all)",
    )
    parser.add_argument("--keep-reserve", type=int, default=0, help="احتياطي يُترك في القلعة لكل مورد (افتراضي 0)")
    parser.add_argument("--ignore-target-limit", action="store_true", help="تجاهل حصة الاستلام اليومية للهدف (leftCanGetRes)")
    parser.add_argument("--max-minutes", type=float, default=0.0, help="الحد الزمني بالدقائق (افتراضي 0 = بلا حد زمني)")
    parser.add_argument("--dry-run", action="store_true", help="محاكاة حساب السعة وحصة الهدف وتوزيع أول قافلة بدون إرسال")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()