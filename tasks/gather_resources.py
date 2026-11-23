# -*- coding: utf-8 -*-
"""
مهمة جمع الموارد الاحترافية (GatherResourcesTask) — تعمل عبر MarchManagerTask وترث دواله بالكامل.

تدعم وضعين للتشغيل (يُحددان عبر config["mode"] عند الاستدعاء من march_manager.py):
  1. mode="daily_tasks" : إنجاز مهام النشاط اليومي للجمع (القمح، الخشب، الحديد، الفضة)،
     مع تخطي أي مورد منجز أو يسير إليه فيلق جمع نشط حالياً (0-Network).
  2. mode="resource"    : جمع مورد واحد مختار من المستخدم بالمستوى المحدد
     واستخدام كافة الفيالق الشاغرة المتاحة حتى نفادها أو نفاد الجنود.

أمثلة الاختبار المباشر من الطرفية:
  python tasks/gather_resources.py --email beetoo1@hotmail.com --mode resource --resource wood --level 6 --dry-run
  python tasks/gather_resources.py --email beetoo1@hotmail.com --mode daily_tasks --level 6 --dry-run
  python tasks/gather_resources.py --email beetoo1@hotmail.com --mode resource --resource wood --level 6
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
from tasks.march_manager import (
    MarchManagerTask,
    RESOURCE_SEARCH_ALIASES,
    WORLD_RESOURCE_MAX_CAPACITY,
)

# الحد الأدنى لمستوى القلعة لفتح جمع كل مورد (من سورس اللعبة الرسمي resource.lua)
RESOURCE_MIN_CASTLE_LEVEL: Dict[str, int] = {
    "food": 1,
    "wood": 1,
    "gold": 10,
    "iron": 10,
    "silver": 15,
    "crystal": 30,
}

# ترتيب موارد مهام النشاط اليومي (مطابق لـ DAILY_MARCH_TASKS_SPEC في march_manager.py)
DAILY_GATHER_TASK_ORDER: Tuple[Tuple[str, str], ...] = (
    ("gather_food", "food"),
    ("gather_wood", "wood"),
    ("gather_iron", "iron"),
    ("gather_silver", "silver"),
)


class GatherResourcesTask(MarchManagerTask):
    """
    مهمة جمع الموارد المستقلة:
    ترث من MarchManagerTask وتستدعي دواله مباشرة:
      - has_available_march / get_available_marches_count
      - get_daily_march_tasks_status
      - search_best_resource
      - build_gather_army_formation
      - dispatch_gather_march (CMD 1007/2)
    """

    name: str = "gather_resources"
    alias: str = "gather"

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
        self.name = "gather_resources"

    # ═════════════════════════════════════════════════════════════════════════
    # 1. قراءة الإعدادات وفحص الجاهزية (0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    @property
    def gather_mode(self) -> str:
        """وضع التشغيل: 'daily_tasks' لمهام النشاط اليومي أو 'resource' لمورد محدد."""
        raw = str(self.config.get("mode", "resource") or "resource").strip().lower()
        if raw in ("daily", "daily_tasks", "daily_quest", "يومي", "النشاط_اليومي"):
            return "daily_tasks"
        return "resource"

    def _is_resource_unlocked_for_castle(self, res_key: str) -> Tuple[bool, int, int]:
        """التحقق من فتح المورد حسب مستوى القلعة الحالي (0-Network)."""
        castle_lv = self._safe_int(getattr(self, "castle_level", 1), 1)
        req_lv = RESOURCE_MIN_CASTLE_LEVEL.get(res_key, 1)
        return (castle_lv >= req_lv), castle_lv, req_lv

    def _get_live_march_capacity(self) -> int:
        """قراءة سعة الفيلق القصوى للقلعة حصرياً عبر tasks/march_capacity.py (0-Network)."""
        from tasks.march_capacity import get_march_capacity_no_heroes

        cap = self._safe_int(get_march_capacity_no_heroes(self._get_live_snapshot()), 0)
        return cap if cap > 0 else 1000

    async def can_run(self) -> Tuple[bool, str]:
        """الفحص القبلي للجاهزية (0-Network): الاتصال + وجود فيلق شاغر + جنود متاحين."""
        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بخادم اللعبة."
        if not self.init_data:
            return False, "بيانات الذاكرة الحية للقلعة غير متوفرة."
        if not self.has_available_march(require_soldiers=False):
            return False, "لا توجد خانات فيالق شاغرة حالياً."
        if not self.get_available_soldiers():
            return False, "لا يوجد جنود متاحون داخل القلعة لإرسال مسيرة جمع."
        return True, ""

    # ═════════════════════════════════════════════════════════════════════════
    # 2. تنفيذ إرسال فيلق جمع واحد لمورد محدد (بحث -> تشكيل -> إرسال)
    # ═════════════════════════════════════════════════════════════════════════

    async def _send_one_gather_march(
        self,
        res_key: str,
        start_level: int,
        max_distance: float,
        safety_margin: float,
        dry_run: bool = False,
        max_dispatch_retries: int = 2,
    ) -> Dict[str, Any]:
        """
        تنفيذ دورة كاملة لفيلق جمع واحد:
          1. التحقق من وجود فيلق شاغر وجنود متاحين.
          2. البحث الرسمي عن أفضل مورد متاح (search_best_resource).
          3. تشكيل الجيش والأبطال المناسبين (build_gather_army_formation) بدون حد أدنى للتغطية.
          4. إرسال الفيلق فعلياً عبر CMD 1007/2 (dispatch_gather_march) مع إدارة الاستبعاد.
        """
        for dispatch_try in range(1, max(1, max_dispatch_retries) + 1):
            if not self.has_available_march(require_soldiers=True):
                return {"success": False, "stop_all": True, "reason": "نفدت الفيالق الشاغرة أو الجنود المتاحون."}

            # 1. البحث عن المورد
            search_res = await self.search_best_resource(
                resource_type=res_key,
                level=start_level,
                max_distance=max_distance,
                reserve_found=not dry_run,
            )
            if not search_res.get("success") or not search_res.get("target"):
                return {
                    "success": False,
                    "stop_all": False,
                    "reason": search_res.get("message", f"لم يتم العثور على مورد ({res_key})."),
                }

            target = search_res["target"]
            res_code = self._safe_int(target.get("resource_code"), 0)
            target_lv = self._safe_int(target.get("level"), start_level)
            fallback_cap = WORLD_RESOURCE_MAX_CAPACITY.get(res_code, {}).get(target_lv, 300_000)
            res_amount = (
                self._safe_int(target.get("remaining"), fallback_cap)
                if target.get("remaining") is not None
                else fallback_cap
            )

            # 2. تشكيل الجيش والأبطال (بدون حد أدنى للجنود — يُرسل ما تبقى إذا كان > 0)
            soldiers_now = self.get_available_soldiers()
            heroes_now = self.get_available_heroes()
            max_cap = self._get_live_march_capacity()

            formation = self.build_gather_army_formation(
                resource_type=res_key,
                resource_amount=res_amount,
                available_soldiers=soldiers_now,
                available_heroes=heroes_now,
                max_march_capacity=max_cap,
                safety_margin=safety_margin,
            )

            if not formation.get("success") or formation.get("total_soldiers", 0) <= 0:
                if not dry_run:
                    await self.release_target(target["target_id"], kingdom_id=target.get("kingdom_id"))
                return {
                    "success": False,
                    "stop_all": True,
                    "reason": formation.get("message", "تعذر تشكيل جيش للجمع لعدم توفر جنود."),
                }

            if dry_run:
                self.log(
                    f"🧪 [محاكاة جمع] مورد {res_key} مستوى {target_lv} في ({target['x']}, {target['y']}) "
                    f"| مسافة: {target['distance']} | كمية: {res_amount:,} | "
                    f"جنود: {formation['total_soldiers']:,}/{max_cap:,} | "
                    f"أبطال: {formation['hero_ids']} | تغطية: {formation['coverage_percent']}%"
                )
                return {
                    "success": True,
                    "dry_run": True,
                    "target": target,
                    "formation": formation,
                }

            # 3. الإرسال الفعلي عبر CMD 1007/2
            dispatch_res = await self.dispatch_gather_march(target=target, formation=formation)
            if dispatch_res.get("success"):
                return {
                    "success": True,
                    "target": target,
                    "formation": formation,
                    "dispatch": dispatch_res,
                }

            # فشل الإرسال: هل نعيد المحاولة على مورد آخر أم نتوقف؟
            if dispatch_res.get("retryable") and dispatch_try < max_dispatch_retries:
                self.log(
                    f"🔄 [جمع الموارد] فشل إرسال الفيلق نحو ({target['x']}, {target['y']}) "
                    f"({dispatch_res.get('message')}) — إعادة البحث (محاولة {dispatch_try + 1}/{max_dispatch_retries})..."
                )
                await asyncio.sleep(random.uniform(1.2, 2.4))
                continue

            return {
                "success": False,
                "stop_all": not bool(dispatch_res.get("retryable")),
                "reason": dispatch_res.get("message", "فشل إرسال فيلق الجمع."),
            }

        return {"success": False, "stop_all": False, "reason": "استُنفدت محاولات الإرسال."}

    # ═════════════════════════════════════════════════════════════════════════
    # 3. محرك التنفيذ الرئيسي للوضعين (daily_tasks & resource)
    # ═════════════════════════════════════════════════════════════════════════

    async def run(self) -> TaskResult:
        """
        تشغيل مهمة جمع الموارد وفق الوضع المحدد في config["mode"]:
          - daily_tasks: إرسال فيلق لكل مورد غير منجز (وليس له مسيرة نشطة) من مهام النشاط اليومي.
          - resource   : إرسال كافة الفيالق الشاغرة المتاحة لجمع المورد المختار من المستخدم.
        """
        start_time = time.monotonic()
        mode = self.gather_mode
        start_level = max(2, min(10, self._safe_int(self.config.get("resource_level", self.config.get("level", 6)), 6)))
        max_distance = max(10.0, self._safe_float(self.config.get("max_distance", 120.0), 120.0))
        safety_margin = max(0.0, self._safe_float(self.config.get("safety_margin", 0.03), 0.03))
        dry_run = bool(self.config.get("dry_run", False))

        avail_slots = self.get_available_marches_count()
        if avail_slots <= 0:
            return TaskResult.skip("لا توجد فيالق شاغرة حالياً لبدء جمع الموارد.")

        sent_marches: List[Dict[str, Any]] = []

        # ── المود الأول: إنجاز مهام النشاط اليومي ──
        if mode == "daily_tasks":
            daily_status = self.get_daily_march_tasks_status()
            pending_resources: List[str] = []

            for task_key, res_key in DAILY_GATHER_TASK_ORDER:
                info = daily_status.get(task_key, {})
                if info.get("completed") or info.get("has_active_march"):
                    continue
                unlocked, c_lv, req_lv = self._is_resource_unlocked_for_castle(res_key)
                if not unlocked:
                    self.log(f"⏭️ [جمع يومي] تخطي ({res_key}) لأن القلعة مستوى {c_lv} < {req_lv}.")
                    continue
                pending_resources.append(res_key)

            if not pending_resources:
                return TaskResult.skip("جميع مهام الجمع اليومية المتاحة للقلعة منجزة أو تسير إليها فيالق حالياً.")

            self.log(
                f"📅 [جمع الموارد - النشاط اليومي] الموارد المطلوبة: {pending_resources} | "
                f"الفيالق الشاغرة: {avail_slots} | المستوى الابتدائي: {start_level}"
            )

            for idx, res_key in enumerate(pending_resources):
                if not dry_run and not self.has_available_march(require_soldiers=True):
                    self.log("ℹ️ [جمع يومي] نفدت الفيالق الشاغرة أو الجنود المتاحون — إيقاف الدورة.")
                    break
                if dry_run and len(sent_marches) >= avail_slots:
                    break

                outcome = await self._send_one_gather_march(
                    res_key=res_key,
                    start_level=start_level,
                    max_distance=max_distance,
                    safety_margin=safety_margin,
                    dry_run=dry_run,
                )
                if outcome.get("success"):
                    sent_marches.append(outcome)
                    if idx + 1 < len(pending_resources):
                        await asyncio.sleep(random.uniform(1.2, 2.5))
                elif outcome.get("stop_all"):
                    self.log(f"🛑 [جمع يومي] توقف الدورة: {outcome.get('reason')}")
                    break
                else:
                    self.log(f"⚠️ [جمع يومي] تعذر إرسال فيلق لمورد ({res_key}): {outcome.get('reason')}")

            elapsed = round(time.monotonic() - start_time, 2)
            if not sent_marches:
                return TaskResult.fail("لم يتم إرسال أي فيلق لمهام الجمع اليومية.", exec_time=elapsed)
            timings = [
                m["dispatch"]["timing"]
                for m in sent_marches
                if isinstance(m.get("dispatch"), dict) and isinstance(m["dispatch"].get("timing"), dict)
            ]
            earliest_sec = min((t["total_seconds"] for t in timings), default=0.0)
            latest_sec = max((t["total_seconds"] for t in timings), default=0.0)
            return TaskResult.ok(
                f"تم {'محاكاة ' if dry_run else ''}إرسال {len(sent_marches)} فيلق لإنجاز مهام الجمع اليومية.",
                data={
                    "mode": mode,
                    "sent_count": len(sent_marches),
                    "earliest_return_seconds": earliest_sec,
                    "earliest_return_formatted": self._format_duration_hms(earliest_sec),
                    "latest_return_seconds": latest_sec,
                    "latest_return_formatted": self._format_duration_hms(latest_sec),
                    "marches_timing": timings,
                    "dry_run": dry_run,
                },
                exec_time=elapsed,
            )

        # ── المود الثاني: جمع مورد واحد مختار من المستخدم حتى نفاد الفيالق ──
        raw_res = str(self.config.get("resource_type", self.config.get("resource", "wood")) or "wood").strip().lower()
        if raw_res not in RESOURCE_SEARCH_ALIASES:
            return TaskResult.fail(f"نوع المورد غير معروف: '{raw_res}'.")

        _res_code, res_key = RESOURCE_SEARCH_ALIASES[raw_res]
        unlocked, c_lv, req_lv = self._is_resource_unlocked_for_castle(res_key)
        if not unlocked:
            return TaskResult.skip(
                f"المورد ({res_key}) غير مفتوح بعد لهذه القلعة (مستوى القلعة {c_lv}، المطلوب مستوى {req_lv})."
            )

        self.log(
            f"⛏️ [جمع الموارد - مورد محدد] المورد: {res_key} (مستوى {start_level}) | "
            f"الفيالق الشاغرة: {avail_slots} | أقصى مسافة: {max_distance:g}"
        )

        # استخدام كل الفيالق الشاغرة المتاحة (مع سقف حماية برابر لعدد الخانات الشاغرة الحالية)
        max_loops = max(1, avail_slots)
        for loop_idx in range(max_loops):
            if not dry_run and not self.has_available_march(require_soldiers=True):
                break
            if dry_run and len(sent_marches) >= avail_slots:
                break

            outcome = await self._send_one_gather_march(
                res_key=res_key,
                start_level=start_level,
                max_distance=max_distance,
                safety_margin=safety_margin,
                dry_run=dry_run,
            )
            if outcome.get("success"):
                sent_marches.append(outcome)
                if loop_idx + 1 < max_loops:
                    await asyncio.sleep(random.uniform(1.5, 3.0))
            else:
                self.log(f"⚠️ [جمع الموارد] إيقاف الإرسال بعد {len(sent_marches)} فيلق: {outcome.get('reason')}")
                break

        elapsed = round(time.monotonic() - start_time, 2)
        if not sent_marches:
            return TaskResult.fail(
                f"لم يتم إرسال أي فيلق لجمع ({res_key}) مستوى {start_level}.",
                exec_time=elapsed,
            )

        timings = [
            m["dispatch"]["timing"]
            for m in sent_marches
            if isinstance(m.get("dispatch"), dict) and isinstance(m["dispatch"].get("timing"), dict)
        ]
        earliest_sec = min((t["total_seconds"] for t in timings), default=0.0)
        latest_sec = max((t["total_seconds"] for t in timings), default=0.0)
        return TaskResult.ok(
            f"تم {'محاكاة ' if dry_run else ''}إرسال {len(sent_marches)} فيلق لجمع ({res_key}) بنجاح.",
            data={
                "mode": mode,
                "resource_type": res_key,
                "sent_count": len(sent_marches),
                "earliest_return_seconds": earliest_sec,
                "earliest_return_formatted": self._format_duration_hms(earliest_sec),
                "latest_return_seconds": latest_sec,
                "latest_return_formatted": self._format_duration_hms(latest_sec),
                "marches_timing": timings,
                "dry_run": dry_run,
            },
            exec_time=elapsed,
        )


# ═════════════════════════════════════════════════════════════════════════════
# واجهة الاختبار المباشر من التيرمنال (CLI)
# ═════════════════════════════════════════════════════════════════════════════

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
            "resource_type": args.resource,
            "resource_level": args.level,
            "max_distance": args.max_dist,
            "safety_margin": args.safety_margin,
            "dry_run": args.dry_run,
        }
        task = GatherResourcesTask(conn, config=cfg)
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

    parser = argparse.ArgumentParser(description="اختبار مهمة جمع الموارد (GatherResourcesTask) مباشرة.")
    parser.add_argument("--email", required=True, help="إيميل الحساب")
    parser.add_argument("--password", "-p", default="", help="كلمة المرور (اختياري)")
    parser.add_argument("--mode", default="resource", choices=["resource", "daily_tasks"], help="وضع الجمع: resource أو daily_tasks")
    parser.add_argument("--resource", default="wood", help="نوع المورد في وضع resource (wood/food/iron/silver/gold/crystal)")
    parser.add_argument("--level", type=int, default=6, help="مستوى المورد الابتدائي (افتراضي 6)")
    parser.add_argument("--max-dist", type=float, default=120.0, help="أقصى مسافة بحث (افتراضي 120)")
    parser.add_argument("--safety-margin", type=float, default=0.03, help="هامش أمان الحمولة (افتراضي 0.03 = 3%)")
    parser.add_argument("--dry-run", action="store_true", help="محاكاة البحث وتشكيل الجيش بدون إرسال الفيلق فعلياً")
    parser.add_argument("--json", action="store_true", help="عرض النتيجة بصيغة JSON")
    args = parser.parse_args()
    sys.exit(asyncio.run(_run_cli_live(args)))


if __name__ == "__main__":
    _main()