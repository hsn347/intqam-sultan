# -*- coding: utf-8 -*-
"""
tasks/treasure.py — مهمة نافورة الكنوز (Trevi Fountain Task)
═════════════════════════════════════════════════════════════
تنفذ سحب موارد نافورة الكنوز وفق إعدادات وتفضيلات المستخدم:
  1. سحب الموارد الستة الرسمية التي يحددها المستخدم فقط (أو الستة افتراضياً).
  2. شرط حاسم في البداية: الخروج فوراً وتخطي المهمة إذا لم توجد سحبات مجانية،
     حتى لو كان السحب بالذهب مسموحاً به.
  3. إنهاء كافة السحبات المجانية المتاحة للموارد المختارة.
  4. السحب بالذهب إذا كان مفعلاً من المستخدم برقم أكبر من الصفر (gold_times > 0)
     بعدد المرات المحدد لكل مورد تم اختياره.
"""

from __future__ import annotations

from typing import Any, Dict, List, Optional, Set, Tuple
from tasks.base_task import BaseTask, TaskResult

# معرّفات الموارد الرسمية الستة في اللعبة مع مفاتيح المطابقة المتعددة
FOUNTAIN_RESOURCES: List[Tuple[int, str, List[str]]] = [
    (1002, "طعام", ["food", "grain", "1002", "طعام"]),
    (1003, "خشب", ["wood", "1003", "خشب"]),
    (1004, "حديد", ["iron", "1004", "حديد"]),
    (1006, "صلب", ["steel", "coal", "1006", "صلب"]),
    (1005, "ميثريل", ["mithril", "diamond", "silver", "1005", "ميثريل"]),
    (1027, "بلور", ["crystal", "1027", "بلور"]),
]


class TreasureTask(BaseTask):
    """مهمة استلام موارد نافورة الكنوز وفق تفضيلات المستخدم."""
    name = "fountain"
    alias = "treasure_hunt"

    async def can_run(self) -> Tuple[bool, str]:
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        # 1. فحص وجود بيانات treviFountain في الذاكرة الحية (0 طلب شبكي)
        trevi_data = self.get_ctrl("treviFountainCtrl")
        if not trevi_data:
            return False, "بيانات نافورة الكنوز غير متوفرة في الذاكرة الحية"

        # 2. 👈 الشرط الحاسم في بداية المهمة:
        # فحص السحبات المجانية أولاً؛ فإذا لم تكن هناك أي سحبة مجانية نخرج فوراً ونلغي المهمة
        # حتى لو كان السحب بالذهب محدداً بـ (gold_times > 0)
        free_times = int(trevi_data.get("multipleTimes", 0)) + int(trevi_data.get("pornMultipleTimes", 0))
        if free_times <= 0:
            return False, "لا توجد سحبات مجانية متبقية اليوم — خروج فوري حتى لو كان السحب بالذهب محدداً"

        return True, ""

    def _get_target_resources(self) -> List[Tuple[int, str]]:
        """تصفية الموارد المراد سحبها وفق قائمة الموارد المحددة من المستخدم"""
        user_res = self.config.get("resources", [])
        if not user_res or not isinstance(user_res, list):
            # إذا لم يُحدد المستخدم موارد، يتم سحب الموارد الستة كاملة افتراضياً
            return [(r_id, r_name) for r_id, r_name, _ in FOUNTAIN_RESOURCES]

        user_keys = {str(k).lower().strip() for k in user_res}
        targets = []
        for r_id, r_name, aliases in FOUNTAIN_RESOURCES:
            if any(alias in user_keys for alias in aliases):
                targets.append((r_id, r_name))

        # في حال حدد المستخدم قائمة فارغة أو غير متطابقة، نعتمد الموارد الستة
        return targets or [(r_id, r_name) for r_id, r_name, _ in FOUNTAIN_RESOURCES]

    async def run(self) -> TaskResult:
        trevi_data = self.get_ctrl("treviFountainCtrl")
        free_times = int(trevi_data.get("multipleTimes", 0)) + int(trevi_data.get("pornMultipleTimes", 0))
        gold_times_per_res = max(0, int(self.config.get("gold_times", 0)))

        target_resources = self._get_target_resources()
        res_names_str = "، ".join([name for _, name in target_resources])
        self.log(f"💎 الموارد المحددة للسحب ({len(target_resources)}/6): [{res_names_str}]")
        self.log(f"🎁 سحبات مجانية متاحة: {free_times} | حد السحب بالذهب لكل مورد: {gold_times_per_res}")

        results: List[Dict[str, Any]] = []
        free_collected = 0
        gold_collected = 0

        # ═════════════════════════════════════════════════════════════════════
        # المرحلة 1: إنهاء كافة السحبات المجانية المتاحة للموارد المختارة
        # ═════════════════════════════════════════════════════════════════════
        while free_times > 0:
            draw_in_cycle = 0
            for res_id, res_name in target_resources:
                if free_times <= 0:
                    break

                r = await self.safe_query("1018", "2", {"resourceType": res_id})
                if not r:
                    self.log(f"  ⚠️ [{res_name}] لا يوجد رد من السيرفر.")
                    results.append({"resource": res_name, "mode": "free", "success": False, "msg": "no_response"})
                    continue

                err = str(r.get("err", "-1"))
                if err == "0":
                    data = r.get("data", {})
                    added = int(data.get("addResource", 0))
                    mult = data.get("must", 1)
                    free_times = int(data.get("multipleTimes", 0)) + int(data.get("pornMultipleTimes", 0))
                    self.log(f"  ✅ [مجاني][{res_name}] +{added:,} (x{mult}) | متبقي مجاني: {free_times}")
                    results.append({"resource": res_name, "mode": "free", "success": True, "added": added, "mult": mult})
                    free_collected += 1
                    draw_in_cycle += 1

                    # تحديث الذاكرة الحية فوراً
                    trevi_data["multipleTimes"] = int(data.get("multipleTimes", 0))
                    trevi_data["pornMultipleTimes"] = int(data.get("pornMultipleTimes", 0))

                elif err == "45001":  # حد السحب المجاني نفد لهذا المورد
                    self.log(f"  ⏭️ [مجاني][{res_name}] نفدت السحبات المجانية لهذا المورد.")
                    results.append({"resource": res_name, "mode": "free", "skipped": True, "reason": "gold_limit"})

                elif err in ("45004", "7"):  # المورد غير مفتوح لهذا المستوى
                    self.log(f"  ⏭️ [{res_name}] المورد غير مفتوح لمستوى القلعة الحالي.")
                    results.append({"resource": res_name, "mode": "free", "skipped": True, "reason": "not_open"})

                else:
                    self.log(f"  ❌ [{res_name}] كود خطأ غير متوقع: err={err}")
                    results.append({"resource": res_name, "mode": "free", "success": False, "err": err})

            # إذا لم يتمكن من سحب أي مورد في الدورة، نتوقف لمنع التكرار اللانهائي
            if draw_in_cycle == 0:
                break

        self.log(f"✓ اكتملت مرحلة السحب المجاني بالكامل (تم إنجاز {free_collected} سحبة مجانية).")

        # ═════════════════════════════════════════════════════════════════════
        # المرحلة 2: السحب بالذهب (لكل مورد محدد وفق gold_times)
        # ═════════════════════════════════════════════════════════════════════
        if gold_times_per_res > 0:
            current_gold = self.gold
            if current_gold <= 0:
                self.log(f"⚠️ [السحب بالذهب] رصيد الذهب غير كافٍ ({current_gold}) — تخطي مرحلة الذهب.")
            else:
                total_target_draws = len(target_resources) * gold_times_per_res

                # تتبع عدد السحبات الناجحة بالذهب لكل مورد على حدة
                res_gold_counts: Dict[int, int] = {r_id: 0 for r_id, _ in target_resources}
                # قائمة الموارد النشطة التي ما زالت تقبل السحب بالذهب
                active_res = list(target_resources)

                for round_idx in range(1, gold_times_per_res + 1):
                    if not active_res:
                        break

                    round_success_count = 0
                    for res_id, res_name in list(active_res):
                        # التحقق من رصيد الذهب المتوفر
                        if self.gold <= 0:
                            self.log("⚠️ [السحب بالذهب] نفد رصيد الذهب أثناء العملية — إيقاف مرحلة الذهب.")
                            active_res.clear()
                            break

                        r = await self.safe_query("1018", "2", {"resourceType": res_id})
                        if not r:
                            self.log(f"  ⚠️ [ذهب][{res_name}] لا يوجد رد من السيرفر.")
                            continue

                        err = str(r.get("err", "-1"))
                        if err == "0":
                            data = r.get("data", {})
                            added = int(data.get("addResource", 0))
                            mult = data.get("must", 1)
                            res_gold_counts[res_id] += 1
                            gold_collected += 1
                            round_success_count += 1
                            self.log(
                                f"  💰 [ذهب - جولة {round_idx}/{gold_times_per_res}][{res_name}] "
                                f"سحبة ({res_gold_counts[res_id]}/{gold_times_per_res}) | +{added:,} (x{mult})"
                            )
                            results.append({
                                "resource": res_name,
                                "mode": "gold",
                                "success": True,
                                "added": added,
                                "mult": mult,
                                "round": round_idx,
                            })

                        elif err == "45001":
                            self.log(f"  ⏹️ [ذهب][{res_name}] تم استنفاد الحد الأقصى لسحب هذا المورد بالذهب من الخادم.")
                            if (res_id, res_name) in active_res:
                                active_res.remove((res_id, res_name))

                        elif err in ("45004", "7"):
                            self.log(f"  ⏭️ [ذهب][{res_name}] المورد غير مفتوح لمستوى القلعة الحالي.")
                            if (res_id, res_name) in active_res:
                                active_res.remove((res_id, res_name))

                        else:
                            self.log(f"  ❌ [ذهب][{res_name}] كود خطأ: err={err}")
                            if err in ("10001", "2"):  # نقص الذهب
                                self.log("⚠️ [السحب بالذهب] رصيد الذهب غير كافٍ في الخادم.")
                                active_res.clear()
                                break
                            else:
                                if (res_id, res_name) in active_res:
                                    active_res.remove((res_id, res_name))

                    if round_success_count == 0 and not active_res:
                        break

                self.log(f"✓ اكتملت مرحلة السحب بالذهب (تم إنجاز {gold_collected}/{total_target_draws} سحبة إجمالاً).")
        else:
            self.log("ℹ️ السحب بالذهب معطل (gold_times = 0).")

        msg = f"اكتملت مهمة النافورة بنجاح: {free_collected} سحبة مجانية"
        if gold_collected > 0:
            msg += f" + {gold_collected} سحبة بالذهب"

        return TaskResult.ok(
            msg,
            data={
                "free_collected": free_collected,
                "gold_collected": gold_collected,
                "results": results,
            },
        )
