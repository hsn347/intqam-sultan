# -*- coding: utf-8 -*-
"""
tasks/watermill.py — مهمة تفعيل دعم ومضاعفة إنتاج الحقول والمناجم (Watermill / Resource Boost Task)
═════════════════════════════════════════════════════════════════════════════════════════════════
تقوم بفحص حقول ومناجم الموارد في القلعة (قمح، خشب، حديد، فضة، بلور) وتفعيل حزم الدعم
المتوفرة مجاناً في الحقيبة على الحقول غير المدعومة بالترتيب من الأعلى مستوى إلى الأدنى.

الميزات والضوابط:
1. فحص قبلي في الذاكرة (0-Network Pre-flight) بصفر طلبات شبكية عند عدم الحاجة أو غياب الحزم.
2. استخدام حزم الدعم المجانية فقط المتوفرة بالحقيبة والتخطي عند نفادها (حظر استهلاك الذهب تماماً).
3. ترتيب الحقول غير المدعومة تنازلياً حسب المستوى لدعم الحقول الأكثر إنتاجاً أولاً.
4. تحديث الذاكرة الحية فورياً (الحقيبة والبافات) لمنع أي تكرار أو استعلام زائد.
5. محاكاة السلوك البشري بفواصل زمنية آمنة (0.8 - 1.4 ثانية) بين الطلبات لحماية الحسابات من الحظر.
"""

from __future__ import annotations

import time
from typing import Any, Dict, List, Optional, Set, Tuple

from tasks.base_task import BaseTask, TaskResult, RESOURCE_BOOST_KEY_MAP, RESOURCE_BOOST_CATALOG, RESOURCE_BUILDING_METADATA


class WatermillTask(BaseTask):
    """مهمة تفعيل دعم إنتاج المزارع والمناجم بالقلعة بصفر طلبات شبكية زائدة."""

    name = "watermill"

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في إعدادات القلعة."""
        return bool(self.config.get("enabled", False))

    def _get_target_resources(self) -> Set[str]:
        """استخراج وتطبيع قائمة الموارد المحددة للتفعيل من الإعدادات."""
        raw_resources = self.config.get("resources")
        if not raw_resources or not isinstance(raw_resources, list):
            # القيمة الافتراضية: دعم الموارد الخمسة
            return {"wheat", "wood", "iron", "silver", "crystal"}

        normalized: Set[str] = set()
        for r in raw_resources:
            r_str = str(r).strip()
            norm = RESOURCE_BOOST_KEY_MAP.get(r_str) or RESOURCE_BOOST_KEY_MAP.get(r_str.lower())
            if norm and norm in RESOURCE_BOOST_CATALOG:
                normalized.add(norm)

        return normalized

    def _deduct_backpack_item(self, item_id: int | str, count: int = 1) -> None:
        """تحديث رصيد الحقيبة محلياً في الذاكرة الحية فور نجاح الاستخدام لمنع أي تكرار."""
        for ctrl_name in ("backpackCtrl", "bagCtrl"):
            backpack = self.get_ctrl(ctrl_name)
            if not isinstance(backpack, dict):
                continue
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

    def _register_buff_in_memory(self, bid: int, iid: int, buff_id: int, item_id: int, duration_sec: int = 86400) -> None:
        """تسجيل الباف فورياً في الذاكرة الحية لتجنب أي محاولة دعم مكررة لنفس الحقل بالدورة."""
        now_ts = int(time.time())
        end_ts = now_ts + duration_sec

        for ctrl_name in ("buffCtrl", "newBuffCtrl"):
            ctrl = self.get_ctrl(ctrl_name)
            if isinstance(ctrl, list):
                ctrl.append({
                    "buffId": buff_id,
                    "id": buff_id,
                    "itemId": item_id,
                    "beginTime": now_ts,
                    "time": duration_sec,
                    "duration": duration_sec,
                    "endTime": end_ts,
                    "finishTime": end_ts,
                    "bid": bid,
                    "iid": iid,
                    "extra": f"bid_{bid}_iid_{iid}",
                })
            elif isinstance(ctrl, dict):
                key = f"buff_{buff_id}_{bid}_{iid}"
                ctrl[key] = {
                    "buffId": buff_id,
                    "id": buff_id,
                    "itemId": item_id,
                    "beginTime": now_ts,
                    "time": duration_sec,
                    "duration": duration_sec,
                    "endTime": end_ts,
                    "finishTime": end_ts,
                    "bid": bid,
                    "iid": iid,
                    "extra": f"bid_{bid}_iid_{iid}",
                }

    async def can_run(self) -> Tuple[bool, str]:
        """فحص قبلي سريع (0-Network Pre-flight): التحقق من الشروط في الذاكرة قبل ملامسة السيرفر."""
        if not self.is_active:
            return False, "المهمة معطلة في الإعدادات"

        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        target_resources = self._get_target_resources()
        if not target_resources:
            return False, "لم يتم تحديد أي نوع مورد لدعمه في الإعدادات"

        # 1. فحص توفر حزم الدعم المجانية في الحقيبة في الذاكرة الحية (0 طلبات شبكية)
        speedups = self.get_resource_boost_speedups()
        details = speedups.get("details", {}) if isinstance(speedups, dict) else {}

        has_available_items = False
        for r_key in target_resources:
            cnt = int(details.get(r_key, {}).get("count", 0))
            if cnt > 0:
                has_available_items = True
                break

        if not has_available_items:
            return False, "لا توجد أي حزم دعم متوفرة بالحقيبة للموارد المحددة"

        # 2. فحص وجود حقول غير مدعومة للموارد المحددة في الذاكرة الحية (0 طلبات شبكية)
        status = self.get_resource_buildings_boost_status()
        unboosted = status.get("unboosted_fields", []) if isinstance(status, dict) else []

        # ترشيح الحقول التابعة للموارد المحددة والمتاحة حالياً (state == 0 / طبيعي)
        target_unboosted = [
            f for f in unboosted
            if f.get("resource") in target_resources and int(f.get("state", 0)) == 0
        ]

        if not target_unboosted:
            return False, "كافة الحقول والمناجم للموارد المحددة مفعل عليها الدعم بالفعل"

        return True, ""

    async def run(self) -> TaskResult:
        """تنفيذ تفعيل حزم الدعم على الحقول غير المدعومة بالترتيب من الأعلى مستوى للأدنى."""
        target_resources = self._get_target_resources()
        if not target_resources:
            return TaskResult.skip("لم يتم تحديد أي نوع مورد للدعم")

        # 1. جلب حزم الدعم المتوفرة بالحقيبة
        speedups = self.get_resource_boost_speedups()
        details = speedups.get("details", {}) if isinstance(speedups, dict) else {}

        # 2. جلب حالة الحقول والمناجم الحالية
        status = self.get_resource_buildings_boost_status()
        unboosted_all = status.get("unboosted_fields", []) if isinstance(status, dict) else []

        # 3. تنظيم الحقول حسب نوع المورد وترتيبها تنازلياً حسب المستوى
        fields_by_res: Dict[str, List[Dict[str, Any]]] = {}
        for f in unboosted_all:
            r = f.get("resource")
            if r in target_resources and int(f.get("state", 0)) == 0:
                fields_by_res.setdefault(r, []).append(f)

        total_boosted = 0
        skipped_resources: List[str] = []

        # 4. التكرار على كل نوع مورد وتطبيق الحزم
        for r_key in sorted(target_resources):
            fields_for_res = fields_by_res.get(r_key, [])
            if not fields_for_res:
                continue

            # ترتيب الحقول تنازلياً حسب المستوى ثم حسب iid
            fields_for_res.sort(key=lambda x: (-int(x.get("level", 0)), int(x.get("iid", 0))))

            item_info = details.get(r_key, {})
            item_id = int(item_info.get("item_id", 0) or RESOURCE_BOOST_CATALOG[r_key]["item_id"])
            item_count = int(item_info.get("count", 0))
            item_name = item_info.get("name") or RESOURCE_BOOST_CATALOG[r_key]["name_ar"]
            res_plural = RESOURCE_BUILDING_METADATA.get(RESOURCE_BOOST_CATALOG[r_key]["building_id"], {}).get("plural_ar", r_key)

            if item_count <= 0:
                self.log(f"[Watermill] ⏭️ تخطي {res_plural}: لا تتوفر حزم {item_name} بالحقيبة.")
                skipped_resources.append(r_key)
                continue

            self.log(f"[Watermill] 📦 بدء دعم {res_plural} (المتوفر: {item_count} حزمة، الحقول غير المدعومة: {len(fields_for_res)})...")

            for field in fields_for_res:
                if item_count <= 0:
                    self.log(f"[Watermill] ⏹️ نفدت حزم {item_name} بالحقيبة، توقف دعم باقي {res_plural}.")
                    break

                bid = int(field.get("bid", 0))
                iid = int(field.get("iid", 0))
                lv = int(field.get("level", 0))
                type_name = field.get("type_name", "حقل")
                buff_id = int(field.get("boost_buff_id", 0) or RESOURCE_BUILDING_METADATA.get(bid, {}).get("boost_buff_id", 0))

                # إرسال طلب تفعيل الدعم الرسمي (CMD 1001 / REQ 9 / mode: 1 / toolid)
                # mode 1 = استخدام أداة من الحقيبة (BUILD_EXCHANGE_MODE.TOOLS)
                payload = {
                    "bid": bid,
                    "iid": iid,
                    "mode": 1,
                    "toolid": item_id,
                }

                resp = await self.safe_query("1001", "9", payload, min_delay=0.8, max_delay=1.4)
                err = resp.get("err") if isinstance(resp, dict) else -1

                if err == 0 or err == "0":
                    item_count -= 1
                    total_boosted += 1

                    # تحديث رصيد الحقيبة والبافات محلياً في الذاكرة الحية
                    self._deduct_backpack_item(item_id, 1)
                    self._register_buff_in_memory(bid, iid, buff_id, item_id, 86400)

                    self.log(
                        f"[Watermill] ✅ تم تفعيل {item_name} على {type_name} (مستوى {lv} / خانة {iid}) بنجاح! "
                        f"(المتبقي: {item_count} حزمة)"
                    )
                else:
                    self.log(
                        f"[Watermill] ⚠️ فشل تفعيل {item_name} على {type_name} (مستوى {lv} / خانة {iid}) - كود الخطأ: {err}"
                    )
                    # إذا كان الخطأ يدل على عدم توفر الأداة أو حد أقصى، نتوقف عن هذا المورد
                    if err in (2001, 2004, "2001", "2004"):
                        break

        if total_boosted > 0:
            return TaskResult.ok(f"تم تفعيل دعم {total_boosted} حقل/منجم بنجاح وفق الأولويات.")
        elif skipped_resources:
            return TaskResult.skip(f"لم يتم تفعيل أي حقل لنفاد حزم الدعم في الحقيبة ({', '.join(skipped_resources)}).")
        else:
            return TaskResult.skip("كافة الحقول والمناجم مفعل عليها الدعم بالفعل.")
