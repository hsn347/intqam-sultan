# -*- coding: utf-8 -*-
"""
tasks/material_synthesis.py — مهمة تجميع مواد العتاد بورشة الحدادة (النشاط اليومي)
═══════════════════════════════════════════════════════════════════════════════
البروتوكول الشبكي للعبة:
  - CMD: "1047" (CMD_EQUIPMENT_MODULE)
  - SubCMD: "10" (REQ_MERGE_MATERIAL)
  - Payload: {"mergeMaterialID": toMid, "mergeCount": 1}

الميزات وصمامات الأمان:
  1. فحص النشاط اليومي المسبق في الذاكرة (0-Network Pre-flight):
     التحقق من كائن everydayTaskCtrl.eventInfo لمهمة تجميع المواد (ID: 4100010)؛
     فإذا كانت متممة مسبقاً، يتم التخطي الفوري بأقل من 0.01ms دون لمس السيرفر.
  2. فحص الحقيبة في الذاكرة (0-Network):
     البحث عن مواد العتاد المتاحة التي يتوفر منها 4 قطع على الأقل، مع إعطاء
     الأولوية القصوى للمواد الأولية الشائعة (الرتبة البيضاء الأولى) لحماية المواد النادرة.
  3. تنفيذ تجميع دفعة واحدة فقط (mergeCount = 1) لإتمام مهمة النشاط اليومي بنجاح
     مع المحافظة التامة على رصيد المواد ومخزون القلعة وصفر استهلاك للذهب.
  4. تحديث الذاكرة الحية فورياً فور نجاح الطلب (In-Memory State Sync).
"""

from __future__ import annotations

import time
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# ثوابت نظام العتاد والنشاط اليومي في لعبة انتقام السلاطين
CMD_EQUIPMENT_MODULE = "1047"
REQ_MERGE_MATERIAL = "10"

# معرّفات مهمة تجميع المواد في جدول النشاط اليومي الرسمي (daily_reward_point_config.lua)
DAILY_QUEST_MATERIAL_ID = "4100010"
DAILY_QUEST_MATERIAL_TYPE = "10"

# صيغ تجميع المواد الأساسية مرتبة حسب الأولوية التصاعدية (من الرتبة الأدنى والأرخص للأعلى)
# كل عملية دمج تتطلب 4 قطع من spend_id لإنتاج قطعة واحدة من result_id
# مأخوذة مباشرة من جدول اللعبة الرسمي equipment_material_formula.lua
MATERIAL_SYNTHESIS_PAIRS: List[Tuple[int, int]] = [
    # الرتبة 1 (أبيض -> أخضر) - الأولوية القصوى لأنها المواد الأوفر والأرخص
    (200101, 200102),  # حديد / معدن
    (200201, 200202),  # فراء / جلود
    (200301, 200302),  # عظم / ناب / عنبر
    (200401, 200402),  # فحم / حجر
    (200501, 200502),  # خشب / قماش
    (200601, 200602),  # ريش / بلور
    (200701, 200702),
    (200801, 200802),
    (200901, 200902),
    (201001, 201002),
    (201101, 201102),
    (201201, 201202),
    (201301, 201302),
    (201401, 201402),
    # الرتبة 2 (أخضر -> أزرق) - في حال عدم توفر مواد رتبة 1
    (200102, 200103),
    (200202, 200203),
    (200302, 200303),
    (200402, 200403),
    (200502, 200503),
    (200602, 200603),
    (200702, 200703),
    (200802, 200803),
    (200902, 200903),
    (201002, 201003),
    (201102, 201103),
    (201202, 201203),
    (201302, 201303),
    (201402, 201403),
    # الرتبة 3 (أزرق -> بنفسجي) - كحل بديل أخير
    (200103, 200104),
    (200203, 200204),
    (200303, 200304),
    (200403, 200404),
    (200503, 200504),
    (200603, 200604),
]


class MaterialSynthesisTask(BaseTask):
    """
    مهمة تجميع مواد العتاد بورشة الحدادة مرة واحدة لإتمام النشاط اليومي.
    """
    name: str = "material_synthesis"

    def _is_daily_quest_completed(self) -> bool:
        """
        التحقق في الذاكرة الحية (0-Network) هل مهمة تجميع المواد متممة مسبقاً اليوم.
        تقرأ من كائن everydayTaskCtrl.eventInfo المشحون مسبقاً.
        """
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if not isinstance(everyday_ctrl, dict):
            return False

        event_info = everyday_ctrl.get("eventInfo")
        if not isinstance(event_info, dict):
            return False

        # فحص المعرف الكامل 4100010 أو النوع 10
        count_id = int(event_info.get(DAILY_QUEST_MATERIAL_ID, 0) or 0)
        count_type = int(event_info.get(DAILY_QUEST_MATERIAL_TYPE, 0) or 0)

        return (count_id >= 1 or count_type >= 1)

    def _get_item_count(self, item_id: int) -> int:
        """
        قراءة رصيد عنصر معين في الحقيبة مباشرة من الذاكرة الحية (0-Network).
        """
        backpack_ctrl = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack_ctrl, dict):
            return 0

        # 1. مطابقة مباشرة بالمفتاح
        str_id = str(item_id)
        if str_id in backpack_ctrl:
            entry = backpack_ctrl[str_id]
            if isinstance(entry, dict):
                return int(entry.get("count", entry.get("num", 0)) or 0)
            elif isinstance(entry, (int, float)):
                return int(entry)

        # 2. فحص itemList أو items إذا كانت مفهرسة
        raw_items = backpack_ctrl.get("itemList", backpack_ctrl.get("items", {}))
        if isinstance(raw_items, dict):
            if str_id in raw_items:
                v = raw_items[str_id]
                if isinstance(v, dict):
                    return int(v.get("count", v.get("num", 0)) or 0)
                elif isinstance(v, (int, float)):
                    return int(v)
            for k, v in raw_items.items():
                if isinstance(v, dict):
                    iid = int(v.get("id", v.get("itemID", k if str(k).isdigit() else 0)) or 0)
                    if iid == item_id:
                        return int(v.get("count", v.get("num", 0)) or 0)

        return 0

    def _find_synthesis_candidate(self) -> Optional[Tuple[int, int, int]]:
        """
        البحث في الذاكرة (0-Network) عن أفضل مادة متوفر منها 4 قطع على الأقل للدمج.
        يعيد (spend_id, result_id, available_count) أو None.
        """
        for spend_id, result_id in MATERIAL_SYNTHESIS_PAIRS:
            count = self._get_item_count(spend_id)
            if count >= 4:
                return spend_id, result_id, count
        return None

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي فائق السرعة في الذاكرة الحية (0-Network Pre-flight):
        - هل المهمة مفعلة بالواجهة وفق رغبة المستخدم؟
        - هل الاتصال نشط بالبوابة؟
        - هل مهمة تجميع المواد متممة مسبقاً في النشاط اليومي؟
        - هل تتوفر مواد كافية (4 قطع على الأقل) في الحقيبة؟
        """
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة وفق رغبة المستخدم"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        # 1. فحص إتمام المهمة في النشاط اليومي (0-Network)
        if self._is_daily_quest_completed():
            return False, "مهمة تجميع المواد متممة مسبقاً في النشاط اليومي"

        # 2. فحص توفر مواد كافية في الحقيبة (0-Network)
        candidate = self._find_synthesis_candidate()
        if not candidate:
            return False, "لا توجد مواد عتاد كافية في الحقيبة (يلزم 4 قطع على الأقل) لإتمام التجميع"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ عملية تجميع مواد العتاد بورشة الحدادة مرة واحدة (0 ذهب).
        """
        candidate = self._find_synthesis_candidate()
        if not candidate:
            return TaskResult.skip("لا توجد مواد عتاد كافية في الحقيبة (يلزم 4 قطع على الأقل)")

        spend_id, result_id, available_count = candidate

        # بناء حزمة الطلب الرسمية المطابقة للعميل الرسمي 100%
        payload = {
            "mergeMaterialID": result_id,
            "mergeCount": 1,  # دفعة واحدة فقط لإنجاز النشاط اليومي
        }

        self.log(f"⚒️ بدء تجميع مادة العتاد #{spend_id} -> #{result_id} (المتوفر: {available_count} قطع)")

        res = await self.safe_query(
            CMD_EQUIPMENT_MODULE,
            REQ_MERGE_MATERIAL,
            payload,
            min_delay=0.8,
            max_delay=1.5,
        )

        if not res or not isinstance(res, dict):
            return TaskResult.retry("انقطاع أو عدم استجابة السيرفر أثناء تجميع المواد")

        err_code = str(res.get("err", "-1"))
        if err_code != "0":
            return TaskResult.retry(f"رفض السيرفر طلب تجميع المواد (كود الخطأ: {err_code})")

        # ═════════════════════════════════════════════════════════════════════
        # تحديث الذاكرة الحية محلياً فور النجاح (In-Memory State Sync)
        # ═════════════════════════════════════════════════════════════════════
        # 1. تحديث عداد النشاط اليومي لمنع أي طلب لاحق في نفس اليوم
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.setdefault("eventInfo", {})
            if isinstance(event_info, dict):
                event_info[DAILY_QUEST_MATERIAL_ID] = 1
                event_info[DAILY_QUEST_MATERIAL_TYPE] = 1

        # 2. تحديث رصيد المواد في الذاكرة الحية (خصم 4 وإضافة 1)
        backpack_ctrl = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if isinstance(backpack_ctrl, dict):
            # خصم المادة المستهلكة
            str_spend = str(spend_id)
            if str_spend in backpack_ctrl and isinstance(backpack_ctrl[str_spend], dict):
                old_c = int(backpack_ctrl[str_spend].get("count", 0) or 0)
                backpack_ctrl[str_spend]["count"] = max(0, old_c - 4)

            # إضافة المادة الناتجة
            str_res = str(result_id)
            if str_res in backpack_ctrl and isinstance(backpack_ctrl[str_res], dict):
                old_r = int(backpack_ctrl[str_res].get("count", 0) or 0)
                backpack_ctrl[str_res]["count"] = old_r + 1

        msg = f"✓ تم تجميع مادة العتاد بنجاح (#{spend_id} -> #{result_id}) وإتمام النشاط اليومي"
        self.log(msg)

        return TaskResult.ok(
            msg,
            data={
                "spend_id": spend_id,
                "result_id": result_id,
                "mergeCount": 1,
            },
        )

