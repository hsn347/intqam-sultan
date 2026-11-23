# -*- coding: utf-8 -*-
"""
مهمة تفعيل مكافأة سرعة الجمع (GatherSpeedBuffTask) — تعمل عبر BaseTask بطلب شبكي واحد فقط (CMD 1004/2).

تتبع سورس كود اللعبة في game_file حرفياً:
  - العناصر الرسمية بالترتيب المطلوب (itemdescribe.lua & local_arab.json & buff.lua):
      1. 400101 : مكافأة الجمع الصغيرة  (+50% لمدة 8 ساعات  | buffID = 5008)
      2. 400102 : مكافأة الجمع الكبيرة  (+50% لمدة 24 ساعة | buffID = 5009)
      3. 402401 : مكافأة الجمع السوبر   (+100% لمدة 24 ساعة | buffID = 5048)
  - كل الفحوصات (فحص الباف النشط في buffCtrl/newBuffCtrl + فحص مخزون الحقيبة في backpackCtrl)
    تتم من الذاكرة الحية فقط (0-Network) بدون أي استعلام إضافي.
  - لا تُرسل سوى طلب شبكي واحد فقط عند الحاجة الفعلية: CMD 1004/2 ({"itemID": ..., "count": 1}).
  - بدون شراء بالذهب إطلاقاً، ومع حماية صارمة ضد استبدال باف سرعة جمع نشط (superposition = 0).

أمثلة الاختبار المباشر من الطرفية:
  python tasks/gather_speed_buff.py --email beetoo2@hotmail.com --dry-run
  python tasks/gather_speed_buff.py --email beetoo2@hotmail.com
"""
from __future__ import annotations

import argparse
import asyncio
import json
import os
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

_PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _PROJECT_ROOT not in sys.path:
    sys.path.insert(0, _PROJECT_ROOT)

from tasks.base_task import BaseTask, TaskResult

# ---------------------------------------------------------------------------
# ثوابت مكافأة سرعة الجمع الرسمية (itemdescribe.lua, buff.lua, buffDef.lua)
# ---------------------------------------------------------------------------
GATHER_SPEED_EFFECT_TYPE = 17  # gBuffEffect.GATHER_SPEED_BOOST (buffDef.lua:18)
CITY_BUFF_ORIGIN = 1           # gBuffSource.CITY (buff.lua)

# ترتيب الأولوية الصارم: الصغيرة -> الكبيرة -> السوبر
GATHER_BUFF_ITEMS_PRIORITY: Tuple[Dict[str, Any], ...] = (
    {
        "key": "small",
        "item_id": 400101,
        "buff_id": 5008,
        "name": "مكافأة الجمع الصغيرة",
        "bonus_pct": 50,
        "duration_sec": 28800,  # 8 ساعات
    },
    {
        "key": "large",
        "item_id": 400102,
        "buff_id": 5009,
        "name": "مكافأة الجمع الكبيرة",
        "bonus_pct": 50,
        "duration_sec": 86400,  # 24 ساعة
    },
    {
        "key": "super",
        "item_id": 402401,
        "buff_id": 5048,
        "name": "مكافأة الجمع السوبر",
        "bonus_pct": 100,
        "duration_sec": 86400,  # 24 ساعة
    },
)

GATHER_BUFF_ID_MAP: Dict[int, Dict[str, Any]] = {
    entry["buff_id"]: entry for entry in GATHER_BUFF_ITEMS_PRIORITY
}


def _format_hhmmss(seconds: int) -> str:
    secs = max(0, int(seconds))
    h, rem = divmod(secs, 3600)
    m, s = divmod(rem, 60)
    return f"{h:02d}:{m:02d}:{s:02d}"


class GatherSpeedBuffTask(BaseTask):
    """
    مهمة تفعيل مكافأة سرعة الجمع (الصغيرة ثم الكبيرة ثم السوبر) بطلب شبكي واحد فقط (1004/2).
    """

    name: str = "gather_speed_buff"
    alias: str = "gather_buff"

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
        self.name = "gather_speed_buff"

    @property
    def is_active(self) -> bool:
        return bool(self.config.get("enabled", True))

    # ------------------------------------------------------------------
    # أدوات قراءة الذاكرة الحية فقط (0-Network)
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

    def _get_live_snapshot(self) -> Dict[str, Any]:
        mem_engine = getattr(self.conn, "memory_engine", None)
        if mem_engine is not None and hasattr(mem_engine, "get_snapshot"):
            snap = mem_engine.get_snapshot()
            if isinstance(snap, dict):
                return snap
        return self.init_data if isinstance(self.init_data, dict) else {}

    def get_active_gather_speed_buff(self) -> Optional[Dict[str, Any]]:
        """
        فحص الذاكرة الحية فقط (0-Network) للتأكد من وجود مكافأة سرعة جمع نشطة حالياً
        في buffCtrl أو newBuffCtrl (buffIDs: 5008 / 5009 / 5048 أو effectType=17 مع origin=1).
        """
        snap = self._get_live_snapshot()
        now_ts = time.time()
        best_active: Optional[Dict[str, Any]] = None

        def _inspect_entry(entry: Any) -> None:
            nonlocal best_active
            if not isinstance(entry, dict):
                return

            bid = self._safe_int(entry.get("buffId") or entry.get("buffID") or entry.get("id"), 0)
            eff = self._safe_int(entry.get("effectType") or entry.get("effect") or entry.get("buffType"), 0)
            origin = self._safe_int(entry.get("origin") or entry.get("source"), 0)

            is_gather_city_buff = (bid in GATHER_BUFF_ID_MAP) or (
                eff == GATHER_SPEED_EFFECT_TYPE and origin in (0, CITY_BUFF_ORIGIN)
            )
            if not is_gather_city_buff:
                return

            end_ts = self._safe_float(
                entry.get("endTime")
                or entry.get("expireTime")
                or entry.get("end_time")
                or entry.get("overTime"),
                0.0,
            )
            if end_ts > 1e11:
                end_ts /= 1000.0

            # البنية الفعلية لـ buffCtrl في اللعبة: beginTime + time (المدة بالثواني)
            if end_ts <= 0:
                begin_ts = self._safe_float(
                    entry.get("beginTime")
                    or entry.get("startTime")
                    or entry.get("begin_time"),
                    0.0,
                )
                if begin_ts > 1e11:
                    begin_ts /= 1000.0
                duration_sec = self._safe_float(
                    entry.get("time") or entry.get("duration"),
                    0.0,
                )
                if begin_ts > 0 and duration_sec > 0:
                    end_ts = begin_ts + duration_sec

            rem_sec = 0
            if end_ts > 0:
                if end_ts <= now_ts:
                    return  # منتهي الصلاحية
                rem_sec = int(end_ts - now_ts)
            else:
                left = self._safe_int(entry.get("remainTime") or entry.get("leftTime"), 0)
                if left <= 0:
                    return
                rem_sec = left

            meta = GATHER_BUFF_ID_MAP.get(bid, {})
            info = {
                "buff_id": bid,
                "name": meta.get("name", f"مكافأة سرعة الجمع (buffID={bid})"),
                "bonus_pct": meta.get("bonus_pct", 50),
                "remaining_seconds": rem_sec,
                "remaining_formatted": _format_hhmmss(rem_sec),
            }
            if best_active is None or rem_sec > best_active["remaining_seconds"]:
                best_active = info

        def _walk(obj: Any, depth: int = 0) -> None:
            if depth > 6 or obj is None:
                return
            if isinstance(obj, list):
                for item in obj:
                    _walk(item, depth + 1)
                return
            if isinstance(obj, dict):
                if any(
                    k in obj
                    for k in ("buffId", "buffID", "id", "effectType", "beginTime", "endTime", "expireTime")
                ):
                    _inspect_entry(obj)
                for v in obj.values():
                    if isinstance(v, (dict, list)):
                        _walk(v, depth + 1)

        for ctrl_name in ("buffCtrl", "newBuffCtrl"):
            ctrl_data = snap.get(ctrl_name)
            if isinstance(ctrl_data, (dict, list)):
                _walk(ctrl_data)

        return best_active

    def _get_bag_item_count_from_memory(self, item_id: int) -> int:
        """قراءة كمية عنصر محدد من backpackCtrl في الذاكرة الحية فقط (0-Network)."""
        snap = self._get_live_snapshot()
        bp = snap.get("backpackCtrl")
        if not isinstance(bp, (dict, list)):
            return 0

        id_str = str(item_id)

        # 1) وصول مباشر بالمعرف النصي أو الرقمي
        if isinstance(bp, dict):
            direct = bp.get(id_str) or bp.get(item_id)
            if isinstance(direct, dict):
                return max(0, self._safe_int(direct.get("count", direct.get("num", 0)), 0))
            if isinstance(direct, (int, float, str)):
                return max(0, self._safe_int(direct, 0))

            # 2) فحص القوائم الفرعية الشائعة (itemList / items / data)
            for sub_key in ("itemList", "items", "list", "data"):
                sub = bp.get(sub_key)
                if isinstance(sub, dict):
                    val = sub.get(id_str) or sub.get(item_id)
                    if isinstance(val, dict):
                        return max(0, self._safe_int(val.get("count", val.get("num", 0)), 0))
                    if isinstance(val, (int, float, str)):
                        return max(0, self._safe_int(val, 0))
                elif isinstance(sub, list):
                    for entry in sub:
                        if isinstance(entry, dict):
                            eid = self._safe_int(entry.get("itemID") or entry.get("itemId") or entry.get("id"), 0)
                            if eid == item_id:
                                return max(0, self._safe_int(entry.get("count", entry.get("num", 0)), 0))
        elif isinstance(bp, list):
            for entry in bp:
                if isinstance(entry, dict):
                    eid = self._safe_int(entry.get("itemID") or entry.get("itemId") or entry.get("id"), 0)
                    if eid == item_id:
                        return max(0, self._safe_int(entry.get("count", entry.get("num", 0)), 0))

        return 0

    def _select_best_available_item(self) -> Tuple[Optional[Dict[str, Any]], Dict[int, int]]:
        """اختيار أول عنصر متوفر في الحقيبة حسب الترتيب الصارم: الصغيرة -> الكبيرة -> السوبر."""
        inventory: Dict[int, int] = {}
        chosen: Optional[Dict[str, Any]] = None
        for item_meta in GATHER_BUFF_ITEMS_PRIORITY:
            iid = item_meta["item_id"]
            cnt = self._get_bag_item_count_from_memory(iid)
            inventory[iid] = cnt
            if chosen is None and cnt > 0:
                chosen = item_meta
        return chosen, inventory

    def _decrement_item_in_live_memory(self, item_id: int) -> None:
        """خصم 1 من رصيد العنصر في backpackCtrl بالذاكرة الحية بعد نجاح التفعيل."""
        bp = self.get_ctrl("backpackCtrl")
        if not isinstance(bp, dict):
            return
        id_str = str(item_id)
        entry = bp.get(id_str)
        if isinstance(entry, dict) and "count" in entry:
            curr = self._safe_int(entry.get("count"), 1)
            if curr > 1:
                entry["count"] = curr - 1
            else:
                bp.pop(id_str, None)

    # ------------------------------------------------------------------
    # الفحص المسبق (0-Network بالكامل)
    # ------------------------------------------------------------------

    async def can_run(self) -> Tuple[bool, str]:
        if not self.is_active:
            return False, "مهمة تفعيل مكافأة سرعة الجمع معطلة في الإعدادات."

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بخادم اللعبة."

        if not self._get_live_snapshot():
            return False, "بيانات الذاكرة الحية للقلعة غير متوفرة."

        # 1) فحص عدم وجود مكافأة سرعة جمع نشطة حالياً (superposition = 0)
        active_buff = self.get_active_gather_speed_buff()
        if active_buff:
            return (
                False,
                f"{active_buff['name']} نشطة بالفعل (+{active_buff['bonus_pct']}%) — "
                f"المتبقي: {active_buff['remaining_formatted']}.",
            )

        # 2) فحص توفر أي من المكافآت الثلاث في الحقيبة (0-Network)
        chosen, _inv = self._select_best_available_item()
        if chosen is None:
            return False, "لا توجد أي مكافأة سرعة جمع متوفرة في الحقيبة (الصغيرة 400101 / الكبيرة 400102 / السوبر 402401)."

        return True, f"جاهز لتفعيل {chosen['name']}."

    # ------------------------------------------------------------------
    # التنفيذ الرئيسي (طلب شبكي واحد فقط: CMD 1004/2)
    # ------------------------------------------------------------------

    async def run(self) -> TaskResult:
        dry_run = bool(self.config.get("dry_run", False))

        # 1) الفحص المسبق الكامل من الذاكرة الحية (0-Network)
        active_buff = self.get_active_gather_speed_buff()
        if active_buff:
            msg = (
                f"{active_buff['name']} نشطة بالفعل (+{active_buff['bonus_pct']}%) — "
                f"المتبقي: {active_buff['remaining_formatted']} (تم التخطي لتفادي إهدار المكافآت)."
            )
            self.log(f"⏭️ [سرعة الجمع] {msg}")
            return TaskResult(
                success=False,
                skipped=True,
                message=msg,
                data={"buff_active": True, "active_buff": active_buff},
            )

        chosen, inv = self._select_best_available_item()
        inv_summary = (
            f"صغيرة(400101): {inv.get(400101, 0)} | "
            f"كبيرة(400102): {inv.get(400102, 0)} | "
            f"سوبر(402401): {inv.get(402401, 0)}"
        )
        self.log(f"🎒 [سرعة الجمع] مخزون الحقيبة (من الذاكرة): {inv_summary}")

        if chosen is None:
            msg = "لا توجد أي مكافأة سرعة جمع في الحقيبة — تم التخطي بدون إرسال أي طلب."
            self.log(f"⏭️ [سرعة الجمع] {msg}")
            return TaskResult(
                success=False,
                skipped=True,
                message=msg,
                data={"inventory": inv},
            )

        item_id = chosen["item_id"]
        if dry_run:
            msg = (
                f"[DRY-RUN] جاهز لتفعيل {chosen['name']} (ID={item_id} | +{chosen['bonus_pct']}% لمدة "
                f"{chosen['duration_sec'] // 3600} ساعة) بطلب واحد 1004/2."
            )
            self.log(f"🧪 [سرعة الجمع] {msg}")
            return TaskResult(
                success=True,
                message=msg,
                data={"dry_run": True, "chosen": chosen, "inventory": inv},
            )

        # 2) الطلب الشبكي الوحيد في المهمة كلها: تفعيل العنصر من الحقيبة (CMD 1004/2)
        self.log(
            f"🚀 [سرعة الجمع] تفعيل {chosen['name']} (ID={item_id} | +{chosen['bonus_pct']}% لمدة "
            f"{chosen['duration_sec'] // 3600} ساعة)..."
        )
        payload = {
            "itemID": item_id,
            "count": 1,
        }
        resp = await self.safe_query("1004", "2", payload, min_delay=0.3, max_delay=0.6)
        err = self._extract_err_code(resp)
        if err != "0":
            msg = f"رفض السيرفر تفعيل {chosen['name']} (ID={item_id}, err={err})."
            self.log(f"⚠️ [سرعة الجمع] {msg}")
            return TaskResult(
                success=False,
                message=msg,
                data={"err": err, "chosen": chosen, "raw": resp},
            )

        self._decrement_item_in_live_memory(item_id)
        msg = (
            f"تم تفعيل {chosen['name']} بنجاح (+{chosen['bonus_pct']}% لمدة "
            f"{chosen['duration_sec'] // 3600} ساعة)."
        )
        self.log(f"✅ [سرعة الجمع] {msg}")
        return TaskResult(
            success=True,
            message=msg,
            data={"chosen": chosen, "inventory_before": inv},
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
        await asyncio.sleep(0.2)

        cfg = {
            "enabled": True,
            "dry_run": args.dry_run,
        }
        task = GatherSpeedBuffTask(conn, config=cfg)
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

    parser = argparse.ArgumentParser(description="مهمة تفعيل مكافأة سرعة الجمع (الصغيرة -> الكبيرة -> السوبر).")
    parser.add_argument("--email", required=True, help="إيميل الحساب")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري إذا كانت في session_cache)")
    parser.add_argument("--dry-run", action="store_true", help="فحص الباف النشط ومخزون الحقيبة من الذاكرة بدون تفعيل")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()