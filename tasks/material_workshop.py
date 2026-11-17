# -*- coding: utf-8 -*-
"""
tasks/material_workshop.py — مهمة معمل المواد التلقائية (Material Workshop Task)
════════════════════════════════════════════════════════════════════════════════
الميزات الرئيسية:
  1. فحص قبلي كامل من الذاكرة الحية (0-Network Pre-flight) عبر متحكم stuffWorkshopCtrl.
  2. استلام المواد المكتملة تلقائياً فور جاهزيتها (doneID > 0).
  3. استغلال الخانات الشاغرة وتوزيع المواد المختارة بالتساوي (Round-Robin).
  4. محاكاة بشرية وفواصل أمان عشوائية بين طلبات التكرير (1.0 - 2.0 ثانية).
  5. عزل تام للأخطاء ومزامنة فورية للذاكرة الحية.
"""

from __future__ import annotations

import asyncio
import random
import time
from typing import Any, Callable, Dict, List, Optional

from tasks.base_task import (
    BaseTask,
    TaskResult,
    MATERIAL_WORKSHOP_CATALOG,
)

# المعرفات الافتراضية للمواد الست من المستوى الأول (أبيض / عادي)
DEFAULT_MATERIAL_IDS: List[int] = [
    200101,  # عشب المستوى 1
    200201,  # خشب بنفسجي المستوى 1
    200301,  # برونز المستوى 1
    200401,  # ياقوت المستوى 1
    200501,  # فرو المستوى 1
    200601,  # قرن المستوى 1
]


class MaterialWorkshopTask(BaseTask):
    """
    مهمة معمل المواد التلقائية:
    - فحص الذاكرة الحية لاستخراج الخانات الشاغرة والمواد الجاهزة.
    - استلام المواد المنتهية.
    - توزيع وتكرير المواد المحددة على الخانات المفتوحة بعدالة وتوازن.
    """
    name: str = "material_workshop"
    alias: str = "material_workshop"

    def __init__(
        self,
        conn: Any,
        log_func: Optional[Callable[[str], None]] = None,
        config: Optional[Dict[str, Any]] = None,
    ):
        if isinstance(log_func, dict) and config is None:
            config = log_func
            log_func = None
        super().__init__(conn, log_func, config)
        self.name = "material_workshop"

    @property
    def is_active(self) -> bool:
        """التحقق من تفعيل المهمة في الإعدادات."""
        return bool(self.config.get("enabled", False))

    @property
    def selected_materials(self) -> List[int]:
        """قائمة معرفات المواد المحددة للتكرير."""
        raw_mats = self.config.get("selected_materials")
        if not raw_mats or not isinstance(raw_mats, list):
            return list(DEFAULT_MATERIAL_IDS)

        valid_mats: List[int] = []
        for m in raw_mats:
            mid = self._safe_int(m)
            if mid > 0:
                valid_mats.append(mid)

        return valid_mats if valid_mats else list(DEFAULT_MATERIAL_IDS)

    async def can_run(self) -> tuple[bool, str]:
        """فحص الشروط المسبقة لتشغيل مهمة معمل المواد (0-Network)."""
        if not self.is_active:
            return False, "المهمة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        status = self.get_material_workshop_status()
        if not status.get("has_workshop"):
            return False, "معمل المواد غير موجود في بيانات القلعة"

        has_finished = status.get("has_finished_material", False)
        has_vacant = status.get("has_vacant_slot", False)

        if not has_finished and not has_vacant:
            return False, (
                f"المعمل ممتلئ ({status.get('currently_producing_count')}/{status.get('total_unlocked_slots')}) "
                f"ولا توجد مواد جاهزة للاستلام"
            )

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة معمل المواد:
        1. فحص حالة المعمل من الذاكرة الحية (0-Network).
        2. استلام المادة المكتملة إن وجدت.
        3. توزيع وتكرير المواد المختارة على الخانات الشاغرة (Round-Robin).
        """
        status = self.get_material_workshop_status()
        if not status.get("has_workshop"):
            return TaskResult.skip("معمل المواد غير متوفر في هذه القلعة")

        collected_items: List[str] = []
        refined_items: List[str] = []

        # 1. استلام المواد المكتملة أولاً لتفريغ الخانات
        if status.get("has_finished_material"):
            done_id = status.get("done_material_id", 0)
            fin_info = status.get("finished_material") or {}
            mat_name = fin_info.get("name") or f"مادة #{done_id}"
            self.log(f"🏭 [معمل المواد] تم رصد مادة جاهزة للاستلام: '{mat_name}' (ID: {done_id})")

            collect_res = await self.collect_material_workshop_finished()
            if collect_res.get("success"):
                collected_items.append(mat_name)
                # فاصل زمني أمان بشري بعد الاستلام وقبل التكرير
                await asyncio.sleep(random.uniform(0.8, 1.5))
                # إعادة قراءة حالة المعمل من الذاكرة الحية المحدثة
                status = self.get_material_workshop_status()
            else:
                self.log(f"⚠️ [معمل المواد] فشل استلام المادة المكتملة: {collect_res.get('message')}")

        # 2. فحص الخانات الشاغرة وبدء تكرير المواد
        vacant_slots = status.get("vacant_slots_count", 0)
        if vacant_slots > 0 and status.get("has_vacant_slot"):
            target_materials = self.selected_materials
            self.log(
                f"🏭 [معمل المواد] يتوفر {vacant_slots} خانة شاغرة. "
                f"جاري توزيع المواد المختارة ({len(target_materials)} مادة) بالتساوي..."
            )

            # احتساب عدد المواد الجاري تصنيعها حالياً لتحقيق توازن عادل تام
            current_counts: Dict[int, int] = {mid: 0 for mid in target_materials}
            for m in status.get("materials_in_process", []):
                mid = m.get("material_id")
                if mid in current_counts:
                    current_counts[mid] += 1

            # اختيار المواد للخانات الشاغرة بنمط Round-Robin متوازن
            materials_to_refine: List[int] = []
            for _ in range(vacant_slots):
                # اختيار المادة الأقل إنتاجاً حالياً لتحقيق التوازن، مع الحفاظ على الترتيب الأصلي عند التساوي
                chosen_mid = min(target_materials, key=lambda mid: current_counts[mid])
                materials_to_refine.append(chosen_mid)
                current_counts[chosen_mid] += 1

            # تنفيذ طلبات التكرير
            for idx, mat_id in enumerate(materials_to_refine):
                mat_meta = MATERIAL_WORKSHOP_CATALOG.get(mat_id) or self.resolve_material_info(mat_id)
                mat_name = mat_meta.get("name", f"مادة #{mat_id}")

                refine_res = await self.refine_material_workshop(mat_id)
                if refine_res.get("success"):
                    refined_items.append(mat_name)
                    # فاصل بشري عشوائي بين طلبات التكرير المتتالية
                    if idx < len(materials_to_refine) - 1:
                        delay = round(random.uniform(1.0, 2.0), 2)
                        await asyncio.sleep(delay)
                else:
                    err_code = refine_res.get("code")
                    err_msg = refine_res.get("message")
                    self.log(f"⚠️ [معمل المواد] تعذر تكرير '{mat_name}': {err_msg}")
                    # إذا امتلات الخانات بالسيرفر، نكتفي بما تم
                    if err_code == "NO_VACANT_SLOTS":
                        break

        # 3. صياغة تقرير النتيجة
        if not collected_items and not refined_items:
            return TaskResult.skip("لم يتم تنفيذ أي إجراء في معمل المواد (لا توجد خانات شاغرة أو مواد جاهزة)")

        parts = []
        if collected_items:
            parts.append(f"استلام ({len(collected_items)}): {', '.join(collected_items)}")
        if refined_items:
            parts.append(f"بدء تكرير ({len(refined_items)}): {', '.join(refined_items)}")

        summary_msg = f"معمل المواد: {' | '.join(parts)}"
        self.log(f"✅ [معمل المواد] {summary_msg}")

        return TaskResult.ok(
            msg=summary_msg,
            data={
                "collected": collected_items,
                "refined": refined_items,
                "vacant_slots_remaining": max(0, vacant_slots - len(refined_items)),
            },
        )
