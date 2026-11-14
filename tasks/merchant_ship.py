# -*- coding: utf-8 -*-
"""
tasks/merchant_ship.py — مهمة سحب بطاقة السفينة التجارية بالميناء (Merchant Ship Task)
═════════════════════════════════════════════════════════════════════════════════════
تفحص توفر سحب بطاقة الحظ والمضاعفة اليومية من الذاكرة الحية (0 طلبات شبكية)،
وتسحب بطاقة عشوائية من البطاقات غير المفتوحة عند توفرها.
"""

from __future__ import annotations

import random
from typing import Tuple
from tasks.base_task import BaseTask, TaskResult


class MerchantShipTask(BaseTask):
    """مهمة سحب بطاقة المضاعفة اليومية من السفينة التجارية."""
    name = "merchant_ship"
    alias = "daily_sign"

    async def can_run(self) -> Tuple[bool, str]:
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        # 1. قراءة بيانات السفينة التجارية من الذاكرة الحية (0 طلب شبكي)
        ctrl = self.get_ctrl("loginRewardCtrl") or self.get_ctrl("loginRewardData")
        if not ctrl:
            return False, "بيانات السفينة التجارية غير متوفرة في الذاكرة الحية"

        # 2. فحص هل بطاقة اليوم متاحة للسحب (0 طلب شبكي)
        if not ctrl.get("canReceive"):
            return False, "تم سحب بطاقة السفينة التجارية لليوم مسبقاً"

        return True, ""

    async def run(self) -> TaskResult:
        ctrl = self.get_ctrl("loginRewardCtrl") or self.get_ctrl("loginRewardData") or {}

        # اختيار بطاقة عشوائية من بين البطاقات غير المفتوحة بعد لمحاكاة السلوك البشري
        cards = ctrl.get("cardList", []) if isinstance(ctrl.get("cardList"), list) else []
        unopened = [c["location"] for c in cards if isinstance(c, dict) and not c.get("get") and "location" in c]
        chosen_loc = random.choice(unopened) if unopened else int(ctrl.get("curDay", 1) or 1)

        self.log(f"⛵ جاري سحب بطاقة السفينة التجارية (الموقع: {chosen_loc})...")

        # إرسال طلب السحب الرسمي (CMD 1032 / SUBCMD 2)
        r = await self.safe_query("1032", "2", {"location": chosen_loc})
        if not r or str(r.get("err", "-1")) != "0":
            err_msg = r.get("msg") or r.get("err") or "لا يوجد رد من الخادم"
            return TaskResult.fail(f"فشل سحب بطاقة السفينة التجارية: {err_msg}")

        # تحديث الذاكرة الحية فوراً لمنع أي محاولة سحب مكررة
        ctrl["canReceive"] = False
        rsp = (r.get("rspdata") or {}) if isinstance(r, dict) else {}
        if "loginRewardData" in rsp and isinstance(rsp["loginRewardData"], dict):
            self.init_data["loginRewardCtrl"] = rsp["loginRewardData"]

        mul = rsp.get("mul") or 1
        msg = f"تم سحب بطاقة السفينة التجارية بنجاح (المضاعف: x{mul})"
        self.log(f"🎉 {msg}")
        return TaskResult.ok(msg, data=rsp)

