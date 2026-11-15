# -*- coding: utf-8 -*-
"""
Command Hall Task Engine - محرك مهام قاعة القيادة
===================================================
محرك ذكي، نظيف، وموديولار بالكامل لإدارة وإنجاز مهام قاعة القيادة في لعبة انتقام السلاطين.
يعتمد بالكامل على بروتوكول الذاكرة الحية (0-Network Direct Read) ودوال الأساس الموثقة في BaseTask.

سير العمل:
1. الفحص القبلي للجاهزية (can_run / Pre-flight):
   - التحقق من تفعيل المهمة في الإعدادات.
   - التحقق من توفر طاقة اللورد بما يغطي تكلفة المعركة + حد الأمان (10 طاقة).
   - التحقق من وجود فيالق شاغرة للإرسال (get_available_marches_count > 0).
   - التحقق من توفر قوات مقاتلة جاهزة بالقلعة (get_available_troops_count > 0).
2. استعلام المهام المتاحة (0-Network):
   - استدعاء get_command_hall_tasks() لجلب كافة المهام وتصنيفها.
3. التصفية وفرز الأولويات:
   - فرز المهام القتالية الجاهزة (فريق الغزاة نوع 5، طليعة الغزاة نوع 2) بالأعلى جودة أولاً.
4. حلقة التنفيذ المتسلسلة (Single March Loop):
   - إرسال فيلق واحد فقط في كل دورة نحو الهدف عبر execute_command_hall_battle_task().
   - الانتظار الإلزامي حتى حسم المعركة بالسيرفر واستلام الجوائز وتثبيت الإنجاز.
   - الانتقال الآمن للمهمة التالية طالما تحققت شروط الأمان والطاقة.

مسار التشغيل والاختبار:
python tools/test_task_method.py --email beetoo1@hotmail.com --task command_hall run
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

from tasks.base_task import (
    BaseTask,
    TaskResult,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    REQ_COMMAND_HALL_COMMIT_TASK,
    COMMAND_HALL_TASK_TYPES,
    COMMAND_HALL_TASK_STATUES,
)

# أنواع المهام الفرعية لقاعة القيادة (gCommandHallTaskType)
TASK_TYPE_REBEL_GROUP = 1    # جيش المتمردين الجماعي (بوس)
TASK_TYPE_REBEL_PIONEER = 2  # طليعة جيش المتمردين (معركة مسير)
TASK_TYPE_DIALOGUE = 3       # المعلومات العسكرية (حوار فوري)
TASK_TYPE_RESCUE = 4         # إنقاذ القرويين (إنقاذ فوري)
TASK_TYPE_BATTLE = 5         # فريق الغزاة (معركة مسير)
TASK_TYPE_SNIPE = 6          # القناص الصامت (لعبة مصغرة)

# حالات المهام الرسمية (gCommandHallTaskStatue)
TASK_STATUE_PREPARE = 1   # قيد الإعداد
TASK_STATUE_READY = 2     # جاهزة للتنفيذ
TASK_STATUE_FINISH = 3    # مكتملة وبانتظار الاستلام

# تكلفة الطاقة الافتراضية لكل مهمة معركة
STAMINA_COST_PER_BATTLE = 10

# الحد الأدنى لأمان الطاقة المحفوظة في القلعة لمنع تصفير طاقة اللورد
DEFAULT_MIN_SAFETY_STAMINA = 10


class CommandHallTask(BaseTask):
    """
    محرك مهام قاعة القيادة التلقائي المتكامل:
    ينفذ مهام المعارك والمسير (فريق الغزاة 5 وطليعة الغزاة 2) بتسلسل آمن،
    ويتحقق من طاقة اللورد والشواغر، وقابل للتوسع لاحتضان باقي المهام لاحقاً.
    """
    name: str = "command_hall"
    alias: str = "command_hall"

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
        self.name = "command_hall"

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة برأي المستخدم من خلال الإعدادات وقاعدة البيانات."""
        return bool(self.config.get("enabled", False))

    @property
    def min_safety_stamina(self) -> int:
        """حد الأمان الأدنى لطاقة اللورد المطلوب الحفاظ عليه بالقلعة (افتراضياً 10 طاقة)."""
        cfg_val = self.config.get("min_stamina") or self.config.get("min_safety_stamina")
        return max(0, self._safe_int(cfg_val, DEFAULT_MIN_SAFETY_STAMINA))

    @property
    def allow_marches(self) -> bool:
        """السماح بالمسير القتالي (افتراضياً مفعل طالما المهمة نشطة)."""
        return bool(self.config.get("allow_marches", True))

    async def can_run(self) -> Tuple[bool, str]:
        """
        الفحص القبلي الصارم للأمان والجاهزية (0-Network Pre-flight):
        - التحقق من تفعيل المهمة.
        - التحقق من كفاية طاقة اللورد لتنفيذ مهمة قتالية واحدة على الأقل مع حد الأمان.
        - التحقق من وجود فيالق شاغرة للإرسال.
        - التحقق من توفر جنود مقاتلين داخل القلعة.
        """
        if not self.is_active:
            return False, "المهمة غير مفعلة في الإعدادات."

        # 1. فحص طاقة اللورد مع حد الأمان المخصص
        min_required = STAMINA_COST_PER_BATTLE + self.min_safety_stamina
        cur_stam = self.stamina
        if cur_stam < min_required:
            return False, f"طاقة اللورد غير كافية ({cur_stam} متوفر | الحد الأدنى المطلوب: {min_required} تشمل {self.min_safety_stamina} حد أمان)."

        # 2. فحص شاغرية الفيالق
        avail_marches = self.get_available_marches_count()
        if avail_marches <= 0:
            return False, "لا توجد طوابير مسير شاغرة حالياً (كافة الفيالق نشطة بالخارج)."

        # 3. فحص الجنود المقاتلين بالقلعة
        avail_troops = self.get_available_troops_count()
        if avail_troops <= 0:
            return False, "لا توجد قوات مقاتلة متاحة داخل القلعة لتشكيل الفيلق."

        return True, "جاهز للتنفيذ."

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة محرك مهام قاعة القيادة بالكامل:
        1. استعلام وفحص المهام المتاحة بقاعة القيادة (get_command_hall_tasks).
        2. فرز المهام القتالية المؤهلة (فريق الغزاة 5، طليعة الغزاة 2) بالأعلى جودة أولاً.
        3. الدخول في حلقة تنفيذ متسلسلة باستخدام فيلق واحد فقط لكل دورة.
        4. الانتظار وحسم المعركة واستلام الجوائز والانتقال للمهمة التالية.
        """
        t0 = time.perf_counter()

        # 1. الفحص القبلي للجاهزية
        can_exec, reason = await self.can_run()
        if not can_exec:
            self.log(f"🛡️ [قاعة القيادة] تخطي الدورة بأمان: {reason}")
            return TaskResult.skip(reason)

        # 2. استعلام بيانات قاعة القيادة عبر الذاكرة الحية (0-Network)
        tasks_data = await self.get_command_hall_tasks(force_sync=False)
        if not tasks_data.get("success"):
            self.log("📡 [قاعة القيادة] تحديث احتياطي لبيانات قاعة القيادة من السيرفر...")
            tasks_data = await self.get_command_hall_tasks(force_sync=True)

        if not tasks_data.get("success"):
            return TaskResult.skip("تعذر الحصول على بيانات قاعة القيادة من الذاكرة الحية أو السيرفر.")

        summary = tasks_data.get("summary", {})
        hall_lv = summary.get("command_lv", 1)
        hall_exp = summary.get("command_exp", 0)
        need_exp = summary.get("need_exp", 1600)

        self.log(
            f"🏰 [قاعة القيادة] بدء فحص المهام (المستوى: Lv.{hall_lv} | الخبرة: {hall_exp}/{need_exp} "
            f"| الطاقة: {self.stamina} | الفيالق الشاغرة: {self.get_available_marches_count()})."
        )

        # 3. استخراج وتصفية المهام القتالية الجاهزة للتنفيذ (Statue == 2)
        # تشمل نوع 5 (فريق الغزاة) ونوع 2 (طليعة الغزاة)
        march_tasks = tasks_data.get("march_tasks", [])
        eligible_tasks: List[Dict[str, Any]] = [
            t for t in march_tasks
            if self._safe_int(t.get("type")) in (TASK_TYPE_BATTLE, TASK_TYPE_REBEL_PIONEER)
            and self._safe_int(t.get("statue")) == TASK_STATUE_READY
        ]

        if not eligible_tasks:
            self.log("ℹ️ [قاعة القيادة] لا توجد مهام قتالية (فريق الغزاة أو طليعة الغزاة) جاهزة للتنفيذ حالياً.")
            return TaskResult.ok(
                "لا توجد مهام قتالية جاهزة للتنفيذ حالياً بقاعة القيادة.",
                data={"summary": summary, "completed_tasks": 0},
                exec_time=time.perf_counter() - t0,
            )

        # 4. فرز المهام بالأعلى جودة أولاً (Quality Descending: 6 ذهبي -> 5 برتقالي -> 4 بنفسجي -> 3 أزرق)
        # لتعظيم العائد من نقاط الخبرة والجوائز ذات القيمة الأعلى أولاً
        eligible_tasks.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)

        self.log(f"📋 [قاعة القيادة] تم رصد {len(eligible_tasks)} مهام قتالية جاهزة للتنفيذ (مرتبة بالأعلى جودة أولاً).")

        # 5. حلقة التنفيذ المتسلسلة (Single March Execution Loop)
        completed_tasks_count = 0
        failed_tasks_count = 0
        total_stamina_spent = 0
        all_rewards_collected: List[Dict[str, Any]] = []

        for task_idx, task_item in enumerate(eligible_tasks, 1):
            task_id = self._safe_int(task_item.get("task_id"), 0)
            task_index = self._safe_int(task_item.get("index"), 0)
            task_type = self._safe_int(task_item.get("type"), 5)
            type_name = "طليعة الغزاة" if task_type == TASK_TYPE_REBEL_PIONEER else "فريق الغزاة"
            quality_name = task_item.get("quality_name_ar", str(task_item.get("quality", "")))
            stamina_cost = self._safe_int(task_item.get("stamina_cost"), STAMINA_COST_PER_BATTLE)

            # أ) فحص مسبق صارم لطاقة اللورد قبل كل مهمة لحماية حد الأمان
            min_needed_stamina = stamina_cost + self.min_safety_stamina
            current_stamina = self.stamina
            if current_stamina < min_needed_stamina:
                self.log(
                    f"🛑 [قاعة القيادة] التوقف عن تنفيذ باقي المهام للحفاظ على حد أمان الطاقة بالقلعة "
                    f"({current_stamina} متوفر | المطلوب: {min_needed_stamina} تشمل {self.min_safety_stamina} حد أمان)."
                )
                break

            # ب) التأكد من شاغرية الفيلق قبل إرسال المسير (فيلق واحد فقط في كل مرة)
            avail_marches = self.get_available_marches_count()
            if avail_marches <= 0:
                self.log("⏳ [قاعة القيادة] انتظار عودة الفيالق النشطة بالخارج...")
                # مهلة انتظار قصيرة لعودة الفيلق إن وُجد
                waited = 0
                while self.get_available_marches_count() <= 0 and waited < 10:
                    await asyncio.sleep(2.0)
                    waited += 2

                if self.get_available_marches_count() <= 0:
                    self.log("⚠️ [قاعة القيادة] تعذر استكمال باقي المهام لعدم توفر فيالق شاغرة.")
                    break

            # ج) فحص القوات المقاتلة بالقلعة
            if self.get_available_troops_count() <= 0:
                self.log("⚠️ [قاعة القيادة] نفدت القوات المقاتلة الشاغرة بالقلعة لتشكيل الفيلق. توقف الدورة.")
                break

            self.log(
                f"⚔️ [قاعة القيادة] ({task_idx}/{len(eligible_tasks)}) تنفيذ مهمة {type_name} #{task_index} "
                f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
            )

            # د) استدعاء دالة تنفيذ المعركة الرسمية الموثقة في BaseTask
            exec_res = await self.execute_command_hall_battle_task(task_item, wait_seconds=7.0)

            if exec_res.get("success"):
                completed_tasks_count += 1
                total_stamina_spent += exec_res.get("stamina_spent", stamina_cost)
                task_rewards = exec_res.get("rewards") or []
                if task_rewards:
                    all_rewards_collected.extend(task_rewards)

                self.log(f"✅ [قاعة القيادة] اكتملت المهمة #{task_index} بنجاح!")

                # فاصل بشري عشوائي ذكي وآمن بين المعارك (Human Jitter)
                if task_idx < len(eligible_tasks):
                    jitter = random.uniform(1.0, 2.0)
                    await asyncio.sleep(jitter)
            else:
                failed_tasks_count += 1
                fail_reason = exec_res.get("reason", "خطأ غير محدد")
                self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز المهمة #{task_index} ({fail_reason}).")

        # 6. تجميع الإحصائيات والنتيجة النهائية
        exec_duration = time.perf_counter() - t0

        if completed_tasks_count > 0:
            result_msg = (
                f"تم إنجاز {completed_tasks_count} مهام قتالية بنجاح بقاعة القيادة "
                f"(استهلاك {total_stamina_spent} طاقة | فاشل: {failed_tasks_count})."
            )
            return TaskResult.ok(
                result_msg,
                data={
                    "completed_tasks": completed_tasks_count,
                    "failed_tasks": failed_tasks_count,
                    "stamina_spent": total_stamina_spent,
                    "rewards_count": len(all_rewards_collected),
                    "rewards": all_rewards_collected,
                    "summary": summary,
                },
                exec_time=exec_duration,
            )

        if failed_tasks_count > 0:
            return TaskResult.fail(
                f"فشل إنجاز المهام القتالية المرصودة ({failed_tasks_count} مهام).",
                exec_time=exec_duration,
            )

        return TaskResult.ok(
            "تم فحص مهام قاعة القيادة — لم تتطلب الدورة تنفيذ أي معارك جديدة.",
            data={"summary": summary, "completed_tasks": 0},
            exec_time=exec_duration,
        )
