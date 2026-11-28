# -*- coding: utf-8 -*-
"""
tasks/port.py — مهمة استلام مكافآت سفن الميناء (Port / Harbor Task)
════════════════════════════════════════════════════════════════════
تتحقق من وصول سفن الميناء واستلام مكافآتها اليومية بصفر طلبات شبكية
عند عدم وصول السفينة أو استلام كل السفن مسبقاً.
"""

from __future__ import annotations

from typing import Tuple
from tasks.base_task import BaseTask, TaskResult


class PortTask(BaseTask):
    """مهمة فحص واستلام جوائز سفن الميناء."""
    name = "port"

    async def can_run(self) -> Tuple[bool, str]:
        # مهمة الميناء خلفية إلزامية مطلقة (لا تفحص config['enabled'] وتُنفّذ دائماً طالما الاتصال والذاكرة جاهزان)
        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "قاطع الاتصال: لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        # 1. فحص توفر ميزة الميناء في الذاكرة الحية (0 طلب شبكي)
        time_reward = self.get_ctrl("timeRewardCtrl")
        if not time_reward:
            return False, "بيانات الميناء غير متوفرة في init_data"

        # 2. فحص هل تم استلام جميع سفن اليوم بالكامل (0 طلب شبكي)
        tr_data = time_reward.get("data", {}) if isinstance(time_reward.get("data"), dict) else time_reward
        if int(tr_data.get("isAllReceive", 0) or 0) == 1:
            return False, "تم استلام كافة سفن الميناء اليومية"

        # 3. فحص حالة الجاهزية الفعلية (isReceive == 2 تعني وصلت وجاهزة للاستلام فوراً)
        is_receive = int(tr_data.get("isReceive", 0) or 0)
        if is_receive == 2:
            return True, ""

        rem_sec = int(time_reward.get("time", 0) or 0)
        if rem_sec > 0:
            return False, f"سفينة الميناء لم تصل بعد (المتبقي: {rem_sec} ثانية)"
        if "isReceive" in tr_data and is_receive != 2:
            return False, "سفينة الميناء قيد الإبحار ولم تصل بعد"

        return True, ""

    async def run(self) -> TaskResult:
        self.log("🚢 سفينة الميناء وصلت! جاري استلام المكافأة...")
        
        # إرسال طلب استلام جائزة سفينة الميناء
        r = await self.safe_query("1033", "2", {})
        if not r or str(r.get("err", "-1")) != "0":
            err_msg = r.get("msg", "لا يوجد رد") if r else "لا يوجد رد من الخادم"
            return TaskResult.fail(f"تعذر استلام جائزة الميناء: {err_msg}")

        # تحديث بيانات الميناء في الذاكرة الحية فوراً بالعداد والبيانات الجديدة
        new_data = r.get("data")
        if isinstance(new_data, dict):
            if "data" in new_data or "time" in new_data:
                self.init_data["timeRewardCtrl"] = new_data
            else:
                tr_ctrl = self.init_data.setdefault("timeRewardCtrl", {})
                if isinstance(tr_ctrl, dict):
                    tr_ctrl["data"] = new_data

        msg = "تم استلام جائزة سفينة الميناء بنجاح"
        self.log(f"🎉 {msg}")
        return TaskResult.ok(msg, data=new_data)
