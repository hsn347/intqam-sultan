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
    COMMAND_HALL_OPEN_LV,
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

# تكلفة الطاقة الافتراضية لكل مهمة معركة (مطابق لـ newcommandhalltask.lua -> consume = 5)
STAMINA_COST_PER_BATTLE = 5

# الحد الأدنى لأمان الطاقة المحفوظة في القلعة لمنع تصفير طاقة اللورد
DEFAULT_MIN_SAFETY_STAMINA = 10


class CommandHallTask(BaseTask):
    """
    محرك مهام قاعة القيادة التلقائي المتكامل:
    ينفذ مهام المعارك والمسير (فريق الغزاة 5 وطليعة الغزاة 2) بفيلق واحد فقط بالتسلسل،
    ويتحقق من طاقة اللورد والشواغر وقوة القتل المؤكد عبر MarchManagerTask و march_capacity.py.
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
        """نمط التنفيذ: 'daily' (إنجاز شرط النشاط اليومي 3/3 مهام قاعة القيادة ثم التوقف) أو 'full' (إنجاز جميع المهام المتاحة)."""
        return str(self.config.get("mode", "daily")).lower().strip()

    @property
    def min_safety_stamina(self) -> int:
        """حد الأمان الأدنى لطاقة اللورد المطلوب الحفاظ عليه بالقلعة (يدعم القيمة 0 بشكل صحيح)."""
        if self.config.get("min_stamina") is not None:
            cfg_val = self.config.get("min_stamina")
        elif self.config.get("min_safety_stamina") is not None:
            cfg_val = self.config.get("min_safety_stamina")
        else:
            cfg_val = DEFAULT_MIN_SAFETY_STAMINA
        return max(0, self._safe_int(cfg_val, DEFAULT_MIN_SAFETY_STAMINA))

    def _is_daily_goal_met(self) -> bool:
        """التحقق في وضع daily مما إذا كانت مهمة النشاط اليومي (33) قد أُنجزت (3/3 مهام مكتملة)."""
        if self.mode != "daily":
            return False
        is_completed, _, _ = self.get_command_hall_daily_status()
        return is_completed

    def _log_daily_goal_reached(self, scope_ar: str) -> None:
        """طباعة رسالة موحدة ودقيقة عند تحقق هدف النشاط اليومي (3/3) في نمط daily."""
        _, done_cnt, target_cnt = self.get_command_hall_daily_status()
        self.log(
            f"✅ [قاعة القيادة] تحقق هدف النشاط اليومي ({done_cnt}/{target_cnt} مهام قاعة القيادة) في نمط daily — التوقف عن باقي {scope_ar}."
        )

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

    async def _run_instant_phase(
        self,
        tasks_data: Dict[str, Any],
        task_type: int,
        phase_num: int,
        icon: str,
        plural_label: str,
        item_label: str,
        daily_stop_label: str,
        disabled_msg: Optional[str],
        allowed: bool,
        executor: Any,
        wait_seconds: float,
        all_rewards_collected: List[Dict[str, Any]],
    ) -> Tuple[int, int, int, bool, bool]:
        """
        تنفيذ موحد لمراحل المهام الفورية (القناص الصامت 6، إنقاذ القرويين 4، المعلومات العسكرية 3):
        - يفرز المهام بالأعلى جودة أولاً.
        - يلتزم بحد أمان الطاقة (stamina_cost + min_safety_stamina) لكل مهمة قبل التنفيذ.
        - يتوقف فوراً عند تحقق هدف النشاط اليومي (3/3) في نمط daily أو عند انقطاع الاتصال.
        """
        if not allowed:
            if disabled_msg:
                self.log(disabled_msg)
            return 0, 0, 0, False, False

        if self._is_daily_goal_met():
            return 0, 0, 0, False, False

        eligible = [
            t for t in tasks_data.get("executable_tasks", [])
            if self._safe_int(t.get("type")) == task_type
            and self._safe_int(t.get("statue")) in (1, 2, 3)
        ]
        if not eligible:
            return 0, 0, 0, False, False

        eligible.sort(key=lambda x: self._safe_int(x.get("quality"), 0), reverse=True)
        self.log(
            f"{icon} [قاعة القيادة] المرحلة {phase_num}: رصد {len(eligible)} مهمة {plural_label} جاهزة للتنفيذ (استهلاك 5 طاقة)."
        )

        completed = 0
        failed = 0
        stamina_spent = 0

        for idx, t_item in enumerate(eligible, 1):
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log(f"⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال بالسيرفر — إيقاف مهام {plural_label} فوراً.")
                return completed, failed, stamina_spent, True, True

            task_id = self._safe_int(t_item.get("task_id"), 0)
            task_index = self._safe_int(t_item.get("index"), 0)
            quality_name = t_item.get("quality_name_ar", str(t_item.get("quality", "")))
            statue = self._safe_int(t_item.get("statue"), 2)
            task_consume = self._safe_int(t_item.get("stamina_cost"), 5)
            if task_consume <= 0:
                task_consume = 5

            if statue != 3 and self.stamina < (task_consume + self.min_safety_stamina):
                self.log(
                    f"🛑 [قاعة القيادة] التوقف عن {plural_label} للحفاظ على حد أمان الطاقة بالقلعة "
                    f"({self.stamina} متوفر | المطلوب: {task_consume + self.min_safety_stamina})."
                )
                break

            self.log(
                f"{icon} [قاعة القيادة] ({idx}/{len(eligible)}) تنفيذ مهمة {item_label} #{task_index} "
                f"(ID: {task_id} | جودة: {quality_name} | استهلاك {task_consume} طاقة)..."
            )

            try:
                exec_res = await executor(
                    t_item, wait_seconds=wait_seconds, min_safety_stamina=self.min_safety_stamina
                )
            except ConnectionCircuitBreakerError as e:
                self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة {item_label} #{task_index} لانقطاع الاتصال: {e}")
                return completed, failed, stamina_spent, True, True

            if exec_res.get("success"):
                completed += 1
                default_spent = task_consume if statue != 3 else 0
                stamina_spent += self._safe_int(exec_res.get("stamina_spent"), default_spent)
                t_rewards = exec_res.get("rewards") or []
                if t_rewards:
                    all_rewards_collected.extend(t_rewards)
                self.log(f"✅ [قاعة القيادة] اكتملت مهمة {item_label} #{task_index} بنجاح!")

                if self._is_daily_goal_met():
                    self._log_daily_goal_reached(daily_stop_label)
                    break

                if idx < len(eligible):
                    await asyncio.sleep(random.uniform(1.0, 1.8))
            else:
                failed += 1
                reason = exec_res.get("reason", "خطأ غير محدد")
                self.log(f"⚠️ [قاعة القيادة] تعذر إنجاز مهمة {item_label} #{task_index}: {reason}")

        return completed, failed, stamina_spent, True, False

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

        # فحص استباقي لمستوى القلعة وفق ثابت اللعبة (COMMANDHALL_OPEN_LV = 3) عبر base_task.py (0-Network Pre-flight)
        unlocked, lock_reason = self.is_command_hall_unlocked()
        if not unlocked:
            return False, lock_reason

        # في نمط النشاط اليومي: التجاوز الفوري إذا كانت المهمة منجزة مسبقاً اليوم في النشاط اليومي/الهيبة (0-Network)
        if self.mode == "daily":
            is_completed, done_cnt, target_cnt = self.get_command_hall_daily_status()
            if is_completed:
                return (
                    False,
                    f"مهمة قاعة القيادة منجزة بالفعل في النشاط اليومي/الهيبة (تقدم النشاط: {done_cnt}/{target_cnt} مهام — تم تجاوز المهمة لباقي اليوم في نمط daily).",
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
        need_exp = summary.get("need_exp", self.get_command_hall_need_exp(hall_lv))

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
        # المرحلة 0.5: استلام جوائز المهام المكتملة مسبقاً (statue == 3) مجاناً (0 طاقة و 0 فيالق)
        # ======================================================================
        completed_claimed_count = 0
        claimable_list = [
            t for t in tasks_data.get("claimable_tasks", [])
            if self._safe_int(t.get("statue")) == TASK_STATUE_FINISH
            and self._safe_int(t.get("type")) in (2, 3, 4, 5, 6)
            and self._safe_int(t.get("index")) > 0
        ]
        if not circuit_broken and claimable_list:
            self.log(f"🎁 [قاعة القيادة] المرحلة 0.5: رصد {len(claimable_list)} مهمة مكتملة مسبقاً (statue=3) جاهزة للاستلام الفوري...")
            for c_task in claimable_list:
                if not self.conn or not getattr(self.conn, "is_connected", False):
                    circuit_broken = True
                    break
                c_idx = self._safe_int(c_task.get("index"), 0)
                c_type = self._safe_int(c_task.get("type"), 0)
                try:
                    c_resp = await self.safe_query(
                        CMD_COMMAND_HALL_MODULE,
                        REQ_COMMAND_HALL_COMMIT_TASK,
                        {"commitType": c_type, "index": c_idx},
                        min_delay=0.4,
                        max_delay=0.8,
                    )
                except ConnectionCircuitBreakerError:
                    circuit_broken = True
                    break
                if isinstance(c_resp, dict) and str(c_resp.get("err", c_resp.get("code", "0"))).strip() in ("0", "Err_None"):
                    completed_claimed_count += 1
                    c_rsp = c_resp.get("rspdata") if isinstance(c_resp.get("rspdata"), dict) else {}
                    c_rew = c_rsp.get("reward") or c_resp.get("reward") or []
                    if c_rew:
                        all_rewards_collected.extend(c_rew)
                    c_init = c_rsp.get("initData")
                    if isinstance(c_init, dict):
                        self._sync_command_hall_init_data(c_init)
                    else:
                        self._mark_command_hall_task_claimed(c_idx, c_type)
                    self._record_command_hall_subtask_completion(1)
                    self.log(f"✅ [قاعة القيادة] تم استلام جائزة المهمة المكتملة مسبقاً #{c_idx} بنجاح!")
                else:
                    self.log(f"⚠️ [قاعة القيادة] تعذر استلام المهمة #{c_idx} (الرد: {c_resp}).")

            # تحديث قائمة المهام بعد الاستلام المجاني
            if completed_claimed_count > 0 and not circuit_broken:
                tasks_data = await self.get_command_hall_tasks(force_sync=False)
                summary = tasks_data.get("summary", summary)

        # ======================================================================
        # المرحلة 1: تنفيذ مهام القناص الصامت (Sniper Hunter Tasks - Type 6)
        # ======================================================================
        completed_snipe_count, failed_snipe_count, snipe_stamina, has_snipe_eligible, cb_1 = (
            await self._run_instant_phase(
                tasks_data=tasks_data,
                task_type=TASK_TYPE_SNIPE,
                phase_num=1,
                icon="🎯",
                plural_label="قناص صامت",
                item_label="القناص الصامت",
                daily_stop_label="مهام القناص",
                disabled_msg=None,
                allowed=self.allow_snipe and not circuit_broken,
                executor=self.execute_command_hall_snipe_task,
                wait_seconds=2.5,
                all_rewards_collected=all_rewards_collected,
            )
        )
        total_stamina_spent += snipe_stamina
        if cb_1:
            circuit_broken = True

        # ======================================================================
        # المرحلة 2: تنفيذ مهام إنقاذ القرويين (Rescue Tasks - Type 4)
        # ======================================================================
        completed_rescue_count, failed_rescue_count, rescue_stamina, has_rescue_eligible, cb_2 = (
            await self._run_instant_phase(
                tasks_data=tasks_data,
                task_type=TASK_TYPE_RESCUE,
                phase_num=2,
                icon="🤝",
                plural_label="إنقاذ قرويين",
                item_label="إنقاذ القرويين",
                daily_stop_label="مهام الإنقاذ",
                disabled_msg="ℹ️ [قاعة القيادة] تم تخطي مهام إنقاذ القرويين (خيار allow_rescue غير مفعل في إعدادات القلعة).",
                allowed=self.allow_rescue and not circuit_broken,
                executor=self.execute_command_hall_rescue_task,
                wait_seconds=2.2,
                all_rewards_collected=all_rewards_collected,
            )
        )
        total_stamina_spent += rescue_stamina
        if cb_2:
            circuit_broken = True

        # ======================================================================
        # المرحلة 3: تنفيذ مهام المعلومات العسكرية (Military Intelligence Tasks - Type 3)
        # ======================================================================
        completed_dialogue_count, failed_dialogue_count, dialogue_stamina, has_dialogue_eligible, cb_3 = (
            await self._run_instant_phase(
                tasks_data=tasks_data,
                task_type=TASK_TYPE_DIALOGUE,
                phase_num=3,
                icon="📜",
                plural_label="معلومات عسكرية",
                item_label="المعلومات العسكرية",
                daily_stop_label="مهام الحوار",
                disabled_msg="ℹ️ [قاعة القيادة] تم تخطي مهام المعلومات العسكرية (خيار allow_dialogue غير مفعل في إعدادات القلعة).",
                allowed=self.allow_dialogue and not circuit_broken,
                executor=self.execute_command_hall_dialogue_task,
                wait_seconds=1.5,
                all_rewards_collected=all_rewards_collected,
            )
        )
        total_stamina_spent += dialogue_stamina
        if cb_3:
            circuit_broken = True

        # ======================================================================
        # المرحلة 4: تنفيذ مهام المعارك والمسير (Battle Tasks - Type 5 & Type 2)
        # ======================================================================
        completed_battle_count = 0
        failed_battle_count = 0

        eligible_battle_tasks: List[Dict[str, Any]] = []
        if not circuit_broken and self.allow_marches and not self._is_daily_goal_met():
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
            self.log(f"⚔️ [قاعة القيادة] المرحلة 4: رصد {len(eligible_battle_tasks)} مهام قتالية جاهزة للتنفيذ (فيلق واحد بالتسلسل بالأعلى جودة أولاً).")

            for task_idx, task_item in enumerate(eligible_battle_tasks, 1):
                if self._is_daily_goal_met():
                    self._log_daily_goal_reached("المعارك لحفظ الطاقة")
                    break

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
                spec = self.get_command_hall_task_spec(task_id)
                stamina_cost = self._safe_int(task_item.get("stamina_cost"), spec["consume"])
                if stamina_cost <= 0:
                    stamina_cost = spec["consume"]

                # أ) فحص مسبق صارم لطاقة اللورد قبل كل مهمة لحماية حد الأمان
                min_needed_stamina = stamina_cost + self.min_safety_stamina
                current_stamina = self.stamina
                if current_stamina < min_needed_stamina:
                    self.log(
                        f"🛑 [قاعة القيادة] التوقف عن تنفيذ باقي المعارك للحفاظ على حد أمان الطاقة بالقلعة "
                        f"({current_stamina} متوفر | المطلوب: {min_needed_stamina} تشمل {self.min_safety_stamina} حد أمان)."
                    )
                    break

                # ب) التحقق الفوري من شاغرية الفيلق (تخطي فوري بدون انتظار عند امتلاء الفيالق)
                if self.get_available_marches_count() <= 0:
                    self.log("⏭️ [قاعة القيادة] لا توجد فيالق شاغرة حالياً — تخطي مهام المعارك فوراً دون انتظار.")
                    break

                self.log(
                    f"⚔️ [قاعة القيادة] ({task_idx}/{len(eligible_battle_tasks)}) تنفيذ مهمة {type_name} #{task_index} "
                    f"(ID: {task_id} | جودة: {quality_name} | استهلاك {stamina_cost} طاقة)..."
                )

                # ج) استدعاء دالة تنفيذ المعركة الموحّدة (فيلق واحد فقط + انتظار العودة للقلعة)
                try:
                    exec_res = await self.execute_command_hall_battle_task(
                        task_item,
                        wait_seconds=7.0,
                        wait_for_return=True,
                    )
                except ConnectionCircuitBreakerError as e:
                    self.log(f"⚡ [قاطع الاتصال] تم اعتراض مهمة {type_name} #{task_index} لانقطاع الاتصال: {e}")
                    circuit_broken = True
                    break

                if exec_res.get("disconnected"):
                    circuit_broken = True
                    break

                if exec_res.get("skipped_unbeatable"):
                    # تخطي آمن لأن التشكيلة الحالية غير كافية لقتل هذا الهدف (قد تنجح مهمة أضعف تالية)
                    continue

                if exec_res.get("success"):
                    completed_battle_count += 1
                    total_stamina_spent += exec_res.get("stamina_spent", stamina_cost)
                    task_rewards = exec_res.get("rewards") or []
                    if task_rewards:
                        all_rewards_collected.extend(task_rewards)

                    self.log(f"✅ [قاعة القيادة] اكتملت المهمة القتالية #{task_index} بنجاح!")

                    # فاصل بشري عشوائي بين المعارك بعد عودة الفيلق فعلياً
                    if task_idx < len(eligible_battle_tasks) and not self._is_daily_goal_met():
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

        if not circuit_broken and self.allow_army_group and not self._is_daily_goal_met():
            if not self.conn or not getattr(self.conn, "is_connected", False):
                self.log("⚡ [قاطع الاتصال] تم رصد انقطاع الاتصال — تخطي هجوم فيلق الغزاة فوراً.")
                circuit_broken = True
            else:
                # إعادة قراءة المهام من الذاكرة الحية لحساب عدد الطلائع النشطة بدقة (0-Network)
                fresh_hall_data = await self.get_command_hall_tasks(force_sync=False)
                live_pioneers = [
                    t for t in (fresh_hall_data.get("executable_tasks", []) + fresh_hall_data.get("claimable_tasks", []))
                    if self._safe_int(t.get("type")) == TASK_TYPE_REBEL_PIONEER
                    and self._safe_int(t.get("statue")) in (1, 2, 3)
                ]
                hall_info = self._get_command_hall_ctrl()
                ag_task = hall_info.get("armyGroupTaskData") if isinstance(hall_info, dict) else None

                if isinstance(ag_task, dict) and ag_task.get("index"):
                    r_hp = self._safe_int(ag_task.get("rabelHp"), 1000)
                    h_hp = self._safe_int(ag_task.get("hurtHp"), 0)
                    st = self._safe_int(ag_task.get("statue"), 2)
                    p_count = len(live_pioneers)
                    if isinstance(hall_info, dict) and p_count == 0 and self._safe_int(hall_info.get("armyPioneerTaskCount"), 0) > 0:
                        hall_info["armyPioneerTaskCount"] = 0

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
                hall_info_end = self._get_command_hall_ctrl()
                if isinstance(hall_info_end, dict):
                    end_lv = self._safe_int(hall_info_end.get("commandLv"), 1)
                    end_exp = self._safe_int(hall_info_end.get("commandExp"), 0)
                    end_need = self.get_command_hall_need_exp(end_lv)
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
        total_completed = (
            completed_claimed_count
            + completed_snipe_count
            + completed_rescue_count
            + completed_dialogue_count
            + completed_battle_count
            + completed_army_group_count
        )
        total_failed = failed_snipe_count + failed_rescue_count + failed_dialogue_count + failed_battle_count + failed_army_group_count

        if total_completed > 0 or total_hall_upgrades > 0:
            details = []
            if total_hall_upgrades > 0:
                details.append(f"{total_hall_upgrades} ترقية لمستوى القاعة (وصلت Lv.{summary.get('command_lv')})")
            if completed_claimed_count > 0:
                details.append(f"{completed_claimed_count} استلام مهام مكتملة مسبقاً")
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

        if not has_snipe_eligible and not has_rescue_eligible and not has_dialogue_eligible and not eligible_battle_tasks and completed_army_group_count == 0 and total_hall_upgrades == 0:
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
