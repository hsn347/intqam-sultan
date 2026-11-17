# -*- coding: utf-8 -*-
"""
tasks/stamina.py — مهمة تعويض طاقة اللورد (Stamina Replenishment Task)
═════════════════════════════════════════════════════════════════════
تتحقق من رصيد طاقة اللورد بالقلعة وتقوم بتعويضها تلقائياً أو يدوياً عبر
استخدام حزم وباقات الطاقة من الحقيبة (0 طلبات شبكية عند كفاية الطاقة) مع
إمكانية الشراء بالذهب من المتجر الرسمي عند نفاذ الحزم وضمن السقف اليومي المحدد.
"""

from __future__ import annotations

import math
from datetime import datetime
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult, STAMINA_PACKS_CATALOG, STAMINA_PACKS_KEY_MAP


class StaminaTask(BaseTask):
    """مهمة فحص وتعويض طاقة اللورد بالقلعة بصفر طلبات شبكية عند الكفاية."""

    name = "stamina"

    # تتبع سقف صرف الذهب اليومي لكل قلعة عبر دورات البوت
    _daily_gold_tracker: Dict[str, Dict[str, Any]] = {}

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة."""
        return bool(self.config.get("enabled", False))

    def _get_castle_tracker_key(self) -> str:
        """الحصول على معرف فريد للقلعة لتتبع سقف الذهب اليومي بدقة."""
        if self.conn and hasattr(self.conn, "creds") and self.conn.creds:
            if getattr(self.conn.creds, "email", None):
                return str(self.conn.creds.email).strip().lower()
            if getattr(self.conn.creds, "uid", None):
                return str(self.conn.creds.uid).strip()
        if self.uid:
            return str(self.uid).strip()
        return "default_castle"

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

        min_stamina = int(self.config.get("min_stamina", 100))
        current_stamina = self.stamina
        if current_stamina >= min_stamina:
            return False, f"طاقة القلعة كافية ({current_stamina} >= {min_stamina})"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ مهمة تعويض طاقة اللورد:
        1. فحص قبلي في الذاكرة (0-Network Pre-flight).
        2. استهلاك حزم الطاقة من الحقيبة (النمط التلقائي أو اليدوي).
        3. شراء حزم إضافية بالذهب من المتجر الرسمي إذا سمح المستخدم وبحد أقصى يومي.
        """
        min_stamina = int(self.config.get("min_stamina", 100))
        initial_stamina = self.stamina

        # 0-Network Pre-flight Check
        if initial_stamina >= min_stamina:
            return TaskResult.skip(f"طاقة القلعة كافية ({initial_stamina} >= {min_stamina})")

        deficit = min_stamina - initial_stamina
        mode = str(self.config.get("mode", "auto")).lower().strip()
        allow_buy = bool(self.config.get("allow_buy", False))
        max_gold_daily = int(self.config.get("max_gold_daily", 1000))

        self.log(
            f"⚡ طاقة القلعة الحالية: {initial_stamina}/{min_stamina} (العجز: {deficit} نقطة) - "
            f"النمط: {mode} | الشراء بالذهب: {'مفعل' if allow_buy else 'معطل'}"
        )

        consumed_packs: List[str] = []
        total_stamina_gained = 0
        gold_spent = 0
        bought_packs = 0

        # فحص الحزم المتوفرة في الحقيبة (0-Network Direct Read)
        packs_data = self.get_available_stamina_packs()
        if not isinstance(packs_data, dict):
            packs_data = {}
        details = packs_data.get("details", {})

        # ── 1. النمط التلقائي الذكي (Auto Mode) ──
        if mode == "auto":
            count_100 = int(details.get("100", {}).get("count", 0))
            count_50 = int(details.get("50", {}).get("count", 0))
            count_10 = int(details.get("10", {}).get("count", 0))

            plan: Dict[str, int] = {"100": 0, "50": 0, "10": 0}
            rem = deficit

            # استهلاك فئة 100 إذا كان العجز المتبقي >= 100
            if rem >= 100 and count_100 > 0:
                take = min(count_100, rem // 100)
                plan["100"] += take
                rem -= take * 100

            # استهلاك فئة 50 إذا كان العجز المتبقي >= 50
            if rem >= 50 and count_50 > 0:
                take = min(count_50, rem // 50)
                plan["50"] += take
                rem -= take * 50

            # استهلاك فئة 10 لتغطية ما تبقى بدقة وبأقل هدر ممكن
            if rem > 0 and count_10 > 0:
                take = min(count_10, math.ceil(rem / 10))
                plan["10"] += take
                rem = max(0, rem - take * 10)

            # إذا استمر العجز ولا توجد حزم 10 كافية، استخدام حزمة 50 واحدة إن توفرت
            if rem > 0 and count_50 > plan["50"]:
                plan["50"] += 1
                rem = max(0, rem - 50)

            # إذا استمر العجز ولا توجد حزم 50 كافية، استخدام حزمة 100 واحدة إن توفرت
            if rem > 0 and count_100 > plan["100"]:
                plan["100"] += 1
                rem = max(0, rem - 100)

            # تنفيذ خطة الاستهلاك التلقائي
            for tier in ("100", "50", "10"):
                use_cnt = plan[tier]
                if use_cnt <= 0:
                    continue

                item_id = STAMINA_PACKS_CATALOG[tier]["item_id"]
                val = STAMINA_PACKS_CATALOG[tier]["stamina_value"]
                name_ar = STAMINA_PACKS_CATALOG[tier]["name"]

                self.log(f"📦 جاري استخدام {use_cnt} حزمة من {name_ar} من الحقيبة...")
                payload = {"itemID": item_id, "count": use_cnt}
                r = await self.safe_query("1004", "2", payload, min_delay=0.3, max_delay=0.6)
                err_code = str(r.get("err", "0")) if isinstance(r, dict) else "0"

                if err_code in ("0", "Err_None", "None") or not r:
                    self._deduct_backpack_item(item_id, use_cnt)
                    pts = use_cnt * val
                    self._add_stamina(pts)
                    total_stamina_gained += pts
                    consumed_packs.append(f"{use_cnt}x{name_ar}")
                    self.log(f"⚡ تم استخدام {use_cnt} حزمة من {name_ar} بنجاح (+{pts} طاقة)")
                else:
                    self.log(f"⚠️ فشل استخدام حزم {name_ar} (كود: {err_code})")

        # ── 2. النمط اليدوي (Manual Mode) ──
        elif mode == "manual":
            raw_tier = str(self.config.get("pack_tier", "50")).strip()
            pack_tier = STAMINA_PACKS_KEY_MAP.get(raw_tier, "50")
            if pack_tier not in ("10", "50", "100"):
                pack_tier = "50"

            pack_cfg = STAMINA_PACKS_CATALOG[pack_tier]
            item_id = pack_cfg["item_id"]
            val = pack_cfg["stamina_value"]
            name_ar = pack_cfg["name"]

            req_count = max(1, int(self.config.get("pack_count", 1)))
            avail_count = int(details.get(pack_tier, {}).get("count", 0))
            use_cnt = min(avail_count, req_count)

            if use_cnt > 0:
                self.log(f"📦 النمط اليدوي: جاري استخدام {use_cnt} من {name_ar} (المطلوب: {req_count}، المتوفر: {avail_count})...")
                payload = {"itemID": item_id, "count": use_cnt}
                r = await self.safe_query("1004", "2", payload, min_delay=0.3, max_delay=0.6)
                err_code = str(r.get("err", "0")) if isinstance(r, dict) else "0"

                if err_code in ("0", "Err_None", "None") or not r:
                    self._deduct_backpack_item(item_id, use_cnt)
                    pts = use_cnt * val
                    self._add_stamina(pts)
                    total_stamina_gained += pts
                    consumed_packs.append(f"{use_cnt}x{name_ar}")
                    self.log(f"⚡ تم استخدام {use_cnt} من {name_ar} يدوياً بنجاح (+{pts} طاقة)")
                else:
                    self.log(f"⚠️ فشل استخدام حزم {name_ar} يدوياً (كود: {err_code})")
            else:
                self.log(f"⚠️ النمط اليدوي: حزم {name_ar} غير متوفرة في الحقيبة (المتوفر: 0)")

        # ── 3. الشراء بالذهب من المتجر الرسمي عند استمرار العجز (Gold Shop Purchase) ──
        rem_deficit = min_stamina - self.stamina
        if rem_deficit > 0 and allow_buy:
            today_str = datetime.now().strftime("%Y-%m-%d")
            castle_key = self._get_castle_tracker_key()
            tracker = StaminaTask._daily_gold_tracker.setdefault(castle_key, {"date": today_str, "spent": 0})
            if tracker["date"] != today_str:
                tracker["date"] = today_str
                tracker["spent"] = 0

            shop_item_id = 1000046  # باقة 50 طاقة بالمتجر الرسمي
            item_gold_price = 200
            stamina_per_buy = 50

            while self.stamina < min_stamina:
                curr_gold = self.gold
                if curr_gold < item_gold_price:
                    self.log(f"⚠️ رصيد الذهب ({curr_gold}) لا يكفي لشراء حزمة طاقة (المطلوب: {item_gold_price} ذهب)")
                    break

                if tracker["spent"] + item_gold_price > max_gold_daily:
                    self.log(
                        f"⚠️ تم الوصول إلى السقف اليومي للذهب المخصص للطاقة "
                        f"({tracker['spent']}/{max_gold_daily} ذهب)"
                    )
                    break

                self.log(f"🪙 جاري شراء واستخدام باقة 50 طاقة بالذهب ({item_gold_price} ذهب)...")
                payload = {
                    "shopItemID": shop_item_id,
                    "num": 1,
                    "use": True,
                }
                r_buy = await self.safe_query("1034", "2", payload, min_delay=0.4, max_delay=0.8)
                err_code = str(r_buy.get("err", "0")) if isinstance(r_buy, dict) else "0"

                if err_code in ("0", "Err_None", "None") or not r_buy:
                    self._deduct_gold(item_gold_price)
                    self._add_stamina(stamina_per_buy)
                    tracker["spent"] += item_gold_price
                    gold_spent += item_gold_price
                    bought_packs += 1
                    total_stamina_gained += stamina_per_buy
                    self.log(
                        f"🪙 تم شراء واستخدام حزمة 50 طاقة بالذهب بنجاح "
                        f"(-{item_gold_price} ذهب، +{stamina_per_buy} طاقة، إجمالي اليوم: {tracker['spent']}/{max_gold_daily})"
                    )
                else:
                    self.log(f"⚠️ فشل شراء حزمة الطاقة بالذهب من المتجر (كود: {err_code})")
                    break

        # ── 4. تقييم النتيجة النهائية ──
        final_stamina = self.stamina
        if total_stamina_gained > 0 or bought_packs > 0:
            result_data = {
                "initial_stamina": initial_stamina,
                "final_stamina": final_stamina,
                "target_min": min_stamina,
                "gained": total_stamina_gained,
                "consumed_packs": consumed_packs,
                "gold_spent": gold_spent,
                "bought_packs": bought_packs,
            }
            summary = (
                f"تم تعويض طاقة القلعة بنجاح: {final_stamina}/{min_stamina} "
                f"(+{total_stamina_gained} نقطة"
                f"{f' عبر {len(consumed_packs)} حزمة' if consumed_packs else ''}"
                f"{f' وشراء {bought_packs} بالذهب ({gold_spent} ذهب)' if bought_packs > 0 else ''})"
            )
            self.log(f"🎉 {summary}")
            return TaskResult.ok(summary, data=result_data)

        # لم يتم شحن أي طاقة
        if final_stamina < min_stamina:
            msg = (
                f"طاقة القلعة ({final_stamina}) أقل من الحد الأدنى ({min_stamina})، "
                f"ولكن لا توجد حزم طاقة متاحة في الحقيبة والشراء بالذهب "
                f"{'مكتمل السقف اليومي' if (allow_buy and tracker.get('spent', 0) >= max_gold_daily) else 'معطل'}"
            )
            self.log(f"⏭️ {msg}")
            return TaskResult.skip(msg)

        return TaskResult.skip(f"طاقة القلعة كافية ({final_stamina} >= {min_stamina})")
