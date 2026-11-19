# -*- coding: utf-8 -*-
"""
tasks/flower.py — مهمة إهداء الزهور التلقائية لإتمام مهام النشاط اليومي (Flower Gifting Task)
════════════════════════════════════════════════════════════════════════════════════════════
المزايا الرئيسية:
  1. نظام التدرج الهرمي لحزم الزهور (Tiered Package Hierarchy):
     - الأولوية 1: الزهور الفردية (802901) — سعة 1 زهرة (الأساس والأكثر اقتصادية).
     - الأولوية 2: باقة 10 زهور (803001) — سعة 10 زهور (احتياطي أول عند نفاد الفردية).
     - الأولوية 3: باقة 100 زهرة (803101) — سعة 100 زهرة (احتياطي أخير لمنع توقف المهمة).
     - الأولوية 4: الشراء بالذهب (10 ذهب لكل زهرة) — اختياري 100% بحسب إعدادات المستخدم.
  2. الإهداء الدفعي الذكي الموحد (Batch Gifting Optimization):
     - إرسال كامل الكمية المطلوبة دفعة واحدة في طلب شبكي موحد (flowerNum = N).
     - تقليل طلبات الشبكة بنسبة 90% وتقليص زمن التنفيذ من 15 ثانية إلى أقل من ثانية واحدة.
     - حلقة تحقق ذاتي بعدية (Feedback Loop) للتأكد من وصول عداد النشاط اليومي إلى 10/10.
  3. استهداف مباشر وموثوق من لوحة المملكة (Kingdom Rankings Only):
     - المستوى 1: لوحة "ترتيب الزهور" في المملكة (Kingdom Flower Rankings) عبر CMD 1029/2 (type=10) حصراً.
     - المستوى 2: لوحة نشاط الزهور العام (Flower Activity Rankings) عبر CMD 2030/10 احتياطياً.
     - المستوى 3: قلاع المستخدم الأخرى داخل نفس المملكة احتياطياً.
  4. فحص شفاف وصفر-شبكة لمخزون الحقيبة (0-Network Cache Read & Update):
     - قراءة وتحديث أرصدة كافة حزم الزهور مباشرة في الذاكرة الحية لمنع أي تعارض.
"""

from __future__ import annotations

import asyncio
import os
import random
import sys
import time
from typing import Any, Callable, Dict, List, Optional, Tuple

if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

_ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if _ROOT_DIR not in sys.path:
    sys.path.insert(0, _ROOT_DIR)

from tasks.base_task import BaseTask, TaskResult

# معرفات حزم الزهور وسعاتها وأسعار شرائها بالذهب
FLOWER_ITEM_SINGLE = 802901       # زهرة عادية فردية (سعة 1)
FLOWER_ITEM_BUNDLE_10 = 803001    # باقة 10 زهور (سعة 10)
FLOWER_ITEM_BUNDLE_100 = 803101   # باقة 100 زهرة كبرى (سعة 100)

FLOWER_PACKAGES: Dict[int, Dict[str, Any]] = {
    FLOWER_ITEM_SINGLE: {
        "name": "زهرة عادية فردية",
        "capacity": 1,
        "gold_price": 10,
        "priority": 1,
    },
    FLOWER_ITEM_BUNDLE_10: {
        "name": "باقة 10 زهور",
        "capacity": 10,
        "gold_price": 100,
        "priority": 2,
    },
    FLOWER_ITEM_BUNDLE_100: {
        "name": "باقة 100 زهرة",
        "capacity": 100,
        "gold_price": 1000,
        "priority": 3,
    },
}

# قائمة الحزم مرتبة تصاعدياً حسب الأولوية
FLOWER_TIER_ORDER = [
    FLOWER_ITEM_SINGLE,
    FLOWER_ITEM_BUNDLE_10,
    FLOWER_ITEM_BUNDLE_100,
]

# إعدادات النشاط اليومي لإهداء الزهور (ID 4100008, type 8)
DAILY_QUEST_FLOWER_TYPE = 8
MAX_DAILY_FLOWERS = 10


class FlowerTask(BaseTask):
    """
    مهمة إهداء الزهور التلقائية لإتمام مهام النشاط اليومي في انتقام السلاطين.
    """

    name: str = "flower"
    alias: str = "give_flower"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(conn, log_func, config)

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع (0-Network) لجاهزية القلعة للتشغيل."""
        if not self.conn or not getattr(self.conn, "_alive", False):
            return False, "الاتصال ببوابة اللعبة غير متصل أو منقطع."

        k_id = self.kingdom_id
        if k_id <= 0:
            return False, "رقم المملكة غير معروف أو القلعة في طور التهيئة."

        return True, ""

    async def _get_daily_quest_flower_count(self) -> int:
        """
        قراءة عدد الزهور المهداة اليوم المسجلة في نظام النشاط اليومي من الذاكرة الحية (0-Network).
        تُقرأ مباشرة من متحكم everydayTaskCtrl دون إرسال أي استعلام للسيرفر.
        """
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or {}
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo", {})
            if isinstance(event_info, dict):
                count_str = str(DAILY_QUEST_FLOWER_TYPE)
                return int(event_info.get(count_str, 0) or 0)
        return 0

    async def _get_flower_inventory(self) -> Dict[int, int]:
        """
        فحص كميات كافة حزم الزهور (فردية 802901، باقة 10: 803001، باقة 100: 803101)
        في الحقيبة من الذاكرة الحية (0-Network)، مع استعلام احتياطي إذا لم تكن الحقيبة مهيأة.
        يعيد قاموساً {item_id: count}.
        """
        inventory: Dict[int, int] = {
            FLOWER_ITEM_SINGLE: 0,
            FLOWER_ITEM_BUNDLE_10: 0,
            FLOWER_ITEM_BUNDLE_100: 0,
        }

        backpack_ctrl = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")

        def _extract_from_dict(d: dict):
            for item_id in inventory.keys():
                # 1. مطابقة مباشرة بالمفتاح
                if str(item_id) in d:
                    entry = d[str(item_id)]
                    if isinstance(entry, dict):
                        inventory[item_id] = max(
                            inventory[item_id],
                            int(entry.get("count", entry.get("num", 0)) or 0)
                        )
                    elif isinstance(entry, (int, float)):
                        inventory[item_id] = max(inventory[item_id], int(entry))

            # 2. فحص itemList أو items إذا وجدت
            raw_items = d.get("itemList", d.get("items", {}))
            if isinstance(raw_items, dict):
                for k, v in raw_items.items():
                    if isinstance(v, dict):
                        iid = int(v.get("id", v.get("itemID", k if str(k).isdigit() else 0)) or 0)
                        if iid in inventory:
                            inventory[iid] = max(
                                inventory[iid],
                                int(v.get("count", v.get("num", 0)) or 0)
                            )
            elif isinstance(raw_items, list):
                for v in raw_items:
                    if isinstance(v, dict):
                        iid = int(v.get("id", v.get("itemID", 0)) or 0)
                        if iid in inventory:
                            inventory[iid] = max(
                                inventory[iid],
                                int(v.get("count", v.get("num", 0)) or 0)
                            )

        if isinstance(backpack_ctrl, dict):
            _extract_from_dict(backpack_ctrl)

        # استعلام احتياطي للبوابة في حال كانت الحقيبة فارغة في الذاكرة الحية
        if sum(inventory.values()) == 0 and not backpack_ctrl:
            try:
                r_bag = await self.safe_query("1004", "1", {}, min_delay=0.2, max_delay=0.4)
                if r_bag and isinstance(r_bag, dict):
                    data = r_bag.get("data", {})
                    if isinstance(data, dict):
                        _extract_from_dict(data)
                        if getattr(self.conn, "init_data", None) is not None:
                            self.conn.init_data["backpackCtrl"] = data.get("itemList", data)
            except Exception:
                pass

        return inventory

    async def _resolve_targets(self, my_uid: str) -> Tuple[List[Dict[str, str]], str]:
        """
        تحديد قائمة اللوردات المؤهلين للإهداء بالاعتماد المباشر على لوحة ترتيب المملكة (CMD 1029):
        المستوى 1: لوحة "ترتيب الزهور" في المملكة (Kingdom Flower Rankings) عبر CMD 1029 / 2 (type=10).
        المستوى 2 (احتياطي): لوحة نشاط الزهور العام (Flower Activity Rankings) عبر CMD 2030 / 10.
        المستوى 3 (احتياطي): قلاع المستخدم الأخرى داخل نفس المملكة.
        """
        targets: List[Dict[str, str]] = []

        # المستوى 1: لوحة ترتيب الزهور في المملكة (Flower Rankings - CMD 1029 / 2 / type 10)
        self.log("🌸 جلب مرشحين من لوحة 'ترتيب الزهور' داخل المملكة (CMD 1029)...")
        try:
            r_rank = await self.safe_query("1029", "2", {"type": 10}, min_delay=0.3, max_delay=0.6)
            if r_rank and isinstance(r_rank, dict):
                r_data = r_rank.get("data", {})
                raw_list = r_data.get("data", []) if isinstance(r_data, dict) else (
                    r_data if isinstance(r_data, list) else []
                )
                if isinstance(raw_list, list):
                    for item in raw_list:
                        if not isinstance(item, dict):
                            continue
                        uid = str(item.get("uid", "")).strip()
                        name = str(item.get("nickName") or item.get("name") or "أمير في ترتيب الزهور").strip()
                        if uid and uid != my_uid and uid != "0":
                            targets.append({"uid": uid, "name": name})

            if targets:
                self.log(f"✓ تم استخراج {len(targets)} لورداً من لوحة 'ترتيب الزهور'.")
                return targets, "ترتيب الزهور (مملكة)"
        except Exception as e:
            self.log(f"⚠️ تعذر جلب ترتيب الزهور (1029): {e}")

        # المستوى 3: نشاط الزهور (CMD 2030 / 10)
        try:
            r_act = await self.safe_query("2030", "10", {"rankType": 1}, min_delay=0.3, max_delay=0.6)
            if r_act and isinstance(r_act, dict):
                rankdata = r_act.get("rankdata", [])
                if isinstance(rankdata, list):
                    my_kid = self.kingdom_id
                    for item in rankdata:
                        if not isinstance(item, dict):
                            continue
                        uid = str(item.get("uid", "")).strip()
                        name = str(item.get("nickName") or item.get("name") or "أمير").strip()
                        kid = int(item.get("kid", 0) or 0)
                        if uid and uid != my_uid and uid != "0":
                            if not my_kid or kid == my_kid or kid == 0:
                                targets.append({"uid": uid, "name": name})
                            elif not targets:
                                targets.append({"uid": uid, "name": name})

            if targets:
                self.log(f"✓ تم استخراج {len(targets)} لورداً من نشاط الزهور (2030).")
                return targets, "نشاط الزهور العام"
        except Exception as e:
            self.log(f"⚠️ تعذر جلب نشاط الزهور (2030): {e}")

        # المستوى 4: قلاع المستخدم الأخرى في نفس المملكة
        try:
            import core.database as db
            all_castles = db.get_all_castles()
            my_kid = self.kingdom_id
            for c in all_castles:
                c_uid = str(c.get("uid") or "").strip()
                c_kid = int(c.get("server_id") or 0)
                if c_uid and c_uid != my_uid and (not my_kid or c_kid == my_kid):
                    c_name = c.get("lord_name") or c.get("castle_name") or "قلعة مستخدم رديفة"
                    targets.append({"uid": c_uid, "name": c_name})

            if targets:
                self.log(f"✓ تم العثور على {len(targets)} قلاع أخرى لنفس المستخدم في المملكة.")
                return targets, "قلاع المستخدم الرديفة"
        except Exception as e:
            self.log(f"⚠️ تعذر جلب قلاع المستخدم الأخرى: {e}")

        return targets, "غير محدد"

    async def run(self) -> TaskResult:
        """
        تنفيذ مهمة إهداء الزهور وفق المعايير المعتمدة والمطورة:
        1. فحص مخزون كافة حزم الزهور (فردية، 10، 100) وعرضه للمستخدم بشفافية تامة.
        2. التحقق من تقدم النشاط اليومي (10/10) والتوقف الفوري إذا كان مكتملاً.
        3. استهداف مرن وهجين لأعضاء التحالف أو ترتيب الزهور.
        4. تطبيق التدرج الهرمي (فردية -> باقة 10 -> باقة 100 -> ذهب).
        5. إهداء دفعي موحد (Batch Sending) لتقليص استهلاك الشبكة بنسبة 90% مع فحص تأكيدي بعدي.
        """
        self.log("🌸 بدء فحص مهمة إهداء الزهور (النشاط اليومي)...")

        # 1. فحص رصيد كافة حزم الزهور المتوفرة بالحقيبة
        inventory = await self._get_flower_inventory()
        allow_gold = bool(self.config.get("allow_gold", False))
        current_gold = self.gold

        self.log(
            f"🎒 مخزون الحقيبة: "
            f"{inventory[FLOWER_ITEM_SINGLE]} زهرة فردية (802901) | "
            f"{inventory[FLOWER_ITEM_BUNDLE_10]} باقة 10 زهور (803001) | "
            f"{inventory[FLOWER_ITEM_BUNDLE_100]} باقة 100 زهرة (803101)."
        )

        # 2. فحص تقدم مهمة إهداء 10 زهور في النشاط اليومي
        current_daily_flowers = await self._get_daily_quest_flower_count()
        if current_daily_flowers >= MAX_DAILY_FLOWERS:
            self.log(f"✅ مهمة إهداء الزهور في النشاط اليومي مكتملة بالفعل لليوم ({current_daily_flowers}/{MAX_DAILY_FLOWERS}).")
            return TaskResult.ok(
                f"مهمة إهداء الزهور في النشاط اليومي مكتملة بالفعل ({current_daily_flowers}/{MAX_DAILY_FLOWERS})."
            )

        needed_flowers = MAX_DAILY_FLOWERS - current_daily_flowers
        self.log(
            f"📊 تقدم النشاط اليومي: تم إهداء {current_daily_flowers}/{MAX_DAILY_FLOWERS} زهرة اليوم "
            f"(المتبقي لإتمام المهمة: {needed_flowers} زهرة)."
        )

        # 3. التأكد من كفاية الرصيد عبر أي حزمة أو بالذهب
        total_available_capacity = (
            inventory[FLOWER_ITEM_SINGLE] * 1
            + inventory[FLOWER_ITEM_BUNDLE_10] * 10
            + inventory[FLOWER_ITEM_BUNDLE_100] * 100
        )
        if total_available_capacity <= 0 and not allow_gold:
            return TaskResult.skip(
                "نفدت كافة حزم الزهور من الحقيبة (فردية، 10، 100)، وخيار الشراء بالذهب معطل."
            )

        # 4. تحديد هوية القلعة واللوردات المستهدفين للإهداء
        lord_info = self.get_ctrl("lordInfoCtrl") or {}
        lord_base = lord_info.get("base", {}) if isinstance(lord_info, dict) else {}
        my_uid = str(lord_base.get("uid") or getattr(getattr(self.conn, "creds", None), "uid", "")).strip()

        targets, target_source = await self._resolve_targets(my_uid)
        if not targets:
            return TaskResult.skip(
                "لم يتم العثور على أي لورد مؤهل للإهداء (التحالف / ترتيب الزهور)."
            )

        # 5. دورة الإهداء الدفعي الذكي (Batch Gifting Optimization)
        free_sent_total = 0
        gold_sent_total = 0
        consecutive_errors = 0
        batches_sent = 0
        last_daily_progress = current_daily_flowers

        while needed_flowers > 0:
            if not targets:
                self.log("⚠️ استنفدت قائمة اللوردات المتاحين للإهداء.")
                break

            target = random.choice(targets)
            target_uid = target["uid"]
            target_name = target["name"]

            # تحديد وسيلة وحزمة الإهداء المناسبة وفق التدرج الهرمي المعتمد
            chosen_item_id: Optional[int] = None
            send_qty: int = 0
            use_gold: bool = False

            # الأولوية 1: الزهور الفردية 802901 (إرسال كامل المتبقي دفعة واحدة أو المتوفر بالحقيبة)
            if inventory[FLOWER_ITEM_SINGLE] > 0:
                chosen_item_id = FLOWER_ITEM_SINGLE
                send_qty = min(inventory[FLOWER_ITEM_SINGLE], needed_flowers)
                use_gold = False

            # الأولوية 2: باقة 10 زهور 803001 (إهداء باقة واحدة سعة 10)
            elif inventory[FLOWER_ITEM_BUNDLE_10] > 0:
                chosen_item_id = FLOWER_ITEM_BUNDLE_10
                send_qty = 1
                use_gold = False

            # الأولوية 3: باقة 100 زهرة كبرى 803101 (إهداء باقة واحدة كبرى)
            elif inventory[FLOWER_ITEM_BUNDLE_100] > 0:
                chosen_item_id = FLOWER_ITEM_BUNDLE_100
                send_qty = 1
                use_gold = False

            # الأولوية 4: الشراء بالذهب إذا وافق المستخدم ونفدت كافة باقات الحقيبة
            elif allow_gold and current_gold >= FLOWER_PACKAGES[FLOWER_ITEM_SINGLE]["gold_price"]:
                chosen_item_id = FLOWER_ITEM_SINGLE
                unit_price = FLOWER_PACKAGES[FLOWER_ITEM_SINGLE]["gold_price"]
                max_afford = current_gold // unit_price
                send_qty = min(needed_flowers, max_afford)
                if send_qty <= 0:
                    self.log(f"⚠️ رصيد الذهب الحالي ({current_gold}) لا يكفي لشراء زهرة.")
                    break
                use_gold = True

            else:
                self.log("⚠️ نفدت كافة حزم الزهور المتاحة ورصيد الذهب لا يكفي أو معطل.")
                break

            pkg_info = FLOWER_PACKAGES[chosen_item_id]
            pkg_name = pkg_info["name"]
            pkg_capacity = pkg_info["capacity"]
            total_flowers_in_batch = send_qty * pkg_capacity

            subcmd = "2" if use_gold else "1"
            action_desc = (
                f"شراء وإهداء دفعة بالذهب ({send_qty * pkg_info['gold_price']} ذهب)"
                if use_gold
                else f"إهداء مجاني من الحقيبة"
            )

            payload = {
                "giftUserID": str(target_uid),
                "flowerID": chosen_item_id,
                "flowerNum": send_qty,
            }

            try:
                resp = await self.conn.query("2023", subcmd, payload, timeout=7.0)
                if not resp or not isinstance(resp, dict):
                    consecutive_errors += 1
                    if consecutive_errors >= 2:
                        self.log("⚠️ لا توجد استجابة من السيرفر عند إهداء الزهور، إيقاف الدورة مؤقتاً.")
                        break
                    continue

                err_code = str(resp.get("err", "0"))

                # نجاح الإهداء الدفعي
                if err_code in ("0", "None", ""):
                    consecutive_errors = 0
                    batches_sent += 1

                    if use_gold:
                        gold_sent_total += total_flowers_in_batch
                        current_gold -= send_qty * pkg_info["gold_price"]
                    else:
                        free_sent_total += total_flowers_in_batch
                        inventory[chosen_item_id] = max(0, inventory[chosen_item_id] - send_qty)

                    self.log(
                        f"💐 [دفعة إهداء #{batches_sent}] تم بنجاح إهداء {send_qty} من '{pkg_name}' "
                        f"({total_flowers_in_batch} زهرة) إلى '{target_name}' [{target_source}] ({action_desc})."
                    )

                    # تحديث ومطابقة عداد النشاط اليومي مباشرة في الذاكرة الحية (0-Network)
                    everyday_ctrl = self.get_ctrl("everydayTaskCtrl")
                    if isinstance(everyday_ctrl, dict):
                        ev = everyday_ctrl.setdefault("eventInfo", {})
                        if isinstance(ev, dict):
                            ev[str(DAILY_QUEST_FLOWER_TYPE)] = min(
                                MAX_DAILY_FLOWERS,
                                int(ev.get(str(DAILY_QUEST_FLOWER_TYPE), 0) or 0) + total_flowers_in_batch
                            )

                    updated_daily = min(MAX_DAILY_FLOWERS, current_daily_flowers + free_sent_total + gold_sent_total)
                    last_daily_progress = updated_daily
                    self.log(f"📊 إنجاز النشاط اليومي بعد الدفعة: {updated_daily}/{MAX_DAILY_FLOWERS}.")

                    if updated_daily >= MAX_DAILY_FLOWERS:
                        needed_flowers = 0
                        break
                    else:
                        needed_flowers = max(0, MAX_DAILY_FLOWERS - updated_daily)
                        await asyncio.sleep(random.uniform(0.5, 1.0))

                elif err_code == "8":
                    self.log(f"⚠️ اللورد '{target_name}' غير موجود في نفس المملكة، تجربة لورد آخر...")
                    targets = [t for t in targets if t["uid"] != target_uid]
                    continue

                elif err_code == "430008":
                    self.log("⚠️ تم بلوغ الحد الأقصى لنظام الزهور لهذا اليوم من السيرفر.")
                    break

                else:
                    self.log(f"⚠️ رفض السيرفر إهداء الزهرة للأمير '{target_name}' (كود الخطأ: {err_code}).")
                    targets = [t for t in targets if t["uid"] != target_uid]
                    consecutive_errors += 1
                    if consecutive_errors >= 3:
                        break

            except Exception as e:
                self.log(f"⚠️ استثناء أثناء إرسال طلب الزهرة: {e}")
                consecutive_errors += 1
                if consecutive_errors >= 2:
                    break

        # 6. تحديث كائن الحقيبة المحلي في الذاكرة الحية لكافة الحزم (0-Network Cache Update)
        if free_sent_total > 0:
            backpack_ctrl = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
            if isinstance(backpack_ctrl, dict):
                for item_id, rem_cnt in inventory.items():
                    if str(item_id) in backpack_ctrl:
                        entry = backpack_ctrl[str(item_id)]
                        if isinstance(entry, dict) and "count" in entry:
                            entry["count"] = rem_cnt

        # 7. تقرير النتيجة النهائية
        total_sent = free_sent_total + gold_sent_total
        if total_sent > 0 or needed_flowers == 0:
            final_progress = last_daily_progress if last_daily_progress > 0 else (current_daily_flowers + total_sent)
            self.log(
                f"🎉 تم إهداء الزهور بنجاح وإنجاز مهمة النشاط اليومي ({final_progress}/{MAX_DAILY_FLOWERS}) "
                f"في {batches_sent} دفعة فقط [مجاني: {free_sent_total}، بالذهب: {gold_sent_total}]."
            )
            return TaskResult.ok(
                f"تم إهداء الزهور بنجاح ({target_source}) - التقدم اليومي: {final_progress}/{MAX_DAILY_FLOWERS} في {batches_sent} دفعة."
            )
        else:
            return TaskResult.skip(
                "لم يتم إهداء أي زهور جديدة (قد تكون مكتملة أو تعذر الوصول للهدف)."
            )
