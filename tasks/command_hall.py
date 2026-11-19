# -*- coding: utf-8 -*-
"""

python tools/test_task_method.py --email beetoo2@hotmail.com --task command_hall run

"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Set, Tuple

from tasks.base_task import (
    BaseTask,
    TaskResult,
    ConnectionCircuitBreakerError,
    CMD_COMMAND_HALL_MODULE,
    REQ_COMMAND_HALL_INIT,
    REQ_COMMAND_HALL_COMMIT_TASK,
    COMMAND_HALL_TASK_TYPES,
    COMMAND_HALL_TASK_STATUES,
    COMMAND_HALL_EXP_BY_LV,
    COMMAND_HALL_MAX_LEVEL,
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
    def mode(self) -> str:
        """نمط التنفيذ: 'daily' (دورة كاملة حتى إتمام النشاط اليومي ثم التجاوز لباقي اليوم) أو 'full' (دورة كاملة مستمرة في كل دورة)."""
        return str(self.config.get("mode", "daily")).lower().strip()

    @property
    def min_safety_stamina(self) -> int:
        """حد الأمان الأدنى لطاقة اللورد المطلوب الحفاظ عليه بالقلعة (افتراضياً 10 طاقة)."""
        cfg_val = self.config.get("min_stamina") or self.config.get("min_safety_stamina")
        return max(0, self._safe_int(cfg_val, DEFAULT_MIN_SAFETY_STAMINA))

    @property
    def allow_marches(self) -> bool:
        """السماح بالمسير القتالي (افتراضياً مفعل طالما المهمة نشطة)."""
        return bool(self.config.get("allow_marches", True))

    @property
    def allow_snipe(self) -> bool:
        """السماح بتنفيذ مهام القناص الصامت (افتراضياً مفعل طالما المهمة نشطة)."""
        return bool(self.config.get("allow_snipe", True))

    @property
    def allow_rescue(self) -> bool:
        """السماح بتنفيذ مهام إنقاذ القرويين (افتراضياً مفعل طالما المهمة نشطة)."""
        return bool(self.config.get("allow_rescue", True))

    @property
    def allow_dialogue(self) -> bool:
        """السماح بتنفيذ مهام المعلومات العسكرية (افتراضياً مفعل طالما المهمة نشطة)."""
        return bool(self.config.get("allow_dialogue", True))

    @property
    def allow_army_group(self) -> bool:
        """السماح بالقضاء على فيلق الغزاة واستلام الجائزة لتجديد المهام تلقائياً (افتراضياً مفعل)."""
        return bool(self.config.get("allow_army_group", True))

    @property
    def auto_upgrade_hall(self) -> bool:
        """السماح بالترقية التلقائية لمستوى قاعة القيادة عند اكتمال نقاط الخبرة (افتراضياً مفعل)."""
        return bool(self.config.get("auto_upgrade_hall", True))

    async def can_run(self) -> Tuple[bool, str]:
        """
        الفحص القبلي الصارم للأمان والجاهزية (0-Network Pre-flight):
        - التحقق من قاطع الاتصال وتوفر اتصال نشط بالبوابة.
        - التحقق من تفعيل المهمة في الإعدادات وقاعدة البيانات.
        - في نمط النشاط اليومي (mode == 'daily'): فحص إنجاز مهمة قاعة القيادة (33) في الذاكرة الحية
          (everydayTaskCtrl) والتجاوز فوراً لحفظ طاقة اللورد والفيالق إن كانت منجزة مسبقاً اليوم.
        - في نمط الدورة الكاملة (mode == 'full'): لا يتم التجاوز وتنفذ الدورة في كل استدعاء.
        """
        # 1. فحص قاطع الاتصال والجاهزية الشبكية والذاكرة الحية (0-Network Pre-flight)
        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بالبوابة."

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة."

        if not self.is_active:
            return False, "المهمة غير مفعلة في الإعدادات."

        # فحص استباقي لمستوى القلعة باستخدام دالة castle_level في base_task.py (0-Network Pre-flight)
        if self.castle_level < 5:
            return (
                False,
                f"قاعة القيادة غير متوفرة لهذه القلعة (مستوى القلعة Lv.{self.castle_level} أقل من المستوى المطلوب Lv.5).",
            )

        # في نمط النشاط اليومي: التجاوز الفوري إذا كانت المهمة منجزة مسبقاً اليوم في النشاط اليومي/الهيبة (0-Network)
        if self.mode == "daily":
            everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
            if isinstance(everyday_ctrl, dict):
                event_info = everyday_ctrl.get("eventInfo")
                if isinstance(event_info, dict):
                    for k in ("33", "4100033", 33, 4100033):
                        if k in event_info and self._safe_int(event_info.get(k), 0) >= 1:
                            val = event_info.get(k)
                            return (
                                False,
                                f"مهمة قاعة القيادة منجزة بالفعل في النشاط اليومي/الهيبة (تقدم النشاط: {val}/1 — تم تجاوز المهمة لباقي اليوم في نمط daily).",
                            )

        return True, "جاهز للتنفيذ."

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة محرك مهام قاعة القيادة بالكامل:
        1. استعلام وفحص المهام المتاحة بقاعة القيادة (get_command_hall_tasks).
        2. المرحلة 1: فرز وتنفيذ مهام القناص الصامت (Sniper 6) أولاً (0 طاقة و 0 مسير وبلا جنود).
        3. المرحلة 2: فرز وتنفيذ مهام إنقاذ القرويين (Rescue 4) (5 طاقة و 0 مسير).
        4. المرحلة 3: فرز وتنفيذ مهام المعلومات العسكرية (Dialogue 3) (5 طاقة و 0 مسير).
        5. المرحلة 4: فرز وتنفيذ مهام المعارك والمسير (فريق الغزاة 5، طليعة الغزاة 2) بالأعلى جودة أولاً.
        6. المرحلة 5: القضاء على فيلق الغزاة (Rebel Legion Boss 1) واستلام الجوائز لتجديد المهام تلقائياً.
        7. إدارة استهلاك الطاقة وحفظ حد الأمان وشواغر الفيالق والجنود بأمان تام.
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

        # فحص إضافي بعد مزامنة البيانات في نمط النشاط اليومي (0-Network)
        if self.mode == "daily" and summary.get("daily_quest_completed"):
            reason = "مهمة قاعة القيادة منجزة بالفعل في النشاط اليومي/الهيبة (تم تجاوز المهمة لباقي اليوم في نمط daily)."
            self.log(f"🛡️ [قاعة القيادة] {reason}")
            return TaskResult.skip(reason)

        self.log(
            f"🏰 [قاعة القيادة] بدء فحص المهام (المستوى: Lv.{hall_lv} | الخبرة: {hall_exp}/{need_exp} "
            f"| الطاقة: {self.stamina} | الفيالق الشاغرة: {self.get_available_marches_count()})."
        )

        all_rewards_collected: List[Dict[str, Any]] = []
        total_stamina_spent = 0
        circuit_broken = False

        # ======================================================================
        # المرحلة 0: الترقية التلقائية الاستباقية لمستوى قاعة القيادة (إن توفرت نقاط الخبرة)
        # ======================================================================
        initial_upgrades = 0
        if not circuit_broken and self.auto_upgrade_hall and summary.get("can_upgrade"):
            try:
                upg_res = await self.execute_command_hall_upgrade_level(max_upgrades=5, wait_seconds=1.0)
                if upg_res.get("success"):
                    initial_upgrades = upg_res.get("upgrades_done", 0)
                    upg_rewards = upg_res.get("rewards") or []
                    if upg_rewards:
                        all_rewards_collected.extend(upg_rewards)
                    # تحديث ملخص المستوى والخبرة محلياً بعد الترقية
                    tasks_data = await self.get_command_hall_tasks(force_sync=False)
                    summary = tasks_data.get("summary", summary)
                    hall_lv = summary.get("command_lv", hall_lv)
                    hall_exp = summary.get("command_exp", hall_exp)
                    need_exp = summary.get("need_exp", need_exp)
            except ConnectionCircuitBreakerError as e:
                self.log(f"⚡ [قاطع الاتصال] تم اعتراض الترقية الاستباقية لقاعة القيادة لانقطاع الاتصال: {e}")
                circuit_broken = True

        # ======================================================================
        # المرحلة 1: تنفيذ مهام القناص الصامت (Sniper Hunter Tasks - Type 6)
        # ======================================================================
        completed_snipe_count = 0
        failed_snipe_count = 0

        eligible_snipe_tasks: List[Dict[str, Any]] = []
        if not circuit_broken and self.allow_snipe:
            eligible_snipe_tasks = [
                t for t in tasks_data.get("executable_tasks", [])
                if self._safe_int(t.get("type")) == TASK_TYPE_SNIPE
                and self._safe_int(t.get("statue")) == TASK_STATUE_READY
            ]
            # فرز بالأعلى جودة أولاً
            eligible_snipe_tasks.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)

        if not circuit_broken and eligible_snipe_tasks:
            self.log(f"🎯 [قاعة القيادة] المرحلة 1: رصد {len(eligible_snipe_tasks)} مهمة قناص صامت جاهزة للتنفيذ (استهلاك طاقة: 0).")
            for s_idx, s_task in enumerate(eligible_snipe_tasks, 1):
                # فحص قاطع الاتصال قبل تنفيذ المهمة
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال بالسيرفر — إيقاف مهام القناص فوراً.")
                    circuit_broken = True
                    break

                task_id = self._safe_int(s_task.get("task_id"), 0)
                task_index = self._safe_int(s_task.get("index"), 0)
                quality_name = s_task.get("quality_name_ar", str(s_task.get("quality", "")))

                self.log(
                    f"🏹 [قاعة القيادة] ({s_idx}/{len(eligible_snipe_tasks)}) تنفيذ مهمة القناص الصامت #{task_index} "
                    f"(ID: {task_id} | جودة: {quality_name})..."
                )

                try:
                    snipe_res = await self.execute_command_hall_snipe_task(s_task, wait_seconds=2.5)
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة القناص الصامت #{task_index} لانقطاع الاتصال: {e}")
                    circuit_broken = True
                    break

                if snipe_res.get("success"):
                    completed_snipe_count += 1
                    s_rewards = snipe_res.get("rewards") or []
                    if s_rewards:
                        all_rewards_collected.extend(s_rewards)
                    self.log(f"✅ [قاعة القيادة] اكتملت مهمة القناص الصامت #{task_index} بنجاح!")

                    # فاصل زمني بشري عشوائي بين مهام القناص
                    if s_idx < len(eligible_snipe_tasks):
                        await asyncio.sleep(random.uniform(1.0, 1.8))
                else:
                    failed_snipe_count += 1
                    reason = snipe_res.get("reason", "خطأ غير محدد")
                    self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز مهمة القناص الصامت #{task_index}: {reason}")

        # ======================================================================
        # المرحلة 2: تنفيذ مهام إنقاذ القرويين (Rescue Tasks - Type 4)
        # ======================================================================
        completed_rescue_count = 0
        failed_rescue_count = 0

        eligible_rescue_tasks: List[Dict[str, Any]] = []
        if not circuit_broken and self.allow_rescue:
            eligible_rescue_tasks = [
                t for t in tasks_data.get("executable_tasks", [])
                if self._safe_int(t.get("type")) == TASK_TYPE_RESCUE
                and self._safe_int(t.get("statue")) in (1, 2, 3)
            ]
            # فرز بالأعلى جودة أولاً
            eligible_rescue_tasks.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)
        elif not self.allow_rescue:
            self.log("ℹ️ [قاعة القيادة] تم تخطي مهام إنقاذ القرويين (خيار allow_rescue غير مفعل في إعدادات القلعة).")

        if not circuit_broken and eligible_rescue_tasks:
            self.log(f"🤝 [قاعة القيادة] المرحلة 2: رصد {len(eligible_rescue_tasks)} مهمة إنقاذ قرويين جاهزة للتنفيذ (استهلاك 5 طاقة).")
            for r_idx, r_task in enumerate(eligible_rescue_tasks, 1):
                # فحص قاطع الاتصال قبل تنفيذ المهمة
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال بالسيرفر — إيقاف مهام الإنقاذ فوراً.")
                    circuit_broken = True
                    break

                task_id = self._safe_int(r_task.get("task_id"), 0)
                task_index = self._safe_int(r_task.get("index"), 0)
                quality_name = r_task.get("quality_name_ar", str(r_task.get("quality", "")))
                statue = self._safe_int(r_task.get("statue"), 2)

                # فحص مسبق لطاقة اللورد قبل تنفيذ الإنقاذ لحماية حد الأمان
                if statue != 3 and self.stamina < (5 + self.min_safety_stamina):
                    self.log(
                        f"🛑 [قاعة القيادة] التوقف عن إنقاذ القرويين للحفاظ على حد أمان الطاقة بالقلعة "
                        f"({self.stamina} متوفر | المطلوب: {5 + self.min_safety_stamina})."
                    )
                    break

                self.log(
                    f"🤝 [قاعة القيادة] ({r_idx}/{len(eligible_rescue_tasks)}) تنفيذ مهمة إنقاذ القرويين #{task_index} "
                    f"(ID: {task_id} | جودة: {quality_name} | استهلاك 5 طاقة)..."
                )

                try:
                    rescue_res = await self.execute_command_hall_rescue_task(
                        r_task, wait_seconds=2.2, min_safety_stamina=self.min_safety_stamina
                    )
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة إنقاذ القرويين #{task_index} لانقطاع الاتصال: {e}")
                    circuit_broken = True
                    break

                if rescue_res.get("success"):
                    completed_rescue_count += 1
                    total_stamina_spent += rescue_res.get("stamina_spent", 5)
                    r_rewards = rescue_res.get("rewards") or []
                    if r_rewards:
                        all_rewards_collected.extend(r_rewards)
                    self.log(f"✅ [قاعة القيادة] اكتملت مهمة إنقاذ القرويين #{task_index} بنجاح!")

                    # فاصل زمني بشري عشوائي بين مهام الإنقاذ
                    if r_idx < len(eligible_rescue_tasks):
                        await asyncio.sleep(random.uniform(1.0, 1.8))
                else:
                    failed_rescue_count += 1
                    reason = rescue_res.get("reason", "خطأ غير محدد")
                    self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز مهمة إنقاذ القرويين #{task_index}: {reason}")

        # ======================================================================
        # المرحلة 3: تنفيذ مهام المعلومات العسكرية (Military Intelligence Tasks - Type 3)
        # ======================================================================
        completed_dialogue_count = 0
        failed_dialogue_count = 0

        eligible_dialogue_tasks: List[Dict[str, Any]] = []
        if not circuit_broken and self.allow_dialogue:
            eligible_dialogue_tasks = [
                t for t in tasks_data.get("executable_tasks", [])
                if self._safe_int(t.get("type")) == TASK_TYPE_DIALOGUE
                and self._safe_int(t.get("statue")) in (1, 2, 3)
            ]
            # فرز بالأعلى جودة أولاً
            eligible_dialogue_tasks.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)
        elif not self.allow_dialogue:
            self.log("ℹ️ [قاعة القيادة] تم تخطي مهام المعلومات العسكرية (خيار allow_dialogue غير مفعل في إعدادات القلعة).")

        if not circuit_broken and eligible_dialogue_tasks:
            self.log(f"📜 [قاعة القيادة] المرحلة 3: رصد {len(eligible_dialogue_tasks)} مهمة معلومات عسكرية جاهزة للتنفيذ (استهلاك 5 طاقة).")
            for d_idx, d_task in enumerate(eligible_dialogue_tasks, 1):
                # فحص قاطع الاتصال قبل تنفيذ المهمة
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال بالسيرفر — إيقاف مهام المعلومات العسكرية فوراً.")
                    circuit_broken = True
                    break

                task_id = self._safe_int(d_task.get("task_id"), 0)
                task_index = self._safe_int(d_task.get("index"), 0)
                quality_name = d_task.get("quality_name_ar", str(d_task.get("quality", "")))
                statue = self._safe_int(d_task.get("statue"), 2)

                # فحص مسبق لطاقة اللورد قبل تنفيذ المهمة لحماية حد الأمان
                if statue != 3 and self.stamina < (5 + self.min_safety_stamina):
                    self.log(
                        f"🛑 [قاعة القيادة] التوقف عن مهام المعلومات العسكرية للحفاظ على حد أمان الطاقة بالقلعة "
                        f"({self.stamina} متوفر | المطلوب: {5 + self.min_safety_stamina})."
                    )
                    break

                self.log(
                    f"📜 [قاعة القيادة] ({d_idx}/{len(eligible_dialogue_tasks)}) تنفيذ مهمة المعلومات العسكرية #{task_index} "
                    f"(ID: {task_id} | جودة: {quality_name} | استهلاك 5 طاقة)..."
                )

                try:
                    dialogue_res = await self.execute_command_hall_dialogue_task(
                        d_task, wait_seconds=1.5, min_safety_stamina=self.min_safety_stamina
                    )
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة المعلومات العسكرية #{task_index} لانقطاع الاتصال: {e}")
                    circuit_broken = True
                    break

                if dialogue_res.get("success"):
                    completed_dialogue_count += 1
                    total_stamina_spent += dialogue_res.get("stamina_spent", 5)
                    d_rewards = dialogue_res.get("rewards") or []
                    if d_rewards:
                        all_rewards_collected.extend(d_rewards)
                    self.log(f"✅ [قاعة القيادة] اكتملت مهمة المعلومات العسكرية #{task_index} بنجاح!")

                    # فاصل زمني بشري عشوائي بين مهام الحوار
                    if d_idx < len(eligible_dialogue_tasks):
                        await asyncio.sleep(random.uniform(1.0, 1.8))
                else:
                    failed_dialogue_count += 1
                    reason = dialogue_res.get("reason", "خطأ غير محدد")
                    self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز مهمة المعلومات العسكرية #{task_index}: {reason}")

        # ======================================================================
        # المرحلة 4: تنفيذ مهام المعارك والمسير (Battle Tasks - Type 5 & Type 2)
        # ======================================================================
        completed_battle_count = 0
        failed_battle_count = 0

        eligible_battle_tasks: List[Dict[str, Any]] = []
        if not circuit_broken and self.allow_marches:
            march_tasks = tasks_data.get("march_tasks", [])
            eligible_battle_tasks = [
                t for t in march_tasks
                if self._safe_int(t.get("type")) in (TASK_TYPE_BATTLE, TASK_TYPE_REBEL_PIONEER)
                and self._safe_int(t.get("statue")) == TASK_STATUE_READY
            ]
            # فرز بالأعلى جودة أولاً (Quality Descending: 6 ذهبي -> 5 برتقالي -> 4 بنفسجي -> 3 أزرق)
            eligible_battle_tasks.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)
        elif not self.allow_marches:
            self.log("ℹ️ [قاعة القيادة] تم تخطي مهام المعارك والمسير (خيار allow_marches غير مفعل في إعدادات القلعة).")

        if not circuit_broken and eligible_battle_tasks:
            self.log(f"⚔️ [قاعة القيادة] المرحلة 4: رصد {len(eligible_battle_tasks)} مهام قتالية جاهزة للتنفيذ (مرتبة بالأعلى جودة أولاً).")

            for task_idx, task_item in enumerate(eligible_battle_tasks, 1):
                # فحص قاطع الاتصال قبل تنفيذ المهمة
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال بالسيرفر — إيقاف مهام المعارك والمسير فوراً.")
                    circuit_broken = True
                    break

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
                        f"🛑 [قاعة القيادة] التوقف عن تنفيذ باقي المعارك للحفاظ على حد أمان الطاقة بالقلعة "
                        f"({current_stamina} متوفر | المطلوب: {min_needed_stamina} تشمل {self.min_safety_stamina} حد أمان)."
                    )
                    break

                # ب) التأكد من شاغرية الفيلق قبل إرسال المسير (فيلق واحد فقط في كل مرة)
                avail_marches = self.get_available_marches_count()
                if avail_marches <= 0:
                    self.log("⏳ [قاعة القيادة] انتظار عودة الفيالق النشطة بالخارج...")
                    waited = 0
                    while self.get_available_marches_count() <= 0 and waited < 10:
                        if not self.conn or not getattr(self.conn, "is_connected", False):
                            circuit_broken = True
                            break
                        await asyncio.sleep(2.0)
                        waited += 2

                    if circuit_broken:
                        break

                    if self.get_available_marches_count() <= 0:
                        self.log("⚠️ [قاعة القيادة] تعذر استكمال باقي المعارك لعدم توفر فيالق شاغرة.")
                        break

                # ج) فحص القوات المقاتلة بالقلعة
                if self.get_available_troops_count() <= 0:
                    self.log("⚠️ [قاعة القيادة] نفدت القوات المقاتلة الشاغرة بالقلعة لتشكيل الفيلق. توقف معارك المسير.")
                    break

                self.log(
                    f"⚔️ [قاعة القيادة] ({task_idx}/{len(eligible_battle_tasks)}) تنفيذ مهمة {type_name} #{task_index} "
                    f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
                )

                # د) استدعاء دالة تنفيذ المعركة الرسمية الموثقة في BaseTask
                try:
                    exec_res = await self.execute_command_hall_battle_task(task_item, wait_seconds=7.0)
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة {type_name} #{task_index} لانقطاع الاتصال: {e}")
                    circuit_broken = True
                    break

                if exec_res.get("success"):
                    completed_battle_count += 1
                    total_stamina_spent += exec_res.get("stamina_spent", stamina_cost)
                    task_rewards = exec_res.get("rewards") or []
                    if task_rewards:
                        all_rewards_collected.extend(task_rewards)

                    self.log(f"✅ [قاعة القيادة] اكتملت المهمة القتالية #{task_index} بنجاح!")

                    # فاصل بشري عشوائي ذكي وآمن بين المعارك (Human Jitter)
                    if task_idx < len(eligible_battle_tasks):
                        jitter = random.uniform(1.0, 2.0)
                        await asyncio.sleep(jitter)
                else:
                    failed_battle_count += 1
                    fail_reason = exec_res.get("reason", "خطأ غير محدد")
                    self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز المهمة القتالية #{task_index} ({fail_reason}).")

        # ======================================================================
        # المرحلة 5: القضاء على فيلق الغزاة وتجديد المهام (Rebel Legion Boss - Type 1)
        # ======================================================================
        completed_army_group_count = 0
        failed_army_group_count = 0

        if not circuit_broken and self.allow_army_group:
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال — تخطي هجوم فيلق الغزاة فوراً.")
                circuit_broken = True
            else:
                # قراءة حالة فيلق الغزاة من الذاكرة الحية (0-Network)
                hall_info = self.get_ctrl("commandHall")
                ag_task = hall_info.get("armyGroupTaskData") if isinstance(hall_info, dict) else None

                if isinstance(ag_task, dict) and ag_task.get("index"):
                    r_hp = self._safe_int(ag_task.get("rabelHp"), 1000)
                    h_hp = self._safe_int(ag_task.get("hurtHp"), 0)
                    st = self._safe_int(ag_task.get("statue"), 2)
                    p_count = self._safe_int(hall_info.get("armyPioneerTaskCount"), 0)

                    # شرط القضاء على الفيلق: صحة الفيلق 0 (أو statue == 3) وعدم وجود مهام طليعة معلقة
                    if (h_hp >= r_hp or st == 3) and p_count == 0:
                        self.log(
                            f"👑 [قاعة القيادة] المرحلة 5: رصد جاهزية فيلق الغزاة للقضاء عليه وتجديد المهام "
                            f"(ضرر: {h_hp}/{r_hp} | طليعة متبقية: {p_count})."
                        )
                        try:
                            ag_res = await self.execute_command_hall_army_group_task(ag_task, wait_seconds=1.5)
                        except ConnectionCircuitBreakerError as e:
                            self.log(f"⚡ [قاطع الاتصال] تم اعتراض القضاء على فيلق الغزاة لانقطاع الاتصال: {e}")
                            circuit_broken = True
                            ag_res = {"success": False, "reason": str(e)}

                        if ag_res.get("success"):
                            completed_army_group_count += 1
                            ag_rewards = ag_res.get("rewards") or []
                            if ag_rewards:
                                all_rewards_collected.extend(ag_rewards)
                            self.log(f"🎉 [قاعة القيادة] اكتمل القضاء على فيلق الغزاة بنجاح وتجددت حزمة المهام الجديدة!")
                        elif not circuit_broken:
                            failed_army_group_count += 1
                            self.log(f"⚠️ [قاعة القيادة] تعذر القضاء على فيلق الغزاة: {ag_res.get('reason')}")
                    elif (h_hp >= r_hp or st == 3) and p_count > 0:
                        self.log(f"ℹ️ [قاعة القيادة] تأجيل القضاء على فيلق الغزاة لحين إنجاز {p_count} مهمة طليعة غزاة أولاً لمنع ضياع جوائزها.")

        # ======================================================================
        # المرحلة 5.5: الترقية الختامية لمستوى قاعة القيادة (لاستيعاب أي نقاط خبرة اكتسبت حديثاً)
        # ======================================================================
        final_upgrades = 0
        if not circuit_broken and self.auto_upgrade_hall:
            if not self.conn or not getattr(self.conn, "is_connected", False):
                circuit_broken = True
            else:
                hall_info_end = self.get_ctrl("commandHall")
                if isinstance(hall_info_end, dict):
                    end_lv = self._safe_int(hall_info_end.get("commandLv"), 1)
                    end_exp = self._safe_int(hall_info_end.get("commandExp"), 0)
                    end_need = COMMAND_HALL_EXP_BY_LV.get(end_lv, 0)
                    if end_lv < COMMAND_HALL_MAX_LEVEL and end_need > 0 and end_exp >= end_need:
                        try:
                            upg_res_end = await self.execute_command_hall_upgrade_level(max_upgrades=5, wait_seconds=1.0)
                            if upg_res_end.get("success"):
                                final_upgrades = upg_res_end.get("upgrades_done", 0)
                                upg_rewards_end = upg_res_end.get("rewards") or []
                                if upg_rewards_end:
                                    all_rewards_collected.extend(upg_rewards_end)
                                # تحديث الملخص الختامي بعد الترقية
                                tasks_data = await self.get_command_hall_tasks(force_sync=False)
                                summary = tasks_data.get("summary", summary)
                        except ConnectionCircuitBreakerError as e:
                            self.log(f"⚡ [قاطع الاتصال] تم اعتراض الترقية الختامية لقاعة القيادة لانقطاع الاتصال: {e}")
                            circuit_broken = True

        total_hall_upgrades = initial_upgrades + final_upgrades

        # ======================================================================
        # المرحلة 6: تجميع الإحصائيات والنتيجة النهائية
        # ======================================================================
        exec_duration = time.perf_counter() - t0
        total_completed = completed_snipe_count + completed_rescue_count + completed_dialogue_count + completed_battle_count + completed_army_group_count
        total_failed = failed_snipe_count + failed_rescue_count + failed_dialogue_count + failed_battle_count + failed_army_group_count

        if total_completed > 0 or total_hall_upgrades > 0:
            details = []
            if total_hall_upgrades > 0:
                details.append(f"{total_hall_upgrades} ترقية لمستوى القاعة (وصلت Lv.{summary.get('command_lv')})")
            if completed_snipe_count > 0:
                details.append(f"{completed_snipe_count} قناص صامت")
            if completed_rescue_count > 0:
                details.append(f"{completed_rescue_count} إنقاذ قرويين")
            if completed_dialogue_count > 0:
                details.append(f"{completed_dialogue_count} معلومات عسكرية")
            if completed_battle_count > 0:
                details.append(f"{completed_battle_count} معارك قتالية")
            if completed_army_group_count > 0:
                details.append(f"{completed_army_group_count} فيلق غزاة (تجديد المهام)")
            details_str = " و ".join(details)
            breaker_note = " (تم تفعيل قاطع الاتصال وتوقف باقي المهام لانقطاع الاتصال بالسيرفر)" if circuit_broken else ""
            result_msg = (
                f"تم إنجاز {details_str} بنجاح بقاعة القيادة{breaker_note} "
                f"(إجمالي المهام المكتملة: {total_completed} | ترقيات القاعة: {total_hall_upgrades} | استهلاك طاقة: {total_stamina_spent} | فاشل: {total_failed})."
            )
            return TaskResult.ok(
                result_msg,
                data={
                    "completed_tasks": total_completed,
                    "completed_hall_upgrades": total_hall_upgrades,
                    "completed_snipe": completed_snipe_count,
                    "completed_rescue": completed_rescue_count,
                    "completed_dialogue": completed_dialogue_count,
                    "completed_battle": completed_battle_count,
                    "completed_army_group": completed_army_group_count,
                    "failed_tasks": total_failed,
                    "stamina_spent": total_stamina_spent,
                    "circuit_broken": circuit_broken,
                    "rewards_count": len(all_rewards_collected),
                    "rewards": all_rewards_collected,
                    "summary": summary,
                },
                exec_time=exec_duration,
            )

        if circuit_broken or not self.conn or not getattr(self.conn, "is_connected", False):
            raise ConnectionCircuitBreakerError("تم إيقاف مهمة قاعة القيادة فوراً بواسطة قاطع الاتصال لعدم توفر اتصال نشط بالخادم.")

        if total_failed > 0:
            return TaskResult.fail(
                f"فشل إنجاز مهام قاعة القيادة المرصودة ({total_failed} مهام فشلت).",
                exec_time=exec_duration,
            )

        if not eligible_snipe_tasks and not eligible_rescue_tasks and not eligible_dialogue_tasks and not eligible_battle_tasks and completed_army_group_count == 0 and total_hall_upgrades == 0:
            return TaskResult.ok(
                "تم فحص مهام قاعة القيادة — لا توجد مهام (قناص، إنقاذ، معلومات، معارك، أو فيلق) جاهزة للتنفيذ حالياً.",
                data={"summary": summary, "completed_tasks": 0, "completed_hall_upgrades": 0},
                exec_time=exec_duration,
            )

        return TaskResult.ok(
            "تم فحص مهام قاعة القيادة — لم تتطلب الدورة تنفيذ أي مهام جديدة.",
            data={"summary": summary, "completed_tasks": 0, "completed_hall_upgrades": 0},
            exec_time=exec_duration,
        )
