# -*- coding: utf-8 -*-
"""
tasks/daily_quest.py — مهمة استلام صناديق النشاط اليومي الجاهزة (DailyQuestTask)
══════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. تعمل كآخر مهمة في دورة البوت بعد إنجاز كافة الأنشطة اليومية الأخرى.
  2. فحص مسبق كامل من الذاكرة الحية (0-Network Pre-flight):
     - احتساب مجموع نقاط النشاط الحالية من everydayTaskCtrl.eventInfo.
     - استخراج الصناديق الجاهزة ومقارنتها بسجل الصناديق المستلمة everydayTaskCtrl.normalRecord.
     - إذا لم يكن هناك أي صندوق جاهز، تتوقف فوراً دون إرسال أي طلب شبكي.
  3. استعلام احتياطي آمن (Safe Fallback Query):
     - في حال غياب المتحكم من الذاكرة الحية أو انتهاء صلاحية اليوم (tomorrowZeroUTC)،
       يتم إرسال CMD 2027 / SUBCMD 1 لإعادة مزامنة الذاكرة ثم استلام الصناديق.
  4. استلام الصناديق عبر CMD 2027 / SUBCMD 2 حصراً (الأمر الرسمي المجاني) مع فواصل بشرية.
  5. مزامنة فورية للذاكرة الحية محلياً لمنع أي استعلامات لاحقة.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# كود وحدة الأوامر الرسمية للمهام اليومية
CMD_EVERYDAY_TASK_MODULE = "2027"
REQ_EVERYDAY_TASK_INIT = "1"            # استعلام المزامنة الشامل الاحتياطي
REQ_EVERYDAY_TASK_RECEIVE_NORMAL = "2"   # استلام الصناديق اليومية الثمانية المجانية

# جدول الصناديق الثمانية وعتبات النقاط المطلوبة لكل صندوق (من daily_reward_point_items.lua)
CHEST_MILESTONES: List[Tuple[int, int]] = [
    (1, 30),
    (2, 70),
    (3, 120),
    (4, 180),
    (5, 260),
    (6, 340),
    (7, 420),
    (8, 500),
]

# جدول إعدادات نقاط المهام الـ 33 الرسمية: {task_type: (points_per_action, max_limit_time)}
# مستخرج ومطابق تماماً لـ daily_reward_point_config.lua
DAILY_QUEST_POINT_RULES: Dict[int, Tuple[int, int]] = {
    1: (3, 5),      # جمع قمح (4100001)
    2: (3, 5),      # جمع خشب (4100002)
    3: (3, 5),      # جمع حديد (4100003)
    4: (3, 5),      # جمع فضة (4100004)
    5: (3, 5),      # قتل وحوش (4100005)
    6: (30, 1),     # تطوير مبنى (4100006)
    7: (30, 1),     # بحث معهد (4100007)
    8: (2, 10),     # إهداء زهور (4100008)
    9: (20, 1),     # تصنيع عتاد (4100009)
    10: (10, 1),    # تجميع مواد (4100010)
    11: (3, 5),     # علاج مصابين (4100011)
    12: (5, 5),     # تدريب مشاة (4100012)
    13: (5, 5),     # تدريب رماة (4100013)
    14: (5, 5),     # تدريب فرسان (4100014)
    15: (5, 5),     # تدريب عربات (4100015)
    16: (3, 5),     # تصنيع فخاخ (4100016)
    17: (10, 1),    # قلب بطاقة دعم الموارد (4100017)
    18: (1, 40),    # مساعدة أعضاء التحالف (4100018)
    19: (10, 1),    # دعم التحالف بالقوات (4100019)
    20: (10, 1),    # دعم التحالف بالموارد (4100020)
    21: (1, 20),    # تبرع لعلوم التحالف (4100021)
    22: (2, 10),    # استلام بضائع الميناء (4100022)
    23: (1, 20),    # استكشاف نافورة الكنوز (4100023)
    24: (2, 10),    # الشراء من التاجر العجيب (4100024)
    25: (20, 1),    # كفاءة الجندي (4100025)
    26: (15, 1),    # استكشاف الهرم (4100026)
    27: (20, 1),    # متجر وسام الحرب (4100027)
    28: (20, 1),    # إطعام الحيوان (4100028)
    29: (10, 5),    # استهلاك الذهب (4100029)
    30: (5, 3),     # تحدي الحلبة (4100030)
    31: (5, 5),     # الحرب الملحمية (4100031)
    32: (30, 1),    # تقوية المباني (4100032)
    33: (10, 1),    # قاعة الأوامر (4100033)
}


class DailyQuestTask(BaseTask):
    """
    مهمة فحص واستلام صناديق النشاط اليومي الجاهزة (صناديق الـ 500 نقطة).
    """
    name = "daily_quest"
    alias = "daily_activity"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    @property
    def is_active(self) -> bool:
        """المهمة مفعلة افتراضياً كنشاط تلقائي ما لم يعطلها المستخدم صراحة."""
        return bool(self.config.get("enabled", True))

    @staticmethod
    def calculate_cur_points(event_info: Dict[str | int, Any]) -> int:
        """
        احتساب مجموع نقاط النشاط اليومي الحالية من سجل eventInfo.
        يطابق دالة everydayTaskCtrl:calCurPoint() الرسمية.
        """
        if not isinstance(event_info, dict):
            return 0

        total = 0
        for raw_k, raw_count in event_info.items():
            try:
                k_int = int(raw_k)
                # مطابقة النوع سواء أكان رقماً مجرداً (1..33) أو ID كامل (4100001..4100033)
                task_type = k_int % 4100000 if k_int > 4100000 else k_int
                rule = DAILY_QUEST_POINT_RULES.get(task_type)
                if rule:
                    point, limit_time = rule
                    count = int(raw_count or 0)
                    total += point * min(count, limit_time)
            except (ValueError, TypeError):
                continue
        return total

    @staticmethod
    def get_unclaimed_ready_chests(cur_points: int, normal_record: Dict[str | int, Any]) -> List[int]:
        """
        استخراج قائمة فهارس الصناديق الجاهزة للاستلام التي لم تُستلم اليوم بعد.
        """
        claimed_keys = {str(k) for k in normal_record.keys()} if isinstance(normal_record, dict) else set()
        ready = []
        for index, threshold in CHEST_MILESTONES:
            if cur_points >= threshold and str(index) not in claimed_keys:
                ready.append(index)
        return ready

    async def _ensure_synced_memory(self) -> Tuple[Optional[Dict[str, Any]], bool]:
        """
        التحقق من جاهزية متحكم everydayTaskCtrl في الذاكرة الحية.
        إذا كان مفقوداً أو منتهي الصلاحية، يتم إرسال الاستعلام الاحتياطي الآمن (CMD 2027 / SUBCMD 1).
        يعيد: (everyday_ctrl, was_queried_over_network)
        """
        ctrl = self.get_ctrl("everydayTaskCtrl")
        now_ts = int(time.time())

        # فحص هل البيانات الحالية صالحة ومحدثة
        if isinstance(ctrl, dict) and isinstance(ctrl.get("eventInfo"), dict) and isinstance(ctrl.get("normalRecord"), dict):
            tomorrow_zero = int(ctrl.get("tomorrowZeroUTC", 0) or 0)
            # إذا لم ينتهِ اليوم بعد، نعتمد على الذاكرة الحية فوراً (0-Network)
            if tomorrow_zero == 0 or now_ts < tomorrow_zero:
                return ctrl, False

        # تنفيذ الاستعلام الاحتياطي الآمن عند نقص البيانات أو تجدد اليوم
        self.log("📡 [صناديق النشاط] استعلام احتياطي لتحديث بيانات المهام اليومية من السيرفر (CMD 2027/1)...")
        resp = await self.safe_query(CMD_EVERYDAY_TASK_MODULE, REQ_EVERYDAY_TASK_INIT, {})
        if resp and isinstance(resp.get("data"), dict):
            if hasattr(self.conn, "init_data") and isinstance(self.conn.init_data, dict):
                ctrl = self.conn.init_data.setdefault("everydayTaskCtrl", {})
                ctrl.update(resp["data"])
                return ctrl, True
            return resp["data"], True

        # في حال فشل الاستعلام الاحتياطي عند نقص البيانات أو انتهاء صلاحيتها:
        # يُمنع منعاً باتاً اعتماد بيانات قديمة منتهية الصلاحية لتفادي إرسال طلبات غير مستحقة
        self.log("⚠️ [صناديق النشاط] تعذر تحديث بيانات المهام اليومية عبر الاستعلام الاحتياطي.")
        return None, True

    async def run(self) -> TaskResult:
        """تنفيذ دورة فحص واستلام الصناديق الجاهزة كآخر مهمة في الدورة."""
        # 1. جلب/مزامنة بيانات متحكم النشاط اليومي
        everyday_ctrl, queried = await self._ensure_synced_memory()
        if not isinstance(everyday_ctrl, dict):
            return TaskResult.skip("تعذر الحصول على بيانات everydayTaskCtrl من الذاكرة أو السيرفر.")

        event_info = everyday_ctrl.get("eventInfo") if isinstance(everyday_ctrl.get("eventInfo"), dict) else {}
        normal_record = everyday_ctrl.get("normalRecord") if isinstance(everyday_ctrl.get("normalRecord"), dict) else {}

        # 2. احتساب النقاط الحالية
        cur_points = self.calculate_cur_points(event_info)

        # 3. فحص الصناديق الجاهزة
        ready_chests = self.get_unclaimed_ready_chests(cur_points, normal_record)

        # فحص 0-Network: إذا لم يكن هناك أي صندوق جاهز ولم نرسل استعلاماً، ننهي فوراً دون شبكة
        if not ready_chests:
            network_status = "عبر الاستعلام الاحتياطي" if queried else "من الذاكرة الحية 0-Network"
            return TaskResult.ok(f"لا توجد صناديق جديدة جاهزة للاستلام ({network_status}) — النقاط الحالية: {cur_points}/500.")

        self.log(f"🎁 [صناديق النشاط] تم رصد {len(ready_chests)} صندوق جاهز للاستلام (النقاط: {cur_points}/500 | الصناديق: {ready_chests}).")

        # 4. فتح الصناديق الجاهزة تتابعياً مع فواصل بشرية آمنة
        claimed_count = 0
        claimed_indices = []

        for index in ready_chests:
            threshold = dict(CHEST_MILESTONES).get(index, 0)
            self.log(f"📦 [صناديق النشاط] جاري استلام الصندوق {index} ({threshold} نقطة)...")

            # إرسال حزمة الاستلام الرسمية (CMD 2027 / SUBCMD 2)
            res = await self.safe_query(
                CMD_EVERYDAY_TASK_MODULE,
                REQ_EVERYDAY_TASK_RECEIVE_NORMAL,
                {"index": index},
                min_delay=0.6,
                max_delay=1.2,
            )

            # فحص الاستجابة وتحديث الذاكرة الحية بطريقة محصنة نوعياً
            is_dict_res = isinstance(res, dict)
            err_raw = res.get("err") if is_dict_res else None
            if err_raw is None and is_dict_res and "code" in res:
                err_raw = res.get("code")

            err_str = str(err_raw).strip() if err_raw is not None else "-1"

            if is_dict_res and err_str in ("0", "Err_None"):
                claimed_count += 1
                claimed_indices.append(index)
                
                # مزامنة normalRecord المرتجع من خادم اللعبة الرسمي إن وُجد
                srv_normal_rec = res.get("data", {}).get("normalRecord") if isinstance(res.get("data"), dict) else None
                if isinstance(srv_normal_rec, dict):
                    normal_record.update(srv_normal_rec)
                else:
                    normal_record[str(index)] = 1

                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"✅ [صناديق النشاط] تم استلام مكافأة الصندوق {index} بنجاح!")

            elif is_dict_res and err_str == "470003":
                # الصندوق مستلم مسبقاً اليوم على السيرفر (Err_EVERYDAY_TASK_ALREADY_RECEIVE)
                claimed_count += 1
                normal_record[str(index)] = 1
                everyday_ctrl["normalRecord"] = normal_record
                self.log(f"ℹ️ [صناديق النشاط] الصندوق {index} مستلم مسبقاً اليوم على السيرفر — تم تحديث الذاكرة الحية.")

            else:
                err_code = err_str if is_dict_res else "NoResponse"
                self.log(f"⚠️ [صناديق النشاط] تعذر استلام الصندوق {index} (رمز الخطأ: {err_code}).")

        if claimed_count > 0:
            return TaskResult.ok(
                f"تم استلام {claimed_count} صندوق نشاط يومي بنجاح (الصناديق: {claimed_indices}) — الرصيد: {cur_points} نقطة.",
                data={"claimed_chests": claimed_indices, "total_points": cur_points}
            )

        return TaskResult.fail(f"فشل استلام الصناديق الجاهزة {ready_chests}.")
