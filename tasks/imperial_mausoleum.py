# -*- coding: utf-8 -*-
"""
tasks/imperial_mausoleum.py — مهمة إستكشاف الهرم / الضريح الإمبراطوري (Pyramid Exploration Task)
══════════════════════════════════════════════════════════════════════════════════════════════════
تنجز مهمة النشاط اليومي رقم 26 (المشاركة في إستكشاف الهرم مرة واحدة = 25 نقطة نشاط).

الميزات والضوابط الأساسية:
  1. الفحص المسبق بالذاكرة الحية بصفر طلبات شبكية (0-Network Pre-flight):
     - التحقق أولاً من إنجاز مهمة النشاط اليومي: everydayTaskCtrl.eventInfo['26'] >= 1.
       إذا كانت مكتملة، يتم التخطي الفوري دون أي استعلام شبكي.
     - التحقق من كائن الهرم: pyramidCtrl.data (free == 1 أو وجود مكافأة معلقة).
       إذا كان free == 0 ولا توجد جائزة معلقة، يتم التوقف الفوري لحماية الذهب.
  2. رمي النرد المجاني حصراً عبر CMD 1045 / SubCMD 3.
  3. إدارة النرد الإضافي (Bonus Dice):
     إذا سقطت الرمية على عناصر touZiArray في كود اللعبة (800101, 803201, 803501, 803301, 803401)،
     تواصل المهمة الرمي مجاناً حتى استقرار النتيجة على مكافأة فعلية.
  4. استلام المكافأة النهائية فوراً بطلب CMD 1045 / SubCMD 5 مع {"receiveType": 0}.
  5. الحظر الصارم لاستهلاك الذهب والنحاس:
     منع كامل وتام للأمر SubCMD 6 (إعادة الرمي بالذهب) والأمر SubCMD 2 (تحديث العناصر بالنحاس).
  6. التحديث الذاتي للذاكرة الحية محلياً:
     تحديث pyramidCtrl.data و everydayTaskCtrl.eventInfo['26'] = 1 لمنع أي استعلام مكرر.
"""

from __future__ import annotations

import asyncio
import random
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult


class ImperialMausoleumTask(BaseTask):
    """
    مهمة إستكشاف الهرم المجانية التلقائية والإلزامية للنشاط اليومي.
    """
    name = "imperial_mausoleum"
    alias = "pyramid"

    CMD_PYRAMID = "1045"
    SUBCMD_INIT = "1"
    SUBCMD_THROW = "3"
    SUBCMD_CLAIM = "5"

    # عناصر النرد الإضافي المجاني من touZiArray في كود اللعبة (pyramidCtrl.lua:6-11)
    DICE_ITEM_IDS = {800101, 803201, 803501, 803301, 803401}

    MAX_DICE_REROLLS = 5  # أقصى عدد رميات متتالية للنرد الإضافي لمنع أي حلقة مفرغة

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي سريع وصارم بصفر استهلاك للشبكة (0-Network Pre-flight):
        - هل المهمة منجزة اليوم في النشاط اليومي؟
        - هل الرمي المجاني متاح أو توجد جائزة معلقة؟
        """
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        # 1. فحص إنجاز مهمة النشاط اليومي (Type 26: إستكشاف الهرم)
        ev_ctrl = self.get_ctrl("everydayTaskCtrl")
        ev_info = ev_ctrl.get("eventInfo", {}) if isinstance(ev_ctrl, dict) else {}
        try:
            daily_count = int(ev_info.get("26", 0) or 0)
            if daily_count >= 1:
                return False, "مهمة إستكشاف الهرم مكتملة بالفعل في النشاط اليومي لهذا اليوم"
        except (ValueError, TypeError):
            pass

        # 2. فحص كائن الهرم في الذاكرة الحية المشحونة مسبقاً (pyramidCtrl.data)
        pyr_ctrl = self.get_ctrl("pyramidCtrl")
        if not pyr_ctrl:
            return False, "بيانات الهرم (pyramidCtrl) غير متوفرة في الذاكرة الحية"

        p_data = pyr_ctrl.get("data", {}) if isinstance(pyr_ctrl.get("data"), dict) else pyr_ctrl
        if not isinstance(p_data, dict) or not p_data:
            return False, "بيانات الهرم فارغة في الذاكرة الحية"

        award = p_data.get("award", {})
        has_pending_award = isinstance(award, dict) and bool(award.get("itemid"))
        free_val = int(p_data.get("free", 0) or 0)

        # إذا كان الرمي المجاني مستهلكاً ولا توجد مكافأة معلقة، نتوقف فوراً دون ملامسة السيرفر
        if not has_pending_award and free_val == 0:
            return False, "تم استهلاك الرمي المجاني للهرم ولا توجد مكافآت معلقة (حماية الذهب)"

        return True, ""

    async def run(self) -> TaskResult:
        """
        دورة تنفيذ استكشاف الهرم:
        - رمي النرد المجاني (SubCMD 3)
        - متابعة النرد الإضافي إذا سقطت الرمية عليه
        - استلام الجائزة المستقرة (SubCMD 5)
        - تحديث الذاكرة الحية محلياً
        """
        self.log("🏛️ بدء تنفيذ مهمة إستكشاف الهرم (Imperial Mausoleum)...")

        pyr_ctrl = self.get_ctrl("pyramidCtrl")
        p_data = pyr_ctrl.get("data", {}) if isinstance(pyr_ctrl.get("data"), dict) else pyr_ctrl
        award = p_data.get("award", {})
        has_pending_award = isinstance(award, dict) and bool(award.get("itemid"))
        free_val = int(p_data.get("free", 0) or 0)

        cur_award = award if has_pending_award else None
        total_received: List[Dict[str, Any]] = []

        # 1. الرمي المجاني الأولي إذا لم تكن هناك جائزة معلقة مسبقاً
        if not cur_award and free_val == 1:
            self.log("🎲 الرمي المجاني متاح في الهرم — جاري رمي النرد (CMD 1045 / SubCMD 3)...")
            resp = await self.safe_query(self.CMD_PYRAMID, self.SUBCMD_THROW, {})
            if not resp or str(resp.get("err", "-1")) != "0":
                err = resp.get("err") if resp else "لا يوجد رد"
                return TaskResult.fail(f"تعذر رمي نرد الهرم: {err}")

            t_data = resp.get("data", {})
            cur_award = t_data.get("award", {})
            score = t_data.get("score", 0)
            self.log(f"🎲 نتيجة الرمية الأولى: {cur_award} (النقاط: {score})")

        # 2. معالجة النرد الإضافي (Bonus Dice) حتى حسم الجائزة الفعلية
        reroll_cnt = 0
        while isinstance(cur_award, dict) and cur_award.get("itemid") in self.DICE_ITEM_IDS and reroll_cnt < self.MAX_DICE_REROLLS:
            reroll_cnt += 1
            dice_id = cur_award.get("itemid")
            self.log(f"🎲 سقط النرد على رمية إضافية مجانية ({dice_id}) — مواصلة الرمي مجاناً #{reroll_cnt}...")
            await asyncio.sleep(round(random.uniform(1.2, 1.8), 2))
            resp_dice = await self.safe_query(self.CMD_PYRAMID, self.SUBCMD_THROW, {})
            if resp_dice and str(resp_dice.get("err", "-1")) == "0":
                cur_award = resp_dice.get("data", {}).get("award", {})
                self.log(f"🎲 نتيجة الرمية الإضافية #{reroll_cnt}: {cur_award}")
            else:
                err = resp_dice.get("err") if resp_dice else "لا يوجد رد"
                self.log(f"⚠️ خطأ أثناء رمي النرد الإضافي: {err}")
                break

        # 3. استلام المكافأة المستقرة عبر SubCMD 5 (receiveType: 0)
        if isinstance(cur_award, dict) and cur_award.get("itemid") and cur_award.get("itemid") not in self.DICE_ITEM_IDS:
            self.log(f"✨ مكافأة جاهزة للاستلام ({cur_award}) — جاري الاستلام بطلب (CMD 1045 / SubCMD 5)...")
            await asyncio.sleep(round(random.uniform(0.8, 1.4), 2))
            resp_claim = await self.safe_query(self.CMD_PYRAMID, self.SUBCMD_CLAIM, {"receiveType": 0})
            if resp_claim and str(resp_claim.get("err", "-1")) == "0":
                c_data = resp_claim.get("data", {})
                rec_award = c_data.get("award", cur_award)
                total_received.append(rec_award)
                self.log(f"🎉 تم استلام مكافأة الهرم بنجاح: {rec_award}")
                self._update_local_memory(c_data)
            else:
                err = resp_claim.get("err") if resp_claim else "لا يوجد رد"
                self.log(f"⚠️ تنبيه عند استلام مكافأة الهرم: {err}")

        # 4. تحديث عدادات النشاط والذاكرة محلياً لضمان عدم إعادة المحاولة في نفس اليوم
        self._mark_completed_in_memory()

        if total_received:
            return TaskResult.ok(f"تم إنجاز إستكشاف الهرم المجاني بنجاح (المكافآت المستلمة: {total_received})")

        return TaskResult.ok("تم فحص وتأكيد حالة إستكشاف الهرم المجاني بنجاح")

    def _update_local_memory(self, claim_data: Dict[str, Any]):
        """تحديث بيانات كاش الهرم محلياً بعد استلام الجائزة لمنع أي تناقض."""
        try:
            p_ctrl = self.init_data.setdefault("pyramidCtrl", {})
            if "pyramidData" in claim_data and "data" in claim_data["pyramidData"]:
                p_ctrl["data"] = claim_data["pyramidData"]["data"]
            else:
                p_data = p_ctrl.setdefault("data", {})
                p_data["free"] = 0
                p_data["award"] = {}
                p_data["state"] = 0
        except Exception:
            pass

    def _mark_completed_in_memory(self):
        """تحديث عداد النشاط اليومي Type 26 في الذاكرة الحية محلياً لمنع التكرار."""
        try:
            ev_ctrl = self.init_data.setdefault("everydayTaskCtrl", {})
            ev_info = ev_ctrl.setdefault("eventInfo", {})
            cur = int(ev_info.get("26", 0) or 0)
            ev_info["26"] = max(1, cur + 1)

            p_ctrl = self.init_data.setdefault("pyramidCtrl", {})
            p_data = p_ctrl.setdefault("data", {})
            p_data["free"] = 0
            p_data["award"] = {}
        except Exception:
            pass
