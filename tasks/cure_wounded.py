# -*- coding: utf-8 -*-
"""
tasks/cure_wounded.py — مهمة علاج المصابين بالخيمة الطبية (النشاط اليومي)
═══════════════════════════════════════════════════════════════════════════════
البروتوكول الشبكي للعبة:
  - CMD: "1005" (CMD_ARMY_MODULE)
  - SubCMD: "4" (REQ_CURE_WOUNDED_ARMY)
  - Payload: {"armyinfo": {"<army_id>": "<count>"}, "mode": "0"}

الميزات وصمامات الأمان:
  1. صفر استهلاك للذهب (0-Gold Guarantee):
     استخدام وضع الموارد العادية فقط (mode: "0" = OPERATE_MODE.NORMAL).
  2. فحص النشاط اليومي المسبق في الذاكرة (0-Network Pre-flight):
     التحقق من كائن everydayTaskCtrl.eventInfo لمهمة علاج المصابين (ID: 4100011 / Type: 11)؛
     فإذا كانت متممة بالكامل (5/5 = 500 جندي)، يتم التخطي فوراً بأقل من 0.01ms دون لمس السيرفر
     (حتى لو كان خيار علاج جميع المصابين مفعلاً، التزاماً بتوجيه المطور الصارم).
  3. حساب دقيق للجنود المتبقين لإتمام المهمة:
     في نمط النشاط اليومي ("daily")، يقوم البوت بحساب عدد الجنود المتبقي بالضبط للوصول إلى 500 جندي
     (المتبقي = (5 - المنجز) * 100) وعلاجهم دفعة واحدة لتوفير الموارد ووقت الخيمة.
  4. فحص طابور المشفى المسبق (Queue Busy Check):
     التحقق من عدم وجود طابور علاج نشط حالياً (QueueType: 1202).
  5. تحديث الذاكرة الحية فورياً فور نجاح الطلب (In-Memory State Sync).
"""

from __future__ import annotations

import time
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# ثوابت نظام الجيش والمشفى والنشاط اليومي في لعبة انتقام السلاطين
CMD_ARMY_MODULE = "1005"
REQ_CURE_WOUNDED_ARMY = "4"

# معرّفات مهمة علاج المصابين في جدول النشاط اليومي الرسمي (daily_reward_point_config.lua)
DAILY_QUEST_CURE_ID = "4100011"
DAILY_QUEST_CURE_TYPE = "11"
DAILY_QUEST_TOTAL_SOLDIERS = 500
DAILY_QUEST_STEP_SOLDIERS = 100
DAILY_QUEST_LIMIT_TIME = 5

# طابور المشفى في جدول اللعبة الرسمي (queueTypeDef.lua)
HOSPITAL_QUEUE_TYPE = 1202

# نمط التشغيل بدون ذهب (wholeDefine.lua: OPERATE_MODE.NORMAL = 0)
OPERATE_MODE_NORMAL = "0"


def _safe_int(val: Any, default: int = 0) -> int:
    """
    تحويل آمن لأي قيمة إلى عدد صحيح (يتعامل مع النصوص العشرية '1482.42', الأعداد العشرية، والقيم الفارغة).
    """
    try:
        if val is None:
            return default
        return int(float(val))
    except (ValueError, TypeError):
        return default


class CureWoundedTask(BaseTask):
    """
    مهمة علاج المصابين بالخيمة الطبية لإتمام النشاط اليومي (500 جندي) وحفظ الموارد.
    """
    name: str = "cure_wounded"

    def _get_daily_progress(self) -> Tuple[int, int]:
        """
        قراءة تقدم مهمة النشاط اليومي بالذاكرة الحية (0-Network):
        ترجع: (عدد المرات المنجزة 0-5، عدد الجنود المتبقي لإتمام 500 جندي).
        """
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if not isinstance(everyday_ctrl, dict):
            return 0, DAILY_QUEST_TOTAL_SOLDIERS

        event_info = everyday_ctrl.get("eventInfo")
        if not isinstance(event_info, dict):
            return 0, DAILY_QUEST_TOTAL_SOLDIERS

        # فحص المعرف الكامل 4100011 أو النوع 11
        val = event_info.get(DAILY_QUEST_CURE_ID)
        if val is None:
            val = event_info.get(DAILY_QUEST_CURE_TYPE)
        if val is None:
            val = event_info.get(11)
        if val is None:
            val = event_info.get(4100011)

        completed_times = _safe_int(val, 0)
        completed_times = max(0, min(DAILY_QUEST_LIMIT_TIME, completed_times))
        remaining_soldiers = max(0, (DAILY_QUEST_LIMIT_TIME - completed_times) * DAILY_QUEST_STEP_SOLDIERS)
        return completed_times, remaining_soldiers

    def _check_single_queue_busy(self, q: Any) -> bool:
        """
        فحص ما إذا كان كائن الطابور نشطاً حالياً ومتبقياً فيه وقت (يدعم جميع صيغ بيانات اللعبة).
        """
        if not isinstance(q, dict):
            return False

        now = int(time.time())

        # 1. فحص وقت الانتهاء المباشر (finishTime / finishtime / endTime / endtime)
        finish = _safe_int(
            q.get("finishTime") or q.get("finishtime") or q.get("endTime") or q.get("endtime"), 0
        )
        if finish > now:
            return True

        # 2. فحص وقت البداية + المدة الإجمالية (startTime + totaltime)
        start = _safe_int(q.get("startTime") or q.get("starttime") or q.get("updated_at"), 0)
        total = _safe_int(q.get("totalTime") or q.get("totaltime") or q.get("ottime"), 0)
        if start > 0 and total > 0 and (start + total) > now:
            return True

        # 3. فحص الوقت المتبقي (lefttime / remainTime)
        left = _safe_int(q.get("leftTime") or q.get("lefttime") or q.get("remainTime"), 0)
        if left > 0:
            if start > 0:
                if (start + left) > now:
                    return True
            else:
                return True

        return False

    def _is_hospital_queue_busy(self) -> bool:
        """
        التحقق في الذاكرة الحية (0-Network) هل طابور علاج المصابين قيد العمل حالياً.
        يدعم جميع هياكل queueCtrl في اللعبة والبوت:
        - قائمة queues في queueCtrl['queues'] (الهيكل المعتمد في core/game_client.py)
        - مفتاح مباشر queueCtrl['1202']
        - قواميس متفرعة queueCtrl['queue'] أو queueCtrl['queueList']
        """
        queue_ctrl = self.get_ctrl("queueCtrl") or self.get_ctrl("queue")
        if not isinstance(queue_ctrl, dict):
            return False

        # 1. فحص المفتاح المباشر 1202 في queue_ctrl
        for key in (str(HOSPITAL_QUEUE_TYPE), HOSPITAL_QUEUE_TYPE):
            if key in queue_ctrl and isinstance(queue_ctrl[key], dict):
                if self._check_single_queue_busy(queue_ctrl[key]):
                    return True

        # 2. فحص قائمة وقواميس الطوابير (تشمل 'queues' المعتمدة في اللعبة)
        queues = (
            queue_ctrl.get("queues")
            or queue_ctrl.get("queue")
            or queue_ctrl.get("queueList")
        )
        if isinstance(queues, list):
            for q in queues:
                if isinstance(q, dict):
                    q_type = _safe_int(q.get("qtype") or q.get("type") or q.get("queuetype"), 0)
                    if q_type == HOSPITAL_QUEUE_TYPE and self._check_single_queue_busy(q):
                        return True
        elif isinstance(queues, dict):
            for q_k, q in queues.items():
                if isinstance(q, dict):
                    q_type = _safe_int(q.get("qtype") or q.get("type") or q.get("queuetype"), 0)
                    if (str(q_k) == str(HOSPITAL_QUEUE_TYPE) or q_type == HOSPITAL_QUEUE_TYPE) and self._check_single_queue_busy(q):
                        return True

        # 3. فحص شامل لكافة قيم كائن queue_ctrl كضمان احترافي (Zero-Leak)
        for k, v in queue_ctrl.items():
            if str(k) == str(HOSPITAL_QUEUE_TYPE) and isinstance(v, dict):
                if self._check_single_queue_busy(v):
                    return True
            elif isinstance(v, dict):
                q_type = _safe_int(v.get("qtype") or v.get("type") or v.get("queuetype"), 0)
                if q_type == HOSPITAL_QUEUE_TYPE and self._check_single_queue_busy(v):
                    return True

        return False

    def _sync_hospital_queue_busy(self, total_time: int = 600) -> None:
        """
        تسجيل حالة انشغال طابور المشفى في الذاكرة الحية (In-Memory State Sync) لمنع أي طلب شبكي قادم.
        """
        queue_ctrl = self.get_ctrl("queueCtrl") or self.get_ctrl("queue")
        now = int(time.time())
        finish = now + total_time
        if isinstance(queue_ctrl, dict):
            # 1. تحديث قائمة queues (الهيكل المعتمد في core/game_client.py)
            queues = queue_ctrl.setdefault("queues", [])
            if isinstance(queues, list):
                queues[:] = [
                    q
                    for q in queues
                    if not (
                        isinstance(q, dict)
                        and _safe_int(q.get("qtype") or q.get("queuetype"), 0)
                        == HOSPITAL_QUEUE_TYPE
                    )
                ]
                queues.append({
                    "qtype": HOSPITAL_QUEUE_TYPE,
                    "queuetype": HOSPITAL_QUEUE_TYPE,
                    "updated_at": now,
                    "starttime": now,
                    "totaltime": total_time,
                    "lefttime": total_time,
                    "finishTime": finish,
                })
            # 2. تحديث المفتاح المباشر 1202
            queue_ctrl[str(HOSPITAL_QUEUE_TYPE)] = {
                "qtype": HOSPITAL_QUEUE_TYPE,
                "startTime": now,
                "totaltime": total_time,
                "finishTime": finish,
            }

    def _get_available_wounded(self) -> Dict[str, int]:
        """
        استخراج الجنود المصابين المتاحين في الخيمة الطبية من كائن armyCtrl.woundedArmy.
        """
        army_ctrl = self.get_ctrl("armyCtrl") or self.get_ctrl("army")
        if not isinstance(army_ctrl, dict):
            return {}

        wounded = army_ctrl.get("woundedArmy")
        if not isinstance(wounded, dict):
            return {}

        res: Dict[str, int] = {}
        for army_id, count_raw in wounded.items():
            cnt = _safe_int(count_raw, 0)
            if cnt > 0:
                res[str(army_id)] = cnt
        return res

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص شروط التشغيل المسبقة بالكامل في الذاكرة الحية (0-Network Pre-flight):
        - هل المهمة مفعلة بالواجهة وفق رغبة المستخدم؟
        - هل الاتصال نشط بالبوابة والذاكرة جاهزة؟
        - هل المهمة متممة مسبقاً في النشاط اليومي؟ (يتم التجاهل حتى لو كان علاج الكل مفعلاً)
        - هل طابور علاج المصابين بالمشفى قيد التشغيل؟
        - هل يوجد جنود مصابون في الخيمة الطبية؟
        """
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة وفق رغبة المستخدم"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        # 1. شرط التجاهل الصارم: إذا كانت المهمة منجزة في النشاط اليومي يتم التجاهل حتى لو كان علاج الكل مفعلاً
        completed_times, remaining_soldiers = self._get_daily_progress()
        if completed_times >= DAILY_QUEST_LIMIT_TIME or remaining_soldiers <= 0:
            return False, f"مهمة علاج المصابين اليومية متممة بالكامل مسبقاً ({completed_times}/{DAILY_QUEST_LIMIT_TIME})"

        # 2. فحص طابور المشفى بالذاكرة: هل يعمل طابور علاج حالياً؟
        if self._is_hospital_queue_busy():
            return False, "طابور علاج المصابين بالمشفى قيد التشغيل حالياً"

        # 3. فحص توفر جنود مصابين بالذاكرة
        wounded = self._get_available_wounded()
        total_wounded = sum(wounded.values())
        if total_wounded <= 0:
            return False, "لا يوجد جنود مصابون في الخيمة الطبية حالياً"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ عملية علاج المصابين دفعة واحدة وفق النمط المحدد بدون أي استهلاك للذهب.
        """
        completed_times, remaining_soldiers = self._get_daily_progress()

        # تحقق إضافي من إتمام المهمة اليومية (حماية استباقية)
        if completed_times >= DAILY_QUEST_LIMIT_TIME or remaining_soldiers <= 0:
            self.log(f"[CureWounded] المهمة منجزة مسبقاً في النشاط اليومي ({completed_times}/{DAILY_QUEST_LIMIT_TIME}) -> إنهاء")
            return TaskResult.skip("Daily quest already completed (0-Network)")

        # فحص الطابور
        if self._is_hospital_queue_busy():
            self.log("[CureWounded] طابور العلاج في المشفى قيد التشغيل -> تأجيل للدورة القادمة")
            return TaskResult.skip("Hospital queue is busy")

        # جلب المصابين
        wounded = self._get_available_wounded()
        total_available = sum(wounded.values())
        if total_available <= 0:
            self.log("[CureWounded] لا يوجد جنود مصابون في الخيمة الطبية")
            return TaskResult.skip("No wounded soldiers available")

        # تحديد النمط: "daily" (إتمام المهمة اليومية فقط) أو "all" (علاج جميع المصابين)
        mode = str(self.config.get("mode", "daily")).lower().strip()
        if mode not in ("daily", "all"):
            mode = "daily"

        # حساب الحصة المطلوبة للعلاج (Target Quota)
        if mode == "daily":
            target_count = min(remaining_soldiers, total_available)
        else:
            target_count = total_available

        if target_count <= 0:
            return TaskResult.skip("No soldiers needed to cure")

        # اختيار الجنود المصابين: فرز تصاعدي حسب معرّف الجندي لإعطاء الأولوية للجنود الأرخص تكلفة في الموارد
        sorted_army_ids = sorted(wounded.keys(), key=lambda x: int(x) if x.isdigit() else 999999)

        payload_army: Dict[str, str] = {}
        collected_count = 0

        for army_id in sorted_army_ids:
            avail = wounded[army_id]
            needed = target_count - collected_count
            if needed <= 0:
                break

            take = min(avail, needed)
            payload_army[str(army_id)] = str(take)
            collected_count += take

        if not payload_army or collected_count <= 0:
            return TaskResult.fail("Failed to construct wounded army payload")

        mode_label = f"النشاط اليومي ({collected_count} جندي متبقي)" if mode == "daily" else f"علاج الجميع ({collected_count} جندي)"
        self.log(f"[CureWounded] ⛺ بدء علاج {collected_count} جندي مصاب دفعة واحدة ({mode_label}) بدون ذهب...")

        # صياغة الحزمة الرسمية للعبة
        payload = {
            "armyinfo": payload_army,
            "mode": OPERATE_MODE_NORMAL,  # "0" = عادي بالموارد حصراً دون أي ذهب
        }

        # إرسال الطلب الشبكي الآمن
        res = await self.safe_query(
            CMD_ARMY_MODULE,
            REQ_CURE_WOUNDED_ARMY,
            payload,
        )

        if not res:
            self.log("[CureWounded] ⚠️ لم يتم استلام رد من السيرفر على طلب العلاج")
            return TaskResult.fail("No response from server for cure request")

        err = res.get("err")
        err_code = _safe_int(err, -1)

        if err_code != 0:
            # حالة 1: طابور المشفى مشغول حالياً على السيرفر (Err_ARMY_QUEUE_BUSY = 4002)
            if err_code == 4002:
                self.log(
                    "[CureWounded] ⏳ طابور علاج المصابين بالخيمة الطبية قيد التشغيل حالياً على السيرفر (كود 4002: Err_ARMY_QUEUE_BUSY). تأجيل للدورة القادمة."
                )
                self._sync_hospital_queue_busy(600)
                return TaskResult.skip("Hospital queue is busy (Err_ARMY_QUEUE_BUSY: 4002)")

            # حالة 2: نقص الموارد (Err_RESOUCH_NOT_REACH = 2) والعدد المطلوب علاجه أكبر من 500 جندي
            elif err_code == 2 and collected_count > 500:
                self.log(
                    f"[CureWounded] ⚠️ موارد القلعة غير كافية لعلاج {collected_count} جندي مصاب (كود 2: Err_RESOUCH_NOT_REACH)."
                )
                self.log(
                    "[CureWounded] 🔄 التراجع التلقائي الذكي: بدء محاولة علاج 500 جندي فقط بالموارد المتاحة..."
                )

                # بناء حزمة علاج 500 جندي فقط
                fallback_target = 500
                fallback_army: Dict[str, str] = {}
                fallback_collected = 0

                for army_id in sorted_army_ids:
                    avail = wounded[army_id]
                    needed = fallback_target - fallback_collected
                    if needed <= 0:
                        break
                    take = min(avail, needed)
                    fallback_army[str(army_id)] = str(take)
                    fallback_collected += take

                if fallback_army and fallback_collected > 0:
                    payload_fallback = {
                        "armyinfo": fallback_army,
                        "mode": OPERATE_MODE_NORMAL,
                    }
                    res_fallback = await self.safe_query(
                        CMD_ARMY_MODULE,
                        REQ_CURE_WOUNDED_ARMY,
                        payload_fallback,
                    )
                    fb_err = _safe_int(res_fallback.get("err") if res_fallback else -1, -1)
                    if fb_err == 0:
                        # نجح التراجع وعلاج الـ 500 جندي بنجاح
                        payload_army = fallback_army
                        collected_count = fallback_collected
                        res = res_fallback
                    elif fb_err == 4002:
                        self.log(
                            "[CureWounded] ⏳ طابور علاج المصابين بالخيمة الطبية قيد التشغيل حالياً على السيرفر (كود 4002: Err_ARMY_QUEUE_BUSY). تأجيل للدورة القادمة."
                        )
                        self._sync_hospital_queue_busy(600)
                        return TaskResult.skip("Hospital queue is busy (Err_ARMY_QUEUE_BUSY: 4002)")
                    else:
                        fb_desc = " (الموارد غير كافية حتى لـ 500 جندي)" if fb_err == 2 else ""
                        self.log(f"[CureWounded] ⚠️ فشل علاج الـ 500 جندي أيضاً (كود الخطأ: {fb_err}{fb_desc})")
                        return TaskResult.fail(f"Server rejected cure even for 500 soldiers (err: {fb_err})")
                else:
                    return TaskResult.fail("Failed to build 500 wounded army payload")
            else:
                err_desc = " (الموارد غير كافية Err_RESOUCH_NOT_REACH)" if err_code == 2 else ""
                self.log(f"[CureWounded] ⚠️ رفض السيرفر طلب العلاج (كود الخطأ: {err}{err_desc})")
                return TaskResult.fail(f"Server rejected cure request with err: {err}{err_desc}")

        # ══════════════════════════════════════════════════════════════════════
        # تحديث الذاكرة الحية محلياً (In-Memory State Sync)
        # ══════════════════════════════════════════════════════════════════════
        # 1. خصم الجنود المعالجين من armyCtrl.woundedArmy
        army_ctrl = self.get_ctrl("armyCtrl") or self.get_ctrl("army")
        if isinstance(army_ctrl, dict) and isinstance(army_ctrl.get("woundedArmy"), dict):
            for a_id, a_take in payload_army.items():
                cur = _safe_int(army_ctrl["woundedArmy"].get(a_id, 0), 0)
                rem = max(0, cur - _safe_int(a_take, 0))
                if rem > 0:
                    army_ctrl["woundedArmy"][a_id] = str(rem)
                else:
                    army_ctrl["woundedArmy"].pop(a_id, None)

        # 2. تحديث طابور المشفى queueCtrl (0-Network Skip أثناء العلاج)
        #    لا يُحقن everydayTaskCtrl.eventInfo محلياً قبل تأكيد السيرفر (NOTIFY 55)
        #    أو عندما يكون العدد < 100 لتفادي تضخيم النقاط وخطأ 470002.
        retdata = res.get("data", {}).get("retdata", {}) if isinstance(res.get("data"), dict) else {}
        total_time = _safe_int(retdata.get("totaltime"), 60)
        self._sync_hospital_queue_busy(total_time)

        steps_hint = collected_count // DAILY_QUEST_STEP_SOLDIERS
        self.log(f"[CureWounded] ✓ تم بدء علاج {collected_count} جندي مصاب بنجاح دفعة واحدة (الخطوات التقديرية: +{steps_hint}، المدة: {total_time}ث)")
        return TaskResult.ok(f"Successfully cured {collected_count} wounded soldiers in a single batch")

