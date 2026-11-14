# -*- coding: utf-8 -*-
"""
tasks/forge_equipment.py — مهمة تصنيع العتاد بورشة الحدادة (النشاط اليومي)
═══════════════════════════════════════════════════════════════════════════════
البروتوكول الشبكي الرسمي للعبة (CMD 1047 - CMD_EQUIPMENT_MODULE):
  - REQ_FORGE_EQUIPMENT = "1":
      Payload: {"eid": int, "materialArray": List[int], "mainMaterialID": int}
  - REQ_GET_EQUIPMENT   = "2":
      Payload: {"epid": int}

الميزات وصمامات الأمان:
  1. فحص النشاط اليومي المسبق في الذاكرة (0-Network Pre-flight):
     التحقق من كائن everydayTaskCtrl.eventInfo لمهمة تصنيع العتاد (ID: 4100009 / Type: 9)
     وقائمة questCtrl.point_finish_list؛ فإذا كانت متممة مسبقاً، يتم التخطي الفوري
     بأقل من 0.01ms دون لمس السيرفر نهائياً.
  2. فحص ورشة الحدادة واستلام القطعة الجاهزة (0-Network):
     - إذا وُجدت قطعة انتهى تصنيعها (endTime > 0 and endTime <= now):
       يتم إرسال أمر الاستلام الرسمي (CMD 1047 / SubCMD 2) لإتمام النشاط اليومي فوراً
       بصفر استهلاك للمواد والصلب!
     - إذا وُجدت قطعة قيد التصنيع حالياً (endTime > now):
       يتم التخطي الفوري (Blacksmith is busy forging) دون إرسال أي طلب شبكي.
  3. خوارزمية تصنيع أعلى مستوى ممكن (Highest Possible Tier Forge):
     - دعم كامل للأصناف الستة: السلاح (weapon: 61)، الثوب (clothes: 62)،
       الخوذة (helmet: 63)، البنطلون (trousers: 64)، الحذاء (shoes: 65)، الخاتم (ring: 66).
     - فحص الوصفات تنازلياً من Lv.110 وحتى Lv.1 مع التحقق من:
       أ) مستوى ورشة الحدادة والقلعة.
       ب) توفر قطعة أساسية غير ملبوسة بالحقيبة (wear == 0 and endTime == 0) للمستويات >= 5.
       ج) توفر المواد بالحقيبة بأولوية الجودة الأدنى (أبيض -> أخضر -> أزرق) لحماية المواد النادرة.
       د) رصيد الصلب (1006) وتوفير العجز من الصناديق عبر ensure_resources.
     - تدرج تلقائي حتى المستوى 1 المضمون بنسبة 100% (يتطلب 100 صلب ومادتين فقط وبدون قطعة سابقة).
  4. تحديث الذاكرة الحية محلياً فور النجاح (In-Memory Live State Sync).
"""

from __future__ import annotations

import math
import time
from typing import Any, Dict, List, Optional, Tuple

from tasks.base_task import BaseTask, TaskResult

# ثوابت بروتوكول وحدة العتاد والنشاط اليومي (من constdef/cmdDef.lua)
CMD_EQUIPMENT_MODULE = "1047"
REQ_FORGE_EQUIPMENT = "1"
REQ_GET_EQUIPMENT = "2"

# معرّفات مهمة تصنيع العتاد في النشاط اليومي الرسمي (daily_reward_point_config.lua)
DAILY_QUEST_FORGE_ID = "4100009"
DAILY_QUEST_FORGE_TYPE = "9"

# معرّف مورد الصلب في مخازن القلعة (cityCtrl.reslist)
RES_STEEL_ID = "1006"

# خريطة بادئات الأصناف الستة للعتاد
CATEGORY_PREFIX_MAP: Dict[str, int] = {
    "weapon": 61,
    "clothes": 62,
    "helmet": 63,
    "trousers": 64,
    "shoes": 65,
    "ring": 66,
}

# أسماء الأصناف بالعربية والإنجليزية للتوثيق والسجلات
CATEGORY_NAMES: Dict[str, str] = {
    "weapon": "السلاح (Weapon)",
    "clothes": "الثوب / الدرع (Clothes)",
    "helmet": "الخوذة (Helmet)",
    "trousers": "البنطلون (Trousers)",
    "shoes": "الحذاء (Shoes)",
    "ring": "الخاتم / الملحقات (Ring)",
}

# عائلات المواد الأساسية (A, B) لكل صنف من الأصناف الستة
# مأخوذة مباشرة من جدول اللعبة الرسمي forge_equipment_config.lua
CATEGORY_MATERIAL_PAIRS: Dict[int, Tuple[int, int]] = {
    61: (2006, 2003),  # سلاح: ريش/بلور (2006) + عنبر/عظم (2003)
    62: (2005, 2001),  # ثوب: خشب/قماش (2005) + حديد/معدن (2001)
    63: (2002, 2001),  # خوذة: فراء/جلود (2002) + حديد/معدن (2001)
    64: (2005, 2003),  # بنطلون: خشب/قماش (2005) + عنبر/عظم (2003)
    65: (2002, 2004),  # حذاء: فراء/جلود (2002) + فحم/حجر (2004)
    66: (2004, 2006),  # خاتم: فحم/حجر (2004) + ريش/بلور (2006)
}

# مستويات وصفات العتاد الرسمية مرتبة تنازلياً من الأعلى إلى الأدنى
EQUIPMENT_LEVELS_DESC: List[int] = [
    110, 105, 100, 95, 90, 85, 80, 75, 70, 65,
    60, 55, 50, 45, 40, 35, 30, 25, 20, 15, 10, 5, 1
]

# تكلفة الصلب ووقت التصنيع الافتراضي لكل مستوى (من forge_equipment_config.lua)
LEVEL_SPECS: Dict[int, Dict[str, int]] = {
    1:   {"steel": 100,     "costTime": 360},
    5:   {"steel": 1000,    "costTime": 360},
    10:  {"steel": 2500,    "costTime": 360},
    15:  {"steel": 5000,    "costTime": 360},
    20:  {"steel": 10000,   "costTime": 360},
    25:  {"steel": 20000,   "costTime": 360},
    30:  {"steel": 40000,   "costTime": 360},
    35:  {"steel": 80000,   "costTime": 360},
    40:  {"steel": 150000,  "costTime": 360},
    45:  {"steel": 200000,  "costTime": 360},
    50:  {"steel": 300000,  "costTime": 360},
    55:  {"steel": 450000,  "costTime": 360},
    60:  {"steel": 650000,  "costTime": 360},
    65:  {"steel": 900000,  "costTime": 360},
    70:  {"steel": 1200000, "costTime": 360},
    75:  {"steel": 1600000, "costTime": 360},
    80:  {"steel": 2200000, "costTime": 360},
    85:  {"steel": 3470000, "costTime": 360},
    90:  {"steel": 3675000, "costTime": 360},
    95:  {"steel": 4200000, "costTime": 360},
    100: {"steel": 4800000, "costTime": 360},
    105: {"steel": 5400000, "costTime": 360},
    110: {"steel": 5940000, "costTime": 360},
}

# صناديق الصلب الرسمية بالحقيبة مرتبة تنازلياً حسب القيمة
STEEL_BOX_CATALOG: List[Tuple[int, int]] = [
    (100405, 5000),  # صندوق صلب 5,000
    (100404, 1000),  # صندوق صلب 1,000
    (100403, 500),   # صندوق صلب 500
    (100402, 100),   # صندوق صلب 100
    (100401, 10),    # صندوق صلب 10
]


class ForgeEquipmentTask(BaseTask):
    """
    مهمة تصنيع قطعة عتاد بورشة الحدادة مرة واحدة يومياً لإنجاز النشاط اليومي.
    """
    name: str = "forge_equipment"

    # ═════════════════════════════════════════════════════════════════════════
    # 1. دوال فحص الذاكرة الحية (0-Network Pre-flight Helpers)
    # ═════════════════════════════════════════════════════════════════════════

    def _is_daily_quest_completed(self) -> bool:
        """
        التحقق في الذاكرة الحية (0-Network) هل مهمة تصنيع العتاد متممة مسبقاً اليوم.
        تفحص كلاً من:
          1. everydayTaskCtrl.eventInfo للمفتاح '4100009' أو النوع '9'.
          2. questCtrl.point_finish_list لمهمة 4100009 إن وُجدت.
        """
        # 1. فحص everydayTaskCtrl
        everyday_ctrl = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday_ctrl, dict):
            event_info = everyday_ctrl.get("eventInfo")
            if isinstance(event_info, dict):
                count_id = int(event_info.get(DAILY_QUEST_FORGE_ID, 0) or 0)
                count_type = int(event_info.get(DAILY_QUEST_FORGE_TYPE, 0) or 0)
                if count_id >= 1 or count_type >= 1:
                    return True

        # 2. فحص questCtrl.point_finish_list
        quest_ctrl = self.get_ctrl("questCtrl")
        if isinstance(quest_ctrl, dict):
            finish_list = quest_ctrl.get("point_finish_list")
            if isinstance(finish_list, list):
                if 4100009 in finish_list or "4100009" in finish_list:
                    return True

        return False

    def _get_blacksmith_info(self) -> Tuple[int, bool, bool]:
        """
        استخراج معلومات ورشة الحدادة من الذاكرة الحية (0-Network):
        ترجع: (blacksmith_level, exists, is_upgrading)
        """
        city_ctrl = self.get_ctrl("cityCtrl")
        if isinstance(city_ctrl, dict):
            blist = city_ctrl.get("blist", [])
            if isinstance(blist, list):
                for b in blist:
                    if isinstance(b, dict):
                        binfo = b.get("binfo", {})
                        if isinstance(binfo, dict) and str(binfo.get("bid")) == "115":
                            try:
                                lv = max(1, int(binfo.get("lv", 1) or 1))
                            except (ValueError, TypeError):
                                lv = 1
                            is_upgrading = str(binfo.get("state", "0")) != "0"
                            return lv, True, is_upgrading
        return 1, False, False

    def _get_blacksmith_level(self) -> int:
        """
        قراءة مستوى مبنى ورشة الحدادة بأمان من الذاكرة الحية cityCtrl.blist (BID 115).
        """
        lv, exists, _ = self._get_blacksmith_info()
        if exists:
            return lv
        return max(1, self.castle_level)

    def _get_item_count_in_bag(self, item_id: int) -> int:
        """
        قراءة رصيد عنصر معين في الحقيبة مباشرة من الذاكرة الحية (0-Network).
        """
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("itemCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            return 0

        str_id = str(item_id)
        # 1. مطابقة مباشرة بالمفتاح
        if str_id in backpack:
            entry = backpack[str_id]
            if isinstance(entry, dict):
                return int(entry.get("count", entry.get("num", 0)) or 0)
            elif isinstance(entry, (int, float)):
                return int(entry)

        if item_id in backpack:
            entry = backpack[item_id]
            if isinstance(entry, dict):
                return int(entry.get("count", entry.get("num", 0)) or 0)
            elif isinstance(entry, (int, float)):
                return int(entry)

        # 2. فحص itemList أو items
        raw_items = backpack.get("itemList", backpack.get("items", {}))
        if isinstance(raw_items, dict):
            if str_id in raw_items:
                entry = raw_items[str_id]
                if isinstance(entry, dict):
                    return int(entry.get("count", entry.get("num", 0)) or 0)
                elif isinstance(entry, (int, float)):
                    return int(entry)
            for k, v in raw_items.items():
                if isinstance(v, dict):
                    iid = int(v.get("id", v.get("itemID", k if str(k).isdigit() else 0)) or 0)
                    if iid == item_id:
                        return int(v.get("count", v.get("num", 0)) or 0)

        return 0

    def _get_current_steel(self) -> int:
        """
        قراءة رصيد الصلب المتاح في مخازن القلعة مباشرة من الذاكرة الحية cityCtrl.reslist.
        """
        city = self.get_ctrl("cityCtrl")
        if not isinstance(city, dict):
            return 0
        reslist = city.get("reslist") or city.get("resList") or {}
        if isinstance(reslist, dict):
            try:
                return int(float(reslist.get(RES_STEEL_ID, 0) or 0))
            except (ValueError, TypeError):
                return 0
        return 0

    # ═════════════════════════════════════════════════════════════════════════
    # 2. خوارزمية توفير الصلب واختيار المواد والقطع الأساسية
    # ═════════════════════════════════════════════════════════════════════════

    async def _ensure_steel_balance(self, needed_steel: int) -> bool:
        """
        التحقق من كفاية الصلب وتوفير أي عجز بفتح صناديق الصلب بالحقيبة (الأكبر أولاً).
        تحديث الذاكرة الحية محلياً فور كل استهلاك.
        """
        current_steel = self._get_current_steel()
        if current_steel >= needed_steel:
            return True

        deficit = needed_steel - current_steel
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("itemCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            return False

        city = self.get_ctrl("cityCtrl")
        reslist = city.get("reslist") or city.get("resList") if isinstance(city, dict) else None

        for box_id, box_val in STEEL_BOX_CATALOG:
            if deficit <= 0:
                break

            avail = self._get_item_count_in_bag(box_id)
            if avail <= 0:
                continue

            needed_boxes = math.ceil(deficit / box_val)
            use_count = min(avail, needed_boxes)
            if use_count <= 0:
                continue

            self.log(f"📦 فتح {use_count}x من صندوق الصلب #{box_id} (قيمة الصندوق: {box_val:,}) لتغطية العجز {deficit:,}...")
            payload = {"itemID": box_id, "count": use_count}
            resp = await self.safe_query("1004", "2", payload)

            if resp is not None:
                gained = use_count * box_val
                current_steel += gained
                deficit = max(0, deficit - gained)

                # تحديث الحقيبة محلياً
                str_box = str(box_id)
                if str_box in backpack and isinstance(backpack[str_box], dict):
                    old_c = int(backpack[str_box].get("count", 0) or 0)
                    backpack[str_box]["count"] = max(0, old_c - use_count)

                # تحديث رصيد الصلب محلياً
                if isinstance(reslist, dict):
                    reslist[RES_STEEL_ID] = current_steel

        return current_steel >= needed_steel

    def _find_base_item_in_bag(self, category_prefix: int, min_lvl: int, max_lvl: int) -> Optional[int]:
        """
        البحث في الحقيبة (0-Network) عن قطعة عتاد سابقة لاستخدامها كقاعدة تطوير للمستويات >= 5.
        الشروط:
          1. القطعة غير ملبوسة: wear == 0.
          2. القطعة مكتملة التصنيع: endTime == 0.
          3. من نفس الصنف: (eid // 100000) == category_prefix.
          4. مستواها يقع ضمن النطاق المطلوب: min_lvl <= lvl <= max_lvl.
        يتم ترتيب القطع المؤهلة تصاعدياً حسب الجودة والمستوى لاستهلاك الأقل قيمة أولاً.
        يعيد epid القطعة أو None.
        """
        eq_ctrl = self.get_ctrl("equipmentCtrl")
        if not isinstance(eq_ctrl, dict):
            return None

        arr = eq_ctrl.get("equipment_array", [])
        if not isinstance(arr, list):
            return None

        candidates = []
        for item in arr:
            if not isinstance(item, dict):
                continue
            wear = int(item.get("wear", 0) or 0)
            end_time = int(item.get("endTime", 0) or 0)
            if wear != 0 or end_time != 0:
                continue

            eid = int(item.get("eid", 0) or 0)
            if (eid // 100000) != category_prefix:
                continue

            item_lvl = (eid % 100000) // 100
            if min_lvl <= item_lvl <= max_lvl:
                epid = int(item.get("epid", 0) or 0)
                qly = int(item.get("qly", 0) or 0)
                slv = int(item.get("slv", 0) or 0)
                # ترتيب حسب الجودة ثم مستوى التعزيز ثم المستوى
                candidates.append((qly, slv, item_lvl, epid))

        if candidates:
            candidates.sort()
            return candidates[0][3]

        return None

    def _select_materials_for_recipe(
        self,
        family_a: int,
        family_b: int,
        level: int,
    ) -> Optional[List[int]]:
        """
        اختيار المواد المطلوبة للوصفة من الحقيبة مع إعطاء الأولوية القصوى
        للجودة الأدنى (أبيض رتبة 1 -> أخضر رتبة 2 -> أزرق رتبة 3) لحماية المواد النادرة.
        يعيد مصفوفة materialArray الجاهزة للطلب الشبكي، أو None إذا كانت المواد غير كافية.
        """
        # تحديد ترتيب عائلات المواد حسب المستوى (مطابق 100% لـ forge_equipment_config.lua)
        if level in (1, 5):
            req_families = [family_a, family_b]
        elif level in (10, 20):
            req_families = [family_a, family_b, family_b]
        elif level == 15:
            req_families = [family_a, family_b, family_a]
        else:  # level >= 25
            req_families = [family_a, family_b, family_a, family_b]

        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("bagCtrl")
        if not isinstance(backpack, dict):
            return None

        temp_usage: Dict[int, int] = {}
        chosen_materials: List[int] = []

        for fam in req_families:
            picked_id = None
            # البحث عن المواد بالجودة الأدنى المتاحة (1=أبيض، 2=أخضر، 3=أزرق، 4=بنفسجي، 5=برتقالي، 6=ذهبي)
            for qly in (1, 2, 3, 4, 5, 6):
                mat_id = fam * 100 + qly
                total_avail = self._get_item_count_in_bag(mat_id)
                used = temp_usage.get(mat_id, 0)
                if total_avail - used > 0:
                    picked_id = mat_id
                    temp_usage[mat_id] = used + 1
                    chosen_materials.append(mat_id)
                    break

            if picked_id is None:
                # مادة ناقصة لا يمكن توفيرها
                return None

        return chosen_materials

    # ═════════════════════════════════════════════════════════════════════════
    # 3. دورة حياة التنفيذ والفحص القبلي (can_run & run)
    # ═════════════════════════════════════════════════════════════════════════

    async def can_run(self) -> Tuple[bool, str]:
        """
        فحص قبلي فائق السرعة في الذاكرة الحية (0-Network Pre-flight):
        - هل المهمة مفعلة في الإعدادات؟
        - هل الاتصال نشط والذاكرة متوفرة؟
        - هل المهمة اليومية الرسمية 4100009 متممة مسبقاً اليوم؟
        - هل ورشة الحدادة مشغولة حالياً بعملية تصنيع نشطة لم تكتمل بعد؟
        """
        if not self.config.get("enabled", False):
            return False, "المهمة معطلة في الإعدادات"

        if not self.conn or not getattr(self.conn, "is_connected", False):
            return False, "لا يوجد اتصال نشط بالبوابة"

        if not self.init_data:
            return False, "بيانات الذاكرة الحية غير متوفرة"

        # 1. فحص إنجاز المهمة اليومية مسبقاً (0-Network)
        if self._is_daily_quest_completed():
            return False, "Daily quest 4100009 already completed (0-Network)"

        # 2. فحص هل ورشة الحدادة مشغولة حالياً بعملية تصنيع نشطة (0-Network)
        queue_ctrl = self.get_ctrl("queueCtrl")
        eq_ctrl = self.get_ctrl("equipmentCtrl")
        now_ts = int(time.time())

        forge_q = queue_ctrl.get("1229") or queue_ctrl.get(1229) if isinstance(queue_ctrl, dict) else None
        fe_obj = eq_ctrl.get("fe") if isinstance(eq_ctrl, dict) else None

        is_busy = False
        rem_sec = 0
        if isinstance(forge_q, dict) and forge_q:
            st = int(forge_q.get("starttime", 0) or 0)
            tt = int(forge_q.get("totaltime", 0) or 0)
            if st > 0 and tt > 0 and (st + tt) > now_ts:
                is_busy = True
                rem_sec = max(1, (st + tt) - now_ts)

        if not is_busy and isinstance(fe_obj, dict) and fe_obj:
            fe_end = int(fe_obj.get("endTime", 0) or 0)
            if fe_end > now_ts:
                is_busy = True
                rem_sec = max(1, fe_end - now_ts)

        if is_busy:
            return False, f"Blacksmith is busy forging (0-Network) (remaining: {rem_sec}s)"

        return True, ""

    async def run(self) -> TaskResult:
        """
        تنفيذ دورة مهمة تصنيع العتاد:
          1. فحص النشاط اليومي مجدداً في الذاكرة (0-Network).
          2. فحص ورشة الحدادة:
             - إذا كان التصنيع نشطاً لم يكتمل بعد: تخطي فوري وآمن (0-Network).
             - إذا وُجدت قطعة مكتملة في fe أو طابور 1229: استلامها فوراً بـ CMD 1047 SubCMD 2
               مع isDirectGet="1"، ومزامنة الذاكرة وإتمام النشاط بـ 0 استهلاك موارد.
          3. إذا كانت الورشة فارغة: التحقق المسبق (0-Network Pre-flight):
             - شغور طابور الحدادة 1229 وكائن fe.
             - حالة ورشة الحدادة ومستواها وعدم ترقيتها (BID 115).
             - سعة حقيبة العتاد (< 200 لمنع خطأ 22012).
             - مستوى الأمير والقلعة وسقف الوصفات (منع خطأ 22006).
             - توفر المواد والصلب واختيار الوصفة والتدرج حتى Lv.1.
          4. إرسال أمر التصنيع وتحديث الذاكرة الحية محلياً (In-Memory State Sync).
        """
        # 1. صمام أمان مزدوج: التأكد من عدم إتمام المهمة اليومية مسبقاً (0-Network)
        if self._is_daily_quest_completed():
            return TaskResult.skip("Daily quest 4100009 already completed (0-Network)")

        eq_ctrl = self.get_ctrl("equipmentCtrl")
        queue_ctrl = self.get_ctrl("queueCtrl")
        now_ts = int(time.time())

        forge_q = None
        if isinstance(queue_ctrl, dict):
            forge_q = queue_ctrl.get("1229") or queue_ctrl.get(1229)

        fe_obj = eq_ctrl.get("fe") if isinstance(eq_ctrl, dict) else None

        # 2. فحص هل عملية التصنيع لا تزال جارية حالياً (0-Network)
        is_forging_active = False
        remaining_seconds = 0

        if isinstance(forge_q, dict) and forge_q:
            start_t = int(forge_q.get("starttime", 0) or 0)
            total_t = int(forge_q.get("totaltime", 0) or 0)
            if start_t > 0 and total_t > 0:
                finish_t = start_t + total_t
                if finish_t > now_ts:
                    is_forging_active = True
                    remaining_seconds = max(1, finish_t - now_ts)

        if not is_forging_active and isinstance(fe_obj, dict) and fe_obj:
            fe_end = int(fe_obj.get("endTime", 0) or 0)
            if fe_end > now_ts:
                is_forging_active = True
                remaining_seconds = max(1, fe_end - now_ts)

        if is_forging_active:
            q_data = forge_q.get("data", {}) if isinstance(forge_q, dict) and isinstance(forge_q.get("data"), dict) else {}
            fe_epid = int((q_data.get("epid") or (fe_obj.get("epid") if isinstance(fe_obj, dict) else 0) or 0))
            fe_eid = int((q_data.get("eid") or (fe_obj.get("eid") if isinstance(fe_obj, dict) else 0) or 0))
            msg = f"Blacksmith is busy forging (0-Network) (EPID: {fe_epid}, EID: {fe_eid}, remaining: {remaining_seconds}s)"
            self.log(f"⏳ ورشة الحدادة مشغولة بتصنيع عتاد حالياً (0-Network) (EPID: {fe_epid}, المتبقي: {remaining_seconds} ثانية)")
            return TaskResult.skip(msg)

        # 3. فحص وجود قطعة عتاد منتهية بانتظار الاستلام (في fe أو طابور 1229 المكتمل)
        has_finished_piece = False
        fe_epid = 0
        fe_eid = 0

        q_data = forge_q.get("data", {}) if isinstance(forge_q, dict) and isinstance(forge_q.get("data"), dict) else {}
        if isinstance(fe_obj, dict) and fe_obj:
            fe_epid = int(fe_obj.get("epid", 0) or 0)
            fe_eid = int(fe_obj.get("eid", 0) or 0)
            if fe_epid > 0:
                has_finished_piece = True

        if not has_finished_piece and isinstance(forge_q, dict) and forge_q:
            fe_epid = int(q_data.get("epid", 0) or 0)
            fe_eid = int(q_data.get("eid", 0) or 0)
            if fe_epid > 0:
                has_finished_piece = True

        if has_finished_piece:
            self.log(f"📥 اكتمل تصنيع العتاد في ورشة الحدادة بانتظار الاستلام (EPID: {fe_epid}, EID: {fe_eid}) — جاري الاستلام...")
            recv_res = await self.safe_query(
                CMD_EQUIPMENT_MODULE,
                REQ_GET_EQUIPMENT,
                {"epid": fe_epid, "isDirectGet": "1"},
                min_delay=0.8,
                max_delay=1.5,
            )

            if recv_res is None:
                return TaskResult.fail(f"انقطاع أو عدم استجابة السيرفر أثناء استلام العتاد (EPID: {fe_epid})")

            err_code = str(recv_res.get("err", "-1"))
            if err_code != "0":
                return TaskResult.fail(f"رفض السيرفر استلام العتاد (كود الخطأ: {err_code})")

            # مزامنة الذاكرة الحية محلياً فور الاستلام (0-Network)
            if isinstance(queue_ctrl, dict):
                queue_ctrl.pop("1229", None)
                queue_ctrl.pop(1229, None)

            if isinstance(eq_ctrl, dict):
                eq_ctrl.pop("fe", None)
                arr = eq_ctrl.setdefault("equipment_array", [])
                if isinstance(arr, list):
                    new_item = dict(fe_obj) if isinstance(fe_obj, dict) and fe_obj else dict(q_data)
                    new_item["wear"] = 0
                    new_item["endTime"] = 0
                    arr.append(new_item)

            everyday = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
            if isinstance(everyday, dict):
                ev_info = everyday.setdefault("eventInfo", {})
                if isinstance(ev_info, dict):
                    ev_info[DAILY_QUEST_FORGE_ID] = 1
                    ev_info[DAILY_QUEST_FORGE_TYPE] = 1

            quest_ctrl = self.get_ctrl("questCtrl")
            if isinstance(quest_ctrl, dict):
                pfl = quest_ctrl.setdefault("point_finish_list", [])
                if isinstance(pfl, list) and 4100009 not in pfl:
                    pfl.append(4100009)

            msg = f"✓ تم استلام قطعة العتاد المصنعة بنجاح (EPID: {fe_epid}, EID: {fe_eid}) وإتمام النشاط اليومي بـ 0 استهلاك موارد"
            self.log(msg)
            return TaskResult.ok(
                msg,
                data={"epid": fe_epid, "eid": fe_eid, "action": "claimed"},
            )

        # 4. الفحص المسبق قبل بدء تصنيع عتاد جديد (0-Network Pre-flight Validation)
        # أ) التحقق من شغور ورشة الحدادة وطابور 1229 وكائن fe
        if (isinstance(queue_ctrl, dict) and (queue_ctrl.get("1229") or queue_ctrl.get(1229))) or (isinstance(eq_ctrl, dict) and eq_ctrl.get("fe")):
            return TaskResult.skip("ورشة الحدادة لا تزال مشغولة بقطعة سابقة (0-Network)")

        # ب) التحقق من وجود ورشة الحدادة ومستواها وعدم ترقيتها حالياً (BID 115)
        blacksmith_lvl, bs_exists, bs_upgrading = self._get_blacksmith_info()
        if not bs_exists:
            return TaskResult.skip("ورشة الحدادة غير مبنية في القلعة (0-Network)")
        if bs_upgrading:
            return TaskResult.skip("ورشة الحدادة قيد الترقية حالياً (0-Network)")
        if blacksmith_lvl < 1:
            return TaskResult.skip("مستوى ورشة الحدادة غير كافٍ (0-Network)")

        # ج) التحقق من سعة حقيبة العتاد (الحد الأقصى: 200 قطعة لمنع خطأ 22012)
        eq_array = eq_ctrl.get("equipment_array", []) if isinstance(eq_ctrl, dict) else []
        if len(eq_array) >= 200:
            return TaskResult.skip("حقيبة العتاد ممتلئة بالكامل (200/200) (0-Network)")

        # د) التحقق من مستوى الأمير والقلعة لتحديد سقف الوصفات المسموحة (منع خطأ 22006)
        lord_lvl = self.lord_level or self.castle_level
        castle_lvl = self.castle_level
        max_allowed_lvl = max(1, min(blacksmith_lvl, lord_lvl, castle_lvl))

        # 5. تحديد الصنف المطلوب تصنيعه
        user_cat = str(self.config.get("category", "weapon")).lower().strip()
        cat_prefix = CATEGORY_PREFIX_MAP.get(user_cat, 61)
        cat_name = CATEGORY_NAMES.get(user_cat, "السلاح (Weapon)")
        pair_a, pair_b = CATEGORY_MATERIAL_PAIRS.get(cat_prefix, (2006, 2003))

        self.log(
            f"⚒️ فحص وصفات {cat_name} — مستوى الحدادة: Lv.{blacksmith_lvl}، "
            f"مستوى الأمير: Lv.{lord_lvl}، القلعة: Lv.{castle_lvl} (الحد الأقصى المتاح: Lv.{max_allowed_lvl})"
        )

        # 6. البحث عن أعلى وصفة ممكنة تنازلياً من Lv.110 وحتى Lv.1
        selected_recipe: Optional[Dict[str, Any]] = None

        for lvl in EQUIPMENT_LEVELS_DESC:
            # أ) شرط المستوى
            if lvl > max_allowed_lvl:
                continue

            specs = LEVEL_SPECS.get(lvl, {"steel": 100, "costTime": 360})
            need_steel = specs["steel"]
            cost_time = specs["costTime"]
            recipe_eid = cat_prefix * 100000 + lvl * 100 + 1

            # ب) شرط القطعة الأساسية السابقة للمستويات >= 5
            base_epid = 0
            if lvl >= 5:
                min_req_prev = max(1, lvl - 5)
                max_req_prev = lvl
                base_epid = self._find_base_item_in_bag(cat_prefix, min_req_prev, max_req_prev)
                if not base_epid:
                    # لا توجد قطعة أساسية سابقة غير ملبوسة بالحقيبة — التدرج للمستوى الأدنى
                    continue

            # ج) شرط المواد بالحقيبة
            chosen_mats = self._select_materials_for_recipe(pair_a, pair_b, lvl)
            if not chosen_mats:
                # مواد غير كافية بالحقيبة — التدرج للمستوى الأدنى
                continue

            # د) شرط الصلب (مع محاولة توفير العجز من الصناديق)
            steel_ok = await self._ensure_steel_balance(need_steel)
            if not steel_ok:
                # تعذر توفير رصيد الصلب المطلوب — التدرج للمستوى الأدنى
                continue

            # تحققت كافة الشروط لهذه الوصفة!
            selected_recipe = {
                "eid": recipe_eid,
                "level": lvl,
                "materials": chosen_mats,
                "base_epid": base_epid,
                "need_steel": need_steel,
                "cost_time": cost_time,
            }
            break

        if not selected_recipe:
            return TaskResult.skip("لا توجد وصفة عتاد قابلة للتصنيع حالياً بالموارد المتاحة")

        # 5. إرسال أمر بدء التصنيع الرسمي (CMD 1047 / SubCMD 1)
        recipe_eid = selected_recipe["eid"]
        recipe_lvl = selected_recipe["level"]
        chosen_mats = selected_recipe["materials"]
        base_epid = selected_recipe["base_epid"]
        need_steel = selected_recipe["need_steel"]
        cost_time = selected_recipe["cost_time"]

        payload: Dict[str, Any] = {
            "eid": recipe_eid,
            "materialArray": chosen_mats,
        }
        # لا يتم إرسال mainMaterialID إلا للمستويات >= 5 التي تتطلب قطعة أساسية حقيقية
        if base_epid and int(base_epid) > 0:
            payload["mainMaterialID"] = int(base_epid)

        self.log(
            f"🚀 إرسال أمر تصنيع العتاد الرسمي: {cat_name} Lv.{recipe_lvl} "
            f"(EID: {recipe_eid}, BaseEPID: {base_epid}, Materials: {chosen_mats}, Steel: {need_steel:,})"
        )

        res = await self.safe_query(
            CMD_EQUIPMENT_MODULE,
            REQ_FORGE_EQUIPMENT,
            payload,
            min_delay=0.8,
            max_delay=1.5,
        )

        if res is None:
            return TaskResult.fail(f"انقطاع أو عدم استجابة السيرفر أثناء طلب تصنيع العتاد (EID: {recipe_eid})")

        err_code = str(res.get("err", "-1"))
        if err_code != "0":
            return TaskResult.fail(f"رفض السيرفر طلب تصنيع العتاد (كود الخطأ: {err_code})")

        # ═════════════════════════════════════════════════════════════════════
        # 6. تحديث كائنات الذاكرة الحية محلياً فور النجاح (In-Memory State Sync)
        # ═════════════════════════════════════════════════════════════════════
        now_ts = int(time.time())

        # أ) خصم المواد المستهلكة من backpackCtrl و itemCtrl
        backpack = self.get_ctrl("backpackCtrl") or self.get_ctrl("itemCtrl") or self.get_ctrl("bagCtrl")
        if isinstance(backpack, dict):
            for m_id in chosen_mats:
                str_m = str(m_id)
                if str_m in backpack and isinstance(backpack[str_m], dict):
                    curr_c = int(backpack[str_m].get("count", backpack[str_m].get("num", 0)) or 0)
                    if "count" in backpack[str_m]:
                        backpack[str_m]["count"] = max(0, curr_c - 1)
                    if "num" in backpack[str_m]:
                        backpack[str_m]["num"] = max(0, curr_c - 1)
                elif str_m in backpack and isinstance(backpack[str_m], (int, float)):
                    backpack[str_m] = max(0, int(backpack[str_m]) - 1)

        # ب) خصم الصلب من cityCtrl.reslist
        city = self.get_ctrl("cityCtrl")
        if isinstance(city, dict):
            reslist = city.get("reslist") or city.get("resList")
            if isinstance(reslist, dict) and RES_STEEL_ID in reslist:
                old_steel = int(float(reslist[RES_STEEL_ID]))
                reslist[RES_STEEL_ID] = max(0, old_steel - need_steel)

        # ج) حذف القطعة الأساسية المستهلكة من equipment_array إن وُجدت
        if isinstance(eq_ctrl, dict):
            arr = eq_ctrl.setdefault("equipment_array", [])
            if isinstance(arr, list):
                if base_epid > 0:
                    eq_ctrl["equipment_array"] = [
                        it for it in arr if int(it.get("epid", 0) or 0) != base_epid
                    ]
                    arr = eq_ctrl["equipment_array"]

                # د) تسجيل طابور التصنيع وكائن fe في الذاكرة الحية تماماً كما تفعل اللعبة الرسمية
                server_data = res.get("data", {}) if isinstance(res, dict) else {}
                equip_prop = server_data.get("equipment", {}) if isinstance(server_data, dict) else {}
                actual_cost_time = int(server_data.get("costTime", cost_time)) if isinstance(server_data, dict) else cost_time
                new_epid = int(equip_prop.get("epid", now_ts % 10000000)) if isinstance(equip_prop, dict) else (now_ts % 10000000)

                forging_data = {
                    "epid": new_epid,
                    "eid": recipe_eid,
                    "materialArray": chosen_mats,
                    "costTime": actual_cost_time,
                    "qly": int(equip_prop.get("qly", 1)) if isinstance(equip_prop, dict) else 1,
                    "isCle": 1,
                }

                # تسجيل طابور الحدادة 1229
                queue_ctrl = self.get_ctrl("queueCtrl")
                if isinstance(queue_ctrl, dict):
                    queue_ctrl["1229"] = {
                        "qtype": "1229",
                        "starttime": now_ts,
                        "totaltime": actual_cost_time,
                        "ottime": actual_cost_time,
                        "data": forging_data,
                    }

                # تسجيل كائن fe داخل equipmentCtrl
                eq_ctrl["fe"] = forging_data

        # هـ) تحديث عداد النشاط اليومي لمنع أي طلب لاحق في نفس اليوم (0-Network)
        everyday = self.get_ctrl("everydayTaskCtrl") or self.get_ctrl("everydayTask")
        if isinstance(everyday, dict):
            ev_info = everyday.setdefault("eventInfo", {})
            if isinstance(ev_info, dict):
                ev_info[DAILY_QUEST_FORGE_ID] = 1
                ev_info[DAILY_QUEST_FORGE_TYPE] = 1

        quest_ctrl = self.get_ctrl("questCtrl")
        if isinstance(quest_ctrl, dict):
            pfl = quest_ctrl.setdefault("point_finish_list", [])
            if isinstance(pfl, list) and 4100009 not in pfl:
                pfl.append(4100009)

        success_msg = (
            f"✓ بدأ تصنيع العتاد بنجاح: {cat_name} Lv.{recipe_lvl} "
            f"(EID: {recipe_eid}, المدة: {cost_time}ثانية) وإتمام النشاط اليومي"
        )
        self.log(success_msg)

        return TaskResult.ok(
            success_msg,
            data={
                "eid": recipe_eid,
                "category": user_cat,
                "level": recipe_lvl,
                "mainMaterialID": base_epid,
                "materialArray": chosen_mats,
                "needSteel": need_steel,
                "costTime": cost_time,
            },
        )
