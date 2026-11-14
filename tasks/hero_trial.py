# -*- coding: utf-8 -*-
"""
python tools/test_task_method.py --email beetoo3@hotmail.com --task hero_trial run
"""

from __future__ import annotations

import asyncio
import copy
import random
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية لكفاءة الجندي
CMD_HT_MODULE = "1059"

# رموز الأوامر الفرعية الرسمية (من cmdDef.lua)
REQ_HT_OPEN_TRIAL = "1"        # فتح رحلة الكفاءة بخريطة محددة
REQ_HT_QUIT_TRIAL = "2"        # الانسحاب من التحدي الحالي
REQ_HT_GENERAL_TRIAL = "3"     # هجوم على مرحلة محددة
REQ_HT_AUTO_TRIAL = "4"        # بدء الهجوم التلقائي (VIP5+)
REQ_HT_STOP_AUTO_TRIAL = "5"   # إيقاف الهجوم التلقائي
REQ_HT_LIKE = "6"              # الإعجاب بالمتصدرين
REQ_HT_MAP_INFO = "8"          # طلب معلومات الخريطة
REQ_HT_INIT_DATA = "10"        # مزامنة البيانات الأولية لكفاءة الجندي
REQ_HT_SWEEP = "11"            # الإكتساح السريع للخريطة المنجزة

# رقم مهمة النشاط اليومي لكفاءة الجندي في daily_reward_point_config.lua
DAILY_QUEST_HERO_TRIAL_TYPE = "25"
DAILY_QUEST_HERO_TRIAL_ID = 4100025
DAILY_QUEST_HERO_TRIAL_POINTS = 20

# أكواد أخطاء اللعبة الرسمية (من errDef.lua)
ERR_HT_REPEAT_TO_OPEN_TRIAL = "35001"
ERR_HT_MAP_NOT_UNLOCK = "35002"
ERR_HT_TRIAL_POINT_NOT_ENOUGH = "35003"
ERR_HT_HAVE_NOT_SOLDIERS = "35004"
ERR_HT_NOT_IN_TRIAL = "35005"
ERR_HT_IN_MARCH = "35009"
ERR_HT_SOLDIER_NOT_ENOUGH = "35010"
ERR_HT_MAP_NOT_COMPLETE = "35012"


class HeroTrialTask(BaseTask):
    """
    مهمة المشاركة في تحدي كفاءة الجندي (Hero Trial) بالحد الأدنى
    لإنجاز مهمة النشاط اليومي رقم 25 وكسب الـ 20 نقطة.
    """
    name = "hero_trial"
    alias = "soldier_trial"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة."""
        return bool(self.config.get("enabled", False))

    async def run(self) -> TaskResult:
        """
        تنفيذ مهمة كفاءة الجندي بالحد الأدنى المطلوب لإنجاز النشاط اليومي.
        """
        start_time = time.time()
        self.log(f"Starting task...")

        # ══════════════════════════════════════════════════════════════════════
        # 1. فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight)
        # ══════════════════════════════════════════════════════════════════════
        init_data = getattr(self.conn, "init_data", {}) or {}
        everyday_ctrl = init_data.get("everydayTaskCtrl", {})
        event_info = everyday_ctrl.get("eventInfo", {})

        # فحص هل تم إنجاز المهمة اليوم بالفعل (القيمة >= 1)
        quest_done_count = int(event_info.get(DAILY_QUEST_HERO_TRIAL_TYPE, 0))
        if quest_done_count >= 1:
            self.log(
                f"0-Network Pre-flight: Daily quest {DAILY_QUEST_HERO_TRIAL_TYPE} "
                f"(Soldier Trial) is already completed ({quest_done_count}/1). Skipping."
            )
            return TaskResult.skip("Daily quest 25 already completed", exec_time=time.time() - start_time)

        # ══════════════════════════════════════════════════════════════════════
        # 2. فحص بيانات كفاءة الجندي (htData) في الذاكرة الحية
        # ══════════════════════════════════════════════════════════════════════
        ht_data = init_data.get("htData")
        if not ht_data or not isinstance(ht_data, dict):
            # طلب مزامنة احتياطي رسمي عند غياب البيانات
            self.log("htData missing from live memory. Requesting init sync (CMD 1059 / REQ 10)...")
            try:
                resp = await self.safe_query(CMD_HT_MODULE, REQ_HT_INIT_DATA, {})
                if resp and str(resp.get("err", "-1")) == "0":
                    ht_data = resp.get("data", {})
                    init_data["htData"] = ht_data
                else:
                    err_code = resp.get("err") if resp else "timeout"
                    self.log(f"Failed to sync htData from server (err={err_code}).")
                    return TaskResult.fail(f"Sync htData failed: err={err_code}", exec_time=time.time() - start_time)
            except Exception as e:
                self.log(f"Exception during htData sync: {e}")
                return TaskResult.fail(f"Sync error: {e}", exec_time=time.time() - start_time)

        # استخراج تفاصيل النقاط والمعارك والخرائط
        point_data = ht_data.get("htPointData", {}) if isinstance(ht_data, dict) else {}
        ht_point = int(point_data.get("htPoint", 0))

        battle_data = ht_data.get("battleData", {}) if isinstance(ht_data, dict) else {}
        trial_status = bool(battle_data.get("trialStatus", False))

        map_info = ht_data.get("mapInfo", {}) if isinstance(ht_data, dict) else {}
        last_sid = int(map_info.get("lastSID", 40101))
        last_comp_sid = int(map_info.get("lastCOMPSID", 0))

        self.log(
            f"State in memory: htPoint={ht_point}, trialStatus={trial_status}, "
            f"lastSID={last_sid}, lastCOMPSID={last_comp_sid}"
        )

        # إذا كانت نقاط الكفاءة صفر ولا يوجد تحدٍ جارٍ، لا يمكن المشاركة اليوم
        if ht_point < 1 and not trial_status:
            self.log(f"No trial points available (htPoint={ht_point}). Cannot participate today.")
            return TaskResult.skip("No trial points available", exec_time=time.time() - start_time)

        # تحديد رقم الخريطة المستهدفة
        if trial_status:
            target_map_id = int(battle_data.get("trialMID", last_sid // 100))
        else:
            target_map_id = last_sid // 100 if last_sid > 0 else 401

        # ══════════════════════════════════════════════════════════════════════
        # 3. محاولة الإكتساح السريع (Fast Sweep) إن كان مدعوماً
        # ══════════════════════════════════════════════════════════════════════
        # الخريطة تعتبر مكتملة إذا كان آخر مرحلة منجزة هي المرحلة 10 من تلك الخريطة
        is_map_passed = (last_comp_sid >= (target_map_id * 100 + 10))
        
        # فحص امتياز الإكتساح السريع
        has_sweep_privilege = False
        exalted = init_data.get("exaltedPrivilegeCtrl", {})
        if isinstance(exalted, dict):
            privileges = exalted.get("privileges", {})
            if isinstance(privileges, dict):
                has_sweep_privilege = bool(privileges.get("56") or privileges.get("heroTrialSweep"))

        if is_map_passed and has_sweep_privilege and ht_point >= 1:
            self.log(f"Attempting fast sweep for map {target_map_id}...")
            try:
                sweep_resp = await self.safe_query(CMD_HT_MODULE, REQ_HT_SWEEP, {"mapID": target_map_id})
                if sweep_resp and str(sweep_resp.get("err", "-1")) == "0":
                    self.log(f"Fast sweep succeeded on map {target_map_id}!")
                    self._sync_task_completion_in_memory(point_data, ht_point - 1)
                    return TaskResult.ok(f"Completed via Sweep on map {target_map_id}", exec_time=time.time() - start_time)
                else:
                    err = sweep_resp.get("err") if sweep_resp else "no_response"
                    self.log(f"Sweep not available or rejected (err={err}). Falling back to regular challenge.")
            except Exception as e:
                self.log(f"Sweep attempt exception: {e}. Falling back to regular challenge.")

        # ══════════════════════════════════════════════════════════════════════
        # 4. النمط العادي: فتح التحدي (Open Trial) + شن هجمة واحدة بالحد الأدنى
        # ══════════════════════════════════════════════════════════════════════
        # الخطوة أ: فتح التحدي إذا لم يكن مفتوحاً
        if not trial_status:
            self.log(f"Opening trial for map {target_map_id} (CMD 1059 / REQ 1)...")
            try:
                open_resp = await self.safe_query(CMD_HT_MODULE, REQ_HT_OPEN_TRIAL, {"mapID": target_map_id})
                err = str(open_resp.get("err", "-1")) if open_resp else "-1"

                if err == "0":
                    self.log(f"Successfully opened trial on map {target_map_id}.")
                    trial_status = True
                    ht_point = max(0, ht_point - 1)
                    point_data["htPoint"] = ht_point
                    battle_data["trialStatus"] = True
                    battle_data["trialMID"] = target_map_id
                    rsp_data = open_resp.get("data", {})
                    if isinstance(rsp_data, dict) and "soldiers" in rsp_data:
                        battle_data["soldiers"] = rsp_data["soldiers"]
                elif err == ERR_HT_REPEAT_TO_OPEN_TRIAL:
                    self.log("Trial was already open on server.")
                    trial_status = True
                    battle_data["trialStatus"] = True
                elif err == ERR_HT_TRIAL_POINT_NOT_ENOUGH:
                    self.log("Server reported trial points not enough.")
                    return TaskResult.skip("Trial points not enough on server", exec_time=time.time() - start_time)
                else:
                    self.log(f"Failed to open trial (err={err}).")
                    return TaskResult.fail(f"Open trial failed: err={err}", exec_time=time.time() - start_time)

                await asyncio.sleep(random.uniform(1.5, 2.8))
            except Exception as e:
                self.log(f"Exception while opening trial: {e}")
                return TaskResult.fail(f"Open trial exception: {e}", exec_time=time.time() - start_time)

        # الخطوة ب: شن هجمة على أول مرحلة متاحة بالحد الأدنى من الجنود
        current_stage = int(battle_data.get("trialSID", 0)) or (target_map_id * 100 + 1)
        self.log(f"Attacking stage {current_stage} to fulfill daily quest participation...")

        dispatch_soldiers = self._get_minimal_soldiers(battle_data, init_data)

        try:
            attack_resp = await self.safe_query(
                CMD_HT_MODULE,
                REQ_HT_GENERAL_TRIAL,
                {"stageID": current_stage, "soldiers": dispatch_soldiers},
            )
            err = str(attack_resp.get("err", "-1")) if attack_resp else "-1"

            if err in ("0", ERR_HT_IN_MARCH):
                self.log(
                    f"Stage {current_stage} attack launched successfully (err={err}). "
                    f"Daily quest {DAILY_QUEST_HERO_TRIAL_TYPE} achieved (+{DAILY_QUEST_HERO_TRIAL_POINTS} points)!"
                )
                self._sync_task_completion_in_memory(point_data, ht_point)
                return TaskResult.ok(
                    f"Attacked stage {current_stage} with minimal troop; daily quest completed",
                    exec_time=time.time() - start_time,
                )
            elif err == ERR_HT_HAVE_NOT_SOLDIERS or err == ERR_HT_SOLDIER_NOT_ENOUGH:
                self.log(f"Not enough soldiers for trial battle (err={err}).")
                self._sync_task_completion_in_memory(point_data, ht_point)
                return TaskResult.ok("Opened trial (insufficient troops for attack)", exec_time=time.time() - start_time)
            else:
                self.log(f"Attack stage returned err={err}.")
                self._sync_task_completion_in_memory(point_data, ht_point)
                return TaskResult.ok(f"Trial processed (attack returned {err})", exec_time=time.time() - start_time)

        except Exception as e:
            self.log(f"Exception during stage attack: {e}")
            self._sync_task_completion_in_memory(point_data, ht_point)
            return TaskResult.ok("Trial opened, attack encountered exception", exec_time=time.time() - start_time)

    def _get_minimal_soldiers(self, battle_data: Dict[str, Any], init_data: Dict[str, Any]) -> List[Dict[str, int]]:
        """
        تحديد جندي واحد فقط من أول رتبة متاحة لتجنب أي خسائر أو استنزاف للقوات.
        يتم إرسالها كقائمة كائنات [{"id": int, "num": int}] طبقاً لبروتوكول اللعبة الرسمي.
        """
        # أولاً: فحص جنود الكفاءة المخصصين داخل battleData
        trial_soldiers = battle_data.get("soldiers")
        if isinstance(trial_soldiers, dict) and trial_soldiers:
            for s_id, count in trial_soldiers.items():
                if int(count) > 0:
                    return [{"id": int(s_id), "num": 1}]
        elif isinstance(trial_soldiers, list) and trial_soldiers:
            for s in trial_soldiers:
                if isinstance(s, dict) and int(s.get("num", 0)) > 0:
                    return [{"id": int(s.get("id", 401)), "num": 1}]

        # ثانياً: فحص جنود القلعة العاديين
        army_ctrl = init_data.get("armyCtrl", {})
        if isinstance(army_ctrl, dict):
            armys = army_ctrl.get("armys", {})
            if isinstance(armys, dict):
                for s_id, count in armys.items():
                    if int(count) > 0:
                        return [{"id": int(s_id), "num": 1}]

        # افتراضي آمن: جندي مشاة رتبة 1 (ID: 401)
        return [{"id": 401, "num": 1}]

    def _sync_task_completion_in_memory(self, point_data: Dict[str, Any], remaining_points: int) -> None:
        """
        تحديث الذاكرة الحية (conn.init_data) محلياً فور النجاح لمنع أي استعلامات شبكية لاحقة.
        """
        try:
            init_data = getattr(self.conn, "init_data", {}) or {}
            everyday_ctrl = init_data.setdefault("everydayTaskCtrl", {})
            event_info = everyday_ctrl.setdefault("eventInfo", {})
            event_info[DAILY_QUEST_HERO_TRIAL_TYPE] = 1

            if isinstance(point_data, dict):
                point_data["htPoint"] = max(0, remaining_points)

            self.log(
                f"In-Memory State Sync: everydayTaskCtrl.eventInfo['{DAILY_QUEST_HERO_TRIAL_TYPE}'] = 1, "
                f"htPoint = {max(0, remaining_points)}"
            )
        except Exception as e:
            self.log(f"Could not sync in-memory state: {e}")

    execute = run
