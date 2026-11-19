# -*- coding: utf-8 -*-
"""
tasks/stamina.py — مهمة تعويض طاقة اللورد (Stamina Replenishment Task)
═════════════════════════════════════════════════════════════════════
تتحقق من رصيد طاقة اللورد بالقلعة وتقوم بتعويضها تلقائياً عبر:
1. استهلاك كافة حزم وباقات الطاقة المجانية المتوفرة بالحقيبة (100، 50، 10).
2. الشراء بالذهب من المتجر الرسمي (باقات 50 طاقة - 1034/2) فقط عند نفاذ الحزم
   المجانية بالحقيبة، وتفعيل خيار الشراء بالذهب، وانخفاض الطاقة عن السقف المحدد،
   وتوفر رصيد الذهب الكافي لكامل الكمية المطلوبة دون شراء جزئي.
3. فحص قبلي في الذاكرة (0-Network Pre-flight) بصفر طلبات شبكية عند عدم تحقق الشروط.
"""

from __future__ import annotations

import math
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult, STAMINA_PACKS_CATALOG


# الحد الأقصى الرسمي المسموح باستهلاكه في الطلب الواحد بسيرفر اللعبة لتفادي كود الخطأ 2004 (Err_ITEM_USE_COUNT_IS_LIMIT)
STAMINA_USE_BATCH_LIMITS: Dict[str, int] = {
    "100": 10,  # 10 * 100 = 1000 نقطة طاقة كحد أقصى للطلب الواحد
    "50": 20,   # 20 * 50  = 1000 نقطة طاقة كحد أقصى للطلب الواحد
    "10": 50,   # 50 * 10  = 500  نقطة طاقة كحد أقصى للطلب الواحد
}


class StaminaTask(BaseTask):
    """مهمة فحص وتعويض طاقة اللورد بالقلعة بصفر طلبات شبكية عند عدم الحاجة."""

    name = "stamina"

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة."""
        return bool(self.config.get("enabled", False))

    def _deduct_backpack_item(self, item_id: int | str, count: int) -> None:
        """تحديث رصيد الحقيبة محلياً في الذاكرة الحية فور نجاح الاستخدام لمنع أي تكرار."""
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            return
        for k in (str(item_id), int(item_id)):
            if k in backpack:
                entry = backpack[k]
                if isinstance(entry, dict):
                    curr = int(entry.get("count", 0))
                    if curr > count:
                        entry["count"] = curr - count
                    else:
                        backpack.pop(k, None)
                elif isinstance(entry, (int, str)):
                    curr = int(entry)
                    if curr > count:
                        backpack[k] = curr - count
                    else:
                        backpack.pop(k, None)
                break

    def _add_stamina(self, amount: int) -> None:
        """تحديث رصيد طاقة اللورد محلياً في الذاكرة الحية فور نجاح الشحن."""
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict) and "base" in lord and isinstance(lord["base"], dict):
            curr = int(lord["base"].get("health", 0))
            lord["base"]["health"] = curr + amount

    def _deduct_gold(self, amount: int) -> None:
        """تحديث رصيد الذهب محلياً في الذاكرة الحية فور نجاح الشراء."""
        lord = self.get_ctrl("lordInfoCtrl")
        if isinstance(lord, dict) and "base" in lord and isinstance(lord["base"], dict):
            curr = int(lord["base"].get("gold", 0))
            lord["base"]["gold"] = max(0, curr - amount)

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع (0-Network Pre-flight): التحقق من الشروط قبل ملامسة السيرفر."""
        if not self.is_active:
            return False, "المهمة معطلة في الإعدادات"

        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        # فحص الحزم المتوفرة في الحقيبة في الذاكرة الحية (0 طلبات شبكية)
        packs_data = self.get_available_stamina_packs()
        total_packs = int(packs_data.get("total_packs", 0)) if isinstance(packs_data, dict) else 0

        if total_packs > 0:
            return True, ""

        # في حال عدم وجود حزم مجانية، نتحقق من إمكانية الشراء بالذهب
        gold_buy_enabled = bool(self.config.get("gold_buy_enabled", False))
        if not gold_buy_enabled:
            return False, "لا توجد حزم طاقة مجانية في الحقيبة والشراء بالذهب غير مفعل"

        gold_trigger_stamina = int(self.config.get("gold_trigger_stamina", 50))
        current_stamina = self.stamina
        if current_stamina > gold_trigger_stamina:
            return False, f"طاقة القلعة ({current_stamina}) أعلى من سقف تفعيل الشراء بالذهب ({gold_trigger_stamina})"

        gold_buy_stamina_amount = int(self.config.get("gold_buy_stamina_amount", 50))
        required_purchases = max(1, math.ceil(gold_buy_stamina_amount / 50))
        total_gold_needed = required_purchases * 200

        current_gold = self.gold
        if current_gold < total_gold_needed:
            return False, f"رصيد الذهب ({current_gold}) لا يكفي لشراء {gold_buy_stamina_amount} طاقة (المطلوب: {total_gold_needed} ذهب)"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ مهمة تعويض طاقة اللورد:
        • الخطوة 1: استهلاك كافة حزم الطاقة المجانية المتوفرة بالحقيبة بالكامل (100، 50، 10).
        • الخطوة 2: الشراء بالذهب عند نفاذ الحزم المجانية وانخفاض الطاقة وتوفر الذهب الكافي.
        • الخطوة 3: التخطي عند عدم توفر حزم مجانية وعدم استيفاء شروط الشراء بالذهب.
        """
        gold_buy_enabled = bool(self.config.get("gold_buy_enabled", False))
        gold_trigger_stamina = int(self.config.get("gold_trigger_stamina", 50))
        gold_buy_stamina_amount = int(self.config.get("gold_buy_stamina_amount", 50))

        initial_stamina = self.stamina
        consumed_packs: List[str] = []
        total_stamina_gained = 0
        gold_spent = 0
        bought_packs = 0

        # ── الخطوة 1: فحص واستهلاك حزم الطاقة المجانية بالحقيبة (Free Packs) ──
        packs_data = self.get_available_stamina_packs()
        if not isinstance(packs_data, dict):
            packs_data = {}
        total_free_packs = int(packs_data.get("total_packs", 0))
        details = packs_data.get("details", {})

        if total_free_packs > 0:
            self.log(
                f"📦 تم العثور على {total_free_packs} حزمة طاقة مجانية بالحقيبة "
                f"({packs_data.get('total_stamina', 0)} نقطة طاقة). جاري استهلاكها بالكامل..."
            )
            for tier in ("100", "50", "10"):
                tier_info = details.get(tier, {})
                count = int(tier_info.get("count", 0))
                if count <= 0:
                    continue

                item_id = STAMINA_PACKS_CATALOG[tier]["item_id"]
                val = STAMINA_PACKS_CATALOG[tier]["stamina_value"]
                name_ar = STAMINA_PACKS_CATALOG[tier]["name"]

                batch_limit = STAMINA_USE_BATCH_LIMITS.get(tier, 10)
                remaining_to_use = count
                used_in_tier = 0

                self.log(
                    f"📦 جاري استخدام كافة حزم {name_ar} المتوفرة ({count} حزمة) "
                    f"على دفعات رسمية (سقف الدفعة: {batch_limit})..."
                )

                while remaining_to_use > 0:
                    batch_count = min(remaining_to_use, batch_limit)
                    payload = {"itemID": item_id, "count": batch_count}
                    r = await self.safe_query("1004", "2", payload, min_delay=0.3, max_delay=0.6)
                    err_code = str(r.get("err", "0")) if isinstance(r, dict) else "0"

                    if err_code in ("0", "Err_None", "None") or not r:
                        self._deduct_backpack_item(item_id, batch_count)
                        pts = batch_count * val
                        self._add_stamina(pts)
                        total_stamina_gained += pts
                        used_in_tier += batch_count
                        remaining_to_use -= batch_count
                    else:
                        self.log(f"⚠️ فشل استخدام دفعة من حزم {name_ar} ({batch_count} حزمة) - كود: {err_code}")
                        break

                if used_in_tier > 0:
                    tier_pts = used_in_tier * val
                    consumed_packs.append(f"{used_in_tier}x{name_ar}")
                    self.log(f"⚡ تم استخدام {used_in_tier} حزمة من {name_ar} بنجاح (+{tier_pts} طاقة)")

        # ── الخطوة 2: الشراء بالذهب من المتجر الرسمي (Gold Purchase) ──
        # يُفعّل فقط إذا كانت الحزم المجانية بالحقيبة 0، والشراء بالذهب مفعل، والطاقة <= سقف التفعيل
        updated_packs = self.get_available_stamina_packs()
        rem_free_packs = int(updated_packs.get("total_packs", 0)) if isinstance(updated_packs, dict) else 0

        if rem_free_packs == 0 and gold_buy_enabled and self.stamina <= gold_trigger_stamina:
            required_purchases = max(1, math.ceil(gold_buy_stamina_amount / 50))
            total_gold_needed = required_purchases * 200
            current_gold = self.gold

            if current_gold < total_gold_needed:
                self.log(
                    f"⚠️ رصيد الذهب ({current_gold}) لا يكفي لشراء الحزم المطلوبة "
                    f"({total_gold_needed} ذهب). التوقف دون شراء جزئي وفق التوجيهات."
                )
            else:
                self.log(
                    f"🪙 جاري شراء واستخدام {required_purchases} حزمة طاقة بالذهب "
                    f"({total_gold_needed} ذهب لـ {required_purchases * 50} طاقة)..."
                )
                payload = {
                    "shopItemID": 1000046,
                    "num": required_purchases,
                    "use": True,
                }
                r_buy = await self.safe_query("1034", "2", payload, min_delay=0.4, max_delay=0.8)
                err_code = str(r_buy.get("err", "0")) if isinstance(r_buy, dict) else "0"

                if err_code in ("0", "Err_None", "None") or not r_buy:
                    stamina_bought = required_purchases * 50
                    self._deduct_gold(total_gold_needed)
                    self._add_stamina(stamina_bought)
                    gold_spent += total_gold_needed
                    bought_packs += required_purchases
                    total_stamina_gained += stamina_bought
                    self.log(
                        f"🪙 تم شراء واستخدام {required_purchases} حزمة 50 طاقة بالذهب بنجاح "
                        f"(-{total_gold_needed} ذهب، +{stamina_bought} طاقة)"
                    )
                else:
                    self.log(f"⚠️ فشل شراء حزم الطاقة بالذهب من المتجر (كود: {err_code})")

        # ── الخطوة 3: تقييم النتيجة وتحديد التخطي (Result Evaluation) ──
        if total_stamina_gained > 0 or bought_packs > 0:
            final_stamina = self.stamina
            summary_parts = []
            if consumed_packs:
                summary_parts.append(f"استهلاك {', '.join(consumed_packs)}")
            if bought_packs > 0:
                summary_parts.append(f"شراء {bought_packs} حزمة بالذهب ({gold_spent} ذهب)")

            summary = f"تم تعويض الطاقة بنجاح (+{total_stamina_gained} طاقة): {', '.join(summary_parts)}"
            self.log(f"🎉 {summary}")
            return TaskResult.ok(summary, data={
                "initial_stamina": initial_stamina,
                "final_stamina": final_stamina,
                "gained": total_stamina_gained,
                "consumed_packs": consumed_packs,
                "gold_spent": gold_spent,
                "bought_packs": bought_packs,
            })

        # شرط التخطي الصريح: عند عدم وجود حزم مجانية وعدم الشراء بالذهب
        if not gold_buy_enabled:
            msg = "لا توجد حزم طاقة مجانية في الحقيبة والشراء بالذهب غير مفعل"
        elif self.stamina > gold_trigger_stamina:
            msg = f"لا توجد حزم مجانية وطاقة اللورد ({self.stamina}) أعلى من سقف الشراء بالذهب ({gold_trigger_stamina})"
        else:
            msg = f"لا توجد حزم مجانية ورصيد الذهب ({self.gold}) غير كافٍ لشراء الكمية المطلوبة"

        self.log(f"⏭️ {msg}")
        return TaskResult.skip(msg)
