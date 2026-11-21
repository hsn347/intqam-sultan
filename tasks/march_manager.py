# -*- coding: utf-8 -*-
"""
tasks/march_manager.py — مدير المسيرات والفيالق المركزي (Central March & Legion Manager)
══════════════════════════════════════════════════════════════════════════════════════
المنسق والمدير الرئيسي لكافة عمليات الخروج والهجوم والمسيرات خارج أسوار القلعة:
  1. إدارة وتنسيق المهام الفرعية المستقلة (Sub-tasks Registry & Orchestration):
     - تشغيل المهام الفرعية تلو الأخرى بتسلسل منتظم ومحكم.
  2. الحساب الذاتي للمدة الزمنية القصوى (Dynamic Time Budgeting):
     - حد أقصى افتراضي 20 دقيقة (قابلة للتعديل عبر max_duration_minutes).
     - قياس الزمن المنقضي والمتبقي بدقة متناهية.
     - الخروج الفوري عند اكتمال تنفيذ المهام أو انتهاء المهلة الزمنية المحددة.
  3. الفحص القبلي الشامل بالاعتماد الكامل على الذاكرة الحية (0-Network Pre-flight):
     - فحص سعة الفيالق القصوى للقلعة (get_max_marches_capacity).
     - فحص عدد الفيالق والمسيرات النشطة والشاغرة (get_available_marches_count).
     - تحليل طوابير المسيرات النشطة وحساب زمن عودة الفيالق (get_active_marches_eta).
  4. عزل الأخطاء وحماية الاتصال (Fault & Circuit Breaker Isolation):
     - عزل أخطاء أي مهمة فرعية لضمان استقرار دورة البوت.
     - التمرير الفوري لقاطع الاتصال عند رصد موت المقبس أو الدخول المتزامن.
"""

from __future__ import annotations

import asyncio
import logging
import time
from typing import Any, Callable, Dict, List, Optional, Tuple, Type

from tasks.base_task import (
    BaseTask,
    TaskResult,
    ConnectionCircuitBreakerError,
)

log = logging.getLogger("march_manager")

# الحد الأقصى الافتراضي لمدة عمل مدير المسيرات (20 دقيقة = 1200 ثانية)
DEFAULT_MAX_DURATION_MINUTES = 20
DEFAULT_MAX_DURATION_SECONDS = DEFAULT_MAX_DURATION_MINUTES * 60


class MarchManagerTask(BaseTask):
    """
    مدير المسيرات والفيالق المركزي:
    يدير تشغيل مهام العمليات العسكرية والمسيرات الخارجية تباعاً،
    ويتحكم في شواغر الفيالق، وزمن الدورة، والخروج الفوري عند الإنجاز.
    """
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
    # 3. تحليل طوابير ومسيرات الجيوش في الذاكرة الحية (0-Network)
    # ═════════════════════════════════════════════════════════════════════════

    def get_active_marches_eta(self) -> Dict[str, Any]:
        """
        فحص وتحليل طوابير ومسيرات القلعة النشطة بالخارج من الذاكرة الحية (0-Network):
        - حساب الثواني المتبقية لعودة كل فيلق نشط.
        - معرفة أقرب فيلق سيعود (earliest_return_seconds) وأبعد فيلق (latest_return_seconds).
        - استخراج إحداثيات الهدف ونوع المسيرة بدون أي طلب شبكي.
        """
        queues = self._read_live_local_queues(self.conn)
        my_uid = str(getattr(self, "uid", "") or "").strip()
        active_statuses = (0, 1, 2, 3, 4, 7)
        now_ts = time.time()

        active_list: List[Dict[str, Any]] = []
        earliest_return: Optional[float] = None
        latest_return: Optional[float] = None

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

            # استخراج أوقات المسيرة
            finish_time = self._safe_float(
                q.get("finishTime") or q.get("endTime") or q.get("finish_time") or 0.0
            )
            # تصحيح الطوابع الزمنية بالمللي ثانية إن وجدت
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
        """
        ملخص شامل ومفصل لحالة الفيالق والمسيرات المتاحة للقلعة (0-Network):
        - السعة القصوى المسموحة (وفق الأساس، الأبحاث، وباف الـ VIP).
        - عدد الفيالق المنطلقة حالياً خارج القلعة.
        - عدد الفيالق الشاغرة الجاهزة لأي مهمة جديدة.
        - تفاصيل أزمنة المسيرات النشطة.
        """
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
    # 4. الفحص القبلي والتنفيذ (Pre-flight & Execution Engine)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        """
        الفحص القبلي السريع للجاهزية (0-Network Pre-flight):
        - التحقق من تفعيل المهمة في الإعدادات.
        - التحقق من حيوية الاتصال وقاطع الاتصال.
        - التحقق من شحن الذاكرة الحية.
        """
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
        2. قراءة كفاءة الفيالق وطوابير المسيرة بالذاكرة الحية (0-Network).
        3. تشغيل المهام الفرعية المسجلة تلو الأخرى بانتظام.
        4. احتساب الوقت المنقضي قبل كل مهمة والخروج فوراً عند:
           - انتهاء كافة المهام بنجاح.
           - أو بلوغ الحد الأقصى للمدة الزمنية المحسوبة.
        5. الخروج الفوري دون استهلاك موارد أو تعطيل حلقة البوت.
        """
        start_time = time.monotonic()
        max_duration = self.max_duration_seconds
        max_minutes = self.max_duration_minutes

        # 1. جلب ملخص سعة الفيالق والمسيرات الحية (0-Network)
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

        # في حال عدم تسجيل أي مهمة فرعية حالياً (مرحلة التجهيز المعماري)
        if not subtasks:
            duration_spent = time.monotonic() - start_time
            msg = (
                f"محرك مدير المسيرات جاهز بكفاءة تامة (بانتظار ربط المهام الفرعية لاحقاً). "
                f"الفيالق: {avail}/{max_cap} متاحة."
            )
            self.log(f"ℹ️ [MarchManager] {msg} (استغرق الفحص: {duration_spent:.2f} ثانية).")
            return TaskResult.ok(msg)

        # 2. تشغيل المهام الفرعية تلو الأخرى ومراقبة السقف الزمني
        for subtask_cls in subtasks:
            # التحقق من المدة الزمنية المنقضية قبل بدء أي مهمة فرعية
            elapsed = time.monotonic() - start_time
            if elapsed >= max_duration:
                self.log(
                    f"⏳ [MarchManager] بلغت المهمة الحد الأقصى للمدة المحددة "
                    f"({max_minutes} دقيقة) — الخروج فوراً وإنهاء الدورة."
                )
                break

            sub_name = getattr(subtask_cls, "name", subtask_cls.__name__)
            sub_alias = getattr(subtask_cls, "alias", "")

            # استخراج إعدادات المهمة الفرعية من إعدادات مدير المسيرات أو الجذر
            sub_cfg = (
                self.config.get(sub_name)
                or (self.config.get(sub_alias) if sub_alias else None)
                or {}
            )

            # تشغيل المهمة الفرعية مع عزل الأخطاء
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
                self.log(f"⚡ [MarchManager] قاطع الاتصال: تم رصد انقطاع الاتصال أثناء [{sub_name}] — إيقاف الدورة فوراً.")
                raise
            except Exception as e:
                if "ConcurrentLogin" in type(e).__name__:
                    raise
                self.log(f"❌ [MarchManager] خطأ غير متوقع في المهمة الفرعية [{sub_name}]: {e}")
            finally:
                sub_instance = None

        # 3. اكتمال دورة المهام والخروج الفوري
        duration_spent = time.monotonic() - start_time
        final_msg = (
            f"اكتملت دورة مدير المسيرات بنجاح "
            f"(تم تنفيذ: {executed_subtasks} مهام فرعية | نجاح: {successful_subtasks} | "
            f"الزمن المستغرق: {duration_spent:.1f} ثانية من أصل {max_minutes} دقيقة)."
        )
        self.log(f"🏁 [MarchManager] {final_msg} — الخروج فوراً.")
        return TaskResult.ok(final_msg)
