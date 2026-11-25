# -*- coding: utf-8 -*-
"""
tasks/wonder_merchant.py — مهمة التاجر العجيب في النشاط اليومي (Wonder Merchant Task)
═════════════════════════════════════════════════════════════════════════════════════
تنجز مهمة النشاط اليومي رقم 24 (شراء البضائع عند التاجر العجيب 10 مرات = 20 نقطة نشاط).
الميزات الأساسية:
  1. قراءة العداد اليومي (eventInfo['24']) وتواجد التاجر (isOpen) من الذاكرة الحية (0-Network).
  2. الخانات الأربع واستبدال الصنف التفاعلي الفوري (Dynamic Slot Replacement Loop).
  3. حظر الذهب الصارم: استبعاد أي سلعة سعرها بالذهب (pricetype == 1001).
  4. الشراء بالموارد الأساسية أو البلور (خشب، قمح، حديد، ميثريل، بلور) عند توفر الرصيد.
  5. التحديث المجاني الشامل للبضائع عند نفاد عروض الموارد (storesCtrl.refreshGold == 0).
  6. التوقف الفوري وحظر التحديث المدفوع بالذهب قطيعاً (عندما يكون refreshGold > 0).
"""

from __future__ import annotations

import asyncio
import random
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult


class WonderMerchantTask(BaseTask):
    """مهمة شراء بضائع التاجر العجيب للنشاط اليومي وحماية الذهب."""
    name = "wonder_merchant"
    alias = "stores"

    # ═════════════════════════════════════════════════════════════════════════
    # 1. دوال مساعدة لاستخراج الرصيد والخصم في الذاكرة الحية
    # ═════════════════════════════════════════════════════════════════════════

    def _get_resource_balance(self, price_type: int) -> float:
        """استخراج الرصيد الإجمالي الحقيقي للقلعة من الذاكرة الحية (0-Network) مطابقاً لـ cityCtrl:getResCount()."""
        # 1001 هو الذهب
        if price_type == 1001:
            lord = self.get_ctrl("lordInfoCtrl")
            base = lord.get("base", {}) if isinstance(lord, dict) else {}
            return float(base.get("gold", 0) or 0)

        # في cityCtrl.lua: resList يحتوي الإجمالي الكلي أصلاً (الحر + الآمن)، ولا يجوز جمع saferes فوقه
        city = self.get_ctrl("cityCtrl")
        if isinstance(city, dict):
            res_list = city.get("resList") or city.get("reslist") or {}
            k = str(price_type)
            return float(res_list.get(k, 0) or 0)
        return 0.0

    def _deduct_resource(self, price_type: int, amount: float):
        """
        تحديث الذاكرة الحية احتياطياً عند عدم وصول إشعار NOTIFY_CITY فوري.
        تتفادى الخصم المزدوج إذا قام إشعار السيرفر بتحديث الرصيد بالفعل.
        """
        if price_type == 1001:
            lord = self.get_ctrl("lordInfoCtrl")
            if isinstance(lord, dict):
                base = lord.setdefault("base", {})
                cur = float(base.get("gold", 0) or 0)
                base["gold"] = max(0, int(cur - amount))
        # ملاحظة: الموارد الأساسية تُحدّث تلقائياً وبدقة قطعية عبر إشعارات NOTIFY_CITY من خادم اللعبة
        # لذا تم إلغاء الخصم اليدوي لتفادي تصفير الرصيد المتبقي (Double Deduction)

    # ═════════════════════════════════════════════════════════════════════════
    # 2. الفحص القبلي (can_run)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        # 1. فحص رغبة المستخدم الصريحة في إعدادات القلعة
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة في إعدادات القلعة"

        # 2. فحص حالة إنجاز المهمة في النشاط اليومي (0-Network)
        daily_ctrl = self.get_ctrl("everydayTaskCtrl") or {}
        event_info = daily_ctrl.get("eventInfo", {}) if isinstance(daily_ctrl, dict) else {}
        purchases_today = int(event_info.get("24", 0) or 0)
        if purchases_today >= 10:
            return False, f"مهمة التاجر العجيب مكتملة لليوم ({purchases_today}/10)"

        # 3. فحص تواجد التاجر العجيب بالقلعة من الذاكرة الحية (0-Network)
        stores = self.get_ctrl("storesCtrl") or {}
        if not isinstance(stores, dict) or not stores.get("isOpen", False):
            return False, "التاجر العجيب غادر القلعة حالياً"

        return True, ""

    # ═════════════════════════════════════════════════════════════════════════
    # 3. دورة التنفيذ الرئيسية (run)
    # ═════════════════════════════════════════════════════════════════════════

    async def run(self) -> TaskResult:
        stores = self.get_ctrl("storesCtrl") or {}
        daily_ctrl = self.get_ctrl("everydayTaskCtrl") or {}
        ev_init = daily_ctrl.get("eventInfo", {}) if isinstance(daily_ctrl, dict) else {}
        purchases_today = int(ev_init.get("24", 0) or 0) if isinstance(ev_init, dict) else 0

        total_bought_this_cycle = 0

        self.log(f"🏪 بدء مهمة التاجر العجيب (الإنجاز الحالي: {purchases_today}/10)...")

        while purchases_today < 10:
            slots: List[Any] = stores.get("shopItemArray", [])
            if not isinstance(slots, list) or not slots:
                break

            bought_in_pass = False

            # فحص الخانات الأربع وحلقة استبدال الأصناف الفورية
            idx = 0
            while idx < len(slots) and purchases_today < 10:
                item = slots[idx]
                if not isinstance(item, dict):
                    idx += 1
                    continue

                price_type = int(item.get("pricetype", 1001) or 1001)
                price = float(item.get("price", 0) or 0)
                shop_item_id = item.get("shopItemID")

                # شرط الأمان الذهبي: استبعاد أي صنف ثمنه بالذهب
                if price_type == 1001 or not shop_item_id:
                    idx += 1
                    continue

                # فحص رصيد المورد أو البلور
                current_bal = self._get_resource_balance(price_type)
                if current_bal < price:
                    self.log(f"⏭️ الخانة #{idx+1}: تخطي صنف لعدم كفاية الرصيد ({int(price)} من نوع {price_type}، المتوفر: {int(current_bal)})")
                    idx += 1
                    continue

                # إرسال طلب الشراء الرسمي (CMD 1024 / SUBCMD 3)
                self.log(f"🛒 جاري شراء صنف من الخانة #{idx+1} (المعرف: {shop_item_id}، السعر: {int(price)} من النوع {price_type})...")
                res = await self.safe_query("1024", "3", {"shopItemID": shop_item_id}, min_delay=0.8, max_delay=1.3)

                if not res or str(res.get("err", "-1")) != "0":
                    err_msg = (res.get("msg") or res.get("err") or "فشل غير معروف") if res else "لا يوجد رد من السيرفر"
                    self.log(f"⚠️ فشل شراء الصنف {shop_item_id}: {err_msg}")
                    idx += 1
                    continue

                # نجاح الشراء: تحديث العدادات وإحلال الصنف البديل قبل أي خروج (بما في ذلك الشراء العاشر)
                purchases_today += 1
                total_bought_this_cycle += 1
                bought_in_pass = True

                cur_daily = self.get_ctrl("everydayTaskCtrl")
                if isinstance(cur_daily, dict):
                    cur_ev = cur_daily.setdefault("eventInfo", {})
                    if isinstance(cur_ev, dict):
                        cur_ev["24"] = max(int(cur_ev.get("24", 0) or 0), purchases_today)

                rspdata = (res.get("data") or {}).get("rspdata") if isinstance(res.get("data"), dict) else None
                if not isinstance(rspdata, dict):
                    rspdata = res.get("rspdata") or res.get("data") or {}
                new_shop_item = rspdata.get("newShopItem") if isinstance(rspdata, dict) else None

                self.log(f"✅ تم شراء الصنف بنجاح! (التقدم اليومي: {purchases_today}/10)")

                if isinstance(new_shop_item, dict) and new_shop_item.get("shopItemID"):
                    slots[idx] = new_shop_item
                    if purchases_today >= 10:
                        break
                    # فاصل زمني بشري قبل فحص الصنف البديل في نفس الخانة
                    await asyncio.sleep(round(random.uniform(1.0, 1.4), 2))
                else:
                    # نفدت بدائل هذه الخانة في السيرفر: إزالتها بنظافة دون حقن كائن ناقص
                    slots.pop(idx)
                    if purchases_today >= 10:
                        break

            # إذا قمنا بشراء صنف وحدثت تبديلات، نعيد الفحص من جديد للتأكد من كل الخانات
            if bought_in_pass and purchases_today < 10:
                continue

            # إذا أصبحت كافة الخانات أصنافاً بالذهب ولم تكتمل المهمة اليومية:
            # فحص إمكانية التحديث المجاني الشامل (refreshGold == 0)
            refresh_gold = int(stores.get("refreshGold", 0) or 0)
            if refresh_gold == 0 and purchases_today < 10:
                self.log("🔄 كافة البضائع المتبقية بالذهب — إرسال طلب تحديث مجاني شامل للبضاعة (CMD 1024 / 2)...")
                ref_res = await self.safe_query("1024", "2", {}, min_delay=1.1, max_delay=1.6)

                if ref_res and str(ref_res.get("err", "-1")) == "0":
                    rsp = (ref_res.get("data") or {}).get("rspdata") if isinstance(ref_res.get("data"), dict) else None
                    if not isinstance(rsp, dict):
                        rsp = ref_res.get("rspdata") or ref_res.get("data") or {}
                    new_array = rsp.get("shopItemArray", []) if isinstance(rsp, dict) else []
                    if isinstance(new_array, list) and new_array:
                        stores["shopItemArray"] = new_array
                        stores["refreshGold"] = int(rsp.get("refreshGold", 0) or 0)
                        stores["refreshTimes"] = int(rsp.get("refreshTimes", 0) or 0)
                        self.log(f"🎉 تم تحديث بضائع التاجر العجيب مجاناً بنجاح (المحاولات المستخدمة: {stores['refreshTimes']}).")
                        await asyncio.sleep(round(random.uniform(1.0, 1.5), 2))
                        continue  # إعادة فحص البضائع الجديدة بالكامل
                    else:
                        self.log("⚠️ قائمة البضائع المحدثة فارغة.")
                        break
                else:
                    self.log("⚠️ فشل تنفيذ التحديث المجاني للبضائع.")
                    break
            else:
                # التحديث يتطلب ذهباً (refreshGold > 0) ➔ توقف فوري لحماية الذهب
                if purchases_today < 10:
                    self.log(f"🛑 التحديث القادم يتطلب ذهباً ({refresh_gold} ذهب). توقف البوت تماماً لحماية الذهب.")
                break

        msg = f"تم إنجاز {total_bought_this_cycle} عمليات شراء من التاجر العجيب (إجمالي النشاط اليومي: {purchases_today}/10)"
        self.log(f"🏁 {msg}")
        return TaskResult.ok(msg, data={"purchases_today": purchases_today, "bought_this_cycle": total_bought_this_cycle})

