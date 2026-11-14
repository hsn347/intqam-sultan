# -*- coding: utf-8 -*-
"""
tasks/city_harvest.py — مهمة حصاد مزارع ومناجم الموارد داخل القلعة (City Harvest Task)
══════════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. استعلام كامل من الذاكرة الحية (0 طلب شبكي قبل التأكد من وجود موارد جاهزة).
  2. جمع المزارع والمناجم كل على حدة وفق متطلبات بروتوكول خادم اللعبة (CMD 1001 / SUBCMD 8).
  3. أمان ومحاكاة بشرية فائقة بفاصل زمني عشوائي من 0.4 إلى 0.6 ثانية بين كل جمع وآخر.
  4. تصفير رصيد المبنى محلياً في الذاكرة الحية فور نجاح جمعه لمنع أي تكرار غير مفيد.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Dict, List, Tuple
from tasks.base_task import BaseTask, TaskResult

# أنواع مباني الموارد المعرفة في بروتوكول اللعبة (buildDef.lua)
RESOURCE_BUILDINGS: Dict[str, Dict[str, str]] = {
    "201": {"name": "مزرعة القمح", "res": "القمح"},
    "202": {"name": "منشرة الخشب", "res": "الخشب"},
    "203": {"name": "منجم الحديد", "res": "الحديد"},
    "204": {"name": "منجم الفضة", "res": "الفضة"},
    "207": {"name": "منجم البلور", "res": "البلور"},
}


class CityHarvestTask(BaseTask):
    """مهمة حصاد كافة المزارع والمناجم المنتجة للموارد داخل القلعة."""
    name = "city_harvest"
    alias = "harvest"

    def _get_harvestable_buildings(self) -> List[Dict[str, Any]]:
        """
        استخراج قائمة المباني التي تحتوي على موارد جاهزة للحصاد
        مباشرة من الذاكرة الحية بصفر طلبات شبكية.
        """
        city_ctrl = self.get_ctrl("cityCtrl")
        if not city_ctrl or not isinstance(city_ctrl, dict):
            return []

        blist = city_ctrl.get("blist", [])
        if not isinstance(blist, list):
            return []

        harvestable: List[Dict[str, Any]] = []
        for b in blist:
            if not isinstance(b, dict):
                continue
            binfo = b.get("binfo", b) if isinstance(b.get("binfo"), dict) else b
            bid_str = str(binfo.get("bid", ""))
            if bid_str not in RESOURCE_BUILDINGS:
                continue

            try:
                curres = float(binfo.get("curres", 0) or 0)
            except (ValueError, TypeError):
                curres = 0.0

            # جمع أي مبنى لديه إنتاج جاهز أكبر من الصفر
            if curres > 0:
                try:
                    iid = int(binfo.get("iid", 0) or 0)
                except (ValueError, TypeError):
                    iid = 0
                try:
                    bid = int(bid_str)
                except (ValueError, TypeError):
                    bid = 0
                index = str(binfo.get("index", ""))
                lv = int(binfo.get("lv", 1) or 1)
                info_def = RESOURCE_BUILDINGS[bid_str]
                harvestable.append({
                    "bid": bid,
                    "iid": iid,
                    "index": index,
                    "lv": lv,
                    "curres": curres,
                    "name": info_def["name"],
                    "res": info_def["res"],
                    "binfo": binfo,
                })

        return harvestable

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص مسبق صارم وسريع من الذاكرة الحية:
        إذا لم تكن هناك موارد منتجة جاهزة، يتم التخطي فوراً بصفر طلبات شبكية.
        """
        ok, reason = await super().can_run()
        if not ok:
            return False, reason

        city_ctrl = self.get_ctrl("cityCtrl")
        if not city_ctrl:
            return False, "بيانات المدينة (cityCtrl) غير متوفرة في الذاكرة الحية"

        harvestable = self._get_harvestable_buildings()
        if not harvestable:
            return False, "لا توجد موارد منتجة جاهزة للحصاد في مزارع القلعة حالياً"

        return True, ""

    async def run(self) -> TaskResult:
        harvestable = self._get_harvestable_buildings()
        if not harvestable:
            return TaskResult.skip("لا توجد مزارع جاهزة للحصاد في الذاكرة الحية")

        total_buildings = len(harvestable)
        self.log(f"🌾 تم اكتشاف {total_buildings} مبنى موارد جاهز للحصاد، جاري الجمع بأمان زمني عالي...")

        collected_count = 0
        failed_count = 0
        collected_totals: Dict[str, float] = {}

        for idx, b in enumerate(harvestable, 1):
            bid = b["bid"]
            iid = b["iid"]
            b_name = b["name"]
            res_name = b["res"]
            curres_val = b["curres"]

            # تطبيق الفاصل الزمني البشري الآمن محلياً داخل البوت (من 0.4 إلى 0.6 ثانية)
            await asyncio.sleep(random.uniform(0.4, 0.6))

            # إرسال حزمة اللعبة الأصلية الصافية فقط دون أي زيادات وبأنواع عددية مطابقة لبروتوكول السيرفر:
            # CMD 1001 (CMD_CITY_MODULE) / SUBCMD 8 (REQ_COLLECT_RES)
            r = await self.conn.query(
                cmd="1001",
                subcmd="8",
                data={"bid": int(bid), "iid": int(iid)},
            )

            if r and str(r.get("err", "-1")) == "0":
                # تصفير رصيد المبنى فوراً في الذاكرة الحية لمنع الجمع المكرر
                b["binfo"]["curres"] = "0"
                b["binfo"]["lastCalcuTime"] = int(time.time())

                collected_count += 1
                collected_totals[res_name] = collected_totals.get(res_name, 0.0) + curres_val
                self.log(f"💖💖{collected_totals[res_name]}")
                # تحديث رصيد الموارد العام إن ورد في استجابة الخادم
                rsp_data = r.get("data") if isinstance(r.get("data"), dict) else {}
                if "resList" in rsp_data:
                    city_ctrl = self.get_ctrl("cityCtrl")
                    if isinstance(city_ctrl, dict):
                        city_ctrl["reslist"] = rsp_data["resList"]
            else:
                err_code = r.get("err") if r else "no_response"
                err_msg = r.get("msg") if r else "لا يوجد رد من الخادم"
                failed_count += 1
                self.log(f"⚠️ تعذر حصاد {b_name} (iid={iid}): {err_msg} (رمز: {err_code})")

        # صياغة التقرير الإجمالي
        if collected_count == 0:
            return TaskResult.fail(f"فشل حصاد مباني الموارد بالكامل ({failed_count} محاولات)")

        res_breakdown = " | ".join(
            f"{res}: +{int(val):,}" for res, val in collected_totals.items() if val > 0
        )
        summary_msg = f"تم حصاد {collected_count}/{total_buildings} مبنى موارد بنجاح"
        if res_breakdown:
            summary_msg += f" ({res_breakdown})"

        self.log(f"🎉 {summary_msg}")
        return TaskResult.ok(
            summary_msg,
            data={
                "collected_count": collected_count,
                "total_targets": total_buildings,
                "totals": collected_totals,
            },
        )

